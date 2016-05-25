
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 ce 0b 00 	movl   $0xbce,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 75 05 00 00       	call   5b5 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 1a 02 00 00       	call   276 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
    if(fork() > 0)
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
    if(fork() > 0)
      break;
  86:	90                   	nop

  printf(1, "write %d\n", i);
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 e1 0b 00 	movl   $0xbe1,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 0f 05 00 00       	call   5b5 <printf>

  path[8] += i;
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	8d 04 02             	lea    (%edx,%eax,1),%eax
  ba:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c8:	00 
  c9:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 84 03 00 00       	call   45c <open>
  d8:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  df:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e6:	00 00 00 00 
  ea:	eb 27                	jmp    113 <main+0x113>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f3:	00 
  f4:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  fc:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 31 03 00 00       	call   43c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 10b:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 112:	01 
 113:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 11a:	13 
 11b:	7e cf                	jle    ec <main+0xec>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 124:	89 04 24             	mov    %eax,(%esp)
 127:	e8 18 03 00 00       	call   444 <close>

  printf(1, "read\n");
 12c:	c7 44 24 04 eb 0b 00 	movl   $0xbeb,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	e8 75 04 00 00       	call   5b5 <printf>

  fd = open(path, O_RDONLY);
 140:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 147:	00 
 148:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 05 03 00 00       	call   45c <open>
 157:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15e:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 165:	00 00 00 00 
 169:	eb 27                	jmp    192 <main+0x192>
    read(fd, data, sizeof(data));
 16b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 172:	00 
 173:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 177:	89 44 24 04          	mov    %eax,0x4(%esp)
 17b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 aa 02 00 00       	call   434 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 18a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 191:	01 
 192:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 199:	13 
 19a:	7e cf                	jle    16b <main+0x16b>
    read(fd, data, sizeof(data));
  close(fd);
 19c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 99 02 00 00       	call   444 <close>

  wait();
 1ab:	e8 74 02 00 00       	call   424 <wait>
  
  exit();
 1b0:	e8 67 02 00 00       	call   41c <exit>
 1b5:	90                   	nop
 1b6:	90                   	nop
 1b7:	90                   	nop

000001b8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
 1bc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c0:	8b 55 10             	mov    0x10(%ebp),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 cb                	mov    %ecx,%ebx
 1c8:	89 df                	mov    %ebx,%edi
 1ca:	89 d1                	mov    %edx,%ecx
 1cc:	fc                   	cld    
 1cd:	f3 aa                	rep stos %al,%es:(%edi)
 1cf:	89 ca                	mov    %ecx,%edx
 1d1:	89 fb                	mov    %edi,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d9:	5b                   	pop    %ebx
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	0f b6 10             	movzbl (%eax),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	88 10                	mov    %dl,(%eax)
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	0f 95 c0             	setne  %al
 1ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 203:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 207:	84 c0                	test   %al,%al
 209:	75 de                	jne    1e9 <strcpy+0xc>
    ;
  return os;
 20b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 213:	eb 08                	jmp    21d <strcmp+0xd>
    p++, q++;
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	74 10                	je     237 <strcmp+0x27>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	38 c2                	cmp    %al,%dl
 235:	74 de                	je     215 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	0f b6 d0             	movzbl %al,%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f b6 c0             	movzbl %al,%eax
 249:	89 d1                	mov    %edx,%ecx
 24b:	29 c1                	sub    %eax,%ecx
 24d:	89 c8                	mov    %ecx,%eax
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strlen>:

uint
strlen(char *s)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25e:	eb 04                	jmp    264 <strlen+0x13>
 260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
 267:	03 45 08             	add    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	84 c0                	test   %al,%al
 26f:	75 ef                	jne    260 <strlen+0xf>
    ;
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	89 44 24 08          	mov    %eax,0x8(%esp)
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 44 24 04          	mov    %eax,0x4(%esp)
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 23 ff ff ff       	call   1b8 <stosb>
  return dst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <strchr>:

char*
strchr(const char *s, char c)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 04             	sub    $0x4,%esp
 2a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a6:	eb 14                	jmp    2bc <strchr+0x22>
    if(*s == c)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b1:	75 05                	jne    2b8 <strchr+0x1e>
      return (char*)s;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	eb 13                	jmp    2cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	75 e2                	jne    2a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <gets>:

