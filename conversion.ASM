; 16-bit DOS COM program
org 100h

section .text
start:
    jmp main

; Data section
cadena  db   "00000$"
cadres  db   "000000$"
bienv   db   10,13,"Bienvenido al sistema de conversion de numeros$"
limite  db   10,13,"(Limite de 4 digitos)$"
opc1    db   10,13,"1)Pasar de hexadecimal a octal$"
opc2    db   10,13,"2)Pasar de octal a hexadecimal$"
opc3    db   10,13,"3)Salir del programa$"
selOpc  db   10,13,"Elija la opcion deseada:$"
selNum  db   10,13,"Ingrese el numero que desea convertir:$"
res     db   10,13,"El resultado es:$"
error   db   10,13,"Hubo un error de ingreso$"
separ   db   10,13,"------------------------$"

char    db 0
num     dw 0
ocho    dw 8
hexa    dw 16
largo   dw 0

main:
    lea dx, [bienv]
    mov ah, 9h
    int 21h

menu:
    
    lea dx, [opc1]
    mov ah, 9h
    int 21h
    
    lea dx, [opc2]
    mov ah, 9h
    int 21h

    lea dx, [opc3]
    mov ah, 9h
    int 21h

    lea dx, [separ]
    mov ah, 9h
    int 21h
    
    lea dx, [selOpc]
    mov ah, 9h
    int 21h
    
    mov ah, 1h
    int 21h
    mov [char], al
    
    cmp byte[char], '1'
    je hexAOct

    cmp byte[char], '2'
    je octAHex

    cmp byte[char], '3'
    je finProg
    
    jmp errorIng
    
hexAOct:
    lea dx, [limite]
    mov ah, 9h
    int 21h
    lea dx, [selNum]
    mov ah, 9h
    int 21h
    
    mov si, 0
    jmp ingNumHex
    
octAHex:
    lea dx, [limite]
    mov ah, 9h
    int 21h
    lea dx, [selNum]
    mov ah, 9h
    int 21h
    
    mov si, 0
    jmp ingNumOct
    
ingNumHex:
    
    mov ah, 1h
    int 21h
    
    cmp al, 13
    je finIngDec
    
    cmp al, 8
    je borrarDec
    
    cmp al, 32
    je errorIng

    cmp al, '0'
    jb errorIng
    
    cmp al, '9'
    jbe agrCharHex

    cmp al, 'A'
    jb errorIng

    cmp al, 'F'
    jbe agrCharHex

    cmp al, 'a'
    jb errorIng

    cmp al, 'f'
    jbe pasAMin

    jmp errorIng
    
agrCharHex:

    mov [cadena+si], al
    add word[largo], 1
    inc si
    
    cmp si, 5
    je errorIng
    
    jmp ingNumHex
    
finIngDec:
    mov byte[cadena+si], '$'
    jmp hexADec

borrarDec:
    cmp si, 0
    je errorIng
    sub word[largo], 1
    dec si
    jmp ingNumHex

pasAMin:
    sub al, 32
    jmp agrCharHex
    
ingNumOct:
    
    mov ah, 1h
    int 21h
    
    cmp al, 13
    je finIngOct
    
    cmp al, 8
    je borrarOct
    
    cmp al, '0'
    jb errorIng
    
    cmp al, '7'
    jg errorIng
    
    cmp al, 32
    je errorIng
    
    mov [cadena+si], al
    add word[largo], 1
    inc si
    
    cmp si, 5
    je errorIng
    
    jmp ingNumOct
    
finIngOct:
    mov byte[cadena+si], '$'
    jmp octADec

borrarOct:
    cmp si, 0
    je errorIng
    dec si
    sub word[largo], 1
    jmp ingNumOct
    
hexADec:
    mov di, 0
pasHexADec:
    mov si, [largo]
    
    dec si
    sub si, di

    cmp byte[cadena+di], '$'
    je convAOct

    cmp byte[cadena+di], '9'
    jg restHex
    
    mov ah, 0
    mov al, byte[cadena+di]
    sub ax, 30h
    jmp multHex

restHex:

    mov ah, 0
    mov al, byte[cadena+di]
    sub ax, 37h
    
multHex:
    cmp si, 0
    je finMultHex
    
    mul word[hexa]
    dec si
    jmp multHex
    
finMultHex:
    add ax, [num]
    mov [num], ax

    inc di
    jmp pasHexADec
    
octADec:
    mov di, 0
pasOctADec:
    mov si, [largo]
    dec si
    sub si, di
    
    cmp byte[cadena+di], '$'
    je convAHex
    
    mov ah, 0
    mov al, byte[cadena+di]
    sub ax, 30h
    
multOct:
    cmp si, 0
    je finMultOct
    
    mul word[ocho]
    dec si
    jmp multOct
    
finMultOct:
    add [num], ax
    inc di
    jmp pasOctADec
    
convAOct:
    mov dx, 0
    mov ax, [num]
    mov si, 5
    
divAOct:
    div word[ocho]
    add dx, 30h
    mov [cadres+si], dl
    dec si
    
    cmp ax, 0
    je mostrar
    
    mov dx, 0
    jmp divAOct
    
convAHex:
    mov dx, 0
    mov ax, [num]
    mov si, 5
    
divADec:
    div word[hexa]

    cmp dx, 9
    jg sumHex

    add dx, 30h
    jmp ingCharHex

sumHex:
    add dx, 37h

ingCharHex:

    mov [cadres+si], dl
    dec si
    
    cmp ax, 0
    je mostrar
    
    mov dx, 0
    jmp divADec

mostrar:
    lea dx, [res]
    mov ah, 9h
    int 21h

    lea dx, [cadres]
    mov ah, 9h
    int 21h

    lea dx, [separ]
    mov ah, 9h
    int 21h

    mov si, 5
    mov word[num], 0
    mov word[largo], 0

vaciarRes:
    mov byte[cadres+si], '0'
    dec si

    cmp si, 0
    jge vaciarRes

    jmp menu
    
errorIng:
    lea dx, [error]
    mov ah, 9h
    int 21h

    lea dx, [separ]
    mov ah, 9h
    int 21h

    jmp menu
    
finProg:
    mov ah, 4ch
    int 21h
