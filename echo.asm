
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 45                	jmp    58 <main+0x58>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 7e 0a 00 00       	mov    $0xa7e,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 80 0a 00 00       	mov    $0xa80,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	c1 e2 02             	shl    $0x2,%edx
  32:	03 55 0c             	add    0xc(%ebp),%edx
  35:	8b 12                	mov    (%edx),%edx
  37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  3f:	c7 44 24 04 82 0a 00 	movl   $0xa82,0x4(%esp)
  46:	00 
  47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4e:	e8 12 04 00 00       	call   465 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  53:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c b2                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  61:	e8 66 02 00 00       	call   2cc <exit>
  66:	90                   	nop
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	0f 95 c0             	setne  %al
  af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b7:	84 c0                	test   %al,%al
  b9:	75 de                	jne    99 <strcpy+0xc>
    ;
  return os;
  bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c3:	eb 08                	jmp    cd <strcmp+0xd>
    p++, q++;
  c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	74 10                	je     e7 <strcmp+0x27>
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	38 c2                	cmp    %al,%dl
  e5:	74 de                	je     c5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	0f b6 d0             	movzbl %al,%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 c0             	movzbl %al,%eax
  f9:	89 d1                	mov    %edx,%ecx
  fb:	29 c1                	sub    %eax,%ecx
  fd:	89 c8                	mov    %ecx,%eax
}
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strlen>:

uint
strlen(char *s)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10e:	eb 04                	jmp    114 <strlen+0x13>
 110:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 114:	8b 45 fc             	mov    -0x4(%ebp),%eax
 117:	03 45 08             	add    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 ef                	jne    110 <strlen+0xf>
    ;
  return n;
 121:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12c:	8b 45 10             	mov    0x10(%ebp),%eax
 12f:	89 44 24 08          	mov    %eax,0x8(%esp)
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	89 44 24 04          	mov    %eax,0x4(%esp)
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 04 24             	mov    %eax,(%esp)
 140:	e8 23 ff ff ff       	call   68 <stosb>
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 18a:	eb 44                	jmp    1d0 <gets+0x53>
    cc = read(0, &c, 1);
 18c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 193:	00 
 194:	8d 45 ef             	lea    -0x11(%ebp),%eax
 197:	89 44 24 04          	mov    %eax,0x4(%esp)
 19b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a2:	e8 3d 01 00 00       	call   2e4 <read>
 1a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ae:	7e 2d                	jle    1dd <gets+0x60>
      break;
    buf[i++] = c;
 1b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b3:	03 45 08             	add    0x8(%ebp),%eax
 1b6:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ba:	88 10                	mov    %dl,(%eax)
 1bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c4:	3c 0a                	cmp    $0xa,%al
 1c6:	74 16                	je     1de <gets+0x61>
 1c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cc:	3c 0d                	cmp    $0xd,%al
 1ce:	74 0e                	je     1de <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d9:	7c b1                	jl     18c <gets+0xf>
 1db:	eb 01                	jmp    1de <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1dd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e1:	03 45 08             	add    0x8(%ebp),%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f9:	00 
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 07 01 00 00       	call   30c <open>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20c:	79 07                	jns    215 <stat+0x29>
    return -1;
 20e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 213:	eb 23                	jmp    238 <stat+0x4c>
  r = fstat(fd, st);
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	89 44 24 04          	mov    %eax,0x4(%esp)
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 fd 00 00 00       	call   324 <fstat>
 227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22d:	89 04 24             	mov    %eax,(%esp)
 230:	e8 bf 00 00 00       	call   2f4 <close>
  return r;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <atoi>:

