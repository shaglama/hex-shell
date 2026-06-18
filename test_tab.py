import pty
import os
import time
import select

pid, fd = pty.fork()

if pid == 0:
    # Child process
    # set LD_LIBRARY_PATH
    os.environ["LD_LIBRARY_PATH"] = "/home/randy/Workspace/REPOS/aria-packages/packages/aria-display/shim:/home/randy/Workspace/REPOS/aria-packages/packages/aria-input/shim:/home/randy/Workspace/REPOS/aria-packages/packages/hex-shell/../aria-toml/shim:/home/randy/Workspace/REPOS/aria-packages/packages/hex-shell/../aria-fs/shim"
    os.execv("./hex_shell", ["./hex_shell"])
else:
    # Parent process
    time.sleep(1) # wait for shell to start
    
    # Read whatever is there
    while select.select([fd], [], [], 0.1)[0]:
        os.read(fd, 1024)
        
    # Send "cat test/test_t\t"
    os.write(fd, b"cat test/test_t\t")
    time.sleep(0.5)
    
    # Read response
    out = b""
    while select.select([fd], [], [], 0.5)[0]:
        out += os.read(fd, 1024)
        
    # Send Ctrl-C to exit
    os.write(fd, b"\x03")
    
    print("OUTPUT:", out.decode('utf-8', errors='ignore'))
