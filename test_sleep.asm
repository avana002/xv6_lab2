
_test_sleep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    int total;
}ttable;

void func(void *arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    struct thread * t;
    int i;
    printf(1,"init ttable\n");
   9:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 c8 05 00 00       	call   5e5 <printf>
    lock_init(&ttable.lock);
  1d:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
  24:	e8 9d 09 00 00       	call   9c6 <lock_init>
    ttable.total = 0;
  29:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
  30:	00 00 00 

    lock_acquire(&ttable.lock);
  33:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
  3a:	e8 95 09 00 00       	call   9d4 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  3f:	c7 44 24 14 04 0d 00 	movl   $0xd04,0x14(%esp)
  46:	00 
  47:	eb 0f                	jmp    58 <main+0x58>
        t->tid = 0;
  49:	8b 44 24 14          	mov    0x14(%esp),%eax
  4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    printf(1,"init ttable\n");
    lock_init(&ttable.lock);
    ttable.total = 0;

    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  53:	83 44 24 14 04       	addl   $0x4,0x14(%esp)
  58:	b8 04 0e 00 00       	mov    $0xe04,%eax
  5d:	39 44 24 14          	cmp    %eax,0x14(%esp)
  61:	72 e6                	jb     49 <main+0x49>
        t->tid = 0;
    }
    lock_release(&ttable.lock);
  63:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
  6a:	e8 84 09 00 00       	call   9f3 <lock_release>
    printf(1,"testing thread sleep and wakeup \n\n\n");
  6f:	c7 44 24 04 10 0c 00 	movl   $0xc10,0x4(%esp)
  76:	00 
  77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7e:	e8 62 05 00 00       	call   5e5 <printf>
    void *stack = thread_create(func,0);
  83:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8a:	00 
  8b:	c7 04 24 6c 01 00 00 	movl   $0x16c,(%esp)
  92:	e8 77 09 00 00       	call   a0e <thread_create>
  97:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    thread_create(func,0);
  9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a2:	00 
  a3:	c7 04 24 6c 01 00 00 	movl   $0x16c,(%esp)
  aa:	e8 5f 09 00 00       	call   a0e <thread_create>
    thread_create(func,0);
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	c7 04 24 6c 01 00 00 	movl   $0x16c,(%esp)
  be:	e8 4b 09 00 00       	call   a0e <thread_create>

    i=0;
  c3:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  ca:	00 
    while(i++ < 1000000);
  cb:	81 7c 24 18 3f 42 0f 	cmpl   $0xf423f,0x18(%esp)
  d2:	00 
  d3:	0f 9e c0             	setle  %al
  d6:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
  db:	84 c0                	test   %al,%al
  dd:	75 ec                	jne    cb <main+0xcb>
    //find that thread
    lock_acquire(&ttable.lock);
  df:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
  e6:	e8 e9 08 00 00       	call   9d4 <lock_acquire>
    for(t=ttable.threads;t < &ttable.threads[64];t++){
  eb:	c7 44 24 14 04 0d 00 	movl   $0xd04,0x14(%esp)
  f2:	00 
  f3:	eb 40                	jmp    135 <main+0x135>
        if(t->tid != 0){
  f5:	8b 44 24 14          	mov    0x14(%esp),%eax
  f9:	8b 00                	mov    (%eax),%eax
  fb:	85 c0                	test   %eax,%eax
  fd:	74 31                	je     130 <main+0x130>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
  ff:	8b 44 24 14          	mov    0x14(%esp),%eax
 103:	8b 00                	mov    (%eax),%eax
 105:	89 44 24 08          	mov    %eax,0x8(%esp)
 109:	c7 44 24 04 34 0c 00 	movl   $0xc34,0x4(%esp)
 110:	00 
 111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 118:	e8 c8 04 00 00       	call   5e5 <printf>
            twakeup(t->tid);
 11d:	8b 44 24 14          	mov    0x14(%esp),%eax
 121:	8b 00                	mov    (%eax),%eax
 123:	89 04 24             	mov    %eax,(%esp)
 126:	e8 d9 03 00 00       	call   504 <twakeup>
            i++;
 12b:	83 44 24 18 01       	addl   $0x1,0x18(%esp)

    i=0;
    while(i++ < 1000000);
    //find that thread
    lock_acquire(&ttable.lock);
    for(t=ttable.threads;t < &ttable.threads[64];t++){
 130:	83 44 24 14 04       	addl   $0x4,0x14(%esp)
 135:	b8 04 0e 00 00       	mov    $0xe04,%eax
 13a:	39 44 24 14          	cmp    %eax,0x14(%esp)
 13e:	72 b5                	jb     f5 <main+0xf5>
            printf(1,"found one... %d,   wake up lazy boy !!!\n",t->tid);
            twakeup(t->tid);
            i++;
        }
    }
    lock_release(&ttable.lock);
 140:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
 147:	e8 a7 08 00 00       	call   9f3 <lock_release>
    wait();
 14c:	e8 03 03 00 00       	call   454 <wait>
    wait();
 151:	e8 fe 02 00 00       	call   454 <wait>
    wait();
 156:	e8 f9 02 00 00       	call   454 <wait>
    free(stack);
 15b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15f:	89 04 24             	mov    %eax,(%esp)
 162:	e8 35 06 00 00       	call   79c <free>
    exit();
 167:	e8 e0 02 00 00       	call   44c <exit>

0000016c <func>:
}