int
atoi(const char *s)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 247:	eb 24                	jmp    26d <atoi+0x33>
    n = n*10 + *s++ - '0';
 249:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24c:	89 d0                	mov    %edx,%eax
 24e:	c1 e0 02             	shl    $0x2,%eax
 251:	01 d0                	add    %edx,%eax
 253:	01 c0                	add    %eax,%eax
 255:	89 c2                	mov    %eax,%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	0f be c0             	movsbl %al,%eax
 260:	8d 04 02             	lea    (%edx,%eax,1),%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
 269:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x47>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c8                	jle    249 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 298:	eb 13                	jmp    2ad <memmove+0x27>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	0f b6 10             	movzbl (%eax),%edx
 2a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a3:	88 10                	mov    %dl,(%eax)
 2a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b1:	0f 9f c0             	setg   %al
 2b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b8:	84 c0                	test   %al,%al
 2ba:	75 de                	jne    29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    
 2c1:	90                   	nop
 2c2:	90                   	nop
 2c3:	90                   	nop

000002c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c4:	b8 01 00 00 00       	mov    $0x1,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <exit>:
SYSCALL(exit)
 2cc:	b8 02 00 00 00       	mov    $0x2,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <wait>:
SYSCALL(wait)
 2d4:	b8 03 00 00 00       	mov    $0x3,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <pipe>:
SYSCALL(pipe)
 2dc:	b8 04 00 00 00       	mov    $0x4,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <read>:
SYSCALL(read)
 2e4:	b8 05 00 00 00       	mov    $0x5,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <write>:
SYSCALL(write)
 2ec:	b8 10 00 00 00       	mov    $0x10,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <close>:
SYSCALL(close)
 2f4:	b8 15 00 00 00       	mov    $0x15,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <kill>:
SYSCALL(kill)
 2fc:	b8 06 00 00 00       	mov    $0x6,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <exec>:
SYSCALL(exec)
 304:	b8 07 00 00 00       	mov    $0x7,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <open>:
SYSCALL(open)
 30c:	b8 0f 00 00 00       	mov    $0xf,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <mknod>:
SYSCALL(mknod)
 314:	b8 11 00 00 00       	mov    $0x11,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <unlink>:
SYSCALL(unlink)
 31c:	b8 12 00 00 00       	mov    $0x12,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <fstat>:
SYSCALL(fstat)
 324:	b8 08 00 00 00       	mov    $0x8,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <link>:
SYSCALL(link)
 32c:	b8 13 00 00 00       	mov    $0x13,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mkdir>:
SYSCALL(mkdir)
 334:	b8 14 00 00 00       	mov    $0x14,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <chdir>:
SYSCALL(chdir)
 33c:	b8 09 00 00 00       	mov    $0x9,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <dup>:
SYSCALL(dup)
 344:	b8 0a 00 00 00       	mov    $0xa,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <getpid>:
SYSCALL(getpid)
 34c:	b8 0b 00 00 00       	mov    $0xb,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sbrk>:
SYSCALL(sbrk)
 354:	b8 0c 00 00 00       	mov    $0xc,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sleep>:
SYSCALL(sleep)
 35c:	b8 0d 00 00 00       	mov    $0xd,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <uptime>:
SYSCALL(uptime)
 364:	b8 0e 00 00 00       	mov    $0xe,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <clone>:
SYSCALL(clone)
 36c:	b8 16 00 00 00       	mov    $0x16,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <texit>:
SYSCALL(texit)
 374:	b8 17 00 00 00       	mov    $0x17,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <tsleep>:
SYSCALL(tsleep)
 37c:	b8 18 00 00 00       	mov    $0x18,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <twakeup>:
