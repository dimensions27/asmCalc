
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
	converted		resb	10	;converted to int
	tempans			resb 	1	;temporary answerholder for calculations
	result			resb    1	;final result (int)
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
	
	mov			r10, byte[converted]
	mov			r12, 0
	mov 			al, byte[r10+r12]
	
	
findOper:

	cmp 			al, '+'			; seeing if index is at add to call its function
	je 			add
	
	cmp			al, '/'			; seeing if index is at divide
	je 			divide
	
	cmp			al, '*'			; seeing if index is at multiply to call its function
	je			multiply
	
	cmp			al, '-'			; seeing if index is at subtract to call its function
	je			subtract
	
	inc 			r12
	cmp			al, 0
	jne			findOper
	
	mov			byte[result], byte[tempans]
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
	mov			byte[converted], ax			
	ret
	
; TO STRING FUNCTION
toString:
	mov 			ax, byte[result]
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
add:
	cmp			r12, 1
	jne			cont_add			
first:	
	dec			r12
	mov 			byte[tempans], byte[r10+r12]
	inc			r12
	inc			r12
	mov			ax, byte[tempans]
	add			ax, byte[r10+r12]
	mov			byte[tempans], ax
		
	ret
	
cont_add:
	mov			ax, byte[tempans]
	inc 			r12
	add			ax, byte[r10+r12]
	mov			byte[tempans], ax
	ret
	
; DIVISION FUNCTION
divide:
	cmp			r12, 1
	jne			cont_div			
first:	
	dec			r12
	mov			byte[tempans], byte[r10+r12]
	inc		`	r12
	inc 			r12
	mov 			ax, byte[tempans]
	div			byte[r10+r12] 			
	mov			byte[tempans], ax
	ret
	
cont_div:
	mov			ax, byte[tempans]
	inc 			r12
	div 			byte[r10+r12]
	mov			byte[tempans], ax
	ret

; MULTIPLY FUNCTION
multiply:
	cmp			r12, 1
	jne			cont_mul			
first:	
	dec			r12
	mov			byte[tempans], byte[r10+r12]
	inc		`	r12
	inc 		r12
	mov 		ax, byte[tempans]
	mul			byte[r10+r12] 			
	mov			byte[tempans], ax
	ret
	
cont_mul:
	mov			ax, byte[tempans]
	inc 		r12
	mul			byte[r10+r12]
	mov			byte[tempans], ax
	ret

; SUBTRACT FUNCTION
subtract:
	cmp			r12, 1
	jne			cont_sub			
first:	
	dec			r12
	mov 		byte[tempans], byte[r10+r12]
	inc			r12
	inc			r12
	mov			ax, byte[tempans]
	sub			ax, byte[r10+r12]
	mov			byte[tempans], ax
		
	ret
	
cont_sub:
	mov			ax, byte[tempans]
	inc 			r12
	sub			ax, byte[r10+r12]
	mov			byte[tempans], ax
	ret
	
