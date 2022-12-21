SYS_INIT_MODULE equ 0x80
SYS_EXIT equ 0x01
SYS_WRITE equ 0x04

section	.text
	global _start       ;must be declared for using gcc
	int 0x80
_start:                     ;tell linker entry point
    mov edx, lenInit ;message length
    mov ecx, msgInit ;message to write
    mov ebx, 1 ;file descriptor (stdout)
    mov eax, 4 ;system call number (sys_write)
    int 0x80 ;call kernel
    
    mov edx, len ;message length
    mov ecx, msg ;message to write
    mov ebx, 1 ;file descriptor (stdout)
    mov eax, 4 ;system call number (sys_write)
    int 0x80 ;call kernel
    call setNumbers;call label setNumber  
    mov edx, 2
    mov ecx, buf
    mov eax, 3
    mov ebx, 0
    int 0x80
	cmp byte [buf], "1"
	je addition
	cmp byte [buf], "2"
	je subtraction
	cmp byte [buf], "3"
	je multiplication
	cmp byte [buf], "4"
	je division
	cmp byte [buf], "5"
	je power
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel

setNumbers:
    mov eax, 20 ;set number one
    mov ebx, 4 ;set number two
    mov [num1], eax
    mov [num2], ebx
    ret


addition:
    mov esi, [num1] ;get number
    mov ecx, [num2] ;get number
    add esi, ecx
    mov eax, 1
    mul esi
    aam
    add eax, 3030h
    mov ebp, esp
    sub esp, 2
    mov [esp], byte ah
    mov [esp+1], byte al
    mov ecx, esp
    mov eax, SYS_WRITE
    mov edx, 2 
    mov ebx, 1
    int SYS_INIT_MODULE
    mov esp, ebp
    jmp _start
    
subtraction:
    mov esi, [num1] ;get number
    mov ecx, [num2] ;get number
    sub esi, ecx
    mov eax, 1
    mul esi
    aam
    add eax, 3030h
    mov ebp, esp
    sub esp, 2
    mov [esp], byte ah
    mov [esp+1], byte al
    mov ecx, esp
    mov eax, SYS_WRITE
    mov edx, 2 
    mov ebx, 1
    int SYS_INIT_MODULE
    mov esp, ebp
    jmp _start 
    
multiplication:
    mov eax, [num1] ;get number
    mov ebx, [num2] ;get number
    mul ebx
    aam
    add eax, 3030h
    mov ebp, esp
    sub esp, 2
    mov [esp], byte ah
    mov [esp+1], byte al
    mov ecx, esp
    mov edx, 2
    mov ebx, 1
    mov eax, 4
    int 0x80
    jmp _start
    
division:
    mov eax, [num1] ;get number
    mov ebx, [num2] ;get number
    div ebx
    aam
    add eax, 3030h
    mov ebp, esp
    sub esp, 2
    mov [esp], byte ah
    mov [esp+1], byte al
    mov ecx, esp
    mov edx, 2
    mov ebx, 1
    mov eax, 4
    int 0x80
    jmp _start
power:
    mov esi, [num1] ;get number
    mov ecx, [num2] ;get number
    add esi, ecx
    dec ecx
    cmp ecx, 0
    jg power
    mov eax, 1
    mul esi
    aam
    add eax, 3030h
    mov ebp, esp
    sub esp, 2
    mov [esp], byte ah
    mov [esp+1], byte al
    mov ecx, esp
    mov eax, SYS_WRITE
    mov edx, 2
    mov ebx, 1
    int SYS_INIT_MODULE
    mov esp, ebp
    jmp _start

section .data

msgInit: db 13,10, 'Practica Calculadora, numeros quemados 20 y 4 -Diego Ramos'
    lenInit equ $ - msgInit

msg: db 13,10, 'Opciones 1: suma, 2: resta, 3: multiplicacion, 4: division, 5: potencia '

    len equ $ - msg


section .bss
    buf resb 11
    num1 resb 1 
    num2 resb 1




