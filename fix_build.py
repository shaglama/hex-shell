import re

with open('build.sh', 'r') as f:
    content = f.read()

content = content.replace('DISPLAY_SHIM="/home/randy/Workspace/REPOS/aria-packages/packages/aria-display/shim"\nINPUT_SHIM="/home/randy/Workspace/REPOS/aria-packages/packages/aria-input/shim"\nHEX_SHIM="$SCRIPT_DIR/shim"', 'DISPLAY_SHIM="/home/randy/Workspace/REPOS/aria-packages/packages/aria-display/shim"\nINPUT_SHIM="/home/randy/Workspace/REPOS/aria-packages/packages/aria-input/shim"\nHEX_SHIM="$SCRIPT_DIR/shim"\nPANE_SHIM="$SCRIPT_DIR/../aria-pane/shim"')

content = content.replace('''        echo "  Compiling hex_pane shim..."
        gcc -c -O2 -o "$HEX_SHIM/hex_pane.o" "$HEX_SHIM/hex_pane.c"
        ar rcs "$HEX_SHIM/libhex_pane.a" "$HEX_SHIM/hex_pane.o"''', '''        echo "  Compiling aria_pane shim..."
        gcc -c -O2 -o "$PANE_SHIM/pane.o" "$PANE_SHIM/pane.c"
        ar rcs "$PANE_SHIM/libhex_pane.a" "$PANE_SHIM/pane.o"''')

content = content.replace('-L "$HEX_SHIM" -lhex_pane', '-L "$PANE_SHIM" -lhex_pane')

with open('build.sh', 'w') as f:
    f.write(content)

with open('aria-package.toml', 'r') as f:
    toml = f.read()

toml = toml.replace('[dependencies]\naria-libc = ">=0.2.6"', '[dependencies]\naria-libc = ">=0.2.6"\naria-readline = ">=0.1.0"\naria-pane = ">=0.1.0"')

with open('aria-package.toml', 'w') as f:
    f.write(toml)