void func(void *arg_ptr){
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	83 ec 28             	sub    $0x28,%esp
    int tid;
    tid = getpid();
 172:	e8 55 03 00 00       	call   4cc <getpid>
 177:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lock_acquire(&ttable.lock);
 17a:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
 181:	e8 4e 08 00 00       	call   9d4 <lock_acquire>
    (ttable.threads[ttable.total]).tid = tid;
 186:	a1 04 0e 00 00       	mov    0xe04,%eax
 18b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18e:	89 14 85 04 0d 00 00 	mov    %edx,0xd04(,%eax,4)
    ttable.total++;
 195:	a1 04 0e 00 00       	mov    0xe04,%eax
 19a:	83 c0 01             	add    $0x1,%eax
 19d:	a3 04 0e 00 00       	mov    %eax,0xe04
    lock_release(&ttable.lock);
 1a2:	c7 04 24 00 0d 00 00 	movl   $0xd00,(%esp)
 1a9:	e8 45 08 00 00       	call   9f3 <lock_release>

    printf(1,"I am thread %d, is about to sleep\n",tid);
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b5:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
 1bc:	00 
 1bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c4:	e8 1c 04 00 00       	call   5e5 <printf>
    tsleep();
 1c9:	e8 2e 03 00 00       	call   4fc <tsleep>
    printf(1,"I am wake up!\n");
 1ce:	c7 44 24 04 83 0c 00 	movl   $0xc83,0x4(%esp)
 1d5:	00 
 1d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1dd:	e8 03 04 00 00       	call   5e5 <printf>
    texit();
 1e2:	e8 0d 03 00 00       	call   4f4 <texit>
 1e7:	90                   	nop

000001e8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	57                   	push   %edi
 1ec:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f0:	8b 55 10             	mov    0x10(%ebp),%edx
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	89 cb                	mov    %ecx,%ebx
 1f8:	89 df                	mov    %ebx,%edi
 1fa:	89 d1                	mov    %edx,%ecx
 1fc:	fc                   	cld    
 1fd:	f3 aa                	rep stos %al,%es:(%edi)
 1ff:	89 ca                	mov    %ecx,%edx
 201:	89 fb                	mov    %edi,%ebx
 203:	89 5d 08             	mov    %ebx,0x8(%ebp)
 206:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 209:	5b                   	pop    %ebx
 20a:	5f                   	pop    %edi
 20b:	5d                   	pop    %ebp
 20c:	c3                   	ret    

0000020d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 20d:	55                   	push   %ebp
 20e:	89 e5                	mov    %esp,%ebp
 210:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	0f b6 10             	movzbl (%eax),%edx
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	88 10                	mov    %dl,(%eax)
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	0f 95 c0             	setne  %al
 22f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 233:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 237:	84 c0                	test   %al,%al
 239:	75 de                	jne    219 <strcpy+0xc>
    ;
  return os;
 23b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23e:	c9                   	leave  
 23f:	c3                   	ret    

00000240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 243:	eb 08                	jmp    24d <strcmp+0xd>
    p++, q++;
 245:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 249:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	84 c0                	test   %al,%al
 255:	74 10                	je     267 <strcmp+0x27>
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 10             	movzbl (%eax),%edx
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	0f b6 00             	movzbl (%eax),%eax
 263:	38 c2                	cmp    %al,%dl
 265:	74 de                	je     245 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	0f b6 d0             	movzbl %al,%edx
 270:	8b 45 0c             	mov    0xc(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	0f b6 c0             	movzbl %al,%eax
 279:	89 d1                	mov    %edx,%ecx
 27b:	29 c1                	sub    %eax,%ecx
 27d:	89 c8                	mov    %ecx,%eax
}
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    

00000281 <strlen>:

uint
strlen(char *s)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 28e:	eb 04                	jmp    294 <strlen+0x13>
 290:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 294:	8b 45 fc             	mov    -0x4(%ebp),%eax
 297:	03 45 08             	add    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	84 c0                	test   %al,%al
 29f:	75 ef                	jne    290 <strlen+0xf>
    ;
  return n;
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ac:	8b 45 10             	mov    0x10(%ebp),%eax
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	89 04 24             	mov    %eax,(%esp)
 2c0:	e8 23 ff ff ff       	call   1e8 <stosb>
  return dst;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <strchr>:

char*
strchr(const char *s, char c)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 04             	sub    $0x4,%esp
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d6:	eb 14                	jmp    2ec <strchr+0x22>
    if(*s == c)
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e1:	75 05                	jne    2e8 <strchr+0x1e>
      return (char*)s;
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	eb 13                	jmp    2fb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	84 c0                	test   %al,%al
 2f4:	75 e2                	jne    2d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fb:	c9                   	leave  
 2fc:	c3                   	ret    

000002fd <gets>:

char*
gets(char *buf, int max)
{
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 303:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 30a:	eb 44                	jmp    350 <gets+0x53>
    cc = read(0, &c, 1);
 30c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 313:	00 
 314:	8d 45 ef             	lea    -0x11(%ebp),%eax
 317:	89 44 24 04          	mov    %eax,0x4(%esp)
 31b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 322:	e8 3d 01 00 00       	call   464 <read>
 327:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 32a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 32e:	7e 2d                	jle    35d <gets+0x60>
      break;
    buf[i++] = c;
 330:	8b 45 f0             	mov    -0x10(%ebp),%eax
 333:	03 45 08             	add    0x8(%ebp),%eax
 336:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 33a:	88 10                	mov    %dl,(%eax)
 33c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 340:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 344:	3c 0a                	cmp    $0xa,%al
 346:	74 16                	je     35e <gets+0x61>
 348:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34c:	3c 0d                	cmp    $0xd,%al
 34e:	74 0e                	je     35e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	8b 45 f0             	mov    -0x10(%ebp),%eax
 353:	83 c0 01             	add    $0x1,%eax
 356:	3b 45 0c             	cmp    0xc(%ebp),%eax
 359:	7c b1                	jl     30c <gets+0xf>
 35b:	eb 01                	jmp    35e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 35d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 35e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 361:	03 45 08             	add    0x8(%ebp),%eax
 364:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36a:	c9                   	leave  
 36b:	c3                   	ret    

0000036c <stat>:

int
stat(char *n, struct stat *st)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 372:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 379:	00 
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 07 01 00 00       	call   48c <open>
 385:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 388:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 38c:	79 07                	jns    395 <stat+0x29>
    return -1;
 38e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 393:	eb 23                	jmp    3b8 <stat+0x4c>
  r = fstat(fd, st);
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 44 24 04          	mov    %eax,0x4(%esp)
 39c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 39f:	89 04 24             	mov    %eax,(%esp)
 3a2:	e8 fd 00 00 00       	call   4a4 <fstat>
 3a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 3aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3ad:	89 04 24             	mov    %eax,(%esp)
 3b0:	e8 bf 00 00 00       	call   474 <close>
  return r;
 3b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <atoi>:

int
atoi(const char *s)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c7:	eb 24                	jmp    3ed <atoi+0x33>
    n = n*10 + *s++ - '0';
 3c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cc:	89 d0                	mov    %edx,%eax
 3ce:	c1 e0 02             	shl    $0x2,%eax
 3d1:	01 d0                	add    %edx,%eax
 3d3:	01 c0                	add    %eax,%eax
 3d5:	89 c2                	mov    %eax,%edx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	0f be c0             	movsbl %al,%eax
 3e0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3e3:	83 e8 30             	sub    $0x30,%eax
 3e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	3c 2f                	cmp    $0x2f,%al
 3f5:	7e 0a                	jle    401 <atoi+0x47>
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3c 39                	cmp    $0x39,%al
 3ff:	7e c8                	jle    3c9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 401:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 404:	c9                   	leave  
 405:	c3                   	ret    

00000406 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 418:	eb 13                	jmp    42d <memmove+0x27>
    *dst++ = *src++;
 41a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41d:	0f b6 10             	movzbl (%eax),%edx
 420:	8b 45 f8             	mov    -0x8(%ebp),%eax
 423:	88 10                	mov    %dl,(%eax)
 425:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 429:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 42d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 431:	0f 9f c0             	setg   %al
 434:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 438:	84 c0                	test   %al,%al
 43a:	75 de                	jne    41a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43f:	c9                   	leave  
 440:	c3                   	ret    
 441:	90                   	nop
 442:	90                   	nop
 443:	90                   	nop

00000444 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 444:	b8 01 00 00 00       	mov    $0x1,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exit>:
SYSCALL(exit)
 44c:	b8 02 00 00 00       	mov    $0x2,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <wait>:
SYSCALL(wait)
 454:	b8 03 00 00 00       	mov    $0x3,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <pipe>:
SYSCALL(pipe)
 45c:	b8 04 00 00 00       	mov    $0x4,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <read>:
SYSCALL(read)
 464:	b8 05 00 00 00       	mov    $0x5,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <write>:
SYSCALL(write)
 46c:	b8 10 00 00 00       	mov    $0x10,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <close>:
SYSCALL(close)
 474:	b8 15 00 00 00       	mov    $0x15,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <kill>:
SYSCALL(kill)
 47c:	b8 06 00 00 00       	mov    $0x6,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <exec>:
SYSCALL(exec)
 484:	b8 07 00 00 00       	mov    $0x7,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <open>:
SYSCALL(open)
 48c:	b8 0f 00 00 00       	mov    $0xf,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <mknod>:
SYSCALL(mknod)
 494:	b8 11 00 00 00       	mov    $0x11,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <unlink>:
SYSCALL(unlink)
 49c:	b8 12 00 00 00       	mov    $0x12,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <fstat>:
SYSCALL(fstat)
 4a4:	b8 08 00 00 00       	mov    $0x8,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <link>:
SYSCALL(link)
 4ac:	b8 13 00 00 00       	mov    $0x13,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <mkdir>:
SYSCALL(mkdir)
 4b4:	b8 14 00 00 00       	mov    $0x14,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <chdir>:
SYSCALL(chdir)
 4bc:	b8 09 00 00 00       	mov    $0x9,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <dup>:
SYSCALL(dup)
 4c4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <getpid>:
SYSCALL(getpid)
 4cc:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sbrk>:
SYSCALL(sbrk)
 4d4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sleep>:
SYSCALL(sleep)
 4dc:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <uptime>:
SYSCALL(uptime)
 4e4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <clone>:
SYSCALL(clone)
 4ec:	b8 16 00 00 00       	mov    $0x16,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <texit>:
SYSCALL(texit)
 4f4:	b8 17 00 00 00       	mov    $0x17,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <tsleep>:
SYSCALL(tsleep)
 4fc:	b8 18 00 00 00       	mov    $0x18,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <twakeup>:
SYSCALL(twakeup)
 504:	b8 19 00 00 00       	mov    $0x19,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 28             	sub    $0x28,%esp
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 518:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51f:	00 
 520:	8d 45 f4             	lea    -0xc(%ebp),%eax
 523:	89 44 24 04          	mov    %eax,0x4(%esp)
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	89 04 24             	mov    %eax,(%esp)
 52d:	e8 3a ff ff ff       	call   46c <write>
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	53                   	push   %ebx
 538:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 542:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 546:	74 17                	je     55f <printint+0x2b>
 548:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54c:	79 11                	jns    55f <printint+0x2b>
    neg = 1;
 54e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 555:	8b 45 0c             	mov    0xc(%ebp),%eax
 558:	f7 d8                	neg    %eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55d:	eb 06                	jmp    565 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 55f:	8b 45 0c             	mov    0xc(%ebp),%eax
 562:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 565:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 56c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 56f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	ba 00 00 00 00       	mov    $0x0,%edx
 57a:	f7 f3                	div    %ebx
 57c:	89 d0                	mov    %edx,%eax
 57e:	0f b6 80 c8 0c 00 00 	movzbl 0xcc8(%eax),%eax
 585:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 589:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 58d:	8b 45 10             	mov    0x10(%ebp),%eax
 590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	ba 00 00 00 00       	mov    $0x0,%edx
 59b:	f7 75 d4             	divl   -0x2c(%ebp)
 59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a5:	75 c5                	jne    56c <printint+0x38>
  if(neg)
 5a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ab:	74 28                	je     5d5 <printint+0xa1>
    buf[i++] = '-';
 5ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 5b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 5b9:	eb 1a                	jmp    5d5 <printint+0xa1>
    putc(fd, buf[i]);
 5bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5be:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 37 ff ff ff       	call   50c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 5d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5dd:	79 dc                	jns    5bb <printint+0x87>
    putc(fd, buf[i]);
}
 5df:	83 c4 44             	add    $0x44,%esp
 5e2:	5b                   	pop    %ebx
 5e3:	5d                   	pop    %ebp
 5e4:	c3                   	ret    

000005e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e5:	55                   	push   %ebp
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f5:	83 c0 04             	add    $0x4,%eax
 5f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 602:	e9 7e 01 00 00       	jmp    785 <printf+0x1a0>
    c = fmt[i] & 0xff;
 607:	8b 55 0c             	mov    0xc(%ebp),%edx
 60a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 60d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	25 ff 00 00 00       	and    $0xff,%eax
 61b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 61e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 622:	75 2c                	jne    650 <printf+0x6b>
      if(c == '%'){
 624:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 628:	75 0c                	jne    636 <printf+0x51>
        state = '%';
 62a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 631:	e9 4b 01 00 00       	jmp    781 <printf+0x19c>
      } else {
        putc(fd, c);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 04 24             	mov    %eax,(%esp)
 646:	e8 c1 fe ff ff       	call   50c <putc>
 64b:	e9 31 01 00 00       	jmp    781 <printf+0x19c>
      }
    } else if(state == '%'){
 650:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 654:	0f 85 27 01 00 00    	jne    781 <printf+0x19c>
      if(c == 'd'){
 65a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 65e:	75 2d                	jne    68d <printf+0xa8>
        printint(fd, *ap, 10, 1);
 660:	8b 45 f4             	mov    -0xc(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 66c:	00 
 66d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 674:	00 
 675:	89 44 24 04          	mov    %eax,0x4(%esp)
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	89 04 24             	mov    %eax,(%esp)
 67f:	e8 b0 fe ff ff       	call   534 <printint>
        ap++;
 684:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 688:	e9 ed 00 00 00       	jmp    77a <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 68d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 691:	74 06                	je     699 <printf+0xb4>
 693:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 697:	75 2d                	jne    6c6 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 699:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6a5:	00 
 6a6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6ad:	00 
 6ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	89 04 24             	mov    %eax,(%esp)
 6b8:	e8 77 fe ff ff       	call   534 <printint>
        ap++;
 6bd:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6c1:	e9 b4 00 00 00       	jmp    77a <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6c6:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 6ca:	75 46                	jne    712 <printf+0x12d>
        s = (char*)*ap;
 6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 6d4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 6d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 6dc:	75 27                	jne    705 <printf+0x120>
          s = "(null)";
 6de:	c7 45 e4 92 0c 00 00 	movl   $0xc92,-0x1c(%ebp)
        while(*s != 0){
 6e5:	eb 1f                	jmp    706 <printf+0x121>
          putc(fd, *s);
 6e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	0f be c0             	movsbl %al,%eax
 6f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 0d fe ff ff       	call   50c <putc>
          s++;
 6ff:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 703:	eb 01                	jmp    706 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 705:	90                   	nop
 706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	84 c0                	test   %al,%al
 70e:	75 d7                	jne    6e7 <printf+0x102>
 710:	eb 68                	jmp    77a <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 712:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 716:	75 1d                	jne    735 <printf+0x150>
        putc(fd, *ap);
 718:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 dd fd ff ff       	call   50c <putc>
        ap++;
 72f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 733:	eb 45                	jmp    77a <printf+0x195>
      } else if(c == '%'){
 735:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 739:	75 17                	jne    752 <printf+0x16d>
        putc(fd, c);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	0f be c0             	movsbl %al,%eax
 741:	89 44 24 04          	mov    %eax,0x4(%esp)
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	89 04 24             	mov    %eax,(%esp)
 74b:	e8 bc fd ff ff       	call   50c <putc>
 750:	eb 28                	jmp    77a <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 752:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 759:	00 
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 a7 fd ff ff       	call   50c <putc>
        putc(fd, c);
 765:	8b 45 e8             	mov    -0x18(%ebp),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	89 44 24 04          	mov    %eax,0x4(%esp)
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 92 fd ff ff       	call   50c <putc>
      }
      state = 0;
 77a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 781:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 785:	8b 55 0c             	mov    0xc(%ebp),%edx
 788:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 78e:	0f b6 00             	movzbl (%eax),%eax
 791:	84 c0                	test   %al,%al
 793:	0f 85 6e fe ff ff    	jne    607 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 799:	c9                   	leave  
 79a:	c3                   	ret    
 79b:	90                   	nop

0000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	83 e8 08             	sub    $0x8,%eax
 7a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ab:	a1 e8 0c 00 00       	mov    0xce8,%eax
 7b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b3:	eb 24                	jmp    7d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bd:	77 12                	ja     7d1 <free+0x35>
 7bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c5:	77 24                	ja     7eb <free+0x4f>
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cf:	77 1a                	ja     7eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7df:	76 d4                	jbe    7b5 <free+0x19>
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e9:	76 ca                	jbe    7b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	c1 e0 03             	shl    $0x3,%eax
 7f4:	89 c2                	mov    %eax,%edx
 7f6:	03 55 f8             	add    -0x8(%ebp),%edx
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	39 c2                	cmp    %eax,%edx
 800:	75 24                	jne    826 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	8b 50 04             	mov    0x4(%eax),%edx
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	01 c2                	add    %eax,%edx
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
 824:	eb 0a                	jmp    830 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 10                	mov    (%eax),%edx
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	c1 e0 03             	shl    $0x3,%eax
 839:	03 45 fc             	add    -0x4(%ebp),%eax
 83c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83f:	75 20                	jne    861 <free+0xc5>
    p->s.size += bp->s.size;
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 50 04             	mov    0x4(%eax),%edx
 847:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	01 c2                	add    %eax,%edx
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 855:	8b 45 f8             	mov    -0x8(%ebp),%eax
 858:	8b 10                	mov    (%eax),%edx
 85a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85d:	89 10                	mov    %edx,(%eax)
 85f:	eb 08                	jmp    869 <free+0xcd>
  } else
    p->s.ptr = bp;
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	8b 55 f8             	mov    -0x8(%ebp),%edx
 867:	89 10                	mov    %edx,(%eax)
  freep = p;
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	a3 e8 0c 00 00       	mov    %eax,0xce8
}
 871:	c9                   	leave  
 872:	c3                   	ret    

00000873 <morecore>:

static Header*
morecore(uint nu)
{
 873:	55                   	push   %ebp
 874:	89 e5                	mov    %esp,%ebp
 876:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 879:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 880:	77 07                	ja     889 <morecore+0x16>
    nu = 4096;
 882:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 889:	8b 45 08             	mov    0x8(%ebp),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	89 04 24             	mov    %eax,(%esp)
 892:	e8 3d fc ff ff       	call   4d4 <sbrk>
 897:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 89a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 89e:	75 07                	jne    8a7 <morecore+0x34>
    return 0;
 8a0:	b8 00 00 00 00       	mov    $0x0,%eax
 8a5:	eb 22                	jmp    8c9 <morecore+0x56>
  hp = (Header*)p;
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 55 08             	mov    0x8(%ebp),%edx
 8b3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	83 c0 08             	add    $0x8,%eax
 8bc:	89 04 24             	mov    %eax,(%esp)
 8bf:	e8 d8 fe ff ff       	call   79c <free>
  return freep;
 8c4:	a1 e8 0c 00 00       	mov    0xce8,%eax
}
 8c9:	c9                   	leave  
 8ca:	c3                   	ret    

000008cb <malloc>:

void*
malloc(uint nbytes)
{
 8cb:	55                   	push   %ebp
 8cc:	89 e5                	mov    %esp,%ebp
 8ce:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d1:	8b 45 08             	mov    0x8(%ebp),%eax
 8d4:	83 c0 07             	add    $0x7,%eax
 8d7:	c1 e8 03             	shr    $0x3,%eax
 8da:	83 c0 01             	add    $0x1,%eax
 8dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 8e0:	a1 e8 0c 00 00       	mov    0xce8,%eax
 8e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ec:	75 23                	jne    911 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ee:	c7 45 f0 e0 0c 00 00 	movl   $0xce0,-0x10(%ebp)
 8f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f8:	a3 e8 0c 00 00       	mov    %eax,0xce8
 8fd:	a1 e8 0c 00 00       	mov    0xce8,%eax
 902:	a3 e0 0c 00 00       	mov    %eax,0xce0
    base.s.size = 0;
 907:	c7 05 e4 0c 00 00 00 	movl   $0x0,0xce4
 90e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 919:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91c:	8b 40 04             	mov    0x4(%eax),%eax
 91f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 922:	72 4d                	jb     971 <malloc+0xa6>
      if(p->s.size == nunits)
 924:	8b 45 ec             	mov    -0x14(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 92d:	75 0c                	jne    93b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 92f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 f0             	mov    -0x10(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
 939:	eb 26                	jmp    961 <malloc+0x96>
      else {
        p->s.size -= nunits;
 93b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93e:	8b 40 04             	mov    0x4(%eax),%eax
 941:	89 c2                	mov    %eax,%edx
 943:	2b 55 f4             	sub    -0xc(%ebp),%edx
 946:	8b 45 ec             	mov    -0x14(%ebp),%eax
 949:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 94c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	c1 e0 03             	shl    $0x3,%eax
 955:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 958:	8b 45 ec             	mov    -0x14(%ebp),%eax
 95b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 95e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 961:	8b 45 f0             	mov    -0x10(%ebp),%eax
 964:	a3 e8 0c 00 00       	mov    %eax,0xce8
      return (void*)(p + 1);
 969:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96c:	83 c0 08             	add    $0x8,%eax
 96f:	eb 38                	jmp    9a9 <malloc+0xde>
    }
    if(p == freep)
 971:	a1 e8 0c 00 00       	mov    0xce8,%eax
 976:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 979:	75 1b                	jne    996 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	89 04 24             	mov    %eax,(%esp)
 981:	e8 ed fe ff ff       	call   873 <morecore>
 986:	89 45 ec             	mov    %eax,-0x14(%ebp)
 989:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 98d:	75 07                	jne    996 <malloc+0xcb>
        return 0;
 98f:	b8 00 00 00 00       	mov    $0x0,%eax
 994:	eb 13                	jmp    9a9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 996:	8b 45 ec             	mov    -0x14(%ebp),%eax
 999:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a4:	e9 70 ff ff ff       	jmp    919 <malloc+0x4e>
}
 9a9:	c9                   	leave  
 9aa:	c3                   	ret    
 9ab:	90                   	nop

000009ac <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 9ac:	55                   	push   %ebp
 9ad:	89 e5                	mov    %esp,%ebp
 9af:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 9b2:	8b 55 08             	mov    0x8(%ebp),%edx
 9b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9bb:	f0 87 02             	lock xchg %eax,(%edx)
 9be:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9c4:	c9                   	leave  
 9c5:	c3                   	ret    

000009c6 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 9c6:	55                   	push   %ebp
 9c7:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
 9cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9d2:	5d                   	pop    %ebp
 9d3:	c3                   	ret    

000009d4 <lock_acquire>:
void lock_acquire(lock_t *lock){
 9d4:	55                   	push   %ebp
 9d5:	89 e5                	mov    %esp,%ebp
 9d7:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9e4:	00 
 9e5:	89 04 24             	mov    %eax,(%esp)
 9e8:	e8 bf ff ff ff       	call   9ac <xchg>
 9ed:	85 c0                	test   %eax,%eax
 9ef:	75 e9                	jne    9da <lock_acquire+0x6>
}
 9f1:	c9                   	leave  
 9f2:	c3                   	ret    

000009f3 <lock_release>:
void lock_release(lock_t *lock){
 9f3:	55                   	push   %ebp
 9f4:	89 e5                	mov    %esp,%ebp
 9f6:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9f9:	8b 45 08             	mov    0x8(%ebp),%eax
 9fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 a03:	00 
 a04:	89 04 24             	mov    %eax,(%esp)
 a07:	e8 a0 ff ff ff       	call   9ac <xchg>
}
 a0c:	c9                   	leave  
 a0d:	c3                   	ret    

00000a0e <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 a0e:	55                   	push   %ebp
 a0f:	89 e5                	mov    %esp,%ebp
 a11:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 a14:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 a1b:	e8 ab fe ff ff       	call   8cb <malloc>
 a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2c:	25 ff 0f 00 00       	and    $0xfff,%eax
 a31:	85 c0                	test   %eax,%eax
 a33:	74 15                	je     a4a <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	89 c2                	mov    %eax,%edx
 a3a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 a40:	b8 00 10 00 00       	mov    $0x1000,%eax
 a45:	29 d0                	sub    %edx,%eax
 a47:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4e:	75 1b                	jne    a6b <thread_create+0x5d>

        printf(1,"malloc fail \n");
 a50:	c7 44 24 04 99 0c 00 	movl   $0xc99,0x4(%esp)
 a57:	00 
 a58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a5f:	e8 81 fb ff ff       	call   5e5 <printf>
        return 0;
 a64:	b8 00 00 00 00       	mov    $0x0,%eax
 a69:	eb 6f                	jmp    ada <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a6e:	8b 55 08             	mov    0x8(%ebp),%edx
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a78:	89 54 24 08          	mov    %edx,0x8(%esp)
 a7c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a83:	00 
 a84:	89 04 24             	mov    %eax,(%esp)
 a87:	e8 60 fa ff ff       	call   4ec <clone>
 a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a93:	79 1b                	jns    ab0 <thread_create+0xa2>
        printf(1,"clone fails\n");
 a95:	c7 44 24 04 a7 0c 00 	movl   $0xca7,0x4(%esp)
 a9c:	00 
 a9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aa4:	e8 3c fb ff ff       	call   5e5 <printf>
        return 0;
 aa9:	b8 00 00 00 00       	mov    $0x0,%eax
 aae:	eb 2a                	jmp    ada <thread_create+0xcc>
    }
    if(tid > 0){
 ab0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ab4:	7e 05                	jle    abb <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab9:	eb 1f                	jmp    ada <thread_create+0xcc>
    }
    if(tid == 0){
 abb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 abf:	75 14                	jne    ad5 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 ac1:	c7 44 24 04 b4 0c 00 	movl   $0xcb4,0x4(%esp)
 ac8:	00 
 ac9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ad0:	e8 10 fb ff ff       	call   5e5 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ada:	c9                   	leave  
 adb:	c3                   	ret    

00000adc <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 adc:	55                   	push   %ebp
 add:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 adf:	8b 45 08             	mov    0x8(%ebp),%eax
 ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ae8:	8b 45 08             	mov    0x8(%ebp),%eax
 aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 af2:	8b 45 08             	mov    0x8(%ebp),%eax
 af5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 afc:	5d                   	pop    %ebp
 afd:	c3                   	ret    

00000afe <add_q>:

void add_q(struct queue *q, int v){
 afe:	55                   	push   %ebp
 aff:	89 e5                	mov    %esp,%ebp
 b01:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 b04:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 b0b:	e8 bb fd ff ff       	call   8cb <malloc>
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b20:	8b 55 0c             	mov    0xc(%ebp),%edx
 b23:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b25:	8b 45 08             	mov    0x8(%ebp),%eax
 b28:	8b 40 04             	mov    0x4(%eax),%eax
 b2b:	85 c0                	test   %eax,%eax
 b2d:	75 0b                	jne    b3a <add_q+0x3c>
        q->head = n;
 b2f:	8b 45 08             	mov    0x8(%ebp),%eax
 b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b35:	89 50 04             	mov    %edx,0x4(%eax)
 b38:	eb 0c                	jmp    b46 <add_q+0x48>
    }else{
        q->tail->next = n;
 b3a:	8b 45 08             	mov    0x8(%ebp),%eax
 b3d:	8b 40 08             	mov    0x8(%eax),%eax
 b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b43:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b46:	8b 45 08             	mov    0x8(%ebp),%eax
 b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b4c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b4f:	8b 45 08             	mov    0x8(%ebp),%eax
 b52:	8b 00                	mov    (%eax),%eax
 b54:	8d 50 01             	lea    0x1(%eax),%edx
 b57:	8b 45 08             	mov    0x8(%ebp),%eax
 b5a:	89 10                	mov    %edx,(%eax)
}
 b5c:	c9                   	leave  
 b5d:	c3                   	ret    

00000b5e <empty_q>:

int empty_q(struct queue *q){
 b5e:	55                   	push   %ebp
 b5f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b61:	8b 45 08             	mov    0x8(%ebp),%eax
 b64:	8b 00                	mov    (%eax),%eax
 b66:	85 c0                	test   %eax,%eax
 b68:	75 07                	jne    b71 <empty_q+0x13>
        return 1;
 b6a:	b8 01 00 00 00       	mov    $0x1,%eax
 b6f:	eb 05                	jmp    b76 <empty_q+0x18>
    else
        return 0;
 b71:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b76:	5d                   	pop    %ebp
 b77:	c3                   	ret    

00000b78 <pop_q>:
int pop_q(struct queue *q){
 b78:	55                   	push   %ebp
 b79:	89 e5                	mov    %esp,%ebp
 b7b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b7e:	8b 45 08             	mov    0x8(%ebp),%eax
 b81:	89 04 24             	mov    %eax,(%esp)
 b84:	e8 d5 ff ff ff       	call   b5e <empty_q>
 b89:	85 c0                	test   %eax,%eax
 b8b:	75 5d                	jne    bea <pop_q+0x72>
       val = q->head->value; 
 b8d:	8b 45 08             	mov    0x8(%ebp),%eax
 b90:	8b 40 04             	mov    0x4(%eax),%eax
 b93:	8b 00                	mov    (%eax),%eax
 b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 b98:	8b 45 08             	mov    0x8(%ebp),%eax
 b9b:	8b 40 04             	mov    0x4(%eax),%eax
 b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 ba1:	8b 45 08             	mov    0x8(%ebp),%eax
 ba4:	8b 40 04             	mov    0x4(%eax),%eax
 ba7:	8b 50 04             	mov    0x4(%eax),%edx
 baa:	8b 45 08             	mov    0x8(%ebp),%eax
 bad:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb3:	89 04 24             	mov    %eax,(%esp)
 bb6:	e8 e1 fb ff ff       	call   79c <free>
       q->size--;
 bbb:	8b 45 08             	mov    0x8(%ebp),%eax
 bbe:	8b 00                	mov    (%eax),%eax
 bc0:	8d 50 ff             	lea    -0x1(%eax),%edx
 bc3:	8b 45 08             	mov    0x8(%ebp),%eax
 bc6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 bc8:	8b 45 08             	mov    0x8(%ebp),%eax
 bcb:	8b 00                	mov    (%eax),%eax
 bcd:	85 c0                	test   %eax,%eax
 bcf:	75 14                	jne    be5 <pop_q+0x6d>
            q->head = 0;
 bd1:	8b 45 08             	mov    0x8(%ebp),%eax
 bd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bdb:	8b 45 08             	mov    0x8(%ebp),%eax
 bde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be8:	eb 05                	jmp    bef <pop_q+0x77>
    }
    return -1;
 bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bef:	c9                   	leave  
 bf0:	c3                   	ret    

00000bf1 <front>:

int front(struct queue *q)
{
 bf1:	55                   	push   %ebp
 bf2:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 bf4:	8b 45 08             	mov    0x8(%ebp),%eax
 bf7:	8b 40 04             	mov    0x4(%eax),%eax
 bfa:	8b 00                	mov    (%eax),%eax
}
 bfc:	5d                   	pop    %ebp
 bfd:	c3                   	ret    
