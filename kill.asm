
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 7a 0a 00 	movl   $0xa7a,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3e 04 00 00       	call   461 <printf>
    exit();
  23:	e8 a0 02 00 00       	call   2c8 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 21                	jmp    53 <main+0x53>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 f0 01 00 00       	call   236 <atoi>
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 aa 02 00 00       	call   2f8 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  53:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  57:	3b 45 08             	cmp    0x8(%ebp),%eax
  5a:	7c d6                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  5c:	e8 67 02 00 00       	call   2c8 <exit>
  61:	90                   	nop
  62:	90                   	nop
  63:	90                   	nop

00000064 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	8b 55 10             	mov    0x10(%ebp),%edx
  6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  72:	89 cb                	mov    %ecx,%ebx
  74:	89 df                	mov    %ebx,%edi
  76:	89 d1                	mov    %edx,%ecx
  78:	fc                   	cld    
  79:	f3 aa                	rep stos %al,%es:(%edi)
  7b:	89 ca                	mov    %ecx,%edx
  7d:	89 fb                	mov    %edi,%ebx
  7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  85:	5b                   	pop    %ebx
  86:	5f                   	pop    %edi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  8c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	88 10                	mov    %dl,(%eax)
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	84 c0                	test   %al,%al
  a8:	0f 95 c0             	setne  %al
  ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b3:	84 c0                	test   %al,%al
  b5:	75 de                	jne    95 <strcpy+0xc>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	89 d1                	mov    %edx,%ecx
  f7:	29 c1                	sub    %eax,%ecx
  f9:	89 c8                	mov    %ecx,%eax
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    

000000fd <strlen>:

uint
strlen(char *s)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 103:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10a:	eb 04                	jmp    110 <strlen+0x13>
 10c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 110:	8b 45 fc             	mov    -0x4(%ebp),%eax
 113:	03 45 08             	add    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ef                	jne    10c <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 23 ff ff ff       	call   64 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 186:	eb 44                	jmp    1cc <gets+0x53>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 3d 01 00 00       	call   2e0 <read>
 1a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1aa:	7e 2d                	jle    1d9 <gets+0x60>
      break;
    buf[i++] = c;
 1ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1af:	03 45 08             	add    0x8(%ebp),%eax
 1b2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1b6:	88 10                	mov    %dl,(%eax)
 1b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x61>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b1                	jl     188 <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1dd:	03 45 08             	add    0x8(%ebp),%eax
 1e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <stat>:

int
stat(char *n, struct stat *st)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f5:	00 
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	89 04 24             	mov    %eax,(%esp)
 1fc:	e8 07 01 00 00       	call   308 <open>
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	79 07                	jns    211 <stat+0x29>
    return -1;
 20a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20f:	eb 23                	jmp    234 <stat+0x4c>
  r = fstat(fd, st);
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	e8 fd 00 00 00       	call   320 <fstat>
 223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
 229:	89 04 24             	mov    %eax,(%esp)
 22c:	e8 bf 00 00 00       	call   2f0 <close>
  return r;
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <atoi>:

int
atoi(const char *s)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 243:	eb 24                	jmp    269 <atoi+0x33>
    n = n*10 + *s++ - '0';
 245:	8b 55 fc             	mov    -0x4(%ebp),%edx
 248:	89 d0                	mov    %edx,%eax
 24a:	c1 e0 02             	shl    $0x2,%eax
 24d:	01 d0                	add    %edx,%eax
 24f:	01 c0                	add    %eax,%eax
 251:	89 c2                	mov    %eax,%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f be c0             	movsbl %al,%eax
 25c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 25f:	83 e8 30             	sub    $0x30,%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
 265:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2f                	cmp    $0x2f,%al
 271:	7e 0a                	jle    27d <atoi+0x47>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e c8                	jle    245 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 294:	eb 13                	jmp    2a9 <memmove+0x27>
    *dst++ = *src++;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
 299:	0f b6 10             	movzbl (%eax),%edx
 29c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29f:	88 10                	mov    %dl,(%eax)
 2a1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ad:	0f 9f c0             	setg   %al
 2b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b4:	84 c0                	test   %al,%al
 2b6:	75 de                	jne    296 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    
 2bd:	90                   	nop
 2be:	90                   	nop
 2bf:	90                   	nop

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <clone>:
SYSCALL(clone)
 368:	b8 16 00 00 00       	mov    $0x16,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <texit>:
