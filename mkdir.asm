
_mkdir:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 9a 0a 00 	movl   $0xa9a,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 5e 04 00 00       	call   481 <printf>
    exit();
  23:	e8 c0 02 00 00       	call   2e8 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 43                	jmp    75 <main+0x75>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 0a 03 00 00       	call   350 <mkdir>
  46:	85 c0                	test   %eax,%eax
  48:	79 26                	jns    70 <main+0x70>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  4a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4e:	c1 e0 02             	shl    $0x2,%eax
  51:	03 45 0c             	add    0xc(%ebp),%eax
  54:	8b 00                	mov    (%eax),%eax
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	c7 44 24 04 b1 0a 00 	movl   $0xab1,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	e8 13 04 00 00       	call   481 <printf>
      break;
  6e:	eb 0e                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  70:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	3b 45 08             	cmp    0x8(%ebp),%eax
  7c:	7c b4                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 65 02 00 00       	call   2e8 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 10             	movzbl (%eax),%edx
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	88 10                	mov    %dl,(%eax)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	0f 95 c0             	setne  %al
  cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  d3:	84 c0                	test   %al,%al
  d5:	75 de                	jne    b5 <strcpy+0xc>
    ;
  return os;
  d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  da:	c9                   	leave  
  db:	c3                   	ret    

000000dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  df:	eb 08                	jmp    e9 <strcmp+0xd>
    p++, q++;
  e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 10                	je     103 <strcmp+0x27>
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 10             	movzbl (%eax),%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	38 c2                	cmp    %al,%dl
 101:	74 de                	je     e1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 c0             	movzbl %al,%eax
 115:	89 d1                	mov    %edx,%ecx
 117:	29 c1                	sub    %eax,%ecx
 119:	89 c8                	mov    %ecx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 04                	jmp    130 <strlen+0x13>
 12c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
 133:	03 45 08             	add    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 ef                	jne    12c <strlen+0xf>
    ;
  return n;
 13d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 44 24 04          	mov    %eax,0x4(%esp)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	89 04 24             	mov    %eax,(%esp)
 15c:	e8 23 ff ff ff       	call   84 <stosb>
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1a6:	eb 44                	jmp    1ec <gets+0x53>
    cc = read(0, &c, 1);
 1a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1af:	00 
 1b0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1be:	e8 3d 01 00 00       	call   300 <read>
 1c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ca:	7e 2d                	jle    1f9 <gets+0x60>
      break;
    buf[i++] = c;
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	03 45 08             	add    0x8(%ebp),%eax
 1d2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1d6:	88 10                	mov    %dl,(%eax)
 1d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 16                	je     1fa <gets+0x61>
 1e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e8:	3c 0d                	cmp    $0xd,%al
 1ea:	74 0e                	je     1fa <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ef:	83 c0 01             	add    $0x1,%eax
 1f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f5:	7c b1                	jl     1a8 <gets+0xf>
 1f7:	eb 01                	jmp    1fa <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1fd:	03 45 08             	add    0x8(%ebp),%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 215:	00 
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	89 04 24             	mov    %eax,(%esp)
 21c:	e8 07 01 00 00       	call   328 <open>
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 228:	79 07                	jns    231 <stat+0x29>
    return -1;
 22a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22f:	eb 23                	jmp    254 <stat+0x4c>
  r = fstat(fd, st);
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	89 44 24 04          	mov    %eax,0x4(%esp)
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23b:	89 04 24             	mov    %eax,(%esp)
 23e:	e8 fd 00 00 00       	call   340 <fstat>
 243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 246:	8b 45 f0             	mov    -0x10(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 bf 00 00 00       	call   310 <close>
  return r;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <atoi>:

int
atoi(const char *s)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 263:	eb 24                	jmp    289 <atoi+0x33>
    n = n*10 + *s++ - '0';
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	89 d0                	mov    %edx,%eax
 26a:	c1 e0 02             	shl    $0x2,%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	01 c0                	add    %eax,%eax
 271:	89 c2                	mov    %eax,%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	0f be c0             	movsbl %al,%eax
 27c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 27f:	83 e8 30             	sub    $0x30,%eax
 282:	89 45 fc             	mov    %eax,-0x4(%ebp)
 285:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x47>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c8                	jle    265 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2b4:	eb 13                	jmp    2c9 <memmove+0x27>
    *dst++ = *src++;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b9:	0f b6 10             	movzbl (%eax),%edx
 2bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2bf:	88 10                	mov    %dl,(%eax)
 2c1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2cd:	0f 9f c0             	setg   %al
 2d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2d4:	84 c0                	test   %al,%al
 2d6:	75 de                	jne    2b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    
 2dd:	90                   	nop
 2de:	90                   	nop
 2df:	90                   	nop

000002e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exit>:
SYSCALL(exit)
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait>:
SYSCALL(wait)
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <pipe>:
SYSCALL(pipe)
 2f8:	b8 04 00 00 00       	mov    $0x4,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <read>:
SYSCALL(read)
 300:	b8 05 00 00 00       	mov    $0x5,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <write>:
SYSCALL(write)
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <close>:
SYSCALL(close)
 310:	b8 15 00 00 00       	mov    $0x15,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <kill>:
SYSCALL(kill)
 318:	b8 06 00 00 00       	mov    $0x6,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <exec>:
SYSCALL(exec)
 320:	b8 07 00 00 00       	mov    $0x7,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <open>:
SYSCALL(open)
 328:	b8 0f 00 00 00       	mov    $0xf,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mknod>:
SYSCALL(mknod)
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <unlink>:
SYSCALL(unlink)
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <fstat>:
SYSCALL(fstat)
 340:	b8 08 00 00 00       	mov    $0x8,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <link>:
SYSCALL(link)
 348:	b8 13 00 00 00       	mov    $0x13,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <mkdir>:
SYSCALL(mkdir)
 350:	b8 14 00 00 00       	mov    $0x14,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <chdir>:
SYSCALL(chdir)
 358:	b8 09 00 00 00       	mov    $0x9,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <dup>:
SYSCALL(dup)
 360:	b8 0a 00 00 00       	mov    $0xa,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getpid>:
SYSCALL(getpid)
 368:	b8 0b 00 00 00       	mov    $0xb,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sbrk>:
SYSCALL(sbrk)
 370:	b8 0c 00 00 00       	mov    $0xc,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <sleep>:
SYSCALL(sleep)
 378:	b8 0d 00 00 00       	mov    $0xd,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <uptime>:
SYSCALL(uptime)
 380:	b8 0e 00 00 00       	mov    $0xe,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <clone>:
SYSCALL(clone)
 388:	b8 16 00 00 00       	mov    $0x16,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <texit>:
SYSCALL(texit)
 390:	b8 17 00 00 00       	mov    $0x17,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <tsleep>:
SYSCALL(tsleep)
 398:	b8 18 00 00 00       	mov    $0x18,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <twakeup>:
SYSCALL(twakeup)
 3a0:	b8 19 00 00 00       	mov    $0x19,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 28             	sub    $0x28,%esp
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bb:	00 
 3bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	89 04 24             	mov    %eax,(%esp)
 3c9:	e8 3a ff ff ff       	call   308 <write>
}
 3ce:	c9                   	leave  
 3cf:	c3                   	ret    

