
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 31 0b 00 00 	movl   $0xb31,(%esp)
  18:	e8 9f 03 00 00       	call   3bc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 31 0b 00 00 	movl   $0xb31,(%esp)
  38:	e8 87 03 00 00       	call   3c4 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 31 0b 00 00 	movl   $0xb31,(%esp)
  4c:	e8 6b 03 00 00       	call   3bc <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 97 03 00 00       	call   3f4 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 8b 03 00 00       	call   3f4 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 39 0b 00 	movl   $0xb39,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 95 04 00 00       	call   515 <printf>
    pid = fork();
  80:	e8 ef 02 00 00       	call   374 <fork>
  85:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(pid < 0){
  89:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 4c 0b 00 	movl   $0xb4c,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 71 04 00 00       	call   515 <printf>
      exit();
  a4:	e8 d3 02 00 00       	call   37c <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ae:	75 43                	jne    f3 <main+0xf3>
      exec("sh", argv);
  b0:	c7 44 24 04 b4 0b 00 	movl   $0xbb4,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 2e 0b 00 00 	movl   $0xb2e,(%esp)
  bf:	e8 f0 02 00 00       	call   3b4 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 5f 0b 00 	movl   $0xb5f,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 3d 04 00 00       	call   515 <printf>
      exit();
  d8:	e8 9f 02 00 00       	call   37c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 75 0b 00 	movl   $0xb75,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 24 04 00 00       	call   515 <printf>
  f1:	eb 01                	jmp    f4 <main+0xf4>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f3:	90                   	nop
  f4:	e8 8b 02 00 00       	call   384 <wait>
  f9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  fd:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 102:	0f 88 63 ff ff ff    	js     6b <main+0x6b>
 108:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10c:	3b 44 24 18          	cmp    0x18(%esp),%eax
 110:	75 cb                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 112:	e9 55 ff ff ff       	jmp    6c <main+0x6c>
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 10             	movzbl (%eax),%edx
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	88 10                	mov    %dl,(%eax)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	0f 95 c0             	setne  %al
 15f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 163:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 167:	84 c0                	test   %al,%al
 169:	75 de                	jne    149 <strcpy+0xc>
    ;
  return os;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 173:	eb 08                	jmp    17d <strcmp+0xd>
    p++, q++;
 175:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 179:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	74 10                	je     197 <strcmp+0x27>
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	38 c2                	cmp    %al,%dl
 195:	74 de                	je     175 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 d0             	movzbl %al,%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	89 d1                	mov    %edx,%ecx
 1ab:	29 c1                	sub    %eax,%ecx
 1ad:	89 c8                	mov    %ecx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 ef                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 23 ff ff ff       	call   118 <stosb>
  return dst;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 206:	eb 14                	jmp    21c <strchr+0x22>
    if(*s == c)
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 211:	75 05                	jne    218 <strchr+0x1e>
      return (char*)s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	eb 13                	jmp    22b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	84 c0                	test   %al,%al
 224:	75 e2                	jne    208 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 226:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <gets>:

char*
gets(char *buf, int max)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 233:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 23a:	eb 44                	jmp    280 <gets+0x53>
    cc = read(0, &c, 1);
 23c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 243:	00 
 244:	8d 45 ef             	lea    -0x11(%ebp),%eax
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 252:	e8 3d 01 00 00       	call   394 <read>
 257:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 25a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25e:	7e 2d                	jle    28d <gets+0x60>
      break;
    buf[i++] = c;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	03 45 08             	add    0x8(%ebp),%eax
 266:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26a:	88 10                	mov    %dl,(%eax)
 26c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0a                	cmp    $0xa,%al
 276:	74 16                	je     28e <gets+0x61>
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	3c 0d                	cmp    $0xd,%al
 27e:	74 0e                	je     28e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	8b 45 f0             	mov    -0x10(%ebp),%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	3b 45 0c             	cmp    0xc(%ebp),%eax
 289:	7c b1                	jl     23c <gets+0xf>
 28b:	eb 01                	jmp    28e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 291:	03 45 08             	add    0x8(%ebp),%eax
 294:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <stat>:

int
stat(char *n, struct stat *st)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 07 01 00 00       	call   3bc <open>
 2b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bc:	79 07                	jns    2c5 <stat+0x29>
    return -1;
 2be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c3:	eb 23                	jmp    2e8 <stat+0x4c>
  r = fstat(fd, st);
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	89 04 24             	mov    %eax,(%esp)
 2d2:	e8 fd 00 00 00       	call   3d4 <fstat>
 2d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2dd:	89 04 24             	mov    %eax,(%esp)
 2e0:	e8 bf 00 00 00       	call   3a4 <close>
  return r;
 2e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f7:	eb 24                	jmp    31d <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 02             	shl    $0x2,%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 c0                	add    %eax,%eax
 305:	89 c2                	mov    %eax,%edx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	8d 04 02             	lea    (%edx,%eax,1),%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x47>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c8                	jle    2f9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 348:	eb 13                	jmp    35d <memmove+0x27>
    *dst++ = *src++;
 34a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 359:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    
 371:	90                   	nop
 372:	90                   	nop
 373:	90                   	nop

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <clone>:
SYSCALL(clone)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <texit>:
SYSCALL(texit)
 424:	b8 17 00 00 00       	mov    $0x17,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <tsleep>:
SYSCALL(tsleep)
 42c:	b8 18 00 00 00       	mov    $0x18,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <twakeup>:
SYSCALL(twakeup)
 434:	b8 19 00 00 00       	mov    $0x19,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 28             	sub    $0x28,%esp
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 448:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44f:	00 
 450:	8d 45 f4             	lea    -0xc(%ebp),%eax
 453:	89 44 24 04          	mov    %eax,0x4(%esp)
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	89 04 24             	mov    %eax,(%esp)
 45d:	e8 3a ff ff ff       	call   39c <write>
}
 462:	c9                   	leave  
 463:	c3                   	ret    

