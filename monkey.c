#include "semaphore.c"
#include "thread.h"

Semaphore t;

int coconuts = 0;
int dominant = 0;

void monkey(void* v)
{
   int i = (int)v;
   while(dominant > 0);
   sem_acquire(&t);
   printf(1,"%d\n",i);
   coconuts++;
   int j;
   for(j = 0; j < 100000; j++);
   printf(1,"%d\n",i);
   sem_signal(&t);
   texit();
}

void dmonkey(void* v)
{
   int i = (int)v;
   dominant++;
   sem_acquire(&t);
   dominant--;
   printf(1,"d%d\n",i);
   coconuts++;
   int j;
   for(j = 0; j < 100000; j++);
   printf(1,"d%d\n",i);
   sem_signal(&t);
   texit();
}

void part_one()
{
   int i;
   for(i = 1; i < 15; i++)
   {
      thread_create(monkey,(void*)i);
   }

   while(wait() >= 0);
}

void part_two()
{
   int i;
   for(i = 1; i < 5; i++)
   {
      thread_create(monkey,(void*)i);
   }
   thread_create(dmonkey,(void*)1);
   for(i = i; i < 10; i++)
   {
      thread_create(monkey,(void*)i);
   }
  
   while(wait() >= 0);
}   

int main()
{
   Sem_init(&t, 3);


   //part_one();
   part_two();

   exit();

}


