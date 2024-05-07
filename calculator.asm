section .bss
    buffer          resb    10  ; input buffer
    tempans         resd    1   ; temporary answer holder for calculations
    result          resb    10  ; final result (ASCII)
    
section .data
    SYS_exit        equ     60
    EXIT_SUCCESS    equ     0
    msg1            db      "Enter an Operation: ", 0
    msg2            db      " = ", 0

section .text
    global _start

_start:
    print   msg1, 19            ; Print prompt
    scan    buffer, 10          ; Read user input

    call    calculate           ; Perform calculations

    print   buffer, 10          ; Print input expression
    print   msg2, 3             ; Print '='
    print   result, 10          ; Print result

    ; Exit
    mov     rax, SYS_exit
    xor     rdi, rdi
    syscall

calculate:
    mov     rsi, buffer         ; Point RSI to the beginning of the input buffer
    mov     rdi, tempans        ; Point RDI to the temporary answer holder
    mov     rcx, 0              ; Initialize loop counter

parse_loop:
    mov     al, byte [rsi + rcx]  ; Load the current character into AL
    cmp     al, 0               ; Check for end of string
    je      end_parse

    ; Parse character
    cmp     al, '+'             ; Check for addition
    je      perform_addition
    cmp     al, '-'             ; Check for subtraction
    je      perform_subtraction
    cmp     al, '*'             ; Check for multiplication
    je      perform_multiplication
    cmp     al, '/'             ; Check for division
    je      perform_division
    ; If the character is not an operator, it's treated as a digit, continue parsing

perform_addition:
    add     dword [rdi], eax   ; Add the current number to the temporary answer
    jmp     next_char

perform_subtraction:
    sub     dword [rdi], eax   ; Subtract the current number from the temporary answer
    jmp     next_char

perform_multiplication:
    imul    dword [rdi], eax   ; Multiply the temporary answer by the current number
    jmp     next_char

perform_division:
    xor     edx, edx           ; Clear EDX for division
    mov     ecx, eax           ; Move the current number to ECX for division
    mov     eax, dword [rdi]   ; Move the temporary answer to EAX for division
    idiv    ecx                ; Divide the temporary answer by the current number
    mov     dword [rdi], eax   ; Store the result back in the temporary answer

next_char:
    inc     rcx                 ; Move to the next character
    jmp     parse_loop          ; Continue parsing

end_parse:
    ; Convert the result to ASCII string
    mov     rax, dword [rdi]    ; Move the result to RAX
    mov     rdi, result         ; Point RDI to the result buffer
    call    int_to_ascii        ; Convert the result to ASCII
    ret

; Function to convert an integer to ASCII string
int_to_ascii:
    mov     rbx, 10             ; Base 10
    mov     rcx, result + 9     ; End of buffer
    mov     byte [rcx], 0       ; Null terminator
reverse_loop:
    dec     rcx                 ; Move backward in buffer
    xor     rdx, rdx            ; Clear remainder
    div     rbx                 ; Divide RAX by 10
    add     dl, '0'             ; Convert remainder to ASCII
    mov     [rcx], dl           ; Store ASCII digit in buffer
    test    rax, rax            ; Check for quotient
    jnz     reverse_loop        ; Continue if quotient is not zero
    mov     rdi, rcx            ; Move address of first character of the string to RDI
    ret
