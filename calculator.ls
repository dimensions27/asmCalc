     1                                 %line 1+1 calculator.asm
     2                                 
     3                                 
     4                                 %line 10+1 calculator.asm
     5                                 
     6                                 
     7                                 %line 19+1 calculator.asm
     8                                 
     9                                 [section .bss]
    10 00000000 <gap>                   buffer resb 10
    11 0000000A <gap>                   tempans resd 2
    12 00000012 <gap>                   result resd 1
    13 00000016 <gap>                   ascii resb 1
    14                                 
    15                                 [section .data]
    16                                  SYS_exit equ 60
    17                                  EXIT_SUCCESS equ 0
    18 00000000 456E74657220616E20-     msg1 db "Enter an Operation: "
    19 00000000 4F7065726174696F6E-
    20 00000000 3A20               
    21 00000014 203D20                  msg2 db " = "
    22                                 
    23                                 [section .text]
    24                                 [global _start]
    25                                 
    26                                 _start:
    27 00000000 48C7C001000000          mov rax, 1
    28                                 %line 36+0 calculator.asm
    29 00000007 48C7C701000000          mov rdi, 1
    30 0000000E 48C7C6[00000000]        mov rsi, msg1
    31 00000015 48C7C215000000          mov rdx, 21
    32 0000001C 0F05                    syscall
    33                                 %line 37+1 calculator.asm
    34 0000001E 48C7C000000000          mov rax, 0
    35                                 %line 37+0 calculator.asm
    36 00000025 48C7C700000000          mov rdi, 0
    37 0000002C 48C7C6[00000000]        mov rsi, buffer
    38 00000033 48C7C20A000000          mov rdx, 10
    39 0000003A 0F05                    syscall
    40                                 %line 38+1 calculator.asm
    41                                 
    42 0000003C E8C0000000              call toInt
    43                                 
    44 00000041 48C7C100000000          mov rcx, 0
    45 00000048 48C7C600000000          mov rsi, 0
    46 0000004F 488BB1[00000000]        mov rsi, qword[tempans+rcx]
    47                                 
    48                                 findOper:
    49                                 
    50 00000056 48833E2B                cmp qword[rsi], '+'
    51 0000005A 0F841B010000            je addition
    52                                 
    53 00000060 48833E2F                cmp qword[rsi], '/'
    54 00000064 0F8449010000            je divide
    55                                 
    56 0000006A 48833E2A                cmp qword[rsi], '*'
    57 0000006E 0F8477010000            je multiply
    58                                 
    59 00000074 48833E2D                cmp qword[rsi], '-'
    60 00000078 0F84A5010000            je subtract
    61                                 
    62 0000007E 66FFC0                  inc ax
    63 00000081 6683F800                cmp ax, 0
    64 00000085 75CD                    jne findOper
    65                                 
    66 00000087 668B0425[00000000]      mov ax, word[tempans]
    67 0000008F 66890425[00000000]      mov word[result], ax
    68                                 end:
    69                                 
    70 00000097 E89D000000              call toString
    71                                 
    72 0000009C 48C7C001000000          mov rax, 1
    73                                 %line 69+0 calculator.asm
    74 000000A3 48C7C701000000          mov rdi, 1
    75 000000AA 48C7C6[00000000]        mov rsi, buffer
    76 000000B1 48C7C20A000000          mov rdx, 10
    77 000000B8 0F05                    syscall
    78                                 %line 70+1 calculator.asm
    79 000000BA 48C7C001000000          mov rax, 1
    80                                 %line 70+0 calculator.asm
    81 000000C1 48C7C701000000          mov rdi, 1
    82 000000C8 48C7C6[00000000]        mov rsi, msg2
    83 000000CF 48C7C203000000          mov rdx, 3
    84 000000D6 0F05                    syscall
    85                                 %line 71+1 calculator.asm
    86 000000D8 48C7C001000000          mov rax, 1
    87                                 %line 71+0 calculator.asm
    88 000000DF 48C7C701000000          mov rdi, 1
    89 000000E6 48C7C6[00000000]        mov rsi, ascii
    90 000000ED 48C7C201000000          mov rdx, 1
    91 000000F4 0F05                    syscall
    92                                 %line 72+1 calculator.asm
    93                                 
    94 000000F6 48C7C03C000000          mov rax, SYS_exit
    95 000000FD 48C7C700000000          mov rdi, EXIT_SUCCESS
    96 00000104 0F05                    syscall
    97                                 
    98                                 
    99                                 
   100                                 toInt:
   101 00000106 66B80000                mov ax, 0
   102 0000010A 66BB0A00                mov bx, 10
   103 0000010E 48C7C600000000          mov rsi, 0
   104                                 input:
   105 00000115 8A8E[00000000]          mov cl, byte[rsi+buffer]
   106 0000011B 80E10F                  and cl, 0f
   107 0000011E 00C8                    add al, cl
   108 00000120 80D400                  adc ah, 0
   109 00000123 4883FE02                cmp rsi, 2
   110 00000127 7401                    je skip0
   111 00000129 66F7E3                  mul bx
   112                                 skip0:
   113 0000012C 48FFC6                  inc rsi
   114 0000012F 4883FE03                cmp rsi, 3
   115 00000133 7CDE                    jl input
   116 00000135 66890425[00000000]      mov word[tempans], ax
   117 0000013D C3                      ret
   118                                 
   119                                 
   120                                 toString:
   121 0000013E 668B0425[00000000]      mov ax, word[result]
   122 00000146 48C7C100000000          mov rcx, 0
   123 0000014D 66BB0A00                mov bx, 10
   124                                 
   125                                 divideLoop:
   126 00000151 66BA0000                mov dx, 0
   127 00000155 66F7F3                  div bx
   128 00000158 6652                    push dx
   129 0000015A 48FFC1                  inc rcx
   130 0000015D 6683F800                cmp ax, 0
   131 00000161 75EC                    jne divideLoop
   132                                 
   133 00000163 48C7C3[00000000]        mov rbx, ascii
   134 0000016A 48C7C700000000          mov rdi, 0
   135                                 popLoop:
   136 00000171 58                      pop rax
   137 00000172 0430                    add al, "0"
   138 00000174 88043B                  mov byte [rbx+rdi], al
   139 00000177 48FFC7                  inc rdi
   140 0000017A E2F3                    loop popLoop
   141 0000017C C6043B0A                mov byte [rbx+rdi], 10
   142 00000180 C3                      ret
   143                                 
   144                                 
   145                                 addition:
   146 00000181 4883FE01                cmp rsi, 1
   147 00000185 7518                    jne cont_add
   148                                 a_first:
   149 00000187 48FFCE                  dec rsi
   150 0000018A 668B0437                mov ax, word[rdi+rsi]
   151 0000018E 48FFC6                  inc rsi
   152 00000191 48FFC6                  inc rsi
   153 00000194 66030437                add ax, word[rdi+rsi]
   154 00000198 66890425[00000000]      mov word[tempans], ax
   155                                 
   156 000001A0 C3                      ret
   157                                 
   158                                 cont_add:
   159 000001A1 668B0425[00000000]      mov ax, word[tempans]
   160 000001A9 48FFC6                  inc rsi
   161 000001AC 66030437                add ax, word[rdi+rsi]
   162 000001B0 66890425[00000000]      mov word[tempans], ax
   163 000001B8 C3                      ret
   164                                 
   165                                 
   166                                 divide:
   167 000001B9 4883FE01                cmp rsi, 1
   168 000001BD 7518                    jne cont_div
   169                                 d_first:
   170 000001BF 48FFCE                  dec rsi
   171 000001C2 668B1437                mov dx, word[rdi+rsi]
   172 000001C6 48FFC6                  inc rsi
   173 000001C9 48FFC6                  inc rsi
   174 000001CC 66F73437                div word[rdi+rsi]
   175 000001D0 66891425[00000000]      mov word[tempans], dx
   176 000001D8 C3                      ret
   177                                 
   178                                 cont_div:
   179 000001D9 668B1425[00000000]      mov dx, word[tempans]
   180 000001E1 48FFC6                  inc rsi
   181 000001E4 66F73437                div word[rdi+rsi]
   182 000001E8 66891425[00000000]      mov word[tempans], dx
   183 000001F0 C3                      ret
   184                                 
   185                                 
   186                                 multiply:
   187 000001F1 4883FE01                cmp rsi, 1
   188 000001F5 7518                    jne cont_mul
   189                                 m_first:
   190 000001F7 48FFCE                  dec rsi
   191 000001FA 668B0C37                mov cx, word[rdi+rsi]
   192 000001FE 48FFC6                  inc rsi
   193 00000201 48FFC6                  inc rsi
   194 00000204 66F72437                mul word[rdi+rsi]
   195 00000208 66890C25[00000000]      mov word[tempans], cx
   196 00000210 C3                      ret
   197                                 
   198                                 cont_mul:
   199 00000211 668B0C25[00000000]      mov cx, word[tempans]
   200 00000219 48FFC6                  inc rsi
   201 0000021C 66F72437                mul word[rdi+rsi]
   202 00000220 66890C25[00000000]      mov word[tempans], cx
   203 00000228 C3                      ret
   204                                 
   205                                 
   206                                 subtract:
   207 00000229 4883FE01                cmp rsi, 1
   208 0000022D 7518                    jne cont_sub
   209                                 s_first:
   210 0000022F 48FFCE                  dec rsi
   211 00000232 668B1C37                mov bx, word[rdi+rsi]
   212 00000236 48FFC6                  inc rsi
   213 00000239 48FFC6                  inc rsi
   214 0000023C 662B1C37                sub bx, word[rdi+rsi]
   215 00000240 66891C25[00000000]      mov word[tempans], bx
   216                                 
   217 00000248 C3                      ret
   218                                 
   219                                 cont_sub:
   220 00000249 668B1C25[00000000]      mov bx, word[tempans]
   221 00000251 48FFC6                  inc rsi
   222 00000254 662B1C37                sub bx, word[rdi+rsi]
   223 00000258 66891C25[00000000]      mov word[tempans], bx
   224 00000260 C3                      ret
   225                                 
