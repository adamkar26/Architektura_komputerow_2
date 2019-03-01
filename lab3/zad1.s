.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
znak: .asciz "a000asd000000000d0fg000b"
znak_len= .-znak



.text
.global main
main:
push $znak_len
push $znak
call f


koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

# funckja obliczajaca indeks poczatku najdluzszego ciagu 0
f:
push %rbp
movq %rsp, %rbp
movq 16(%rbp), %rax   # char *
movq 24(%rbp), %r10   # dlugosc ciagu

movq $0, %rbx  # licznik petli
movq $0, %rdx  # licznik zer
movq $-1, %rdi  # numer pozycji
movq $0, %r8  # maksimum wystapien
movq $-1, %r9  # poczatek wystapienia maksimum

licz:
movb (%rax,%rbx,1), %cl   # kopiuje znak
cmp $'0', %cl  # czy jest zerem?
jne k_zer
inc %rdx
movq %rbx, %rdi
jmp k_petli

k_zer:
cmp %r8, %rdx
jle k_petli
movq %rdx, %r8  # nowe maksimum
dec %rdx
sub %rdx, %rdi  # obliczam poczatek ciagu
movq %rdi, %r9
movq $0, %rdx
movq $-1, %rdi # zerowanie licznikow


k_petli:
inc %rbx
cmp %r10, %rbx
jle licz

movq %r9, %rax  # zwrot wartosci
movq %rbp, %rsp
pop %rbp
ret