000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e2:	74 17                	je     3fb <printint+0x2b>
 3e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e8:	79 11                	jns    3fb <printint+0x2b>
    neg = 1;
 3ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	f7 d8                	neg    %eax
 3f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f9:	eb 06                	jmp    401 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 401:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 408:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 40b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 40e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 411:	ba 00 00 00 00       	mov    $0x0,%edx
 416:	f7 f3                	div    %ebx
 418:	89 d0                	mov    %edx,%eax
 41a:	0f b6 80 00 0b 00 00 	movzbl 0xb00(%eax),%eax
 421:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 425:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 429:	8b 45 10             	mov    0x10(%ebp),%eax
 42c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 432:	ba 00 00 00 00       	mov    $0x0,%edx
 437:	f7 75 d4             	divl   -0x2c(%ebp)
 43a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 43d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 441:	75 c5                	jne    408 <printint+0x38>
  if(neg)
 443:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 447:	74 28                	je     471 <printint+0xa1>
    buf[i++] = '-';
 449:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 451:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 455:	eb 1a                	jmp    471 <printint+0xa1>
    putc(fd, buf[i]);
 457:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 45f:	0f be c0             	movsbl %al,%eax
 462:	89 44 24 04          	mov    %eax,0x4(%esp)
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	89 04 24             	mov    %eax,(%esp)
 46c:	e8 37 ff ff ff       	call   3a8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 471:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	79 dc                	jns    457 <printint+0x87>
    putc(fd, buf[i]);
}
 47b:	83 c4 44             	add    $0x44,%esp
 47e:	5b                   	pop    %ebx
 47f:	5d                   	pop    %ebp
 480:	c3                   	ret    

