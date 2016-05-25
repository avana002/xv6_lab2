
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 71 03 00 00       	call   394 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 4e 03 00 00       	call   38c <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 26 0b 00 	movl   $0xb26,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 ac 04 00 00       	call   50d <printf>
    exit();
  61:	e8 0e 03 00 00       	call   374 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 ec 02 00 00       	call   374 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 6d                	jmp    ff <main+0x97>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	c1 e0 02             	shl    $0x2,%eax
  99:	03 45 0c             	add    0xc(%ebp),%eax
  9c:	8b 00                	mov    (%eax),%eax
  9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  a5:	00 
  a6:	89 04 24             	mov    %eax,(%esp)
  a9:	e8 06 03 00 00       	call   3b4 <open>
  ae:	89 44 24 18          	mov    %eax,0x18(%esp)
  b2:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  b7:	79 29                	jns    e2 <main+0x7a>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  bd:	c1 e0 02             	shl    $0x2,%eax
  c0:	03 45 0c             	add    0xc(%ebp),%eax
  c3:	8b 00                	mov    (%eax),%eax
  c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  c9:	c7 44 24 04 37 0b 00 	movl   $0xb37,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 30 04 00 00       	call   50d <printf>
      exit();
  dd:	e8 92 02 00 00       	call   374 <exit>
    }
    cat(fd);
  e2:	8b 44 24 18          	mov    0x18(%esp),%eax
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
    close(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 a2 02 00 00       	call   39c <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  fa:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  ff:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 103:	3b 45 08             	cmp    0x8(%ebp),%eax
 106:	7c 8a                	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 108:	e8 67 02 00 00       	call   374 <exit>
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	0f b6 10             	movzbl (%eax),%edx
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 10                	mov    %dl,(%eax)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	0f b6 00             	movzbl (%eax),%eax
 152:	84 c0                	test   %al,%al
 154:	0f 95 c0             	setne  %al
 157:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 15f:	84 c0                	test   %al,%al
 161:	75 de                	jne    141 <strcpy+0xc>
    ;
  return os;
 163:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16b:	eb 08                	jmp    175 <strcmp+0xd>
    p++, q++;
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	84 c0                	test   %al,%al
 17d:	74 10                	je     18f <strcmp+0x27>
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 10             	movzbl (%eax),%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	38 c2                	cmp    %al,%dl
 18d:	74 de                	je     16d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	0f b6 d0             	movzbl %al,%edx
 198:	8b 45 0c             	mov    0xc(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f b6 c0             	movzbl %al,%eax
 1a1:	89 d1                	mov    %edx,%ecx
 1a3:	29 c1                	sub    %eax,%ecx
 1a5:	89 c8                	mov    %ecx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strlen>:

uint
strlen(char *s)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b6:	eb 04                	jmp    1bc <strlen+0x13>
 1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1bf:	03 45 08             	add    0x8(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	84 c0                	test   %al,%al
 1c7:	75 ef                	jne    1b8 <strlen+0xf>
    ;
  return n;
 1c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cc:	c9                   	leave  
 1cd:	c3                   	ret    

000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d4:	8b 45 10             	mov    0x10(%ebp),%eax
 1d7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 23 ff ff ff       	call   110 <stosb>
  return dst;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f0:	c9                   	leave  
 1f1:	c3                   	ret    

000001f2 <strchr>:

char*
strchr(const char *s, char c)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 04             	sub    $0x4,%esp
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fe:	eb 14                	jmp    214 <strchr+0x22>
    if(*s == c)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3a 45 fc             	cmp    -0x4(%ebp),%al
 209:	75 05                	jne    210 <strchr+0x1e>
      return (char*)s;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	eb 13                	jmp    223 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	84 c0                	test   %al,%al
 21c:	75 e2                	jne    200 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 223:	c9                   	leave  
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 232:	eb 44                	jmp    278 <gets+0x53>
    cc = read(0, &c, 1);
 234:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23b:	00 
 23c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24a:	e8 3d 01 00 00       	call   38c <read>
 24f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 252:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 256:	7e 2d                	jle    285 <gets+0x60>
      break;
    buf[i++] = c;
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25b:	03 45 08             	add    0x8(%ebp),%eax
 25e:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 262:	88 10                	mov    %dl,(%eax)
 264:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 268:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26c:	3c 0a                	cmp    $0xa,%al
 26e:	74 16                	je     286 <gets+0x61>
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0d                	cmp    $0xd,%al
 276:	74 0e                	je     286 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 278:	8b 45 f0             	mov    -0x10(%ebp),%eax
 27b:	83 c0 01             	add    $0x1,%eax
 27e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 281:	7c b1                	jl     234 <gets+0xf>
 283:	eb 01                	jmp    286 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 285:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 286:	8b 45 f0             	mov    -0x10(%ebp),%eax
 289:	03 45 08             	add    0x8(%ebp),%eax
 28c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <stat>:

int
stat(char *n, struct stat *st)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a1:	00 
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 07 01 00 00       	call   3b4 <open>
 2ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b4:	79 07                	jns    2bd <stat+0x29>
    return -1;
 2b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bb:	eb 23                	jmp    2e0 <stat+0x4c>
  r = fstat(fd, st);
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 fd 00 00 00       	call   3cc <fstat>
 2cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d5:	89 04 24             	mov    %eax,(%esp)
 2d8:	e8 bf 00 00 00       	call   39c <close>
  return r;
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ef:	eb 24                	jmp    315 <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	89 d0                	mov    %edx,%eax
 2f6:	c1 e0 02             	shl    $0x2,%eax
 2f9:	01 d0                	add    %edx,%eax
 2fb:	01 c0                	add    %eax,%eax
 2fd:	89 c2                	mov    %eax,%edx
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	0f be c0             	movsbl %al,%eax
 308:	8d 04 02             	lea    (%edx,%eax,1),%eax
 30b:	83 e8 30             	sub    $0x30,%eax
 30e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 311:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2f                	cmp    $0x2f,%al
 31d:	7e 0a                	jle    329 <atoi+0x47>
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 39                	cmp    $0x39,%al
 327:	7e c8                	jle    2f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 329:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 340:	eb 13                	jmp    355 <memmove+0x27>
    *dst++ = *src++;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	0f b6 10             	movzbl (%eax),%edx
 348:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34b:	88 10                	mov    %dl,(%eax)
 34d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 351:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 355:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 359:	0f 9f c0             	setg   %al
 35c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 360:	84 c0                	test   %al,%al
 362:	75 de                	jne    342 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    
 369:	90                   	nop
 36a:	90                   	nop
 36b:	90                   	nop

0000036c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36c:	b8 01 00 00 00       	mov    $0x1,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <exit>:
SYSCALL(exit)
 374:	b8 02 00 00 00       	mov    $0x2,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <wait>:
SYSCALL(wait)
 37c:	b8 03 00 00 00       	mov    $0x3,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <pipe>:
SYSCALL(pipe)
 384:	b8 04 00 00 00       	mov    $0x4,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <read>:
SYSCALL(read)
 38c:	b8 05 00 00 00       	mov    $0x5,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <write>:
SYSCALL(write)
 394:	b8 10 00 00 00       	mov    $0x10,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <close>:
SYSCALL(close)
 39c:	b8 15 00 00 00       	mov    $0x15,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <kill>:
SYSCALL(kill)
 3a4:	b8 06 00 00 00       	mov    $0x6,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <exec>:
SYSCALL(exec)
 3ac:	b8 07 00 00 00       	mov    $0x7,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <open>:
SYSCALL(open)
 3b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mknod>:
SYSCALL(mknod)
 3bc:	b8 11 00 00 00       	mov    $0x11,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <unlink>:
SYSCALL(unlink)
 3c4:	b8 12 00 00 00       	mov    $0x12,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <fstat>:
SYSCALL(fstat)
 3cc:	b8 08 00 00 00       	mov    $0x8,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <link>:
SYSCALL(link)
 3d4:	b8 13 00 00 00       	mov    $0x13,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mkdir>:
SYSCALL(mkdir)
 3dc:	b8 14 00 00 00       	mov    $0x14,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <chdir>:
SYSCALL(chdir)
 3e4:	b8 09 00 00 00       	mov    $0x9,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <dup>:
SYSCALL(dup)
 3ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <getpid>:
SYSCALL(getpid)
 3f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sbrk>:
SYSCALL(sbrk)
 3fc:	b8 0c 00 00 00       	mov    $0xc,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sleep>:
SYSCALL(sleep)
 404:	b8 0d 00 00 00       	mov    $0xd,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <uptime>:
SYSCALL(uptime)
 40c:	b8 0e 00 00 00       	mov    $0xe,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <clone>:
SYSCALL(clone)
 414:	b8 16 00 00 00       	mov    $0x16,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <texit>:
SYSCALL(texit)
 41c:	b8 17 00 00 00       	mov    $0x17,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <tsleep>:
SYSCALL(tsleep)
 424:	b8 18 00 00 00       	mov    $0x18,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <twakeup>:
SYSCALL(twakeup)
 42c:	b8 19 00 00 00       	mov    $0x19,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 28             	sub    $0x28,%esp
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 440:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 447:	00 
 448:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44b:	89 44 24 04          	mov    %eax,0x4(%esp)
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	89 04 24             	mov    %eax,(%esp)
 455:	e8 3a ff ff ff       	call   394 <write>
}
 45a:	c9                   	leave  
 45b:	c3                   	ret    

0000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	53                   	push   %ebx
 460:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 463:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 46a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46e:	74 17                	je     487 <printint+0x2b>
 470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 474:	79 11                	jns    487 <printint+0x2b>
    neg = 1;
 476:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47d:	8b 45 0c             	mov    0xc(%ebp),%eax
 480:	f7 d8                	neg    %eax
 482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 485:	eb 06                	jmp    48d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 487:	8b 45 0c             	mov    0xc(%ebp),%eax
 48a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 48d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 494:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 497:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49d:	ba 00 00 00 00       	mov    $0x0,%edx
 4a2:	f7 f3                	div    %ebx
 4a4:	89 d0                	mov    %edx,%eax
 4a6:	0f b6 80 80 0b 00 00 	movzbl 0xb80(%eax),%eax
 4ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4b1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4b5:	8b 45 10             	mov    0x10(%ebp),%eax
 4b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4be:	ba 00 00 00 00       	mov    $0x0,%edx
 4c3:	f7 75 d4             	divl   -0x2c(%ebp)
 4c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cd:	75 c5                	jne    494 <printint+0x38>
  if(neg)
 4cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d3:	74 28                	je     4fd <printint+0xa1>
    buf[i++] = '-';
 4d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4dd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4e1:	eb 1a                	jmp    4fd <printint+0xa1>
    putc(fd, buf[i]);
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4eb:	0f be c0             	movsbl %al,%eax
 4ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	89 04 24             	mov    %eax,(%esp)
 4f8:	e8 37 ff ff ff       	call   434 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fd:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 505:	79 dc                	jns    4e3 <printint+0x87>
    putc(fd, buf[i]);
}
 507:	83 c4 44             	add    $0x44,%esp
 50a:	5b                   	pop    %ebx
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    

0000050d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51a:	8d 45 0c             	lea    0xc(%ebp),%eax
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 523:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 52a:	e9 7e 01 00 00       	jmp    6ad <printf+0x1a0>
    c = fmt[i] & 0xff;
 52f:	8b 55 0c             	mov    0xc(%ebp),%edx
 532:	8b 45 ec             	mov    -0x14(%ebp),%eax
 535:	8d 04 02             	lea    (%edx,%eax,1),%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	0f be c0             	movsbl %al,%eax
 53e:	25 ff 00 00 00       	and    $0xff,%eax
 543:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 546:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54a:	75 2c                	jne    578 <printf+0x6b>
      if(c == '%'){
 54c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 550:	75 0c                	jne    55e <printf+0x51>
        state = '%';
 552:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 559:	e9 4b 01 00 00       	jmp    6a9 <printf+0x19c>
      } else {
        putc(fd, c);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	89 44 24 04          	mov    %eax,0x4(%esp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	89 04 24             	mov    %eax,(%esp)
 56e:	e8 c1 fe ff ff       	call   434 <putc>
 573:	e9 31 01 00 00       	jmp    6a9 <printf+0x19c>
      }
    } else if(state == '%'){
 578:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 57c:	0f 85 27 01 00 00    	jne    6a9 <printf+0x19c>
      if(c == 'd'){
 582:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 586:	75 2d                	jne    5b5 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 594:	00 
 595:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 59c:	00 
 59d:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 04 24             	mov    %eax,(%esp)
 5a7:	e8 b0 fe ff ff       	call   45c <printint>
        ap++;
 5ac:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5b0:	e9 ed 00 00 00       	jmp    6a2 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5b5:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5b9:	74 06                	je     5c1 <printf+0xb4>
 5bb:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5bf:	75 2d                	jne    5ee <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5cd:	00 
 5ce:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d5:	00 
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 77 fe ff ff       	call   45c <printint>
        ap++;
 5e5:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5e9:	e9 b4 00 00 00       	jmp    6a2 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5ee:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5f2:	75 46                	jne    63a <printf+0x12d>
        s = (char*)*ap;
 5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5fc:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 604:	75 27                	jne    62d <printf+0x120>
          s = "(null)";
 606:	c7 45 e4 4c 0b 00 00 	movl   $0xb4c,-0x1c(%ebp)
        while(*s != 0){
 60d:	eb 1f                	jmp    62e <printf+0x121>
          putc(fd, *s);
 60f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 612:	0f b6 00             	movzbl (%eax),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	89 44 24 04          	mov    %eax,0x4(%esp)
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 0d fe ff ff       	call   434 <putc>
          s++;
 627:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 62b:	eb 01                	jmp    62e <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62d:	90                   	nop
 62e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	84 c0                	test   %al,%al
 636:	75 d7                	jne    60f <printf+0x102>
 638:	eb 68                	jmp    6a2 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63a:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 63e:	75 1d                	jne    65d <printf+0x150>
        putc(fd, *ap);
 640:	8b 45 f4             	mov    -0xc(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	0f be c0             	movsbl %al,%eax
 648:	89 44 24 04          	mov    %eax,0x4(%esp)
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	89 04 24             	mov    %eax,(%esp)
 652:	e8 dd fd ff ff       	call   434 <putc>
        ap++;
 657:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 65b:	eb 45                	jmp    6a2 <printf+0x195>
      } else if(c == '%'){
 65d:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 661:	75 17                	jne    67a <printf+0x16d>
        putc(fd, c);
 663:	8b 45 e8             	mov    -0x18(%ebp),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 bc fd ff ff       	call   434 <putc>
 678:	eb 28                	jmp    6a2 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 681:	00 
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 a7 fd ff ff       	call   434 <putc>
        putc(fd, c);
 68d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 92 fd ff ff       	call   434 <putc>
      }
      state = 0;
 6a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b3:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6b6:	0f b6 00             	movzbl (%eax),%eax
 6b9:	84 c0                	test   %al,%al
 6bb:	0f 85 6e fe ff ff    	jne    52f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    
 6c3:	90                   	nop

000006c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
 6c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ca:	8b 45 08             	mov    0x8(%ebp),%eax
 6cd:	83 e8 08             	sub    $0x8,%eax
 6d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6db:	eb 24                	jmp    701 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e5:	77 12                	ja     6f9 <free+0x35>
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 24                	ja     713 <free+0x4f>
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f7:	77 1a                	ja     713 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 707:	76 d4                	jbe    6dd <free+0x19>
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 711:	76 ca                	jbe    6dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	8b 40 04             	mov    0x4(%eax),%eax
 719:	c1 e0 03             	shl    $0x3,%eax
 71c:	89 c2                	mov    %eax,%edx
 71e:	03 55 f8             	add    -0x8(%ebp),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	39 c2                	cmp    %eax,%edx
 728:	75 24                	jne    74e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	8b 50 04             	mov    0x4(%eax),%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	01 c2                	add    %eax,%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
 74c:	eb 0a                	jmp    758 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	03 45 fc             	add    -0x4(%ebp),%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	75 20                	jne    789 <free+0xc5>
    p->s.size += bp->s.size;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 50 04             	mov    0x4(%eax),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	01 c2                	add    %eax,%edx
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
 787:	eb 08                	jmp    791 <free+0xcd>
  } else
    p->s.ptr = bp;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78f:	89 10                	mov    %edx,(%eax)
  freep = p;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <morecore>:

static Header*
morecore(uint nu)
{
 79b:	55                   	push   %ebp
 79c:	89 e5                	mov    %esp,%ebp
 79e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a8:	77 07                	ja     7b1 <morecore+0x16>
    nu = 4096;
 7aa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b1:	8b 45 08             	mov    0x8(%ebp),%eax
 7b4:	c1 e0 03             	shl    $0x3,%eax
 7b7:	89 04 24             	mov    %eax,(%esp)
 7ba:	e8 3d fc ff ff       	call   3fc <sbrk>
 7bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7c2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7c6:	75 07                	jne    7cf <morecore+0x34>
    return 0;
 7c8:	b8 00 00 00 00       	mov    $0x0,%eax
 7cd:	eb 22                	jmp    7f1 <morecore+0x56>
  hp = (Header*)p;
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 55 08             	mov    0x8(%ebp),%edx
 7db:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	83 c0 08             	add    $0x8,%eax
 7e4:	89 04 24             	mov    %eax,(%esp)
 7e7:	e8 d8 fe ff ff       	call   6c4 <free>
  return freep;
 7ec:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 7f1:	c9                   	leave  
 7f2:	c3                   	ret    

000007f3 <malloc>:

void*
malloc(uint nbytes)
{
 7f3:	55                   	push   %ebp
 7f4:	89 e5                	mov    %esp,%ebp
 7f6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f9:	8b 45 08             	mov    0x8(%ebp),%eax
 7fc:	83 c0 07             	add    $0x7,%eax
 7ff:	c1 e8 03             	shr    $0x3,%eax
 802:	83 c0 01             	add    $0x1,%eax
 805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 808:	a1 a8 0b 00 00       	mov    0xba8,%eax
 80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 814:	75 23                	jne    839 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 816:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	a3 a8 0b 00 00       	mov    %eax,0xba8
 825:	a1 a8 0b 00 00       	mov    0xba8,%eax
 82a:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 82f:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 836:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 841:	8b 45 ec             	mov    -0x14(%ebp),%eax
 844:	8b 40 04             	mov    0x4(%eax),%eax
 847:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 84a:	72 4d                	jb     899 <malloc+0xa6>
      if(p->s.size == nunits)
 84c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84f:	8b 40 04             	mov    0x4(%eax),%eax
 852:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 855:	75 0c                	jne    863 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 857:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85a:	8b 10                	mov    (%eax),%edx
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	89 10                	mov    %edx,(%eax)
 861:	eb 26                	jmp    889 <malloc+0x96>
      else {
        p->s.size -= nunits;
 863:	8b 45 ec             	mov    -0x14(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	89 c2                	mov    %eax,%edx
 86b:	2b 55 f4             	sub    -0xc(%ebp),%edx
 86e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 871:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 874:	8b 45 ec             	mov    -0x14(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	c1 e0 03             	shl    $0x3,%eax
 87d:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 880:	8b 45 ec             	mov    -0x14(%ebp),%eax
 883:	8b 55 f4             	mov    -0xc(%ebp),%edx
 886:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 891:	8b 45 ec             	mov    -0x14(%ebp),%eax
 894:	83 c0 08             	add    $0x8,%eax
 897:	eb 38                	jmp    8d1 <malloc+0xde>
    }
    if(p == freep)
 899:	a1 a8 0b 00 00       	mov    0xba8,%eax
 89e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8a1:	75 1b                	jne    8be <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 ed fe ff ff       	call   79b <morecore>
 8ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8b5:	75 07                	jne    8be <malloc+0xcb>
        return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb 13                	jmp    8d1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8cc:	e9 70 ff ff ff       	jmp    841 <malloc+0x4e>
}
 8d1:	c9                   	leave  
 8d2:	c3                   	ret    
 8d3:	90                   	nop

000008d4 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8d4:	55                   	push   %ebp
 8d5:	89 e5                	mov    %esp,%ebp
 8d7:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8da:	8b 55 08             	mov    0x8(%ebp),%edx
 8dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8e3:	f0 87 02             	lock xchg %eax,(%edx)
 8e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8ec:	c9                   	leave  
 8ed:	c3                   	ret    

000008ee <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 8ee:	55                   	push   %ebp
 8ef:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8f1:	8b 45 08             	mov    0x8(%ebp),%eax
 8f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 8fa:	5d                   	pop    %ebp
 8fb:	c3                   	ret    

000008fc <lock_acquire>:
void lock_acquire(lock_t *lock){
 8fc:	55                   	push   %ebp
 8fd:	89 e5                	mov    %esp,%ebp
 8ff:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 90c:	00 
 90d:	89 04 24             	mov    %eax,(%esp)
 910:	e8 bf ff ff ff       	call   8d4 <xchg>
 915:	85 c0                	test   %eax,%eax
 917:	75 e9                	jne    902 <lock_acquire+0x6>
}
 919:	c9                   	leave  
 91a:	c3                   	ret    

0000091b <lock_release>:
void lock_release(lock_t *lock){
 91b:	55                   	push   %ebp
 91c:	89 e5                	mov    %esp,%ebp
 91e:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 921:	8b 45 08             	mov    0x8(%ebp),%eax
 924:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 92b:	00 
 92c:	89 04 24             	mov    %eax,(%esp)
 92f:	e8 a0 ff ff ff       	call   8d4 <xchg>
}
 934:	c9                   	leave  
 935:	c3                   	ret    

00000936 <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 936:	55                   	push   %ebp
 937:	89 e5                	mov    %esp,%ebp
 939:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 93c:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 943:	e8 ab fe ff ff       	call   7f3 <malloc>
 948:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 94b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	25 ff 0f 00 00       	and    $0xfff,%eax
 959:	85 c0                	test   %eax,%eax
 95b:	74 15                	je     972 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	89 c2                	mov    %eax,%edx
 962:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 968:	b8 00 10 00 00       	mov    $0x1000,%eax
 96d:	29 d0                	sub    %edx,%eax
 96f:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 976:	75 1b                	jne    993 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 978:	c7 44 24 04 53 0b 00 	movl   $0xb53,0x4(%esp)
 97f:	00 
 980:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 987:	e8 81 fb ff ff       	call   50d <printf>
        return 0;
 98c:	b8 00 00 00 00       	mov    $0x0,%eax
 991:	eb 6f                	jmp    a02 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 996:	8b 55 08             	mov    0x8(%ebp),%edx
 999:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 9a0:	89 54 24 08          	mov    %edx,0x8(%esp)
 9a4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9ab:	00 
 9ac:	89 04 24             	mov    %eax,(%esp)
 9af:	e8 60 fa ff ff       	call   414 <clone>
 9b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 9b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9bb:	79 1b                	jns    9d8 <thread_create+0xa2>
        printf(1,"clone fails\n");
 9bd:	c7 44 24 04 61 0b 00 	movl   $0xb61,0x4(%esp)
 9c4:	00 
 9c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9cc:	e8 3c fb ff ff       	call   50d <printf>
        return 0;
 9d1:	b8 00 00 00 00       	mov    $0x0,%eax
 9d6:	eb 2a                	jmp    a02 <thread_create+0xcc>
    }
    if(tid > 0){
 9d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9dc:	7e 05                	jle    9e3 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	eb 1f                	jmp    a02 <thread_create+0xcc>
    }
    if(tid == 0){
 9e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9e7:	75 14                	jne    9fd <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 9e9:	c7 44 24 04 6e 0b 00 	movl   $0xb6e,0x4(%esp)
 9f0:	00 
 9f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9f8:	e8 10 fb ff ff       	call   50d <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 9fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a02:	c9                   	leave  
 a03:	c3                   	ret    

00000a04 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 a04:	55                   	push   %ebp
 a05:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a1a:	8b 45 08             	mov    0x8(%ebp),%eax
 a1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a24:	5d                   	pop    %ebp
 a25:	c3                   	ret    

00000a26 <add_q>:

void add_q(struct queue *q, int v){
 a26:	55                   	push   %ebp
 a27:	89 e5                	mov    %esp,%ebp
 a29:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a2c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a33:	e8 bb fd ff ff       	call   7f3 <malloc>
 a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8b 55 0c             	mov    0xc(%ebp),%edx
 a4b:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a4d:	8b 45 08             	mov    0x8(%ebp),%eax
 a50:	8b 40 04             	mov    0x4(%eax),%eax
 a53:	85 c0                	test   %eax,%eax
 a55:	75 0b                	jne    a62 <add_q+0x3c>
        q->head = n;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a5d:	89 50 04             	mov    %edx,0x4(%eax)
 a60:	eb 0c                	jmp    a6e <add_q+0x48>
    }else{
        q->tail->next = n;
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	8b 40 08             	mov    0x8(%eax),%eax
 a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a6b:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a6e:	8b 45 08             	mov    0x8(%ebp),%eax
 a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a74:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a77:	8b 45 08             	mov    0x8(%ebp),%eax
 a7a:	8b 00                	mov    (%eax),%eax
 a7c:	8d 50 01             	lea    0x1(%eax),%edx
 a7f:	8b 45 08             	mov    0x8(%ebp),%eax
 a82:	89 10                	mov    %edx,(%eax)
}
 a84:	c9                   	leave  
 a85:	c3                   	ret    

00000a86 <empty_q>:

int empty_q(struct queue *q){
 a86:	55                   	push   %ebp
 a87:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a89:	8b 45 08             	mov    0x8(%ebp),%eax
 a8c:	8b 00                	mov    (%eax),%eax
 a8e:	85 c0                	test   %eax,%eax
 a90:	75 07                	jne    a99 <empty_q+0x13>
        return 1;
 a92:	b8 01 00 00 00       	mov    $0x1,%eax
 a97:	eb 05                	jmp    a9e <empty_q+0x18>
    else
        return 0;
 a99:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 a9e:	5d                   	pop    %ebp
 a9f:	c3                   	ret    

00000aa0 <pop_q>:
int pop_q(struct queue *q){
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 aa6:	8b 45 08             	mov    0x8(%ebp),%eax
 aa9:	89 04 24             	mov    %eax,(%esp)
 aac:	e8 d5 ff ff ff       	call   a86 <empty_q>
 ab1:	85 c0                	test   %eax,%eax
 ab3:	75 5d                	jne    b12 <pop_q+0x72>
       val = q->head->value; 
 ab5:	8b 45 08             	mov    0x8(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	8b 00                	mov    (%eax),%eax
 abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 ac0:	8b 45 08             	mov    0x8(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 ac9:	8b 45 08             	mov    0x8(%ebp),%eax
 acc:	8b 40 04             	mov    0x4(%eax),%eax
 acf:	8b 50 04             	mov    0x4(%eax),%edx
 ad2:	8b 45 08             	mov    0x8(%ebp),%eax
 ad5:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	89 04 24             	mov    %eax,(%esp)
 ade:	e8 e1 fb ff ff       	call   6c4 <free>
       q->size--;
 ae3:	8b 45 08             	mov    0x8(%ebp),%eax
 ae6:	8b 00                	mov    (%eax),%eax
 ae8:	8d 50 ff             	lea    -0x1(%eax),%edx
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 af0:	8b 45 08             	mov    0x8(%ebp),%eax
 af3:	8b 00                	mov    (%eax),%eax
 af5:	85 c0                	test   %eax,%eax
 af7:	75 14                	jne    b0d <pop_q+0x6d>
            q->head = 0;
 af9:	8b 45 08             	mov    0x8(%ebp),%eax
 afc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b10:	eb 05                	jmp    b17 <pop_q+0x77>
    }
    return -1;
 b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b17:	c9                   	leave  
 b18:	c3                   	ret    

00000b19 <front>:

int front(struct queue *q)
{
 b19:	55                   	push   %ebp
 b1a:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 b1c:	8b 45 08             	mov    0x8(%ebp),%eax
 b1f:	8b 40 04             	mov    0x4(%eax),%eax
 b22:	8b 00                	mov    (%eax),%eax
}
 b24:	5d                   	pop    %ebp
 b25:	c3                   	ret    
