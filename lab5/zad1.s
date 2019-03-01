.data
control_word: .short 0

.text
.global ustaw, sprawdz
.type ustaw, @function
.type sprawdz, @function

sprawdz:
push %rbp
movq %rsp, %rbp

movq $0, %rax  # zeruje ax
fstcw  control_word  # pobieram slowo kontrolne
fwait
mov  control_word, %ax  # slowo kontrolne w ax
and $0xC00, %ax # 0000 1100 0000 0000 zeruje wszystko za wyjatkiem bitow zaokroglania
shr $10, %ax # przesuwam w prawo, zwracany wynik w rax

movq %rbp, %rsp
pop %rbp
ret


ustaw:
push %rbp
movq %rsp, %rbp
# w rdi przeslany tryb zaokroaglania

movq $0, %rax  # zeruje ax
fstcw control_word  # pobieram slowo kontrolne
fwait
mov control_word, %ax  # slowo kontrolne w ax

and $0xF3FF, %ax # 1111 0011 1111 1111  zeruje bity zaokroglania
shl $10, %di # przeuwam w lewo przeslana wartosc
xor %di, %ax  # ustawiam wartosc

mov %ax, control_word  # ustawiam slowo kontrolne 
fldcw control_word

movq %rbp, %rsp
pop %rbp
ret
