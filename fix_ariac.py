import re
with open('build.sh', 'r') as f:
    content = f.read()

content = content.replace('"$ARIAC" src/hex_shell.aria -o hex_shell \\', '"$ARIAC" src/hex_shell.aria -o hex_shell -I "$SCRIPT_DIR/../aria-readline/src" -I "$SCRIPT_DIR/../aria-pane/src" \\')

with open('build.sh', 'w') as f:
    f.write(content)