SYSCALL(twakeup)
 384:	b8 19 00 00 00       	mov    $0x19,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	83 ec 28             	sub    $0x28,%esp
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 398:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39f:	00 
 3a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 3a ff ff ff       	call   2ec <write>
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	53                   	push   %ebx
 3b8:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c6:	74 17                	je     3df <printint+0x2b>
 3c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3cc:	79 11                	jns    3df <printint+0x2b>
    neg = 1;
 3ce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	f7 d8                	neg    %eax
 3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3dd:	eb 06                	jmp    3e5 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ec:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f5:	ba 00 00 00 00       	mov    $0x0,%edx
 3fa:	f7 f3                	div    %ebx
 3fc:	89 d0                	mov    %edx,%eax
 3fe:	0f b6 80 bc 0a 00 00 	movzbl 0xabc(%eax),%eax
 405:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 409:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 40d:	8b 45 10             	mov    0x10(%ebp),%eax
 410:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	ba 00 00 00 00       	mov    $0x0,%edx
 41b:	f7 75 d4             	divl   -0x2c(%ebp)
 41e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 425:	75 c5                	jne    3ec <printint+0x38>
  if(neg)
 427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42b:	74 28                	je     455 <printint+0xa1>
    buf[i++] = '-';
 42d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 430:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 435:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 439:	eb 1a                	jmp    455 <printint+0xa1>
    putc(fd, buf[i]);
 43b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 443:	0f be c0             	movsbl %al,%eax
 446:	89 44 24 04          	mov    %eax,0x4(%esp)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	89 04 24             	mov    %eax,(%esp)
 450:	e8 37 ff ff ff       	call   38c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 455:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 459:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45d:	79 dc                	jns    43b <printint+0x87>
    putc(fd, buf[i]);
}
 45f:	83 c4 44             	add    $0x44,%esp
 462:	5b                   	pop    %ebx
 463:	5d                   	pop    %ebp
 464:	c3                   	ret    

