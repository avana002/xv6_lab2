
_test1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

int n = 1;

void test_func(void *arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp


   int pid = fork();
   9:	e8 de 04 00 00       	call   4ec <fork>
   e:	89 44 24 14          	mov    %eax,0x14(%esp)
    if(pid == 0){
  12:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  17:	0f 85 43 01 00 00    	jne    160 <main+0x160>
        void *tid = thread_create(test_func,(void *)0);
  1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  24:	00 
  25:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
  2c:	e8 85 0a 00 00       	call   ab6 <thread_create>
  31:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
  35:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  3a:	75 19                	jne    55 <main+0x55>
            printf(1,"thread_create fails\n");
  3c:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 3d 06 00 00       	call   68d <printf>
            exit();
  50:	e8 9f 04 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  55:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
  64:	e8 4d 0a 00 00       	call   ab6 <thread_create>
  69:	89 44 24 18          	mov    %eax,0x18(%esp)
        if(tid == 0){
  6d:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  72:	75 19                	jne    8d <main+0x8d>
            printf(1,"thread_create fails\n");
  74:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 05 06 00 00       	call   68d <printf>
            exit();
  88:	e8 67 04 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  94:	00 
  95:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
  9c:	e8 15 0a 00 00       	call   ab6 <thread_create>
  a1:	89 44 24 18          	mov    %eax,0x18(%esp)
         if(tid == 0){
  a5:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  aa:	75 19                	jne    c5 <main+0xc5>
            printf(1,"thread_create fails\n");
  ac:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
  b3:	00 
  b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bb:	e8 cd 05 00 00       	call   68d <printf>
            exit();
  c0:	e8 2f 04 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
  c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  cc:	00 
  cd:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
  d4:	e8 dd 09 00 00       	call   ab6 <thread_create>
  d9:	89 44 24 18          	mov    %eax,0x18(%esp)
          if(tid == 0){
  dd:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  e2:	75 19                	jne    fd <main+0xfd>
            printf(1,"thread_create fails\n");
  e4:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 95 05 00 00       	call   68d <printf>
            exit();
  f8:	e8 f7 03 00 00       	call   4f4 <exit>
        }
       tid = thread_create(test_func,(void *)0);
  fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 104:	00 
 105:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
 10c:	e8 a5 09 00 00       	call   ab6 <thread_create>
 111:	89 44 24 18          	mov    %eax,0x18(%esp)
           if(tid == 0){
 115:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 11a:	75 19                	jne    135 <main+0x135>
            printf(1,"thread_create fails\n");
 11c:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
 123:	00 
 124:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12b:	e8 5d 05 00 00       	call   68d <printf>
            exit();
 130:	e8 bf 03 00 00       	call   4f4 <exit>
        }
      while(wait()>=0);
 135:	e8 c2 03 00 00       	call   4fc <wait>
 13a:	85 c0                	test   %eax,%eax
 13c:	79 f7                	jns    135 <main+0x135>
        printf(1,"I am child, [6] n = %d\n",n);
 13e:	a1 20 0d 00 00       	mov    0xd20,%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	c7 44 24 04 bb 0c 00 	movl   $0xcbb,0x4(%esp)
 14e:	00 
 14f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 156:	e8 32 05 00 00       	call   68d <printf>
 15b:	e9 11 01 00 00       	jmp    271 <main+0x271>
    }else if(pid > 0){
 160:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 165:	0f 8e 06 01 00 00    	jle    271 <main+0x271>
        void *tid = thread_create(test_func,(void *)0);
 16b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 172:	00 
 173:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
 17a:	e8 37 09 00 00       	call   ab6 <thread_create>
 17f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
         if(tid == 0){
 183:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 188:	75 19                	jne    1a3 <main+0x1a3>
            printf(1,"thread_create fails\n");
 18a:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
 191:	00 
 192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 199:	e8 ef 04 00 00       	call   68d <printf>
            exit();
 19e:	e8 51 03 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 1a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1aa:	00 
 1ab:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
 1b2:	e8 ff 08 00 00       	call   ab6 <thread_create>
 1b7:	89 44 24 1c          	mov    %eax,0x1c(%esp)
         if(tid == 0){
 1bb:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 1c0:	75 19                	jne    1db <main+0x1db>
            printf(1,"thread_create fails\n");
 1c2:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
 1c9:	00 
 1ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d1:	e8 b7 04 00 00       	call   68d <printf>
            exit();
 1d6:	e8 19 03 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 1db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1e2:	00 
 1e3:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
 1ea:	e8 c7 08 00 00       	call   ab6 <thread_create>
 1ef:	89 44 24 1c          	mov    %eax,0x1c(%esp)
         if(tid == 0){
 1f3:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 1f8:	75 19                	jne    213 <main+0x213>
            printf(1,"thread_create fails\n");
 1fa:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
 201:	00 
 202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 209:	e8 7f 04 00 00       	call   68d <printf>
            exit();
 20e:	e8 e1 02 00 00       	call   4f4 <exit>
        }
        tid = thread_create(test_func,(void *)0);
 213:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21a:	00 
 21b:	c7 04 24 76 02 00 00 	movl   $0x276,(%esp)
 222:	e8 8f 08 00 00       	call   ab6 <thread_create>
 227:	89 44 24 1c          	mov    %eax,0x1c(%esp)
         if(tid == 0){
 22b:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 230:	75 19                	jne    24b <main+0x24b>
            printf(1,"thread_create fails\n");
 232:	c7 44 24 04 a6 0c 00 	movl   $0xca6,0x4(%esp)
 239:	00 
 23a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 241:	e8 47 04 00 00       	call   68d <printf>
            exit();
 246:	e8 a9 02 00 00       	call   4f4 <exit>
        }
        while(wait()>=0);
 24b:	e8 ac 02 00 00       	call   4fc <wait>
 250:	85 c0                	test   %eax,%eax
 252:	79 f7                	jns    24b <main+0x24b>
        printf(1,"I am parent, [5] n = %d\n",n);
 254:	a1 20 0d 00 00       	mov    0xd20,%eax
 259:	89 44 24 08          	mov    %eax,0x8(%esp)
 25d:	c7 44 24 04 d3 0c 00 	movl   $0xcd3,0x4(%esp)
 264:	00 
 265:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26c:	e8 1c 04 00 00       	call   68d <printf>
    }

   exit();
 271:	e8 7e 02 00 00       	call   4f4 <exit>

00000276 <test_func>:
}

void test_func(void *arg_ptr){
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 08             	sub    $0x8,%esp
//    printf(1,"\n n = %d\n",n);
    n++;
 27c:	a1 20 0d 00 00       	mov    0xd20,%eax
 281:	83 c0 01             	add    $0x1,%eax
 284:	a3 20 0d 00 00       	mov    %eax,0xd20
   // printf(1,"after increase by 1 , n = %d\n\n",n);
    texit();
 289:	e8 0e 03 00 00       	call   59c <texit>
 28e:	90                   	nop
 28f:	90                   	nop

00000290 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 295:	8b 4d 08             	mov    0x8(%ebp),%ecx
 298:	8b 55 10             	mov    0x10(%ebp),%edx
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 cb                	mov    %ecx,%ebx
 2a0:	89 df                	mov    %ebx,%edi
 2a2:	89 d1                	mov    %edx,%ecx
 2a4:	fc                   	cld    
 2a5:	f3 aa                	rep stos %al,%es:(%edi)
 2a7:	89 ca                	mov    %ecx,%edx
 2a9:	89 fb                	mov    %edi,%ebx
 2ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2b1:	5b                   	pop    %ebx
 2b2:	5f                   	pop    %edi
 2b3:	5d                   	pop    %ebp
 2b4:	c3                   	ret    

000002b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	0f b6 10             	movzbl (%eax),%edx
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	88 10                	mov    %dl,(%eax)
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	84 c0                	test   %al,%al
 2d4:	0f 95 c0             	setne  %al
 2d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 2df:	84 c0                	test   %al,%al
 2e1:	75 de                	jne    2c1 <strcpy+0xc>
    ;
  return os;
 2e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e6:	c9                   	leave  
 2e7:	c3                   	ret    

000002e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2eb:	eb 08                	jmp    2f5 <strcmp+0xd>
    p++, q++;
 2ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	84 c0                	test   %al,%al
 2fd:	74 10                	je     30f <strcmp+0x27>
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 10             	movzbl (%eax),%edx
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	38 c2                	cmp    %al,%dl
 30d:	74 de                	je     2ed <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	0f b6 d0             	movzbl %al,%edx
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	0f b6 00             	movzbl (%eax),%eax
 31e:	0f b6 c0             	movzbl %al,%eax
 321:	89 d1                	mov    %edx,%ecx
 323:	29 c1                	sub    %eax,%ecx
 325:	89 c8                	mov    %ecx,%eax
}
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    

00000329 <strlen>:

uint
strlen(char *s)
{
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
 32c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 32f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 336:	eb 04                	jmp    33c <strlen+0x13>
 338:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33f:	03 45 08             	add    0x8(%ebp),%eax
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	84 c0                	test   %al,%al
 347:	75 ef                	jne    338 <strlen+0xf>
    ;
  return n;
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <memset>:

void*
memset(void *dst, int c, uint n)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	89 44 24 08          	mov    %eax,0x8(%esp)
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	89 44 24 04          	mov    %eax,0x4(%esp)
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 04 24             	mov    %eax,(%esp)
 368:	e8 23 ff ff ff       	call   290 <stosb>
  return dst;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <strchr>:

char*
strchr(const char *s, char c)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 04             	sub    $0x4,%esp
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 37e:	eb 14                	jmp    394 <strchr+0x22>
    if(*s == c)
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	0f b6 00             	movzbl (%eax),%eax
 386:	3a 45 fc             	cmp    -0x4(%ebp),%al
 389:	75 05                	jne    390 <strchr+0x1e>
      return (char*)s;
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	eb 13                	jmp    3a3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 390:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	84 c0                	test   %al,%al
 39c:	75 e2                	jne    380 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 39e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a3:	c9                   	leave  
 3a4:	c3                   	ret    

000003a5 <gets>:

char*
gets(char *buf, int max)
{
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp
 3a8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 3b2:	eb 44                	jmp    3f8 <gets+0x53>
    cc = read(0, &c, 1);
 3b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bb:	00 
 3bc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3ca:	e8 3d 01 00 00       	call   50c <read>
 3cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 3d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3d6:	7e 2d                	jle    405 <gets+0x60>
      break;
    buf[i++] = c;
 3d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3db:	03 45 08             	add    0x8(%ebp),%eax
 3de:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 3e2:	88 10                	mov    %dl,(%eax)
 3e4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 3e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ec:	3c 0a                	cmp    $0xa,%al
 3ee:	74 16                	je     406 <gets+0x61>
 3f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f4:	3c 0d                	cmp    $0xd,%al
 3f6:	74 0e                	je     406 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3fb:	83 c0 01             	add    $0x1,%eax
 3fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
 401:	7c b1                	jl     3b4 <gets+0xf>
 403:	eb 01                	jmp    406 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 405:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 406:	8b 45 f0             	mov    -0x10(%ebp),%eax
 409:	03 45 08             	add    0x8(%ebp),%eax
 40c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <stat>:

int
stat(char *n, struct stat *st)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 421:	00 
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	89 04 24             	mov    %eax,(%esp)
 428:	e8 07 01 00 00       	call   534 <open>
 42d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 434:	79 07                	jns    43d <stat+0x29>
    return -1;
 436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43b:	eb 23                	jmp    460 <stat+0x4c>
  r = fstat(fd, st);
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	89 44 24 04          	mov    %eax,0x4(%esp)
 444:	8b 45 f0             	mov    -0x10(%ebp),%eax
 447:	89 04 24             	mov    %eax,(%esp)
 44a:	e8 fd 00 00 00       	call   54c <fstat>
 44f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 452:	8b 45 f0             	mov    -0x10(%ebp),%eax
 455:	89 04 24             	mov    %eax,(%esp)
 458:	e8 bf 00 00 00       	call   51c <close>
  return r;
 45d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 460:	c9                   	leave  
 461:	c3                   	ret    

00000462 <atoi>:

int
atoi(const char *s)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 46f:	eb 24                	jmp    495 <atoi+0x33>
    n = n*10 + *s++ - '0';
 471:	8b 55 fc             	mov    -0x4(%ebp),%edx
 474:	89 d0                	mov    %edx,%eax
 476:	c1 e0 02             	shl    $0x2,%eax
 479:	01 d0                	add    %edx,%eax
 47b:	01 c0                	add    %eax,%eax
 47d:	89 c2                	mov    %eax,%edx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	0f be c0             	movsbl %al,%eax
 488:	8d 04 02             	lea    (%edx,%eax,1),%eax
 48b:	83 e8 30             	sub    $0x30,%eax
 48e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 491:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	0f b6 00             	movzbl (%eax),%eax
 49b:	3c 2f                	cmp    $0x2f,%al
 49d:	7e 0a                	jle    4a9 <atoi+0x47>
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	3c 39                	cmp    $0x39,%al
 4a7:	7e c8                	jle    471 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 4ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 4c0:	eb 13                	jmp    4d5 <memmove+0x27>
    *dst++ = *src++;
 4c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c5:	0f b6 10             	movzbl (%eax),%edx
 4c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4cb:	88 10                	mov    %dl,(%eax)
 4cd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 4d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4d9:	0f 9f c0             	setg   %al
 4dc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 4e0:	84 c0                	test   %al,%al
 4e2:	75 de                	jne    4c2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e7:	c9                   	leave  
 4e8:	c3                   	ret    
 4e9:	90                   	nop
 4ea:	90                   	nop
 4eb:	90                   	nop

000004ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ec:	b8 01 00 00 00       	mov    $0x1,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <exit>:
SYSCALL(exit)
 4f4:	b8 02 00 00 00       	mov    $0x2,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <wait>:
SYSCALL(wait)
 4fc:	b8 03 00 00 00       	mov    $0x3,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <pipe>:
SYSCALL(pipe)
 504:	b8 04 00 00 00       	mov    $0x4,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <read>:
SYSCALL(read)
 50c:	b8 05 00 00 00       	mov    $0x5,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <write>:
SYSCALL(write)
 514:	b8 10 00 00 00       	mov    $0x10,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <close>:
SYSCALL(close)
 51c:	b8 15 00 00 00       	mov    $0x15,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <kill>:
SYSCALL(kill)
 524:	b8 06 00 00 00       	mov    $0x6,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <exec>:
SYSCALL(exec)
 52c:	b8 07 00 00 00       	mov    $0x7,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <open>:
SYSCALL(open)
 534:	b8 0f 00 00 00       	mov    $0xf,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <mknod>:
SYSCALL(mknod)
 53c:	b8 11 00 00 00       	mov    $0x11,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <unlink>:
SYSCALL(unlink)
 544:	b8 12 00 00 00       	mov    $0x12,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <fstat>:
SYSCALL(fstat)
 54c:	b8 08 00 00 00       	mov    $0x8,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <link>:
SYSCALL(link)
 554:	b8 13 00 00 00       	mov    $0x13,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <mkdir>:
SYSCALL(mkdir)
 55c:	b8 14 00 00 00       	mov    $0x14,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <chdir>:
SYSCALL(chdir)
 564:	b8 09 00 00 00       	mov    $0x9,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <dup>:
SYSCALL(dup)
 56c:	b8 0a 00 00 00       	mov    $0xa,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <getpid>:
SYSCALL(getpid)
 574:	b8 0b 00 00 00       	mov    $0xb,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <sbrk>:
SYSCALL(sbrk)
 57c:	b8 0c 00 00 00       	mov    $0xc,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <sleep>:
SYSCALL(sleep)
 584:	b8 0d 00 00 00       	mov    $0xd,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <uptime>:
SYSCALL(uptime)
 58c:	b8 0e 00 00 00       	mov    $0xe,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <clone>:
SYSCALL(clone)
 594:	b8 16 00 00 00       	mov    $0x16,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <texit>:
SYSCALL(texit)
 59c:	b8 17 00 00 00       	mov    $0x17,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <tsleep>:
SYSCALL(tsleep)
 5a4:	b8 18 00 00 00       	mov    $0x18,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <twakeup>:
SYSCALL(twakeup)
 5ac:	b8 19 00 00 00       	mov    $0x19,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 28             	sub    $0x28,%esp
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c7:	00 
 5c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 3a ff ff ff       	call   514 <write>
}
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	53                   	push   %ebx
 5e0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ee:	74 17                	je     607 <printint+0x2b>
 5f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f4:	79 11                	jns    607 <printint+0x2b>
    neg = 1;
 5f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 600:	f7 d8                	neg    %eax
 602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 605:	eb 06                	jmp    60d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 607:	8b 45 0c             	mov    0xc(%ebp),%eax
 60a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 60d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 614:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 617:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61d:	ba 00 00 00 00       	mov    $0x0,%edx
 622:	f7 f3                	div    %ebx
 624:	89 d0                	mov    %edx,%eax
 626:	0f b6 80 24 0d 00 00 	movzbl 0xd24(%eax),%eax
 62d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 631:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 635:	8b 45 10             	mov    0x10(%ebp),%eax
 638:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 63b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63e:	ba 00 00 00 00       	mov    $0x0,%edx
 643:	f7 75 d4             	divl   -0x2c(%ebp)
 646:	89 45 f4             	mov    %eax,-0xc(%ebp)
 649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64d:	75 c5                	jne    614 <printint+0x38>
  if(neg)
 64f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 653:	74 28                	je     67d <printint+0xa1>
    buf[i++] = '-';
 655:	8b 45 ec             	mov    -0x14(%ebp),%eax
 658:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 65d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 661:	eb 1a                	jmp    67d <printint+0xa1>
    putc(fd, buf[i]);
 663:	8b 45 ec             	mov    -0x14(%ebp),%eax
 666:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	89 44 24 04          	mov    %eax,0x4(%esp)
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 37 ff ff ff       	call   5b4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67d:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 681:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 685:	79 dc                	jns    663 <printint+0x87>
    putc(fd, buf[i]);
}
 687:	83 c4 44             	add    $0x44,%esp
 68a:	5b                   	pop    %ebx
 68b:	5d                   	pop    %ebp
 68c:	c3                   	ret    

0000068d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
 690:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 693:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69a:	8d 45 0c             	lea    0xc(%ebp),%eax
 69d:	83 c0 04             	add    $0x4,%eax
 6a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 6a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 6aa:	e9 7e 01 00 00       	jmp    82d <printf+0x1a0>
    c = fmt[i] & 0xff;
 6af:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b5:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6b8:	0f b6 00             	movzbl (%eax),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	25 ff 00 00 00       	and    $0xff,%eax
 6c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 6c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ca:	75 2c                	jne    6f8 <printf+0x6b>
      if(c == '%'){
 6cc:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6d0:	75 0c                	jne    6de <printf+0x51>
        state = '%';
 6d2:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 6d9:	e9 4b 01 00 00       	jmp    829 <printf+0x19c>
      } else {
        putc(fd, c);
 6de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	89 04 24             	mov    %eax,(%esp)
 6ee:	e8 c1 fe ff ff       	call   5b4 <putc>
 6f3:	e9 31 01 00 00       	jmp    829 <printf+0x19c>
      }
    } else if(state == '%'){
 6f8:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 6fc:	0f 85 27 01 00 00    	jne    829 <printf+0x19c>
      if(c == 'd'){
 702:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 706:	75 2d                	jne    735 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 714:	00 
 715:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 71c:	00 
 71d:	89 44 24 04          	mov    %eax,0x4(%esp)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 b0 fe ff ff       	call   5dc <printint>
        ap++;
 72c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 730:	e9 ed 00 00 00       	jmp    822 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 735:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 739:	74 06                	je     741 <printf+0xb4>
 73b:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 73f:	75 2d                	jne    76e <printf+0xe1>
        printint(fd, *ap, 16, 0);
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 74d:	00 
 74e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 755:	00 
 756:	89 44 24 04          	mov    %eax,0x4(%esp)
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	89 04 24             	mov    %eax,(%esp)
 760:	e8 77 fe ff ff       	call   5dc <printint>
        ap++;
 765:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 769:	e9 b4 00 00 00       	jmp    822 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 76e:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 772:	75 46                	jne    7ba <printf+0x12d>
        s = (char*)*ap;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 77c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 784:	75 27                	jne    7ad <printf+0x120>
          s = "(null)";
 786:	c7 45 e4 ec 0c 00 00 	movl   $0xcec,-0x1c(%ebp)
        while(*s != 0){
 78d:	eb 1f                	jmp    7ae <printf+0x121>
          putc(fd, *s);
 78f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 792:	0f b6 00             	movzbl (%eax),%eax
 795:	0f be c0             	movsbl %al,%eax
 798:	89 44 24 04          	mov    %eax,0x4(%esp)
 79c:	8b 45 08             	mov    0x8(%ebp),%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 0d fe ff ff       	call   5b4 <putc>
          s++;
 7a7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 7ab:	eb 01                	jmp    7ae <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ad:	90                   	nop
 7ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b1:	0f b6 00             	movzbl (%eax),%eax
 7b4:	84 c0                	test   %al,%al
 7b6:	75 d7                	jne    78f <printf+0x102>
 7b8:	eb 68                	jmp    822 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ba:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 7be:	75 1d                	jne    7dd <printf+0x150>
        putc(fd, *ap);
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	0f be c0             	movsbl %al,%eax
 7c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	89 04 24             	mov    %eax,(%esp)
 7d2:	e8 dd fd ff ff       	call   5b4 <putc>
        ap++;
 7d7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 7db:	eb 45                	jmp    822 <printf+0x195>
      } else if(c == '%'){
 7dd:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 7e1:	75 17                	jne    7fa <printf+0x16d>
        putc(fd, c);
 7e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e6:	0f be c0             	movsbl %al,%eax
 7e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	89 04 24             	mov    %eax,(%esp)
 7f3:	e8 bc fd ff ff       	call   5b4 <putc>
 7f8:	eb 28                	jmp    822 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7fa:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 801:	00 
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 a7 fd ff ff       	call   5b4 <putc>
        putc(fd, c);
 80d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	89 44 24 04          	mov    %eax,0x4(%esp)
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	89 04 24             	mov    %eax,(%esp)
 81d:	e8 92 fd ff ff       	call   5b4 <putc>
      }
      state = 0;
 822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 829:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 82d:	8b 55 0c             	mov    0xc(%ebp),%edx
 830:	8b 45 ec             	mov    -0x14(%ebp),%eax
 833:	8d 04 02             	lea    (%edx,%eax,1),%eax
 836:	0f b6 00             	movzbl (%eax),%eax
 839:	84 c0                	test   %al,%al
 83b:	0f 85 6e fe ff ff    	jne    6af <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 841:	c9                   	leave  
 842:	c3                   	ret    
 843:	90                   	nop

00000844 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84a:	8b 45 08             	mov    0x8(%ebp),%eax
 84d:	83 e8 08             	sub    $0x8,%eax
 850:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 853:	a1 40 0d 00 00       	mov    0xd40,%eax
 858:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85b:	eb 24                	jmp    881 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 865:	77 12                	ja     879 <free+0x35>
 867:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86d:	77 24                	ja     893 <free+0x4f>
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 00                	mov    (%eax),%eax
 874:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 877:	77 1a                	ja     893 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 881:	8b 45 f8             	mov    -0x8(%ebp),%eax
 884:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 887:	76 d4                	jbe    85d <free+0x19>
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 891:	76 ca                	jbe    85d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	c1 e0 03             	shl    $0x3,%eax
 89c:	89 c2                	mov    %eax,%edx
 89e:	03 55 f8             	add    -0x8(%ebp),%edx
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	39 c2                	cmp    %eax,%edx
 8a8:	75 24                	jne    8ce <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 8aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ad:	8b 50 04             	mov    0x4(%eax),%edx
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	8b 40 04             	mov    0x4(%eax),%eax
 8b8:	01 c2                	add    %eax,%edx
 8ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	8b 10                	mov    (%eax),%edx
 8c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ca:	89 10                	mov    %edx,(%eax)
 8cc:	eb 0a                	jmp    8d8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 10                	mov    (%eax),%edx
 8d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	c1 e0 03             	shl    $0x3,%eax
 8e1:	03 45 fc             	add    -0x4(%ebp),%eax
 8e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e7:	75 20                	jne    909 <free+0xc5>
    p->s.size += bp->s.size;
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	8b 50 04             	mov    0x4(%eax),%edx
 8ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f2:	8b 40 04             	mov    0x4(%eax),%eax
 8f5:	01 c2                	add    %eax,%edx
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	8b 10                	mov    (%eax),%edx
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	89 10                	mov    %edx,(%eax)
 907:	eb 08                	jmp    911 <free+0xcd>
  } else
    p->s.ptr = bp;
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 90f:	89 10                	mov    %edx,(%eax)
  freep = p;
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	a3 40 0d 00 00       	mov    %eax,0xd40
}
 919:	c9                   	leave  
 91a:	c3                   	ret    

0000091b <morecore>:

static Header*
morecore(uint nu)
{
 91b:	55                   	push   %ebp
 91c:	89 e5                	mov    %esp,%ebp
 91e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 921:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 928:	77 07                	ja     931 <morecore+0x16>
    nu = 4096;
 92a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 931:	8b 45 08             	mov    0x8(%ebp),%eax
 934:	c1 e0 03             	shl    $0x3,%eax
 937:	89 04 24             	mov    %eax,(%esp)
 93a:	e8 3d fc ff ff       	call   57c <sbrk>
 93f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 942:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 946:	75 07                	jne    94f <morecore+0x34>
    return 0;
 948:	b8 00 00 00 00       	mov    $0x0,%eax
 94d:	eb 22                	jmp    971 <morecore+0x56>
  hp = (Header*)p;
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 55 08             	mov    0x8(%ebp),%edx
 95b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	83 c0 08             	add    $0x8,%eax
 964:	89 04 24             	mov    %eax,(%esp)
 967:	e8 d8 fe ff ff       	call   844 <free>
  return freep;
 96c:	a1 40 0d 00 00       	mov    0xd40,%eax
}
 971:	c9                   	leave  
 972:	c3                   	ret    

00000973 <malloc>:

void*
malloc(uint nbytes)
{
 973:	55                   	push   %ebp
 974:	89 e5                	mov    %esp,%ebp
 976:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 979:	8b 45 08             	mov    0x8(%ebp),%eax
 97c:	83 c0 07             	add    $0x7,%eax
 97f:	c1 e8 03             	shr    $0x3,%eax
 982:	83 c0 01             	add    $0x1,%eax
 985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 988:	a1 40 0d 00 00       	mov    0xd40,%eax
 98d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 990:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 994:	75 23                	jne    9b9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 996:	c7 45 f0 38 0d 00 00 	movl   $0xd38,-0x10(%ebp)
 99d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a0:	a3 40 0d 00 00       	mov    %eax,0xd40
 9a5:	a1 40 0d 00 00       	mov    0xd40,%eax
 9aa:	a3 38 0d 00 00       	mov    %eax,0xd38
    base.s.size = 0;
 9af:	c7 05 3c 0d 00 00 00 	movl   $0x0,0xd3c
 9b6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bc:	8b 00                	mov    (%eax),%eax
 9be:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 9c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c4:	8b 40 04             	mov    0x4(%eax),%eax
 9c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 9ca:	72 4d                	jb     a19 <malloc+0xa6>
      if(p->s.size == nunits)
 9cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 9d5:	75 0c                	jne    9e3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9da:	8b 10                	mov    (%eax),%edx
 9dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9df:	89 10                	mov    %edx,(%eax)
 9e1:	eb 26                	jmp    a09 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9e6:	8b 40 04             	mov    0x4(%eax),%eax
 9e9:	89 c2                	mov    %eax,%edx
 9eb:	2b 55 f4             	sub    -0xc(%ebp),%edx
 9ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9f1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9f7:	8b 40 04             	mov    0x4(%eax),%eax
 9fa:	c1 e0 03             	shl    $0x3,%eax
 9fd:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a06:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0c:	a3 40 0d 00 00       	mov    %eax,0xd40
      return (void*)(p + 1);
 a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a14:	83 c0 08             	add    $0x8,%eax
 a17:	eb 38                	jmp    a51 <malloc+0xde>
    }
    if(p == freep)
 a19:	a1 40 0d 00 00       	mov    0xd40,%eax
 a1e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a21:	75 1b                	jne    a3e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a26:	89 04 24             	mov    %eax,(%esp)
 a29:	e8 ed fe ff ff       	call   91b <morecore>
 a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a35:	75 07                	jne    a3e <malloc+0xcb>
        return 0;
 a37:	b8 00 00 00 00       	mov    $0x0,%eax
 a3c:	eb 13                	jmp    a51 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a47:	8b 00                	mov    (%eax),%eax
 a49:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a4c:	e9 70 ff ff ff       	jmp    9c1 <malloc+0x4e>
}
 a51:	c9                   	leave  
 a52:	c3                   	ret    
 a53:	90                   	nop

00000a54 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 a54:	55                   	push   %ebp
 a55:	89 e5                	mov    %esp,%ebp
 a57:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 a5a:	8b 55 08             	mov    0x8(%ebp),%edx
 a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
 a60:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a63:	f0 87 02             	lock xchg %eax,(%edx)
 a66:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 a6c:	c9                   	leave  
 a6d:	c3                   	ret    

00000a6e <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 a6e:	55                   	push   %ebp
 a6f:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 a71:	8b 45 08             	mov    0x8(%ebp),%eax
 a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 a7a:	5d                   	pop    %ebp
 a7b:	c3                   	ret    

00000a7c <lock_acquire>:
void lock_acquire(lock_t *lock){
 a7c:	55                   	push   %ebp
 a7d:	89 e5                	mov    %esp,%ebp
 a7f:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 a82:	8b 45 08             	mov    0x8(%ebp),%eax
 a85:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 a8c:	00 
 a8d:	89 04 24             	mov    %eax,(%esp)
 a90:	e8 bf ff ff ff       	call   a54 <xchg>
 a95:	85 c0                	test   %eax,%eax
 a97:	75 e9                	jne    a82 <lock_acquire+0x6>
}
 a99:	c9                   	leave  
 a9a:	c3                   	ret    

00000a9b <lock_release>:
void lock_release(lock_t *lock){
 a9b:	55                   	push   %ebp
 a9c:	89 e5                	mov    %esp,%ebp
 a9e:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 aa1:	8b 45 08             	mov    0x8(%ebp),%eax
 aa4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 aab:	00 
 aac:	89 04 24             	mov    %eax,(%esp)
 aaf:	e8 a0 ff ff ff       	call   a54 <xchg>
}
 ab4:	c9                   	leave  
 ab5:	c3                   	ret    

00000ab6 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 ab6:	55                   	push   %ebp
 ab7:	89 e5                	mov    %esp,%ebp
 ab9:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 abc:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 ac3:	e8 ab fe ff ff       	call   973 <malloc>
 ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad4:	25 ff 0f 00 00       	and    $0xfff,%eax
 ad9:	85 c0                	test   %eax,%eax
 adb:	74 15                	je     af2 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	89 c2                	mov    %eax,%edx
 ae2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 ae8:	b8 00 10 00 00       	mov    $0x1000,%eax
 aed:	29 d0                	sub    %edx,%eax
 aef:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af6:	75 1b                	jne    b13 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 af8:	c7 44 24 04 f3 0c 00 	movl   $0xcf3,0x4(%esp)
 aff:	00 
 b00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b07:	e8 81 fb ff ff       	call   68d <printf>
        return 0;
 b0c:	b8 00 00 00 00       	mov    $0x0,%eax
 b11:	eb 6f                	jmp    b82 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 b16:	8b 55 08             	mov    0x8(%ebp),%edx
 b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 b20:	89 54 24 08          	mov    %edx,0x8(%esp)
 b24:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 b2b:	00 
 b2c:	89 04 24             	mov    %eax,(%esp)
 b2f:	e8 60 fa ff ff       	call   594 <clone>
 b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 b37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b3b:	79 1b                	jns    b58 <thread_create+0xa2>
        printf(1,"clone fails\n");
 b3d:	c7 44 24 04 01 0d 00 	movl   $0xd01,0x4(%esp)
 b44:	00 
 b45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b4c:	e8 3c fb ff ff       	call   68d <printf>
        return 0;
 b51:	b8 00 00 00 00       	mov    $0x0,%eax
 b56:	eb 2a                	jmp    b82 <thread_create+0xcc>
    }
    if(tid > 0){
 b58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b5c:	7e 05                	jle    b63 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b61:	eb 1f                	jmp    b82 <thread_create+0xcc>
    }
    if(tid == 0){
 b63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b67:	75 14                	jne    b7d <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 b69:	c7 44 24 04 0e 0d 00 	movl   $0xd0e,0x4(%esp)
 b70:	00 
 b71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b78:	e8 10 fb ff ff       	call   68d <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 b82:	c9                   	leave  
 b83:	c3                   	ret    

00000b84 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 b84:	55                   	push   %ebp
 b85:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 b87:	8b 45 08             	mov    0x8(%ebp),%eax
 b8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 b90:	8b 45 08             	mov    0x8(%ebp),%eax
 b93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 ba4:	5d                   	pop    %ebp
 ba5:	c3                   	ret    

00000ba6 <add_q>:

void add_q(struct queue *q, int v){
 ba6:	55                   	push   %ebp
 ba7:	89 e5                	mov    %esp,%ebp
 ba9:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 bac:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 bb3:	e8 bb fd ff ff       	call   973 <malloc>
 bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
 bcb:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 bcd:	8b 45 08             	mov    0x8(%ebp),%eax
 bd0:	8b 40 04             	mov    0x4(%eax),%eax
 bd3:	85 c0                	test   %eax,%eax
 bd5:	75 0b                	jne    be2 <add_q+0x3c>
        q->head = n;
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bdd:	89 50 04             	mov    %edx,0x4(%eax)
 be0:	eb 0c                	jmp    bee <add_q+0x48>
    }else{
        q->tail->next = n;
 be2:	8b 45 08             	mov    0x8(%ebp),%eax
 be5:	8b 40 08             	mov    0x8(%eax),%eax
 be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 beb:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 bee:	8b 45 08             	mov    0x8(%ebp),%eax
 bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bf4:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 bf7:	8b 45 08             	mov    0x8(%ebp),%eax
 bfa:	8b 00                	mov    (%eax),%eax
 bfc:	8d 50 01             	lea    0x1(%eax),%edx
 bff:	8b 45 08             	mov    0x8(%ebp),%eax
 c02:	89 10                	mov    %edx,(%eax)
}
 c04:	c9                   	leave  
 c05:	c3                   	ret    

00000c06 <empty_q>:

int empty_q(struct queue *q){
 c06:	55                   	push   %ebp
 c07:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 c09:	8b 45 08             	mov    0x8(%ebp),%eax
 c0c:	8b 00                	mov    (%eax),%eax
 c0e:	85 c0                	test   %eax,%eax
 c10:	75 07                	jne    c19 <empty_q+0x13>
        return 1;
 c12:	b8 01 00 00 00       	mov    $0x1,%eax
 c17:	eb 05                	jmp    c1e <empty_q+0x18>
    else
        return 0;
 c19:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 c1e:	5d                   	pop    %ebp
 c1f:	c3                   	ret    

00000c20 <pop_q>:
int pop_q(struct queue *q){
 c20:	55                   	push   %ebp
 c21:	89 e5                	mov    %esp,%ebp
 c23:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 c26:	8b 45 08             	mov    0x8(%ebp),%eax
 c29:	89 04 24             	mov    %eax,(%esp)
 c2c:	e8 d5 ff ff ff       	call   c06 <empty_q>
 c31:	85 c0                	test   %eax,%eax
 c33:	75 5d                	jne    c92 <pop_q+0x72>
       val = q->head->value; 
 c35:	8b 45 08             	mov    0x8(%ebp),%eax
 c38:	8b 40 04             	mov    0x4(%eax),%eax
 c3b:	8b 00                	mov    (%eax),%eax
 c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 c40:	8b 45 08             	mov    0x8(%ebp),%eax
 c43:	8b 40 04             	mov    0x4(%eax),%eax
 c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 c49:	8b 45 08             	mov    0x8(%ebp),%eax
 c4c:	8b 40 04             	mov    0x4(%eax),%eax
 c4f:	8b 50 04             	mov    0x4(%eax),%edx
 c52:	8b 45 08             	mov    0x8(%ebp),%eax
 c55:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5b:	89 04 24             	mov    %eax,(%esp)
 c5e:	e8 e1 fb ff ff       	call   844 <free>
       q->size--;
 c63:	8b 45 08             	mov    0x8(%ebp),%eax
 c66:	8b 00                	mov    (%eax),%eax
 c68:	8d 50 ff             	lea    -0x1(%eax),%edx
 c6b:	8b 45 08             	mov    0x8(%ebp),%eax
 c6e:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 c70:	8b 45 08             	mov    0x8(%ebp),%eax
 c73:	8b 00                	mov    (%eax),%eax
 c75:	85 c0                	test   %eax,%eax
 c77:	75 14                	jne    c8d <pop_q+0x6d>
            q->head = 0;
 c79:	8b 45 08             	mov    0x8(%ebp),%eax
 c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 c83:	8b 45 08             	mov    0x8(%ebp),%eax
 c86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c90:	eb 05                	jmp    c97 <pop_q+0x77>
    }
    return -1;
 c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 c97:	c9                   	leave  
 c98:	c3                   	ret    

00000c99 <front>:

int front(struct queue *q)
{
 c99:	55                   	push   %ebp
 c9a:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 c9c:	8b 45 08             	mov    0x8(%ebp),%eax
 c9f:	8b 40 04             	mov    0x4(%eax),%eax
 ca2:	8b 00                	mov    (%eax),%eax
}
 ca4:	5d                   	pop    %ebp
 ca5:	c3                   	ret    
