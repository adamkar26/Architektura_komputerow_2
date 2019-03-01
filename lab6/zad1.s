.text
.global add
.global multiply

.type add, @function
.type multiply, @function

add:
push %rbp
movq %rsp, %rbp

# vec1 w rdi, vec2 w rsi, n w rdx

movq $0, %r8
movq $0, %r9

petla1:
movq (%rdi,%r8,8), %mm0
movq (%rsi, %r8,8), %mm1
paddw %mm1, %mm0
movq  %mm0  ,(%rdi,%r8,8)
# add $8, %r9
inc %r8
cmp %rdx,%r8
jne petla1
emms


mov %rbp, %rsp
pop %rbp
ret # Powrót do miejsca wywołania funkcji

multiply:
push %rbp
movq %rsp, %rbp

# vec1 w rdi, vec2 w rsi, n w rdx

movq $0, %r8
movq $0, %r9

petla2:
movq (%rdi,%r8,8), %mm0
movq (%rsi, %r8,8), %mm1
pmullw %mm0,%mm1
pmulhw %mm0, %mm1
pmulhuw %mm0,%mm1
movq  %mm1  ,(%rdi,%r8,8)
add $8, %r9
inc %r8
cmp %rdx,%r8
jne petla2
emms

mov %rbp, %rsp
pop %rbp
ret # Powrót do miejsca wywołania funkcji