SYSCALL(texit)
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <tsleep>:
SYSCALL(tsleep)
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <twakeup>:
SYSCALL(twakeup)
 380:	b8 19 00 00 00       	mov    $0x19,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	83 ec 28             	sub    $0x28,%esp
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 394:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39b:	00 
 39c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39f:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	89 04 24             	mov    %eax,(%esp)
 3a9:	e8 3a ff ff ff       	call   2e8 <write>
}
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c2:	74 17                	je     3db <printint+0x2b>
 3c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c8:	79 11                	jns    3db <printint+0x2b>
    neg = 1;
 3ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	f7 d8                	neg    %eax
 3d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d9:	eb 06                	jmp    3e1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f1:	ba 00 00 00 00       	mov    $0x0,%edx
 3f6:	f7 f3                	div    %ebx
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	0f b6 80 c4 0a 00 00 	movzbl 0xac4(%eax),%eax
 401:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 405:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 409:	8b 45 10             	mov    0x10(%ebp),%eax
 40c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	ba 00 00 00 00       	mov    $0x0,%edx
 417:	f7 75 d4             	divl   -0x2c(%ebp)
 41a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 421:	75 c5                	jne    3e8 <printint+0x38>
  if(neg)
 423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 427:	74 28                	je     451 <printint+0xa1>
    buf[i++] = '-';
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 431:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 435:	eb 1a                	jmp    451 <printint+0xa1>
    putc(fd, buf[i]);
 437:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	89 44 24 04          	mov    %eax,0x4(%esp)
 446:	8b 45 08             	mov    0x8(%ebp),%eax
 449:	89 04 24             	mov    %eax,(%esp)
 44c:	e8 37 ff ff ff       	call   388 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 451:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 459:	79 dc                	jns    437 <printint+0x87>
    putc(fd, buf[i]);
}
 45b:	83 c4 44             	add    $0x44,%esp
 45e:	5b                   	pop    %ebx
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 0c             	lea    0xc(%ebp),%eax
 471:	83 c0 04             	add    $0x4,%eax
 474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 47e:	e9 7e 01 00 00       	jmp    601 <printf+0x1a0>
    c = fmt[i] & 0xff;
 483:	8b 55 0c             	mov    0xc(%ebp),%edx
 486:	8b 45 ec             	mov    -0x14(%ebp),%eax
 489:	8d 04 02             	lea    (%edx,%eax,1),%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	0f be c0             	movsbl %al,%eax
 492:	25 ff 00 00 00       	and    $0xff,%eax
 497:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 49a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49e:	75 2c                	jne    4cc <printf+0x6b>
      if(c == '%'){
 4a0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4a4:	75 0c                	jne    4b2 <printf+0x51>
        state = '%';
 4a6:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4ad:	e9 4b 01 00 00       	jmp    5fd <printf+0x19c>
      } else {
        putc(fd, c);
 4b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 c1 fe ff ff       	call   388 <putc>
 4c7:	e9 31 01 00 00       	jmp    5fd <printf+0x19c>
      }
    } else if(state == '%'){
 4cc:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4d0:	0f 85 27 01 00 00    	jne    5fd <printf+0x19c>
      if(c == 'd'){
 4d6:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4da:	75 2d                	jne    509 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e8:	00 
 4e9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f0:	00 
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 b0 fe ff ff       	call   3b0 <printint>
        ap++;
 500:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 504:	e9 ed 00 00 00       	jmp    5f6 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 509:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 50d:	74 06                	je     515 <printf+0xb4>
 50f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 513:	75 2d                	jne    542 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 521:	00 
 522:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 529:	00 
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 77 fe ff ff       	call   3b0 <printint>
        ap++;
 539:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 53d:	e9 b4 00 00 00       	jmp    5f6 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 542:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 546:	75 46                	jne    58e <printf+0x12d>
        s = (char*)*ap;
 548:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 550:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 558:	75 27                	jne    581 <printf+0x120>
          s = "(null)";
 55a:	c7 45 e4 8e 0a 00 00 	movl   $0xa8e,-0x1c(%ebp)
        while(*s != 0){
 561:	eb 1f                	jmp    582 <printf+0x121>
          putc(fd, *s);
 563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	89 04 24             	mov    %eax,(%esp)
 576:	e8 0d fe ff ff       	call   388 <putc>
          s++;
 57b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 57f:	eb 01                	jmp    582 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 581:	90                   	nop
 582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	84 c0                	test   %al,%al
 58a:	75 d7                	jne    563 <printf+0x102>
 58c:	eb 68                	jmp    5f6 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58e:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 592:	75 1d                	jne    5b1 <printf+0x150>
        putc(fd, *ap);
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8b 00                	mov    (%eax),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 dd fd ff ff       	call   388 <putc>
        ap++;
 5ab:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5af:	eb 45                	jmp    5f6 <printf+0x195>
      } else if(c == '%'){
 5b1:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5b5:	75 17                	jne    5ce <printf+0x16d>
        putc(fd, c);
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 bc fd ff ff       	call   388 <putc>
 5cc:	eb 28                	jmp    5f6 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ce:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d5:	00 
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 a7 fd ff ff       	call   388 <putc>
        putc(fd, c);
 5e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 92 fd ff ff       	call   388 <putc>
      }
      state = 0;
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 601:	8b 55 0c             	mov    0xc(%ebp),%edx
 604:	8b 45 ec             	mov    -0x14(%ebp),%eax
 607:	8d 04 02             	lea    (%edx,%eax,1),%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	84 c0                	test   %al,%al
 60f:	0f 85 6e fe ff ff    	jne    483 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 615:	c9                   	leave  
 616:	c3                   	ret    
 617:	90                   	nop

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	83 e8 08             	sub    $0x8,%eax
 624:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	a1 e0 0a 00 00       	mov    0xae0,%eax
 62c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62f:	eb 24                	jmp    655 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 12                	ja     64d <free+0x35>
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 24                	ja     667 <free+0x4f>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	77 1a                	ja     667 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	76 d4                	jbe    631 <free+0x19>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	76 ca                	jbe    631 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	c1 e0 03             	shl    $0x3,%eax
 670:	89 c2                	mov    %eax,%edx
 672:	03 55 f8             	add    -0x8(%ebp),%edx
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	39 c2                	cmp    %eax,%edx
 67c:	75 24                	jne    6a2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 50 04             	mov    0x4(%eax),%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 40 04             	mov    0x4(%eax),%eax
 68c:	01 c2                	add    %eax,%edx
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
 6a0:	eb 0a                	jmp    6ac <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	c1 e0 03             	shl    $0x3,%eax
 6b5:	03 45 fc             	add    -0x4(%ebp),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	75 20                	jne    6dd <free+0xc5>
    p->s.size += bp->s.size;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 50 04             	mov    0x4(%eax),%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	01 c2                	add    %eax,%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 10                	mov    (%eax),%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	89 10                	mov    %edx,(%eax)
 6db:	eb 08                	jmp    6e5 <free+0xcd>
  } else
    p->s.ptr = bp;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <morecore>:

static Header*
morecore(uint nu)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fc:	77 07                	ja     705 <morecore+0x16>
    nu = 4096;
 6fe:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 705:	8b 45 08             	mov    0x8(%ebp),%eax
 708:	c1 e0 03             	shl    $0x3,%eax
 70b:	89 04 24             	mov    %eax,(%esp)
 70e:	e8 3d fc ff ff       	call   350 <sbrk>
 713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 716:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 71a:	75 07                	jne    723 <morecore+0x34>
    return 0;
 71c:	b8 00 00 00 00       	mov    $0x0,%eax
 721:	eb 22                	jmp    745 <morecore+0x56>
  hp = (Header*)p;
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8b 55 08             	mov    0x8(%ebp),%edx
 72f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	83 c0 08             	add    $0x8,%eax
 738:	89 04 24             	mov    %eax,(%esp)
 73b:	e8 d8 fe ff ff       	call   618 <free>
  return freep;
 740:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 745:	c9                   	leave  
 746:	c3                   	ret    

00000747 <malloc>:

void*
malloc(uint nbytes)
{
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	83 c0 07             	add    $0x7,%eax
 753:	c1 e8 03             	shr    $0x3,%eax
 756:	83 c0 01             	add    $0x1,%eax
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 75c:	a1 e0 0a 00 00       	mov    0xae0,%eax
 761:	89 45 f0             	mov    %eax,-0x10(%ebp)
 764:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 768:	75 23                	jne    78d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76a:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	a3 e0 0a 00 00       	mov    %eax,0xae0
 779:	a1 e0 0a 00 00       	mov    0xae0,%eax
 77e:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 783:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 78a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 795:	8b 45 ec             	mov    -0x14(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 79e:	72 4d                	jb     7ed <malloc+0xa6>
      if(p->s.size == nunits)
 7a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7a9:	75 0c                	jne    7b7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ae:	8b 10                	mov    (%eax),%edx
 7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b3:	89 10                	mov    %edx,(%eax)
 7b5:	eb 26                	jmp    7dd <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	89 c2                	mov    %eax,%edx
 7bf:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	c1 e0 03             	shl    $0x3,%eax
 7d1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7da:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 7e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e8:	83 c0 08             	add    $0x8,%eax
 7eb:	eb 38                	jmp    825 <malloc+0xde>
    }
    if(p == freep)
 7ed:	a1 e0 0a 00 00       	mov    0xae0,%eax
 7f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f5:	75 1b                	jne    812 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 04 24             	mov    %eax,(%esp)
 7fd:	e8 ed fe ff ff       	call   6ef <morecore>
 802:	89 45 ec             	mov    %eax,-0x14(%ebp)
 805:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 809:	75 07                	jne    812 <malloc+0xcb>
        return 0;
 80b:	b8 00 00 00 00       	mov    $0x0,%eax
 810:	eb 13                	jmp    825 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	8b 45 ec             	mov    -0x14(%ebp),%eax
 815:	89 45 f0             	mov    %eax,-0x10(%ebp)
 818:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 820:	e9 70 ff ff ff       	jmp    795 <malloc+0x4e>
}
 825:	c9                   	leave  
 826:	c3                   	ret    
 827:	90                   	nop

00000828 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 828:	55                   	push   %ebp
 829:	89 e5                	mov    %esp,%ebp
 82b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 82e:	8b 55 08             	mov    0x8(%ebp),%edx
 831:	8b 45 0c             	mov    0xc(%ebp),%eax
 834:	8b 4d 08             	mov    0x8(%ebp),%ecx
 837:	f0 87 02             	lock xchg %eax,(%edx)
 83a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 84e:	5d                   	pop    %ebp
 84f:	c3                   	ret    

00000850 <lock_acquire>:
void lock_acquire(lock_t *lock){
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 856:	8b 45 08             	mov    0x8(%ebp),%eax
 859:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 860:	00 
 861:	89 04 24             	mov    %eax,(%esp)
 864:	e8 bf ff ff ff       	call   828 <xchg>
 869:	85 c0                	test   %eax,%eax
 86b:	75 e9                	jne    856 <lock_acquire+0x6>
}
 86d:	c9                   	leave  
 86e:	c3                   	ret    

0000086f <lock_release>:
void lock_release(lock_t *lock){
 86f:	55                   	push   %ebp
 870:	89 e5                	mov    %esp,%ebp
 872:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 87f:	00 
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 a0 ff ff ff       	call   828 <xchg>
}
 888:	c9                   	leave  
 889:	c3                   	ret    

0000088a <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 88a:	55                   	push   %ebp
 88b:	89 e5                	mov    %esp,%ebp
 88d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 890:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 897:	e8 ab fe ff ff       	call   747 <malloc>
 89c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	25 ff 0f 00 00       	and    $0xfff,%eax
 8ad:	85 c0                	test   %eax,%eax
 8af:	74 15                	je     8c6 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	89 c2                	mov    %eax,%edx
 8b6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 8bc:	b8 00 10 00 00       	mov    $0x1000,%eax
 8c1:	29 d0                	sub    %edx,%eax
 8c3:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 8c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ca:	75 1b                	jne    8e7 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 8cc:	c7 44 24 04 95 0a 00 	movl   $0xa95,0x4(%esp)
 8d3:	00 
 8d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8db:	e8 81 fb ff ff       	call   461 <printf>
        return 0;
 8e0:	b8 00 00 00 00       	mov    $0x0,%eax
 8e5:	eb 6f                	jmp    956 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 8e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8ea:	8b 55 08             	mov    0x8(%ebp),%edx
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 8f4:	89 54 24 08          	mov    %edx,0x8(%esp)
 8f8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 8ff:	00 
 900:	89 04 24             	mov    %eax,(%esp)
 903:	e8 60 fa ff ff       	call   368 <clone>
 908:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 90b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 90f:	79 1b                	jns    92c <thread_create+0xa2>
        printf(1,"clone fails\n");
 911:	c7 44 24 04 a3 0a 00 	movl   $0xaa3,0x4(%esp)
 918:	00 
 919:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 920:	e8 3c fb ff ff       	call   461 <printf>
        return 0;
 925:	b8 00 00 00 00       	mov    $0x0,%eax
 92a:	eb 2a                	jmp    956 <thread_create+0xcc>
    }
    if(tid > 0){
 92c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 930:	7e 05                	jle    937 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	eb 1f                	jmp    956 <thread_create+0xcc>
    }
    if(tid == 0){
 937:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 93b:	75 14                	jne    951 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 93d:	c7 44 24 04 b0 0a 00 	movl   $0xab0,0x4(%esp)
 944:	00 
 945:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 94c:	e8 10 fb ff ff       	call   461 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 951:	b8 00 00 00 00       	mov    $0x0,%eax
}
 956:	c9                   	leave  
 957:	c3                   	ret    

