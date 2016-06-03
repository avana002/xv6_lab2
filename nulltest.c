//#include <stdio.h>
#include "types.h"
#include "user.h"
//#include <stdlib.h>

void nulltest()
{
   int* i = (int*)0;
   //int* j = *i;
   (*i)++;
}

int main()
{
   //int* ptr;
   //ptr = 0;
   //if(*((int*)0) == 0 || 1) printf(1,"pointer dereferenced\n");
   //int i = *ptr;
   //i++;
   nulltest();
   exit();
}
