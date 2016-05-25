
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 72 02 00 00       	call   280 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fa 02 00 00       	call   318 <sleep>
  exit();
  1e:	e8 65 02 00 00       	call   288 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	8b 45 0c             	mov    0xc(%ebp),%eax
  58:	0f b6 10             	movzbl (%eax),%edx
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	84 c0                	test   %al,%al
  68:	0f 95 c0             	setne  %al
  6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  73:	84 c0                	test   %al,%al
  75:	75 de                	jne    55 <strcpy+0xc>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	89 d1                	mov    %edx,%ecx
  b7:	29 c1                	sub    %eax,%ecx
  b9:	89 c8                	mov    %ecx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d3:	03 45 08             	add    0x8(%ebp),%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 ef                	jne    cc <strlen+0xf>
    ;
  return n;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e8:	8b 45 10             	mov    0x10(%ebp),%eax
  eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	89 04 24             	mov    %eax,(%esp)
  fc:	e8 23 ff ff ff       	call   24 <stosb>
  return dst;
 101:	8b 45 08             	mov    0x8(%ebp),%eax
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 112:	eb 14                	jmp    128 <strchr+0x22>
    if(*s == c)
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11d:	75 05                	jne    124 <strchr+0x1e>
      return (char*)s;
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	eb 13                	jmp    137 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	84 c0                	test   %al,%al
 130:	75 e2                	jne    114 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 132:	b8 00 00 00 00       	mov    $0x0,%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <gets>:

char*
gets(char *buf, int max)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 146:	eb 44                	jmp    18c <gets+0x53>
    cc = read(0, &c, 1);
 148:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14f:	00 
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	89 44 24 04          	mov    %eax,0x4(%esp)
 157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15e:	e8 3d 01 00 00       	call   2a0 <read>
 163:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 16a:	7e 2d                	jle    199 <gets+0x60>
      break;
    buf[i++] = c;
 16c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 16f:	03 45 08             	add    0x8(%ebp),%eax
 172:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 176:	88 10                	mov    %dl,(%eax)
 178:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 17c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 16                	je     19a <gets+0x61>
 184:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0e                	je     19a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 18f:	83 c0 01             	add    $0x1,%eax
 192:	3b 45 0c             	cmp    0xc(%ebp),%eax
 195:	7c b1                	jl     148 <gets+0xf>
 197:	eb 01                	jmp    19a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 199:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 19d:	03 45 08             	add    0x8(%ebp),%eax
 1a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <stat>:

int
stat(char *n, struct stat *st)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b5:	00 
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	89 04 24             	mov    %eax,(%esp)
 1bc:	e8 07 01 00 00       	call   2c8 <open>
 1c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 1c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x29>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 23                	jmp    1f4 <stat+0x4c>
  r = fstat(fd, st);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 fd 00 00 00       	call   2e0 <fstat>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 bf 00 00 00       	call   2b0 <close>
  return r;
 1f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 203:	eb 24                	jmp    229 <atoi+0x33>
    n = n*10 + *s++ - '0';
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	89 d0                	mov    %edx,%eax
 20a:	c1 e0 02             	shl    $0x2,%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	01 c0                	add    %eax,%eax
 211:	89 c2                	mov    %eax,%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 00             	movzbl (%eax),%eax
 219:	0f be c0             	movsbl %al,%eax
 21c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
 225:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 2f                	cmp    $0x2f,%al
 231:	7e 0a                	jle    23d <atoi+0x47>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	3c 39                	cmp    $0x39,%al
 23b:	7e c8                	jle    205 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 23d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 254:	eb 13                	jmp    269 <memmove+0x27>
    *dst++ = *src++;
 256:	8b 45 fc             	mov    -0x4(%ebp),%eax
 259:	0f b6 10             	movzbl (%eax),%edx
 25c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25f:	88 10                	mov    %dl,(%eax)
 261:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 265:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 26d:	0f 9f c0             	setg   %al
 270:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 274:	84 c0                	test   %al,%al
 276:	75 de                	jne    256 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    
 27d:	90                   	nop
 27e:	90                   	nop
 27f:	90                   	nop

00000280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <exit>:
SYSCALL(exit)
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <wait>:
SYSCALL(wait)
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <pipe>:
SYSCALL(pipe)
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <read>:
SYSCALL(read)
 2a0:	b8 05 00 00 00       	mov    $0x5,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <write>:
SYSCALL(write)
 2a8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <close>:
SYSCALL(close)
 2b0:	b8 15 00 00 00       	mov    $0x15,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <kill>:
SYSCALL(kill)
 2b8:	b8 06 00 00 00       	mov    $0x6,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exec>:
SYSCALL(exec)
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <open>:
SYSCALL(open)
 2c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mknod>:
SYSCALL(mknod)
 2d0:	b8 11 00 00 00       	mov    $0x11,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <unlink>:
SYSCALL(unlink)
 2d8:	b8 12 00 00 00       	mov    $0x12,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <fstat>:
SYSCALL(fstat)
 2e0:	b8 08 00 00 00       	mov    $0x8,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <link>:
SYSCALL(link)
 2e8:	b8 13 00 00 00       	mov    $0x13,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mkdir>:
SYSCALL(mkdir)
 2f0:	b8 14 00 00 00       	mov    $0x14,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <chdir>:
SYSCALL(chdir)
 2f8:	b8 09 00 00 00       	mov    $0x9,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <dup>:
SYSCALL(dup)
 300:	b8 0a 00 00 00       	mov    $0xa,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <getpid>:
SYSCALL(getpid)
 308:	b8 0b 00 00 00       	mov    $0xb,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <sbrk>:
SYSCALL(sbrk)
 310:	b8 0c 00 00 00       	mov    $0xc,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sleep>:
SYSCALL(sleep)
 318:	b8 0d 00 00 00       	mov    $0xd,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <uptime>:
SYSCALL(uptime)
 320:	b8 0e 00 00 00       	mov    $0xe,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <clone>:
SYSCALL(clone)
 328:	b8 16 00 00 00       	mov    $0x16,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <texit>:
SYSCALL(texit)
 330:	b8 17 00 00 00       	mov    $0x17,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <tsleep>:
SYSCALL(tsleep)
 338:	b8 18 00 00 00       	mov    $0x18,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <twakeup>:
SYSCALL(twakeup)
 340:	b8 19 00 00 00       	mov    $0x19,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 28             	sub    $0x28,%esp
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 354:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 35b:	00 
 35c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 35f:	89 44 24 04          	mov    %eax,0x4(%esp)
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	89 04 24             	mov    %eax,(%esp)
 369:	e8 3a ff ff ff       	call   2a8 <write>
}
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 377:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 37e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 382:	74 17                	je     39b <printint+0x2b>
 384:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 388:	79 11                	jns    39b <printint+0x2b>
    neg = 1;
 38a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 391:	8b 45 0c             	mov    0xc(%ebp),%eax
 394:	f7 d8                	neg    %eax
 396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 399:	eb 06                	jmp    3a1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39b:	8b 45 0c             	mov    0xc(%ebp),%eax
 39e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b1:	ba 00 00 00 00       	mov    $0x0,%edx
 3b6:	f7 f3                	div    %ebx
 3b8:	89 d0                	mov    %edx,%eax
 3ba:	0f b6 80 70 0a 00 00 	movzbl 0xa70(%eax),%eax
 3c1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3c9:	8b 45 10             	mov    0x10(%ebp),%eax
 3cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d2:	ba 00 00 00 00       	mov    $0x0,%edx
 3d7:	f7 75 d4             	divl   -0x2c(%ebp)
 3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e1:	75 c5                	jne    3a8 <printint+0x38>
  if(neg)
 3e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e7:	74 28                	je     411 <printint+0xa1>
    buf[i++] = '-';
 3e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ec:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 3f1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 3f5:	eb 1a                	jmp    411 <printint+0xa1>
    putc(fd, buf[i]);
 3f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fa:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 3ff:	0f be c0             	movsbl %al,%eax
 402:	89 44 24 04          	mov    %eax,0x4(%esp)
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	89 04 24             	mov    %eax,(%esp)
 40c:	e8 37 ff ff ff       	call   348 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 411:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 415:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 419:	79 dc                	jns    3f7 <printint+0x87>
    putc(fd, buf[i]);
}
 41b:	83 c4 44             	add    $0x44,%esp
 41e:	5b                   	pop    %ebx
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    