00000465 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 46b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 472:	8d 45 0c             	lea    0xc(%ebp),%eax
 475:	83 c0 04             	add    $0x4,%eax
 478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 47b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 482:	e9 7e 01 00 00       	jmp    605 <printf+0x1a0>
    c = fmt[i] & 0xff;
 487:	8b 55 0c             	mov    0xc(%ebp),%edx
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	25 ff 00 00 00       	and    $0xff,%eax
 49b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 49e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a2:	75 2c                	jne    4d0 <printf+0x6b>
      if(c == '%'){
 4a4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4a8:	75 0c                	jne    4b6 <printf+0x51>
        state = '%';
 4aa:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4b1:	e9 4b 01 00 00       	jmp    601 <printf+0x19c>
      } else {
        putc(fd, c);
 4b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 c1 fe ff ff       	call   38c <putc>
 4cb:	e9 31 01 00 00       	jmp    601 <printf+0x19c>
      }
    } else if(state == '%'){
 4d0:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4d4:	0f 85 27 01 00 00    	jne    601 <printf+0x19c>
      if(c == 'd'){
 4da:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4de:	75 2d                	jne    50d <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ec:	00 
 4ed:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f4:	00 
 4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 b0 fe ff ff       	call   3b4 <printint>
        ap++;
 504:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 508:	e9 ed 00 00 00       	jmp    5fa <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 50d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 511:	74 06                	je     519 <printf+0xb4>
 513:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 517:	75 2d                	jne    546 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 519:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51c:	8b 00                	mov    (%eax),%eax
 51e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 525:	00 
 526:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 52d:	00 
 52e:	89 44 24 04          	mov    %eax,0x4(%esp)
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	89 04 24             	mov    %eax,(%esp)
 538:	e8 77 fe ff ff       	call   3b4 <printint>
        ap++;
 53d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 541:	e9 b4 00 00 00       	jmp    5fa <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 546:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 54a:	75 46                	jne    592 <printf+0x12d>
        s = (char*)*ap;
 54c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 554:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 558:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 55c:	75 27                	jne    585 <printf+0x120>
          s = "(null)";
 55e:	c7 45 e4 87 0a 00 00 	movl   $0xa87,-0x1c(%ebp)
        while(*s != 0){
 565:	eb 1f                	jmp    586 <printf+0x121>
          putc(fd, *s);
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	89 44 24 04          	mov    %eax,0x4(%esp)
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 0d fe ff ff       	call   38c <putc>
          s++;
 57f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 583:	eb 01                	jmp    586 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 585:	90                   	nop
 586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 589:	0f b6 00             	movzbl (%eax),%eax
 58c:	84 c0                	test   %al,%al
 58e:	75 d7                	jne    567 <printf+0x102>
 590:	eb 68                	jmp    5fa <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 592:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 596:	75 1d                	jne    5b5 <printf+0x150>
        putc(fd, *ap);
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	8b 00                	mov    (%eax),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 dd fd ff ff       	call   38c <putc>
        ap++;
 5af:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5b3:	eb 45                	jmp    5fa <printf+0x195>
      } else if(c == '%'){
 5b5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5b9:	75 17                	jne    5d2 <printf+0x16d>
        putc(fd, c);
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 bc fd ff ff       	call   38c <putc>
 5d0:	eb 28                	jmp    5fa <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d9:	00 
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 a7 fd ff ff       	call   38c <putc>
        putc(fd, c);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	0f be c0             	movsbl %al,%eax
 5eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 92 fd ff ff       	call   38c <putc>
      }
      state = 0;
 5fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 601:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 605:	8b 55 0c             	mov    0xc(%ebp),%edx
 608:	8b 45 ec             	mov    -0x14(%ebp),%eax
 60b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	0f 85 6e fe ff ff    	jne    487 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 619:	c9                   	leave  
 61a:	c3                   	ret    
 61b:	90                   	nop

0000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	83 e8 08             	sub    $0x8,%eax
 628:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62b:	a1 d8 0a 00 00       	mov    0xad8,%eax
 630:	89 45 fc             	mov    %eax,-0x4(%ebp)
 633:	eb 24                	jmp    659 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	77 12                	ja     651 <free+0x35>
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 24                	ja     66b <free+0x4f>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	77 1a                	ja     66b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	89 45 fc             	mov    %eax,-0x4(%ebp)
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65f:	76 d4                	jbe    635 <free+0x19>
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 669:	76 ca                	jbe    635 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	c1 e0 03             	shl    $0x3,%eax
 674:	89 c2                	mov    %eax,%edx
 676:	03 55 f8             	add    -0x8(%ebp),%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	39 c2                	cmp    %eax,%edx
 680:	75 24                	jne    6a6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 40 04             	mov    0x4(%eax),%eax
 690:	01 c2                	add    %eax,%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 0a                	jmp    6b0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	c1 e0 03             	shl    $0x3,%eax
 6b9:	03 45 fc             	add    -0x4(%ebp),%eax
 6bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bf:	75 20                	jne    6e1 <free+0xc5>
    p->s.size += bp->s.size;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 50 04             	mov    0x4(%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	01 c2                	add    %eax,%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 10                	mov    %edx,(%eax)
 6df:	eb 08                	jmp    6e9 <free+0xcd>
  } else
    p->s.ptr = bp;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	a3 d8 0a 00 00       	mov    %eax,0xad8
}
 6f1:	c9                   	leave  
 6f2:	c3                   	ret    

000006f3 <morecore>:

static Header*
morecore(uint nu)
{
 6f3:	55                   	push   %ebp
 6f4:	89 e5                	mov    %esp,%ebp
 6f6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 700:	77 07                	ja     709 <morecore+0x16>
    nu = 4096;
 702:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 709:	8b 45 08             	mov    0x8(%ebp),%eax
 70c:	c1 e0 03             	shl    $0x3,%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 3d fc ff ff       	call   354 <sbrk>
 717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 71a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 71e:	75 07                	jne    727 <morecore+0x34>
    return 0;
 720:	b8 00 00 00 00       	mov    $0x0,%eax
 725:	eb 22                	jmp    749 <morecore+0x56>
  hp = (Header*)p;
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	8b 55 08             	mov    0x8(%ebp),%edx
 733:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	83 c0 08             	add    $0x8,%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 d8 fe ff ff       	call   61c <free>
  return freep;
 744:	a1 d8 0a 00 00       	mov    0xad8,%eax
}
 749:	c9                   	leave  
 74a:	c3                   	ret    

0000074b <malloc>:

void*
malloc(uint nbytes)
{
 74b:	55                   	push   %ebp
 74c:	89 e5                	mov    %esp,%ebp
 74e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	83 c0 07             	add    $0x7,%eax
 757:	c1 e8 03             	shr    $0x3,%eax
 75a:	83 c0 01             	add    $0x1,%eax
 75d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 760:	a1 d8 0a 00 00       	mov    0xad8,%eax
 765:	89 45 f0             	mov    %eax,-0x10(%ebp)
 768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76c:	75 23                	jne    791 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76e:	c7 45 f0 d0 0a 00 00 	movl   $0xad0,-0x10(%ebp)
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	a3 d8 0a 00 00       	mov    %eax,0xad8
 77d:	a1 d8 0a 00 00       	mov    0xad8,%eax
 782:	a3 d0 0a 00 00       	mov    %eax,0xad0
    base.s.size = 0;
 787:	c7 05 d4 0a 00 00 00 	movl   $0x0,0xad4
 78e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 799:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7a2:	72 4d                	jb     7f1 <malloc+0xa6>
      if(p->s.size == nunits)
 7a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7ad:	75 0c                	jne    7bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b2:	8b 10                	mov    (%eax),%edx
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	89 10                	mov    %edx,(%eax)
 7b9:	eb 26                	jmp    7e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	89 c2                	mov    %eax,%edx
 7c3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	c1 e0 03             	shl    $0x3,%eax
 7d5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	a3 d8 0a 00 00       	mov    %eax,0xad8
      return (void*)(p + 1);
 7e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ec:	83 c0 08             	add    $0x8,%eax
 7ef:	eb 38                	jmp    829 <malloc+0xde>
    }
    if(p == freep)
 7f1:	a1 d8 0a 00 00       	mov    0xad8,%eax
 7f6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f9:	75 1b                	jne    816 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	89 04 24             	mov    %eax,(%esp)
 801:	e8 ed fe ff ff       	call   6f3 <morecore>
 806:	89 45 ec             	mov    %eax,-0x14(%ebp)
 809:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80d:	75 07                	jne    816 <malloc+0xcb>
        return 0;
 80f:	b8 00 00 00 00       	mov    $0x0,%eax
 814:	eb 13                	jmp    829 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	8b 45 ec             	mov    -0x14(%ebp),%eax
 819:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 824:	e9 70 ff ff ff       	jmp    799 <malloc+0x4e>
}
 829:	c9                   	leave  
 82a:	c3                   	ret    
 82b:	90                   	nop