00000464 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	53                   	push   %ebx
 468:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 472:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 476:	74 17                	je     48f <printint+0x2b>
 478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47c:	79 11                	jns    48f <printint+0x2b>
    neg = 1;
 47e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	f7 d8                	neg    %eax
 48a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48d:	eb 06                	jmp    495 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48f:	8b 45 0c             	mov    0xc(%ebp),%eax
 492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 495:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 49c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 49f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a5:	ba 00 00 00 00       	mov    $0x0,%edx
 4aa:	f7 f3                	div    %ebx
 4ac:	89 d0                	mov    %edx,%eax
 4ae:	0f b6 80 bc 0b 00 00 	movzbl 0xbbc(%eax),%eax
 4b5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4b9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4bd:	8b 45 10             	mov    0x10(%ebp),%eax
 4c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c6:	ba 00 00 00 00       	mov    $0x0,%edx
 4cb:	f7 75 d4             	divl   -0x2c(%ebp)
 4ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d5:	75 c5                	jne    49c <printint+0x38>
  if(neg)
 4d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4db:	74 28                	je     505 <printint+0xa1>
    buf[i++] = '-';
 4dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4e9:	eb 1a                	jmp    505 <printint+0xa1>
    putc(fd, buf[i]);
 4eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ee:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4f3:	0f be c0             	movsbl %al,%eax
 4f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	89 04 24             	mov    %eax,(%esp)
 500:	e8 37 ff ff ff       	call   43c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 505:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50d:	79 dc                	jns    4eb <printint+0x87>
    putc(fd, buf[i]);
}
 50f:	83 c4 44             	add    $0x44,%esp
 512:	5b                   	pop    %ebx
 513:	5d                   	pop    %ebp
 514:	c3                   	ret    