char*
gets(char *buf, int max)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2da:	eb 44                	jmp    320 <gets+0x53>
    cc = read(0, &c, 1);
 2dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e3:	00 
 2e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f2:	e8 3d 01 00 00       	call   434 <read>
 2f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 2fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fe:	7e 2d                	jle    32d <gets+0x60>
      break;
    buf[i++] = c;
 300:	8b 45 f0             	mov    -0x10(%ebp),%eax
 303:	03 45 08             	add    0x8(%ebp),%eax
 306:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 30a:	88 10                	mov    %dl,(%eax)
 30c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 16                	je     32e <gets+0x61>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0e                	je     32e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c b1                	jl     2dc <gets+0xf>
 32b:	eb 01                	jmp    32e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 331:	03 45 08             	add    0x8(%ebp),%eax
 334:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <stat>:

int
stat(char *n, struct stat *st)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 349:	00 
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 04 24             	mov    %eax,(%esp)
 350:	e8 07 01 00 00       	call   45c <open>
 355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35c:	79 07                	jns    365 <stat+0x29>
    return -1;
 35e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 363:	eb 23                	jmp    388 <stat+0x4c>
  r = fstat(fd, st);
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 fd 00 00 00       	call   474 <fstat>
 377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 bf 00 00 00       	call   444 <close>
  return r;
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <atoi>:

int
atoi(const char *s)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 397:	eb 24                	jmp    3bd <atoi+0x33>
    n = n*10 + *s++ - '0';
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 02             	shl    $0x2,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	01 c0                	add    %eax,%eax
 3a5:	89 c2                	mov    %eax,%edx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f be c0             	movsbl %al,%eax
 3b0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3b3:	83 e8 30             	sub    $0x30,%eax
 3b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x47>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c8                	jle    399 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3e8:	eb 13                	jmp    3fd <memmove+0x27>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	0f b6 10             	movzbl (%eax),%edx
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	88 10                	mov    %dl,(%eax)
 3f5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 401:	0f 9f c0             	setg   %al
 404:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 408:	84 c0                	test   %al,%al
 40a:	75 de                	jne    3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    
 411:	90                   	nop
 412:	90                   	nop
 413:	90                   	nop

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <clone>:
SYSCALL(clone)
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <texit>:
SYSCALL(texit)
 4c4:	b8 17 00 00 00       	mov    $0x17,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <tsleep>:
SYSCALL(tsleep)
 4cc:	b8 18 00 00 00       	mov    $0x18,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <twakeup>:
SYSCALL(twakeup)
 4d4:	b8 19 00 00 00       	mov    $0x19,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	83 ec 28             	sub    $0x28,%esp
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ef:	00 
 4f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	89 04 24             	mov    %eax,(%esp)
 4fd:	e8 3a ff ff ff       	call   43c <write>
}
 502:	c9                   	leave  
 503:	c3                   	ret    

00000504 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	53                   	push   %ebx
 508:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 50b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 512:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 516:	74 17                	je     52f <printint+0x2b>
 518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51c:	79 11                	jns    52f <printint+0x2b>
    neg = 1;
 51e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 525:	8b 45 0c             	mov    0xc(%ebp),%eax
 528:	f7 d8                	neg    %eax
 52a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 52d:	eb 06                	jmp    535 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52f:	8b 45 0c             	mov    0xc(%ebp),%eax
 532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 53c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 53f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	ba 00 00 00 00       	mov    $0x0,%edx
 54a:	f7 f3                	div    %ebx
 54c:	89 d0                	mov    %edx,%eax
 54e:	0f b6 80 24 0c 00 00 	movzbl 0xc24(%eax),%eax
 555:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 559:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 55d:	8b 45 10             	mov    0x10(%ebp),%eax
 560:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 563:	8b 45 f4             	mov    -0xc(%ebp),%eax
 566:	ba 00 00 00 00       	mov    $0x0,%edx
 56b:	f7 75 d4             	divl   -0x2c(%ebp)
 56e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 575:	75 c5                	jne    53c <printint+0x38>
  if(neg)
 577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57b:	74 28                	je     5a5 <printint+0xa1>
    buf[i++] = '-';
 57d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 580:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 585:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 589:	eb 1a                	jmp    5a5 <printint+0xa1>
    putc(fd, buf[i]);
 58b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	89 44 24 04          	mov    %eax,0x4(%esp)
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 04 24             	mov    %eax,(%esp)
 5a0:	e8 37 ff ff ff       	call   4dc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a5:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 5a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ad:	79 dc                	jns    58b <printint+0x87>
    putc(fd, buf[i]);
}
 5af:	83 c4 44             	add    $0x44,%esp
 5b2:	5b                   	pop    %ebx
 5b3:	5d                   	pop    %ebp
 5b4:	c3                   	ret    

