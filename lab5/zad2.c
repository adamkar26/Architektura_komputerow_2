
#include <stdio.h>

extern double taylor(double a, int b);

int main(void)
{
    int i;
    double f;
    printf("wykladnik: ");
    scanf("%lf", &f);
    printf("Liczba wyrazow ciagu: ");
    scanf("%d", &i);
    printf("Twoj wynik to: %lf\n", taylor(f, i));
    return 0;
}
