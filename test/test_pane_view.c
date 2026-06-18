/* test_pane_view.c — Quick test for hex_pane rendering */
#include <stdio.h>
#include <stdint.h>

/* hex_pane API */
extern int32_t hex_pane_init(void);
extern int32_t hex_pane_set_content(int32_t pane, const char* text);
extern int32_t hex_pane_draw(void);
extern int32_t hex_pane_enter(void);
extern int32_t hex_pane_leave(void);
extern int32_t hex_pane_wait_key(void);

int main(void) {
    hex_pane_init();

    hex_pane_set_content(0, "Hello from stdout!\nThis is line 2\nLine 3 of stdout output\n");
    hex_pane_set_content(1, "Data output stream\nstddato line 2\n");
    hex_pane_set_content(2, "Error: something went wrong\nWarning: check your input\n");
    hex_pane_set_content(3, "DEBUG: entering function foo()\nDEBUG: x = 42\nDEBUG: returning OK\n");

    hex_pane_enter();
    hex_pane_draw();
    hex_pane_wait_key();
    hex_pane_leave();

    printf("Pane view test complete.\n");
    return 0;
}
