#include <stdio.h>
int liczba=1234;
char str[11]="0000000000";
int main()
{
  scanf("%d", &liczba);
  asm(
    "movq %1, %%rax \n"  // liczba w rax
    "movq $10, %%r8 \n"  //licznik petli
    "movq $8, %%r9 \n"  //podstawa zamiany
    "petla: \n"
    "movq $0, %%rdx \n"
    "div %%r9 \n"  // rax/8
    "addb $48,%%dl \n"
    "movb %%dl, (%0,%%r8,1) \n"
    "dec %%r8 \n"
    "cmp $0, %%rax \n"
    "jne petla \n"
    :
    : "r"(&str), "m"(liczba)
    :"%rax", "%r8", "%r9", "%rdx", "%rcx"
  );
  printf("%s /n", str );

  return 0;
}
