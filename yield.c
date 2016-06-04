#include "types.h"
#include "user.h"
#include "thread.h"


void A(void* v)
{
  thread_yield();
   printf(1, "A\n");
   
   texit();
}

void B(void* v)
{
  printf(1, "B\n");
   thread_yield(); 

  texit();
}

int main()
{
   thread_create(A, (void*)0);
   thread_create(B, (void*)0);
   exit();
}








