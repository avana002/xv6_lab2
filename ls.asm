
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 db 03 00 00       	call   3ed <strlen>
  12:	03 45 08             	add    0x8(%ebp),%eax
  15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  18:	eb 04                	jmp    1e <fmtname+0x1e>
  1a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  21:	3b 45 08             	cmp    0x8(%ebp),%eax
  24:	72 0a                	jb     30 <fmtname+0x30>
  26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  29:	0f b6 00             	movzbl (%eax),%eax
  2c:	3c 2f                	cmp    $0x2f,%al
  2e:	75 ea                	jne    1a <fmtname+0x1a>
    ;
  p++;
  30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  37:	89 04 24             	mov    %eax,(%esp)
  3a:	e8 ae 03 00 00       	call   3ed <strlen>
  3f:	83 f8 0d             	cmp    $0xd,%eax
  42:	76 05                	jbe    49 <fmtname+0x49>
    return p;
  44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  47:	eb 5f                	jmp    a8 <fmtname+0xa8>
  memmove(buf, p, strlen(p));
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 99 03 00 00       	call   3ed <strlen>
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  5f:	c7 04 24 fc 0d 00 00 	movl   $0xdfc,(%esp)
  66:	e8 07 05 00 00       	call   572 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 04 24             	mov    %eax,(%esp)
  71:	e8 77 03 00 00       	call   3ed <strlen>
  76:	ba 0e 00 00 00       	mov    $0xe,%edx
  7b:	89 d3                	mov    %edx,%ebx
  7d:	29 c3                	sub    %eax,%ebx
  7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  82:	89 04 24             	mov    %eax,(%esp)
  85:	e8 63 03 00 00       	call   3ed <strlen>
  8a:	05 fc 0d 00 00       	add    $0xdfc,%eax
  8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  93:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9a:	00 
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 6f 03 00 00       	call   412 <memset>
  return buf;
  a3:	b8 fc 0d 00 00       	mov    $0xdfc,%eax
}
  a8:	83 c4 24             	add    $0x24,%esp
  ab:	5b                   	pop    %ebx
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <ls>:

void
ls(char *path)
{
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	57                   	push   %edi
  b2:	56                   	push   %esi
  b3:	53                   	push   %ebx
  b4:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c1:	00 
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	89 04 24             	mov    %eax,(%esp)
  c8:	e8 2b 05 00 00       	call   5f8 <open>
  cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d4:	79 20                	jns    f6 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  dd:	c7 44 24 04 6a 0d 00 	movl   $0xd6a,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ec:	e8 60 06 00 00       	call   751 <printf>
    return;
  f1:	e9 01 02 00 00       	jmp    2f7 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
  f6:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 05 05 00 00       	call   610 <fstat>
 10b:	85 c0                	test   %eax,%eax
 10d:	79 2b                	jns    13a <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	89 44 24 08          	mov    %eax,0x8(%esp)
 116:	c7 44 24 04 7e 0d 00 	movl   $0xd7e,0x4(%esp)
 11d:	00 
 11e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 125:	e8 27 06 00 00       	call   751 <printf>
    close(fd);
 12a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12d:	89 04 24             	mov    %eax,(%esp)
 130:	e8 ab 04 00 00       	call   5e0 <close>
    return;
 135:	e9 bd 01 00 00       	jmp    2f7 <ls+0x249>
  }
  
  switch(st.type){
 13a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 141:	98                   	cwtl   
 142:	83 f8 01             	cmp    $0x1,%eax
 145:	74 53                	je     19a <ls+0xec>
 147:	83 f8 02             	cmp    $0x2,%eax
 14a:	0f 85 9c 01 00 00    	jne    2ec <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 150:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 156:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 163:	0f bf d8             	movswl %ax,%ebx
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 04 24             	mov    %eax,(%esp)
 16c:	e8 8f fe ff ff       	call   0 <fmtname>
 171:	89 7c 24 14          	mov    %edi,0x14(%esp)
 175:	89 74 24 10          	mov    %esi,0x10(%esp)
 179:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17d:	89 44 24 08          	mov    %eax,0x8(%esp)
 181:	c7 44 24 04 92 0d 00 	movl   $0xd92,0x4(%esp)
 188:	00 
 189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 190:	e8 bc 05 00 00       	call   751 <printf>
    break;
 195:	e9 52 01 00 00       	jmp    2ec <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	89 04 24             	mov    %eax,(%esp)
 1a0:	e8 48 02 00 00       	call   3ed <strlen>
 1a5:	83 c0 10             	add    $0x10,%eax
 1a8:	3d 00 02 00 00       	cmp    $0x200,%eax
 1ad:	76 19                	jbe    1c8 <ls+0x11a>
      printf(1, "ls: path too long\n");
 1af:	c7 44 24 04 9f 0d 00 	movl   $0xd9f,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 8e 05 00 00       	call   751 <printf>
      break;
 1c3:	e9 24 01 00 00       	jmp    2ec <ls+0x23e>
    }
    strcpy(buf, path);
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cf:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 9c 01 00 00       	call   379 <strcpy>
    p = buf+strlen(buf);
 1dd:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 02 02 00 00       	call   3ed <strlen>
 1eb:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f1:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fa:	c6 00 2f             	movb   $0x2f,(%eax)
 1fd:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 201:	e9 c0 00 00 00       	jmp    2c6 <ls+0x218>
      if(de.inum == 0)
 206:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 20d:	66 85 c0             	test   %ax,%ax
 210:	0f 84 af 00 00 00    	je     2c5 <ls+0x217>
        continue;
      memmove(p, de.name, DIRSIZ);
 216:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 21d:	00 
 21e:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 224:	83 c0 02             	add    $0x2,%eax
 227:	89 44 24 04          	mov    %eax,0x4(%esp)
 22b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22e:	89 04 24             	mov    %eax,(%esp)
 231:	e8 3c 03 00 00       	call   572 <memmove>
      p[DIRSIZ] = 0;
 236:	8b 45 e0             	mov    -0x20(%ebp),%eax
 239:	83 c0 0e             	add    $0xe,%eax
 23c:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 23f:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 245:	89 44 24 04          	mov    %eax,0x4(%esp)
 249:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 81 02 00 00       	call   4d8 <stat>
 257:	85 c0                	test   %eax,%eax
 259:	79 20                	jns    27b <ls+0x1cd>
        printf(1, "ls: cannot stat %s\n", buf);
 25b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 261:	89 44 24 08          	mov    %eax,0x8(%esp)
 265:	c7 44 24 04 7e 0d 00 	movl   $0xd7e,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 d8 04 00 00       	call   751 <printf>
        continue;
 279:	eb 4b                	jmp    2c6 <ls+0x218>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27b:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 281:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 287:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 28e:	0f bf d8             	movswl %ax,%ebx
 291:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 297:	89 04 24             	mov    %eax,(%esp)
 29a:	e8 61 fd ff ff       	call   0 <fmtname>
 29f:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a3:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 2af:	c7 44 24 04 92 0d 00 	movl   $0xd92,0x4(%esp)
 2b6:	00 
 2b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2be:	e8 8e 04 00 00       	call   751 <printf>
 2c3:	eb 01                	jmp    2c6 <ls+0x218>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 2c5:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2cd:	00 
 2ce:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 ed 02 00 00       	call   5d0 <read>
 2e3:	83 f8 10             	cmp    $0x10,%eax
 2e6:	0f 84 1a ff ff ff    	je     206 <ls+0x158>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 2ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2ef:	89 04 24             	mov    %eax,(%esp)
 2f2:	e8 e9 02 00 00       	call   5e0 <close>
}
 2f7:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <main>:

