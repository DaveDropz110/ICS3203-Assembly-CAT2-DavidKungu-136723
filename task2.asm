section .data
    prompt db "Enter 5 integers (space-separated): ", 0
    result_msg db "Reversed array: ", 0
    space db " ", 0
    newli,/ne db 10, 0

section .bss
    array resd 5             ; Reserve 20 bytes (5 integers * 4 bytes each)
    num resb 4

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 35
    int 0x80

    ; Read 5 integers
    xor edi, edi            ; Array index counter
input_loop:
    cmp edi, 5              ; Check if we've read all 5 numbers
    je read_done
    
    ; Read a character
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 1
    int 0x80

    ; Skip spaces and newlines
    cmp byte [num], ' '
    je input_loop
    cmp byte [num], 10      ; newline
    je input_loop

    ; Convert and store number
    movzx eax, byte [num]
    sub eax, '0'            ; Convert ASCII to number
    mov [array + edi*4], eax ; Store in array
    inc edi
    jmp input_loop

read_done:
    ; Reverse the array
    mov esi, 0              ; Start index
    mov edi, 4              ; End index (5-1)

reverse_loop:
    cmp esi, edi
    jge print_results

    ; Swap elements
    mov eax, [array + esi*4]     ; Get first element
    mov ebx, [array + edi*4]     ; Get last element
    mov [array + esi*4], ebx     ; Swap them
    mov [array + edi*4], eax

    inc esi                      ; Move start index forward
    dec edi                      ; Move end index backward
    jmp reverse_loop

print_results:
    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 17
    int 0x80

    ; Print reversed array
    xor esi, esi                 ; Reset counter
print_loop:
    cmp esi, 5
    je exit_program

    ; Convert number to ASCII and print
    mov eax, [array + esi*4]
    add eax, '0'
    mov [num], al

    ; Print number
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 0x80

    ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    inc esi
    jmp print_loop

exit_program:
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80