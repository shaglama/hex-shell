#!/usr/bin/env bash
# build.sh — Build hex-shell
#
# Usage:
#   ./build.sh          Build the shell binary
#   ./build.sh test     Build and run tests
#   ./build.sh clean    Remove build artifacts
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${NITPICK_WORKSPACE:-/home/randy/Workspace/REPOS}"

# v0.35.7: use npkc (nitpickc is kept as a build-time alias via CMake POST_BUILD)
ARIAC="$WORKSPACE/nitpick/build/npkc"
LIBC_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-libc/shim"
PROCESS_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-process/shim"
DISPLAY_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-display/shim"
INPUT_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-input/shim"
HEX_SHIM="$SCRIPT_DIR/shim"
ENV_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-env/shim"
TOML_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-toml/shim"
FS_SHIM="$WORKSPACE/nitpick-packages/packages/nitpick-fs/shim"

cd "$SCRIPT_DIR"

case "${1:-build}" in
    build)
        echo "Building hex-shell..."
        # Compile C shims
        echo "  Compiling args_alias shim..."
        g++ -c -O2 -o "$HEX_SHIM/args_alias.o" "$HEX_SHIM/args_alias.cpp"
        ar rcs "$HEX_SHIM/libargs_alias.a" "$HEX_SHIM/args_alias.o"
        echo "  Compiling nitpick_env shim..."
        gcc -c -O2 -o "$ENV_SHIM/nitpick_env_shim.o" "$ENV_SHIM/nitpick_env_shim.c"
        ar rcs "$ENV_SHIM/libnitpick_env_shim.a" "$ENV_SHIM/nitpick_env_shim.o"
        echo "  Compiling nitpick_fs shim..."
        gcc -c -O2 -o "$FS_SHIM/nitpick_fs_shim.o" "$FS_SHIM/nitpick_fs_shim.c"
        ar rcs "$FS_SHIM/libnitpick_fs_shim.a" "$FS_SHIM/nitpick_fs_shim.o"
        ar rcs "$HEX_SHIM/libaria_readline.a" "$SCRIPT_DIR/aria-readline.o"
        # Build Nitpick binary
        "$ARIAC" src/hex_shell.npk -o hex_shell -I "$WORKSPACE/nitpick-packages/packages/nitpick-env/src" -I "$WORKSPACE/nitpick-packages/packages/nitpick-toml/src" \
            -L "$DISPLAY_SHIM" -lnitpick_display_shim \
            -L "$INPUT_SHIM" -lnitpick_input \
            -L "$ENV_SHIM" -lnitpick_env_shim \
            -L "$TOML_SHIM" -lnitpick_toml_shim \
            -L "$FS_SHIM" -lnitpick_fs_shim \
            -L "$HEX_SHIM" -largs_alias \
            -L "$HEX_SHIM" -lhex_pane \
            -L "$HEX_SHIM" -lhex_process \
            -L "$HEX_SHIM" -laria_readline \
            -L "$WORKSPACE/nitpick/build" -lnitpick_runtime
        echo "Built: hex_shell"
        echo "Run with: LD_LIBRARY_PATH=$DISPLAY_SHIM:$INPUT_SHIM:$TOML_SHIM:$PROCESS_SHIM ./hex_shell"
        ;;
    test)
        echo "Building tests..."
        g++ -c -O2 -o "$HEX_SHIM/args_alias.o" "$HEX_SHIM/args_alias.cpp"
        ar rcs "$HEX_SHIM/libargs_alias.a" "$HEX_SHIM/args_alias.o"
        "$ARIAC" test/test_tokenizer.npk -o test_tokenizer \
            -L "$HEX_SHIM" -largs_alias \
            -L "$PROCESS_SHIM" -lnitpick_process \
            -I "$WORKSPACE/nitpick-packages/packages/nitpick-process/src" \
            -L "$WORKSPACE/nitpick/build_tmp" -lnitpick_runtime
        echo "Running tests..."
        ./test_tokenizer
        ;;
    hex-test)
        echo "Building hex_test_writer..."
        gcc -O2 -o test/hex_test_writer test/hex_test_writer.c
        echo "Built: test/hex_test_writer"
        ;;
    clean)
        rm -f hex_shell test_tokenizer
        echo "Cleaned."
        ;;
    *)
        echo "Usage: $0 [build|test|clean]"
        exit 1
        ;;
esac
