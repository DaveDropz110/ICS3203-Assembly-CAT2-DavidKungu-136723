section .data
    prompt db 'Enter an integer: ', 0
    positive_msg db 'POSITIVE', 10, 0
    negative_msg db 'NEGATIVE', 10, 0
    zero_msg db 'ZERO', 10, 0
    error_msg db 'Invalid input. Please enter a valid integer.', 10, 0

section .bss
    input resd 1      ; 4-byte input buffer
    input_buffer resb 20  ; Larger buffer for input parsing

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 19
    int 0x80

    ; Read input with buffer
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 20
    int 0x80

    ; Convert input to integer
    mov esi, input_buffer
    call parse_integer

    ; Check parsing result
    test eax, eax
    jz input_error

    ; Classify number
    mov eax, [input]
    cmp eax, 0
    je zero_case
    jg positive_case
    jl negative_case

input_error:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 44
    int 0x80
    jmp exit

positive_case:
    mov eax, 4
    mov ebx, 1
    mov ecx, positive_msg
    mov edx, 9
    int 0x80
    jmp exit

negative_case:
    mov eax, 4
    mov ebx, 1
    mov ecx, negative_msg
    mov edx, 9
    int 0x80
    jmp exit

zero_case:
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 5
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Input parsing function
parse_integer:
    ; Input: ESI points to input buffer
    ; Output: EAX (0 = error, 1 = success), [input] contains parsed number
    push ebx
    push ecx
    push edx

    xor eax, eax    ; Clear EAX for result
    xor ebx, ebx    ; Clear EBX for sign
    xor ecx, ecx    ; Clear ECX for number
    xor edx, edx    ; Clear EDX for parsing

    ; Check for sign
    mov dl, [esi]
    cmp dl, '-'
    je negative_number
    cmp dl, '+'
    je positive_number
    jmp parse_digits

negative_number:
    mov ebx, 1      ; Set negative flag
    inc esi
    jmp parse_digits

positive_number:
    inc esi

parse_digits:
    mov dl, [esi]
    cmp dl, 10      ; Newline
    je parse_done
    cmp dl, 0       ; Null terminator
    je parse_done
    cmp dl, '0'
    jl parse_error
    cmp dl, '9'
    jg parse_error

    ; Convert digit
    sub dl, '0'
    imul ecx, 10
    add ecx, edx
    inc esi
    jmp parse_digits

parse_done:
    ; Apply sign
    test ebx, ebx
    jz positive_result
    neg ecx

positive_result:
    mov [input], ecx
    mov eax, 1      ; Success
    jmp parse_exit

parse_error:
    xor eax, eax    ; Error

parse_exit:
    pop edx
    pop ecx
    pop ebx
    ret