00000958 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 958:	55                   	push   %ebp
 959:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 95b:	8b 45 08             	mov    0x8(%ebp),%eax
 95e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 964:	8b 45 08             	mov    0x8(%ebp),%eax
 967:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 96e:	8b 45 08             	mov    0x8(%ebp),%eax
 971:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 978:	5d                   	pop    %ebp
 979:	c3                   	ret    

0000097a <add_q>:

void add_q(struct queue *q, int v){
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 980:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 987:	e8 bb fd ff ff       	call   747 <malloc>
 98c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8b 55 0c             	mov    0xc(%ebp),%edx
 99f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 9a1:	8b 45 08             	mov    0x8(%ebp),%eax
 9a4:	8b 40 04             	mov    0x4(%eax),%eax
 9a7:	85 c0                	test   %eax,%eax
 9a9:	75 0b                	jne    9b6 <add_q+0x3c>
        q->head = n;
 9ab:	8b 45 08             	mov    0x8(%ebp),%eax
 9ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
 9b4:	eb 0c                	jmp    9c2 <add_q+0x48>
    }else{
        q->tail->next = n;
 9b6:	8b 45 08             	mov    0x8(%ebp),%eax
 9b9:	8b 40 08             	mov    0x8(%eax),%eax
 9bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9bf:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 9c2:	8b 45 08             	mov    0x8(%ebp),%eax
 9c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9c8:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	8b 00                	mov    (%eax),%eax
 9d0:	8d 50 01             	lea    0x1(%eax),%edx
 9d3:	8b 45 08             	mov    0x8(%ebp),%eax
 9d6:	89 10                	mov    %edx,(%eax)
}
 9d8:	c9                   	leave  
 9d9:	c3                   	ret    

