section .data
    prompt_msg db 'Enter a number (1-8): '  ; Message prompting the user for input
    prompt_len equ $ - prompt_msg  ; Length of the prompt message
    result_msg1 db 'The factorial of:', 10  ; First message line, followed by a newline
    result_len1 equ $ - result_msg1  ; Length of the first result message
    result_msg2 db 'The factorial is:', 10  ; Second message line, followed by a newline
    result_len2 equ $ - result_msg2  ; Length of the second result message
    newline db 10  ; ASCII code for newline character

section .bss
    input resb 2   ; Reserve 2 bytes for user input (input number)
    output resb 32 ; Reserve 32 bytes for the output string (to store result as a string)

section .text
    global _start

_start:
    ; Print prompt to the user to enter a number
    mov eax, 4            ; Syscall number for 'write'
    mov ebx, 1            ; File descriptor for stdout
    mov ecx, prompt_msg   ; Address of the prompt message
    mov edx, prompt_len   ; Length of the prompt message
    int 80h               ; Call the kernel to print the prompt

    ; Read input from the user
    mov eax, 3            ; Syscall number for 'read'
    mov ebx, 0            ; File descriptor for stdin
    mov ecx, input        ; Address to store input
    mov edx, 2            ; Number of bytes to read
    int 80h               ; Call the kernel to read the input

    ; Convert ASCII input to integer (from '0'-'9' to actual number)
    movzx eax, byte [input]  ; Load the input (first byte) into eax
    sub eax, '0'             ; Convert the ASCII character to an integer by subtracting ASCII '0'
    push eax                 ; Save the original input number on the stack

    ; Print the first result line: "The factorial of:"
    mov eax, 4            ; Syscall number for 'write'
    mov ebx, 1            ; File descriptor for stdout
    mov ecx, result_msg1  ; Address of the first result message
    mov edx, result_len1  ; Length of the first result message
    int 80h               ; Call the kernel to print the result message

    ; Print the second result line: "The factorial is:"
    mov eax, 4            ; Syscall number for 'write'
    mov ebx, 1            ; File descriptor for stdout
    mov ecx, result_msg2  ; Address of the second result message
    mov edx, result_len2  ; Length of the second result message
    int 80h               ; Call the kernel to print the result message

    ; Print the input number (input is stored in `input` as a character)
    mov al, [input]      ; Load the input byte into al
    mov [output], al     ; Store the input number in the output buffer
    mov eax, 4           ; Syscall number for 'write'
    mov ebx, 1           ; File descriptor for stdout
    mov ecx, output      ; Address of the output buffer (contains input number)
    mov edx, 1           ; Number of bytes to write (only 1 character)
    int 80h              ; Call the kernel to print the input number

    ; Print a newline after the input number
    mov eax, 4           ; Syscall number for 'write'
    mov ebx, 1           ; File descriptor for stdout
    mov ecx, newline     ; Address of newline character
    mov edx, 1           ; Number of bytes to write (newline)
    int 80h              ; Call the kernel to print the newline

    ; Calculate factorial by calling the 'factorial' subroutine
    pop eax              ; Restore the input number from the stack
    call factorial       ; Call the factorial subroutine

    ; Convert the result (in eax) to a string for printing
    mov ecx, output      ; Address of the output buffer
    add ecx, 31          ; Point to the end of the buffer (last byte)
    mov byte [ecx], 0    ; Null-terminate the string
    mov ebx, 10          ; Set divisor for base 10 conversion

convert:
    xor edx, edx         ; Clear the remainder register (edx)
    div ebx              ; Divide eax by 10, quotient in eax, remainder in edx
    add dl, '0'          ; Convert the remainder (digit) to ASCII
    dec ecx              ; Move buffer pointer backwards
    mov [ecx], dl        ; Store the ASCII digit in the output buffer
    test eax, eax        ; Check if the quotient is zero
    jnz convert          ; If not, continue dividing

    ; Print the result string (the factorial result as a string)
    mov edx, output      ; Address of the output buffer
    add edx, 31          ; Move to the last non-null byte in the output buffer
    sub edx, ecx         ; Calculate the length of the result string
    mov eax, 4           ; Syscall number for 'write'
    mov ebx, 1           ; File descriptor for stdout
    int 80h              ; Call the kernel to print the result

    ; Print final newline after the result
    mov eax, 4           ; Syscall number for 'write'
    mov ebx, 1           ; File descriptor for stdout
    mov ecx, newline     ; Address of newline character
    mov edx, 1           ; Number of bytes to write (newline)
    int 80h              ; Call the kernel to print the newline

    ; Exit the program
    mov eax, 1           ; Syscall number for 'exit'
    xor ebx, ebx         ; Exit code 0
    int 80h              ; Call the kernel to exit

; Subroutine to calculate factorial
factorial:
    push ebp             ; Save the old base pointer
    mov ebp, esp         ; Set up new base pointer
    push ebx             ; Save ebx register
    push ecx             ; Save ecx register

    cmp eax, 0           ; Check if the input number is 0
    je return_one        ; If eax == 0, return 1 (factorial of 0 is 1)

    mov ecx, eax         ; Copy eax (input number) to ecx
    dec ecx              ; Decrement ecx (start from n-1)

multiply_loop:
    cmp ecx, 1           ; Compare ecx with 1
    jbe factorial_done   ; If ecx <= 1, we're done
    mul ecx              ; Multiply eax by ecx
    dec ecx              ; Decrement ecx
    jmp multiply_loop    ; Repeat the multiplication

return_one:
    mov eax, 1           ; Set eax to 1 (factorial of 0 or 1)

factorial_done:
    pop ecx              ; Restore the saved ecx register
    pop ebx              ; Restore the saved ebx register
    mov esp, ebp         ; Restore the stack pointer
    pop ebp              ; Restore the old base pointer
    ret                  ; Return to the calling code