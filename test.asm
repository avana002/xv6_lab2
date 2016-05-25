
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

int n = 1;

void test_func(void * arg_ptr);

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp

   printf(1,"thread_create test begin\n\n");
   9:	c7 44 24 04 f6 0a 00 	movl   $0xaf6,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 c0 04 00 00       	call   4dd <printf>

   printf(1,"before thread_create n = %d\n",n);
  1d:	a1 9c 0b 00 00       	mov    0xb9c,%eax
  22:	89 44 24 08          	mov    %eax,0x8(%esp)
  26:	c7 44 24 04 11 0b 00 	movl   $0xb11,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  35:	e8 a3 04 00 00       	call   4dd <printf>

   int arg = 10;
  3a:	c7 44 24 18 0a 00 00 	movl   $0xa,0x18(%esp)
  41:	00 
   void *tid = thread_create(test_func, (void *)&arg);
  42:	8d 44 24 18          	lea    0x18(%esp),%eax
  46:	89 44 24 04          	mov    %eax,0x4(%esp)
  4a:	c7 04 24 a8 00 00 00 	movl   $0xa8,(%esp)
  51:	e8 b0 08 00 00       	call   906 <thread_create>
  56:	89 44 24 1c          	mov    %eax,0x1c(%esp)
   if(tid <= 0){
  5a:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  5f:	75 38                	jne    99 <main+0x99>
       printf(1,"wrong happen");
  61:	c7 44 24 04 2e 0b 00 	movl   $0xb2e,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 68 04 00 00       	call   4dd <printf>
       exit();
  75:	e8 ca 02 00 00       	call   344 <exit>
   } 
   while(wait()>= 0)
   printf(1,"\nback to parent n = %d\n",n);
  7a:	a1 9c 0b 00 00       	mov    0xb9c,%eax
  7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  83:	c7 44 24 04 3b 0b 00 	movl   $0xb3b,0x4(%esp)
  8a:	00 
  8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  92:	e8 46 04 00 00       	call   4dd <printf>
  97:	eb 01                	jmp    9a <main+0x9a>
   void *tid = thread_create(test_func, (void *)&arg);
   if(tid <= 0){
       printf(1,"wrong happen");
       exit();
   } 
   while(wait()>= 0)
  99:	90                   	nop
  9a:	e8 ad 02 00 00       	call   34c <wait>
  9f:	85 c0                	test   %eax,%eax
  a1:	79 d7                	jns    7a <main+0x7a>
   printf(1,"\nback to parent n = %d\n",n);
   
   exit();
  a3:	e8 9c 02 00 00       	call   344 <exit>

000000a8 <test_func>:
}

