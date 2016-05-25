
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
   d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  inword = 0;
  19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 66                	jmp    88 <wc+0x88>
    for(i=0; i<n; i++){
  22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  29:	eb 55                	jmp    80 <wc+0x80>
      c++;
  2b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  32:	0f b6 80 80 0c 00 00 	movzbl 0xc80(%eax),%eax
  39:	3c 0a                	cmp    $0xa,%al
  3b:	75 04                	jne    41 <wc+0x41>
        l++;
  3d:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  44:	0f b6 80 80 0c 00 00 	movzbl 0xc80(%eax),%eax
  4b:	0f be c0             	movsbl %al,%eax
  4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  52:	c7 04 24 da 0b 00 00 	movl   $0xbda,(%esp)
  59:	e8 48 02 00 00       	call   2a6 <strchr>
  5e:	85 c0                	test   %eax,%eax
  60:	74 09                	je     6b <wc+0x6b>
        inword = 0;
  62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  69:	eb 11                	jmp    7c <wc+0x7c>
      else if(!inword){
  6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  6f:	75 0b                	jne    7c <wc+0x7c>
        w++;
  71:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  75:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  83:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  86:	7c a3                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8f:	00 
  90:	c7 44 24 04 80 0c 00 	movl   $0xc80,0x4(%esp)
  97:	00 
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 9d 03 00 00       	call   440 <read>
  a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  b4:	79 19                	jns    cf <wc+0xcf>
    printf(1, "wc: read error\n");
  b6:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
  bd:	00 
  be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c5:	e8 f7 04 00 00       	call   5c1 <printf>
    exit();
  ca:	e8 59 03 00 00       	call   428 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 44 24 14          	mov    %eax,0x14(%esp)
  d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	c7 44 24 04 f0 0b 00 	movl   $0xbf0,0x4(%esp)
  f2:	00 
  f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fa:	e8 c2 04 00 00       	call   5c1 <printf>
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <main>:

int
main(int argc, char *argv[])
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 e4 f0             	and    $0xfffffff0,%esp
 107:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10e:	7f 19                	jg     129 <main+0x28>
    wc(0, "");
 110:	c7 44 24 04 fd 0b 00 	movl   $0xbfd,0x4(%esp)
 117:	00 
 118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11f:	e8 dc fe ff ff       	call   0 <wc>
    exit();
 124:	e8 ff 02 00 00       	call   428 <exit>
  }

  for(i = 1; i < argc; i++){
 129:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 130:	00 
 131:	eb 7d                	jmp    1b0 <main+0xaf>
    if((fd = open(argv[i], 0)) < 0){
 133:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 137:	c1 e0 02             	shl    $0x2,%eax
 13a:	03 45 0c             	add    0xc(%ebp),%eax
 13d:	8b 00                	mov    (%eax),%eax
 13f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 146:	00 
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 19 03 00 00       	call   468 <open>
 14f:	89 44 24 18          	mov    %eax,0x18(%esp)
 153:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 158:	79 29                	jns    183 <main+0x82>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15e:	c1 e0 02             	shl    $0x2,%eax
 161:	03 45 0c             	add    0xc(%ebp),%eax
 164:	8b 00                	mov    (%eax),%eax
 166:	89 44 24 08          	mov    %eax,0x8(%esp)
 16a:	c7 44 24 04 fe 0b 00 	movl   $0xbfe,0x4(%esp)
 171:	00 
 172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 179:	e8 43 04 00 00       	call   5c1 <printf>
      exit();
 17e:	e8 a5 02 00 00       	call   428 <exit>
    }
    wc(fd, argv[i]);
 183:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 187:	c1 e0 02             	shl    $0x2,%eax
 18a:	03 45 0c             	add    0xc(%ebp),%eax
 18d:	8b 00                	mov    (%eax),%eax
 18f:	89 44 24 04          	mov    %eax,0x4(%esp)
 193:	8b 44 24 18          	mov    0x18(%esp),%eax
 197:	89 04 24             	mov    %eax,(%esp)
 19a:	e8 61 fe ff ff       	call   0 <wc>
    close(fd);
 19f:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 a5 02 00 00       	call   450 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1ab:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1b4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1b7:	0f 8c 76 ff ff ff    	jl     133 <main+0x32>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1bd:	e8 66 02 00 00       	call   428 <exit>
 1c2:	90                   	nop
 1c3:	90                   	nop

000001c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	89 cb                	mov    %ecx,%ebx
 1d4:	89 df                	mov    %ebx,%edi
 1d6:	89 d1                	mov    %edx,%ecx
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
 1db:	89 ca                	mov    %ecx,%edx
 1dd:	89 fb                	mov    %edi,%ebx
 1df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e5:	5b                   	pop    %ebx
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	0f b6 10             	movzbl (%eax),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	88 10                	mov    %dl,(%eax)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	0f 95 c0             	setne  %al
 20b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 213:	84 c0                	test   %al,%al
 215:	75 de                	jne    1f5 <strcpy+0xc>
    ;
  return os;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21f:	eb 08                	jmp    229 <strcmp+0xd>
    p++, q++;
 221:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 225:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	84 c0                	test   %al,%al
 231:	74 10                	je     243 <strcmp+0x27>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 10             	movzbl (%eax),%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	38 c2                	cmp    %al,%dl
 241:	74 de                	je     221 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 d0             	movzbl %al,%edx
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	0f b6 c0             	movzbl %al,%eax
 255:	89 d1                	mov    %edx,%ecx
 257:	29 c1                	sub    %eax,%ecx
 259:	89 c8                	mov    %ecx,%eax
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    

0000025d <strlen>:

uint
strlen(char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26a:	eb 04                	jmp    270 <strlen+0x13>
 26c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 273:	03 45 08             	add    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	84 c0                	test   %al,%al
 27b:	75 ef                	jne    26c <strlen+0xf>
    ;
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memset>:

void*
memset(void *dst, int c, uint n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	89 44 24 08          	mov    %eax,0x8(%esp)
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 44 24 04          	mov    %eax,0x4(%esp)
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	89 04 24             	mov    %eax,(%esp)
 29c:	e8 23 ff ff ff       	call   1c4 <stosb>
  return dst;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <strchr>:

char*
strchr(const char *s, char c)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 04             	sub    $0x4,%esp
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b2:	eb 14                	jmp    2c8 <strchr+0x22>
    if(*s == c)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2bd:	75 05                	jne    2c4 <strchr+0x1e>
      return (char*)s;
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	eb 13                	jmp    2d7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	84 c0                	test   %al,%al
 2d0:	75 e2                	jne    2b4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <gets>:

char*
gets(char *buf, int max)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2e6:	eb 44                	jmp    32c <gets+0x53>
    cc = read(0, &c, 1);
 2e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ef:	00 
 2f0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fe:	e8 3d 01 00 00       	call   440 <read>
 303:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30a:	7e 2d                	jle    339 <gets+0x60>
      break;
    buf[i++] = c;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30f:	03 45 08             	add    0x8(%ebp),%eax
 312:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 316:	88 10                	mov    %dl,(%eax)
 318:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 31c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 320:	3c 0a                	cmp    $0xa,%al
 322:	74 16                	je     33a <gets+0x61>
 324:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 328:	3c 0d                	cmp    $0xd,%al
 32a:	74 0e                	je     33a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 32f:	83 c0 01             	add    $0x1,%eax
 332:	3b 45 0c             	cmp    0xc(%ebp),%eax
 335:	7c b1                	jl     2e8 <gets+0xf>
 337:	eb 01                	jmp    33a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 339:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 33d:	03 45 08             	add    0x8(%ebp),%eax
 340:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <stat>:

int
stat(char *n, struct stat *st)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 355:	00 
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	89 04 24             	mov    %eax,(%esp)
 35c:	e8 07 01 00 00       	call   468 <open>
 361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 364:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 368:	79 07                	jns    371 <stat+0x29>
    return -1;
 36a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36f:	eb 23                	jmp    394 <stat+0x4c>
  r = fstat(fd, st);
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 44 24 04          	mov    %eax,0x4(%esp)
 378:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37b:	89 04 24             	mov    %eax,(%esp)
 37e:	e8 fd 00 00 00       	call   480 <fstat>
 383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 386:	8b 45 f0             	mov    -0x10(%ebp),%eax
 389:	89 04 24             	mov    %eax,(%esp)
 38c:	e8 bf 00 00 00       	call   450 <close>
  return r;
 391:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <atoi>:

int
atoi(const char *s)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a3:	eb 24                	jmp    3c9 <atoi+0x33>
    n = n*10 + *s++ - '0';
 3a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	c1 e0 02             	shl    $0x2,%eax
 3ad:	01 d0                	add    %edx,%eax
 3af:	01 c0                	add    %eax,%eax
 3b1:	89 c2                	mov    %eax,%edx
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f be c0             	movsbl %al,%eax
 3bc:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3bf:	83 e8 30             	sub    $0x30,%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoi+0x47>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 39                	cmp    $0x39,%al
 3db:	7e c8                	jle    3a5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3f4:	eb 13                	jmp    409 <memmove+0x27>
    *dst++ = *src++;
 3f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f9:	0f b6 10             	movzbl (%eax),%edx
 3fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ff:	88 10                	mov    %dl,(%eax)
 401:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 405:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 409:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40d:	0f 9f c0             	setg   %al
 410:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 414:	84 c0                	test   %al,%al
 416:	75 de                	jne    3f6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 418:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41b:	c9                   	leave  
 41c:	c3                   	ret    
 41d:	90                   	nop
 41e:	90                   	nop
 41f:	90                   	nop

00000420 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 420:	b8 01 00 00 00       	mov    $0x1,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <exit>:
SYSCALL(exit)
 428:	b8 02 00 00 00       	mov    $0x2,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <wait>:
SYSCALL(wait)
 430:	b8 03 00 00 00       	mov    $0x3,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <pipe>:
SYSCALL(pipe)
 438:	b8 04 00 00 00       	mov    $0x4,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <read>:
SYSCALL(read)
 440:	b8 05 00 00 00       	mov    $0x5,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <write>:
SYSCALL(write)
 448:	b8 10 00 00 00       	mov    $0x10,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <close>:
SYSCALL(close)
 450:	b8 15 00 00 00       	mov    $0x15,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <kill>:
SYSCALL(kill)
 458:	b8 06 00 00 00       	mov    $0x6,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <exec>:
SYSCALL(exec)
 460:	b8 07 00 00 00       	mov    $0x7,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <open>:
SYSCALL(open)
 468:	b8 0f 00 00 00       	mov    $0xf,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <mknod>:
SYSCALL(mknod)
 470:	b8 11 00 00 00       	mov    $0x11,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <unlink>:
SYSCALL(unlink)
 478:	b8 12 00 00 00       	mov    $0x12,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <fstat>:
SYSCALL(fstat)
 480:	b8 08 00 00 00       	mov    $0x8,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <link>:
SYSCALL(link)
 488:	b8 13 00 00 00       	mov    $0x13,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <mkdir>:
SYSCALL(mkdir)
 490:	b8 14 00 00 00       	mov    $0x14,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <chdir>:
SYSCALL(chdir)
 498:	b8 09 00 00 00       	mov    $0x9,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <dup>:
SYSCALL(dup)
 4a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <getpid>:
SYSCALL(getpid)
 4a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <sbrk>:
SYSCALL(sbrk)
 4b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <sleep>:
SYSCALL(sleep)
 4b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <uptime>:
SYSCALL(uptime)
 4c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <clone>:
SYSCALL(clone)
 4c8:	b8 16 00 00 00       	mov    $0x16,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <texit>:
SYSCALL(texit)
 4d0:	b8 17 00 00 00       	mov    $0x17,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <tsleep>:
SYSCALL(tsleep)
 4d8:	b8 18 00 00 00       	mov    $0x18,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <twakeup>:
SYSCALL(twakeup)
 4e0:	b8 19 00 00 00       	mov    $0x19,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 28             	sub    $0x28,%esp
 4ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4fb:	00 
 4fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 3a ff ff ff       	call   448 <write>
}
 50e:	c9                   	leave  
 50f:	c3                   	ret    

00000510 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 517:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 522:	74 17                	je     53b <printint+0x2b>
 524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 528:	79 11                	jns    53b <printint+0x2b>
    neg = 1;
 52a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	f7 d8                	neg    %eax
 536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 539:	eb 06                	jmp    541 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53b:	8b 45 0c             	mov    0xc(%ebp),%eax
 53e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 548:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 54b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	ba 00 00 00 00       	mov    $0x0,%edx
 556:	f7 f3                	div    %ebx
 558:	89 d0                	mov    %edx,%eax
 55a:	0f b6 80 48 0c 00 00 	movzbl 0xc48(%eax),%eax
 561:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 565:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 569:	8b 45 10             	mov    0x10(%ebp),%eax
 56c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	ba 00 00 00 00       	mov    $0x0,%edx
 577:	f7 75 d4             	divl   -0x2c(%ebp)
 57a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 57d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 581:	75 c5                	jne    548 <printint+0x38>
  if(neg)
 583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 587:	74 28                	je     5b1 <printint+0xa1>
    buf[i++] = '-';
 589:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 591:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 595:	eb 1a                	jmp    5b1 <printint+0xa1>
    putc(fd, buf[i]);
 597:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	89 04 24             	mov    %eax,(%esp)
 5ac:	e8 37 ff ff ff       	call   4e8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b1:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 5b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b9:	79 dc                	jns    597 <printint+0x87>
    putc(fd, buf[i]);
}
 5bb:	83 c4 44             	add    $0x44,%esp
 5be:	5b                   	pop    %ebx
 5bf:	5d                   	pop    %ebp
 5c0:	c3                   	ret    

000005c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d1:	83 c0 04             	add    $0x4,%eax
 5d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5de:	e9 7e 01 00 00       	jmp    761 <printf+0x1a0>
    c = fmt[i] & 0xff;
 5e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e9:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5ec:	0f b6 00             	movzbl (%eax),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	25 ff 00 00 00       	and    $0xff,%eax
 5f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5fe:	75 2c                	jne    62c <printf+0x6b>
      if(c == '%'){
 600:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 604:	75 0c                	jne    612 <printf+0x51>
        state = '%';
 606:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 60d:	e9 4b 01 00 00       	jmp    75d <printf+0x19c>
      } else {
        putc(fd, c);
 612:	8b 45 e8             	mov    -0x18(%ebp),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	89 44 24 04          	mov    %eax,0x4(%esp)
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 c1 fe ff ff       	call   4e8 <putc>
 627:	e9 31 01 00 00       	jmp    75d <printf+0x19c>
      }
    } else if(state == '%'){
 62c:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 630:	0f 85 27 01 00 00    	jne    75d <printf+0x19c>
      if(c == 'd'){
 636:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 63a:	75 2d                	jne    669 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 63c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 648:	00 
 649:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 650:	00 
 651:	89 44 24 04          	mov    %eax,0x4(%esp)
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 b0 fe ff ff       	call   510 <printint>
        ap++;
 660:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 664:	e9 ed 00 00 00       	jmp    756 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 669:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 66d:	74 06                	je     675 <printf+0xb4>
 66f:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 673:	75 2d                	jne    6a2 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 681:	00 
 682:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 689:	00 
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 77 fe ff ff       	call   510 <printint>
        ap++;
 699:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 69d:	e9 b4 00 00 00       	jmp    756 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6a2:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 6a6:	75 46                	jne    6ee <printf+0x12d>
        s = (char*)*ap;
 6a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 6b0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 6b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 6b8:	75 27                	jne    6e1 <printf+0x120>
          s = "(null)";
 6ba:	c7 45 e4 12 0c 00 00 	movl   $0xc12,-0x1c(%ebp)
        while(*s != 0){
 6c1:	eb 1f                	jmp    6e2 <printf+0x121>
          putc(fd, *s);
 6c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c6:	0f b6 00             	movzbl (%eax),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d0:	8b 45 08             	mov    0x8(%ebp),%eax
 6d3:	89 04 24             	mov    %eax,(%esp)
 6d6:	e8 0d fe ff ff       	call   4e8 <putc>
          s++;
 6db:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6df:	eb 01                	jmp    6e2 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e1:	90                   	nop
 6e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e5:	0f b6 00             	movzbl (%eax),%eax
 6e8:	84 c0                	test   %al,%al
 6ea:	75 d7                	jne    6c3 <printf+0x102>
 6ec:	eb 68                	jmp    756 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ee:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6f2:	75 1d                	jne    711 <printf+0x150>
        putc(fd, *ap);
 6f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	0f be c0             	movsbl %al,%eax
 6fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 700:	8b 45 08             	mov    0x8(%ebp),%eax
 703:	89 04 24             	mov    %eax,(%esp)
 706:	e8 dd fd ff ff       	call   4e8 <putc>
        ap++;
 70b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 70f:	eb 45                	jmp    756 <printf+0x195>
      } else if(c == '%'){
 711:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 715:	75 17                	jne    72e <printf+0x16d>
        putc(fd, c);
 717:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71a:	0f be c0             	movsbl %al,%eax
 71d:	89 44 24 04          	mov    %eax,0x4(%esp)
 721:	8b 45 08             	mov    0x8(%ebp),%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 bc fd ff ff       	call   4e8 <putc>
 72c:	eb 28                	jmp    756 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 735:	00 
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 a7 fd ff ff       	call   4e8 <putc>
        putc(fd, c);
 741:	8b 45 e8             	mov    -0x18(%ebp),%eax
 744:	0f be c0             	movsbl %al,%eax
 747:	89 44 24 04          	mov    %eax,0x4(%esp)
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	89 04 24             	mov    %eax,(%esp)
 751:	e8 92 fd ff ff       	call   4e8 <putc>
      }
      state = 0;
 756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 761:	8b 55 0c             	mov    0xc(%ebp),%edx
 764:	8b 45 ec             	mov    -0x14(%ebp),%eax
 767:	8d 04 02             	lea    (%edx,%eax,1),%eax
 76a:	0f b6 00             	movzbl (%eax),%eax
 76d:	84 c0                	test   %al,%al
 76f:	0f 85 6e fe ff ff    	jne    5e3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 775:	c9                   	leave  
 776:	c3                   	ret    
 777:	90                   	nop

00000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 e8 08             	sub    $0x8,%eax
 784:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 787:	a1 68 0c 00 00       	mov    0xc68,%eax
 78c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78f:	eb 24                	jmp    7b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 799:	77 12                	ja     7ad <free+0x35>
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a1:	77 24                	ja     7c7 <free+0x4f>
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ab:	77 1a                	ja     7c7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bb:	76 d4                	jbe    791 <free+0x19>
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c5:	76 ca                	jbe    791 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	c1 e0 03             	shl    $0x3,%eax
 7d0:	89 c2                	mov    %eax,%edx
 7d2:	03 55 f8             	add    -0x8(%ebp),%edx
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	39 c2                	cmp    %eax,%edx
 7dc:	75 24                	jne    802 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	8b 50 04             	mov    0x4(%eax),%edx
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	01 c2                	add    %eax,%edx
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
 800:	eb 0a                	jmp    80c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 10                	mov    (%eax),%edx
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	c1 e0 03             	shl    $0x3,%eax
 815:	03 45 fc             	add    -0x4(%ebp),%eax
 818:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81b:	75 20                	jne    83d <free+0xc5>
    p->s.size += bp->s.size;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 50 04             	mov    0x4(%eax),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	01 c2                	add    %eax,%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 08                	jmp    845 <free+0xcd>
  } else
    p->s.ptr = bp;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 55 f8             	mov    -0x8(%ebp),%edx
 843:	89 10                	mov    %edx,(%eax)
  freep = p;
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 84d:	c9                   	leave  
 84e:	c3                   	ret    

0000084f <morecore>:

static Header*
morecore(uint nu)
{
 84f:	55                   	push   %ebp
 850:	89 e5                	mov    %esp,%ebp
 852:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 855:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 85c:	77 07                	ja     865 <morecore+0x16>
    nu = 4096;
 85e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	c1 e0 03             	shl    $0x3,%eax
 86b:	89 04 24             	mov    %eax,(%esp)
 86e:	e8 3d fc ff ff       	call   4b0 <sbrk>
 873:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 876:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 87a:	75 07                	jne    883 <morecore+0x34>
    return 0;
 87c:	b8 00 00 00 00       	mov    $0x0,%eax
 881:	eb 22                	jmp    8a5 <morecore+0x56>
  hp = (Header*)p;
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 55 08             	mov    0x8(%ebp),%edx
 88f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	83 c0 08             	add    $0x8,%eax
 898:	89 04 24             	mov    %eax,(%esp)
 89b:	e8 d8 fe ff ff       	call   778 <free>
  return freep;
 8a0:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    

000008a7 <malloc>:

void*
malloc(uint nbytes)
{
 8a7:	55                   	push   %ebp
 8a8:	89 e5                	mov    %esp,%ebp
 8aa:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ad:	8b 45 08             	mov    0x8(%ebp),%eax
 8b0:	83 c0 07             	add    $0x7,%eax
 8b3:	c1 e8 03             	shr    $0x3,%eax
 8b6:	83 c0 01             	add    $0x1,%eax
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 8bc:	a1 68 0c 00 00       	mov    0xc68,%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c8:	75 23                	jne    8ed <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ca:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	a3 68 0c 00 00       	mov    %eax,0xc68
 8d9:	a1 68 0c 00 00       	mov    0xc68,%eax
 8de:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8e3:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f8:	8b 40 04             	mov    0x4(%eax),%eax
 8fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8fe:	72 4d                	jb     94d <malloc+0xa6>
      if(p->s.size == nunits)
 900:	8b 45 ec             	mov    -0x14(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 909:	75 0c                	jne    917 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 90b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90e:	8b 10                	mov    (%eax),%edx
 910:	8b 45 f0             	mov    -0x10(%ebp),%eax
 913:	89 10                	mov    %edx,(%eax)
 915:	eb 26                	jmp    93d <malloc+0x96>
      else {
        p->s.size -= nunits;
 917:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91a:	8b 40 04             	mov    0x4(%eax),%eax
 91d:	89 c2                	mov    %eax,%edx
 91f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 922:	8b 45 ec             	mov    -0x14(%ebp),%eax
 925:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 928:	8b 45 ec             	mov    -0x14(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	c1 e0 03             	shl    $0x3,%eax
 931:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 934:	8b 45 ec             	mov    -0x14(%ebp),%eax
 937:	8b 55 f4             	mov    -0xc(%ebp),%edx
 93a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 93d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 940:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 945:	8b 45 ec             	mov    -0x14(%ebp),%eax
 948:	83 c0 08             	add    $0x8,%eax
 94b:	eb 38                	jmp    985 <malloc+0xde>
    }
    if(p == freep)
 94d:	a1 68 0c 00 00       	mov    0xc68,%eax
 952:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 955:	75 1b                	jne    972 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	89 04 24             	mov    %eax,(%esp)
 95d:	e8 ed fe ff ff       	call   84f <morecore>
 962:	89 45 ec             	mov    %eax,-0x14(%ebp)
 965:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 969:	75 07                	jne    972 <malloc+0xcb>
        return 0;
 96b:	b8 00 00 00 00       	mov    $0x0,%eax
 970:	eb 13                	jmp    985 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	8b 45 ec             	mov    -0x14(%ebp),%eax
 975:	89 45 f0             	mov    %eax,-0x10(%ebp)
 978:	8b 45 ec             	mov    -0x14(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 980:	e9 70 ff ff ff       	jmp    8f5 <malloc+0x4e>
}
 985:	c9                   	leave  
 986:	c3                   	ret    
 987:	90                   	nop

00000988 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 988:	55                   	push   %ebp
 989:	89 e5                	mov    %esp,%ebp
 98b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 98e:	8b 55 08             	mov    0x8(%ebp),%edx
 991:	8b 45 0c             	mov    0xc(%ebp),%eax
 994:	8b 4d 08             	mov    0x8(%ebp),%ecx
 997:	f0 87 02             	lock xchg %eax,(%edx)
 99a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9a0:	c9                   	leave  
 9a1:	c3                   	ret    

000009a2 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 9ae:	5d                   	pop    %ebp
 9af:	c3                   	ret    

000009b0 <lock_acquire>:
void lock_acquire(lock_t *lock){
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 9b6:	8b 45 08             	mov    0x8(%ebp),%eax
 9b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 9c0:	00 
 9c1:	89 04 24             	mov    %eax,(%esp)
 9c4:	e8 bf ff ff ff       	call   988 <xchg>
 9c9:	85 c0                	test   %eax,%eax
 9cb:	75 e9                	jne    9b6 <lock_acquire+0x6>
}
 9cd:	c9                   	leave  
 9ce:	c3                   	ret    

000009cf <lock_release>:
void lock_release(lock_t *lock){
 9cf:	55                   	push   %ebp
 9d0:	89 e5                	mov    %esp,%ebp
 9d2:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9df:	00 
 9e0:	89 04 24             	mov    %eax,(%esp)
 9e3:	e8 a0 ff ff ff       	call   988 <xchg>
}
 9e8:	c9                   	leave  
 9e9:	c3                   	ret    

000009ea <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 9ea:	55                   	push   %ebp
 9eb:	89 e5                	mov    %esp,%ebp
 9ed:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 9f0:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 9f7:	e8 ab fe ff ff       	call   8a7 <malloc>
 9fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 9ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a08:	25 ff 0f 00 00       	and    $0xfff,%eax
 a0d:	85 c0                	test   %eax,%eax
 a0f:	74 15                	je     a26 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a14:	89 c2                	mov    %eax,%edx
 a16:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 a1c:	b8 00 10 00 00       	mov    $0x1000,%eax
 a21:	29 d0                	sub    %edx,%eax
 a23:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a2a:	75 1b                	jne    a47 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 a2c:	c7 44 24 04 19 0c 00 	movl   $0xc19,0x4(%esp)
 a33:	00 
 a34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a3b:	e8 81 fb ff ff       	call   5c1 <printf>
        return 0;
 a40:	b8 00 00 00 00       	mov    $0x0,%eax
 a45:	eb 6f                	jmp    ab6 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 a47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 a4a:	8b 55 08             	mov    0x8(%ebp),%edx
 a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a50:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 a54:	89 54 24 08          	mov    %edx,0x8(%esp)
 a58:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 a5f:	00 
 a60:	89 04 24             	mov    %eax,(%esp)
 a63:	e8 60 fa ff ff       	call   4c8 <clone>
 a68:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 a6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a6f:	79 1b                	jns    a8c <thread_create+0xa2>
        printf(1,"clone fails\n");
 a71:	c7 44 24 04 27 0c 00 	movl   $0xc27,0x4(%esp)
 a78:	00 
 a79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a80:	e8 3c fb ff ff       	call   5c1 <printf>
        return 0;
 a85:	b8 00 00 00 00       	mov    $0x0,%eax
 a8a:	eb 2a                	jmp    ab6 <thread_create+0xcc>
    }
    if(tid > 0){
 a8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a90:	7e 05                	jle    a97 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a95:	eb 1f                	jmp    ab6 <thread_create+0xcc>
    }
    if(tid == 0){
 a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a9b:	75 14                	jne    ab1 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 a9d:	c7 44 24 04 34 0c 00 	movl   $0xc34,0x4(%esp)
 aa4:	00 
 aa5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 aac:	e8 10 fb ff ff       	call   5c1 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 ab6:	c9                   	leave  
 ab7:	c3                   	ret    

00000ab8 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 ab8:	55                   	push   %ebp
 ab9:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 abb:	8b 45 08             	mov    0x8(%ebp),%eax
 abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 ac4:	8b 45 08             	mov    0x8(%ebp),%eax
 ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 ace:	8b 45 08             	mov    0x8(%ebp),%eax
 ad1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 ad8:	5d                   	pop    %ebp
 ad9:	c3                   	ret    

00000ada <add_q>:

void add_q(struct queue *q, int v){
 ada:	55                   	push   %ebp
 adb:	89 e5                	mov    %esp,%ebp
 add:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 ae0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 ae7:	e8 bb fd ff ff       	call   8a7 <malloc>
 aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afc:	8b 55 0c             	mov    0xc(%ebp),%edx
 aff:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 b01:	8b 45 08             	mov    0x8(%ebp),%eax
 b04:	8b 40 04             	mov    0x4(%eax),%eax
 b07:	85 c0                	test   %eax,%eax
 b09:	75 0b                	jne    b16 <add_q+0x3c>
        q->head = n;
 b0b:	8b 45 08             	mov    0x8(%ebp),%eax
 b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b11:	89 50 04             	mov    %edx,0x4(%eax)
 b14:	eb 0c                	jmp    b22 <add_q+0x48>
    }else{
        q->tail->next = n;
 b16:	8b 45 08             	mov    0x8(%ebp),%eax
 b19:	8b 40 08             	mov    0x8(%eax),%eax
 b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b1f:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 b22:	8b 45 08             	mov    0x8(%ebp),%eax
 b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
 b28:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 b2b:	8b 45 08             	mov    0x8(%ebp),%eax
 b2e:	8b 00                	mov    (%eax),%eax
 b30:	8d 50 01             	lea    0x1(%eax),%edx
 b33:	8b 45 08             	mov    0x8(%ebp),%eax
 b36:	89 10                	mov    %edx,(%eax)
}
 b38:	c9                   	leave  
 b39:	c3                   	ret    

00000b3a <empty_q>:

int empty_q(struct queue *q){
 b3a:	55                   	push   %ebp
 b3b:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 b3d:	8b 45 08             	mov    0x8(%ebp),%eax
 b40:	8b 00                	mov    (%eax),%eax
 b42:	85 c0                	test   %eax,%eax
 b44:	75 07                	jne    b4d <empty_q+0x13>
        return 1;
 b46:	b8 01 00 00 00       	mov    $0x1,%eax
 b4b:	eb 05                	jmp    b52 <empty_q+0x18>
    else
        return 0;
 b4d:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 b52:	5d                   	pop    %ebp
 b53:	c3                   	ret    

00000b54 <pop_q>:
int pop_q(struct queue *q){
 b54:	55                   	push   %ebp
 b55:	89 e5                	mov    %esp,%ebp
 b57:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	89 04 24             	mov    %eax,(%esp)
 b60:	e8 d5 ff ff ff       	call   b3a <empty_q>
 b65:	85 c0                	test   %eax,%eax
 b67:	75 5d                	jne    bc6 <pop_q+0x72>
       val = q->head->value; 
 b69:	8b 45 08             	mov    0x8(%ebp),%eax
 b6c:	8b 40 04             	mov    0x4(%eax),%eax
 b6f:	8b 00                	mov    (%eax),%eax
 b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 b74:	8b 45 08             	mov    0x8(%ebp),%eax
 b77:	8b 40 04             	mov    0x4(%eax),%eax
 b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 b7d:	8b 45 08             	mov    0x8(%ebp),%eax
 b80:	8b 40 04             	mov    0x4(%eax),%eax
 b83:	8b 50 04             	mov    0x4(%eax),%edx
 b86:	8b 45 08             	mov    0x8(%ebp),%eax
 b89:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8f:	89 04 24             	mov    %eax,(%esp)
 b92:	e8 e1 fb ff ff       	call   778 <free>
       q->size--;
 b97:	8b 45 08             	mov    0x8(%ebp),%eax
 b9a:	8b 00                	mov    (%eax),%eax
 b9c:	8d 50 ff             	lea    -0x1(%eax),%edx
 b9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ba2:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 ba4:	8b 45 08             	mov    0x8(%ebp),%eax
 ba7:	8b 00                	mov    (%eax),%eax
 ba9:	85 c0                	test   %eax,%eax
 bab:	75 14                	jne    bc1 <pop_q+0x6d>
            q->head = 0;
 bad:	8b 45 08             	mov    0x8(%ebp),%eax
 bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 bb7:	8b 45 08             	mov    0x8(%ebp),%eax
 bba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc4:	eb 05                	jmp    bcb <pop_q+0x77>
    }
    return -1;
 bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 bcb:	c9                   	leave  
 bcc:	c3                   	ret    

00000bcd <front>:

int front(struct queue *q)
{
 bcd:	55                   	push   %ebp
 bce:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 bd0:	8b 45 08             	mov    0x8(%ebp),%eax
 bd3:	8b 40 04             	mov    0x4(%eax),%eax
 bd6:	8b 00                	mov    (%eax),%eax
}
 bd8:	5d                   	pop    %ebp
 bd9:	c3                   	ret    
