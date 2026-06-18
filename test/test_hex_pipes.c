/*
 * test_hex_pipes.c — Test hex_process shim pipe/fork/exec/drain cycle
 */
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

/* Import shim functions */
extern int64_t hex_proc_pipe(void);
extern int64_t hex_proc_pipe_read_fd(int64_t encoded);
extern int64_t hex_proc_pipe_write_fd(int64_t encoded);
extern int64_t hex_proc_fork(void);
extern int64_t hex_proc_dup2(int64_t oldfd, int64_t newfd);
extern int32_t hex_proc_close(int64_t fd);
extern int32_t hex_proc_exec_sh(const char* cmd);
extern int32_t hex_proc_exit_now(int32_t code);
extern int32_t hex_proc_waitpid_nohang(int64_t pid);
extern int32_t hex_proc_set_nonblock(int64_t fd);
extern int64_t hex_proc_poll4(int64_t fd0, int64_t fd1, int64_t fd2, int64_t fd3, int64_t timeout_ms);

typedef struct { char* data; int64_t length; } AriaString;
extern AriaString hex_proc_read_available(int64_t fd);

int main(void) {
    printf("Creating 6 pipes...\n");
    int64_t p[6];
    int64_t pr[6], pw[6]; /* read and write ends */
    for (int i = 0; i < 6; i++) {
        p[i] = hex_proc_pipe();
        if (p[i] < 0) { printf("FAIL: pipe %d\n", i); return 1; }
        pr[i] = hex_proc_pipe_read_fd(p[i]);
        pw[i] = hex_proc_pipe_write_fd(p[i]);
        printf("  pipe%d: read=%ld write=%ld\n", i, pr[i], pw[i]);
    }

    printf("Forking...\n");
    int64_t pid = hex_proc_fork();
    printf("  fork returned: %ld\n", pid);

    if (pid == 0) {
        /* Child */
        hex_proc_dup2(pr[0], 0);  /* stdin */
        hex_proc_dup2(pw[1], 1);  /* stdout */
        hex_proc_dup2(pw[2], 2);  /* stderr */
        hex_proc_dup2(pw[3], 3);  /* stddbg */
        hex_proc_dup2(pr[4], 4);  /* stddati */
        hex_proc_dup2(pw[5], 5);  /* stddato */

        /* Close all FDs >= 6 */
        for (int fd = 6; fd < 64; fd++) close(fd);

        hex_proc_exec_sh("echo hello world");
        /* never reached */
    }

    /* Parent: close child-side ends */
    hex_proc_close(pr[0]);  /* child stdin read */
    hex_proc_close(pw[1]);  /* child stdout write */
    hex_proc_close(pw[2]);  /* child stderr write */
    hex_proc_close(pw[3]);  /* child stddbg write */
    hex_proc_close(pr[4]);  /* child stddati read */
    hex_proc_close(pw[5]);  /* child stddato write */

    /* Close stdin/stddati write (send EOF to child) */
    hex_proc_close(pw[0]);
    hex_proc_close(pw[4]);

    /* Set read ends non-blocking */
    hex_proc_set_nonblock(pr[1]);
    hex_proc_set_nonblock(pr[2]);
    hex_proc_set_nonblock(pr[3]);
    hex_proc_set_nonblock(pr[5]);

    printf("Parent draining...\n");
    int done = 0;
    int loops = 0;
    while (!done && loops < 100) {
        int64_t ready = hex_proc_poll4(pr[1], pr[2], pr[3], pr[5], 50);
        if (ready > 0) {
            printf("  poll ready=%ld\n", ready);
            if (ready & 1) {
                AriaString s = hex_proc_read_available(pr[1]);
                if (s.length > 0) printf("  STDOUT: %.*s", (int)s.length, s.data);
            }
            if (ready & 2) {
                AriaString s = hex_proc_read_available(pr[2]);
                if (s.length > 0) printf("  STDERR: %.*s", (int)s.length, s.data);
            }
            if (ready & 4) {
                AriaString s = hex_proc_read_available(pr[3]);
                if (s.length > 0) printf("  STDDBG: %.*s", (int)s.length, s.data);
            }
            if (ready & 8) {
                AriaString s = hex_proc_read_available(pr[5]);
                if (s.length > 0) printf("  STDDATO: %.*s", (int)s.length, s.data);
            }
        }
        int32_t ws = hex_proc_waitpid_nohang(pid);
        printf("  loop=%d waitpid=%d\n", loops, ws);
        if (ws >= 0) done = 1;
        loops++;
    }

    hex_proc_close(pr[1]);
    hex_proc_close(pr[2]);
    hex_proc_close(pr[3]);
    hex_proc_close(pr[5]);

    printf("Done! loops=%d\n", loops);
    return 0;
}
