.global _start

_start:
    adr x0, msg
    bl  my_strlen

    mov x8, #93
    svc #0

.global my_strlen
my_strlen:
    mov x1, #0

loop:
    ldrb w2, [x0, x1]
    cbz  w2, done
    add  x1, x1, #1
    b    loop

done:
    mov x0, x1
    ret

.section .rodata
msg:
    .ascii "Lets test strlen on ARM\0"
