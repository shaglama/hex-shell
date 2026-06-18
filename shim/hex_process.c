/*
 * hex_process.c — Process management shim for hex-shell
 *
 * Provides fork/pipe/dup2/exec/wait/poll/read primitives that Aria
 * can call via extern declarations. Designed for 6-pipe hexstream
 * process launching.
 *
 * Build: gcc -c -O2 -o hex_process.o hex_process.c
 *        ar rcs libhex_process.a hex_process.o
 */

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/wait.h>
#include <poll.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

/* Aria string ABI: {char* data, int64_t length} returned by value */
typedef struct {
    char*   data;
    int64_t length;
} AriaString;

/* ── Pipe creation ──────────────────────────────────────────────── */

/* Creates a pipe, returns encoded pair: read_fd * 65536 + write_fd
 * Returns -1 on error. */
int64_t hex_proc_pipe(void) {
    int fds[2];
    if (pipe(fds) < 0) return -1;
    return (int64_t)fds[0] * 65536 + (int64_t)fds[1];
}

int64_t hex_proc_pipe_read_fd(int64_t encoded) {
    return encoded / 65536;
}

int64_t hex_proc_pipe_write_fd(int64_t encoded) {
    return encoded - (encoded / 65536) * 65536;
}

/* ── Fork ───────────────────────────────────────────────────────── */

int64_t hex_proc_fork(void) {
    return (int64_t)fork();
}

/* ── dup2 / close ───────────────────────────────────────────────── */

int64_t hex_proc_dup2(int64_t oldfd, int64_t newfd) {
    return (int64_t)dup2((int)oldfd, (int)newfd);
}

int32_t hex_proc_close(int64_t fd) {
    return (int32_t)close((int)fd);
}

int64_t hex_proc_open_file(const char* path, const char* mode) {
    int flags = 0;
    int m = 0644;
    if (strcmp(mode, "r") == 0) flags = O_RDONLY;
    else if (strcmp(mode, "w") == 0) flags = O_WRONLY | O_CREAT | O_TRUNC;
    else if (strcmp(mode, "a") == 0) flags = O_WRONLY | O_CREAT | O_APPEND;
    else return -1;
    return (int64_t)open(path, flags, m);
}

/* ── Exec /bin/sh -c cmd — never returns on success ─────────────── */

int32_t hex_proc_exec_sh(const char* cmd) {
    execl("/bin/sh", "sh", "-c", cmd, (char*)NULL);
    _exit(127);
    return -1; /* unreachable */
}

/* _exit() for child process */
int32_t hex_proc_exit_now(int32_t code) {
    _exit(code);
    return -1; /* unreachable */
}

/* ── Wait ───────────────────────────────────────────────────────── */

/* Blocking waitpid — returns exit code (0-255) or 128+sig */
int32_t hex_proc_waitpid(int64_t pid) {
    int status;
    pid_t ret = waitpid((pid_t)pid, &status, 0);
    if (ret < 0) return -1;
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return -1;
}

/* Non-blocking waitpid — returns -1 if still running, else exit code */
int32_t hex_proc_waitpid_nohang(int64_t pid) {
    int status;
    pid_t ret = waitpid((pid_t)pid, &status, WNOHANG);
    if (ret == 0) return -1; /* still running */
    if (ret < 0) return -2; /* error */
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
    return -3;
}

/* ── Non-blocking I/O ───────────────────────────────────────────── */

int32_t hex_proc_set_nonblock(int64_t fd) {
    int flags = fcntl((int)fd, F_GETFL, 0);
    if (flags < 0) return -1;
    return fcntl((int)fd, F_SETFL, flags | O_NONBLOCK);
}

/* ── Poll up to 4 FDs ──────────────────────────────────────────── */

/* Returns bitmask: bit0=fd0 ready, bit1=fd1, bit2=fd2, bit3=fd3
 * Pass -1 for unused fd slots. */
int64_t hex_proc_poll4(int64_t fd0, int64_t fd1, int64_t fd2, int64_t fd3,
                       int64_t timeout_ms) {
    struct pollfd pfds[4];
    int nfds = 0;
    int map[4] = {-1, -1, -1, -1};

    if (fd0 >= 0) { pfds[nfds].fd = (int)fd0; pfds[nfds].events = POLLIN; pfds[nfds].revents = 0; map[nfds] = 0; nfds++; }
    if (fd1 >= 0) { pfds[nfds].fd = (int)fd1; pfds[nfds].events = POLLIN; pfds[nfds].revents = 0; map[nfds] = 1; nfds++; }
    if (fd2 >= 0) { pfds[nfds].fd = (int)fd2; pfds[nfds].events = POLLIN; pfds[nfds].revents = 0; map[nfds] = 2; nfds++; }
    if (fd3 >= 0) { pfds[nfds].fd = (int)fd3; pfds[nfds].events = POLLIN; pfds[nfds].revents = 0; map[nfds] = 3; nfds++; }

    if (nfds == 0) return 0;

    int ret = poll(pfds, nfds, (int)timeout_ms);
    if (ret <= 0) return 0;

    int64_t mask = 0;
    for (int i = 0; i < nfds; i++) {
        if (pfds[i].revents & (POLLIN | POLLHUP | POLLERR)) {
            mask |= (1L << map[i]);
        }
    }
    return mask;
}

/* ── Read from FD ───────────────────────────────────────────────── */

/* Non-blocking read up to 8191 bytes from fd.
 * Returns AriaString by value. Empty string if nothing available or EOF.
 * Caller (Aria runtime) owns the strdup'd memory. */