00000515 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 515:	55                   	push   %ebp
 516:	89 e5                	mov    %esp,%ebp
 518:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 51b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 522:	8d 45 0c             	lea    0xc(%ebp),%eax
 525:	83 c0 04             	add    $0x4,%eax
 528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 52b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 532:	e9 7e 01 00 00       	jmp    6b5 <printf+0x1a0>
    c = fmt[i] & 0xff;
 537:	8b 55 0c             	mov    0xc(%ebp),%edx
 53a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	25 ff 00 00 00       	and    $0xff,%eax
 54b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 54e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 552:	75 2c                	jne    580 <printf+0x6b>
      if(c == '%'){
 554:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 558:	75 0c                	jne    566 <printf+0x51>
        state = '%';
 55a:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 561:	e9 4b 01 00 00       	jmp    6b1 <printf+0x19c>
      } else {
        putc(fd, c);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	89 44 24 04          	mov    %eax,0x4(%esp)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	89 04 24             	mov    %eax,(%esp)
 576:	e8 c1 fe ff ff       	call   43c <putc>
 57b:	e9 31 01 00 00       	jmp    6b1 <printf+0x19c>
      }
    } else if(state == '%'){
 580:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 584:	0f 85 27 01 00 00    	jne    6b1 <printf+0x19c>
      if(c == 'd'){
 58a:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 58e:	75 2d                	jne    5bd <printf+0xa8>
        printint(fd, *ap, 10, 1);
 590:	8b 45 f4             	mov    -0xc(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 59c:	00 
 59d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5a4:	00 
 5a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	89 04 24             	mov    %eax,(%esp)
 5af:	e8 b0 fe ff ff       	call   464 <printint>
        ap++;
 5b4:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5b8:	e9 ed 00 00 00       	jmp    6aa <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5bd:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5c1:	74 06                	je     5c9 <printf+0xb4>
 5c3:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5c7:	75 2d                	jne    5f6 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5d5:	00 
 5d6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5dd:	00 
 5de:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	89 04 24             	mov    %eax,(%esp)
 5e8:	e8 77 fe ff ff       	call   464 <printint>
        ap++;
 5ed:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5f1:	e9 b4 00 00 00       	jmp    6aa <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5f6:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5fa:	75 46                	jne    642 <printf+0x12d>
        s = (char*)*ap;
 5fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 604:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 60c:	75 27                	jne    635 <printf+0x120>
          s = "(null)";
 60e:	c7 45 e4 7e 0b 00 00 	movl   $0xb7e,-0x1c(%ebp)
        while(*s != 0){
 615:	eb 1f                	jmp    636 <printf+0x121>
          putc(fd, *s);
 617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	89 44 24 04          	mov    %eax,0x4(%esp)
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	89 04 24             	mov    %eax,(%esp)
 62a:	e8 0d fe ff ff       	call   43c <putc>
          s++;
 62f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 633:	eb 01                	jmp    636 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 635:	90                   	nop
 636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	84 c0                	test   %al,%al
 63e:	75 d7                	jne    617 <printf+0x102>
 640:	eb 68                	jmp    6aa <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 642:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 646:	75 1d                	jne    665 <printf+0x150>
        putc(fd, *ap);
 648:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	0f be c0             	movsbl %al,%eax
 650:	89 44 24 04          	mov    %eax,0x4(%esp)
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	89 04 24             	mov    %eax,(%esp)
 65a:	e8 dd fd ff ff       	call   43c <putc>
        ap++;
 65f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 663:	eb 45                	jmp    6aa <printf+0x195>
      } else if(c == '%'){
 665:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 669:	75 17                	jne    682 <printf+0x16d>
        putc(fd, c);
 66b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	89 44 24 04          	mov    %eax,0x4(%esp)
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 bc fd ff ff       	call   43c <putc>
 680:	eb 28                	jmp    6aa <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 682:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 689:	00 
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	89 04 24             	mov    %eax,(%esp)
 690:	e8 a7 fd ff ff       	call   43c <putc>
        putc(fd, c);
 695:	8b 45 e8             	mov    -0x18(%ebp),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	89 44 24 04          	mov    %eax,0x4(%esp)
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	89 04 24             	mov    %eax,(%esp)
 6a5:	e8 92 fd ff ff       	call   43c <putc>
      }
      state = 0;
 6aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6bb:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	0f 85 6e fe ff ff    	jne    537 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    
 6cb:	90                   	nop

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	c1 e0 03             	shl    $0x3,%eax
 724:	89 c2                	mov    %eax,%edx
 726:	03 55 f8             	add    -0x8(%ebp),%edx
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	39 c2                	cmp    %eax,%edx
 730:	75 24                	jne    756 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	8b 50 04             	mov    0x4(%eax),%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	8b 40 04             	mov    0x4(%eax),%eax
 740:	01 c2                	add    %eax,%edx
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	8b 10                	mov    (%eax),%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 10                	mov    %edx,(%eax)
 754:	eb 0a                	jmp    760 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 10                	mov    (%eax),%edx
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	c1 e0 03             	shl    $0x3,%eax
 769:	03 45 fc             	add    -0x4(%ebp),%eax
 76c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76f:	75 20                	jne    791 <free+0xc5>
    p->s.size += bp->s.size;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 50 04             	mov    0x4(%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
 78f:	eb 08                	jmp    799 <free+0xcd>
  } else
    p->s.ptr = bp;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 55 f8             	mov    -0x8(%ebp),%edx
 797:	89 10                	mov    %edx,(%eax)
  freep = p;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	a3 d8 0b 00 00       	mov    %eax,0xbd8
}
 7a1:	c9                   	leave  
 7a2:	c3                   	ret    

000007a3 <morecore>:

static Header*
morecore(uint nu)
{
 7a3:	55                   	push   %ebp
 7a4:	89 e5                	mov    %esp,%ebp
 7a6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b0:	77 07                	ja     7b9 <morecore+0x16>
    nu = 4096;
 7b2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	c1 e0 03             	shl    $0x3,%eax
 7bf:	89 04 24             	mov    %eax,(%esp)
 7c2:	e8 3d fc ff ff       	call   404 <sbrk>
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7ca:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7ce:	75 07                	jne    7d7 <morecore+0x34>
    return 0;
 7d0:	b8 00 00 00 00       	mov    $0x0,%eax
 7d5:	eb 22                	jmp    7f9 <morecore+0x56>
  hp = (Header*)p;
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 55 08             	mov    0x8(%ebp),%edx
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	83 c0 08             	add    $0x8,%eax
 7ec:	89 04 24             	mov    %eax,(%esp)
 7ef:	e8 d8 fe ff ff       	call   6cc <free>
  return freep;
 7f4:	a1 d8 0b 00 00       	mov    0xbd8,%eax
}
 7f9:	c9                   	leave  
 7fa:	c3                   	ret    

000007fb <malloc>:

void*
malloc(uint nbytes)
{
 7fb:	55                   	push   %ebp
 7fc:	89 e5                	mov    %esp,%ebp
 7fe:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	83 c0 07             	add    $0x7,%eax
 807:	c1 e8 03             	shr    $0x3,%eax
 80a:	83 c0 01             	add    $0x1,%eax
 80d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 810:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 815:	89 45 f0             	mov    %eax,-0x10(%ebp)
 818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81c:	75 23                	jne    841 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81e:	c7 45 f0 d0 0b 00 00 	movl   $0xbd0,-0x10(%ebp)
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	a3 d8 0b 00 00       	mov    %eax,0xbd8
 82d:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 832:	a3 d0 0b 00 00       	mov    %eax,0xbd0
    base.s.size = 0;
 837:	c7 05 d4 0b 00 00 00 	movl   $0x0,0xbd4
 83e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 841:	8b 45 f0             	mov    -0x10(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 849:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 852:	72 4d                	jb     8a1 <malloc+0xa6>
      if(p->s.size == nunits)
 854:	8b 45 ec             	mov    -0x14(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 85d:	75 0c                	jne    86b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 862:	8b 10                	mov    (%eax),%edx
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	89 10                	mov    %edx,(%eax)
 869:	eb 26                	jmp    891 <malloc+0x96>
      else {
        p->s.size -= nunits;
 86b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	89 c2                	mov    %eax,%edx
 873:	2b 55 f4             	sub    -0xc(%ebp),%edx
 876:	8b 45 ec             	mov    -0x14(%ebp),%eax
 879:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	c1 e0 03             	shl    $0x3,%eax
 885:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 888:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 88e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	a3 d8 0b 00 00       	mov    %eax,0xbd8
      return (void*)(p + 1);
 899:	8b 45 ec             	mov    -0x14(%ebp),%eax
 89c:	83 c0 08             	add    $0x8,%eax
 89f:	eb 38                	jmp    8d9 <malloc+0xde>
    }
    if(p == freep)
 8a1:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 8a6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8a9:	75 1b                	jne    8c6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	89 04 24             	mov    %eax,(%esp)
 8b1:	e8 ed fe ff ff       	call   7a3 <morecore>
 8b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8bd:	75 07                	jne    8c6 <malloc+0xcb>
        return 0;
 8bf:	b8 00 00 00 00       	mov    $0x0,%eax
 8c4:	eb 13                	jmp    8d9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d4:	e9 70 ff ff ff       	jmp    849 <malloc+0x4e>
}
 8d9:	c9                   	leave  
 8da:	c3                   	ret    
 8db:	90                   	nop

000008dc <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 8dc:	55                   	push   %ebp
 8dd:	89 e5                	mov    %esp,%ebp
 8df:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 8e2:	8b 55 08             	mov    0x8(%ebp),%edx
 8e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8eb:	f0 87 02             	lock xchg %eax,(%edx)
 8ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8f4:	c9                   	leave  
 8f5:	c3                   	ret    

000008f6 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 8f6:	55                   	push   %ebp
 8f7:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
 8fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 902:	5d                   	pop    %ebp
 903:	c3                   	ret    

00000904 <lock_acquire>:
void lock_acquire(lock_t *lock){
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 90a:	8b 45 08             	mov    0x8(%ebp),%eax
 90d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 914:	00 
 915:	89 04 24             	mov    %eax,(%esp)
 918:	e8 bf ff ff ff       	call   8dc <xchg>
 91d:	85 c0                	test   %eax,%eax
 91f:	75 e9                	jne    90a <lock_acquire+0x6>
}
 921:	c9                   	leave  
 922:	c3                   	ret    

00000923 <lock_release>:
void lock_release(lock_t *lock){
 923:	55                   	push   %ebp
 924:	89 e5                	mov    %esp,%ebp
 926:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 929:	8b 45 08             	mov    0x8(%ebp),%eax
 92c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 933:	00 
 934:	89 04 24             	mov    %eax,(%esp)
 937:	e8 a0 ff ff ff       	call   8dc <xchg>
}
 93c:	c9                   	leave  
 93d:	c3                   	ret    

0000093e <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 93e:	55                   	push   %ebp
 93f:	89 e5                	mov    %esp,%ebp
 941:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 944:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 94b:	e8 ab fe ff ff       	call   7fb <malloc>
 950:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 953:	8b 45 f0             	mov    -0x10(%ebp),%eax
 956:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 959:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95c:	25 ff 0f 00 00       	and    $0xfff,%eax
 961:	85 c0                	test   %eax,%eax
 963:	74 15                	je     97a <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	89 c2                	mov    %eax,%edx
 96a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 970:	b8 00 10 00 00       	mov    $0x1000,%eax
 975:	29 d0                	sub    %edx,%eax
 977:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 97a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 97e:	75 1b                	jne    99b <thread_create+0x5d>

        printf(1,"malloc fail \n");
 980:	c7 44 24 04 85 0b 00 	movl   $0xb85,0x4(%esp)
 987:	00 
 988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 98f:	e8 81 fb ff ff       	call   515 <printf>
        return 0;
 994:	b8 00 00 00 00       	mov    $0x0,%eax
 999:	eb 6f                	jmp    a0a <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 99b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 99e:	8b 55 08             	mov    0x8(%ebp),%edx
 9a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 9a8:	89 54 24 08          	mov    %edx,0x8(%esp)
 9ac:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 9b3:	00 
 9b4:	89 04 24             	mov    %eax,(%esp)
 9b7:	e8 60 fa ff ff       	call   41c <clone>
 9bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 9bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9c3:	79 1b                	jns    9e0 <thread_create+0xa2>
        printf(1,"clone fails\n");
 9c5:	c7 44 24 04 93 0b 00 	movl   $0xb93,0x4(%esp)
 9cc:	00 
 9cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9d4:	e8 3c fb ff ff       	call   515 <printf>
        return 0;
 9d9:	b8 00 00 00 00       	mov    $0x0,%eax
 9de:	eb 2a                	jmp    a0a <thread_create+0xcc>
    }
    if(tid > 0){
 9e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9e4:	7e 05                	jle    9eb <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 9e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e9:	eb 1f                	jmp    a0a <thread_create+0xcc>
    }
    if(tid == 0){
 9eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9ef:	75 14                	jne    a05 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 9f1:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
 9f8:	00 
 9f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a00:	e8 10 fb ff ff       	call   515 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a0a:	c9                   	leave  
 a0b:	c3                   	ret    

00000a0c <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 a0c:	55                   	push   %ebp
 a0d:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 a0f:	8b 45 08             	mov    0x8(%ebp),%eax
 a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 a18:	8b 45 08             	mov    0x8(%ebp),%eax
 a1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 a22:	8b 45 08             	mov    0x8(%ebp),%eax
 a25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 a2c:	5d                   	pop    %ebp
 a2d:	c3                   	ret    

00000a2e <add_q>:

void add_q(struct queue *q, int v){
 a2e:	55                   	push   %ebp
 a2f:	89 e5                	mov    %esp,%ebp
 a31:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 a34:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 a3b:	e8 bb fd ff ff       	call   7fb <malloc>
 a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 55 0c             	mov    0xc(%ebp),%edx
 a53:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 a55:	8b 45 08             	mov    0x8(%ebp),%eax
 a58:	8b 40 04             	mov    0x4(%eax),%eax
 a5b:	85 c0                	test   %eax,%eax
 a5d:	75 0b                	jne    a6a <add_q+0x3c>
        q->head = n;
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a65:	89 50 04             	mov    %edx,0x4(%eax)
 a68:	eb 0c                	jmp    a76 <add_q+0x48>
    }else{
        q->tail->next = n;
 a6a:	8b 45 08             	mov    0x8(%ebp),%eax
 a6d:	8b 40 08             	mov    0x8(%eax),%eax
 a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a73:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 a76:	8b 45 08             	mov    0x8(%ebp),%eax
 a79:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a7c:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 a7f:	8b 45 08             	mov    0x8(%ebp),%eax
 a82:	8b 00                	mov    (%eax),%eax
 a84:	8d 50 01             	lea    0x1(%eax),%edx
 a87:	8b 45 08             	mov    0x8(%ebp),%eax
 a8a:	89 10                	mov    %edx,(%eax)
}
 a8c:	c9                   	leave  
 a8d:	c3                   	ret    

00000a8e <empty_q>:

int empty_q(struct queue *q){
 a8e:	55                   	push   %ebp
 a8f:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 a91:	8b 45 08             	mov    0x8(%ebp),%eax
 a94:	8b 00                	mov    (%eax),%eax
 a96:	85 c0                	test   %eax,%eax
 a98:	75 07                	jne    aa1 <empty_q+0x13>
        return 1;
 a9a:	b8 01 00 00 00       	mov    $0x1,%eax
 a9f:	eb 05                	jmp    aa6 <empty_q+0x18>
    else
        return 0;
 aa1:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 aa6:	5d                   	pop    %ebp
 aa7:	c3                   	ret    

00000aa8 <pop_q>:
int pop_q(struct queue *q){
 aa8:	55                   	push   %ebp
 aa9:	89 e5                	mov    %esp,%ebp
 aab:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 aae:	8b 45 08             	mov    0x8(%ebp),%eax
 ab1:	89 04 24             	mov    %eax,(%esp)
 ab4:	e8 d5 ff ff ff       	call   a8e <empty_q>
 ab9:	85 c0                	test   %eax,%eax
 abb:	75 5d                	jne    b1a <pop_q+0x72>
       val = q->head->value; 
 abd:	8b 45 08             	mov    0x8(%ebp),%eax
 ac0:	8b 40 04             	mov    0x4(%eax),%eax
 ac3:	8b 00                	mov    (%eax),%eax
 ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 ac8:	8b 45 08             	mov    0x8(%ebp),%eax
 acb:	8b 40 04             	mov    0x4(%eax),%eax
 ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 ad1:	8b 45 08             	mov    0x8(%ebp),%eax
 ad4:	8b 40 04             	mov    0x4(%eax),%eax
 ad7:	8b 50 04             	mov    0x4(%eax),%edx
 ada:	8b 45 08             	mov    0x8(%ebp),%eax
 add:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae3:	89 04 24             	mov    %eax,(%esp)
 ae6:	e8 e1 fb ff ff       	call   6cc <free>
       q->size--;
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	8b 00                	mov    (%eax),%eax
 af0:	8d 50 ff             	lea    -0x1(%eax),%edx
 af3:	8b 45 08             	mov    0x8(%ebp),%eax
 af6:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 af8:	8b 45 08             	mov    0x8(%ebp),%eax
 afb:	8b 00                	mov    (%eax),%eax
 afd:	85 c0                	test   %eax,%eax
 aff:	75 14                	jne    b15 <pop_q+0x6d>
            q->head = 0;
 b01:	8b 45 08             	mov    0x8(%ebp),%eax
 b04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 b0b:	8b 45 08             	mov    0x8(%ebp),%eax
 b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b18:	eb 05                	jmp    b1f <pop_q+0x77>
    }
    return -1;
 b1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b1f:	c9                   	leave  
 b20:	c3                   	ret    

00000b21 <front>:

int front(struct queue *q)
{
 b21:	55                   	push   %ebp
 b22:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 b24:	8b 45 08             	mov    0x8(%ebp),%eax
 b27:	8b 40 04             	mov    0x4(%eax),%eax
 b2a:	8b 00                	mov    (%eax),%eax
}
 b2c:	5d                   	pop    %ebp
 b2d:	c3                   	ret    
