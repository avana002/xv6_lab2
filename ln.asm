
_ln:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 92 0a 00 	movl   $0xa92,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 56 04 00 00       	call   479 <printf>
    exit();
  23:	e8 b8 02 00 00       	call   2e0 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 fc 02 00 00       	call   340 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 a5 0a 00 	movl   $0xaa5,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 05 04 00 00       	call   479 <printf>
  exit();
  74:	e8 67 02 00 00       	call   2e0 <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 10             	movzbl (%eax),%edx
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	88 10                	mov    %dl,(%eax)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	0f 95 c0             	setne  %al
  c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cb:	84 c0                	test   %al,%al
  cd:	75 de                	jne    ad <strcpy+0xc>
    ;
  return os;
  cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d2:	c9                   	leave  
  d3:	c3                   	ret    

000000d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d7:	eb 08                	jmp    e1 <strcmp+0xd>
    p++, q++;
  d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	84 c0                	test   %al,%al
  e9:	74 10                	je     fb <strcmp+0x27>
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 de                	je     d9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	0f b6 d0             	movzbl %al,%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	0f b6 c0             	movzbl %al,%eax
 10d:	89 d1                	mov    %edx,%ecx
 10f:	29 c1                	sub    %eax,%ecx
 111:	89 c8                	mov    %ecx,%eax
}
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    

00000115 <strlen>:

uint
strlen(char *s)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 122:	eb 04                	jmp    128 <strlen+0x13>
 124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12b:	03 45 08             	add    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 ef                	jne    124 <strlen+0xf>
    ;
  return n;
 135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <memset>:

void*
memset(void *dst, int c, uint n)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 140:	8b 45 10             	mov    0x10(%ebp),%eax
 143:	89 44 24 08          	mov    %eax,0x8(%esp)
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 44 24 04          	mov    %eax,0x4(%esp)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	89 04 24             	mov    %eax,(%esp)
 154:	e8 23 ff ff ff       	call   7c <stosb>
  return dst;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <strchr>:

char*
strchr(const char *s, char c)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 04             	sub    $0x4,%esp
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16a:	eb 14                	jmp    180 <strchr+0x22>
    if(*s == c)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	3a 45 fc             	cmp    -0x4(%ebp),%al
 175:	75 05                	jne    17c <strchr+0x1e>
      return (char*)s;
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	eb 13                	jmp    18f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <gets>:

