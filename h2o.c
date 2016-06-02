#include "semaphore.c"
#include "thread.h"
#include "user.h"
//#include "queue.c"
//#include <stdio.h>

void hReady(void*);
void oReady(void*);

int water = 0;

//struct Semaphore h,o,l;

int main()
{
/*
   //Semaphore h,o,l;
   Sem_init(&h, 0);
   Sem_init(&o, 0);
   Sem_init(&l, 1);

   thread_create(hReady,(void*)&water);
   thread_create(hReady,(void*)&water);  
   thread_create(oReady,(void*)&water);
*/
   exit();
}

void hReady(void* v)
{
 //  sem_signal(&h);
 //  sem_acquire(&o);
 texit();
}

void oReady(void* v)
{/*
   sem_acquire(&h);
   sem_acquire(&h);
   sem_signal(&o);
   sem_signal(&o);
   sem_acquire(&l);
   water++;
   //printf(0,"water created\n");
   sem_signal(&l);
*/
  texit();
}
