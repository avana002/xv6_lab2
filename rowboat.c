#include "semaphore.c"
#include "thread.h"


Semaphore l;
Semaphore m;
Semaphore c;

int miss = 0;
int cann = 0;

void rowboat()
{
   printf(1,"Rowboat sent\n");
}

void missionary(void* v)
{
   sem_acquire(&l);
   miss++;
   if(miss+cann<3 || miss == 1)
   {
      sem_signal(&l);
      sem_acquire(&m);
      sem_acquire(&l);
   }
   else
   {
      if(cann >= 1)
      {
         miss = miss-2;
         cann--;
         sem_signal(&m);
         sem_signal(&c);
      }
      else
      {
         miss = miss - 3;
         sem_signal(&m);
         sem_signal(&m);
      }
   }
   sem_signal(&l);
   rowboat();

   texit();
}

void cannibal(void* v)
{
   sem_acquire(&l);
   cann++;
   if(miss+cann<3 || (miss==1 && cann==2))
   {
      sem_signal(&l);
      sem_acquire(&c);
   }
   else
   {
      if(miss>=2)
      {
         miss=miss-2;   
         cann--;
         sem_signal(&m);
         sem_signal(&m);
         sem_signal(&l);
      }
      else
      {
         cann = cann -3;
         sem_signal(&c);
         sem_signal(&c);
         sem_signal(&l);
         rowboat();
      }
   }
   texit();
}

int main()
{
   Sem_init(&l, 1);
   Sem_init(&m, 0);
   Sem_init(&c, 0);

   //while(wait() >= 0); 

   exit();

}