char*
gets(char *buf, int max)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 19e:	eb 44                	jmp    1e4 <gets+0x53>
    cc = read(0, &c, 1);
 1a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a7:	00 
 1a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 1af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b6:	e8 3d 01 00 00       	call   2f8 <read>
 1bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c2:	7e 2d                	jle    1f1 <gets+0x60>
      break;
    buf[i++] = c;
 1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ce:	88 10                	mov    %dl,(%eax)
 1d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	3c 0a                	cmp    $0xa,%al
 1da:	74 16                	je     1f2 <gets+0x61>
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 0e                	je     1f2 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b1                	jl     1a0 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f5:	03 45 08             	add    0x8(%ebp),%eax
 1f8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <stat>:

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20d:	00 
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 07 01 00 00       	call   320 <open>
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 21c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 220:	79 07                	jns    229 <stat+0x29>
    return -1;
 222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 227:	eb 23                	jmp    24c <stat+0x4c>
  r = fstat(fd, st);
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 44 24 04          	mov    %eax,0x4(%esp)
 230:	8b 45 f0             	mov    -0x10(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 fd 00 00 00       	call   338 <fstat>
 23b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 23e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 bf 00 00 00       	call   308 <close>
  return r;
 249:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <atoi>:

int
atoi(const char *s)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25b:	eb 24                	jmp    281 <atoi+0x33>
    n = n*10 + *s++ - '0';
 25d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	c1 e0 02             	shl    $0x2,%eax
 265:	01 d0                	add    %edx,%eax
 267:	01 c0                	add    %eax,%eax
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	0f be c0             	movsbl %al,%eax
 274:	8d 04 02             	lea    (%edx,%eax,1),%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x47>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c8                	jle    25d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
    *dst++ = *src++;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	90                   	nop
 2d6:	90                   	nop
 2d7:	90                   	nop

000002d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
SYSCALL(exit)
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
SYSCALL(wait)
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <pipe>:
SYSCALL(pipe)
 2f0:	b8 04 00 00 00       	mov    $0x4,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <read>:
SYSCALL(read)
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <write>:
SYSCALL(write)
 300:	b8 10 00 00 00       	mov    $0x10,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <close>:
SYSCALL(close)
 308:	b8 15 00 00 00       	mov    $0x15,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <kill>:
SYSCALL(kill)
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exec>:
SYSCALL(exec)
 318:	b8 07 00 00 00       	mov    $0x7,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <open>:
SYSCALL(open)
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mknod>:
SYSCALL(mknod)
 328:	b8 11 00 00 00       	mov    $0x11,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <unlink>:
SYSCALL(unlink)
 330:	b8 12 00 00 00       	mov    $0x12,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <fstat>:
SYSCALL(fstat)
 338:	b8 08 00 00 00       	mov    $0x8,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <link>:
SYSCALL(link)
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mkdir>:
SYSCALL(mkdir)
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <chdir>:
SYSCALL(chdir)
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <dup>:
SYSCALL(dup)
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getpid>:
SYSCALL(getpid)
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sbrk>:
SYSCALL(sbrk)
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sleep>:
SYSCALL(sleep)
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <uptime>:
SYSCALL(uptime)
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <clone>:
SYSCALL(clone)
 380:	b8 16 00 00 00       	mov    $0x16,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <texit>:
SYSCALL(texit)
 388:	b8 17 00 00 00       	mov    $0x17,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <tsleep>:
SYSCALL(tsleep)
 390:	b8 18 00 00 00       	mov    $0x18,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <twakeup>:
SYSCALL(twakeup)
 398:	b8 19 00 00 00       	mov    $0x19,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 28             	sub    $0x28,%esp
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b3:	00 
 3b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	89 04 24             	mov    %eax,(%esp)
 3c1:	e8 3a ff ff ff       	call   300 <write>
}
 3c6:	c9                   	leave  
 3c7:	c3                   	ret    

000003c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c8:	55                   	push   %ebp
 3c9:	89 e5                	mov    %esp,%ebp
 3cb:	53                   	push   %ebx
 3cc:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3da:	74 17                	je     3f3 <printint+0x2b>
 3dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e0:	79 11                	jns    3f3 <printint+0x2b>
    neg = 1;
 3e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	f7 d8                	neg    %eax
 3ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f1:	eb 06                	jmp    3f9 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 400:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 403:	8b 5d 10             	mov    0x10(%ebp),%ebx
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	ba 00 00 00 00       	mov    $0x0,%edx
 40e:	f7 f3                	div    %ebx
 410:	89 d0                	mov    %edx,%eax
 412:	0f b6 80 ec 0a 00 00 	movzbl 0xaec(%eax),%eax
 419:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 41d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 421:	8b 45 10             	mov    0x10(%ebp),%eax
 424:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42a:	ba 00 00 00 00       	mov    $0x0,%edx
 42f:	f7 75 d4             	divl   -0x2c(%ebp)
 432:	89 45 f4             	mov    %eax,-0xc(%ebp)
 435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 439:	75 c5                	jne    400 <printint+0x38>
  if(neg)
 43b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43f:	74 28                	je     469 <printint+0xa1>
    buf[i++] = '-';
 441:	8b 45 ec             	mov    -0x14(%ebp),%eax
 444:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 449:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 44d:	eb 1a                	jmp    469 <printint+0xa1>
    putc(fd, buf[i]);
 44f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 452:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 457:	0f be c0             	movsbl %al,%eax
 45a:	89 44 24 04          	mov    %eax,0x4(%esp)
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	89 04 24             	mov    %eax,(%esp)
 464:	e8 37 ff ff ff       	call   3a0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 469:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 46d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 471:	79 dc                	jns    44f <printint+0x87>
    putc(fd, buf[i]);
}
 473:	83 c4 44             	add    $0x44,%esp
 476:	5b                   	pop    %ebx
 477:	5d                   	pop    %ebp
 478:	c3                   	ret    

