/*
 * hex_test_writer.c — Test program that writes to all 6 hexstream FDs
 *
 * Writes labeled output to:
 *   FD 1 (stdout):  standard output
 *   FD 2 (stderr):  error messages
 *   FD 3 (stddbg):  debug/telemetry
 *   FD 5 (stddato): data output
 *
 * Reads from:
 *   FD 4 (stddati): data input (optional, non-blocking check)
 *
 * Build: gcc -O2 -o hex_test_writer hex_test_writer.c
 * Run:   ./hex_test_writer
 */

#include <unistd.h>
#include <string.h>
#include <stdio.h>

static void write_fd(int fd, const char* msg) {
    write(fd, msg, strlen(msg));
}

int main(void) {
    /* stdout (FD 1) */
    write_fd(1, "STDOUT: Hello from stdout line 1\n");
    write_fd(1, "STDOUT: Hello from stdout line 2\n");

    /* stderr (FD 2) */
    write_fd(2, "STDERR: Warning — example error message\n");
    write_fd(2, "STDERR: Another error line\n");

    /* stddbg (FD 3) — may fail if FD 3 not open */
    write_fd(3, "STDDBG: Debug telemetry tick=1 energy=0.42\n");
    write_fd(3, "STDDBG: Debug telemetry tick=2 energy=0.38\n");
    write_fd(3, "STDDBG: Debug telemetry tick=3 energy=0.41\n");

    /* stddato (FD 5) — may fail if FD 5 not open */
    write_fd(5, "STDDATO: Structured data output record=1\n");
    write_fd(5, "STDDATO: Structured data output record=2\n");

    /* stddati (FD 4) — just report if it's open */
    char buf[256];
    ssize_t n = read(4, buf, sizeof(buf) - 1);
    if (n > 0) {
        buf[n] = '\0';
        write_fd(1, "STDOUT: Received on stddati: ");
        write_fd(1, buf);
        write_fd(1, "\n");
    }

    return 0;
}