00000421 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 42e:	8d 45 0c             	lea    0xc(%ebp),%eax
 431:	83 c0 04             	add    $0x4,%eax
 434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 437:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 43e:	e9 7e 01 00 00       	jmp    5c1 <printf+0x1a0>
    c = fmt[i] & 0xff;
 443:	8b 55 0c             	mov    0xc(%ebp),%edx
 446:	8b 45 ec             	mov    -0x14(%ebp),%eax
 449:	8d 04 02             	lea    (%edx,%eax,1),%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	0f be c0             	movsbl %al,%eax
 452:	25 ff 00 00 00       	and    $0xff,%eax
 457:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 45a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45e:	75 2c                	jne    48c <printf+0x6b>
      if(c == '%'){
 460:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 464:	75 0c                	jne    472 <printf+0x51>
        state = '%';
 466:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 46d:	e9 4b 01 00 00       	jmp    5bd <printf+0x19c>
      } else {
        putc(fd, c);
 472:	8b 45 e8             	mov    -0x18(%ebp),%eax
 475:	0f be c0             	movsbl %al,%eax
 478:	89 44 24 04          	mov    %eax,0x4(%esp)
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	89 04 24             	mov    %eax,(%esp)
 482:	e8 c1 fe ff ff       	call   348 <putc>
 487:	e9 31 01 00 00       	jmp    5bd <printf+0x19c>
      }
    } else if(state == '%'){
 48c:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 490:	0f 85 27 01 00 00    	jne    5bd <printf+0x19c>
      if(c == 'd'){
 496:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 49a:	75 2d                	jne    4c9 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	8b 00                	mov    (%eax),%eax
 4a1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4a8:	00 
 4a9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4b0:	00 
 4b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	89 04 24             	mov    %eax,(%esp)
 4bb:	e8 b0 fe ff ff       	call   370 <printint>
        ap++;
 4c0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4c4:	e9 ed 00 00 00       	jmp    5b6 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4c9:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4cd:	74 06                	je     4d5 <printf+0xb4>
 4cf:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4d3:	75 2d                	jne    502 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 4d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d8:	8b 00                	mov    (%eax),%eax
 4da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4e1:	00 
 4e2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4e9:	00 
 4ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 77 fe ff ff       	call   370 <printint>
        ap++;
 4f9:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4fd:	e9 b4 00 00 00       	jmp    5b6 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 502:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 506:	75 46                	jne    54e <printf+0x12d>
        s = (char*)*ap;
 508:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50b:	8b 00                	mov    (%eax),%eax
 50d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 510:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 514:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 518:	75 27                	jne    541 <printf+0x120>
          s = "(null)";
 51a:	c7 45 e4 3a 0a 00 00 	movl   $0xa3a,-0x1c(%ebp)
        while(*s != 0){
 521:	eb 1f                	jmp    542 <printf+0x121>
          putc(fd, *s);
 523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 526:	0f b6 00             	movzbl (%eax),%eax
 529:	0f be c0             	movsbl %al,%eax
 52c:	89 44 24 04          	mov    %eax,0x4(%esp)
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	89 04 24             	mov    %eax,(%esp)
 536:	e8 0d fe ff ff       	call   348 <putc>
          s++;
 53b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 53f:	eb 01                	jmp    542 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 541:	90                   	nop
 542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	84 c0                	test   %al,%al
 54a:	75 d7                	jne    523 <printf+0x102>
 54c:	eb 68                	jmp    5b6 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54e:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 552:	75 1d                	jne    571 <printf+0x150>
        putc(fd, *ap);
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	0f be c0             	movsbl %al,%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 dd fd ff ff       	call   348 <putc>
        ap++;
 56b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 56f:	eb 45                	jmp    5b6 <printf+0x195>
      } else if(c == '%'){
 571:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 575:	75 17                	jne    58e <printf+0x16d>
        putc(fd, c);
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 bc fd ff ff       	call   348 <putc>
 58c:	eb 28                	jmp    5b6 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 58e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 595:	00 
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 a7 fd ff ff       	call   348 <putc>
        putc(fd, c);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 92 fd ff ff       	call   348 <putc>
      }
      state = 0;
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	84 c0                	test   %al,%al
 5cf:	0f 85 6e fe ff ff    	jne    443 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d5:	c9                   	leave  
 5d6:	c3                   	ret    
 5d7:	90                   	nop

000005d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d8:	55                   	push   %ebp
 5d9:	89 e5                	mov    %esp,%ebp
 5db:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5de:	8b 45 08             	mov    0x8(%ebp),%eax
 5e1:	83 e8 08             	sub    $0x8,%eax
 5e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e7:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 5ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ef:	eb 24                	jmp    615 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f9:	77 12                	ja     60d <free+0x35>
 5fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 601:	77 24                	ja     627 <free+0x4f>
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60b:	77 1a                	ja     627 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	89 45 fc             	mov    %eax,-0x4(%ebp)
 615:	8b 45 f8             	mov    -0x8(%ebp),%eax
 618:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61b:	76 d4                	jbe    5f1 <free+0x19>
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 625:	76 ca                	jbe    5f1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	8b 40 04             	mov    0x4(%eax),%eax
 62d:	c1 e0 03             	shl    $0x3,%eax
 630:	89 c2                	mov    %eax,%edx
 632:	03 55 f8             	add    -0x8(%ebp),%edx
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	39 c2                	cmp    %eax,%edx
 63c:	75 24                	jne    662 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 63e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 641:	8b 50 04             	mov    0x4(%eax),%edx
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	8b 40 04             	mov    0x4(%eax),%eax
 64c:	01 c2                	add    %eax,%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 10                	mov    (%eax),%edx
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	89 10                	mov    %edx,(%eax)
 660:	eb 0a                	jmp    66c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 10                	mov    (%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	c1 e0 03             	shl    $0x3,%eax
 675:	03 45 fc             	add    -0x4(%ebp),%eax
 678:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67b:	75 20                	jne    69d <free+0xc5>
    p->s.size += bp->s.size;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 50 04             	mov    0x4(%eax),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	01 c2                	add    %eax,%edx
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 10                	mov    (%eax),%edx
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	89 10                	mov    %edx,(%eax)
 69b:	eb 08                	jmp    6a5 <free+0xcd>
  } else
    p->s.ptr = bp;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <morecore>:

static Header*
morecore(uint nu)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bc:	77 07                	ja     6c5 <morecore+0x16>
    nu = 4096;
 6be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	c1 e0 03             	shl    $0x3,%eax
 6cb:	89 04 24             	mov    %eax,(%esp)
 6ce:	e8 3d fc ff ff       	call   310 <sbrk>
 6d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 6d6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6da:	75 07                	jne    6e3 <morecore+0x34>
    return 0;
 6dc:	b8 00 00 00 00       	mov    $0x0,%eax
 6e1:	eb 22                	jmp    705 <morecore+0x56>
  hp = (Header*)p;
 6e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ec:	8b 55 08             	mov    0x8(%ebp),%edx
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	83 c0 08             	add    $0x8,%eax
 6f8:	89 04 24             	mov    %eax,(%esp)
 6fb:	e8 d8 fe ff ff       	call   5d8 <free>
  return freep;
 700:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 705:	c9                   	leave  
 706:	c3                   	ret    

00000707 <malloc>:

void*
malloc(uint nbytes)
{
 707:	55                   	push   %ebp
 708:	89 e5                	mov    %esp,%ebp
 70a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	83 c0 07             	add    $0x7,%eax
 713:	c1 e8 03             	shr    $0x3,%eax
 716:	83 c0 01             	add    $0x1,%eax
 719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 71c:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 721:	89 45 f0             	mov    %eax,-0x10(%ebp)
 724:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 728:	75 23                	jne    74d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 72a:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 739:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 73e:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 743:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 74a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 755:	8b 45 ec             	mov    -0x14(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 75e:	72 4d                	jb     7ad <malloc+0xa6>
      if(p->s.size == nunits)
 760:	8b 45 ec             	mov    -0x14(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 769:	75 0c                	jne    777 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 76b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
 775:	eb 26                	jmp    79d <malloc+0x96>
      else {
        p->s.size -= nunits;
 777:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	89 c2                	mov    %eax,%edx
 77f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 782:	8b 45 ec             	mov    -0x14(%ebp),%eax
 785:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 788:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	c1 e0 03             	shl    $0x3,%eax
 791:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 794:	8b 45 ec             	mov    -0x14(%ebp),%eax
 797:	8b 55 f4             	mov    -0xc(%ebp),%edx
 79a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a8:	83 c0 08             	add    $0x8,%eax
 7ab:	eb 38                	jmp    7e5 <malloc+0xde>
    }
    if(p == freep)
 7ad:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7b2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7b5:	75 1b                	jne    7d2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 ed fe ff ff       	call   6af <morecore>
 7c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c9:	75 07                	jne    7d2 <malloc+0xcb>
        return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb 13                	jmp    7e5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7e0:	e9 70 ff ff ff       	jmp    755 <malloc+0x4e>
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    
 7e7:	90                   	nop

000007e8 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 7e8:	55                   	push   %ebp
 7e9:	89 e5                	mov    %esp,%ebp
 7eb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 7ee:	8b 55 08             	mov    0x8(%ebp),%edx
 7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 7f7:	f0 87 02             	lock xchg %eax,(%edx)
 7fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 800:	c9                   	leave  
 801:	c3                   	ret    

00000802 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 802:	55                   	push   %ebp
 803:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 80e:	5d                   	pop    %ebp
 80f:	c3                   	ret    

00000810 <lock_acquire>:
void lock_acquire(lock_t *lock){
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 816:	8b 45 08             	mov    0x8(%ebp),%eax
 819:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 820:	00 
 821:	89 04 24             	mov    %eax,(%esp)
 824:	e8 bf ff ff ff       	call   7e8 <xchg>
 829:	85 c0                	test   %eax,%eax
 82b:	75 e9                	jne    816 <lock_acquire+0x6>
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <lock_release>:
void lock_release(lock_t *lock){
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 83f:	00 
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 a0 ff ff ff       	call   7e8 <xchg>
}
 848:	c9                   	leave  
 849:	c3                   	ret    

0000084a <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 84a:	55                   	push   %ebp
 84b:	89 e5                	mov    %esp,%ebp
 84d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 850:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 857:	e8 ab fe ff ff       	call   707 <malloc>
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	25 ff 0f 00 00       	and    $0xfff,%eax
 86d:	85 c0                	test   %eax,%eax
 86f:	74 15                	je     886 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	89 c2                	mov    %eax,%edx
 876:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 87c:	b8 00 10 00 00       	mov    $0x1000,%eax
 881:	29 d0                	sub    %edx,%eax
 883:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 886:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88a:	75 1b                	jne    8a7 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 88c:	c7 44 24 04 41 0a 00 	movl   $0xa41,0x4(%esp)
 893:	00 
 894:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 89b:	e8 81 fb ff ff       	call   421 <printf>
        return 0;
 8a0:	b8 00 00 00 00       	mov    $0x0,%eax
 8a5:	eb 6f                	jmp    916 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 8a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8aa:	8b 55 08             	mov    0x8(%ebp),%edx
 8ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8b4:	89 54 24 08          	mov    %edx,0x8(%esp)
 8b8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 8bf:	00 
 8c0:	89 04 24             	mov    %eax,(%esp)
 8c3:	e8 60 fa ff ff       	call   328 <clone>
 8c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 8cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8cf:	79 1b                	jns    8ec <thread_create+0xa2>
        printf(1,"clone fails\n");
 8d1:	c7 44 24 04 4f 0a 00 	movl   $0xa4f,0x4(%esp)
 8d8:	00 
 8d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8e0:	e8 3c fb ff ff       	call   421 <printf>
        return 0;
 8e5:	b8 00 00 00 00       	mov    $0x0,%eax
 8ea:	eb 2a                	jmp    916 <thread_create+0xcc>
    }
    if(tid > 0){
 8ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8f0:	7e 05                	jle    8f7 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	eb 1f                	jmp    916 <thread_create+0xcc>
    }
    if(tid == 0){
 8f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8fb:	75 14                	jne    911 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 8fd:	c7 44 24 04 5c 0a 00 	movl   $0xa5c,0x4(%esp)
 904:	00 
 905:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 90c:	e8 10 fb ff ff       	call   421 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 911:	b8 00 00 00 00       	mov    $0x0,%eax
}
 916:	c9                   	leave  
 917:	c3                   	ret    

00000918 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 918:	55                   	push   %ebp
 919:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 91b:	8b 45 08             	mov    0x8(%ebp),%eax
 91e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 924:	8b 45 08             	mov    0x8(%ebp),%eax
 927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 938:	5d                   	pop    %ebp
 939:	c3                   	ret    

0000093a <add_q>:

void add_q(struct queue *q, int v){
 93a:	55                   	push   %ebp
 93b:	89 e5                	mov    %esp,%ebp
 93d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 940:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 947:	e8 bb fd ff ff       	call   707 <malloc>
 94c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	8b 55 0c             	mov    0xc(%ebp),%edx
 95f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 961:	8b 45 08             	mov    0x8(%ebp),%eax
 964:	8b 40 04             	mov    0x4(%eax),%eax
 967:	85 c0                	test   %eax,%eax
 969:	75 0b                	jne    976 <add_q+0x3c>
        q->head = n;
 96b:	8b 45 08             	mov    0x8(%ebp),%eax
 96e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 971:	89 50 04             	mov    %edx,0x4(%eax)
 974:	eb 0c                	jmp    982 <add_q+0x48>
    }else{
        q->tail->next = n;
 976:	8b 45 08             	mov    0x8(%ebp),%eax
 979:	8b 40 08             	mov    0x8(%eax),%eax
 97c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 97f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 982:	8b 45 08             	mov    0x8(%ebp),%eax
 985:	8b 55 f4             	mov    -0xc(%ebp),%edx
 988:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 98b:	8b 45 08             	mov    0x8(%ebp),%eax
 98e:	8b 00                	mov    (%eax),%eax
 990:	8d 50 01             	lea    0x1(%eax),%edx
 993:	8b 45 08             	mov    0x8(%ebp),%eax
 996:	89 10                	mov    %edx,(%eax)
}
 998:	c9                   	leave  
 999:	c3                   	ret    

0000099a <empty_q>:

int empty_q(struct queue *q){
 99a:	55                   	push   %ebp
 99b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 99d:	8b 45 08             	mov    0x8(%ebp),%eax
 9a0:	8b 00                	mov    (%eax),%eax
 9a2:	85 c0                	test   %eax,%eax
 9a4:	75 07                	jne    9ad <empty_q+0x13>
        return 1;
 9a6:	b8 01 00 00 00       	mov    $0x1,%eax
 9ab:	eb 05                	jmp    9b2 <empty_q+0x18>
    else
        return 0;
 9ad:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 9b2:	5d                   	pop    %ebp
 9b3:	c3                   	ret    

000009b4 <pop_q>:
int pop_q(struct queue *q){
 9b4:	55                   	push   %ebp
 9b5:	89 e5                	mov    %esp,%ebp
 9b7:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 9ba:	8b 45 08             	mov    0x8(%ebp),%eax
 9bd:	89 04 24             	mov    %eax,(%esp)
 9c0:	e8 d5 ff ff ff       	call   99a <empty_q>
 9c5:	85 c0                	test   %eax,%eax
 9c7:	75 5d                	jne    a26 <pop_q+0x72>
       val = q->head->value; 
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
 9cc:	8b 40 04             	mov    0x4(%eax),%eax
 9cf:	8b 00                	mov    (%eax),%eax
 9d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 9d4:	8b 45 08             	mov    0x8(%ebp),%eax
 9d7:	8b 40 04             	mov    0x4(%eax),%eax
 9da:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	8b 40 04             	mov    0x4(%eax),%eax
 9e3:	8b 50 04             	mov    0x4(%eax),%edx
 9e6:	8b 45 08             	mov    0x8(%ebp),%eax
 9e9:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 9ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ef:	89 04 24             	mov    %eax,(%esp)
 9f2:	e8 e1 fb ff ff       	call   5d8 <free>
       q->size--;
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	8b 00                	mov    (%eax),%eax
 9fc:	8d 50 ff             	lea    -0x1(%eax),%edx
 9ff:	8b 45 08             	mov    0x8(%ebp),%eax
 a02:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 a04:	8b 45 08             	mov    0x8(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	85 c0                	test   %eax,%eax
 a0b:	75 14                	jne    a21 <pop_q+0x6d>
            q->head = 0;
 a0d:	8b 45 08             	mov    0x8(%ebp),%eax
 a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 a17:	8b 45 08             	mov    0x8(%ebp),%eax
 a1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a24:	eb 05                	jmp    a2b <pop_q+0x77>
    }
    return -1;
 a26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a2b:	c9                   	leave  
 a2c:	c3                   	ret    

00000a2d <front>:

int front(struct queue *q)
{
 a2d:	55                   	push   %ebp
 a2e:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 a30:	8b 45 08             	mov    0x8(%ebp),%eax
 a33:	8b 40 04             	mov    0x4(%eax),%eax
 a36:	8b 00                	mov    (%eax),%eax
}
 a38:	5d                   	pop    %ebp
 a39:	c3                   	ret    
