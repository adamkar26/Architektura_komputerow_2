.text
.global rdtsc

.type rdtsc, @function

rdtsc:
push %rbp
movq %rsp, %rbp

movq $0, %eax
movq $0, %edx
rdtsc # wynik w rax


mov %rbp, %rsp
pop %rbp
ret # Powrót do miejsca wywołania funkcji