000009da <empty_q>:

int empty_q(struct queue *q){
 9da:	55                   	push   %ebp
 9db:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	8b 00                	mov    (%eax),%eax
 9e2:	85 c0                	test   %eax,%eax
 9e4:	75 07                	jne    9ed <empty_q+0x13>
        return 1;
 9e6:	b8 01 00 00 00       	mov    $0x1,%eax
 9eb:	eb 05                	jmp    9f2 <empty_q+0x18>
    else
        return 0;
 9ed:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 9f2:	5d                   	pop    %ebp
 9f3:	c3                   	ret    

000009f4 <pop_q>:
int pop_q(struct queue *q){
 9f4:	55                   	push   %ebp
 9f5:	89 e5                	mov    %esp,%ebp
 9f7:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 9fa:	8b 45 08             	mov    0x8(%ebp),%eax
 9fd:	89 04 24             	mov    %eax,(%esp)
 a00:	e8 d5 ff ff ff       	call   9da <empty_q>
 a05:	85 c0                	test   %eax,%eax
 a07:	75 5d                	jne    a66 <pop_q+0x72>
       val = q->head->value; 
 a09:	8b 45 08             	mov    0x8(%ebp),%eax
 a0c:	8b 40 04             	mov    0x4(%eax),%eax
 a0f:	8b 00                	mov    (%eax),%eax
 a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 a14:	8b 45 08             	mov    0x8(%ebp),%eax
 a17:	8b 40 04             	mov    0x4(%eax),%eax
 a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	8b 40 04             	mov    0x4(%eax),%eax
 a23:	8b 50 04             	mov    0x4(%eax),%edx
 a26:	8b 45 08             	mov    0x8(%ebp),%eax
 a29:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	89 04 24             	mov    %eax,(%esp)
 a32:	e8 e1 fb ff ff       	call   618 <free>
       q->size--;
 a37:	8b 45 08             	mov    0x8(%ebp),%eax
 a3a:	8b 00                	mov    (%eax),%eax
 a3c:	8d 50 ff             	lea    -0x1(%eax),%edx
 a3f:	8b 45 08             	mov    0x8(%ebp),%eax
 a42:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 a44:	8b 45 08             	mov    0x8(%ebp),%eax
 a47:	8b 00                	mov    (%eax),%eax
 a49:	85 c0                	test   %eax,%eax
 a4b:	75 14                	jne    a61 <pop_q+0x6d>
            q->head = 0;
 a4d:	8b 45 08             	mov    0x8(%ebp),%eax
 a50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a64:	eb 05                	jmp    a6b <pop_q+0x77>
    }
    return -1;
 a66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a6b:	c9                   	leave  
 a6c:	c3                   	ret    

00000a6d <front>:

int front(struct queue *q)
{
 a6d:	55                   	push   %ebp
 a6e:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 a70:	8b 45 08             	mov    0x8(%ebp),%eax
 a73:	8b 40 04             	mov    0x4(%eax),%eax
 a76:	8b 00                	mov    (%eax),%eax
}
 a78:	5d                   	pop    %ebp
 a79:	c3                   	ret    
