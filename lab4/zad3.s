.data

.text
.global funkcja
.type funkcja, @function

funkcja:

push %rbp
movq %rsp, %rbp
 # rdi- liczba, rsi- tablica

 movq %rdi, %r8  # kopia liczby do r8
 movq $2, %r9  # pierwsza liczba pierwsza
movq $0, %r10  # licznik liczb pierwszych

 petla_zewnetrzna:

petla_wewnetrzna:
movq $0, %rdx  # do dzielenia
movq %r8, %rax
div %r9 # r8 mod r9
cmp $0, %rdx
jne koniec_wewnetrznej

movq %r9, %rdx   # kopia k- dzielnik
add $48, %dl  # kodowanie ascii
movb %dl, (%rsi,%r10,1) # kopiuje znak do tablicy
inc %r10


movq $0, %rdx
movq %r8, %rax
div %r9   # r8=r8/r9
movq %rax, %r8
jmp petla_wewnetrzna

koniec_wewnetrznej:
inc %r9;

 cmp $1, %r8  # dopoki liczba wieksza od 1
 jg petla_zewnetrzna

movq %r10, %rax  # zwracam wartosc
dec %r10
mov %rbp, %rsp
pop %rbp
ret # Powrót do miejsca wywołania funkcji