000005b5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b5:	55                   	push   %ebp
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c2:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c5:	83 c0 04             	add    $0x4,%eax
 5c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5d2:	e9 7e 01 00 00       	jmp    755 <printf+0x1a0>
    c = fmt[i] & 0xff;
 5d7:	8b 55 0c             	mov    0xc(%ebp),%edx
 5da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5dd:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	25 ff 00 00 00       	and    $0xff,%eax
 5eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f2:	75 2c                	jne    620 <printf+0x6b>
      if(c == '%'){
 5f4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5f8:	75 0c                	jne    606 <printf+0x51>
        state = '%';
 5fa:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 601:	e9 4b 01 00 00       	jmp    751 <printf+0x19c>
      } else {
        putc(fd, c);
 606:	8b 45 e8             	mov    -0x18(%ebp),%eax
 609:	0f be c0             	movsbl %al,%eax
 60c:	89 44 24 04          	mov    %eax,0x4(%esp)
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	89 04 24             	mov    %eax,(%esp)
 616:	e8 c1 fe ff ff       	call   4dc <putc>
 61b:	e9 31 01 00 00       	jmp    751 <printf+0x19c>
      }
    } else if(state == '%'){
 620:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 624:	0f 85 27 01 00 00    	jne    751 <printf+0x19c>
      if(c == 'd'){
 62a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 62e:	75 2d                	jne    65d <printf+0xa8>
        printint(fd, *ap, 10, 1);
 630:	8b 45 f4             	mov    -0xc(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 63c:	00 
 63d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 644:	00 
 645:	89 44 24 04          	mov    %eax,0x4(%esp)
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	89 04 24             	mov    %eax,(%esp)
 64f:	e8 b0 fe ff ff       	call   504 <printint>
        ap++;
 654:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 658:	e9 ed 00 00 00       	jmp    74a <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 65d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 661:	74 06                	je     669 <printf+0xb4>
 663:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 667:	75 2d                	jne    696 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 675:	00 
 676:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 67d:	00 
 67e:	89 44 24 04          	mov    %eax,0x4(%esp)
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 77 fe ff ff       	call   504 <printint>
        ap++;
 68d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 691:	e9 b4 00 00 00       	jmp    74a <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 696:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 69a:	75 46                	jne    6e2 <printf+0x12d>
        s = (char*)*ap;
 69c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 6a4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 6a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 6ac:	75 27                	jne    6d5 <printf+0x120>
          s = "(null)";
 6ae:	c7 45 e4 f1 0b 00 00 	movl   $0xbf1,-0x1c(%ebp)
        while(*s != 0){
 6b5:	eb 1f                	jmp    6d6 <printf+0x121>
          putc(fd, *s);
 6b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ba:	0f b6 00             	movzbl (%eax),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	89 04 24             	mov    %eax,(%esp)
 6ca:	e8 0d fe ff ff       	call   4dc <putc>
          s++;
 6cf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6d3:	eb 01                	jmp    6d6 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d5:	90                   	nop
 6d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d9:	0f b6 00             	movzbl (%eax),%eax
 6dc:	84 c0                	test   %al,%al
 6de:	75 d7                	jne    6b7 <printf+0x102>
 6e0:	eb 68                	jmp    74a <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e2:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6e6:	75 1d                	jne    705 <printf+0x150>
        putc(fd, *ap);
 6e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	0f be c0             	movsbl %al,%eax
 6f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 dd fd ff ff       	call   4dc <putc>
        ap++;
 6ff:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 703:	eb 45                	jmp    74a <printf+0x195>
      } else if(c == '%'){
 705:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 709:	75 17                	jne    722 <printf+0x16d>
        putc(fd, c);
 70b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70e:	0f be c0             	movsbl %al,%eax
 711:	89 44 24 04          	mov    %eax,0x4(%esp)
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 bc fd ff ff       	call   4dc <putc>
 720:	eb 28                	jmp    74a <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 722:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 729:	00 
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	89 04 24             	mov    %eax,(%esp)
 730:	e8 a7 fd ff ff       	call   4dc <putc>
        putc(fd, c);
 735:	8b 45 e8             	mov    -0x18(%ebp),%eax
 738:	0f be c0             	movsbl %al,%eax
 73b:	89 44 24 04          	mov    %eax,0x4(%esp)
 73f:	8b 45 08             	mov    0x8(%ebp),%eax
 742:	89 04 24             	mov    %eax,(%esp)
 745:	e8 92 fd ff ff       	call   4dc <putc>
      }
      state = 0;
 74a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 751:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 755:	8b 55 0c             	mov    0xc(%ebp),%edx
 758:	8b 45 ec             	mov    -0x14(%ebp),%eax
 75b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 75e:	0f b6 00             	movzbl (%eax),%eax
 761:	84 c0                	test   %al,%al
 763:	0f 85 6e fe ff ff    	jne    5d7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 769:	c9                   	leave  
 76a:	c3                   	ret    
 76b:	90                   	nop

0000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	55                   	push   %ebp
 76d:	89 e5                	mov    %esp,%ebp
 76f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	8b 45 08             	mov    0x8(%ebp),%eax
 775:	83 e8 08             	sub    $0x8,%eax
 778:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77b:	a1 40 0c 00 00       	mov    0xc40,%eax
 780:	89 45 fc             	mov    %eax,-0x4(%ebp)
 783:	eb 24                	jmp    7a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78d:	77 12                	ja     7a1 <free+0x35>
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 795:	77 24                	ja     7bb <free+0x4f>
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79f:	77 1a                	ja     7bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7af:	76 d4                	jbe    785 <free+0x19>
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b9:	76 ca                	jbe    785 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	c1 e0 03             	shl    $0x3,%eax
 7c4:	89 c2                	mov    %eax,%edx
 7c6:	03 55 f8             	add    -0x8(%ebp),%edx
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	39 c2                	cmp    %eax,%edx
 7d0:	75 24                	jne    7f6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	8b 40 04             	mov    0x4(%eax),%eax
 7e0:	01 c2                	add    %eax,%edx
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	89 10                	mov    %edx,(%eax)
 7f4:	eb 0a                	jmp    800 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	c1 e0 03             	shl    $0x3,%eax
 809:	03 45 fc             	add    -0x4(%ebp),%eax
 80c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80f:	75 20                	jne    831 <free+0xc5>
    p->s.size += bp->s.size;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 50 04             	mov    0x4(%eax),%edx
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	01 c2                	add    %eax,%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
 82f:	eb 08                	jmp    839 <free+0xcd>
  } else
    p->s.ptr = bp;
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 55 f8             	mov    -0x8(%ebp),%edx
 837:	89 10                	mov    %edx,(%eax)
  freep = p;
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 841:	c9                   	leave  
 842:	c3                   	ret    

00000843 <morecore>:

static Header*
morecore(uint nu)
{
 843:	55                   	push   %ebp
 844:	89 e5                	mov    %esp,%ebp
 846:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 849:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 850:	77 07                	ja     859 <morecore+0x16>
    nu = 4096;
 852:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 859:	8b 45 08             	mov    0x8(%ebp),%eax
 85c:	c1 e0 03             	shl    $0x3,%eax
 85f:	89 04 24             	mov    %eax,(%esp)
 862:	e8 3d fc ff ff       	call   4a4 <sbrk>
 867:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 86a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 86e:	75 07                	jne    877 <morecore+0x34>
    return 0;
 870:	b8 00 00 00 00       	mov    $0x0,%eax
 875:	eb 22                	jmp    899 <morecore+0x56>
  hp = (Header*)p;
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 55 08             	mov    0x8(%ebp),%edx
 883:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	83 c0 08             	add    $0x8,%eax
 88c:	89 04 24             	mov    %eax,(%esp)
 88f:	e8 d8 fe ff ff       	call   76c <free>
  return freep;
 894:	a1 40 0c 00 00       	mov    0xc40,%eax
}
 899:	c9                   	leave  
 89a:	c3                   	ret    

0000089b <malloc>:

void*
malloc(uint nbytes)
{
 89b:	55                   	push   %ebp
 89c:	89 e5                	mov    %esp,%ebp
 89e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a1:	8b 45 08             	mov    0x8(%ebp),%eax
 8a4:	83 c0 07             	add    $0x7,%eax
 8a7:	c1 e8 03             	shr    $0x3,%eax
 8aa:	83 c0 01             	add    $0x1,%eax
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 8b0:	a1 40 0c 00 00       	mov    0xc40,%eax
 8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8bc:	75 23                	jne    8e1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8be:	c7 45 f0 38 0c 00 00 	movl   $0xc38,-0x10(%ebp)
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	a3 40 0c 00 00       	mov    %eax,0xc40
 8cd:	a1 40 0c 00 00       	mov    0xc40,%eax
 8d2:	a3 38 0c 00 00       	mov    %eax,0xc38
    base.s.size = 0;
 8d7:	c7 05 3c 0c 00 00 00 	movl   $0x0,0xc3c
 8de:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8f2:	72 4d                	jb     941 <malloc+0xa6>
      if(p->s.size == nunits)
 8f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f7:	8b 40 04             	mov    0x4(%eax),%eax
 8fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8fd:	75 0c                	jne    90b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 902:	8b 10                	mov    (%eax),%edx
 904:	8b 45 f0             	mov    -0x10(%ebp),%eax
 907:	89 10                	mov    %edx,(%eax)
 909:	eb 26                	jmp    931 <malloc+0x96>
      else {
        p->s.size -= nunits;
 90b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90e:	8b 40 04             	mov    0x4(%eax),%eax
 911:	89 c2                	mov    %eax,%edx
 913:	2b 55 f4             	sub    -0xc(%ebp),%edx
 916:	8b 45 ec             	mov    -0x14(%ebp),%eax
 919:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91f:	8b 40 04             	mov    0x4(%eax),%eax
 922:	c1 e0 03             	shl    $0x3,%eax
 925:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 928:	8b 45 ec             	mov    -0x14(%ebp),%eax
 92b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 92e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 931:	8b 45 f0             	mov    -0x10(%ebp),%eax
 934:	a3 40 0c 00 00       	mov    %eax,0xc40
      return (void*)(p + 1);
 939:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93c:	83 c0 08             	add    $0x8,%eax
 93f:	eb 38                	jmp    979 <malloc+0xde>
    }
    if(p == freep)
 941:	a1 40 0c 00 00       	mov    0xc40,%eax
 946:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 949:	75 1b                	jne    966 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	89 04 24             	mov    %eax,(%esp)
 951:	e8 ed fe ff ff       	call   843 <morecore>
 956:	89 45 ec             	mov    %eax,-0x14(%ebp)
 959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 95d:	75 07                	jne    966 <malloc+0xcb>
        return 0;
 95f:	b8 00 00 00 00       	mov    $0x0,%eax
 964:	eb 13                	jmp    979 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 966:	8b 45 ec             	mov    -0x14(%ebp),%eax
 969:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 974:	e9 70 ff ff ff       	jmp    8e9 <malloc+0x4e>
}
 979:	c9                   	leave  
 97a:	c3                   	ret    
 97b:	90                   	nop

0000097c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 97c:	55                   	push   %ebp
 97d:	89 e5                	mov    %esp,%ebp
 97f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 982:	8b 55 08             	mov    0x8(%ebp),%edx
 985:	8b 45 0c             	mov    0xc(%ebp),%eax
 988:	8b 4d 08             	mov    0x8(%ebp),%ecx
 98b:	f0 87 02             	lock xchg %eax,(%edx)
 98e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 991:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 994:	c9                   	leave  
 995:	c3                   	ret    

00000996 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 996:	55                   	push   %ebp
 997:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 999:	8b 45 08             	mov    0x8(%ebp),%eax
 99c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9a2:	5d                   	pop    %ebp
 9a3:	c3                   	ret    

000009a4 <lock_acquire>:
void lock_acquire(lock_t *lock){
 9a4:	55                   	push   %ebp
 9a5:	89 e5                	mov    %esp,%ebp
 9a7:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9aa:	8b 45 08             	mov    0x8(%ebp),%eax
 9ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9b4:	00 
 9b5:	89 04 24             	mov    %eax,(%esp)
 9b8:	e8 bf ff ff ff       	call   97c <xchg>
 9bd:	85 c0                	test   %eax,%eax
 9bf:	75 e9                	jne    9aa <lock_acquire+0x6>
}
 9c1:	c9                   	leave  
 9c2:	c3                   	ret    

000009c3 <lock_release>:
void lock_release(lock_t *lock){
 9c3:	55                   	push   %ebp
 9c4:	89 e5                	mov    %esp,%ebp
 9c6:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
 9cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9d3:	00 
 9d4:	89 04 24             	mov    %eax,(%esp)
 9d7:	e8 a0 ff ff ff       	call   97c <xchg>
}
 9dc:	c9                   	leave  
 9dd:	c3                   	ret    

000009de <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 9de:	55                   	push   %ebp
 9df:	89 e5                	mov    %esp,%ebp
 9e1:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 9e4:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 9eb:	e8 ab fe ff ff       	call   89b <malloc>
 9f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 9f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 9f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fc:	25 ff 0f 00 00       	and    $0xfff,%eax
 a01:	85 c0                	test   %eax,%eax
 a03:	74 15                	je     a1a <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a08:	89 c2                	mov    %eax,%edx
 a0a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 a10:	b8 00 10 00 00       	mov    $0x1000,%eax
 a15:	29 d0                	sub    %edx,%eax
 a17:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 a1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a1e:	75 1b                	jne    a3b <thread_create+0x5d>

        printf(1,"malloc fail \n");
 a20:	c7 44 24 04 f8 0b 00 	movl   $0xbf8,0x4(%esp)
 a27:	00 
 a28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a2f:	e8 81 fb ff ff       	call   5b5 <printf>
        return 0;
 a34:	b8 00 00 00 00       	mov    $0x0,%eax
 a39:	eb 6f                	jmp    aaa <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a3e:	8b 55 08             	mov    0x8(%ebp),%edx
 a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a44:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a48:	89 54 24 08          	mov    %edx,0x8(%esp)
 a4c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a53:	00 
 a54:	89 04 24             	mov    %eax,(%esp)
 a57:	e8 60 fa ff ff       	call   4bc <clone>
 a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a63:	79 1b                	jns    a80 <thread_create+0xa2>
        printf(1,"clone fails\n");
 a65:	c7 44 24 04 06 0c 00 	movl   $0xc06,0x4(%esp)
 a6c:	00 
 a6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a74:	e8 3c fb ff ff       	call   5b5 <printf>
        return 0;
 a79:	b8 00 00 00 00       	mov    $0x0,%eax
 a7e:	eb 2a                	jmp    aaa <thread_create+0xcc>
    }
    if(tid > 0){
 a80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a84:	7e 05                	jle    a8b <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	eb 1f                	jmp    aaa <thread_create+0xcc>
    }
    if(tid == 0){
 a8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a8f:	75 14                	jne    aa5 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 a91:	c7 44 24 04 13 0c 00 	movl   $0xc13,0x4(%esp)
 a98:	00 
 a99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aa0:	e8 10 fb ff ff       	call   5b5 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 aaa:	c9                   	leave  
 aab:	c3                   	ret    

00000aac <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 aac:	55                   	push   %ebp
 aad:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 aaf:	8b 45 08             	mov    0x8(%ebp),%eax
 ab2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ab8:	8b 45 08             	mov    0x8(%ebp),%eax
 abb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 ac2:	8b 45 08             	mov    0x8(%ebp),%eax
 ac5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 acc:	5d                   	pop    %ebp
 acd:	c3                   	ret    

00000ace <add_q>:

void add_q(struct queue *q, int v){
 ace:	55                   	push   %ebp
 acf:	89 e5                	mov    %esp,%ebp
 ad1:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 ad4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 adb:	e8 bb fd ff ff       	call   89b <malloc>
 ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af0:	8b 55 0c             	mov    0xc(%ebp),%edx
 af3:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 af5:	8b 45 08             	mov    0x8(%ebp),%eax
 af8:	8b 40 04             	mov    0x4(%eax),%eax
 afb:	85 c0                	test   %eax,%eax
 afd:	75 0b                	jne    b0a <add_q+0x3c>
        q->head = n;
 aff:	8b 45 08             	mov    0x8(%ebp),%eax
 b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b05:	89 50 04             	mov    %edx,0x4(%eax)
 b08:	eb 0c                	jmp    b16 <add_q+0x48>
    }else{
        q->tail->next = n;
 b0a:	8b 45 08             	mov    0x8(%ebp),%eax
 b0d:	8b 40 08             	mov    0x8(%eax),%eax
 b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b13:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b16:	8b 45 08             	mov    0x8(%ebp),%eax
 b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b1c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	8b 00                	mov    (%eax),%eax
 b24:	8d 50 01             	lea    0x1(%eax),%edx
 b27:	8b 45 08             	mov    0x8(%ebp),%eax
 b2a:	89 10                	mov    %edx,(%eax)
}
 b2c:	c9                   	leave  
 b2d:	c3                   	ret    

00000b2e <empty_q>:

int empty_q(struct queue *q){
 b2e:	55                   	push   %ebp
 b2f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b31:	8b 45 08             	mov    0x8(%ebp),%eax
 b34:	8b 00                	mov    (%eax),%eax
 b36:	85 c0                	test   %eax,%eax
 b38:	75 07                	jne    b41 <empty_q+0x13>
        return 1;
 b3a:	b8 01 00 00 00       	mov    $0x1,%eax
 b3f:	eb 05                	jmp    b46 <empty_q+0x18>
    else
        return 0;
 b41:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b46:	5d                   	pop    %ebp
 b47:	c3                   	ret    

00000b48 <pop_q>:
int pop_q(struct queue *q){
 b48:	55                   	push   %ebp
 b49:	89 e5                	mov    %esp,%ebp
 b4b:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b4e:	8b 45 08             	mov    0x8(%ebp),%eax
 b51:	89 04 24             	mov    %eax,(%esp)
 b54:	e8 d5 ff ff ff       	call   b2e <empty_q>
 b59:	85 c0                	test   %eax,%eax
 b5b:	75 5d                	jne    bba <pop_q+0x72>
       val = q->head->value; 
 b5d:	8b 45 08             	mov    0x8(%ebp),%eax
 b60:	8b 40 04             	mov    0x4(%eax),%eax
 b63:	8b 00                	mov    (%eax),%eax
 b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 b68:	8b 45 08             	mov    0x8(%ebp),%eax
 b6b:	8b 40 04             	mov    0x4(%eax),%eax
 b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 b71:	8b 45 08             	mov    0x8(%ebp),%eax
 b74:	8b 40 04             	mov    0x4(%eax),%eax
 b77:	8b 50 04             	mov    0x4(%eax),%edx
 b7a:	8b 45 08             	mov    0x8(%ebp),%eax
 b7d:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b83:	89 04 24             	mov    %eax,(%esp)
 b86:	e8 e1 fb ff ff       	call   76c <free>
       q->size--;
 b8b:	8b 45 08             	mov    0x8(%ebp),%eax
 b8e:	8b 00                	mov    (%eax),%eax
 b90:	8d 50 ff             	lea    -0x1(%eax),%edx
 b93:	8b 45 08             	mov    0x8(%ebp),%eax
 b96:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 b98:	8b 45 08             	mov    0x8(%ebp),%eax
 b9b:	8b 00                	mov    (%eax),%eax
 b9d:	85 c0                	test   %eax,%eax
 b9f:	75 14                	jne    bb5 <pop_q+0x6d>
            q->head = 0;
 ba1:	8b 45 08             	mov    0x8(%ebp),%eax
 ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bab:	8b 45 08             	mov    0x8(%ebp),%eax
 bae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb8:	eb 05                	jmp    bbf <pop_q+0x77>
    }
    return -1;
 bba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bbf:	c9                   	leave  
 bc0:	c3                   	ret    

00000bc1 <front>:

int front(struct queue *q)
{
 bc1:	55                   	push   %ebp
 bc2:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 bc4:	8b 45 08             	mov    0x8(%ebp),%eax
 bc7:	8b 40 04             	mov    0x4(%eax),%eax
 bca:	8b 00                	mov    (%eax),%eax
}
 bcc:	5d                   	pop    %ebp
 bcd:	c3                   	ret    
