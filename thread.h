#include "types.h"

void lock_init(lock_t *);

void lock_acquire(lock_t *);

void lock_release(lock_t *);

void thread_yield();

void *thread_create(void(*)(void*), void *);