int
main(int argc, char *argv[])
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 e4 f0             	and    $0xfffffff0,%esp
 308:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 30f:	7f 11                	jg     322 <main+0x20>
    ls(".");
 311:	c7 04 24 b2 0d 00 00 	movl   $0xdb2,(%esp)
 318:	e8 91 fd ff ff       	call   ae <ls>
    exit();
 31d:	e8 96 02 00 00       	call   5b8 <exit>
  }
  for(i=1; i<argc; i++)
 322:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 329:	00 
 32a:	eb 19                	jmp    345 <main+0x43>
    ls(argv[i]);
 32c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 330:	c1 e0 02             	shl    $0x2,%eax
 333:	03 45 0c             	add    0xc(%ebp),%eax
 336:	8b 00                	mov    (%eax),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 6e fd ff ff       	call   ae <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 340:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 345:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 349:	3b 45 08             	cmp    0x8(%ebp),%eax
 34c:	7c de                	jl     32c <main+0x2a>
    ls(argv[i]);
  exit();
 34e:	e8 65 02 00 00       	call   5b8 <exit>
 353:	90                   	nop

00000354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 359:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35c:	8b 55 10             	mov    0x10(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	89 cb                	mov    %ecx,%ebx
 364:	89 df                	mov    %ebx,%edi
 366:	89 d1                	mov    %edx,%ecx
 368:	fc                   	cld    
 369:	f3 aa                	rep stos %al,%es:(%edi)
 36b:	89 ca                	mov    %ecx,%edx
 36d:	89 fb                	mov    %edi,%ebx
 36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 375:	5b                   	pop    %ebx
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	0f b6 10             	movzbl (%eax),%edx
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	88 10                	mov    %dl,(%eax)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	84 c0                	test   %al,%al
 398:	0f 95 c0             	setne  %al
 39b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 39f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3a3:	84 c0                	test   %al,%al
 3a5:	75 de                	jne    385 <strcpy+0xc>
    ;
  return os;
 3a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3af:	eb 08                	jmp    3b9 <strcmp+0xd>
    p++, q++;
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	84 c0                	test   %al,%al
 3c1:	74 10                	je     3d3 <strcmp+0x27>
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 10             	movzbl (%eax),%edx
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	38 c2                	cmp    %al,%dl
 3d1:	74 de                	je     3b1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	0f b6 d0             	movzbl %al,%edx
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 c0             	movzbl %al,%eax
 3e5:	89 d1                	mov    %edx,%ecx
 3e7:	29 c1                	sub    %eax,%ecx
 3e9:	89 c8                	mov    %ecx,%eax
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    

000003ed <strlen>:

uint
strlen(char *s)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fa:	eb 04                	jmp    400 <strlen+0x13>
 3fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	03 45 08             	add    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	84 c0                	test   %al,%al
 40b:	75 ef                	jne    3fc <strlen+0xf>
    ;
  return n;
 40d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <memset>:

void*
memset(void *dst, int c, uint n)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 418:	8b 45 10             	mov    0x10(%ebp),%eax
 41b:	89 44 24 08          	mov    %eax,0x8(%esp)
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 23 ff ff ff       	call   354 <stosb>
  return dst;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <strchr>:

char*
strchr(const char *s, char c)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 04             	sub    $0x4,%esp
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 442:	eb 14                	jmp    458 <strchr+0x22>
    if(*s == c)
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	0f b6 00             	movzbl (%eax),%eax
 44a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44d:	75 05                	jne    454 <strchr+0x1e>
      return (char*)s;
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	eb 13                	jmp    467 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 454:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	0f b6 00             	movzbl (%eax),%eax
 45e:	84 c0                	test   %al,%al
 460:	75 e2                	jne    444 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 462:	b8 00 00 00 00       	mov    $0x0,%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <gets>:

char*
gets(char *buf, int max)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 476:	eb 44                	jmp    4bc <gets+0x53>
    cc = read(0, &c, 1);
 478:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47f:	00 
 480:	8d 45 ef             	lea    -0x11(%ebp),%eax
 483:	89 44 24 04          	mov    %eax,0x4(%esp)
 487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48e:	e8 3d 01 00 00       	call   5d0 <read>
 493:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49a:	7e 2d                	jle    4c9 <gets+0x60>
      break;
    buf[i++] = c;
 49c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49f:	03 45 08             	add    0x8(%ebp),%eax
 4a2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4a6:	88 10                	mov    %dl,(%eax)
 4a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b0:	3c 0a                	cmp    $0xa,%al
 4b2:	74 16                	je     4ca <gets+0x61>
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	3c 0d                	cmp    $0xd,%al
 4ba:	74 0e                	je     4ca <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	83 c0 01             	add    $0x1,%eax
 4c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4c5:	7c b1                	jl     478 <gets+0xf>
 4c7:	eb 01                	jmp    4ca <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4c9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cd:	03 45 08             	add    0x8(%ebp),%eax
 4d0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <stat>:

int
stat(char *n, struct stat *st)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4e5:	00 
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 07 01 00 00       	call   5f8 <open>
 4f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 4f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f8:	79 07                	jns    501 <stat+0x29>
    return -1;
 4fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ff:	eb 23                	jmp    524 <stat+0x4c>
  r = fstat(fd, st);
 501:	8b 45 0c             	mov    0xc(%ebp),%eax
 504:	89 44 24 04          	mov    %eax,0x4(%esp)
 508:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50b:	89 04 24             	mov    %eax,(%esp)
 50e:	e8 fd 00 00 00       	call   610 <fstat>
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 516:	8b 45 f0             	mov    -0x10(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 bf 00 00 00       	call   5e0 <close>
  return r;
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 524:	c9                   	leave  
 525:	c3                   	ret    

00000526 <atoi>:

int
atoi(const char *s)
{
 526:	55                   	push   %ebp
 527:	89 e5                	mov    %esp,%ebp
 529:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 52c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 533:	eb 24                	jmp    559 <atoi+0x33>
    n = n*10 + *s++ - '0';
 535:	8b 55 fc             	mov    -0x4(%ebp),%edx
 538:	89 d0                	mov    %edx,%eax
 53a:	c1 e0 02             	shl    $0x2,%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	01 c0                	add    %eax,%eax
 541:	89 c2                	mov    %eax,%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	0f b6 00             	movzbl (%eax),%eax
 549:	0f be c0             	movsbl %al,%eax
 54c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 54f:	83 e8 30             	sub    $0x30,%eax
 552:	89 45 fc             	mov    %eax,-0x4(%ebp)
 555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	3c 2f                	cmp    $0x2f,%al
 561:	7e 0a                	jle    56d <atoi+0x47>
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	3c 39                	cmp    $0x39,%al
 56b:	7e c8                	jle    535 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 56d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 570:	c9                   	leave  
 571:	c3                   	ret    

00000572 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 572:	55                   	push   %ebp
 573:	89 e5                	mov    %esp,%ebp
 575:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 57e:	8b 45 0c             	mov    0xc(%ebp),%eax
 581:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 584:	eb 13                	jmp    599 <memmove+0x27>
    *dst++ = *src++;
 586:	8b 45 fc             	mov    -0x4(%ebp),%eax
 589:	0f b6 10             	movzbl (%eax),%edx
 58c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 58f:	88 10                	mov    %dl,(%eax)
 591:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 595:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 599:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 59d:	0f 9f c0             	setg   %al
 5a0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5a4:	84 c0                	test   %al,%al
 5a6:	75 de                	jne    586 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ab:	c9                   	leave  
 5ac:	c3                   	ret    
 5ad:	90                   	nop
 5ae:	90                   	nop
 5af:	90                   	nop

000005b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b0:	b8 01 00 00 00       	mov    $0x1,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <exit>:
SYSCALL(exit)
 5b8:	b8 02 00 00 00       	mov    $0x2,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <wait>:
SYSCALL(wait)
 5c0:	b8 03 00 00 00       	mov    $0x3,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <pipe>:
SYSCALL(pipe)
 5c8:	b8 04 00 00 00       	mov    $0x4,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <read>:
SYSCALL(read)
 5d0:	b8 05 00 00 00       	mov    $0x5,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <write>:
SYSCALL(write)
 5d8:	b8 10 00 00 00       	mov    $0x10,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <close>:
SYSCALL(close)
 5e0:	b8 15 00 00 00       	mov    $0x15,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <kill>:
SYSCALL(kill)
 5e8:	b8 06 00 00 00       	mov    $0x6,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <exec>:
SYSCALL(exec)
 5f0:	b8 07 00 00 00       	mov    $0x7,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <open>:
SYSCALL(open)
 5f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <mknod>:
SYSCALL(mknod)
 600:	b8 11 00 00 00       	mov    $0x11,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <unlink>:
SYSCALL(unlink)
 608:	b8 12 00 00 00       	mov    $0x12,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <fstat>:
SYSCALL(fstat)
 610:	b8 08 00 00 00       	mov    $0x8,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <link>:
SYSCALL(link)
 618:	b8 13 00 00 00       	mov    $0x13,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <mkdir>:
SYSCALL(mkdir)
 620:	b8 14 00 00 00       	mov    $0x14,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <chdir>:
SYSCALL(chdir)
 628:	b8 09 00 00 00       	mov    $0x9,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <dup>:
SYSCALL(dup)
 630:	b8 0a 00 00 00       	mov    $0xa,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <getpid>:
SYSCALL(getpid)
 638:	b8 0b 00 00 00       	mov    $0xb,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <sbrk>:
SYSCALL(sbrk)
 640:	b8 0c 00 00 00       	mov    $0xc,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <sleep>:
SYSCALL(sleep)
 648:	b8 0d 00 00 00       	mov    $0xd,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <uptime>:
SYSCALL(uptime)
 650:	b8 0e 00 00 00       	mov    $0xe,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <clone>:
SYSCALL(clone)
 658:	b8 16 00 00 00       	mov    $0x16,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <texit>:
SYSCALL(texit)
 660:	b8 17 00 00 00       	mov    $0x17,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <tsleep>:
SYSCALL(tsleep)
 668:	b8 18 00 00 00       	mov    $0x18,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <twakeup>:
SYSCALL(twakeup)
 670:	b8 19 00 00 00       	mov    $0x19,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	83 ec 28             	sub    $0x28,%esp
 67e:	8b 45 0c             	mov    0xc(%ebp),%eax
 681:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 684:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68b:	00 
 68c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 68f:	89 44 24 04          	mov    %eax,0x4(%esp)
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	89 04 24             	mov    %eax,(%esp)
 699:	e8 3a ff ff ff       	call   5d8 <write>
}
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	53                   	push   %ebx
 6a4:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6b2:	74 17                	je     6cb <printint+0x2b>
 6b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6b8:	79 11                	jns    6cb <printint+0x2b>
    neg = 1;
 6ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c4:	f7 d8                	neg    %eax
 6c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6c9:	eb 06                	jmp    6d1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 6d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 6d8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 6db:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e1:	ba 00 00 00 00       	mov    $0x0,%edx
 6e6:	f7 f3                	div    %ebx
 6e8:	89 d0                	mov    %edx,%eax
 6ea:	0f b6 80 e8 0d 00 00 	movzbl 0xde8(%eax),%eax
 6f1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 6f5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 6f9:	8b 45 10             	mov    0x10(%ebp),%eax
 6fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	ba 00 00 00 00       	mov    $0x0,%edx
 707:	f7 75 d4             	divl   -0x2c(%ebp)
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 70d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 711:	75 c5                	jne    6d8 <printint+0x38>
  if(neg)
 713:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 717:	74 28                	je     741 <printint+0xa1>
    buf[i++] = '-';
 719:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 721:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 725:	eb 1a                	jmp    741 <printint+0xa1>
    putc(fd, buf[i]);
 727:	8b 45 ec             	mov    -0x14(%ebp),%eax
 72a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	89 44 24 04          	mov    %eax,0x4(%esp)
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 37 ff ff ff       	call   678 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 741:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 745:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 749:	79 dc                	jns    727 <printint+0x87>
    putc(fd, buf[i]);
}
 74b:	83 c4 44             	add    $0x44,%esp
 74e:	5b                   	pop    %ebx
 74f:	5d                   	pop    %ebp
 750:	c3                   	ret    

00000751 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 757:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 75e:	8d 45 0c             	lea    0xc(%ebp),%eax
 761:	83 c0 04             	add    $0x4,%eax
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 767:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 76e:	e9 7e 01 00 00       	jmp    8f1 <printf+0x1a0>
    c = fmt[i] & 0xff;
 773:	8b 55 0c             	mov    0xc(%ebp),%edx
 776:	8b 45 ec             	mov    -0x14(%ebp),%eax
 779:	8d 04 02             	lea    (%edx,%eax,1),%eax
 77c:	0f b6 00             	movzbl (%eax),%eax
 77f:	0f be c0             	movsbl %al,%eax
 782:	25 ff 00 00 00       	and    $0xff,%eax
 787:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 78a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78e:	75 2c                	jne    7bc <printf+0x6b>
      if(c == '%'){
 790:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 794:	75 0c                	jne    7a2 <printf+0x51>
        state = '%';
 796:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 79d:	e9 4b 01 00 00       	jmp    8ed <printf+0x19c>
      } else {
        putc(fd, c);
 7a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a5:	0f be c0             	movsbl %al,%eax
 7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 c1 fe ff ff       	call   678 <putc>
 7b7:	e9 31 01 00 00       	jmp    8ed <printf+0x19c>
      }
    } else if(state == '%'){
 7bc:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 7c0:	0f 85 27 01 00 00    	jne    8ed <printf+0x19c>
      if(c == 'd'){
 7c6:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 7ca:	75 2d                	jne    7f9 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7d8:	00 
 7d9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7e0:	00 
 7e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	89 04 24             	mov    %eax,(%esp)
 7eb:	e8 b0 fe ff ff       	call   6a0 <printint>
        ap++;
 7f0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 7f4:	e9 ed 00 00 00       	jmp    8e6 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 7f9:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 7fd:	74 06                	je     805 <printf+0xb4>
 7ff:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 803:	75 2d                	jne    832 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 811:	00 
 812:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 819:	00 
 81a:	89 44 24 04          	mov    %eax,0x4(%esp)
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	89 04 24             	mov    %eax,(%esp)
 824:	e8 77 fe ff ff       	call   6a0 <printint>
        ap++;
 829:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 82d:	e9 b4 00 00 00       	jmp    8e6 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 832:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 836:	75 46                	jne    87e <printf+0x12d>
        s = (char*)*ap;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 840:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 844:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 848:	75 27                	jne    871 <printf+0x120>
          s = "(null)";
 84a:	c7 45 e4 b4 0d 00 00 	movl   $0xdb4,-0x1c(%ebp)
        while(*s != 0){
 851:	eb 1f                	jmp    872 <printf+0x121>
          putc(fd, *s);
 853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 856:	0f b6 00             	movzbl (%eax),%eax
 859:	0f be c0             	movsbl %al,%eax
 85c:	89 44 24 04          	mov    %eax,0x4(%esp)
 860:	8b 45 08             	mov    0x8(%ebp),%eax
 863:	89 04 24             	mov    %eax,(%esp)
 866:	e8 0d fe ff ff       	call   678 <putc>
          s++;
 86b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 86f:	eb 01                	jmp    872 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 871:	90                   	nop
 872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 875:	0f b6 00             	movzbl (%eax),%eax
 878:	84 c0                	test   %al,%al
 87a:	75 d7                	jne    853 <printf+0x102>
 87c:	eb 68                	jmp    8e6 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 87e:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 882:	75 1d                	jne    8a1 <printf+0x150>
        putc(fd, *ap);
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	0f be c0             	movsbl %al,%eax
 88c:	89 44 24 04          	mov    %eax,0x4(%esp)
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	89 04 24             	mov    %eax,(%esp)
 896:	e8 dd fd ff ff       	call   678 <putc>
        ap++;
 89b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 89f:	eb 45                	jmp    8e6 <printf+0x195>
      } else if(c == '%'){
 8a1:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 8a5:	75 17                	jne    8be <printf+0x16d>
        putc(fd, c);
 8a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8aa:	0f be c0             	movsbl %al,%eax
 8ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b1:	8b 45 08             	mov    0x8(%ebp),%eax
 8b4:	89 04 24             	mov    %eax,(%esp)
 8b7:	e8 bc fd ff ff       	call   678 <putc>
 8bc:	eb 28                	jmp    8e6 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8be:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8c5:	00 
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	89 04 24             	mov    %eax,(%esp)
 8cc:	e8 a7 fd ff ff       	call   678 <putc>
        putc(fd, c);
 8d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d4:	0f be c0             	movsbl %al,%eax
 8d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8db:	8b 45 08             	mov    0x8(%ebp),%eax
 8de:	89 04 24             	mov    %eax,(%esp)
 8e1:	e8 92 fd ff ff       	call   678 <putc>
      }
      state = 0;
 8e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8ed:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 8f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 8f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f7:	8d 04 02             	lea    (%edx,%eax,1),%eax
 8fa:	0f b6 00             	movzbl (%eax),%eax
 8fd:	84 c0                	test   %al,%al
 8ff:	0f 85 6e fe ff ff    	jne    773 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 905:	c9                   	leave  
 906:	c3                   	ret    
 907:	90                   	nop

00000908 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 908:	55                   	push   %ebp
 909:	89 e5                	mov    %esp,%ebp
 90b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	83 e8 08             	sub    $0x8,%eax
 914:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 917:	a1 14 0e 00 00       	mov    0xe14,%eax
 91c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91f:	eb 24                	jmp    945 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 929:	77 12                	ja     93d <free+0x35>
 92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 931:	77 24                	ja     957 <free+0x4f>
 933:	8b 45 fc             	mov    -0x4(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93b:	77 1a                	ja     957 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 940:	8b 00                	mov    (%eax),%eax
 942:	89 45 fc             	mov    %eax,-0x4(%ebp)
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 94b:	76 d4                	jbe    921 <free+0x19>
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 955:	76 ca                	jbe    921 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	c1 e0 03             	shl    $0x3,%eax
 960:	89 c2                	mov    %eax,%edx
 962:	03 55 f8             	add    -0x8(%ebp),%edx
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	39 c2                	cmp    %eax,%edx
 96c:	75 24                	jne    992 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	8b 50 04             	mov    0x4(%eax),%edx
 974:	8b 45 fc             	mov    -0x4(%ebp),%eax
 977:	8b 00                	mov    (%eax),%eax
 979:	8b 40 04             	mov    0x4(%eax),%eax
 97c:	01 c2                	add    %eax,%edx
 97e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 981:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	8b 00                	mov    (%eax),%eax
 989:	8b 10                	mov    (%eax),%edx
 98b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98e:	89 10                	mov    %edx,(%eax)
 990:	eb 0a                	jmp    99c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 992:	8b 45 fc             	mov    -0x4(%ebp),%eax
 995:	8b 10                	mov    (%eax),%edx
 997:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 40 04             	mov    0x4(%eax),%eax
 9a2:	c1 e0 03             	shl    $0x3,%eax
 9a5:	03 45 fc             	add    -0x4(%ebp),%eax
 9a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ab:	75 20                	jne    9cd <free+0xc5>
    p->s.size += bp->s.size;
 9ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b0:	8b 50 04             	mov    0x4(%eax),%edx
 9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b6:	8b 40 04             	mov    0x4(%eax),%eax
 9b9:	01 c2                	add    %eax,%edx
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c4:	8b 10                	mov    (%eax),%edx
 9c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c9:	89 10                	mov    %edx,(%eax)
 9cb:	eb 08                	jmp    9d5 <free+0xcd>
  } else
    p->s.ptr = bp;
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d3:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d8:	a3 14 0e 00 00       	mov    %eax,0xe14
}
 9dd:	c9                   	leave  
 9de:	c3                   	ret    

000009df <morecore>:

static Header*
morecore(uint nu)
{
 9df:	55                   	push   %ebp
 9e0:	89 e5                	mov    %esp,%ebp
 9e2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ec:	77 07                	ja     9f5 <morecore+0x16>
    nu = 4096;
 9ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f5:	8b 45 08             	mov    0x8(%ebp),%eax
 9f8:	c1 e0 03             	shl    $0x3,%eax
 9fb:	89 04 24             	mov    %eax,(%esp)
 9fe:	e8 3d fc ff ff       	call   640 <sbrk>
 a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 a06:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 a0a:	75 07                	jne    a13 <morecore+0x34>
    return 0;
 a0c:	b8 00 00 00 00       	mov    $0x0,%eax
 a11:	eb 22                	jmp    a35 <morecore+0x56>
  hp = (Header*)p;
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1c:	8b 55 08             	mov    0x8(%ebp),%edx
 a1f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	83 c0 08             	add    $0x8,%eax
 a28:	89 04 24             	mov    %eax,(%esp)
 a2b:	e8 d8 fe ff ff       	call   908 <free>
  return freep;
 a30:	a1 14 0e 00 00       	mov    0xe14,%eax
}
 a35:	c9                   	leave  
 a36:	c3                   	ret    

00000a37 <malloc>:

void*
malloc(uint nbytes)
{
 a37:	55                   	push   %ebp
 a38:	89 e5                	mov    %esp,%ebp
 a3a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a3d:	8b 45 08             	mov    0x8(%ebp),%eax
 a40:	83 c0 07             	add    $0x7,%eax
 a43:	c1 e8 03             	shr    $0x3,%eax
 a46:	83 c0 01             	add    $0x1,%eax
 a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 a4c:	a1 14 0e 00 00       	mov    0xe14,%eax
 a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a58:	75 23                	jne    a7d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a5a:	c7 45 f0 0c 0e 00 00 	movl   $0xe0c,-0x10(%ebp)
 a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a64:	a3 14 0e 00 00       	mov    %eax,0xe14
 a69:	a1 14 0e 00 00       	mov    0xe14,%eax
 a6e:	a3 0c 0e 00 00       	mov    %eax,0xe0c
    base.s.size = 0;
 a73:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
 a7a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a80:	8b 00                	mov    (%eax),%eax
 a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a88:	8b 40 04             	mov    0x4(%eax),%eax
 a8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a8e:	72 4d                	jb     add <malloc+0xa6>
      if(p->s.size == nunits)
 a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a93:	8b 40 04             	mov    0x4(%eax),%eax
 a96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a99:	75 0c                	jne    aa7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a9e:	8b 10                	mov    (%eax),%edx
 aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa3:	89 10                	mov    %edx,(%eax)
 aa5:	eb 26                	jmp    acd <malloc+0x96>
      else {
        p->s.size -= nunits;
 aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	89 c2                	mov    %eax,%edx
 aaf:	2b 55 f4             	sub    -0xc(%ebp),%edx
 ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 abb:	8b 40 04             	mov    0x4(%eax),%eax
 abe:	c1 e0 03             	shl    $0x3,%eax
 ac1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 aca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad0:	a3 14 0e 00 00       	mov    %eax,0xe14
      return (void*)(p + 1);
 ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad8:	83 c0 08             	add    $0x8,%eax
 adb:	eb 38                	jmp    b15 <malloc+0xde>
    }
    if(p == freep)
 add:	a1 14 0e 00 00       	mov    0xe14,%eax
 ae2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ae5:	75 1b                	jne    b02 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aea:	89 04 24             	mov    %eax,(%esp)
 aed:	e8 ed fe ff ff       	call   9df <morecore>
 af2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 af9:	75 07                	jne    b02 <malloc+0xcb>
        return 0;
 afb:	b8 00 00 00 00       	mov    $0x0,%eax
 b00:	eb 13                	jmp    b15 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b0b:	8b 00                	mov    (%eax),%eax
 b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b10:	e9 70 ff ff ff       	jmp    a85 <malloc+0x4e>
}
 b15:	c9                   	leave  
 b16:	c3                   	ret    
 b17:	90                   	nop

00000b18 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 b18:	55                   	push   %ebp
 b19:	89 e5                	mov    %esp,%ebp
 b1b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 b1e:	8b 55 08             	mov    0x8(%ebp),%edx
 b21:	8b 45 0c             	mov    0xc(%ebp),%eax
 b24:	8b 4d 08             	mov    0x8(%ebp),%ecx
 b27:	f0 87 02             	lock xchg %eax,(%edx)
 b2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 b30:	c9                   	leave  
 b31:	c3                   	ret    

00000b32 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 b32:	55                   	push   %ebp
 b33:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 b35:	8b 45 08             	mov    0x8(%ebp),%eax
 b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 b3e:	5d                   	pop    %ebp
 b3f:	c3                   	ret    

00000b40 <lock_acquire>:
void lock_acquire(lock_t *lock){
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 b46:	8b 45 08             	mov    0x8(%ebp),%eax
 b49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 b50:	00 
 b51:	89 04 24             	mov    %eax,(%esp)
 b54:	e8 bf ff ff ff       	call   b18 <xchg>
 b59:	85 c0                	test   %eax,%eax
 b5b:	75 e9                	jne    b46 <lock_acquire+0x6>
}
 b5d:	c9                   	leave  
 b5e:	c3                   	ret    

00000b5f <lock_release>:
void lock_release(lock_t *lock){
 b5f:	55                   	push   %ebp
 b60:	89 e5                	mov    %esp,%ebp
 b62:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 b65:	8b 45 08             	mov    0x8(%ebp),%eax
 b68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 b6f:	00 
 b70:	89 04 24             	mov    %eax,(%esp)
 b73:	e8 a0 ff ff ff       	call   b18 <xchg>
}
 b78:	c9                   	leave  
 b79:	c3                   	ret    

00000b7a <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 b7a:	55                   	push   %ebp
 b7b:	89 e5                	mov    %esp,%ebp
 b7d:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 b80:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 b87:	e8 ab fe ff ff       	call   a37 <malloc>
 b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b98:	25 ff 0f 00 00       	and    $0xfff,%eax
 b9d:	85 c0                	test   %eax,%eax
 b9f:	74 15                	je     bb6 <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba4:	89 c2                	mov    %eax,%edx
 ba6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 bac:	b8 00 10 00 00       	mov    $0x1000,%eax
 bb1:	29 d0                	sub    %edx,%eax
 bb3:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 bb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bba:	75 1b                	jne    bd7 <thread_create+0x5d>

        printf(1,"malloc fail \n");
 bbc:	c7 44 24 04 bb 0d 00 	movl   $0xdbb,0x4(%esp)
 bc3:	00 
 bc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 bcb:	e8 81 fb ff ff       	call   751 <printf>
        return 0;
 bd0:	b8 00 00 00 00       	mov    $0x0,%eax
 bd5:	eb 6f                	jmp    c46 <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 bda:	8b 55 08             	mov    0x8(%ebp),%edx
 bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 be4:	89 54 24 08          	mov    %edx,0x8(%esp)
 be8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 bef:	00 
 bf0:	89 04 24             	mov    %eax,(%esp)
 bf3:	e8 60 fa ff ff       	call   658 <clone>
 bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bff:	79 1b                	jns    c1c <thread_create+0xa2>
        printf(1,"clone fails\n");
 c01:	c7 44 24 04 c9 0d 00 	movl   $0xdc9,0x4(%esp)
 c08:	00 
 c09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c10:	e8 3c fb ff ff       	call   751 <printf>
        return 0;
 c15:	b8 00 00 00 00       	mov    $0x0,%eax
 c1a:	eb 2a                	jmp    c46 <thread_create+0xcc>
    }
    if(tid > 0){
 c1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 c20:	7e 05                	jle    c27 <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c25:	eb 1f                	jmp    c46 <thread_create+0xcc>
    }
    if(tid == 0){
 c27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 c2b:	75 14                	jne    c41 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 c2d:	c7 44 24 04 d6 0d 00 	movl   $0xdd6,0x4(%esp)
 c34:	00 
 c35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 c3c:	e8 10 fb ff ff       	call   751 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c46:	c9                   	leave  
 c47:	c3                   	ret    

00000c48 <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 c48:	55                   	push   %ebp
 c49:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 c4b:	8b 45 08             	mov    0x8(%ebp),%eax
 c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 c54:	8b 45 08             	mov    0x8(%ebp),%eax
 c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 c5e:	8b 45 08             	mov    0x8(%ebp),%eax
 c61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 c68:	5d                   	pop    %ebp
 c69:	c3                   	ret    

00000c6a <add_q>:

void add_q(struct queue *q, int v){
 c6a:	55                   	push   %ebp
 c6b:	89 e5                	mov    %esp,%ebp
 c6d:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 c70:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 c77:	e8 bb fd ff ff       	call   a37 <malloc>
 c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
 c8f:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 c91:	8b 45 08             	mov    0x8(%ebp),%eax
 c94:	8b 40 04             	mov    0x4(%eax),%eax
 c97:	85 c0                	test   %eax,%eax
 c99:	75 0b                	jne    ca6 <add_q+0x3c>
        q->head = n;
 c9b:	8b 45 08             	mov    0x8(%ebp),%eax
 c9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ca1:	89 50 04             	mov    %edx,0x4(%eax)
 ca4:	eb 0c                	jmp    cb2 <add_q+0x48>
    }else{
        q->tail->next = n;
 ca6:	8b 45 08             	mov    0x8(%ebp),%eax
 ca9:	8b 40 08             	mov    0x8(%eax),%eax
 cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 caf:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 cb2:	8b 45 08             	mov    0x8(%ebp),%eax
 cb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 cb8:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 cbb:	8b 45 08             	mov    0x8(%ebp),%eax
 cbe:	8b 00                	mov    (%eax),%eax
 cc0:	8d 50 01             	lea    0x1(%eax),%edx
 cc3:	8b 45 08             	mov    0x8(%ebp),%eax
 cc6:	89 10                	mov    %edx,(%eax)
}
 cc8:	c9                   	leave  
 cc9:	c3                   	ret    

00000cca <empty_q>:

int empty_q(struct queue *q){
 cca:	55                   	push   %ebp
 ccb:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 ccd:	8b 45 08             	mov    0x8(%ebp),%eax
 cd0:	8b 00                	mov    (%eax),%eax
 cd2:	85 c0                	test   %eax,%eax
 cd4:	75 07                	jne    cdd <empty_q+0x13>
        return 1;
 cd6:	b8 01 00 00 00       	mov    $0x1,%eax
 cdb:	eb 05                	jmp    ce2 <empty_q+0x18>
    else
        return 0;
 cdd:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 ce2:	5d                   	pop    %ebp
 ce3:	c3                   	ret    

00000ce4 <pop_q>:
int pop_q(struct queue *q){
 ce4:	55                   	push   %ebp
 ce5:	89 e5                	mov    %esp,%ebp
 ce7:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 cea:	8b 45 08             	mov    0x8(%ebp),%eax
 ced:	89 04 24             	mov    %eax,(%esp)
 cf0:	e8 d5 ff ff ff       	call   cca <empty_q>
 cf5:	85 c0                	test   %eax,%eax
 cf7:	75 5d                	jne    d56 <pop_q+0x72>
       val = q->head->value; 
 cf9:	8b 45 08             	mov    0x8(%ebp),%eax
 cfc:	8b 40 04             	mov    0x4(%eax),%eax
 cff:	8b 00                	mov    (%eax),%eax
 d01:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 d04:	8b 45 08             	mov    0x8(%ebp),%eax
 d07:	8b 40 04             	mov    0x4(%eax),%eax
 d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 d0d:	8b 45 08             	mov    0x8(%ebp),%eax
 d10:	8b 40 04             	mov    0x4(%eax),%eax
 d13:	8b 50 04             	mov    0x4(%eax),%edx
 d16:	8b 45 08             	mov    0x8(%ebp),%eax
 d19:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1f:	89 04 24             	mov    %eax,(%esp)
 d22:	e8 e1 fb ff ff       	call   908 <free>
       q->size--;
 d27:	8b 45 08             	mov    0x8(%ebp),%eax
 d2a:	8b 00                	mov    (%eax),%eax
 d2c:	8d 50 ff             	lea    -0x1(%eax),%edx
 d2f:	8b 45 08             	mov    0x8(%ebp),%eax
 d32:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 d34:	8b 45 08             	mov    0x8(%ebp),%eax
 d37:	8b 00                	mov    (%eax),%eax
 d39:	85 c0                	test   %eax,%eax
 d3b:	75 14                	jne    d51 <pop_q+0x6d>
            q->head = 0;
 d3d:	8b 45 08             	mov    0x8(%ebp),%eax
 d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 d47:	8b 45 08             	mov    0x8(%ebp),%eax
 d4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d54:	eb 05                	jmp    d5b <pop_q+0x77>
    }
    return -1;
 d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 d5b:	c9                   	leave  
 d5c:	c3                   	ret    

00000d5d <front>:

int front(struct queue *q)
{
 d5d:	55                   	push   %ebp
 d5e:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 d60:	8b 45 08             	mov    0x8(%ebp),%eax
 d63:	8b 40 04             	mov    0x4(%eax),%eax
 d66:	8b 00                	mov    (%eax),%eax
}
 d68:	5d                   	pop    %ebp
 d69:	c3                   	ret    
