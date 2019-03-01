
#include <stdio.h>

// Deklaracja funkcji które zostaną dołączone
// dopiero na etapie linkowania kodu
extern int sprawdz();
extern int ustaw(int tryb);

int main(void)
{
    int nr_opcji=1, tryb=1;
    do
    {
        printf("Wybierz:\n");
        printf("1 - sprawdz aktualny tryb zaokraglania\n");
        printf("2 - zmien aktualny tryb zaokraglania:\n");
        printf("0 - zakoncz program\n");
        scanf("%d", &nr_opcji);

        switch(nr_opcji)
        {
        case 1:
            printf("\nAktualny tryb zaokraglania: ");
            switch(sprawdz())
            {
                case 0: printf("Round to nearest\n\n"); break;
                case 1: printf("Round down\n\n"); break;
                case 2: printf("Round up\n\n"); break;
                case 3: printf("Truncate\n\n"); break;
            }
            break;

        case 2:
            printf("\n0 - Round to nearest\n");
            printf("1 - Round down\n");
            printf("2 - Round up\n");
            printf("3 - Truncate\n");
            scanf("%d", &tryb);
            if (tryb>3 || tryb<0) printf("Podano zla wartosc\n");
            else ustaw(tryb);
            printf("\n");
            break;
        }
    } while(nr_opcji!=0);

    return 0;
}