AriaString hex_proc_read_available(int64_t fd) {
    static char buf[8192];
    AriaString result;
    ssize_t n = read((int)fd, buf, sizeof(buf) - 1);
    if (n <= 0) {
        result.data = "";
        result.length = 0;
        return result;
    }
    buf[n] = '\0';
    result.data = strdup(buf);
    result.length = n;
    return result;
}

/* ── Write to FD ────────────────────────────────────────────────── */

int32_t hex_proc_write_fd(int64_t fd, const char* data) {
    if (!data) return -1;
    size_t len = strlen(data);
    if (len == 0) return 0;
    ssize_t written = write((int)fd, data, len);
    return (int32_t)written;
}

/* ── Spawn: fork + dup2 + close + exec in one C call ────────────── */

/* Avoids Aria runtime deadlock in child process.
 * Parameters are the 6 pipe FDs to dup2 to FDs 0-5.
 * Returns child PID (>0) on success, -1 on fork error.
 * Also does parent-side cleanup: closes child-side FDs,
 * closes stdin/stddati write ends, sets read ends non-blocking. */
int64_t hex_proc_spawn(const char* cmd,
                       int64_t fd_stdin_r,  int64_t fd_stdin_w,
                       int64_t fd_stdout_r, int64_t fd_stdout_w,
                       int64_t fd_stderr_r, int64_t fd_stderr_w,
                       int64_t fd_stddbg_r, int64_t fd_stddbg_w,
                       int64_t fd_dati_r,   int64_t fd_dati_w,
                       int64_t fd_dato_r,   int64_t fd_dato_w) {
    pid_t pid = fork();
    if (pid < 0) return -1;

    if (pid == 0) {
        /* ── Child process ── */
        dup2((int)fd_stdin_r,  0);  /* stdin */
        dup2((int)fd_stdout_w, 1);  /* stdout */
        dup2((int)fd_stderr_w, 2);  /* stderr */
        dup2((int)fd_stddbg_w, 3);  /* stddbg */
        dup2((int)fd_dati_r,   4);  /* stddati */
        dup2((int)fd_dato_w,   5);  /* stddato */

        /* Close all FDs >= 6 (all original pipe FDs) */
        for (int fd = 6; fd < 256; fd++) close(fd);

        execl("/bin/sh", "sh", "-c", cmd, (char*)NULL);
        _exit(127);
    }

    /* ── Parent process ── */
    /* Close child-side pipe ends */
    close((int)fd_stdin_r);   /* child's stdin read */
    close((int)fd_stdout_w);  /* child's stdout write */
    close((int)fd_stderr_w);  /* child's stderr write */
    close((int)fd_stddbg_w);  /* child's stddbg write */
    close((int)fd_dati_r);    /* child's stddati read */
    close((int)fd_dato_w);    /* child's stddato write */

    /* Close stdin and stddati write ends (EOF to child) */
    close((int)fd_stdin_w);
    close((int)fd_dati_w);

    /* Set read ends non-blocking for polling */
    int flags;
    flags = fcntl((int)fd_stdout_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stdout_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_stderr_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stderr_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_stddbg_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stddbg_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_dato_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_dato_r, F_SETFL, flags | O_NONBLOCK);

    return (int64_t)pid;
}

/* ── Spawn 2-process pipeline: cmd1 | cmd2 ──────────────────────── */

int64_t hex_proc_spawn2(const char* cmd1, const char* cmd2,
                        int64_t fd_stdin_r,  int64_t fd_stdin_w,
                        int64_t fd_stdout_r, int64_t fd_stdout_w,
                        int64_t fd_stderr_r, int64_t fd_stderr_w,
                        int64_t fd_stddbg_r, int64_t fd_stddbg_w,
                        int64_t fd_dati_r,   int64_t fd_dati_w,
                        int64_t fd_dato_r,   int64_t fd_dato_w) {
    int p_out[2];
    int p_dat[2];
    pipe(p_out);
    pipe(p_dat);

    pid_t pid1 = fork();
    if (pid1 == 0) {
        dup2((int)fd_stdin_r, 0);
        dup2(p_out[1], 1);
        dup2((int)fd_stderr_w, 2);
        dup2((int)fd_stddbg_w, 3);
        dup2((int)fd_dati_r, 4);
        dup2(p_dat[1], 5);
        for (int fd = 6; fd < 256; fd++) close(fd);
        execl("/bin/sh", "sh", "-c", cmd1, (char*)NULL);
        _exit(127);
    }

    pid_t pid2 = fork();
    if (pid2 == 0) {
        dup2(p_out[0], 0);
        dup2((int)fd_stdout_w, 1);
        dup2((int)fd_stderr_w, 2);
        dup2((int)fd_stddbg_w, 3);
        dup2(p_dat[0], 4);
        dup2((int)fd_dato_w, 5);
        for (int fd = 6; fd < 256; fd++) close(fd);
        execl("/bin/sh", "sh", "-c", cmd2, (char*)NULL);
        _exit(127);
    }

    close(p_out[0]); close(p_out[1]);
    close(p_dat[0]); close(p_dat[1]);

    close((int)fd_stdin_r);
    close((int)fd_stdout_w);
    close((int)fd_stderr_w);
    close((int)fd_stddbg_w);
    close((int)fd_dati_r);
    close((int)fd_dato_w);
    close((int)fd_stdin_w);
    close((int)fd_dati_w);

    int flags;
    flags = fcntl((int)fd_stdout_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stdout_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_stderr_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stderr_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_stddbg_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_stddbg_r, F_SETFL, flags | O_NONBLOCK);
    flags = fcntl((int)fd_dato_r, F_GETFL, 0);
    if (flags >= 0) fcntl((int)fd_dato_r, F_SETFL, flags | O_NONBLOCK);

    return (int64_t)pid2;
}

