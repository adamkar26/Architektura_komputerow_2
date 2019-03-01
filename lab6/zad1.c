#include <stdio.h>
#define N 16

short int tab1[N];
short int tab2[N];

void dodaj(short int vec1[], short int vec2[], int n);
extern void add(short int vec1[],short int vec2[],int n);

void mnoz(short int vec1[], short int vec2[], int n);
extern void multiply(short int vec1[],short int vec2[],int n);

unsigned long long rdtsc(void);

int main()
{
long long poczatek, koniec;
int n=N;
srand(time(NULL));
printf("wypelniam tablice\n" );
for(int i=0;i<N;i++)
{
  tab1[i]=rand()%100;
  tab2[i]=rand()%100;
}
poczatek=rdtsc();
dodaj(tab1,tab2,n);
koniec=rdtsc();
printf("Pomiar zakonczony- dodanie c: %llu \n",koniec-poczatek );

poczatek=rdtsc();
add(tab1,tab2,n/4);
koniec=rdtsc();
printf("Pomiar zakonczony- dodanie asm: %llu \n",koniec-poczatek );

poczatek=rdtsc();
mnoz(tab1,tab2,n);
koniec=rdtsc();
printf("Pomiar zakonczony- mnozenie c: %llu \n",koniec-poczatek );

poczatek=rdtsc();
multiply(tab1,tab2,n/4);
koniec=rdtsc();
printf("Pomiar zakonczony- mnzenie asm: %llu \n",koniec-poczatek );

  return 0;
}

void dodaj(short int vec1[],short int vec2[],int n)
{
  for(int i=0;i<n;i++)
  {
    vec2[i]=vec2[i]+vec1[i];
  }
}

void mnoz(short int vec1[],short int vec2[],int n)
{
  for(int i=0;i<n;i++)
  {
    vec2[i]=vec2[i]*vec1[i];
  }
}
