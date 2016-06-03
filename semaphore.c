#include "queue.h"
#include "types.h"
#include "user.h"

#ifndef _SEMAPHORE_
#define _SEMAPHORE_

int wait(void);
int getpid(void);

struct Semaphore
{
   int count;
   struct queue q;
};

typedef struct Semaphore Semaphore;

int sem_count(Semaphore* s)
{
   return s->count;
}

void Sem_init(Semaphore *s, int v)
{
   s->count = v;
   init_q(&(s->q)); 
}

void sem_acquire(Semaphore *s)
{
   //if count is positive, decrement count
   if(s->count > 0)
   {
     // printf(1,"count is positive\n");
      (s->count)--;
   }
   //if count is zero, thread added to queue and waits
   else
   {
    // printf(1,"count is zero\n"); 
     add_q(&(s->q),getpid());
      while(s->count == 0 || (front(&(s->q)) != getpid())) wait();
      pop_q(&(s->q));
   }
}

void sem_signal(Semaphore *s)
{
   //increment count
   (s->count)++;
}

#endif
