#include <stdio.h>

extern double taylor(double x, int n);

int main()
{
  double x;
  int n;
  printf("x= ");
  scanf("%lf \n", &x);
  printf("n= ");
  scanf("%d \n", &n);
  printf("%f\n", taylor(x,n) );
  return 0;
}
