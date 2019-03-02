.data
STDIN=0
STDOUT=1
SYSREAD=0
SYSWRITE=1
SYSOPEN=2
SYSCLOSE=3
FREAD=0
FWRITE=1
SYSEXIT=60
EXIT_SUCCESS=0
file_in1: .ascii "1.txt\0"
file_in2: .ascii "2.txt\0"
file_out: .ascii "out.txt\0"

.bss
.comm in1, 1024 #bufor przechowuje dane ascii z pliku 1
.comm in2, 1024 #bufor przechowuje dane z pliku 2
.comm value1, 256  #wartosc 1
.comm value2, 256  #wartosc 2
.comm sum, 512  #bufor sumy
.comm out, 1025 #bufor wyjscia

.text
.global main
main:

#zeruje value 1 i 2
movq $0, %rax
zeruj:
movq $0, value1(,%rax,1)
movq $0, value2(,%rax,1)
inc %rax
cmp $256, %rax
jl zeruj


#wczytanie pierwszej liczby
movq $SYSOPEN, %rax
movq $file_in1, %rdi
movq $FREAD, %rsi
movq $0, %rdx
syscall
movq %rax, %r8  #kopia uchwytu do pliku

movq $SYSREAD, %rax
movq %r8, %rdi
movq $in1, %rsi
movq $1024, %rdx
syscall
mov %rax, %r9   #r9 liczba odczytanych danych

#zamkniecie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall


#zapis liczby do bufora
dec %r9 #pomijam koniec lini
movq $-1, %r10  #licznik od poczatku

zapis1:
dec %r9
inc %r10

#zdekodownie 2 pierwszych bitow
movb in1(, %r9,1), %al  #wczytanie ascii
sub $'0',%al  #dekodowanie
cmp $0, %r9  #jezli jest co wczytaj
jle zapiszA

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $2, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszA

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $4, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszA

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $6, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszA

zapiszA:
movb %al, value1(,%r10,1)  #zapis do bufora
cmp $0, %r9
jg zapis1


liczba2:
#wczytanie drugiej liczby
movq $SYSOPEN, %rax
movq $file_in2, %rdi
movq $FREAD, %rsi
movq $0, %rdx
syscall
movq %rax, %r8  #kopia uchwytu do pliku

movq $SYSREAD, %rax
movq %r8, %rdi
movq $in1, %rsi
movq $1024, %rdx
syscall
mov %rax, %r9   #r9 liczba odczytanych danych

#zamkniecie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#zapis liczby do bufora
dec %r9 #pomijam koniec lini
movq $-1, %r11  #licznik od poczatku

zapis2:
dec %r9
inc %r11

#zdekodownie 2 pierwszych bitow
movb in1(, %r9,1), %al  #wczytanie ascii
sub $'0',%al  #dekodowanie
cmp $0, %r9  #jezli jest co wczytaj
jle zapiszB

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $2, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszB

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $4, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszB

#kolejne 2 bity
dec %r9
movb in1(,%r9,1), %bl  #wczytanie ascii
sub $'0', %bl #odejmuje ascii
shl $6, %bl   #przesuwam
add %bl, %al  #dodaje do wyniku
cmp $0, %r9
jle zapiszB

zapiszB:
movb %al, value2(,%r11,1)  #zapis do bufora
cmp $0, %r9
jg zapis2

#dodanie wartosci
clc #czyscze flage przeniesienia
pushfq #umieszczam rejestr z flagami na stosie
movq $0, %r8 #licznik petli

dodaj:
movq value1(,%r8,8), %rax
movq value2(,%r8,8), %rbx
popfq   #pobieram rejestr flag
adc %rbx,%rax  #dodaje z przeniesieniem
jnc s_koniec
pushfq  #umieszczam flagi na stosie
n_koniec:
movq %rax, sum(,%r8,8)  #zapis wyniku
add $8, %r8 #skok co 8
cmp $256,%r8
jl dodaj

s_koniec:
pushfq
cmp $0, %rax  #jezeli wynik 0 i brak przeniesienia
jne n_koniec


#zamiana na hex
movq %r8, %r10  #licznik out
movq $0, %r9   #licznik sum

zmien:
movb sum(,%r9,1), %al  #kopiuje bajt wyjsciowy
movb %al, %bl
movb %al, %cl  #kopie bajtu
#rozdzielam liczbe na dwa
shr $4, %cl  #przesuwam w prawo o 4
and $0b1111, %bl   #wyłuskuje 4 niższe bity
and $0b1111, %cl   #wyłuskuje 4 wyższe bity
add $'0', %bl
add $'0', %cl  #zamiana na ascii

#sprawdzenie czy nie trzeba dac A,..F
cmp $'9', %bl
jle cspr
add $7,%bl  #zamieniam na litere

cspr:
cmp $'9', %cl
jle kon
add $7,%cl

kon:
movb %bl, out(,%r8,1)
dec %r8
movb %cl, out(,%r8,1)
dec %r8
inc %r9
cmp %r10,%r9
jl zmien

#dodanie znaku konca lini
inc %r10
movq %r10, %r8
movb $0x0A, out(, %r8, 1)

zapis:
movq $SYSOPEN, %rax
movq $file_out, %rdi
movq $FWRITE, %rsi
movq $0644, %rdx
syscall
movq %rax, %r8  #uchwyt pliku

movq $SYSWRITE, %rax
movq  %r8, %rdi
movq $out, %rsi
movq %r10, %rdx
syscall

#zamkniecie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall


koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