0000082c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 82c:	55                   	push   %ebp
 82d:	89 e5                	mov    %esp,%ebp
 82f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 832:	8b 55 08             	mov    0x8(%ebp),%edx
 835:	8b 45 0c             	mov    0xc(%ebp),%eax
 838:	8b 4d 08             	mov    0x8(%ebp),%ecx
 83b:	f0 87 02             	lock xchg %eax,(%edx)
 83e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 844:	c9                   	leave  
 845:	c3                   	ret    

00000846 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 846:	55                   	push   %ebp
 847:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
 84c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 852:	5d                   	pop    %ebp
 853:	c3                   	ret    

00000854 <lock_acquire>:
void lock_acquire(lock_t *lock){
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 864:	00 
 865:	89 04 24             	mov    %eax,(%esp)
 868:	e8 bf ff ff ff       	call   82c <xchg>
 86d:	85 c0                	test   %eax,%eax
 86f:	75 e9                	jne    85a <lock_acquire+0x6>
}
 871:	c9                   	leave  
 872:	c3                   	ret    

00000873 <lock_release>:
void lock_release(lock_t *lock){
 873:	55                   	push   %ebp
 874:	89 e5                	mov    %esp,%ebp
 876:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 879:	8b 45 08             	mov    0x8(%ebp),%eax
 87c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 883:	00 
 884:	89 04 24             	mov    %eax,(%esp)
 887:	e8 a0 ff ff ff       	call   82c <xchg>
}
 88c:	c9                   	leave  
 88d:	c3                   	ret    

