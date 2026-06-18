import re

with open('src/hex_shell.aria', 'r') as f:
    content = f.read()

# Add use statements
if 'use "aria-readline".*;' not in content:
    content = content.replace('// ═══════════════════════════════════════════════════════════════════════\n// Extern declarations', 'use "aria-readline".*;\nuse "aria-pane".*;\n\n// ═══════════════════════════════════════════════════════════════════════\n// Extern declarations')

# Remove hex_pane extern block
content = re.sub(r'extern "hex_pane" \{.*?\}\n', '', content, flags=re.DOTALL)

# Remove g_history and g_hist_count
content = re.sub(r'string:g_history = "";\nint32:g_hist_count = 0i32;\n', '', content)

# Remove Control character builders
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// Control character builders.*?func:make_esc = string\(\) \{ pass\(string_from_char\(@cast<int8>\(27i32\)\)\); \};\n', '', content, flags=re.DOTALL)

# Remove I/O helpers write_stdout and read_line_fp (but wait, hex-shell might need them, I'll rely on aria-readline exporting them)
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// I/O helpers.*?func:read_line_fp = string\(int64:fp\) \{.*?pass\(line\);\n\};\n', '', content, flags=re.DOTALL)

# Remove Environment read_env_var, get_home, get_user
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// Environment.*?func:get_user = string\(\) \{.*?pass\(user\);\n\};\n', '', content, flags=re.DOTALL)

# Remove Edit buffer helpers
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// Edit buffer helpers.*?func:find_word_start = int64\(string:buf, int64:cursor\) \{.*?pass\(pos\);\n\};\n', '', content, flags=re.DOTALL)

# Remove History management
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// History management.*?func:hist_save = int32\(\) \{.*?pass\(0i32\);\n\};\n', '', content, flags=re.DOTALL)

# Remove Line renderer
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// Line renderer.*?func:render_line_ed = int32\(string:prompt_str, string:buf, int64:cursor\) \{.*?pass\(0i32\);\n\};\n', '', content, flags=re.DOTALL)

# Remove Readline interactive line editor
content = re.sub(r'// ═══════════════════════════════════════════════════════════════════════\n// Readline — interactive line editor with history.*?func:read_line_edit = string\(string:prompt_str\) \{.*?pass\(result_line\);\n\};\n', '', content, flags=re.DOTALL)


with open('src/hex_shell.aria', 'w') as f:
    f.write(content)

