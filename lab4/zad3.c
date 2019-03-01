#include <stdio.h>
int liczba;
char pierwsze[20];
int ilosc;
extern int funkcja(int liczba,char* pierwsze);

int main()
{
  scanf("%d",&liczba);
  ilosc=funkcja(liczba,pierwsze);
  for(int i=0; i<ilosc;i++)
  {
    printf("%c \n", pierwsze[i]);
  }
  return 0;
}
