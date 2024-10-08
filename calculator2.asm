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
	buffer			resb	30				; revise size of buffer
	nums			resb 	30				; numholder for calculations
	symbols			resb 	30				; symbol holder for calculations
	result			resb    1				; final result (int)
	newLine			resb	1				; newline

section .data
	SYS_exit		equ	60
	EXIT_SUCCESS		equ	0
	msg1			db	"Enter an Operation: " 
	msg2			db	" = " 

section .text
        global _start
        
_start:
	print			msg1, 21				
	scan			buffer, 30
	
	
	call			store_num
	
	call			store_sym
	
	mov			al, byte[nums+0]
	mov			byte[result], al
	
	call 			findOper
	
end:
	add			byte[result], '0'			; convert result into an ascii value
	mov			byte[newLine], 10			; store newline address into newLine
	
	
	print			msg2, 3					; print the equal sign
	print			result, 1				; print the result
	print			newLine, 1				; print a new line 
	
	mov     		rax, SYS_exit				
        mov     		rdi, EXIT_SUCCESS			
        syscall		
   
   
   
      
store_num:
	mov			rax, 0
	mov			rsi, buffer				; store address of input buffer in rsi
	mov 			rdi, nums				; store address of nums in rdi
	mov			r10, 0									
	mov			rcx, 0					
	
store_n_loop:

	mov     		al, byte [rsi+r10]      		; load byte from source string
    	cmp     		al, 0               			; check if it's the null terminator
  	je      		store_n_done           			; if it's null end the loop
  	cmp			al, 10					; check if its new line char
  	je      		store_n_done           			; if it's new line end the loop
  	and			al, 0fh
  	;sub			al, '0'					; convert to decimal
   	inc    	 		r10			 
   	inc			r10                			; move to next even byte in source string
   	mov   			byte[nums+rcx], al      		; copy byte to destination array
    	inc     		rcx                 			; move to next byte in destination array
    	jmp     		store_n_loop          			; repeat the store loop

store_n_done:	
	ret             


store_sym:
	mov			rax, 0
	mov			rsi, buffer				; store address of input buffer in rsi
	mov 			rdi, symbols				; store address of symbols in rdi
	mov			rcx, 0
	mov			r10, 1
store_s_loop:

	mov     		al, byte [rsi+r10]     			; load byte from source string
	cmp     		al, 0               			; check if it's the null terminator
  	je      		store_s_done           			; if it's null end the loop
  	cmp			al, 10					; check if its new line char
  	je      		store_s_done          		 	; if it's new line end the loop
   	mov   			byte [rdi+rcx], al   			; copy byte to destination array
   	inc    	 		r10					 
   	inc			r10                			; move to next odd byte in source string
    	inc     		rcx                 			; move to next byte in destination array
    	jmp     		store_s_loop          			; repeat the store loop

store_s_done:		
    	ret                         


findOper:
	mov			rbx,	0					
	mov			rcx,	1				; initializing the index of nums array
	mov			al,	byte[nums+0]			; store first digit in al register
	mov			byte[result],	al			; store first digit into result
calculateLoop:
	cmp			byte[nums+rcx], 0			; checking for end of array
	je			end					; exit if we do
	mov			sil, byte[result]			; store current result in sil register
	mov			dil, byte[nums+rcx]			; store next digit in dil register		
checkAdd:
	cmp			byte[symbols+rbx], '+'			; check if current symbol is addition, move to checkSub if not	
	jne			checkSub	
	call			addition				; perform addition if symbol is addition
	jmp			moveTonext				; move to next symbol
checkSub:
	cmp			byte[symbols+rbx], '-'			; check if current symbol is subtraction, move to checkMul if not		
	jne			checkMul
	call			subtraction				; perform subtraction operation if symbol is subtraction
	jmp			moveTonext				; jump to next symbol
checkMul:
	cmp			byte[symbols+rbx], '*'			; check if current symbol is multiply, move to checkDiv if not		
	jne			checkDiv
	call			multiply				; perform multiplication operation if correct symbol
	jmp			moveTonext				; move to next symbol
checkDiv:
				
	call			divide					; perform divison operation if symbol matches division and not other symbols
	jmp			moveTonext				; jump to next symbol
moveTonext:	
	inc			rcx					; move to next digit in nums array
	inc 			rbx					; move to next symbol in symbol array
	jmp 			calculateLoop				; jump back to start new iteration of loop
	

addition:
	add			sil, dil				; adding the value sil holds to the value dil holds
	mov			byte[result], sil			; moving the value sil holds into result
	ret
	
multiply:
	mov 			al, sil 	
	mul 			dil					; multiply value holds al by value dil holds(al*dil)
	mov			byte[result], al			; moving the value al holds into result
	ret
subtraction:	
	sub			sil, dil				; subtracting the value sil holds to the value dil holds
	mov			byte[result], sil			; moving the value sil holds into result
	ret
divide:
	mov			al, sil
	div			dil					; divide value holds al by value dil holds(al/dil)
	mov			byte[result], al			; moving the value al holds into result
	ret

