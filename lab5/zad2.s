.data
szereg: .double 1.0
potega: .double 1.0
silnia: .double 1.0
x: .double 0.0
licznik: .double 0.0

.text
.global taylor
.type taylor, @function

taylor:
push %rbp
movq %rsp, %rbp

# w xmm0 wykladnik -x w rdi liczba iteracji- n,

# zaladowanie x przez stos do st(0)
sub $8, %rsp
movsd %xmm0, (%rsp)
fldl (%rsp)
fstpl x  # zapis x

movq $0, %r8  # licznik petli
iteracja:
inc %r8
cmp %rdi, %r8
jg koniec

fldl potega
fmull x
fstpl potega # zapis potegi

fld1  # w st(0) 1
faddl licznik
fstpl licznik
fldl licznik
fmull silnia
fstpl silnia  # zapis silni


fldl potega
fdivl silnia # wytwarzam wyraz
faddl szereg
fstpl szereg # zapisuje szereg




jmp iteracja

koniec:
fldl szereg
  # przeniesienie przez stos wyniku do xmm0
fstpl  (%rsp)
movsd  (%rsp), %xmm0
movq %rbp, %rsp
pop %rbp
ret
