[BITS 16]
[ORG 0x0100]

section .data
    msgInput db '[>] digite o arquivo: $'
    msgError db 'Error loading program.$'

section .bss
    file_name resb 12
    input_buffer resb 13

section .text

global _start

_start:
    mov ah, 0x09
    mov dx, msgInput
    int 0x21

    mov ah, 0x0A
    mov dx, input_buffer
    int 0x21

    lea si, [input_buffer + 1]
    lea di, [file_name]
    xor cx, cx
    mov cl, 12
copyfile:
    lodsb
    stosb
    or al, al
    jz open_file
    loop copyfile

open_file:
    mov ah, 0x3D
    xor al, al
    mov dx, file_name
    int 0x21

    jc error
    xchg ax, bx

    mov ah, 0x3F
    mov cx, 512
    mov dx, 0x2000
    int 0x21

    jc error

    mov ah, 0x3E
    int 0x21

    jmp 0x2000

error:
    mov ah, 0x09
    mov dx, msgError
    int 0x21
    jmp $

times 510-($-$$) db 0
dw 0xAA55
