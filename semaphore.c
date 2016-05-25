#include "queue.c"

struct Semaphore
{
   int count;
   queue q;
};

void Sem_init(Semaphore * s, int v)
{
   s->count = v;
   init_q(&(s->q)); 
}

void sem_acquire(Semaphore *s)
{
   //if count is positive, decrement count
   if(s->count > 0)
   {
      (s->count)--;
   }
   //if count is zero, thread added to queue and waits
   else
   {
      add_queue(&(s->q),getpid());
      while(count == 0 || front(&(s->q)) != getpid()) wait();
   }
}

void sem_signal(Semaphore *s)
{
   //increment count
   (s->count)++;
}