0000088e <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 88e:	55                   	push   %ebp
 88f:	89 e5                	mov    %esp,%ebp
 891:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 894:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 89b:	e8 ab fe ff ff       	call   74b <malloc>
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 8a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ac:	25 ff 0f 00 00       	and    $0xfff,%eax
 8b1:	85 c0                	test   %eax,%eax
 8b3:	74 15                	je     8ca <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	89 c2                	mov    %eax,%edx
 8ba:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 8c0:	b8 00 10 00 00       	mov    $0x1000,%eax
 8c5:	29 d0                	sub    %edx,%eax
 8c7:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 8ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ce:	75 1b                	jne    8eb <thread_create+0x5d>

        printf(1,"malloc fail \n");
 8d0:	c7 44 24 04 8e 0a 00 	movl   $0xa8e,0x4(%esp)
 8d7:	00 
 8d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8df:	e8 81 fb ff ff       	call   465 <printf>
        return 0;
 8e4:	b8 00 00 00 00       	mov    $0x0,%eax
 8e9:	eb 6f                	jmp    95a <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 8eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8ee:	8b 55 08             	mov    0x8(%ebp),%edx
 8f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8f8:	89 54 24 08          	mov    %edx,0x8(%esp)
 8fc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 903:	00 
 904:	89 04 24             	mov    %eax,(%esp)
 907:	e8 60 fa ff ff       	call   36c <clone>
 90c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 90f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 913:	79 1b                	jns    930 <thread_create+0xa2>
        printf(1,"clone fails\n");
 915:	c7 44 24 04 9c 0a 00 	movl   $0xa9c,0x4(%esp)
 91c:	00 
 91d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 924:	e8 3c fb ff ff       	call   465 <printf>
        return 0;
 929:	b8 00 00 00 00       	mov    $0x0,%eax
 92e:	eb 2a                	jmp    95a <thread_create+0xcc>
    }
    if(tid > 0){
 930:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 934:	7e 05                	jle    93b <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	eb 1f                	jmp    95a <thread_create+0xcc>
    }
    if(tid == 0){
 93b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 93f:	75 14                	jne    955 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 941:	c7 44 24 04 a9 0a 00 	movl   $0xaa9,0x4(%esp)
 948:	00 
 949:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 950:	e8 10 fb ff ff       	call   465 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 955:	b8 00 00 00 00       	mov    $0x0,%eax
}
 95a:	c9                   	leave  
 95b:	c3                   	ret    

0000095c <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 95c:	55                   	push   %ebp
 95d:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 95f:	8b 45 08             	mov    0x8(%ebp),%eax
 962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 968:	8b 45 08             	mov    0x8(%ebp),%eax
 96b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 972:	8b 45 08             	mov    0x8(%ebp),%eax
 975:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 97c:	5d                   	pop    %ebp
 97d:	c3                   	ret    

0000097e <add_q>:

void add_q(struct queue *q, int v){
 97e:	55                   	push   %ebp
 97f:	89 e5                	mov    %esp,%ebp
 981:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 984:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 98b:	e8 bb fd ff ff       	call   74b <malloc>
 990:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 9a3:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	8b 40 04             	mov    0x4(%eax),%eax
 9ab:	85 c0                	test   %eax,%eax
 9ad:	75 0b                	jne    9ba <add_q+0x3c>
        q->head = n;
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9b5:	89 50 04             	mov    %edx,0x4(%eax)
 9b8:	eb 0c                	jmp    9c6 <add_q+0x48>
    }else{
        q->tail->next = n;
 9ba:	8b 45 08             	mov    0x8(%ebp),%eax
 9bd:	8b 40 08             	mov    0x8(%eax),%eax
 9c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9c3:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 9c6:	8b 45 08             	mov    0x8(%ebp),%eax
 9c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9cc:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 9cf:	8b 45 08             	mov    0x8(%ebp),%eax
 9d2:	8b 00                	mov    (%eax),%eax
 9d4:	8d 50 01             	lea    0x1(%eax),%edx
 9d7:	8b 45 08             	mov    0x8(%ebp),%eax
 9da:	89 10                	mov    %edx,(%eax)
}
 9dc:	c9                   	leave  
 9dd:	c3                   	ret    