00000481 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48e:	8d 45 0c             	lea    0xc(%ebp),%eax
 491:	83 c0 04             	add    $0x4,%eax
 494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 497:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 49e:	e9 7e 01 00 00       	jmp    621 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a9:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	25 ff 00 00 00       	and    $0xff,%eax
 4b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4be:	75 2c                	jne    4ec <printf+0x6b>
      if(c == '%'){
 4c0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4c4:	75 0c                	jne    4d2 <printf+0x51>
        state = '%';
 4c6:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4cd:	e9 4b 01 00 00       	jmp    61d <printf+0x19c>
      } else {
        putc(fd, c);
 4d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 04 24             	mov    %eax,(%esp)
 4e2:	e8 c1 fe ff ff       	call   3a8 <putc>
 4e7:	e9 31 01 00 00       	jmp    61d <printf+0x19c>
      }
    } else if(state == '%'){
 4ec:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4f0:	0f 85 27 01 00 00    	jne    61d <printf+0x19c>
      if(c == 'd'){
 4f6:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4fa:	75 2d                	jne    529 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	8b 00                	mov    (%eax),%eax
 501:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 508:	00 
 509:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 510:	00 
 511:	89 44 24 04          	mov    %eax,0x4(%esp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	89 04 24             	mov    %eax,(%esp)
 51b:	e8 b0 fe ff ff       	call   3d0 <printint>
        ap++;
 520:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 524:	e9 ed 00 00 00       	jmp    616 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 529:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 52d:	74 06                	je     535 <printf+0xb4>
 52f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 533:	75 2d                	jne    562 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 535:	8b 45 f4             	mov    -0xc(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 541:	00 
 542:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 549:	00 
 54a:	89 44 24 04          	mov    %eax,0x4(%esp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 77 fe ff ff       	call   3d0 <printint>
        ap++;
 559:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 55d:	e9 b4 00 00 00       	jmp    616 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 562:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 566:	75 46                	jne    5ae <printf+0x12d>
        s = (char*)*ap;
 568:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 570:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 574:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 578:	75 27                	jne    5a1 <printf+0x120>
          s = "(null)";
 57a:	c7 45 e4 cd 0a 00 00 	movl   $0xacd,-0x1c(%ebp)
        while(*s != 0){
 581:	eb 1f                	jmp    5a2 <printf+0x121>
          putc(fd, *s);
 583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 586:	0f b6 00             	movzbl (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	89 44 24 04          	mov    %eax,0x4(%esp)
 590:	8b 45 08             	mov    0x8(%ebp),%eax
 593:	89 04 24             	mov    %eax,(%esp)
 596:	e8 0d fe ff ff       	call   3a8 <putc>
          s++;
 59b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 59f:	eb 01                	jmp    5a2 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a1:	90                   	nop
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	84 c0                	test   %al,%al
 5aa:	75 d7                	jne    583 <printf+0x102>
 5ac:	eb 68                	jmp    616 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ae:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 5b2:	75 1d                	jne    5d1 <printf+0x150>
        putc(fd, *ap);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 dd fd ff ff       	call   3a8 <putc>
        ap++;
 5cb:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5cf:	eb 45                	jmp    616 <printf+0x195>
      } else if(c == '%'){
 5d1:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5d5:	75 17                	jne    5ee <printf+0x16d>
        putc(fd, c);
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 bc fd ff ff       	call   3a8 <putc>
 5ec:	eb 28                	jmp    616 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ee:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f5:	00 
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 a7 fd ff ff       	call   3a8 <putc>
        putc(fd, c);
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	89 44 24 04          	mov    %eax,0x4(%esp)
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	89 04 24             	mov    %eax,(%esp)
 611:	e8 92 fd ff ff       	call   3a8 <putc>
      }
      state = 0;
 616:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 621:	8b 55 0c             	mov    0xc(%ebp),%edx
 624:	8b 45 ec             	mov    -0x14(%ebp),%eax
 627:	8d 04 02             	lea    (%edx,%eax,1),%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	84 c0                	test   %al,%al
 62f:	0f 85 6e fe ff ff    	jne    4a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 635:	c9                   	leave  
 636:	c3                   	ret    
 637:	90                   	nop

00000638 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	83 e8 08             	sub    $0x8,%eax
 644:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	eb 24                	jmp    675 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 659:	77 12                	ja     66d <free+0x35>
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 24                	ja     687 <free+0x4f>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	77 1a                	ja     687 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 fc             	mov    %eax,-0x4(%ebp)
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	76 d4                	jbe    651 <free+0x19>
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 685:	76 ca                	jbe    651 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	c1 e0 03             	shl    $0x3,%eax
 690:	89 c2                	mov    %eax,%edx
 692:	03 55 f8             	add    -0x8(%ebp),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	39 c2                	cmp    %eax,%edx
 69c:	75 24                	jne    6c2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	8b 40 04             	mov    0x4(%eax),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	8b 10                	mov    (%eax),%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 10                	mov    %edx,(%eax)
 6c0:	eb 0a                	jmp    6cc <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	c1 e0 03             	shl    $0x3,%eax
 6d5:	03 45 fc             	add    -0x4(%ebp),%eax
 6d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6db:	75 20                	jne    6fd <free+0xc5>
    p->s.size += bp->s.size;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 50 04             	mov    0x4(%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	8b 10                	mov    (%eax),%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	89 10                	mov    %edx,(%eax)
 6fb:	eb 08                	jmp    705 <free+0xcd>
  } else
    p->s.ptr = bp;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 55 f8             	mov    -0x8(%ebp),%edx
 703:	89 10                	mov    %edx,(%eax)
  freep = p;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	a3 1c 0b 00 00       	mov    %eax,0xb1c
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <morecore>:

static Header*
morecore(uint nu)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 715:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71c:	77 07                	ja     725 <morecore+0x16>
    nu = 4096;
 71e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	c1 e0 03             	shl    $0x3,%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 3d fc ff ff       	call   370 <sbrk>
 733:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 736:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 73a:	75 07                	jne    743 <morecore+0x34>
    return 0;
 73c:	b8 00 00 00 00       	mov    $0x0,%eax
 741:	eb 22                	jmp    765 <morecore+0x56>
  hp = (Header*)p;
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 749:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74c:	8b 55 08             	mov    0x8(%ebp),%edx
 74f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	83 c0 08             	add    $0x8,%eax
 758:	89 04 24             	mov    %eax,(%esp)
 75b:	e8 d8 fe ff ff       	call   638 <free>
  return freep;
 760:	a1 1c 0b 00 00       	mov    0xb1c,%eax
}
 765:	c9                   	leave  
 766:	c3                   	ret    

00000767 <malloc>:

void*
malloc(uint nbytes)
{
 767:	55                   	push   %ebp
 768:	89 e5                	mov    %esp,%ebp
 76a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	83 c0 07             	add    $0x7,%eax
 773:	c1 e8 03             	shr    $0x3,%eax
 776:	83 c0 01             	add    $0x1,%eax
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 77c:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 781:	89 45 f0             	mov    %eax,-0x10(%ebp)
 784:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 788:	75 23                	jne    7ad <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78a:	c7 45 f0 14 0b 00 00 	movl   $0xb14,-0x10(%ebp)
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	a3 1c 0b 00 00       	mov    %eax,0xb1c
 799:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 79e:	a3 14 0b 00 00       	mov    %eax,0xb14
    base.s.size = 0;
 7a3:	c7 05 18 0b 00 00 00 	movl   $0x0,0xb18
 7aa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7be:	72 4d                	jb     80d <malloc+0xa6>
      if(p->s.size == nunits)
 7c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7c9:	75 0c                	jne    7d7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ce:	8b 10                	mov    (%eax),%edx
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	89 10                	mov    %edx,(%eax)
 7d5:	eb 26                	jmp    7fd <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7da:	8b 40 04             	mov    0x4(%eax),%eax
 7dd:	89 c2                	mov    %eax,%edx
 7df:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	c1 e0 03             	shl    $0x3,%eax
 7f1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	a3 1c 0b 00 00       	mov    %eax,0xb1c
      return (void*)(p + 1);
 805:	8b 45 ec             	mov    -0x14(%ebp),%eax
 808:	83 c0 08             	add    $0x8,%eax
 80b:	eb 38                	jmp    845 <malloc+0xde>
    }
    if(p == freep)
 80d:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 812:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 815:	75 1b                	jne    832 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	89 04 24             	mov    %eax,(%esp)
 81d:	e8 ed fe ff ff       	call   70f <morecore>
 822:	89 45 ec             	mov    %eax,-0x14(%ebp)
 825:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 829:	75 07                	jne    832 <malloc+0xcb>
        return 0;
 82b:	b8 00 00 00 00       	mov    $0x0,%eax
 830:	eb 13                	jmp    845 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	8b 45 ec             	mov    -0x14(%ebp),%eax
 835:	89 45 f0             	mov    %eax,-0x10(%ebp)
 838:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 840:	e9 70 ff ff ff       	jmp    7b5 <malloc+0x4e>
}
 845:	c9                   	leave  
 846:	c3                   	ret    
 847:	90                   	nop

00000848 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 84e:	8b 55 08             	mov    0x8(%ebp),%edx
 851:	8b 45 0c             	mov    0xc(%ebp),%eax
 854:	8b 4d 08             	mov    0x8(%ebp),%ecx
 857:	f0 87 02             	lock xchg %eax,(%edx)
 85a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 860:	c9                   	leave  
 861:	c3                   	ret    

00000862 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 862:	55                   	push   %ebp
 863:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret    

00000870 <lock_acquire>:
void lock_acquire(lock_t *lock){
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 880:	00 
 881:	89 04 24             	mov    %eax,(%esp)
 884:	e8 bf ff ff ff       	call   848 <xchg>
 889:	85 c0                	test   %eax,%eax
 88b:	75 e9                	jne    876 <lock_acquire+0x6>
}
 88d:	c9                   	leave  
 88e:	c3                   	ret    

0000088f <lock_release>:
void lock_release(lock_t *lock){
 88f:	55                   	push   %ebp
 890:	89 e5                	mov    %esp,%ebp
 892:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 895:	8b 45 08             	mov    0x8(%ebp),%eax
 898:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 89f:	00 
 8a0:	89 04 24             	mov    %eax,(%esp)
 8a3:	e8 a0 ff ff ff       	call   848 <xchg>
}
 8a8:	c9                   	leave  
 8a9:	c3                   	ret    

000008aa <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 8aa:	55                   	push   %ebp
 8ab:	89 e5                	mov    %esp,%ebp
 8ad:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 8b0:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 8b7:	e8 ab fe ff ff       	call   767 <malloc>
 8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 8bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	25 ff 0f 00 00       	and    $0xfff,%eax
 8cd:	85 c0                	test   %eax,%eax
 8cf:	74 15                	je     8e6 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	89 c2                	mov    %eax,%edx
 8d6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 8dc:	b8 00 10 00 00       	mov    $0x1000,%eax
 8e1:	29 d0                	sub    %edx,%eax
 8e3:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 8e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8ea:	75 1b                	jne    907 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 8ec:	c7 44 24 04 d4 0a 00 	movl   $0xad4,0x4(%esp)
 8f3:	00 
 8f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8fb:	e8 81 fb ff ff       	call   481 <printf>
        return 0;
 900:	b8 00 00 00 00       	mov    $0x0,%eax
 905:	eb 6f                	jmp    976 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 907:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 90a:	8b 55 08             	mov    0x8(%ebp),%edx
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 914:	89 54 24 08          	mov    %edx,0x8(%esp)
 918:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 91f:	00 
 920:	89 04 24             	mov    %eax,(%esp)
 923:	e8 60 fa ff ff       	call   388 <clone>
 928:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 92b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 92f:	79 1b                	jns    94c <thread_create+0xa2>
        printf(1,"clone fails\n");
 931:	c7 44 24 04 e2 0a 00 	movl   $0xae2,0x4(%esp)
 938:	00 
 939:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 940:	e8 3c fb ff ff       	call   481 <printf>
        return 0;
 945:	b8 00 00 00 00       	mov    $0x0,%eax
 94a:	eb 2a                	jmp    976 <thread_create+0xcc>
    }
    if(tid > 0){
 94c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 950:	7e 05                	jle    957 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	eb 1f                	jmp    976 <thread_create+0xcc>
    }
    if(tid == 0){
 957:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 95b:	75 14                	jne    971 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 95d:	c7 44 24 04 ef 0a 00 	movl   $0xaef,0x4(%esp)
 964:	00 
 965:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 96c:	e8 10 fb ff ff       	call   481 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 971:	b8 00 00 00 00       	mov    $0x0,%eax
}
 976:	c9                   	leave  
 977:	c3                   	ret    

00000978 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 978:	55                   	push   %ebp
 979:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 97b:	8b 45 08             	mov    0x8(%ebp),%eax
 97e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 98e:	8b 45 08             	mov    0x8(%ebp),%eax
 991:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 998:	5d                   	pop    %ebp
 999:	c3                   	ret    

0000099a <add_q>:

void add_q(struct queue *q, int v){
 99a:	55                   	push   %ebp
 99b:	89 e5                	mov    %esp,%ebp
 99d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 9a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 9a7:	e8 bb fd ff ff       	call   767 <malloc>
 9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 9bf:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 9c1:	8b 45 08             	mov    0x8(%ebp),%eax
 9c4:	8b 40 04             	mov    0x4(%eax),%eax
 9c7:	85 c0                	test   %eax,%eax
 9c9:	75 0b                	jne    9d6 <add_q+0x3c>
        q->head = n;
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9d1:	89 50 04             	mov    %edx,0x4(%eax)
 9d4:	eb 0c                	jmp    9e2 <add_q+0x48>
    }else{
        q->tail->next = n;
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	8b 40 08             	mov    0x8(%eax),%eax
 9dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9df:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 9e2:	8b 45 08             	mov    0x8(%ebp),%eax
 9e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9e8:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	8b 00                	mov    (%eax),%eax
 9f0:	8d 50 01             	lea    0x1(%eax),%edx
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	89 10                	mov    %edx,(%eax)
}
 9f8:	c9                   	leave  
 9f9:	c3                   	ret    

000009fa <empty_q>:

int empty_q(struct queue *q){
 9fa:	55                   	push   %ebp
 9fb:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	8b 00                	mov    (%eax),%eax
 a02:	85 c0                	test   %eax,%eax
 a04:	75 07                	jne    a0d <empty_q+0x13>
        return 1;
 a06:	b8 01 00 00 00       	mov    $0x1,%eax
 a0b:	eb 05                	jmp    a12 <empty_q+0x18>
    else
        return 0;
 a0d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a12:	5d                   	pop    %ebp
 a13:	c3                   	ret    

00000a14 <pop_q>:
int pop_q(struct queue *q){
 a14:	55                   	push   %ebp
 a15:	89 e5                	mov    %esp,%ebp
 a17:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 a1a:	8b 45 08             	mov    0x8(%ebp),%eax
 a1d:	89 04 24             	mov    %eax,(%esp)
 a20:	e8 d5 ff ff ff       	call   9fa <empty_q>
 a25:	85 c0                	test   %eax,%eax
 a27:	75 5d                	jne    a86 <pop_q+0x72>
       val = q->head->value; 
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	8b 40 04             	mov    0x4(%eax),%eax
 a2f:	8b 00                	mov    (%eax),%eax
 a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 a34:	8b 45 08             	mov    0x8(%ebp),%eax
 a37:	8b 40 04             	mov    0x4(%eax),%eax
 a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 a3d:	8b 45 08             	mov    0x8(%ebp),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	8b 50 04             	mov    0x4(%eax),%edx
 a46:	8b 45 08             	mov    0x8(%ebp),%eax
 a49:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4f:	89 04 24             	mov    %eax,(%esp)
 a52:	e8 e1 fb ff ff       	call   638 <free>
       q->size--;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	8b 00                	mov    (%eax),%eax
 a5c:	8d 50 ff             	lea    -0x1(%eax),%edx
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 a64:	8b 45 08             	mov    0x8(%ebp),%eax
 a67:	8b 00                	mov    (%eax),%eax
 a69:	85 c0                	test   %eax,%eax
 a6b:	75 14                	jne    a81 <pop_q+0x6d>
            q->head = 0;
 a6d:	8b 45 08             	mov    0x8(%ebp),%eax
 a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 a77:	8b 45 08             	mov    0x8(%ebp),%eax
 a7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a84:	eb 05                	jmp    a8b <pop_q+0x77>
    }
    return -1;
 a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a8b:	c9                   	leave  
 a8c:	c3                   	ret    

00000a8d <front>:

int front(struct queue *q)
{
 a8d:	55                   	push   %ebp
 a8e:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 a90:	8b 45 08             	mov    0x8(%ebp),%eax
 a93:	8b 40 04             	mov    0x4(%eax),%eax
 a96:	8b 00                	mov    (%eax),%eax
}
 a98:	5d                   	pop    %ebp
 a99:	c3                   	ret    
