
; Print Macro
%macro	print 			2
        mov     		rax, 1				
        mov     		rdi, 1					
        mov     		rsi, %1					
        mov     		rdx, %2					
        syscall						
%endmacro

; Scan Macro
%macro	scan 			2
        mov     		rax, 0					
        mov     		rdi, 0					
        mov     		rsi, %1					
        mov     		rdx, %2					
        syscall						
%endmacro

section .bss
	buffer			resb	10	;revise size of buffer
	tempans			resd 	2	;temporary answerholder for calculations
	result			resd    1	;final result (int)
	ascii			resb	1	;final result (ascii)
	
section .data
	SYS_exit		equ	60
	EXIT_SUCCESS		equ	0
	msg1			db	"Enter an Operation: "
	msg2			db	" = "

section .text
        global _start
        
_start:
	print			msg1, 21				
	scan			buffer, 10
	
	call			toInt

	mov			rcx, 0
	mov			rsi, 0
	mov			rsi, qword[tempans+rcx]
	
findOper:

	cmp 			qword[rsi], '+'			; seeing if index is at add to call its function
	je 			addition
	
	cmp			qword[rsi], '/'			; seeing if index is at divide
	je 			divide
	
	cmp			qword[rsi], '*'			; seeing if index is at multiply to call its function
	je			multiply
	
	cmp			qword[rsi], '-'		; seeing if index is at subtract to call its function
	je			subtract
	
	inc 			ax
	cmp			ax, 0
	jne			findOper
	
	mov			ax, word[tempans]
	mov			word[result], ax
end:
	
	call 			toString
	
	print			buffer, 10 	;revise size of buffer 
	print 			msg2, 3			
	print			ascii, 1				

        mov     		rax, SYS_exit				
        mov     		rdi, EXIT_SUCCESS			
        syscall		
        

; TO INTEGER FUNCTION 
toInt:
	mov			ax, 0					
	mov			bx, 10				
	mov			rsi, 0					
input:
	mov			cl, byte[rsi+buffer]
	and			cl, 0fh			
	add			al, cl
	adc			ah, 0					
	cmp			rsi, 2					
	je			skip0					
	mul			bx					
skip0:
	inc			rsi					
	cmp			rsi, 3					
	jl			input				
	mov			word[tempans], ax			
	ret
	
; TO STRING FUNCTION
toString:
	mov 			ax, word[result]
	mov 			rcx, 0
	mov 			bx, 10	
					
divideLoop:		
	mov 			dx, 0
	div 			bx 					
	push 			dx 				
	inc 			rcx 					
	cmp 			ax, 0 				
	jne 			divideLoop 				

	mov 			rbx, ascii				
	mov 			rdi, 0					
popLoop:
	pop 			rax 				
	add 			al, "0" 				
	mov 			byte [rbx+rdi], al 			
	inc 			rdi					
	loop 			popLoop 				
	mov 			byte [rbx+rdi], 10 			
	ret
					
; ADDITION FUNCTION 
addition:
	cmp			rsi, 1
	jne			cont_add			
a_first:	
	dec			rsi
	mov 			ax, word[rdi+rsi]
	inc			rsi
	inc			rsi
	add			ax, word[rdi+rsi]
	mov			word[tempans], ax
		
	ret
	
cont_add:
	mov			ax, word[tempans]
	inc 			rsi
	add			ax, word[rdi+rsi]
	mov			word[tempans], ax
	ret
	
; DIVISION FUNCTION
divide:
	cmp			rsi, 1
	jne			cont_div			
d_first:	
	dec			rsi
	mov			dx, word[rdi+rsi]
	inc			rsi
	inc 			rsi
	div			word[rdi+rsi] 			
	mov			word[tempans], dx
	ret
	
cont_div:
	mov			dx, word[tempans]
	inc 			rsi
	div 			word[rdi+rsi]
	mov			word[tempans], dx
	ret

; MULTIPLY FUNCTION
multiply:
	cmp			rsi, 1
	jne			cont_mul			
m_first:	
	dec			rsi
	mov			cx, word[rdi+rsi]
	inc			rsi
	inc 			rsi
	mul			word[rdi+rsi] 			
	mov			word[tempans], cx
	ret
	
cont_mul:
	mov			cx, word[tempans]
	inc 			rsi
	mul			word[rdi+rsi]
	mov			word[tempans], cx
	ret

; SUBTRACT FUNCTION
subtract:
	cmp			rsi, 1
	jne			cont_sub			
s_first:	
	dec			rsi
	mov 			bx, word[rdi+rsi]
	inc			rsi
	inc			rsi
	sub			bx, word[rdi+rsi]
	mov			word[tempans], bx
		
	ret
	
cont_sub:
	mov			bx, word[tempans]
	inc 			rsi
	sub			bx, word[rdi+rsi]
	mov			word[tempans], bx
	ret
	
