#include <stdio.h>

int main()
{
   int* ptr;
   ptr = 0;
   if(*ptr == 0 || 1) printf("pointer dereferenced\n");
   return 0;
}
