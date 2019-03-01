.data
STDIN= 0
STDOUT = 1
SYSWRITE =1
SYSREAD= 0
SYSEXIT= 60
EXIT_SUCCESS =0
BUFLEN = 512
P_LICZB= 0x30
kom: .ascii "Wprowadzono zla liczbe"
k_len= .-kom

.bss
.comm textin, 512
.comm textout, 512
.comm text, 512

.text
.global main
main:
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

#zamiana ASCII na liczbe
movq %rax, %r8  #licznik petli
sub $2, %r8  #bez spacji
movq $0, %rdi  #miejsce na wynik
movq $1, %rsi  #kolejne potegi 8

zamiana:
movq $0, %rax
movb textin(, %r8,1), %al #pobranie znaku
sub $P_LICZB,%rax  #od teraz liczba
movq %rax, %r9   #kopia liczby do r9
cmp $0, %rax  
jl blad
cmp $7, %rax
jg blad
mul %rsi  #mnoze razy p.8, wynik do %rax
add %rax, %rdi #dodanie wyniku
movq $8, %rax
mul %rsi
movq %rax, %rsi #wytworzenie kolejnej potegi
dec %r8
cmp $0, %r8
jge zamiana

zero:   #sprawdzam czy trzeba dopisac rozszerzenie
cmp $4, %r9
jl dalej
movq $-1, %rax
mul %rsi  #mnoze razy p.8, wynik do %rax
add %rax, %rdi #dodanie wyniku

dalej:
movq %rdi, %rax #nasza liczba w 10
movq $6, %rbx  #podstawa   
movq $0, %r9   #licznik
cmp $0, %rax  #czy wieksze od zera
jge dodatnie
jmp ujemne

dodatnie:
movq $0, %rdx 
div  %rbx  #dziele przez podstawe, rdx zawiera reszte
add $P_LICZB, %dl #zamiana na ascii
movb %dl,text(,%r9,1)  #zapis do bufora
inc %r9
cmp $0,%rax
jne dodatnie

odwroc_dodatnie:
movq $0, %r10 
movb $'0',textout(,%r10,1) #dodaje 0 na poczatek
movq $1, %rdi #licznik
dec %r9 #licznik od konca

odwroc_petla:
movb text(,%r9,1), %al  
movb %al, textout(,%rdi,1)
dec %r9
inc %rdi
cmp $0, %r9
jge odwroc_petla
jmp enter

ujemne:
movq $-1, %rdx  #-1 na najwyzej pozycji
idiv %rbx #dziele ze znakiem
add $6,%rdx  #liczba po zmianie +6
add $P_LICZB, %rdx #zamiana na ascii
movb %dl, text(,%r9,1) #dodaje do buforu
inc %r9
cmp $0,%rax
je enter

ujemne_petla:
movq $-1, %rdx #-1 na najwyzszej pozycji
idiv %rbx  
add $5,%rdx #liczba po zmianie +5
add $P_LICZB, %rdx #zmiana na ascii
movb %dl, text(,%r9,1)
inc %r9
cmp $0, %rax
jne ujemne_petla

odwroc_ujemne:
movq $0, %r10
movb $'5', textout(,%r10,1)
movq $1, %rdi #licznik
dec %r9 #licznik od konca
jmp odwroc_petla


enter:
#dodanie entera
movb $0xA, textout(,%rdi,1)
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall
jmp koniec


blad:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $kom, %rsi
movq $k_len, %rdx
syscall



koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
