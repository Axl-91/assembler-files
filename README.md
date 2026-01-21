# Assembler Projects

## For conversion.ASM

You need to have dosbox and nasm installed:
``` bash
sudo dnf install dosbox
sudo dnf install nasm
```
Build and run
``` bash
# Build
nasm -f bin conversion.asm -o conversion.com

# Run
dosbox

# Inside DOSBox:
mount c .
c:
conversion.com
```