//void test_func(void *arg_ptr){
void test_func(void *arg_ptr){
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	83 ec 28             	sub    $0x28,%esp
    int * num = (int *)arg_ptr;
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = *num; 
  b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b7:	8b 00                	mov    (%eax),%eax
  b9:	a3 9c 0b 00 00       	mov    %eax,0xb9c
    printf(1,"\n n is updated as %d\n",*num);
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c1:	8b 00                	mov    (%eax),%eax
  c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  c7:	c7 44 24 04 53 0b 00 	movl   $0xb53,0x4(%esp)
  ce:	00 
  cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d6:	e8 02 04 00 00       	call   4dd <printf>
    texit();
  db:	e8 0c 03 00 00       	call   3ec <texit>

000000e0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e8:	8b 55 10             	mov    0x10(%ebp),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 cb                	mov    %ecx,%ebx
  f0:	89 df                	mov    %ebx,%edi
  f2:	89 d1                	mov    %edx,%ecx
  f4:	fc                   	cld    
  f5:	f3 aa                	rep stos %al,%es:(%edi)
  f7:	89 ca                	mov    %ecx,%edx
  f9:	89 fb                	mov    %edi,%ebx
  fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
  fe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 101:	5b                   	pop    %ebx
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 111:	8b 45 0c             	mov    0xc(%ebp),%eax
 114:	0f b6 10             	movzbl (%eax),%edx
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	88 10                	mov    %dl,(%eax)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	0f 95 c0             	setne  %al
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 12f:	84 c0                	test   %al,%al
 131:	75 de                	jne    111 <strcpy+0xc>
    ;
  return os;
 133:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 136:	c9                   	leave  
 137:	c3                   	ret    

00000138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 13b:	eb 08                	jmp    145 <strcmp+0xd>
    p++, q++;
 13d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 141:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 145:	8b 45 08             	mov    0x8(%ebp),%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	74 10                	je     15f <strcmp+0x27>
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	0f b6 10             	movzbl (%eax),%edx
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	38 c2                	cmp    %al,%dl
 15d:	74 de                	je     13d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	0f b6 d0             	movzbl %al,%edx
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	0f b6 c0             	movzbl %al,%eax
 171:	89 d1                	mov    %edx,%ecx
 173:	29 c1                	sub    %eax,%ecx
 175:	89 c8                	mov    %ecx,%eax
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    

00000179 <strlen>:

uint
strlen(char *s)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 17f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 186:	eb 04                	jmp    18c <strlen+0x13>
 188:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 18c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 18f:	03 45 08             	add    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	84 c0                	test   %al,%al
 197:	75 ef                	jne    188 <strlen+0xf>
    ;
  return n;
 199:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <memset>:

void*
memset(void *dst, int c, uint n)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1a4:	8b 45 10             	mov    0x10(%ebp),%eax
 1a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	89 04 24             	mov    %eax,(%esp)
 1b8:	e8 23 ff ff ff       	call   e0 <stosb>
  return dst;
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c0:	c9                   	leave  
 1c1:	c3                   	ret    

000001c2 <strchr>:

char*
strchr(const char *s, char c)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	83 ec 04             	sub    $0x4,%esp
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ce:	eb 14                	jmp    1e4 <strchr+0x22>
    if(*s == c)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d9:	75 05                	jne    1e0 <strchr+0x1e>
      return (char*)s;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	eb 13                	jmp    1f3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	84 c0                	test   %al,%al
 1ec:	75 e2                	jne    1d0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f3:	c9                   	leave  
 1f4:	c3                   	ret    

000001f5 <gets>:

char*
gets(char *buf, int max)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 202:	eb 44                	jmp    248 <gets+0x53>
    cc = read(0, &c, 1);
 204:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 20b:	00 
 20c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20f:	89 44 24 04          	mov    %eax,0x4(%esp)
 213:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 21a:	e8 3d 01 00 00       	call   35c <read>
 21f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 226:	7e 2d                	jle    255 <gets+0x60>
      break;
    buf[i++] = c;
 228:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22b:	03 45 08             	add    0x8(%ebp),%eax
 22e:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 232:	88 10                	mov    %dl,(%eax)
 234:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 238:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23c:	3c 0a                	cmp    $0xa,%al
 23e:	74 16                	je     256 <gets+0x61>
 240:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 244:	3c 0d                	cmp    $0xd,%al
 246:	74 0e                	je     256 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	8b 45 f0             	mov    -0x10(%ebp),%eax
 24b:	83 c0 01             	add    $0x1,%eax
 24e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 251:	7c b1                	jl     204 <gets+0xf>
 253:	eb 01                	jmp    256 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 255:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 256:	8b 45 f0             	mov    -0x10(%ebp),%eax
 259:	03 45 08             	add    0x8(%ebp),%eax
 25c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <stat>:

int
stat(char *n, struct stat *st)
{
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 271:	00 
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	89 04 24             	mov    %eax,(%esp)
 278:	e8 07 01 00 00       	call   384 <open>
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	79 07                	jns    28d <stat+0x29>
    return -1;
 286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28b:	eb 23                	jmp    2b0 <stat+0x4c>
  r = fstat(fd, st);
 28d:	8b 45 0c             	mov    0xc(%ebp),%eax
 290:	89 44 24 04          	mov    %eax,0x4(%esp)
 294:	8b 45 f0             	mov    -0x10(%ebp),%eax
 297:	89 04 24             	mov    %eax,(%esp)
 29a:	e8 fd 00 00 00       	call   39c <fstat>
 29f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 bf 00 00 00       	call   36c <close>
  return r;
 2ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <atoi>:

int
atoi(const char *s)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bf:	eb 24                	jmp    2e5 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c4:	89 d0                	mov    %edx,%eax
 2c6:	c1 e0 02             	shl    $0x2,%eax
 2c9:	01 d0                	add    %edx,%eax
 2cb:	01 c0                	add    %eax,%eax
 2cd:	89 c2                	mov    %eax,%edx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	0f be c0             	movsbl %al,%eax
 2d8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2db:	83 e8 30             	sub    $0x30,%eax
 2de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	3c 2f                	cmp    $0x2f,%al
 2ed:	7e 0a                	jle    2f9 <atoi+0x47>
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	3c 39                	cmp    $0x39,%al
 2f7:	7e c8                	jle    2c1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 310:	eb 13                	jmp    325 <memmove+0x27>
    *dst++ = *src++;
 312:	8b 45 fc             	mov    -0x4(%ebp),%eax
 315:	0f b6 10             	movzbl (%eax),%edx
 318:	8b 45 f8             	mov    -0x8(%ebp),%eax
 31b:	88 10                	mov    %dl,(%eax)
 31d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 321:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 325:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 329:	0f 9f c0             	setg   %al
 32c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 330:	84 c0                	test   %al,%al
 332:	75 de                	jne    312 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    
 339:	90                   	nop
 33a:	90                   	nop
 33b:	90                   	nop

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <clone>:
SYSCALL(clone)
 3e4:	b8 16 00 00 00       	mov    $0x16,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <texit>:
SYSCALL(texit)
 3ec:	b8 17 00 00 00       	mov    $0x17,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <tsleep>:
SYSCALL(tsleep)
 3f4:	b8 18 00 00 00       	mov    $0x18,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <twakeup>:
SYSCALL(twakeup)
 3fc:	b8 19 00 00 00       	mov    $0x19,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 28             	sub    $0x28,%esp
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 410:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 417:	00 
 418:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41b:	89 44 24 04          	mov    %eax,0x4(%esp)
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	89 04 24             	mov    %eax,(%esp)
 425:	e8 3a ff ff ff       	call   364 <write>
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	53                   	push   %ebx
 430:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43e:	74 17                	je     457 <printint+0x2b>
 440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 444:	79 11                	jns    457 <printint+0x2b>
    neg = 1;
 446:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	f7 d8                	neg    %eax
 452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 455:	eb 06                	jmp    45d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 45d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 464:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 467:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	ba 00 00 00 00       	mov    $0x0,%edx
 472:	f7 f3                	div    %ebx
 474:	89 d0                	mov    %edx,%eax
 476:	0f b6 80 a0 0b 00 00 	movzbl 0xba0(%eax),%eax
 47d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 481:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 485:	8b 45 10             	mov    0x10(%ebp),%eax
 488:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 48b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48e:	ba 00 00 00 00       	mov    $0x0,%edx
 493:	f7 75 d4             	divl   -0x2c(%ebp)
 496:	89 45 f4             	mov    %eax,-0xc(%ebp)
 499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49d:	75 c5                	jne    464 <printint+0x38>
  if(neg)
 49f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a3:	74 28                	je     4cd <printint+0xa1>
    buf[i++] = '-';
 4a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4ad:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4b1:	eb 1a                	jmp    4cd <printint+0xa1>
    putc(fd, buf[i]);
 4b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4bb:	0f be c0             	movsbl %al,%eax
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 04 24             	mov    %eax,(%esp)
 4c8:	e8 37 ff ff ff       	call   404 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cd:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d5:	79 dc                	jns    4b3 <printint+0x87>
    putc(fd, buf[i]);
}
 4d7:	83 c4 44             	add    $0x44,%esp
 4da:	5b                   	pop    %ebx
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret    

000004dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4dd:	55                   	push   %ebp
 4de:	89 e5                	mov    %esp,%ebp
 4e0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ea:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ed:	83 c0 04             	add    $0x4,%eax
 4f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4fa:	e9 7e 01 00 00       	jmp    67d <printf+0x1a0>
    c = fmt[i] & 0xff;
 4ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 502:	8b 45 ec             	mov    -0x14(%ebp),%eax
 505:	8d 04 02             	lea    (%edx,%eax,1),%eax
 508:	0f b6 00             	movzbl (%eax),%eax
 50b:	0f be c0             	movsbl %al,%eax
 50e:	25 ff 00 00 00       	and    $0xff,%eax
 513:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 516:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51a:	75 2c                	jne    548 <printf+0x6b>
      if(c == '%'){
 51c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 520:	75 0c                	jne    52e <printf+0x51>
        state = '%';
 522:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 529:	e9 4b 01 00 00       	jmp    679 <printf+0x19c>
      } else {
        putc(fd, c);
 52e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 531:	0f be c0             	movsbl %al,%eax
 534:	89 44 24 04          	mov    %eax,0x4(%esp)
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	89 04 24             	mov    %eax,(%esp)
 53e:	e8 c1 fe ff ff       	call   404 <putc>
 543:	e9 31 01 00 00       	jmp    679 <printf+0x19c>
      }
    } else if(state == '%'){
 548:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 54c:	0f 85 27 01 00 00    	jne    679 <printf+0x19c>
      if(c == 'd'){
 552:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 556:	75 2d                	jne    585 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 558:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 564:	00 
 565:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 56c:	00 
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 b0 fe ff ff       	call   42c <printint>
        ap++;
 57c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 580:	e9 ed 00 00 00       	jmp    672 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 585:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 589:	74 06                	je     591 <printf+0xb4>
 58b:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 58f:	75 2d                	jne    5be <printf+0xe1>
        printint(fd, *ap, 16, 0);
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 59d:	00 
 59e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5a5:	00 
 5a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	89 04 24             	mov    %eax,(%esp)
 5b0:	e8 77 fe ff ff       	call   42c <printint>
        ap++;
 5b5:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5b9:	e9 b4 00 00 00       	jmp    672 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5be:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5c2:	75 46                	jne    60a <printf+0x12d>
        s = (char*)*ap;
 5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5cc:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5d4:	75 27                	jne    5fd <printf+0x120>
          s = "(null)";
 5d6:	c7 45 e4 69 0b 00 00 	movl   $0xb69,-0x1c(%ebp)
        while(*s != 0){
 5dd:	eb 1f                	jmp    5fe <printf+0x121>
          putc(fd, *s);
 5df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 0d fe ff ff       	call   404 <putc>
          s++;
 5f7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5fb:	eb 01                	jmp    5fe <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5fd:	90                   	nop
 5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 601:	0f b6 00             	movzbl (%eax),%eax
 604:	84 c0                	test   %al,%al
 606:	75 d7                	jne    5df <printf+0x102>
 608:	eb 68                	jmp    672 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60a:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 60e:	75 1d                	jne    62d <printf+0x150>
        putc(fd, *ap);
 610:	8b 45 f4             	mov    -0xc(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	89 44 24 04          	mov    %eax,0x4(%esp)
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 dd fd ff ff       	call   404 <putc>
        ap++;
 627:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 62b:	eb 45                	jmp    672 <printf+0x195>
      } else if(c == '%'){
 62d:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 631:	75 17                	jne    64a <printf+0x16d>
        putc(fd, c);
 633:	8b 45 e8             	mov    -0x18(%ebp),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	89 04 24             	mov    %eax,(%esp)
 643:	e8 bc fd ff ff       	call   404 <putc>
 648:	eb 28                	jmp    672 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 651:	00 
 652:	8b 45 08             	mov    0x8(%ebp),%eax
 655:	89 04 24             	mov    %eax,(%esp)
 658:	e8 a7 fd ff ff       	call   404 <putc>
        putc(fd, c);
 65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 660:	0f be c0             	movsbl %al,%eax
 663:	89 44 24 04          	mov    %eax,0x4(%esp)
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	89 04 24             	mov    %eax,(%esp)
 66d:	e8 92 fd ff ff       	call   404 <putc>
      }
      state = 0;
 672:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 67d:	8b 55 0c             	mov    0xc(%ebp),%edx
 680:	8b 45 ec             	mov    -0x14(%ebp),%eax
 683:	8d 04 02             	lea    (%edx,%eax,1),%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	84 c0                	test   %al,%al
 68b:	0f 85 6e fe ff ff    	jne    4ff <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 691:	c9                   	leave  
 692:	c3                   	ret    
 693:	90                   	nop

00000694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69a:	8b 45 08             	mov    0x8(%ebp),%eax
 69d:	83 e8 08             	sub    $0x8,%eax
 6a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a3:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 6a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ab:	eb 24                	jmp    6d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b5:	77 12                	ja     6c9 <free+0x35>
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bd:	77 24                	ja     6e3 <free+0x4f>
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	77 1a                	ja     6e3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d7:	76 d4                	jbe    6ad <free+0x19>
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e1:	76 ca                	jbe    6ad <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	c1 e0 03             	shl    $0x3,%eax
 6ec:	89 c2                	mov    %eax,%edx
 6ee:	03 55 f8             	add    -0x8(%ebp),%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	39 c2                	cmp    %eax,%edx
 6f8:	75 24                	jne    71e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 50 04             	mov    0x4(%eax),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
 71c:	eb 0a                	jmp    728 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	c1 e0 03             	shl    $0x3,%eax
 731:	03 45 fc             	add    -0x4(%ebp),%eax
 734:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 737:	75 20                	jne    759 <free+0xc5>
    p->s.size += bp->s.size;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 50 04             	mov    0x4(%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 40 04             	mov    0x4(%eax),%eax
 745:	01 c2                	add    %eax,%edx
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 08                	jmp    761 <free+0xcd>
  } else
    p->s.ptr = bp;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75f:	89 10                	mov    %edx,(%eax)
  freep = p;
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	a3 bc 0b 00 00       	mov    %eax,0xbbc
}
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <morecore>:

static Header*
morecore(uint nu)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 771:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 778:	77 07                	ja     781 <morecore+0x16>
    nu = 4096;
 77a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	c1 e0 03             	shl    $0x3,%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 3d fc ff ff       	call   3cc <sbrk>
 78f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 792:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 796:	75 07                	jne    79f <morecore+0x34>
    return 0;
 798:	b8 00 00 00 00       	mov    $0x0,%eax
 79d:	eb 22                	jmp    7c1 <morecore+0x56>
  hp = (Header*)p;
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 55 08             	mov    0x8(%ebp),%edx
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	83 c0 08             	add    $0x8,%eax
 7b4:	89 04 24             	mov    %eax,(%esp)
 7b7:	e8 d8 fe ff ff       	call   694 <free>
  return freep;
 7bc:	a1 bc 0b 00 00       	mov    0xbbc,%eax
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <malloc>:

void*
malloc(uint nbytes)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
 7cc:	83 c0 07             	add    $0x7,%eax
 7cf:	c1 e8 03             	shr    $0x3,%eax
 7d2:	83 c0 01             	add    $0x1,%eax
 7d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7d8:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 7dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e4:	75 23                	jne    809 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e6:	c7 45 f0 b4 0b 00 00 	movl   $0xbb4,-0x10(%ebp)
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	a3 bc 0b 00 00       	mov    %eax,0xbbc
 7f5:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 7fa:	a3 b4 0b 00 00       	mov    %eax,0xbb4
    base.s.size = 0;
 7ff:	c7 05 b8 0b 00 00 00 	movl   $0x0,0xbb8
 806:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 811:	8b 45 ec             	mov    -0x14(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 81a:	72 4d                	jb     869 <malloc+0xa6>
      if(p->s.size == nunits)
 81c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 825:	75 0c                	jne    833 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 827:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82f:	89 10                	mov    %edx,(%eax)
 831:	eb 26                	jmp    859 <malloc+0x96>
      else {
        p->s.size -= nunits;
 833:	8b 45 ec             	mov    -0x14(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	89 c2                	mov    %eax,%edx
 83b:	2b 55 f4             	sub    -0xc(%ebp),%edx
 83e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 841:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 844:	8b 45 ec             	mov    -0x14(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	c1 e0 03             	shl    $0x3,%eax
 84d:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 850:	8b 45 ec             	mov    -0x14(%ebp),%eax
 853:	8b 55 f4             	mov    -0xc(%ebp),%edx
 856:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	a3 bc 0b 00 00       	mov    %eax,0xbbc
      return (void*)(p + 1);
 861:	8b 45 ec             	mov    -0x14(%ebp),%eax
 864:	83 c0 08             	add    $0x8,%eax
 867:	eb 38                	jmp    8a1 <malloc+0xde>
    }
    if(p == freep)
 869:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 86e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 871:	75 1b                	jne    88e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	89 04 24             	mov    %eax,(%esp)
 879:	e8 ed fe ff ff       	call   76b <morecore>
 87e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 885:	75 07                	jne    88e <malloc+0xcb>
        return 0;
 887:	b8 00 00 00 00       	mov    $0x0,%eax
 88c:	eb 13                	jmp    8a1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 891:	89 45 f0             	mov    %eax,-0x10(%ebp)
 894:	8b 45 ec             	mov    -0x14(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89c:	e9 70 ff ff ff       	jmp    811 <malloc+0x4e>
}
 8a1:	c9                   	leave  
 8a2:	c3                   	ret    
 8a3:	90                   	nop

000008a4 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8aa:	8b 55 08             	mov    0x8(%ebp),%edx
 8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8b3:	f0 87 02             	lock xchg %eax,(%edx)
 8b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8bc:	c9                   	leave  
 8bd:	c3                   	ret    

000008be <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 8be:	55                   	push   %ebp
 8bf:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8c1:	8b 45 08             	mov    0x8(%ebp),%eax
 8c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8ca:	5d                   	pop    %ebp
 8cb:	c3                   	ret    

000008cc <lock_acquire>:
void lock_acquire(lock_t *lock){
 8cc:	55                   	push   %ebp
 8cd:	89 e5                	mov    %esp,%ebp
 8cf:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 8d2:	8b 45 08             	mov    0x8(%ebp),%eax
 8d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8dc:	00 
 8dd:	89 04 24             	mov    %eax,(%esp)
 8e0:	e8 bf ff ff ff       	call   8a4 <xchg>
 8e5:	85 c0                	test   %eax,%eax
 8e7:	75 e9                	jne    8d2 <lock_acquire+0x6>
}
 8e9:	c9                   	leave  
 8ea:	c3                   	ret    

000008eb <lock_release>:
void lock_release(lock_t *lock){
 8eb:	55                   	push   %ebp
 8ec:	89 e5                	mov    %esp,%ebp
 8ee:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 8f1:	8b 45 08             	mov    0x8(%ebp),%eax
 8f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8fb:	00 
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 a0 ff ff ff       	call   8a4 <xchg>
}
 904:	c9                   	leave  
 905:	c3                   	ret    

00000906 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 906:	55                   	push   %ebp
 907:	89 e5                	mov    %esp,%ebp
 909:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 90c:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 913:	e8 ab fe ff ff       	call   7c3 <malloc>
 918:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 921:	8b 45 f0             	mov    -0x10(%ebp),%eax
 924:	25 ff 0f 00 00       	and    $0xfff,%eax
 929:	85 c0                	test   %eax,%eax
 92b:	74 15                	je     942 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 92d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 930:	89 c2                	mov    %eax,%edx
 932:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 938:	b8 00 10 00 00       	mov    $0x1000,%eax
 93d:	29 d0                	sub    %edx,%eax
 93f:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 946:	75 1b                	jne    963 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 948:	c7 44 24 04 70 0b 00 	movl   $0xb70,0x4(%esp)
 94f:	00 
 950:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 957:	e8 81 fb ff ff       	call   4dd <printf>
        return 0;
 95c:	b8 00 00 00 00       	mov    $0x0,%eax
 961:	eb 6f                	jmp    9d2 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 966:	8b 55 08             	mov    0x8(%ebp),%edx
 969:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 970:	89 54 24 08          	mov    %edx,0x8(%esp)
 974:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 97b:	00 
 97c:	89 04 24             	mov    %eax,(%esp)
 97f:	e8 60 fa ff ff       	call   3e4 <clone>
 984:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 987:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 98b:	79 1b                	jns    9a8 <thread_create+0xa2>
        printf(1,"clone fails\n");
 98d:	c7 44 24 04 7e 0b 00 	movl   $0xb7e,0x4(%esp)
 994:	00 
 995:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 99c:	e8 3c fb ff ff       	call   4dd <printf>
        return 0;
 9a1:	b8 00 00 00 00       	mov    $0x0,%eax
 9a6:	eb 2a                	jmp    9d2 <thread_create+0xcc>
    }
    if(tid > 0){
 9a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9ac:	7e 05                	jle    9b3 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	eb 1f                	jmp    9d2 <thread_create+0xcc>
    }
    if(tid == 0){
 9b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9b7:	75 14                	jne    9cd <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 9b9:	c7 44 24 04 8b 0b 00 	movl   $0xb8b,0x4(%esp)
 9c0:	00 
 9c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9c8:	e8 10 fb ff ff       	call   4dd <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 9d2:	c9                   	leave  
 9d3:	c3                   	ret    

000009d4 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 9d4:	55                   	push   %ebp
 9d5:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 9d7:	8b 45 08             	mov    0x8(%ebp),%eax
 9da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 9ea:	8b 45 08             	mov    0x8(%ebp),%eax
 9ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 9f4:	5d                   	pop    %ebp
 9f5:	c3                   	ret    

000009f6 <add_q>:

void add_q(struct queue *q, int v){
 9f6:	55                   	push   %ebp
 9f7:	89 e5                	mov    %esp,%ebp
 9f9:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 9fc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a03:	e8 bb fd ff ff       	call   7c3 <malloc>
 a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	8b 55 0c             	mov    0xc(%ebp),%edx
 a1b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	8b 40 04             	mov    0x4(%eax),%eax
 a23:	85 c0                	test   %eax,%eax
 a25:	75 0b                	jne    a32 <add_q+0x3c>
        q->head = n;
 a27:	8b 45 08             	mov    0x8(%ebp),%eax
 a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a2d:	89 50 04             	mov    %edx,0x4(%eax)
 a30:	eb 0c                	jmp    a3e <add_q+0x48>
    }else{
        q->tail->next = n;
 a32:	8b 45 08             	mov    0x8(%ebp),%eax
 a35:	8b 40 08             	mov    0x8(%eax),%eax
 a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a3b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a3e:	8b 45 08             	mov    0x8(%ebp),%eax
 a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a44:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a47:	8b 45 08             	mov    0x8(%ebp),%eax
 a4a:	8b 00                	mov    (%eax),%eax
 a4c:	8d 50 01             	lea    0x1(%eax),%edx
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	89 10                	mov    %edx,(%eax)
}
 a54:	c9                   	leave  
 a55:	c3                   	ret    

00000a56 <empty_q>:

int empty_q(struct queue *q){
 a56:	55                   	push   %ebp
 a57:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a59:	8b 45 08             	mov    0x8(%ebp),%eax
 a5c:	8b 00                	mov    (%eax),%eax
 a5e:	85 c0                	test   %eax,%eax
 a60:	75 07                	jne    a69 <empty_q+0x13>
        return 1;
 a62:	b8 01 00 00 00       	mov    $0x1,%eax
 a67:	eb 05                	jmp    a6e <empty_q+0x18>
    else
        return 0;
 a69:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a6e:	5d                   	pop    %ebp
 a6f:	c3                   	ret    

00000a70 <pop_q>:
int pop_q(struct queue *q){
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 a76:	8b 45 08             	mov    0x8(%ebp),%eax
 a79:	89 04 24             	mov    %eax,(%esp)
 a7c:	e8 d5 ff ff ff       	call   a56 <empty_q>
 a81:	85 c0                	test   %eax,%eax
 a83:	75 5d                	jne    ae2 <pop_q+0x72>
       val = q->head->value; 
 a85:	8b 45 08             	mov    0x8(%ebp),%eax
 a88:	8b 40 04             	mov    0x4(%eax),%eax
 a8b:	8b 00                	mov    (%eax),%eax
 a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 a90:	8b 45 08             	mov    0x8(%ebp),%eax
 a93:	8b 40 04             	mov    0x4(%eax),%eax
 a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 a99:	8b 45 08             	mov    0x8(%ebp),%eax
 a9c:	8b 40 04             	mov    0x4(%eax),%eax
 a9f:	8b 50 04             	mov    0x4(%eax),%edx
 aa2:	8b 45 08             	mov    0x8(%ebp),%eax
 aa5:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	89 04 24             	mov    %eax,(%esp)
 aae:	e8 e1 fb ff ff       	call   694 <free>
       q->size--;
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	8b 00                	mov    (%eax),%eax
 ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
 abb:	8b 45 08             	mov    0x8(%ebp),%eax
 abe:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 ac0:	8b 45 08             	mov    0x8(%ebp),%eax
 ac3:	8b 00                	mov    (%eax),%eax
 ac5:	85 c0                	test   %eax,%eax
 ac7:	75 14                	jne    add <pop_q+0x6d>
            q->head = 0;
 ac9:	8b 45 08             	mov    0x8(%ebp),%eax
 acc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 ad3:	8b 45 08             	mov    0x8(%ebp),%eax
 ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	eb 05                	jmp    ae7 <pop_q+0x77>
    }
    return -1;
 ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 ae7:	c9                   	leave  
 ae8:	c3                   	ret    

00000ae9 <front>:

int front(struct queue *q)
{
 ae9:	55                   	push   %ebp
 aea:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 aec:	8b 45 08             	mov    0x8(%ebp),%eax
 aef:	8b 40 04             	mov    0x4(%eax),%eax
 af2:	8b 00                	mov    (%eax),%eax
}
 af4:	5d                   	pop    %ebp
 af5:	c3                   	ret    