000009de <empty_q>:

int empty_q(struct queue *q){
 9de:	55                   	push   %ebp
 9df:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 9e1:	8b 45 08             	mov    0x8(%ebp),%eax
 9e4:	8b 00                	mov    (%eax),%eax
 9e6:	85 c0                	test   %eax,%eax
 9e8:	75 07                	jne    9f1 <empty_q+0x13>
        return 1;
 9ea:	b8 01 00 00 00       	mov    $0x1,%eax
 9ef:	eb 05                	jmp    9f6 <empty_q+0x18>
    else
        return 0;
 9f1:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 9f6:	5d                   	pop    %ebp
 9f7:	c3                   	ret    

000009f8 <pop_q>:
int pop_q(struct queue *q){
 9f8:	55                   	push   %ebp
 9f9:	89 e5                	mov    %esp,%ebp
 9fb:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 9fe:	8b 45 08             	mov    0x8(%ebp),%eax
 a01:	89 04 24             	mov    %eax,(%esp)
 a04:	e8 d5 ff ff ff       	call   9de <empty_q>
 a09:	85 c0                	test   %eax,%eax
 a0b:	75 5d                	jne    a6a <pop_q+0x72>
       val = q->head->value; 
 a0d:	8b 45 08             	mov    0x8(%ebp),%eax
 a10:	8b 40 04             	mov    0x4(%eax),%eax
 a13:	8b 00                	mov    (%eax),%eax
 a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 a18:	8b 45 08             	mov    0x8(%ebp),%eax
 a1b:	8b 40 04             	mov    0x4(%eax),%eax
 a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 a21:	8b 45 08             	mov    0x8(%ebp),%eax
 a24:	8b 40 04             	mov    0x4(%eax),%eax
 a27:	8b 50 04             	mov    0x4(%eax),%edx
 a2a:	8b 45 08             	mov    0x8(%ebp),%eax
 a2d:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	89 04 24             	mov    %eax,(%esp)
 a36:	e8 e1 fb ff ff       	call   61c <free>
       q->size--;
 a3b:	8b 45 08             	mov    0x8(%ebp),%eax
 a3e:	8b 00                	mov    (%eax),%eax
 a40:	8d 50 ff             	lea    -0x1(%eax),%edx
 a43:	8b 45 08             	mov    0x8(%ebp),%eax
 a46:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 a48:	8b 45 08             	mov    0x8(%ebp),%eax
 a4b:	8b 00                	mov    (%eax),%eax
 a4d:	85 c0                	test   %eax,%eax
 a4f:	75 14                	jne    a65 <pop_q+0x6d>
            q->head = 0;
 a51:	8b 45 08             	mov    0x8(%ebp),%eax
 a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 a5b:	8b 45 08             	mov    0x8(%ebp),%eax
 a5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	eb 05                	jmp    a6f <pop_q+0x77>
    }
    return -1;
 a6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a6f:	c9                   	leave  
 a70:	c3                   	ret    

00000a71 <front>:

int front(struct queue *q)
{
 a71:	55                   	push   %ebp
 a72:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 a74:	8b 45 08             	mov    0x8(%ebp),%eax
 a77:	8b 40 04             	mov    0x4(%eax),%eax
 a7a:	8b 00                	mov    (%eax),%eax
}
 a7c:	5d                   	pop    %ebp
 a7d:	c3                   	ret    
