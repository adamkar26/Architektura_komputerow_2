.data
format_scanf: .asciz "%d %lf %f"
format_printf: .asciz "%f"

.bss
.comm int, 4   # bufory na dane
.comm double, 8
.comm float, 4

.text
.global main
main:

movq $0, %rax   # zero zmiennego przecinak
movq $format_scanf, %rdi  # pierwszy paramter
movq $int, %rsi
movq $double, %rdx
movq $float, %rcx
call scanf


movq $0, %rdi
movq $0, %rcx

movq $2, %rax
movq int(,%rcx, 4), %rdi
movsd double, %xmm0
movss float, %xmm1
call f  # wynik w xmm0

movq $1, %rax # Przesyłamy jeden parametr zmiennoprzecinkowy
movq $format_printf, %rdi
sub $8, %rsp # Workaround, aby printf nie zmienił wartości
             # ostatniej komórki na stosie. Jest to potrzebne tylko
             # przy wyświetlaniu liczb zmiennoprzecinkowych.
             # Wskaźnik na stos należy przesunąć o wielokrotność
             # liczby 8 równą ilości parametrów ZP (8*RAX).
call printf  # Wywołanie funkcji printf
 add $8, %rsp # Workaround -||-







mov $0, %rax # Brak parametrów zmiennoprzecinkowych
call exit
