// Temporary alias for nitpick_ prefixed builtins -> npk_ prefixed C++ functions.

extern void npk_args_init(int argc, char** argv);
extern void npk_gc_safepoint();
extern void npk_panic_overflow();

extern "C" {

void nitpick_args_init(int argc, char** argv) {
    // Stub
}

void nitpick_gc_safepoint() {
    // Stub
}

void nitpick_panic_overflow() {
    // Stub
}

}
