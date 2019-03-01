.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0

.text
.global main
main:
movq $4, %rax
call funkcja




koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall






# funkcja rekurencyjna- przekazanie przez rejestr
funkcja:
push %rbp
movq %rsp, %rbp
# sub $8, %rsp
movq %rax, %r12   # int i

cmp $0, %rax
jne rekurencja
movq $-2, %r8
jmp koniec_f

rekurencja:
dec %rax
call funkcja
movq %r8, %rax
movq $5, %r8
mul %r8  # wynik w rax
movq %rax, %r8
add $7, %r8 # dodanie 7


koniec_f:
# zwrot wyniku w r8
movq %rbp, %rsp
pop %rbp
ret