00000479 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 486:	8d 45 0c             	lea    0xc(%ebp),%eax
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 48f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 496:	e9 7e 01 00 00       	jmp    619 <printf+0x1a0>
    c = fmt[i] & 0xff;
 49b:	8b 55 0c             	mov    0xc(%ebp),%edx
 49e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a1:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	25 ff 00 00 00       	and    $0xff,%eax
 4af:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b6:	75 2c                	jne    4e4 <printf+0x6b>
      if(c == '%'){
 4b8:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4bc:	75 0c                	jne    4ca <printf+0x51>
        state = '%';
 4be:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4c5:	e9 4b 01 00 00       	jmp    615 <printf+0x19c>
      } else {
        putc(fd, c);
 4ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d4:	8b 45 08             	mov    0x8(%ebp),%eax
 4d7:	89 04 24             	mov    %eax,(%esp)
 4da:	e8 c1 fe ff ff       	call   3a0 <putc>
 4df:	e9 31 01 00 00       	jmp    615 <printf+0x19c>
      }
    } else if(state == '%'){
 4e4:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4e8:	0f 85 27 01 00 00    	jne    615 <printf+0x19c>
      if(c == 'd'){
 4ee:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4f2:	75 2d                	jne    521 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	8b 00                	mov    (%eax),%eax
 4f9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 500:	00 
 501:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 508:	00 
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	89 04 24             	mov    %eax,(%esp)
 513:	e8 b0 fe ff ff       	call   3c8 <printint>
        ap++;
 518:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 51c:	e9 ed 00 00 00       	jmp    60e <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 521:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 525:	74 06                	je     52d <printf+0xb4>
 527:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 52b:	75 2d                	jne    55a <printf+0xe1>
        printint(fd, *ap, 16, 0);
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	8b 00                	mov    (%eax),%eax
 532:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 539:	00 
 53a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 541:	00 
 542:	89 44 24 04          	mov    %eax,0x4(%esp)
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 04 24             	mov    %eax,(%esp)
 54c:	e8 77 fe ff ff       	call   3c8 <printint>
        ap++;
 551:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 555:	e9 b4 00 00 00       	jmp    60e <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 55a:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 55e:	75 46                	jne    5a6 <printf+0x12d>
        s = (char*)*ap;
 560:	8b 45 f4             	mov    -0xc(%ebp),%eax
 563:	8b 00                	mov    (%eax),%eax
 565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 568:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 56c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 570:	75 27                	jne    599 <printf+0x120>
          s = "(null)";
 572:	c7 45 e4 b9 0a 00 00 	movl   $0xab9,-0x1c(%ebp)
        while(*s != 0){
 579:	eb 1f                	jmp    59a <printf+0x121>
          putc(fd, *s);
 57b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 0d fe ff ff       	call   3a0 <putc>
          s++;
 593:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 597:	eb 01                	jmp    59a <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 599:	90                   	nop
 59a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	84 c0                	test   %al,%al
 5a2:	75 d7                	jne    57b <printf+0x102>
 5a4:	eb 68                	jmp    60e <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a6:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 5aa:	75 1d                	jne    5c9 <printf+0x150>
        putc(fd, *ap);
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	89 04 24             	mov    %eax,(%esp)
 5be:	e8 dd fd ff ff       	call   3a0 <putc>
        ap++;
 5c3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5c7:	eb 45                	jmp    60e <printf+0x195>
      } else if(c == '%'){
 5c9:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5cd:	75 17                	jne    5e6 <printf+0x16d>
        putc(fd, c);
 5cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d2:	0f be c0             	movsbl %al,%eax
 5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 bc fd ff ff       	call   3a0 <putc>
 5e4:	eb 28                	jmp    60e <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ed:	00 
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 a7 fd ff ff       	call   3a0 <putc>
        putc(fd, c);
 5f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 92 fd ff ff       	call   3a0 <putc>
      }
      state = 0;
 60e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 615:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 619:	8b 55 0c             	mov    0xc(%ebp),%edx
 61c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 61f:	8d 04 02             	lea    (%edx,%eax,1),%eax
 622:	0f b6 00             	movzbl (%eax),%eax
 625:	84 c0                	test   %al,%al
 627:	0f 85 6e fe ff ff    	jne    49b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 62d:	c9                   	leave  
 62e:	c3                   	ret    
 62f:	90                   	nop

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	83 e8 08             	sub    $0x8,%eax
 63c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63f:	a1 08 0b 00 00       	mov    0xb08,%eax
 644:	89 45 fc             	mov    %eax,-0x4(%ebp)
 647:	eb 24                	jmp    66d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 651:	77 12                	ja     665 <free+0x35>
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 659:	77 24                	ja     67f <free+0x4f>
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 663:	77 1a                	ja     67f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 673:	76 d4                	jbe    649 <free+0x19>
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67d:	76 ca                	jbe    649 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	8b 40 04             	mov    0x4(%eax),%eax
 685:	c1 e0 03             	shl    $0x3,%eax
 688:	89 c2                	mov    %eax,%edx
 68a:	03 55 f8             	add    -0x8(%ebp),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	39 c2                	cmp    %eax,%edx
 694:	75 24                	jne    6ba <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
 6b8:	eb 0a                	jmp    6c4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	c1 e0 03             	shl    $0x3,%eax
 6cd:	03 45 fc             	add    -0x4(%ebp),%eax
 6d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d3:	75 20                	jne    6f5 <free+0xc5>
    p->s.size += bp->s.size;
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 50 04             	mov    0x4(%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 40 04             	mov    0x4(%eax),%eax
 6e1:	01 c2                	add    %eax,%edx
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	8b 10                	mov    (%eax),%edx
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	89 10                	mov    %edx,(%eax)
 6f3:	eb 08                	jmp    6fd <free+0xcd>
  } else
    p->s.ptr = bp;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fb:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	a3 08 0b 00 00       	mov    %eax,0xb08
}
 705:	c9                   	leave  
 706:	c3                   	ret    

00000707 <morecore>:

static Header*
morecore(uint nu)
{
 707:	55                   	push   %ebp
 708:	89 e5                	mov    %esp,%ebp
 70a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 714:	77 07                	ja     71d <morecore+0x16>
    nu = 4096;
 716:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71d:	8b 45 08             	mov    0x8(%ebp),%eax
 720:	c1 e0 03             	shl    $0x3,%eax
 723:	89 04 24             	mov    %eax,(%esp)
 726:	e8 3d fc ff ff       	call   368 <sbrk>
 72b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 72e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 732:	75 07                	jne    73b <morecore+0x34>
    return 0;
 734:	b8 00 00 00 00       	mov    $0x0,%eax
 739:	eb 22                	jmp    75d <morecore+0x56>
  hp = (Header*)p;
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 55 08             	mov    0x8(%ebp),%edx
 747:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	83 c0 08             	add    $0x8,%eax
 750:	89 04 24             	mov    %eax,(%esp)
 753:	e8 d8 fe ff ff       	call   630 <free>
  return freep;
 758:	a1 08 0b 00 00       	mov    0xb08,%eax
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <malloc>:

void*
malloc(uint nbytes)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	83 c0 07             	add    $0x7,%eax
 76b:	c1 e8 03             	shr    $0x3,%eax
 76e:	83 c0 01             	add    $0x1,%eax
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 774:	a1 08 0b 00 00       	mov    0xb08,%eax
 779:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 780:	75 23                	jne    7a5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 782:	c7 45 f0 00 0b 00 00 	movl   $0xb00,-0x10(%ebp)
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	a3 08 0b 00 00       	mov    %eax,0xb08
 791:	a1 08 0b 00 00       	mov    0xb08,%eax
 796:	a3 00 0b 00 00       	mov    %eax,0xb00
    base.s.size = 0;
 79b:	c7 05 04 0b 00 00 00 	movl   $0x0,0xb04
 7a2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7b6:	72 4d                	jb     805 <malloc+0xa6>
      if(p->s.size == nunits)
 7b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7c1:	75 0c                	jne    7cf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c6:	8b 10                	mov    (%eax),%edx
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	89 10                	mov    %edx,(%eax)
 7cd:	eb 26                	jmp    7f5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	89 c2                	mov    %eax,%edx
 7d7:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	c1 e0 03             	shl    $0x3,%eax
 7e9:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	a3 08 0b 00 00       	mov    %eax,0xb08
      return (void*)(p + 1);
 7fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 800:	83 c0 08             	add    $0x8,%eax
 803:	eb 38                	jmp    83d <malloc+0xde>
    }
    if(p == freep)
 805:	a1 08 0b 00 00       	mov    0xb08,%eax
 80a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 80d:	75 1b                	jne    82a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	89 04 24             	mov    %eax,(%esp)
 815:	e8 ed fe ff ff       	call   707 <morecore>
 81a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 81d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 821:	75 07                	jne    82a <malloc+0xcb>
        return 0;
 823:	b8 00 00 00 00       	mov    $0x0,%eax
 828:	eb 13                	jmp    83d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 830:	8b 45 ec             	mov    -0x14(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 838:	e9 70 ff ff ff       	jmp    7ad <malloc+0x4e>
}
 83d:	c9                   	leave  
 83e:	c3                   	ret    
 83f:	90                   	nop

00000840 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 846:	8b 55 08             	mov    0x8(%ebp),%edx
 849:	8b 45 0c             	mov    0xc(%ebp),%eax
 84c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 84f:	f0 87 02             	lock xchg %eax,(%edx)
 852:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 858:	c9                   	leave  
 859:	c3                   	ret    

0000085a <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 85a:	55                   	push   %ebp
 85b:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 866:	5d                   	pop    %ebp
 867:	c3                   	ret    

00000868 <lock_acquire>:
void lock_acquire(lock_t *lock){
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 86e:	8b 45 08             	mov    0x8(%ebp),%eax
 871:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 878:	00 
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 bf ff ff ff       	call   840 <xchg>
 881:	85 c0                	test   %eax,%eax
 883:	75 e9                	jne    86e <lock_acquire+0x6>
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <lock_release>:
void lock_release(lock_t *lock){
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 897:	00 
 898:	89 04 24             	mov    %eax,(%esp)
 89b:	e8 a0 ff ff ff       	call   840 <xchg>
}
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    

000008a2 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 8a2:	55                   	push   %ebp
 8a3:	89 e5                	mov    %esp,%ebp
 8a5:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8a8:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8af:	e8 ab fe ff ff       	call   75f <malloc>
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	25 ff 0f 00 00       	and    $0xfff,%eax
 8c5:	85 c0                	test   %eax,%eax
 8c7:	74 15                	je     8de <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 8c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cc:	89 c2                	mov    %eax,%edx
 8ce:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 8d4:	b8 00 10 00 00       	mov    $0x1000,%eax
 8d9:	29 d0                	sub    %edx,%eax
 8db:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 8de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e2:	75 1b                	jne    8ff <thread_create+0x5d>

        printf(1,"malloc fail \n");
 8e4:	c7 44 24 04 c0 0a 00 	movl   $0xac0,0x4(%esp)
 8eb:	00 
 8ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8f3:	e8 81 fb ff ff       	call   479 <printf>
        return 0;
 8f8:	b8 00 00 00 00       	mov    $0x0,%eax
 8fd:	eb 6f                	jmp    96e <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 8ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 902:	8b 55 08             	mov    0x8(%ebp),%edx
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 90c:	89 54 24 08          	mov    %edx,0x8(%esp)
 910:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 917:	00 
 918:	89 04 24             	mov    %eax,(%esp)
 91b:	e8 60 fa ff ff       	call   380 <clone>
 920:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 923:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 927:	79 1b                	jns    944 <thread_create+0xa2>
        printf(1,"clone fails\n");
 929:	c7 44 24 04 ce 0a 00 	movl   $0xace,0x4(%esp)
 930:	00 
 931:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 938:	e8 3c fb ff ff       	call   479 <printf>
        return 0;
 93d:	b8 00 00 00 00       	mov    $0x0,%eax
 942:	eb 2a                	jmp    96e <thread_create+0xcc>
    }
    if(tid > 0){
 944:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 948:	7e 05                	jle    94f <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	eb 1f                	jmp    96e <thread_create+0xcc>
    }
    if(tid == 0){
 94f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 953:	75 14                	jne    969 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 955:	c7 44 24 04 db 0a 00 	movl   $0xadb,0x4(%esp)
 95c:	00 
 95d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 964:	e8 10 fb ff ff       	call   479 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 969:	b8 00 00 00 00       	mov    $0x0,%eax
}
 96e:	c9                   	leave  
 96f:	c3                   	ret    

00000970 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 973:	8b 45 08             	mov    0x8(%ebp),%eax
 976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 97c:	8b 45 08             	mov    0x8(%ebp),%eax
 97f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 986:	8b 45 08             	mov    0x8(%ebp),%eax
 989:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 990:	5d                   	pop    %ebp
 991:	c3                   	ret    

00000992 <add_q>:

void add_q(struct queue *q, int v){
 992:	55                   	push   %ebp
 993:	89 e5                	mov    %esp,%ebp
 995:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 998:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 99f:	e8 bb fd ff ff       	call   75f <malloc>
 9a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 9b7:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 9b9:	8b 45 08             	mov    0x8(%ebp),%eax
 9bc:	8b 40 04             	mov    0x4(%eax),%eax
 9bf:	85 c0                	test   %eax,%eax
 9c1:	75 0b                	jne    9ce <add_q+0x3c>
        q->head = n;
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9c9:	89 50 04             	mov    %edx,0x4(%eax)
 9cc:	eb 0c                	jmp    9da <add_q+0x48>
    }else{
        q->tail->next = n;
 9ce:	8b 45 08             	mov    0x8(%ebp),%eax
 9d1:	8b 40 08             	mov    0x8(%eax),%eax
 9d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9d7:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9e0:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 9e3:	8b 45 08             	mov    0x8(%ebp),%eax
 9e6:	8b 00                	mov    (%eax),%eax
 9e8:	8d 50 01             	lea    0x1(%eax),%edx
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	89 10                	mov    %edx,(%eax)
}
 9f0:	c9                   	leave  
 9f1:	c3                   	ret    

000009f2 <empty_q>:

int empty_q(struct queue *q){
 9f2:	55                   	push   %ebp
 9f3:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 9f5:	8b 45 08             	mov    0x8(%ebp),%eax
 9f8:	8b 00                	mov    (%eax),%eax
 9fa:	85 c0                	test   %eax,%eax
 9fc:	75 07                	jne    a05 <empty_q+0x13>
        return 1;
 9fe:	b8 01 00 00 00       	mov    $0x1,%eax
 a03:	eb 05                	jmp    a0a <empty_q+0x18>
    else
        return 0;
 a05:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a0a:	5d                   	pop    %ebp
 a0b:	c3                   	ret    

00000a0c <pop_q>:
int pop_q(struct queue *q){
 a0c:	55                   	push   %ebp
 a0d:	89 e5                	mov    %esp,%ebp
 a0f:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 a12:	8b 45 08             	mov    0x8(%ebp),%eax
 a15:	89 04 24             	mov    %eax,(%esp)
 a18:	e8 d5 ff ff ff       	call   9f2 <empty_q>
 a1d:	85 c0                	test   %eax,%eax
 a1f:	75 5d                	jne    a7e <pop_q+0x72>
       val = q->head->value; 
 a21:	8b 45 08             	mov    0x8(%ebp),%eax
 a24:	8b 40 04             	mov    0x4(%eax),%eax
 a27:	8b 00                	mov    (%eax),%eax
 a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 a2c:	8b 45 08             	mov    0x8(%ebp),%eax
 a2f:	8b 40 04             	mov    0x4(%eax),%eax
 a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 a35:	8b 45 08             	mov    0x8(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	8b 50 04             	mov    0x4(%eax),%edx
 a3e:	8b 45 08             	mov    0x8(%ebp),%eax
 a41:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	89 04 24             	mov    %eax,(%esp)
 a4a:	e8 e1 fb ff ff       	call   630 <free>
       q->size--;
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	8b 00                	mov    (%eax),%eax
 a54:	8d 50 ff             	lea    -0x1(%eax),%edx
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 a5c:	8b 45 08             	mov    0x8(%ebp),%eax
 a5f:	8b 00                	mov    (%eax),%eax
 a61:	85 c0                	test   %eax,%eax
 a63:	75 14                	jne    a79 <pop_q+0x6d>
            q->head = 0;
 a65:	8b 45 08             	mov    0x8(%ebp),%eax
 a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 a6f:	8b 45 08             	mov    0x8(%ebp),%eax
 a72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7c:	eb 05                	jmp    a83 <pop_q+0x77>
    }
    return -1;
 a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a83:	c9                   	leave  
 a84:	c3                   	ret    

00000a85 <front>:

int front(struct queue *q)
{
 a85:	55                   	push   %ebp
 a86:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 a88:	8b 45 08             	mov    0x8(%ebp),%eax
 a8b:	8b 40 04             	mov    0x4(%eax),%eax
 a8e:	8b 00                	mov    (%eax),%eax
}
 a90:	5d                   	pop    %ebp
 a91:	c3                   	ret    
