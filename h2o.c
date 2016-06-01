#include "semaphore.c"
#include "thread.c"
//#include <stdio.h>

int water = 0;

int main()
{
   Semaphore h,o,l;
   Sem_init(&h, 0);
   Sem_init(&o, 0);
   Sem_init(&l, 1);

   thread_create(hReady, void* v);
   thread_create(hReady, void* v);  
   thread_create(oReady, void* v);
}

void hReady(void* v)
{
   sem_signal(&h);
   sem_acquire(&o);
}

void oReady(void* v)
{
   sem_acquire(&h);
   sem_acquire(&h);
   sem_signal(&o);
   sem_signal(&o);
   sem_acquire(&l);
   water++;
   printf("water created\n");
   sem_signal(&l);
}
