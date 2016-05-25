
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 18 34 10 80       	mov    $0x80103418,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 f0 85 10 	movl   $0x801085f0,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 e4 4e 00 00       	call   80104f32 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb0
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb4
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	b8 a4 db 10 80       	mov    $0x8010dba4,%eax
801000aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ad:	72 bc                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000be:	e8 90 4e 00 00       	call   80104f53 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
801000c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cb:	eb 63                	jmp    80100130 <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d0:	8b 40 04             	mov    0x4(%eax),%eax
801000d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d6:	75 4f                	jne    80100127 <bget+0x76>
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 08             	mov    0x8(%eax),%eax
801000de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e1:	75 44                	jne    80100127 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 00                	mov    (%eax),%eax
801000e8:	83 e0 01             	and    $0x1,%eax
801000eb:	85 c0                	test   %eax,%eax
801000ed:	75 23                	jne    80100112 <bget+0x61>
        b->flags |= B_BUSY;
801000ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f2:	8b 00                	mov    (%eax),%eax
801000f4:	89 c2                	mov    %eax,%edx
801000f6:	83 ca 01             	or     $0x1,%edx
801000f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fc:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fe:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100105:	e8 aa 4e 00 00       	call   80104fb4 <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 b4 4a 00 00       	call   80104bd9 <sleep>
      goto loop;
80100125:	eb 9c                	jmp    801000c3 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	8b 40 10             	mov    0x10(%eax),%eax
8010012d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100130:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100137:	75 94                	jne    801000cd <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100139:	a1 b0 db 10 80       	mov    0x8010dbb0,%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	eb 4d                	jmp    80100190 <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 00                	mov    (%eax),%eax
80100148:	83 e0 01             	and    $0x1,%eax
8010014b:	85 c0                	test   %eax,%eax
8010014d:	75 38                	jne    80100187 <bget+0xd6>
8010014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100152:	8b 00                	mov    (%eax),%eax
80100154:	83 e0 04             	and    $0x4,%eax
80100157:	85 c0                	test   %eax,%eax
80100159:	75 2c                	jne    80100187 <bget+0xd6>
      b->dev = dev;
8010015b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015e:	8b 55 08             	mov    0x8(%ebp),%edx
80100161:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010016a:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017d:	e8 32 4e 00 00       	call   80104fb4 <release>
      return b;
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	eb 1e                	jmp    801001a5 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018a:	8b 40 0c             	mov    0xc(%eax),%eax
8010018d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100190:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100197:	75 aa                	jne    80100143 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100199:	c7 04 24 f7 85 10 80 	movl   $0x801085f7,(%esp)
801001a0:	e8 95 03 00 00       	call   8010053a <panic>
}
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    

801001a7 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a7:	55                   	push   %ebp
801001a8:	89 e5                	mov    %esp,%ebp
801001aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b4:	8b 45 08             	mov    0x8(%ebp),%eax
801001b7:	89 04 24             	mov    %eax,(%esp)
801001ba:	e8 f2 fe ff ff       	call   801000b1 <bget>
801001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c5:	8b 00                	mov    (%eax),%eax
801001c7:	83 e0 02             	and    $0x2,%eax
801001ca:	85 c0                	test   %eax,%eax
801001cc:	75 0b                	jne    801001d9 <bread+0x32>
    iderw(b);
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	89 04 24             	mov    %eax,(%esp)
801001d4:	e8 0d 26 00 00       	call   801027e6 <iderw>
  return b;
801001d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001dc:	c9                   	leave  
801001dd:	c3                   	ret    

801001de <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001de:	55                   	push   %ebp
801001df:	89 e5                	mov    %esp,%ebp
801001e1:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e4:	8b 45 08             	mov    0x8(%ebp),%eax
801001e7:	8b 00                	mov    (%eax),%eax
801001e9:	83 e0 01             	and    $0x1,%eax
801001ec:	85 c0                	test   %eax,%eax
801001ee:	75 0c                	jne    801001fc <bwrite+0x1e>
    panic("bwrite");
801001f0:	c7 04 24 08 86 10 80 	movl   $0x80108608,(%esp)
801001f7:	e8 3e 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fc:	8b 45 08             	mov    0x8(%ebp),%eax
801001ff:	8b 00                	mov    (%eax),%eax
80100201:	89 c2                	mov    %eax,%edx
80100203:	83 ca 04             	or     $0x4,%edx
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020b:	8b 45 08             	mov    0x8(%ebp),%eax
8010020e:	89 04 24             	mov    %eax,(%esp)
80100211:	e8 d0 25 00 00       	call   801027e6 <iderw>
}
80100216:	c9                   	leave  
80100217:	c3                   	ret    

80100218 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	8b 00                	mov    (%eax),%eax
80100223:	83 e0 01             	and    $0x1,%eax
80100226:	85 c0                	test   %eax,%eax
80100228:	75 0c                	jne    80100236 <brelse+0x1e>
    panic("brelse");
8010022a:	c7 04 24 0f 86 10 80 	movl   $0x8010860f,(%esp)
80100231:	e8 04 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010023d:	e8 11 4d 00 00       	call   80104f53 <acquire>

  b->next->prev = b->prev;
80100242:	8b 45 08             	mov    0x8(%ebp),%eax
80100245:	8b 40 10             	mov    0x10(%eax),%eax
80100248:	8b 55 08             	mov    0x8(%ebp),%edx
8010024b:	8b 52 0c             	mov    0xc(%edx),%edx
8010024e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 40 0c             	mov    0xc(%eax),%eax
80100257:	8b 55 08             	mov    0x8(%ebp),%edx
8010025a:	8b 52 10             	mov    0x10(%edx),%edx
8010025d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100260:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100266:	8b 45 08             	mov    0x8(%ebp),%eax
80100269:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
  bcache.head.next->prev = b;
80100276:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
8010027b:	8b 55 08             	mov    0x8(%ebp),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

  b->flags &= ~B_BUSY;
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	8b 00                	mov    (%eax),%eax
8010028e:	89 c2                	mov    %eax,%edx
80100290:	83 e2 fe             	and    $0xfffffffe,%edx
80100293:	8b 45 08             	mov    0x8(%ebp),%eax
80100296:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100298:	8b 45 08             	mov    0x8(%ebp),%eax
8010029b:	89 04 24             	mov    %eax,(%esp)
8010029e:	e8 7c 4a 00 00       	call   80104d1f <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002aa:	e8 05 4d 00 00       	call   80104fb4 <release>
}
801002af:	c9                   	leave  
801002b0:	c3                   	ret    
801002b1:	00 00                	add    %al,(%eax)
	...

801002b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b4:	55                   	push   %ebp
801002b5:	89 e5                	mov    %esp,%ebp
801002b7:	83 ec 14             	sub    $0x14,%esp
801002ba:	8b 45 08             	mov    0x8(%ebp),%eax
801002bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c5:	89 c2                	mov    %eax,%edx
801002c7:	ec                   	in     (%dx),%al
801002c8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    

801002d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d1:	55                   	push   %ebp
801002d2:	89 e5                	mov    %esp,%ebp
801002d4:	83 ec 08             	sub    $0x8,%esp
801002d7:	8b 55 08             	mov    0x8(%ebp),%edx
801002da:	8b 45 0c             	mov    0xc(%ebp),%eax
801002dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ec:	ee                   	out    %al,(%dx)
}
801002ed:	c9                   	leave  
801002ee:	c3                   	ret    

801002ef <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002ef:	55                   	push   %ebp
801002f0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f2:	fa                   	cli    
}
801002f3:	5d                   	pop    %ebp
801002f4:	c3                   	ret    

801002f5 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	53                   	push   %ebx
801002f9:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100300:	74 19                	je     8010031b <printint+0x26>
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	c1 e8 1f             	shr    $0x1f,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x26>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100319:	eb 06                	jmp    80100321 <printint+0x2c>
    x = -xx;
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  i = 0;
80100321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100331:	ba 00 00 00 00       	mov    $0x0,%edx
80100336:	f7 f3                	div    %ebx
80100338:	89 d0                	mov    %edx,%eax
8010033a:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100341:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
80100345:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }while((x /= base) != 0);
80100349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010034c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 75 d4             	divl   -0x2c(%ebp)
8010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010035d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100361:	75 c5                	jne    80100328 <printint+0x33>

  if(sign)
80100363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100367:	74 21                	je     8010038a <printint+0x95>
    buf[i++] = '-';
80100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
80100371:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

  while(--i >= 0)
80100375:	eb 13                	jmp    8010038a <printint+0x95>
    consputc(buf[i]);
80100377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010037a:	0f b6 44 05 e0       	movzbl -0x20(%ebp,%eax,1),%eax
8010037f:	0f be c0             	movsbl %al,%eax
80100382:	89 04 24             	mov    %eax,(%esp)
80100385:	e8 c4 03 00 00       	call   8010074e <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
8010038e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100392:	79 e3                	jns    80100377 <printint+0x82>
    consputc(buf[i]);
}
80100394:	83 c4 44             	add    $0x44,%esp
80100397:	5b                   	pop    %ebx
80100398:	5d                   	pop    %ebp
80100399:	c3                   	ret    

8010039a <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010039a:	55                   	push   %ebp
8010039b:	89 e5                	mov    %esp,%ebp
8010039d:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a0:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
801003a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801003ac:	74 0c                	je     801003ba <cprintf+0x20>
    acquire(&cons.lock);
801003ae:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003b5:	e8 99 4b 00 00       	call   80104f53 <acquire>

  if (fmt == 0)
801003ba:	8b 45 08             	mov    0x8(%ebp),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 0c                	jne    801003cd <cprintf+0x33>
    panic("null fmt");
801003c1:	c7 04 24 16 86 10 80 	movl   $0x80108616,(%esp)
801003c8:	e8 6d 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003cd:	8d 45 08             	lea    0x8(%ebp),%eax
801003d0:	83 c0 04             	add    $0x4,%eax
801003d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801003dd:	e9 20 01 00 00       	jmp    80100502 <cprintf+0x168>
    if(c != '%'){
801003e2:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
801003e6:	74 10                	je     801003f8 <cprintf+0x5e>
      consputc(c);
801003e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801003eb:	89 04 24             	mov    %eax,(%esp)
801003ee:	e8 5b 03 00 00       	call   8010074e <consputc>
      continue;
801003f3:	e9 06 01 00 00       	jmp    801004fe <cprintf+0x164>
    }
    c = fmt[++i] & 0xff;
801003f8:	8b 55 08             	mov    0x8(%ebp),%edx
801003fb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801003ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100402:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100405:	0f b6 00             	movzbl (%eax),%eax
80100408:	0f be c0             	movsbl %al,%eax
8010040b:	25 ff 00 00 00       	and    $0xff,%eax
80100410:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
80100413:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100417:	0f 84 08 01 00 00    	je     80100525 <cprintf+0x18b>
      break;
    switch(c){
8010041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100420:	83 f8 70             	cmp    $0x70,%eax
80100423:	74 4d                	je     80100472 <cprintf+0xd8>
80100425:	83 f8 70             	cmp    $0x70,%eax
80100428:	7f 13                	jg     8010043d <cprintf+0xa3>
8010042a:	83 f8 25             	cmp    $0x25,%eax
8010042d:	0f 84 a6 00 00 00    	je     801004d9 <cprintf+0x13f>
80100433:	83 f8 64             	cmp    $0x64,%eax
80100436:	74 14                	je     8010044c <cprintf+0xb2>
80100438:	e9 aa 00 00 00       	jmp    801004e7 <cprintf+0x14d>
8010043d:	83 f8 73             	cmp    $0x73,%eax
80100440:	74 53                	je     80100495 <cprintf+0xfb>
80100442:	83 f8 78             	cmp    $0x78,%eax
80100445:	74 2b                	je     80100472 <cprintf+0xd8>
80100447:	e9 9b 00 00 00       	jmp    801004e7 <cprintf+0x14d>
    case 'd':
      printint(*argp++, 10, 1);
8010044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010044f:	8b 00                	mov    (%eax),%eax
80100451:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100455:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045c:	00 
8010045d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100464:	00 
80100465:	89 04 24             	mov    %eax,(%esp)
80100468:	e8 88 fe ff ff       	call   801002f5 <printint>
      break;
8010046d:	e9 8c 00 00 00       	jmp    801004fe <cprintf+0x164>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100475:	8b 00                	mov    (%eax),%eax
80100477:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100482:	00 
80100483:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048a:	00 
8010048b:	89 04 24             	mov    %eax,(%esp)
8010048e:	e8 62 fe ff ff       	call   801002f5 <printint>
      break;
80100493:	eb 69                	jmp    801004fe <cprintf+0x164>
    case 's':
      if((s = (char*)*argp++) == 0)
80100495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100498:	8b 00                	mov    (%eax),%eax
8010049a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010049d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801004a1:	0f 94 c0             	sete   %al
801004a4:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a8:	84 c0                	test   %al,%al
801004aa:	74 20                	je     801004cc <cprintf+0x132>
        s = "(null)";
801004ac:	c7 45 f4 1f 86 10 80 	movl   $0x8010861f,-0xc(%ebp)
      for(; *s; s++)
801004b3:	eb 18                	jmp    801004cd <cprintf+0x133>
        consputc(*s);
801004b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004b8:	0f b6 00             	movzbl (%eax),%eax
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 88 02 00 00       	call   8010074e <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004ca:	eb 01                	jmp    801004cd <cprintf+0x133>
801004cc:	90                   	nop
801004cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004d0:	0f b6 00             	movzbl (%eax),%eax
801004d3:	84 c0                	test   %al,%al
801004d5:	75 de                	jne    801004b5 <cprintf+0x11b>
        consputc(*s);
      break;
801004d7:	eb 25                	jmp    801004fe <cprintf+0x164>
    case '%':
      consputc('%');
801004d9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e0:	e8 69 02 00 00       	call   8010074e <consputc>
      break;
801004e5:	eb 17                	jmp    801004fe <cprintf+0x164>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ee:	e8 5b 02 00 00       	call   8010074e <consputc>
      consputc(c);
801004f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801004f6:	89 04 24             	mov    %eax,(%esp)
801004f9:	e8 50 02 00 00       	call   8010074e <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100502:	8b 55 08             	mov    0x8(%ebp),%edx
80100505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100508:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010050b:	0f b6 00             	movzbl (%eax),%eax
8010050e:	0f be c0             	movsbl %al,%eax
80100511:	25 ff 00 00 00       	and    $0xff,%eax
80100516:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100519:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010051d:	0f 85 bf fe ff ff    	jne    801003e2 <cprintf+0x48>
80100523:	eb 01                	jmp    80100526 <cprintf+0x18c>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100525:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x19e>
    release(&cons.lock);
8010052c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100533:	e8 7c 4a 00 00       	call   80104fb4 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 aa fd ff ff       	call   801002ef <cli>
  cons.locking = 0;
80100545:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 26 86 10 80 	movl   $0x80108626,(%esp)
80100566:	e8 2f fe ff ff       	call   8010039a <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 24 fe ff ff       	call   8010039a <cprintf>
  cprintf("\n");
80100576:	c7 04 24 35 86 10 80 	movl   $0x80108635,(%esp)
8010057d:	e8 18 fe ff ff       	call   8010039a <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 6f 4a 00 00       	call   80105003 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 37 86 10 80 	movl   $0x80108637,(%esp)
801005af:	e8 e6 fd ff ff       	call   8010039a <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 ed fc ff ff       	call   801002d1 <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c4 fc ff ff       	call   801002b4 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c4 fc ff ff       	call   801002d1 <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 9b fc ff ff       	call   801002b4 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	89 ca                	mov    %ecx,%edx
80100647:	29 c2                	sub    %eax,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 33                	jmp    80100688 <cgaputc+0xbe>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 24                	jle    80100688 <cgaputc+0xbe>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 1e                	jmp    80100688 <cgaputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	a1 00 90 10 80       	mov    0x80109000,%eax
8010066f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100672:	01 d2                	add    %edx,%edx
80100674:	8d 14 10             	lea    (%eax,%edx,1),%edx
80100677:	8b 45 08             	mov    0x8(%ebp),%eax
8010067a:	66 25 ff 00          	and    $0xff,%ax
8010067e:	80 cc 07             	or     $0x7,%ah
80100681:	66 89 02             	mov    %ax,(%edx)
80100684:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
80100688:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
8010068f:	7e 53                	jle    801006e4 <cgaputc+0x11a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100691:	a1 00 90 10 80       	mov    0x80109000,%eax
80100696:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069c:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a1:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006a8:	00 
801006a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801006ad:	89 04 24             	mov    %eax,(%esp)
801006b0:	e8 c0 4b 00 00       	call   80105275 <memmove>
    pos -= 80;
801006b5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006b9:	b8 80 07 00 00       	mov    $0x780,%eax
801006be:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c1:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c4:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006cc:	01 c9                	add    %ecx,%ecx
801006ce:	01 c8                	add    %ecx,%eax
801006d0:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006db:	00 
801006dc:	89 04 24             	mov    %eax,(%esp)
801006df:	e8 be 4a 00 00       	call   801051a2 <memset>
  }
  
  outb(CRTPORT, 14);
801006e4:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006eb:	00 
801006ec:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f3:	e8 d9 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos>>8);
801006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fb:	c1 f8 08             	sar    $0x8,%eax
801006fe:	0f b6 c0             	movzbl %al,%eax
80100701:	89 44 24 04          	mov    %eax,0x4(%esp)
80100705:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070c:	e8 c0 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT, 15);
80100711:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100718:	00 
80100719:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100720:	e8 ac fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos);
80100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100728:	0f b6 c0             	movzbl %al,%eax
8010072b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010072f:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100736:	e8 96 fb ff ff       	call   801002d1 <outb>
  crt[pos] = ' ' | 0x0700;
8010073b:	a1 00 90 10 80       	mov    0x80109000,%eax
80100740:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100743:	01 d2                	add    %edx,%edx
80100745:	01 d0                	add    %edx,%eax
80100747:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074c:	c9                   	leave  
8010074d:	c3                   	ret    

8010074e <consputc>:

void
consputc(int c)
{
8010074e:	55                   	push   %ebp
8010074f:	89 e5                	mov    %esp,%ebp
80100751:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100754:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100759:	85 c0                	test   %eax,%eax
8010075b:	74 07                	je     80100764 <consputc+0x16>
    cli();
8010075d:	e8 8d fb ff ff       	call   801002ef <cli>
    for(;;)
      ;
80100762:	eb fe                	jmp    80100762 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100764:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076b:	75 26                	jne    80100793 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100774:	e8 c7 64 00 00       	call   80106c40 <uartputc>
80100779:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100780:	e8 bb 64 00 00       	call   80106c40 <uartputc>
80100785:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078c:	e8 af 64 00 00       	call   80106c40 <uartputc>
80100791:	eb 0b                	jmp    8010079e <consputc+0x50>
  } else
    uartputc(c);
80100793:	8b 45 08             	mov    0x8(%ebp),%eax
80100796:	89 04 24             	mov    %eax,(%esp)
80100799:	e8 a2 64 00 00       	call   80106c40 <uartputc>
  cgaputc(c);
8010079e:	8b 45 08             	mov    0x8(%ebp),%eax
801007a1:	89 04 24             	mov    %eax,(%esp)
801007a4:	e8 21 fe ff ff       	call   801005ca <cgaputc>
}
801007a9:	c9                   	leave  
801007aa:	c3                   	ret    

801007ab <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ab:	55                   	push   %ebp
801007ac:	89 e5                	mov    %esp,%ebp
801007ae:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b1:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801007b8:	e8 96 47 00 00       	call   80104f53 <acquire>
  while((c = getc()) >= 0){
801007bd:	e9 3e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    switch(c){
801007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c5:	83 f8 10             	cmp    $0x10,%eax
801007c8:	74 1e                	je     801007e8 <consoleintr+0x3d>
801007ca:	83 f8 10             	cmp    $0x10,%eax
801007cd:	7f 0a                	jg     801007d9 <consoleintr+0x2e>
801007cf:	83 f8 08             	cmp    $0x8,%eax
801007d2:	74 68                	je     8010083c <consoleintr+0x91>
801007d4:	e9 94 00 00 00       	jmp    8010086d <consoleintr+0xc2>
801007d9:	83 f8 15             	cmp    $0x15,%eax
801007dc:	74 2f                	je     8010080d <consoleintr+0x62>
801007de:	83 f8 7f             	cmp    $0x7f,%eax
801007e1:	74 59                	je     8010083c <consoleintr+0x91>
801007e3:	e9 85 00 00 00       	jmp    8010086d <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007e8:	e8 d9 45 00 00       	call   80104dc6 <procdump>
      break;
801007ed:	e9 0e 01 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f2:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801007f7:	83 e8 01             	sub    $0x1,%eax
801007fa:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
801007ff:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100806:	e8 43 ff ff ff       	call   8010074e <consputc>
8010080b:	eb 01                	jmp    8010080e <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080d:	90                   	nop
8010080e:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100814:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100819:	39 c2                	cmp    %eax,%edx
8010081b:	0f 84 db 00 00 00    	je     801008fc <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100821:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100826:	83 e8 01             	sub    $0x1,%eax
80100829:	83 e0 7f             	and    $0x7f,%eax
8010082c:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100833:	3c 0a                	cmp    $0xa,%al
80100835:	75 bb                	jne    801007f2 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100837:	e9 c4 00 00 00       	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083c:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100842:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100847:	39 c2                	cmp    %eax,%edx
80100849:	0f 84 b0 00 00 00    	je     801008ff <consoleintr+0x154>
        input.e--;
8010084f:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100854:	83 e8 01             	sub    $0x1,%eax
80100857:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
8010085c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100863:	e8 e6 fe ff ff       	call   8010074e <consputc>
      }
      break;
80100868:	e9 93 00 00 00       	jmp    80100900 <consoleintr+0x155>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100871:	0f 84 89 00 00 00    	je     80100900 <consoleintr+0x155>
80100877:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
8010087d:	a1 74 de 10 80       	mov    0x8010de74,%eax
80100882:	89 d1                	mov    %edx,%ecx
80100884:	29 c1                	sub    %eax,%ecx
80100886:	89 c8                	mov    %ecx,%eax
80100888:	83 f8 7f             	cmp    $0x7f,%eax
8010088b:	77 73                	ja     80100900 <consoleintr+0x155>
        c = (c == '\r') ? '\n' : c;
8010088d:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100891:	74 05                	je     80100898 <consoleintr+0xed>
80100893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100896:	eb 05                	jmp    8010089d <consoleintr+0xf2>
80100898:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a0:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008a5:	89 c1                	mov    %eax,%ecx
801008a7:	83 e1 7f             	and    $0x7f,%ecx
801008aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008ad:	88 91 f4 dd 10 80    	mov    %dl,-0x7fef220c(%ecx)
801008b3:	83 c0 01             	add    $0x1,%eax
801008b6:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(c);
801008bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008be:	89 04 24             	mov    %eax,(%esp)
801008c1:	e8 88 fe ff ff       	call   8010074e <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008ca:	74 18                	je     801008e4 <consoleintr+0x139>
801008cc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d0:	74 12                	je     801008e4 <consoleintr+0x139>
801008d2:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008d7:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
801008dd:	83 ea 80             	sub    $0xffffff80,%edx
801008e0:	39 d0                	cmp    %edx,%eax
801008e2:	75 1c                	jne    80100900 <consoleintr+0x155>
          input.w = input.e;
801008e4:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008e9:	a3 78 de 10 80       	mov    %eax,0x8010de78
          wakeup(&input.r);
801008ee:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
801008f5:	e8 25 44 00 00       	call   80104d1f <wakeup>
801008fa:	eb 04                	jmp    80100900 <consoleintr+0x155>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fc:	90                   	nop
801008fd:	eb 01                	jmp    80100900 <consoleintr+0x155>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008ff:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100900:	8b 45 08             	mov    0x8(%ebp),%eax
80100903:	ff d0                	call   *%eax
80100905:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010090c:	0f 89 b0 fe ff ff    	jns    801007c2 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100912:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100919:	e8 96 46 00 00       	call   80104fb4 <release>
}
8010091e:	c9                   	leave  
8010091f:	c3                   	ret    

80100920 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
80100929:	89 04 24             	mov    %eax,(%esp)
8010092c:	e8 c3 10 00 00       	call   801019f4 <iunlock>
  target = n;
80100931:	8b 45 10             	mov    0x10(%ebp),%eax
80100934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&input.lock);
80100937:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010093e:	e8 10 46 00 00       	call   80104f53 <acquire>
  while(n > 0){
80100943:	e9 a8 00 00 00       	jmp    801009f0 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
80100948:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094e:	8b 40 24             	mov    0x24(%eax),%eax
80100951:	85 c0                	test   %eax,%eax
80100953:	74 21                	je     80100976 <consoleread+0x56>
        release(&input.lock);
80100955:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010095c:	e8 53 46 00 00       	call   80104fb4 <release>
        ilock(ip);
80100961:	8b 45 08             	mov    0x8(%ebp),%eax
80100964:	89 04 24             	mov    %eax,(%esp)
80100967:	e8 37 0f 00 00       	call   801018a3 <ilock>
        return -1;
8010096c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100971:	e9 a9 00 00 00       	jmp    80100a1f <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100976:	c7 44 24 04 c0 dd 10 	movl   $0x8010ddc0,0x4(%esp)
8010097d:	80 
8010097e:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
80100985:	e8 4f 42 00 00       	call   80104bd9 <sleep>
8010098a:	eb 01                	jmp    8010098d <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
8010098c:	90                   	nop
8010098d:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
80100993:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100998:	39 c2                	cmp    %eax,%edx
8010099a:	74 ac                	je     80100948 <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010099c:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009a1:	89 c2                	mov    %eax,%edx
801009a3:	83 e2 7f             	and    $0x7f,%edx
801009a6:	0f b6 92 f4 dd 10 80 	movzbl -0x7fef220c(%edx),%edx
801009ad:	0f be d2             	movsbl %dl,%edx
801009b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
801009b3:	83 c0 01             	add    $0x1,%eax
801009b6:	a3 74 de 10 80       	mov    %eax,0x8010de74
    if(c == C('D')){  // EOF
801009bb:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801009bf:	75 17                	jne    801009d8 <consoleread+0xb8>
      if(n < target){
801009c1:	8b 45 10             	mov    0x10(%ebp),%eax
801009c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801009c7:	73 2f                	jae    801009f8 <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c9:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009ce:	83 e8 01             	sub    $0x1,%eax
801009d1:	a3 74 de 10 80       	mov    %eax,0x8010de74
      }
      break;
801009d6:	eb 24                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
801009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009db:	89 c2                	mov    %eax,%edx
801009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e0:	88 10                	mov    %dl,(%eax)
801009e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ea:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801009ee:	74 0b                	je     801009fb <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f4:	7f 96                	jg     8010098c <consoleread+0x6c>
801009f6:	eb 04                	jmp    801009fc <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009f8:	90                   	nop
801009f9:	eb 01                	jmp    801009fc <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
801009fb:	90                   	nop
  }
  release(&input.lock);
801009fc:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100a03:	e8 ac 45 00 00       	call   80104fb4 <release>
  ilock(ip);
80100a08:	8b 45 08             	mov    0x8(%ebp),%eax
80100a0b:	89 04 24             	mov    %eax,(%esp)
80100a0e:	e8 90 0e 00 00       	call   801018a3 <ilock>

  return target - n;
80100a13:	8b 45 10             	mov    0x10(%ebp),%eax
80100a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a19:	89 d1                	mov    %edx,%ecx
80100a1b:	29 c1                	sub    %eax,%ecx
80100a1d:	89 c8                	mov    %ecx,%eax
}
80100a1f:	c9                   	leave  
80100a20:	c3                   	ret    

80100a21 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a21:	55                   	push   %ebp
80100a22:	89 e5                	mov    %esp,%ebp
80100a24:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a27:	8b 45 08             	mov    0x8(%ebp),%eax
80100a2a:	89 04 24             	mov    %eax,(%esp)
80100a2d:	e8 c2 0f 00 00       	call   801019f4 <iunlock>
  acquire(&cons.lock);
80100a32:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a39:	e8 15 45 00 00       	call   80104f53 <acquire>
  for(i = 0; i < n; i++)
80100a3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a45:	eb 1d                	jmp    80100a64 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a4a:	03 45 0c             	add    0xc(%ebp),%eax
80100a4d:	0f b6 00             	movzbl (%eax),%eax
80100a50:	0f be c0             	movsbl %al,%eax
80100a53:	25 ff 00 00 00       	and    $0xff,%eax
80100a58:	89 04 24             	mov    %eax,(%esp)
80100a5b:	e8 ee fc ff ff       	call   8010074e <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a67:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a6a:	7c db                	jl     80100a47 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a6c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a73:	e8 3c 45 00 00       	call   80104fb4 <release>
  ilock(ip);
80100a78:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7b:	89 04 24             	mov    %eax,(%esp)
80100a7e:	e8 20 0e 00 00       	call   801018a3 <ilock>

  return n;
80100a83:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a86:	c9                   	leave  
80100a87:	c3                   	ret    

80100a88 <consoleinit>:

void
consoleinit(void)
{
80100a88:	55                   	push   %ebp
80100a89:	89 e5                	mov    %esp,%ebp
80100a8b:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a8e:	c7 44 24 04 3b 86 10 	movl   $0x8010863b,0x4(%esp)
80100a95:	80 
80100a96:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a9d:	e8 90 44 00 00       	call   80104f32 <initlock>
  initlock(&input.lock, "input");
80100aa2:	c7 44 24 04 43 86 10 	movl   $0x80108643,0x4(%esp)
80100aa9:	80 
80100aaa:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100ab1:	e8 7c 44 00 00       	call   80104f32 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab6:	c7 05 2c e8 10 80 21 	movl   $0x80100a21,0x8010e82c
80100abd:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac0:	c7 05 28 e8 10 80 20 	movl   $0x80100920,0x8010e828
80100ac7:	09 10 80 
  cons.locking = 1;
80100aca:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100ad1:	00 00 00 

  picenable(IRQ_KBD);
80100ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100adb:	e8 d5 2f 00 00       	call   80103ab5 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae7:	00 
80100ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aef:	e8 b2 1e 00 00       	call   801029a6 <ioapicenable>
}
80100af4:	c9                   	leave  
80100af5:	c3                   	ret    
	...

80100af8 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af8:	55                   	push   %ebp
80100af9:	89 e5                	mov    %esp,%ebp
80100afb:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b01:	8b 45 08             	mov    0x8(%ebp),%eax
80100b04:	89 04 24             	mov    %eax,(%esp)
80100b07:	e8 3f 19 00 00       	call   8010244b <namei>
80100b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b13:	75 0a                	jne    80100b1f <exec+0x27>
    return -1;
80100b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1a:	e9 0e 04 00 00       	jmp    80100f2d <exec+0x435>
  ilock(ip);
80100b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b22:	89 04 24             	mov    %eax,(%esp)
80100b25:	e8 79 0d 00 00       	call   801018a3 <ilock>
  pgdir = 0;
80100b2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b31:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b37:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3e:	00 
80100b3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b46:	00 
80100b47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b4e:	89 04 24             	mov    %eax,(%esp)
80100b51:	e8 46 12 00 00       	call   80101d9c <readi>
80100b56:	83 f8 33             	cmp    $0x33,%eax
80100b59:	0f 86 85 03 00 00    	jbe    80100ee4 <exec+0x3ec>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b5f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b65:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6a:	0f 85 77 03 00 00    	jne    80100ee7 <exec+0x3ef>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b70:	e8 10 72 00 00       	call   80107d85 <setupkvm>
80100b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100b7c:	0f 84 68 03 00 00    	je     80100eea <exec+0x3f2>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b82:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  sz = allocuvm(pgdir, sz, PGSIZE);
80100b89:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80100b90:	00 
80100b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b94:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100b9b:	89 04 24             	mov    %eax,(%esp)
80100b9e:	e8 b6 75 00 00       	call   80108159 <allocuvm>
80100ba3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz == 0) goto bad;
80100ba6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100baa:	0f 84 3d 03 00 00    	je     80100eed <exec+0x3f5>

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100bb7:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bbd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100bc0:	e9 ca 00 00 00       	jmp    80100c8f <exec+0x197>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100bc8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bce:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bd5:	00 
80100bd6:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100be1:	89 04 24             	mov    %eax,(%esp)
80100be4:	e8 b3 11 00 00       	call   80101d9c <readi>
80100be9:	83 f8 20             	cmp    $0x20,%eax
80100bec:	0f 85 fe 02 00 00    	jne    80100ef0 <exec+0x3f8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bf2:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bf8:	83 f8 01             	cmp    $0x1,%eax
80100bfb:	0f 85 80 00 00 00    	jne    80100c81 <exec+0x189>
      continue;
    if(ph.memsz < ph.filesz)
80100c01:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c07:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c0d:	39 c2                	cmp    %eax,%edx
80100c0f:	0f 82 de 02 00 00    	jb     80100ef3 <exec+0x3fb>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c15:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c1b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c21:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c32:	89 04 24             	mov    %eax,(%esp)
80100c35:	e8 1f 75 00 00       	call   80108159 <allocuvm>
80100c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c41:	0f 84 af 02 00 00    	je     80100ef6 <exec+0x3fe>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c47:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c4d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c53:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c59:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c61:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100c64:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c68:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c6f:	89 04 24             	mov    %eax,(%esp)
80100c72:	e8 f2 73 00 00       	call   80108069 <loaduvm>
80100c77:	85 c0                	test   %eax,%eax
80100c79:	0f 88 7a 02 00 00    	js     80100ef9 <exec+0x401>
80100c7f:	eb 01                	jmp    80100c82 <exec+0x18a>

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c81:	90                   	nop
  sz = 0;

  sz = allocuvm(pgdir, sz, PGSIZE);
  if(sz == 0) goto bad;

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c82:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80100c86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100c89:	83 c0 20             	add    $0x20,%eax
80100c8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100c8f:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c96:	0f b7 c0             	movzwl %ax,%eax
80100c99:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100c9c:	0f 8f 23 ff ff ff    	jg     80100bc5 <exec+0xcd>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100ca5:	89 04 24             	mov    %eax,(%esp)
80100ca8:	e8 7d 0e 00 00       	call   80101b2a <iunlockput>
  ip = 0;
80100cad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cb7:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cc7:	05 00 20 00 00       	add    $0x2000,%eax
80100ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cda:	89 04 24             	mov    %eax,(%esp)
80100cdd:	e8 77 74 00 00       	call   80108159 <allocuvm>
80100ce2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ce5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100ce9:	0f 84 0d 02 00 00    	je     80100efc <exec+0x404>
    goto bad;
  proc->pstack = (uint *)sz;
80100cef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100cf8:	89 50 7c             	mov    %edx,0x7c(%eax)

  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cfe:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d03:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d0a:	89 04 24             	mov    %eax,(%esp)
80100d0d:	e8 6b 76 00 00       	call   8010837d <clearpteu>

  sp = sz;
80100d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d15:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d18:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100d1f:	e9 81 00 00 00       	jmp    80100da5 <exec+0x2ad>
    if(argc >= MAXARG)
80100d24:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100d28:	0f 87 d1 01 00 00    	ja     80100eff <exec+0x407>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d31:	c1 e0 02             	shl    $0x2,%eax
80100d34:	03 45 0c             	add    0xc(%ebp),%eax
80100d37:	8b 00                	mov    (%eax),%eax
80100d39:	89 04 24             	mov    %eax,(%esp)
80100d3c:	e8 e2 46 00 00       	call   80105423 <strlen>
80100d41:	f7 d0                	not    %eax
80100d43:	03 45 e8             	add    -0x18(%ebp),%eax
80100d46:	83 e0 fc             	and    $0xfffffffc,%eax
80100d49:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4f:	c1 e0 02             	shl    $0x2,%eax
80100d52:	03 45 0c             	add    0xc(%ebp),%eax
80100d55:	8b 00                	mov    (%eax),%eax
80100d57:	89 04 24             	mov    %eax,(%esp)
80100d5a:	e8 c4 46 00 00       	call   80105423 <strlen>
80100d5f:	83 c0 01             	add    $0x1,%eax
80100d62:	89 c2                	mov    %eax,%edx
80100d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d67:	c1 e0 02             	shl    $0x2,%eax
80100d6a:	03 45 0c             	add    0xc(%ebp),%eax
80100d6d:	8b 00                	mov    (%eax),%eax
80100d6f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d73:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d81:	89 04 24             	mov    %eax,(%esp)
80100d84:	e8 b9 77 00 00       	call   80108542 <copyout>
80100d89:	85 c0                	test   %eax,%eax
80100d8b:	0f 88 71 01 00 00    	js     80100f02 <exec+0x40a>
      goto bad;
    ustack[3+argc] = sp;
80100d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d94:	8d 50 03             	lea    0x3(%eax),%edx
80100d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d9a:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100da1:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80100da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da8:	c1 e0 02             	shl    $0x2,%eax
80100dab:	03 45 0c             	add    0xc(%ebp),%eax
80100dae:	8b 00                	mov    (%eax),%eax
80100db0:	85 c0                	test   %eax,%eax
80100db2:	0f 85 6c ff ff ff    	jne    80100d24 <exec+0x22c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dbb:	83 c0 03             	add    $0x3,%eax
80100dbe:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dc5:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc9:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dd0:	ff ff ff 
  ustack[1] = argc;
80100dd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd6:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddf:	83 c0 01             	add    $0x1,%eax
80100de2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100dec:	29 d0                	sub    %edx,%eax
80100dee:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100df4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100df7:	83 c0 04             	add    $0x4,%eax
80100dfa:	c1 e0 02             	shl    $0x2,%eax
80100dfd:	29 45 e8             	sub    %eax,-0x18(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e03:	83 c0 04             	add    $0x4,%eax
80100e06:	c1 e0 02             	shl    $0x2,%eax
80100e09:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e0d:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e13:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e21:	89 04 24             	mov    %eax,(%esp)
80100e24:	e8 19 77 00 00       	call   80108542 <copyout>
80100e29:	85 c0                	test   %eax,%eax
80100e2b:	0f 88 d4 00 00 00    	js     80100f05 <exec+0x40d>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e31:	8b 45 08             	mov    0x8(%ebp),%eax
80100e34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100e37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e3a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e3d:	eb 17                	jmp    80100e56 <exec+0x35e>
    if(*s == '/')
80100e3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e42:	0f b6 00             	movzbl (%eax),%eax
80100e45:	3c 2f                	cmp    $0x2f,%al
80100e47:	75 09                	jne    80100e52 <exec+0x35a>
      last = s+1;
80100e49:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e4c:	83 c0 01             	add    $0x1,%eax
80100e4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e52:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100e56:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e59:	0f b6 00             	movzbl (%eax),%eax
80100e5c:	84 c0                	test   %al,%al
80100e5e:	75 df                	jne    80100e3f <exec+0x347>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e66:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e69:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e70:	00 
80100e71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e78:	89 14 24             	mov    %edx,(%esp)
80100e7b:	e8 55 45 00 00       	call   801053d5 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e86:	8b 40 04             	mov    0x4(%eax),%eax
80100e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->pgdir = pgdir;
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100e95:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100ea1:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ea3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea9:	8b 40 18             	mov    0x18(%eax),%eax
80100eac:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eb2:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebb:	8b 40 18             	mov    0x18(%eax),%eax
80100ebe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100ec1:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ec4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eca:	89 04 24             	mov    %eax,(%esp)
80100ecd:	e8 a5 6f 00 00       	call   80107e77 <switchuvm>
  freevm(oldpgdir);
80100ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ed5:	89 04 24             	mov    %eax,(%esp)
80100ed8:	e8 12 74 00 00       	call   801082ef <freevm>
  return 0;
80100edd:	b8 00 00 00 00       	mov    $0x0,%eax
80100ee2:	eb 49                	jmp    80100f2d <exec+0x435>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100ee4:	90                   	nop
80100ee5:	eb 1f                	jmp    80100f06 <exec+0x40e>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100ee7:	90                   	nop
80100ee8:	eb 1c                	jmp    80100f06 <exec+0x40e>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100eea:	90                   	nop
80100eeb:	eb 19                	jmp    80100f06 <exec+0x40e>

  // Load program into memory.
  sz = 0;

  sz = allocuvm(pgdir, sz, PGSIZE);
  if(sz == 0) goto bad;
80100eed:	90                   	nop
80100eee:	eb 16                	jmp    80100f06 <exec+0x40e>

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ef0:	90                   	nop
80100ef1:	eb 13                	jmp    80100f06 <exec+0x40e>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ef3:	90                   	nop
80100ef4:	eb 10                	jmp    80100f06 <exec+0x40e>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ef6:	90                   	nop
80100ef7:	eb 0d                	jmp    80100f06 <exec+0x40e>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ef9:	90                   	nop
80100efa:	eb 0a                	jmp    80100f06 <exec+0x40e>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100efc:	90                   	nop
80100efd:	eb 07                	jmp    80100f06 <exec+0x40e>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100eff:	90                   	nop
80100f00:	eb 04                	jmp    80100f06 <exec+0x40e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100f02:	90                   	nop
80100f03:	eb 01                	jmp    80100f06 <exec+0x40e>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100f05:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100f0a:	74 0b                	je     80100f17 <exec+0x41f>
    freevm(pgdir);
80100f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 d8 73 00 00       	call   801082ef <freevm>
  if(ip)
80100f17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100f1b:	74 0b                	je     80100f28 <exec+0x430>
    iunlockput(ip);
80100f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100f20:	89 04 24             	mov    %eax,(%esp)
80100f23:	e8 02 0c 00 00       	call   80101b2a <iunlockput>
  return -1;
80100f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2d:	c9                   	leave  
80100f2e:	c3                   	ret    
	...

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	c7 44 24 04 49 86 10 	movl   $0x80108649,0x4(%esp)
80100f3d:	80 
80100f3e:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f45:	e8 e8 3f 00 00       	call   80104f32 <initlock>
}
80100f4a:	c9                   	leave  
80100f4b:	c3                   	ret    

80100f4c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f4c:	55                   	push   %ebp
80100f4d:	89 e5                	mov    %esp,%ebp
80100f4f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f52:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f59:	e8 f5 3f 00 00       	call   80104f53 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5e:	c7 45 f4 b4 de 10 80 	movl   $0x8010deb4,-0xc(%ebp)
80100f65:	eb 29                	jmp    80100f90 <filealloc+0x44>
    if(f->ref == 0){
80100f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6a:	8b 40 04             	mov    0x4(%eax),%eax
80100f6d:	85 c0                	test   %eax,%eax
80100f6f:	75 1b                	jne    80100f8c <filealloc+0x40>
      f->ref = 1;
80100f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f74:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f7b:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f82:	e8 2d 40 00 00       	call   80104fb4 <release>
      return f;
80100f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8a:	eb 1f                	jmp    80100fab <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f8c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f90:	b8 14 e8 10 80       	mov    $0x8010e814,%eax
80100f95:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f98:	72 cd                	jb     80100f67 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f9a:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fa1:	e8 0e 40 00 00       	call   80104fb4 <release>
  return 0;
80100fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fab:	c9                   	leave  
80100fac:	c3                   	ret    

80100fad <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fad:	55                   	push   %ebp
80100fae:	89 e5                	mov    %esp,%ebp
80100fb0:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fb3:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fba:	e8 94 3f 00 00       	call   80104f53 <acquire>
  if(f->ref < 1)
80100fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc2:	8b 40 04             	mov    0x4(%eax),%eax
80100fc5:	85 c0                	test   %eax,%eax
80100fc7:	7f 0c                	jg     80100fd5 <filedup+0x28>
    panic("filedup");
80100fc9:	c7 04 24 50 86 10 80 	movl   $0x80108650,(%esp)
80100fd0:	e8 65 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd8:	8b 40 04             	mov    0x4(%eax),%eax
80100fdb:	8d 50 01             	lea    0x1(%eax),%edx
80100fde:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe1:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe4:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100feb:	e8 c4 3f 00 00       	call   80104fb4 <release>
  return f;
80100ff0:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100ff3:	c9                   	leave  
80100ff4:	c3                   	ret    

80100ff5 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff5:	55                   	push   %ebp
80100ff6:	89 e5                	mov    %esp,%ebp
80100ff8:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ffb:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80101002:	e8 4c 3f 00 00       	call   80104f53 <acquire>
  if(f->ref < 1)
80101007:	8b 45 08             	mov    0x8(%ebp),%eax
8010100a:	8b 40 04             	mov    0x4(%eax),%eax
8010100d:	85 c0                	test   %eax,%eax
8010100f:	7f 0c                	jg     8010101d <fileclose+0x28>
    panic("fileclose");
80101011:	c7 04 24 58 86 10 80 	movl   $0x80108658,(%esp)
80101018:	e8 1d f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
8010101d:	8b 45 08             	mov    0x8(%ebp),%eax
80101020:	8b 40 04             	mov    0x4(%eax),%eax
80101023:	8d 50 ff             	lea    -0x1(%eax),%edx
80101026:	8b 45 08             	mov    0x8(%ebp),%eax
80101029:	89 50 04             	mov    %edx,0x4(%eax)
8010102c:	8b 45 08             	mov    0x8(%ebp),%eax
8010102f:	8b 40 04             	mov    0x4(%eax),%eax
80101032:	85 c0                	test   %eax,%eax
80101034:	7e 11                	jle    80101047 <fileclose+0x52>
    release(&ftable.lock);
80101036:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
8010103d:	e8 72 3f 00 00       	call   80104fb4 <release>
    return;
80101042:	e9 82 00 00 00       	jmp    801010c9 <fileclose+0xd4>
  }
  ff = *f;
80101047:	8b 45 08             	mov    0x8(%ebp),%eax
8010104a:	8b 10                	mov    (%eax),%edx
8010104c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010104f:	8b 50 04             	mov    0x4(%eax),%edx
80101052:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101055:	8b 50 08             	mov    0x8(%eax),%edx
80101058:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010105b:	8b 50 0c             	mov    0xc(%eax),%edx
8010105e:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101061:	8b 50 10             	mov    0x10(%eax),%edx
80101064:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101067:	8b 40 14             	mov    0x14(%eax),%eax
8010106a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010106d:	8b 45 08             	mov    0x8(%ebp),%eax
80101070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101077:	8b 45 08             	mov    0x8(%ebp),%eax
8010107a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101080:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80101087:	e8 28 3f 00 00       	call   80104fb4 <release>
  
  if(ff.type == FD_PIPE)
8010108c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108f:	83 f8 01             	cmp    $0x1,%eax
80101092:	75 18                	jne    801010ac <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101094:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101098:	0f be d0             	movsbl %al,%edx
8010109b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010109e:	89 54 24 04          	mov    %edx,0x4(%esp)
801010a2:	89 04 24             	mov    %eax,(%esp)
801010a5:	e8 c5 2c 00 00       	call   80103d6f <pipeclose>
801010aa:	eb 1d                	jmp    801010c9 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 15                	jne    801010c9 <fileclose+0xd4>
    begin_trans();
801010b4:	e8 81 21 00 00       	call   8010323a <begin_trans>
    iput(ff.ip);
801010b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010bc:	89 04 24             	mov    %eax,(%esp)
801010bf:	e8 95 09 00 00       	call   80101a59 <iput>
    commit_trans();
801010c4:	e8 ba 21 00 00       	call   80103283 <commit_trans>
  }
}
801010c9:	c9                   	leave  
801010ca:	c3                   	ret    

801010cb <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010cb:	55                   	push   %ebp
801010cc:	89 e5                	mov    %esp,%ebp
801010ce:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010d1:	8b 45 08             	mov    0x8(%ebp),%eax
801010d4:	8b 00                	mov    (%eax),%eax
801010d6:	83 f8 02             	cmp    $0x2,%eax
801010d9:	75 38                	jne    80101113 <filestat+0x48>
    ilock(f->ip);
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	8b 40 10             	mov    0x10(%eax),%eax
801010e1:	89 04 24             	mov    %eax,(%esp)
801010e4:	e8 ba 07 00 00       	call   801018a3 <ilock>
    stati(f->ip, st);
801010e9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ec:	8b 40 10             	mov    0x10(%eax),%eax
801010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801010f2:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f6:	89 04 24             	mov    %eax,(%esp)
801010f9:	e8 59 0c 00 00       	call   80101d57 <stati>
    iunlock(f->ip);
801010fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101101:	8b 40 10             	mov    0x10(%eax),%eax
80101104:	89 04 24             	mov    %eax,(%esp)
80101107:	e8 e8 08 00 00       	call   801019f4 <iunlock>
    return 0;
8010110c:	b8 00 00 00 00       	mov    $0x0,%eax
80101111:	eb 05                	jmp    80101118 <filestat+0x4d>
  }
  return -1;
80101113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101118:	c9                   	leave  
80101119:	c3                   	ret    

8010111a <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010111a:	55                   	push   %ebp
8010111b:	89 e5                	mov    %esp,%ebp
8010111d:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101120:	8b 45 08             	mov    0x8(%ebp),%eax
80101123:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101127:	84 c0                	test   %al,%al
80101129:	75 0a                	jne    80101135 <fileread+0x1b>
    return -1;
8010112b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101130:	e9 9f 00 00 00       	jmp    801011d4 <fileread+0xba>
  if(f->type == FD_PIPE)
80101135:	8b 45 08             	mov    0x8(%ebp),%eax
80101138:	8b 00                	mov    (%eax),%eax
8010113a:	83 f8 01             	cmp    $0x1,%eax
8010113d:	75 1e                	jne    8010115d <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	8b 40 0c             	mov    0xc(%eax),%eax
80101145:	8b 55 10             	mov    0x10(%ebp),%edx
80101148:	89 54 24 08          	mov    %edx,0x8(%esp)
8010114c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010114f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101153:	89 04 24             	mov    %eax,(%esp)
80101156:	e8 96 2d 00 00       	call   80103ef1 <piperead>
8010115b:	eb 77                	jmp    801011d4 <fileread+0xba>
  if(f->type == FD_INODE){
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	8b 00                	mov    (%eax),%eax
80101162:	83 f8 02             	cmp    $0x2,%eax
80101165:	75 61                	jne    801011c8 <fileread+0xae>
    ilock(f->ip);
80101167:	8b 45 08             	mov    0x8(%ebp),%eax
8010116a:	8b 40 10             	mov    0x10(%eax),%eax
8010116d:	89 04 24             	mov    %eax,(%esp)
80101170:	e8 2e 07 00 00       	call   801018a3 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101175:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	8b 50 14             	mov    0x14(%eax),%edx
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	8b 40 10             	mov    0x10(%eax),%eax
80101184:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101188:	89 54 24 08          	mov    %edx,0x8(%esp)
8010118c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010118f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101193:	89 04 24             	mov    %eax,(%esp)
80101196:	e8 01 0c 00 00       	call   80101d9c <readi>
8010119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010119e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011a2:	7e 11                	jle    801011b5 <fileread+0x9b>
      f->off += r;
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	8b 50 14             	mov    0x14(%eax),%edx
801011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ad:	01 c2                	add    %eax,%edx
801011af:	8b 45 08             	mov    0x8(%ebp),%eax
801011b2:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 40 10             	mov    0x10(%eax),%eax
801011bb:	89 04 24             	mov    %eax,(%esp)
801011be:	e8 31 08 00 00       	call   801019f4 <iunlock>
    return r;
801011c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c6:	eb 0c                	jmp    801011d4 <fileread+0xba>
  }
  panic("fileread");
801011c8:	c7 04 24 62 86 10 80 	movl   $0x80108662,(%esp)
801011cf:	e8 66 f3 ff ff       	call   8010053a <panic>
}
801011d4:	c9                   	leave  
801011d5:	c3                   	ret    

801011d6 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d6:	55                   	push   %ebp
801011d7:	89 e5                	mov    %esp,%ebp
801011d9:	53                   	push   %ebx
801011da:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e4:	84 c0                	test   %al,%al
801011e6:	75 0a                	jne    801011f2 <filewrite+0x1c>
    return -1;
801011e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ed:	e9 23 01 00 00       	jmp    80101315 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011f2:	8b 45 08             	mov    0x8(%ebp),%eax
801011f5:	8b 00                	mov    (%eax),%eax
801011f7:	83 f8 01             	cmp    $0x1,%eax
801011fa:	75 21                	jne    8010121d <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 40 0c             	mov    0xc(%eax),%eax
80101202:	8b 55 10             	mov    0x10(%ebp),%edx
80101205:	89 54 24 08          	mov    %edx,0x8(%esp)
80101209:	8b 55 0c             	mov    0xc(%ebp),%edx
8010120c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101210:	89 04 24             	mov    %eax,(%esp)
80101213:	e8 e9 2b 00 00       	call   80103e01 <pipewrite>
80101218:	e9 f8 00 00 00       	jmp    80101315 <filewrite+0x13f>
  if(f->type == FD_INODE){
8010121d:	8b 45 08             	mov    0x8(%ebp),%eax
80101220:	8b 00                	mov    (%eax),%eax
80101222:	83 f8 02             	cmp    $0x2,%eax
80101225:	0f 85 de 00 00 00    	jne    80101309 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010122b:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101232:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
80101239:	e9 a8 00 00 00       	jmp    801012e6 <filewrite+0x110>
      int n1 = n - i;
8010123e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101241:	8b 55 10             	mov    0x10(%ebp),%edx
80101244:	89 d1                	mov    %edx,%ecx
80101246:	29 c1                	sub    %eax,%ecx
80101248:	89 c8                	mov    %ecx,%eax
8010124a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
8010124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101250:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101253:	7e 06                	jle    8010125b <filewrite+0x85>
        n1 = max;
80101255:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101258:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_trans();
8010125b:	e8 da 1f 00 00       	call   8010323a <begin_trans>
      ilock(f->ip);
80101260:	8b 45 08             	mov    0x8(%ebp),%eax
80101263:	8b 40 10             	mov    0x10(%eax),%eax
80101266:	89 04 24             	mov    %eax,(%esp)
80101269:	e8 35 06 00 00       	call   801018a3 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 48 14             	mov    0x14(%eax),%ecx
80101277:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127a:	89 c2                	mov    %eax,%edx
8010127c:	03 55 0c             	add    0xc(%ebp),%edx
8010127f:	8b 45 08             	mov    0x8(%ebp),%eax
80101282:	8b 40 10             	mov    0x10(%eax),%eax
80101285:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101289:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010128d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101291:	89 04 24             	mov    %eax,(%esp)
80101294:	e8 6f 0c 00 00       	call   80101f08 <writei>
80101299:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010129c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012a0:	7e 11                	jle    801012b3 <filewrite+0xdd>
        f->off += r;
801012a2:	8b 45 08             	mov    0x8(%ebp),%eax
801012a5:	8b 50 14             	mov    0x14(%eax),%edx
801012a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ab:	01 c2                	add    %eax,%edx
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 40 10             	mov    0x10(%eax),%eax
801012b9:	89 04 24             	mov    %eax,(%esp)
801012bc:	e8 33 07 00 00       	call   801019f4 <iunlock>
      commit_trans();
801012c1:	e8 bd 1f 00 00       	call   80103283 <commit_trans>

      if(r < 0)
801012c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012ca:	78 28                	js     801012f4 <filewrite+0x11e>
        break;
      if(r != n1)
801012cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801012d2:	74 0c                	je     801012e0 <filewrite+0x10a>
        panic("short filewrite");
801012d4:	c7 04 24 6b 86 10 80 	movl   $0x8010866b,(%esp)
801012db:	e8 5a f2 ff ff       	call   8010053a <panic>
      i += r;
801012e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e3:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012e9:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ec:	0f 8c 4c ff ff ff    	jl     8010123e <filewrite+0x68>
801012f2:	eb 01                	jmp    801012f5 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012f4:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012f8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012fb:	75 05                	jne    80101302 <filewrite+0x12c>
801012fd:	8b 45 10             	mov    0x10(%ebp),%eax
80101300:	eb 05                	jmp    80101307 <filewrite+0x131>
80101302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101307:	eb 0c                	jmp    80101315 <filewrite+0x13f>
  }
  panic("filewrite");
80101309:	c7 04 24 7b 86 10 80 	movl   $0x8010867b,(%esp)
80101310:	e8 25 f2 ff ff       	call   8010053a <panic>
}
80101315:	83 c4 24             	add    $0x24,%esp
80101318:	5b                   	pop    %ebx
80101319:	5d                   	pop    %ebp
8010131a:	c3                   	ret    
	...

8010131c <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010131c:	55                   	push   %ebp
8010131d:	89 e5                	mov    %esp,%ebp
8010131f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101322:	8b 45 08             	mov    0x8(%ebp),%eax
80101325:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010132c:	00 
8010132d:	89 04 24             	mov    %eax,(%esp)
80101330:	e8 72 ee ff ff       	call   801001a7 <bread>
80101335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133b:	83 c0 18             	add    $0x18,%eax
8010133e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101345:	00 
80101346:	89 44 24 04          	mov    %eax,0x4(%esp)
8010134a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010134d:	89 04 24             	mov    %eax,(%esp)
80101350:	e8 20 3f 00 00       	call   80105275 <memmove>
  brelse(bp);
80101355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101358:	89 04 24             	mov    %eax,(%esp)
8010135b:	e8 b8 ee ff ff       	call   80100218 <brelse>
}
80101360:	c9                   	leave  
80101361:	c3                   	ret    

80101362 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101362:	55                   	push   %ebp
80101363:	89 e5                	mov    %esp,%ebp
80101365:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101372:	89 04 24             	mov    %eax,(%esp)
80101375:	e8 2d ee ff ff       	call   801001a7 <bread>
8010137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010137d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101380:	83 c0 18             	add    $0x18,%eax
80101383:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010138a:	00 
8010138b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101392:	00 
80101393:	89 04 24             	mov    %eax,(%esp)
80101396:	e8 07 3e 00 00       	call   801051a2 <memset>
  log_write(bp);
8010139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139e:	89 04 24             	mov    %eax,(%esp)
801013a1:	e8 35 1f 00 00       	call   801032db <log_write>
  brelse(bp);
801013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a9:	89 04 24             	mov    %eax,(%esp)
801013ac:	e8 67 ee ff ff       	call   80100218 <brelse>
}
801013b1:	c9                   	leave  
801013b2:	c3                   	ret    

801013b3 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013b3:	55                   	push   %ebp
801013b4:	89 e5                	mov    %esp,%ebp
801013b6:	53                   	push   %ebx
801013b7:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  readsb(dev, &sb);
801013c1:	8b 45 08             	mov    0x8(%ebp),%eax
801013c4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013cb:	89 04 24             	mov    %eax,(%esp)
801013ce:	e8 49 ff ff ff       	call   8010131c <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013da:	e9 15 01 00 00       	jmp    801014f4 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013e2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013e8:	85 c0                	test   %eax,%eax
801013ea:	0f 48 c2             	cmovs  %edx,%eax
801013ed:	c1 f8 0c             	sar    $0xc,%eax
801013f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013f3:	c1 ea 03             	shr    $0x3,%edx
801013f6:	01 d0                	add    %edx,%eax
801013f8:	83 c0 03             	add    $0x3,%eax
801013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101402:	89 04 24             	mov    %eax,(%esp)
80101405:	e8 9d ed ff ff       	call   801001a7 <bread>
8010140a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010140d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101414:	e9 aa 00 00 00       	jmp    801014c3 <balloc+0x110>
      m = 1 << (bi % 8);
80101419:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010141c:	89 c2                	mov    %eax,%edx
8010141e:	c1 fa 1f             	sar    $0x1f,%edx
80101421:	c1 ea 1d             	shr    $0x1d,%edx
80101424:	01 d0                	add    %edx,%eax
80101426:	83 e0 07             	and    $0x7,%eax
80101429:	29 d0                	sub    %edx,%eax
8010142b:	ba 01 00 00 00       	mov    $0x1,%edx
80101430:	89 d3                	mov    %edx,%ebx
80101432:	89 c1                	mov    %eax,%ecx
80101434:	d3 e3                	shl    %cl,%ebx
80101436:	89 d8                	mov    %ebx,%eax
80101438:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010143b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010143e:	8d 50 07             	lea    0x7(%eax),%edx
80101441:	85 c0                	test   %eax,%eax
80101443:	0f 48 c2             	cmovs  %edx,%eax
80101446:	c1 f8 03             	sar    $0x3,%eax
80101449:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010144c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101451:	0f b6 c0             	movzbl %al,%eax
80101454:	23 45 f0             	and    -0x10(%ebp),%eax
80101457:	85 c0                	test   %eax,%eax
80101459:	75 64                	jne    801014bf <balloc+0x10c>
        bp->data[bi/8] |= m;  // Mark block in use.
8010145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145e:	8d 50 07             	lea    0x7(%eax),%edx
80101461:	85 c0                	test   %eax,%eax
80101463:	0f 48 c2             	cmovs  %edx,%eax
80101466:	c1 f8 03             	sar    $0x3,%eax
80101469:	89 c2                	mov    %eax,%edx
8010146b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010146e:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
80101473:	89 c1                	mov    %eax,%ecx
80101475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101478:	09 c8                	or     %ecx,%eax
8010147a:	89 c1                	mov    %eax,%ecx
8010147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147f:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
80101483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101486:	89 04 24             	mov    %eax,(%esp)
80101489:	e8 4d 1e 00 00       	call   801032db <log_write>
        brelse(bp);
8010148e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101491:	89 04 24             	mov    %eax,(%esp)
80101494:	e8 7f ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
80101499:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010149f:	01 c2                	add    %eax,%edx
801014a1:	8b 45 08             	mov    0x8(%ebp),%eax
801014a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801014a8:	89 04 24             	mov    %eax,(%esp)
801014ab:	e8 b2 fe ff ff       	call   80101362 <bzero>
        return b + bi;
801014b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014b6:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014b9:	83 c4 34             	add    $0x34,%esp
801014bc:	5b                   	pop    %ebx
801014bd:	5d                   	pop    %ebp
801014be:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014bf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801014c3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801014ca:	7f 16                	jg     801014e2 <balloc+0x12f>
801014cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014d2:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014da:	39 c2                	cmp    %eax,%edx
801014dc:	0f 82 37 ff ff ff    	jb     80101419 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e5:	89 04 24             	mov    %eax,(%esp)
801014e8:	e8 2b ed ff ff       	call   80100218 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014ed:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014fa:	39 c2                	cmp    %eax,%edx
801014fc:	0f 82 dd fe ff ff    	jb     801013df <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101502:	c7 04 24 85 86 10 80 	movl   $0x80108685,(%esp)
80101509:	e8 2c f0 ff ff       	call   8010053a <panic>

8010150e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010150e:	55                   	push   %ebp
8010150f:	89 e5                	mov    %esp,%ebp
80101511:	53                   	push   %ebx
80101512:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101515:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101518:	89 44 24 04          	mov    %eax,0x4(%esp)
8010151c:	8b 45 08             	mov    0x8(%ebp),%eax
8010151f:	89 04 24             	mov    %eax,(%esp)
80101522:	e8 f5 fd ff ff       	call   8010131c <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101527:	8b 45 0c             	mov    0xc(%ebp),%eax
8010152a:	89 c2                	mov    %eax,%edx
8010152c:	c1 ea 0c             	shr    $0xc,%edx
8010152f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101532:	c1 e8 03             	shr    $0x3,%eax
80101535:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101538:	8d 50 03             	lea    0x3(%eax),%edx
8010153b:	8b 45 08             	mov    0x8(%ebp),%eax
8010153e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101542:	89 04 24             	mov    %eax,(%esp)
80101545:	e8 5d ec ff ff       	call   801001a7 <bread>
8010154a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
8010154d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101550:	25 ff 0f 00 00       	and    $0xfff,%eax
80101555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101558:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155b:	89 c2                	mov    %eax,%edx
8010155d:	c1 fa 1f             	sar    $0x1f,%edx
80101560:	c1 ea 1d             	shr    $0x1d,%edx
80101563:	01 d0                	add    %edx,%eax
80101565:	83 e0 07             	and    $0x7,%eax
80101568:	29 d0                	sub    %edx,%eax
8010156a:	ba 01 00 00 00       	mov    $0x1,%edx
8010156f:	89 d3                	mov    %edx,%ebx
80101571:	89 c1                	mov    %eax,%ecx
80101573:	d3 e3                	shl    %cl,%ebx
80101575:	89 d8                	mov    %ebx,%eax
80101577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157d:	8d 50 07             	lea    0x7(%eax),%edx
80101580:	85 c0                	test   %eax,%eax
80101582:	0f 48 c2             	cmovs  %edx,%eax
80101585:	c1 f8 03             	sar    $0x3,%eax
80101588:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010158b:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101590:	0f b6 c0             	movzbl %al,%eax
80101593:	23 45 f4             	and    -0xc(%ebp),%eax
80101596:	85 c0                	test   %eax,%eax
80101598:	75 0c                	jne    801015a6 <bfree+0x98>
    panic("freeing free block");
8010159a:	c7 04 24 9b 86 10 80 	movl   $0x8010869b,(%esp)
801015a1:	e8 94 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
801015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a9:	8d 50 07             	lea    0x7(%eax),%edx
801015ac:	85 c0                	test   %eax,%eax
801015ae:	0f 48 c2             	cmovs  %edx,%eax
801015b1:	c1 f8 03             	sar    $0x3,%eax
801015b4:	89 c2                	mov    %eax,%edx
801015b6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015b9:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
801015be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801015c1:	f7 d1                	not    %ecx
801015c3:	21 c8                	and    %ecx,%eax
801015c5:	89 c1                	mov    %eax,%ecx
801015c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ca:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
801015ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015d1:	89 04 24             	mov    %eax,(%esp)
801015d4:	e8 02 1d 00 00       	call   801032db <log_write>
  brelse(bp);
801015d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015dc:	89 04 24             	mov    %eax,(%esp)
801015df:	e8 34 ec ff ff       	call   80100218 <brelse>
}
801015e4:	83 c4 34             	add    $0x34,%esp
801015e7:	5b                   	pop    %ebx
801015e8:	5d                   	pop    %ebp
801015e9:	c3                   	ret    

801015ea <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015ea:	55                   	push   %ebp
801015eb:	89 e5                	mov    %esp,%ebp
801015ed:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015f0:	c7 44 24 04 ae 86 10 	movl   $0x801086ae,0x4(%esp)
801015f7:	80 
801015f8:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801015ff:	e8 2e 39 00 00       	call   80104f32 <initlock>
}
80101604:	c9                   	leave  
80101605:	c3                   	ret    

80101606 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101606:	55                   	push   %ebp
80101607:	89 e5                	mov    %esp,%ebp
80101609:	83 ec 48             	sub    $0x48,%esp
8010160c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010160f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101613:	8b 45 08             	mov    0x8(%ebp),%eax
80101616:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101619:	89 54 24 04          	mov    %edx,0x4(%esp)
8010161d:	89 04 24             	mov    %eax,(%esp)
80101620:	e8 f7 fc ff ff       	call   8010131c <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101625:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010162c:	e9 98 00 00 00       	jmp    801016c9 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101631:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101634:	c1 e8 03             	shr    $0x3,%eax
80101637:	83 c0 02             	add    $0x2,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 45 08             	mov    0x8(%ebp),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 5e eb ff ff       	call   801001a7 <bread>
80101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164f:	83 c0 18             	add    $0x18,%eax
80101652:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101655:	83 e2 07             	and    $0x7,%edx
80101658:	c1 e2 06             	shl    $0x6,%edx
8010165b:	01 d0                	add    %edx,%eax
8010165d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
80101660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101663:	0f b7 00             	movzwl (%eax),%eax
80101666:	66 85 c0             	test   %ax,%ax
80101669:	75 4f                	jne    801016ba <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010166b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101672:	00 
80101673:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010167a:	00 
8010167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010167e:	89 04 24             	mov    %eax,(%esp)
80101681:	e8 1c 3b 00 00       	call   801051a2 <memset>
      dip->type = type;
80101686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101689:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010168d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101690:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101693:	89 04 24             	mov    %eax,(%esp)
80101696:	e8 40 1c 00 00       	call   801032db <log_write>
      brelse(bp);
8010169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169e:	89 04 24             	mov    %eax,(%esp)
801016a1:	e8 72 eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
801016a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ad:	8b 45 08             	mov    0x8(%ebp),%eax
801016b0:	89 04 24             	mov    %eax,(%esp)
801016b3:	e8 e6 00 00 00       	call   8010179e <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016b8:	c9                   	leave  
801016b9:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016bd:	89 04 24             	mov    %eax,(%esp)
801016c0:	e8 53 eb ff ff       	call   80100218 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801016c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016cf:	39 c2                	cmp    %eax,%edx
801016d1:	0f 82 5a ff ff ff    	jb     80101631 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016d7:	c7 04 24 b5 86 10 80 	movl   $0x801086b5,(%esp)
801016de:	e8 57 ee ff ff       	call   8010053a <panic>

801016e3 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016e3:	55                   	push   %ebp
801016e4:	89 e5                	mov    %esp,%ebp
801016e6:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	8b 40 04             	mov    0x4(%eax),%eax
801016ef:	c1 e8 03             	shr    $0x3,%eax
801016f2:	8d 50 02             	lea    0x2(%eax),%edx
801016f5:	8b 45 08             	mov    0x8(%ebp),%eax
801016f8:	8b 00                	mov    (%eax),%eax
801016fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801016fe:	89 04 24             	mov    %eax,(%esp)
80101701:	e8 a1 ea ff ff       	call   801001a7 <bread>
80101706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170c:	83 c0 18             	add    $0x18,%eax
8010170f:	89 c2                	mov    %eax,%edx
80101711:	8b 45 08             	mov    0x8(%ebp),%eax
80101714:	8b 40 04             	mov    0x4(%eax),%eax
80101717:	83 e0 07             	and    $0x7,%eax
8010171a:	c1 e0 06             	shl    $0x6,%eax
8010171d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
80101723:	8b 45 08             	mov    0x8(%ebp),%eax
80101726:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101730:	8b 45 08             	mov    0x8(%ebp),%eax
80101733:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010173a:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010173e:	8b 45 08             	mov    0x8(%ebp),%eax
80101741:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101748:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010174c:	8b 45 08             	mov    0x8(%ebp),%eax
8010174f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101756:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010175a:	8b 45 08             	mov    0x8(%ebp),%eax
8010175d:	8b 50 18             	mov    0x18(%eax),%edx
80101760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101763:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101766:	8b 45 08             	mov    0x8(%ebp),%eax
80101769:	8d 50 1c             	lea    0x1c(%eax),%edx
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	83 c0 0c             	add    $0xc,%eax
80101772:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101779:	00 
8010177a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010177e:	89 04 24             	mov    %eax,(%esp)
80101781:	e8 ef 3a 00 00       	call   80105275 <memmove>
  log_write(bp);
80101786:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101789:	89 04 24             	mov    %eax,(%esp)
8010178c:	e8 4a 1b 00 00       	call   801032db <log_write>
  brelse(bp);
80101791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101794:	89 04 24             	mov    %eax,(%esp)
80101797:	e8 7c ea ff ff       	call   80100218 <brelse>
}
8010179c:	c9                   	leave  
8010179d:	c3                   	ret    

8010179e <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010179e:	55                   	push   %ebp
8010179f:	89 e5                	mov    %esp,%ebp
801017a1:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017a4:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801017ab:	e8 a3 37 00 00       	call   80104f53 <acquire>

  // Is the inode already cached?
  empty = 0;
801017b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b7:	c7 45 f0 b4 e8 10 80 	movl   $0x8010e8b4,-0x10(%ebp)
801017be:	eb 59                	jmp    80101819 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c3:	8b 40 08             	mov    0x8(%eax),%eax
801017c6:	85 c0                	test   %eax,%eax
801017c8:	7e 35                	jle    801017ff <iget+0x61>
801017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017cd:	8b 00                	mov    (%eax),%eax
801017cf:	3b 45 08             	cmp    0x8(%ebp),%eax
801017d2:	75 2b                	jne    801017ff <iget+0x61>
801017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d7:	8b 40 04             	mov    0x4(%eax),%eax
801017da:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017dd:	75 20                	jne    801017ff <iget+0x61>
      ip->ref++;
801017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e2:	8b 40 08             	mov    0x8(%eax),%eax
801017e5:	8d 50 01             	lea    0x1(%eax),%edx
801017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017eb:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017ee:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801017f5:	e8 ba 37 00 00       	call   80104fb4 <release>
      return ip;
801017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fd:	eb 70                	jmp    8010186f <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101803:	75 10                	jne    80101815 <iget+0x77>
80101805:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101808:	8b 40 08             	mov    0x8(%eax),%eax
8010180b:	85 c0                	test   %eax,%eax
8010180d:	75 06                	jne    80101815 <iget+0x77>
      empty = ip;
8010180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101812:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101815:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
80101819:	b8 54 f8 10 80       	mov    $0x8010f854,%eax
8010181e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80101821:	72 9d                	jb     801017c0 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101827:	75 0c                	jne    80101835 <iget+0x97>
    panic("iget: no inodes");
80101829:	c7 04 24 c7 86 10 80 	movl   $0x801086c7,(%esp)
80101830:	e8 05 ed ff ff       	call   8010053a <panic>

  ip = empty;
80101835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101838:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
8010183b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183e:	8b 55 08             	mov    0x8(%ebp),%edx
80101841:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101846:	8b 55 0c             	mov    0xc(%ebp),%edx
80101849:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101856:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101859:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101860:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101867:	e8 48 37 00 00       	call   80104fb4 <release>

  return ip;
8010186c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010186f:	c9                   	leave  
80101870:	c3                   	ret    

80101871 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101871:	55                   	push   %ebp
80101872:	89 e5                	mov    %esp,%ebp
80101874:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101877:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010187e:	e8 d0 36 00 00       	call   80104f53 <acquire>
  ip->ref++;
80101883:	8b 45 08             	mov    0x8(%ebp),%eax
80101886:	8b 40 08             	mov    0x8(%eax),%eax
80101889:	8d 50 01             	lea    0x1(%eax),%edx
8010188c:	8b 45 08             	mov    0x8(%ebp),%eax
8010188f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101892:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101899:	e8 16 37 00 00       	call   80104fb4 <release>
  return ip;
8010189e:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018a1:	c9                   	leave  
801018a2:	c3                   	ret    

801018a3 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018a3:	55                   	push   %ebp
801018a4:	89 e5                	mov    %esp,%ebp
801018a6:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018ad:	74 0a                	je     801018b9 <ilock+0x16>
801018af:	8b 45 08             	mov    0x8(%ebp),%eax
801018b2:	8b 40 08             	mov    0x8(%eax),%eax
801018b5:	85 c0                	test   %eax,%eax
801018b7:	7f 0c                	jg     801018c5 <ilock+0x22>
    panic("ilock");
801018b9:	c7 04 24 d7 86 10 80 	movl   $0x801086d7,(%esp)
801018c0:	e8 75 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018c5:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801018cc:	e8 82 36 00 00       	call   80104f53 <acquire>
  while(ip->flags & I_BUSY)
801018d1:	eb 13                	jmp    801018e6 <ilock+0x43>
    sleep(ip, &icache.lock);
801018d3:	c7 44 24 04 80 e8 10 	movl   $0x8010e880,0x4(%esp)
801018da:	80 
801018db:	8b 45 08             	mov    0x8(%ebp),%eax
801018de:	89 04 24             	mov    %eax,(%esp)
801018e1:	e8 f3 32 00 00       	call   80104bd9 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 0c             	mov    0xc(%eax),%eax
801018ec:	83 e0 01             	and    $0x1,%eax
801018ef:	84 c0                	test   %al,%al
801018f1:	75 e0                	jne    801018d3 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018f3:	8b 45 08             	mov    0x8(%ebp),%eax
801018f6:	8b 40 0c             	mov    0xc(%eax),%eax
801018f9:	89 c2                	mov    %eax,%edx
801018fb:	83 ca 01             	or     $0x1,%edx
801018fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101901:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101904:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010190b:	e8 a4 36 00 00       	call   80104fb4 <release>

  if(!(ip->flags & I_VALID)){
80101910:	8b 45 08             	mov    0x8(%ebp),%eax
80101913:	8b 40 0c             	mov    0xc(%eax),%eax
80101916:	83 e0 02             	and    $0x2,%eax
80101919:	85 c0                	test   %eax,%eax
8010191b:	0f 85 d1 00 00 00    	jne    801019f2 <ilock+0x14f>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101921:	8b 45 08             	mov    0x8(%ebp),%eax
80101924:	8b 40 04             	mov    0x4(%eax),%eax
80101927:	c1 e8 03             	shr    $0x3,%eax
8010192a:	8d 50 02             	lea    0x2(%eax),%edx
8010192d:	8b 45 08             	mov    0x8(%ebp),%eax
80101930:	8b 00                	mov    (%eax),%eax
80101932:	89 54 24 04          	mov    %edx,0x4(%esp)
80101936:	89 04 24             	mov    %eax,(%esp)
80101939:	e8 69 e8 ff ff       	call   801001a7 <bread>
8010193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101944:	83 c0 18             	add    $0x18,%eax
80101947:	89 c2                	mov    %eax,%edx
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 40 04             	mov    0x4(%eax),%eax
8010194f:	83 e0 07             	and    $0x7,%eax
80101952:	c1 e0 06             	shl    $0x6,%eax
80101955:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101958:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
8010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195e:	0f b7 10             	movzwl (%eax),%edx
80101961:	8b 45 08             	mov    0x8(%ebp),%eax
80101964:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196b:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010196f:	8b 45 08             	mov    0x8(%ebp),%eax
80101972:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101979:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010197d:	8b 45 08             	mov    0x8(%ebp),%eax
80101980:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101987:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010198b:	8b 45 08             	mov    0x8(%ebp),%eax
8010198e:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101995:	8b 50 08             	mov    0x8(%eax),%edx
80101998:	8b 45 08             	mov    0x8(%ebp),%eax
8010199b:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a1:	8d 50 0c             	lea    0xc(%eax),%edx
801019a4:	8b 45 08             	mov    0x8(%ebp),%eax
801019a7:	83 c0 1c             	add    $0x1c,%eax
801019aa:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019b1:	00 
801019b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b6:	89 04 24             	mov    %eax,(%esp)
801019b9:	e8 b7 38 00 00       	call   80105275 <memmove>
    brelse(bp);
801019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c1:	89 04 24             	mov    %eax,(%esp)
801019c4:	e8 4f e8 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	8b 40 0c             	mov    0xc(%eax),%eax
801019cf:	89 c2                	mov    %eax,%edx
801019d1:	83 ca 02             	or     $0x2,%edx
801019d4:	8b 45 08             	mov    0x8(%ebp),%eax
801019d7:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019da:	8b 45 08             	mov    0x8(%ebp),%eax
801019dd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019e1:	66 85 c0             	test   %ax,%ax
801019e4:	75 0c                	jne    801019f2 <ilock+0x14f>
      panic("ilock: no type");
801019e6:	c7 04 24 dd 86 10 80 	movl   $0x801086dd,(%esp)
801019ed:	e8 48 eb ff ff       	call   8010053a <panic>
  }
}
801019f2:	c9                   	leave  
801019f3:	c3                   	ret    

801019f4 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019f4:	55                   	push   %ebp
801019f5:	89 e5                	mov    %esp,%ebp
801019f7:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019fe:	74 17                	je     80101a17 <iunlock+0x23>
80101a00:	8b 45 08             	mov    0x8(%ebp),%eax
80101a03:	8b 40 0c             	mov    0xc(%eax),%eax
80101a06:	83 e0 01             	and    $0x1,%eax
80101a09:	85 c0                	test   %eax,%eax
80101a0b:	74 0a                	je     80101a17 <iunlock+0x23>
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	8b 40 08             	mov    0x8(%eax),%eax
80101a13:	85 c0                	test   %eax,%eax
80101a15:	7f 0c                	jg     80101a23 <iunlock+0x2f>
    panic("iunlock");
80101a17:	c7 04 24 ec 86 10 80 	movl   $0x801086ec,(%esp)
80101a1e:	e8 17 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a23:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a2a:	e8 24 35 00 00       	call   80104f53 <acquire>
  ip->flags &= ~I_BUSY;
80101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a32:	8b 40 0c             	mov    0xc(%eax),%eax
80101a35:	89 c2                	mov    %eax,%edx
80101a37:	83 e2 fe             	and    $0xfffffffe,%edx
80101a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3d:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	89 04 24             	mov    %eax,(%esp)
80101a46:	e8 d4 32 00 00       	call   80104d1f <wakeup>
  release(&icache.lock);
80101a4b:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a52:	e8 5d 35 00 00       	call   80104fb4 <release>
}
80101a57:	c9                   	leave  
80101a58:	c3                   	ret    

80101a59 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a59:	55                   	push   %ebp
80101a5a:	89 e5                	mov    %esp,%ebp
80101a5c:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a5f:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a66:	e8 e8 34 00 00       	call   80104f53 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6e:	8b 40 08             	mov    0x8(%eax),%eax
80101a71:	83 f8 01             	cmp    $0x1,%eax
80101a74:	0f 85 93 00 00 00    	jne    80101b0d <iput+0xb4>
80101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a80:	83 e0 02             	and    $0x2,%eax
80101a83:	85 c0                	test   %eax,%eax
80101a85:	0f 84 82 00 00 00    	je     80101b0d <iput+0xb4>
80101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a92:	66 85 c0             	test   %ax,%ax
80101a95:	75 76                	jne    80101b0d <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9d:	83 e0 01             	and    $0x1,%eax
80101aa0:	84 c0                	test   %al,%al
80101aa2:	74 0c                	je     80101ab0 <iput+0x57>
      panic("iput busy");
80101aa4:	c7 04 24 f4 86 10 80 	movl   $0x801086f4,(%esp)
80101aab:	e8 8a ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab6:	89 c2                	mov    %eax,%edx
80101ab8:	83 ca 01             	or     $0x1,%edx
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ac1:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101ac8:	e8 e7 34 00 00       	call   80104fb4 <release>
    itrunc(ip);
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	89 04 24             	mov    %eax,(%esp)
80101ad3:	e8 72 01 00 00       	call   80101c4a <itrunc>
    ip->type = 0;
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	89 04 24             	mov    %eax,(%esp)
80101ae7:	e8 f7 fb ff ff       	call   801016e3 <iupdate>
    acquire(&icache.lock);
80101aec:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101af3:	e8 5b 34 00 00       	call   80104f53 <acquire>
    ip->flags = 0;
80101af8:	8b 45 08             	mov    0x8(%ebp),%eax
80101afb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	89 04 24             	mov    %eax,(%esp)
80101b08:	e8 12 32 00 00       	call   80104d1f <wakeup>
  }
  ip->ref--;
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	8b 40 08             	mov    0x8(%eax),%eax
80101b13:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b1c:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101b23:	e8 8c 34 00 00       	call   80104fb4 <release>
}
80101b28:	c9                   	leave  
80101b29:	c3                   	ret    

80101b2a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b2a:	55                   	push   %ebp
80101b2b:	89 e5                	mov    %esp,%ebp
80101b2d:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	89 04 24             	mov    %eax,(%esp)
80101b36:	e8 b9 fe ff ff       	call   801019f4 <iunlock>
  iput(ip);
80101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3e:	89 04 24             	mov    %eax,(%esp)
80101b41:	e8 13 ff ff ff       	call   80101a59 <iput>
}
80101b46:	c9                   	leave  
80101b47:	c3                   	ret    

80101b48 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b48:	55                   	push   %ebp
80101b49:	89 e5                	mov    %esp,%ebp
80101b4b:	53                   	push   %ebx
80101b4c:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b4f:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b53:	77 3e                	ja     80101b93 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b55:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	83 c2 04             	add    $0x4,%edx
80101b5e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b62:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101b69:	75 20                	jne    80101b8b <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b71:	8b 00                	mov    (%eax),%eax
80101b73:	89 04 24             	mov    %eax,(%esp)
80101b76:	e8 38 f8 ff ff       	call   801013b3 <balloc>
80101b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b81:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101b84:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101b87:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b8e:	e9 b1 00 00 00       	jmp    80101c44 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b93:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b97:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b9b:	0f 87 97 00 00 00    	ja     80101c38 <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba4:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bae:	75 19                	jne    80101bc9 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	8b 00                	mov    (%eax),%eax
80101bb5:	89 04 24             	mov    %eax,(%esp)
80101bb8:	e8 f6 f7 ff ff       	call   801013b3 <balloc>
80101bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101bc6:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	8b 00                	mov    (%eax),%eax
80101bce:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bd5:	89 04 24             	mov    %eax,(%esp)
80101bd8:	e8 ca e5 ff ff       	call   801001a7 <bread>
80101bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be3:	83 c0 18             	add    $0x18,%eax
80101be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101be9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bec:	c1 e0 02             	shl    $0x2,%eax
80101bef:	03 45 f0             	add    -0x10(%ebp),%eax
80101bf2:	8b 00                	mov    (%eax),%eax
80101bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bfb:	75 2b                	jne    80101c28 <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c00:	c1 e0 02             	shl    $0x2,%eax
80101c03:	89 c3                	mov    %eax,%ebx
80101c05:	03 5d f0             	add    -0x10(%ebp),%ebx
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0b:	8b 00                	mov    (%eax),%eax
80101c0d:	89 04 24             	mov    %eax,(%esp)
80101c10:	e8 9e f7 ff ff       	call   801013b3 <balloc>
80101c15:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c1b:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c20:	89 04 24             	mov    %eax,(%esp)
80101c23:	e8 b3 16 00 00       	call   801032db <log_write>
    }
    brelse(bp);
80101c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c2b:	89 04 24             	mov    %eax,(%esp)
80101c2e:	e8 e5 e5 ff ff       	call   80100218 <brelse>
    return addr;
80101c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c36:	eb 0c                	jmp    80101c44 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c38:	c7 04 24 fe 86 10 80 	movl   $0x801086fe,(%esp)
80101c3f:	e8 f6 e8 ff ff       	call   8010053a <panic>
}
80101c44:	83 c4 24             	add    $0x24,%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5d                   	pop    %ebp
80101c49:	c3                   	ret    

80101c4a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c4a:	55                   	push   %ebp
80101c4b:	89 e5                	mov    %esp,%ebp
80101c4d:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101c57:	eb 44                	jmp    80101c9d <itrunc+0x53>
    if(ip->addrs[i]){
80101c59:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5f:	83 c2 04             	add    $0x4,%edx
80101c62:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c66:	85 c0                	test   %eax,%eax
80101c68:	74 2f                	je     80101c99 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c70:	83 c2 04             	add    $0x4,%edx
80101c73:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c77:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7a:	8b 00                	mov    (%eax),%eax
80101c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c80:	89 04 24             	mov    %eax,(%esp)
80101c83:	e8 86 f8 ff ff       	call   8010150e <bfree>
      ip->addrs[i] = 0;
80101c88:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8e:	83 c2 04             	add    $0x4,%edx
80101c91:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c98:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c99:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101c9d:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101ca1:	7e b6                	jle    80101c59 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101ca3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ca9:	85 c0                	test   %eax,%eax
80101cab:	0f 84 8f 00 00 00    	je     80101d40 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb4:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	8b 00                	mov    (%eax),%eax
80101cbc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc0:	89 04 24             	mov    %eax,(%esp)
80101cc3:	e8 df e4 ff ff       	call   801001a7 <bread>
80101cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cce:	83 c0 18             	add    $0x18,%eax
80101cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101cdb:	eb 2f                	jmp    80101d0c <itrunc+0xc2>
      if(a[j])
80101cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ce0:	c1 e0 02             	shl    $0x2,%eax
80101ce3:	03 45 f4             	add    -0xc(%ebp),%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	85 c0                	test   %eax,%eax
80101cea:	74 1c                	je     80101d08 <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cef:	c1 e0 02             	shl    $0x2,%eax
80101cf2:	03 45 f4             	add    -0xc(%ebp),%eax
80101cf5:	8b 10                	mov    (%eax),%edx
80101cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfa:	8b 00                	mov    (%eax),%eax
80101cfc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d00:	89 04 24             	mov    %eax,(%esp)
80101d03:	e8 06 f8 ff ff       	call   8010150e <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d08:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d0f:	83 f8 7f             	cmp    $0x7f,%eax
80101d12:	76 c9                	jbe    80101cdd <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d17:	89 04 24             	mov    %eax,(%esp)
80101d1a:	e8 f9 e4 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d22:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	8b 00                	mov    (%eax),%eax
80101d2a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d2e:	89 04 24             	mov    %eax,(%esp)
80101d31:	e8 d8 f7 ff ff       	call   8010150e <bfree>
    ip->addrs[NDIRECT] = 0;
80101d36:	8b 45 08             	mov    0x8(%ebp),%eax
80101d39:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d40:	8b 45 08             	mov    0x8(%ebp),%eax
80101d43:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	89 04 24             	mov    %eax,(%esp)
80101d50:	e8 8e f9 ff ff       	call   801016e3 <iupdate>
}
80101d55:	c9                   	leave  
80101d56:	c3                   	ret    

80101d57 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d57:	55                   	push   %ebp
80101d58:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	8b 00                	mov    (%eax),%eax
80101d5f:	89 c2                	mov    %eax,%edx
80101d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d64:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d67:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6a:	8b 50 04             	mov    0x4(%eax),%edx
80101d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d70:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d7d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d91:	8b 50 18             	mov    0x18(%eax),%edx
80101d94:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d97:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret    

80101d9c <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d9c:	55                   	push   %ebp
80101d9d:	89 e5                	mov    %esp,%ebp
80101d9f:	53                   	push   %ebx
80101da0:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da3:	8b 45 08             	mov    0x8(%ebp),%eax
80101da6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101daa:	66 83 f8 03          	cmp    $0x3,%ax
80101dae:	75 60                	jne    80101e10 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101db0:	8b 45 08             	mov    0x8(%ebp),%eax
80101db3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101db7:	66 85 c0             	test   %ax,%ax
80101dba:	78 20                	js     80101ddc <readi+0x40>
80101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc3:	66 83 f8 09          	cmp    $0x9,%ax
80101dc7:	7f 13                	jg     80101ddc <readi+0x40>
80101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd0:	98                   	cwtl   
80101dd1:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
80101dd8:	85 c0                	test   %eax,%eax
80101dda:	75 0a                	jne    80101de6 <readi+0x4a>
      return -1;
80101ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de1:	e9 1c 01 00 00       	jmp    80101f02 <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101de6:	8b 45 08             	mov    0x8(%ebp),%eax
80101de9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ded:	98                   	cwtl   
80101dee:	8b 14 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%edx
80101df5:	8b 45 14             	mov    0x14(%ebp),%eax
80101df8:	89 44 24 08          	mov    %eax,0x8(%esp)
80101dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dff:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e03:	8b 45 08             	mov    0x8(%ebp),%eax
80101e06:	89 04 24             	mov    %eax,(%esp)
80101e09:	ff d2                	call   *%edx
80101e0b:	e9 f2 00 00 00       	jmp    80101f02 <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101e10:	8b 45 08             	mov    0x8(%ebp),%eax
80101e13:	8b 40 18             	mov    0x18(%eax),%eax
80101e16:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e19:	72 0e                	jb     80101e29 <readi+0x8d>
80101e1b:	8b 45 14             	mov    0x14(%ebp),%eax
80101e1e:	8b 55 10             	mov    0x10(%ebp),%edx
80101e21:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101e24:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e27:	73 0a                	jae    80101e33 <readi+0x97>
    return -1;
80101e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e2e:	e9 cf 00 00 00       	jmp    80101f02 <readi+0x166>
  if(off + n > ip->size)
80101e33:	8b 45 14             	mov    0x14(%ebp),%eax
80101e36:	8b 55 10             	mov    0x10(%ebp),%edx
80101e39:	01 c2                	add    %eax,%edx
80101e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3e:	8b 40 18             	mov    0x18(%eax),%eax
80101e41:	39 c2                	cmp    %eax,%edx
80101e43:	76 0c                	jbe    80101e51 <readi+0xb5>
    n = ip->size - off;
80101e45:	8b 45 08             	mov    0x8(%ebp),%eax
80101e48:	8b 40 18             	mov    0x18(%eax),%eax
80101e4b:	2b 45 10             	sub    0x10(%ebp),%eax
80101e4e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101e58:	e9 96 00 00 00       	jmp    80101ef3 <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e5d:	8b 45 10             	mov    0x10(%ebp),%eax
80101e60:	c1 e8 09             	shr    $0x9,%eax
80101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	89 04 24             	mov    %eax,(%esp)
80101e6d:	e8 d6 fc ff ff       	call   80101b48 <bmap>
80101e72:	8b 55 08             	mov    0x8(%ebp),%edx
80101e75:	8b 12                	mov    (%edx),%edx
80101e77:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7b:	89 14 24             	mov    %edx,(%esp)
80101e7e:	e8 24 e3 ff ff       	call   801001a7 <bread>
80101e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e86:	8b 45 10             	mov    0x10(%ebp),%eax
80101e89:	89 c2                	mov    %eax,%edx
80101e8b:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e91:	b8 00 02 00 00       	mov    $0x200,%eax
80101e96:	89 c1                	mov    %eax,%ecx
80101e98:	29 d1                	sub    %edx,%ecx
80101e9a:	89 ca                	mov    %ecx,%edx
80101e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ea2:	89 cb                	mov    %ecx,%ebx
80101ea4:	29 c3                	sub    %eax,%ebx
80101ea6:	89 d8                	mov    %ebx,%eax
80101ea8:	39 c2                	cmp    %eax,%edx
80101eaa:	0f 46 c2             	cmovbe %edx,%eax
80101ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb3:	8d 50 18             	lea    0x18(%eax),%edx
80101eb6:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ebe:	01 c2                	add    %eax,%edx
80101ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec3:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ec7:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ece:	89 04 24             	mov    %eax,(%esp)
80101ed1:	e8 9f 33 00 00       	call   80105275 <memmove>
    brelse(bp);
80101ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ed9:	89 04 24             	mov    %eax,(%esp)
80101edc:	e8 37 e3 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee4:	01 45 ec             	add    %eax,-0x14(%ebp)
80101ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eea:	01 45 10             	add    %eax,0x10(%ebp)
80101eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef0:	01 45 0c             	add    %eax,0xc(%ebp)
80101ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef6:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ef9:	0f 82 5e ff ff ff    	jb     80101e5d <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101eff:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f02:	83 c4 24             	add    $0x24,%esp
80101f05:	5b                   	pop    %ebx
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    

80101f08 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f08:	55                   	push   %ebp
80101f09:	89 e5                	mov    %esp,%ebp
80101f0b:	53                   	push   %ebx
80101f0c:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f12:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f16:	66 83 f8 03          	cmp    $0x3,%ax
80101f1a:	75 60                	jne    80101f7c <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f23:	66 85 c0             	test   %ax,%ax
80101f26:	78 20                	js     80101f48 <writei+0x40>
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2f:	66 83 f8 09          	cmp    $0x9,%ax
80101f33:	7f 13                	jg     80101f48 <writei+0x40>
80101f35:	8b 45 08             	mov    0x8(%ebp),%eax
80101f38:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f3c:	98                   	cwtl   
80101f3d:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
80101f44:	85 c0                	test   %eax,%eax
80101f46:	75 0a                	jne    80101f52 <writei+0x4a>
      return -1;
80101f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4d:	e9 48 01 00 00       	jmp    8010209a <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101f52:	8b 45 08             	mov    0x8(%ebp),%eax
80101f55:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f59:	98                   	cwtl   
80101f5a:	8b 14 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%edx
80101f61:	8b 45 14             	mov    0x14(%ebp),%eax
80101f64:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f72:	89 04 24             	mov    %eax,(%esp)
80101f75:	ff d2                	call   *%edx
80101f77:	e9 1e 01 00 00       	jmp    8010209a <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7f:	8b 40 18             	mov    0x18(%eax),%eax
80101f82:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f85:	72 0e                	jb     80101f95 <writei+0x8d>
80101f87:	8b 45 14             	mov    0x14(%ebp),%eax
80101f8a:	8b 55 10             	mov    0x10(%ebp),%edx
80101f8d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f90:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f93:	73 0a                	jae    80101f9f <writei+0x97>
    return -1;
80101f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f9a:	e9 fb 00 00 00       	jmp    8010209a <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80101f9f:	8b 45 14             	mov    0x14(%ebp),%eax
80101fa2:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa5:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101fa8:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fad:	76 0a                	jbe    80101fb9 <writei+0xb1>
    return -1;
80101faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb4:	e9 e1 00 00 00       	jmp    8010209a <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fb9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101fc0:	e9 a1 00 00 00       	jmp    80102066 <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc5:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc8:	c1 e8 09             	shr    $0x9,%eax
80101fcb:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd2:	89 04 24             	mov    %eax,(%esp)
80101fd5:	e8 6e fb ff ff       	call   80101b48 <bmap>
80101fda:	8b 55 08             	mov    0x8(%ebp),%edx
80101fdd:	8b 12                	mov    (%edx),%edx
80101fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe3:	89 14 24             	mov    %edx,(%esp)
80101fe6:	e8 bc e1 ff ff       	call   801001a7 <bread>
80101feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fee:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff1:	89 c2                	mov    %eax,%edx
80101ff3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ff9:	b8 00 02 00 00       	mov    $0x200,%eax
80101ffe:	89 c1                	mov    %eax,%ecx
80102000:	29 d1                	sub    %edx,%ecx
80102002:	89 ca                	mov    %ecx,%edx
80102004:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102007:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010200a:	89 cb                	mov    %ecx,%ebx
8010200c:	29 c3                	sub    %eax,%ebx
8010200e:	89 d8                	mov    %ebx,%eax
80102010:	39 c2                	cmp    %eax,%edx
80102012:	0f 46 c2             	cmovbe %edx,%eax
80102015:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010201b:	8d 50 18             	lea    0x18(%eax),%edx
8010201e:	8b 45 10             	mov    0x10(%ebp),%eax
80102021:	25 ff 01 00 00       	and    $0x1ff,%eax
80102026:	01 c2                	add    %eax,%edx
80102028:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010202b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010202f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102032:	89 44 24 04          	mov    %eax,0x4(%esp)
80102036:	89 14 24             	mov    %edx,(%esp)
80102039:	e8 37 32 00 00       	call   80105275 <memmove>
    log_write(bp);
8010203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102041:	89 04 24             	mov    %eax,(%esp)
80102044:	e8 92 12 00 00       	call   801032db <log_write>
    brelse(bp);
80102049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204c:	89 04 24             	mov    %eax,(%esp)
8010204f:	e8 c4 e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102054:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102057:	01 45 ec             	add    %eax,-0x14(%ebp)
8010205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205d:	01 45 10             	add    %eax,0x10(%ebp)
80102060:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102063:	01 45 0c             	add    %eax,0xc(%ebp)
80102066:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102069:	3b 45 14             	cmp    0x14(%ebp),%eax
8010206c:	0f 82 53 ff ff ff    	jb     80101fc5 <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102072:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102076:	74 1f                	je     80102097 <writei+0x18f>
80102078:	8b 45 08             	mov    0x8(%ebp),%eax
8010207b:	8b 40 18             	mov    0x18(%eax),%eax
8010207e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102081:	73 14                	jae    80102097 <writei+0x18f>
    ip->size = off;
80102083:	8b 45 08             	mov    0x8(%ebp),%eax
80102086:	8b 55 10             	mov    0x10(%ebp),%edx
80102089:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010208c:	8b 45 08             	mov    0x8(%ebp),%eax
8010208f:	89 04 24             	mov    %eax,(%esp)
80102092:	e8 4c f6 ff ff       	call   801016e3 <iupdate>
  }
  return n;
80102097:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010209a:	83 c4 24             	add    $0x24,%esp
8010209d:	5b                   	pop    %ebx
8010209e:	5d                   	pop    %ebp
8010209f:	c3                   	ret    

801020a0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020a6:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020ad:	00 
801020ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b5:	8b 45 08             	mov    0x8(%ebp),%eax
801020b8:	89 04 24             	mov    %eax,(%esp)
801020bb:	e8 5d 32 00 00       	call   8010531d <strncmp>
}
801020c0:	c9                   	leave  
801020c1:	c3                   	ret    

801020c2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020c2:	55                   	push   %ebp
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020cf:	66 83 f8 01          	cmp    $0x1,%ax
801020d3:	74 0c                	je     801020e1 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020d5:	c7 04 24 11 87 10 80 	movl   $0x80108711,(%esp)
801020dc:	e8 59 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801020e8:	e9 87 00 00 00       	jmp    80102174 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020f7:	00 
801020f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801020fb:	89 54 24 08          	mov    %edx,0x8(%esp)
801020ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102103:	8b 45 08             	mov    0x8(%ebp),%eax
80102106:	89 04 24             	mov    %eax,(%esp)
80102109:	e8 8e fc ff ff       	call   80101d9c <readi>
8010210e:	83 f8 10             	cmp    $0x10,%eax
80102111:	74 0c                	je     8010211f <dirlookup+0x5d>
      panic("dirlink read");
80102113:	c7 04 24 23 87 10 80 	movl   $0x80108723,(%esp)
8010211a:	e8 1b e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
8010211f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102123:	66 85 c0             	test   %ax,%ax
80102126:	74 47                	je     8010216f <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
80102128:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010212b:	83 c0 02             	add    $0x2,%eax
8010212e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102132:	8b 45 0c             	mov    0xc(%ebp),%eax
80102135:	89 04 24             	mov    %eax,(%esp)
80102138:	e8 63 ff ff ff       	call   801020a0 <namecmp>
8010213d:	85 c0                	test   %eax,%eax
8010213f:	75 2f                	jne    80102170 <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102145:	74 08                	je     8010214f <dirlookup+0x8d>
        *poff = off;
80102147:	8b 45 10             	mov    0x10(%ebp),%eax
8010214a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010214d:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010214f:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102153:	0f b7 c0             	movzwl %ax,%eax
80102156:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
80102159:	8b 45 08             	mov    0x8(%ebp),%eax
8010215c:	8b 00                	mov    (%eax),%eax
8010215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102161:	89 54 24 04          	mov    %edx,0x4(%esp)
80102165:	89 04 24             	mov    %eax,(%esp)
80102168:	e8 31 f6 ff ff       	call   8010179e <iget>
8010216d:	eb 19                	jmp    80102188 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010216f:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102170:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80102174:	8b 45 08             	mov    0x8(%ebp),%eax
80102177:	8b 40 18             	mov    0x18(%eax),%eax
8010217a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010217d:	0f 87 6a ff ff ff    	ja     801020ed <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102183:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102188:	c9                   	leave  
80102189:	c3                   	ret    

8010218a <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010218a:	55                   	push   %ebp
8010218b:	89 e5                	mov    %esp,%ebp
8010218d:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102190:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102197:	00 
80102198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010219b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010219f:	8b 45 08             	mov    0x8(%ebp),%eax
801021a2:	89 04 24             	mov    %eax,(%esp)
801021a5:	e8 18 ff ff ff       	call   801020c2 <dirlookup>
801021aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801021b1:	74 15                	je     801021c8 <dirlink+0x3e>
    iput(ip);
801021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b6:	89 04 24             	mov    %eax,(%esp)
801021b9:	e8 9b f8 ff ff       	call   80101a59 <iput>
    return -1;
801021be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c3:	e9 b8 00 00 00       	jmp    80102280 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801021cf:	eb 44                	jmp    80102215 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021d7:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021de:	00 
801021df:	89 54 24 08          	mov    %edx,0x8(%esp)
801021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ea:	89 04 24             	mov    %eax,(%esp)
801021ed:	e8 aa fb ff ff       	call   80101d9c <readi>
801021f2:	83 f8 10             	cmp    $0x10,%eax
801021f5:	74 0c                	je     80102203 <dirlink+0x79>
      panic("dirlink read");
801021f7:	c7 04 24 23 87 10 80 	movl   $0x80108723,(%esp)
801021fe:	e8 37 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102203:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102207:	66 85 c0             	test   %ax,%ax
8010220a:	74 18                	je     80102224 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010220f:	83 c0 10             	add    $0x10,%eax
80102212:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102215:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102218:	8b 45 08             	mov    0x8(%ebp),%eax
8010221b:	8b 40 18             	mov    0x18(%eax),%eax
8010221e:	39 c2                	cmp    %eax,%edx
80102220:	72 af                	jb     801021d1 <dirlink+0x47>
80102222:	eb 01                	jmp    80102225 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102224:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102225:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010222c:	00 
8010222d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102230:	89 44 24 04          	mov    %eax,0x4(%esp)
80102234:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102237:	83 c0 02             	add    $0x2,%eax
8010223a:	89 04 24             	mov    %eax,(%esp)
8010223d:	e8 33 31 00 00       	call   80105375 <strncpy>
  de.inum = inum;
80102242:	8b 45 10             	mov    0x10(%ebp),%eax
80102245:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102249:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010224c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010224f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102256:	00 
80102257:	89 54 24 08          	mov    %edx,0x8(%esp)
8010225b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010225f:	8b 45 08             	mov    0x8(%ebp),%eax
80102262:	89 04 24             	mov    %eax,(%esp)
80102265:	e8 9e fc ff ff       	call   80101f08 <writei>
8010226a:	83 f8 10             	cmp    $0x10,%eax
8010226d:	74 0c                	je     8010227b <dirlink+0xf1>
    panic("dirlink");
8010226f:	c7 04 24 30 87 10 80 	movl   $0x80108730,(%esp)
80102276:	e8 bf e2 ff ff       	call   8010053a <panic>
  
  return 0;
8010227b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102280:	c9                   	leave  
80102281:	c3                   	ret    

80102282 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102282:	55                   	push   %ebp
80102283:	89 e5                	mov    %esp,%ebp
80102285:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102288:	eb 04                	jmp    8010228e <skipelem+0xc>
    path++;
8010228a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010228e:	8b 45 08             	mov    0x8(%ebp),%eax
80102291:	0f b6 00             	movzbl (%eax),%eax
80102294:	3c 2f                	cmp    $0x2f,%al
80102296:	74 f2                	je     8010228a <skipelem+0x8>
    path++;
  if(*path == 0)
80102298:	8b 45 08             	mov    0x8(%ebp),%eax
8010229b:	0f b6 00             	movzbl (%eax),%eax
8010229e:	84 c0                	test   %al,%al
801022a0:	75 0a                	jne    801022ac <skipelem+0x2a>
    return 0;
801022a2:	b8 00 00 00 00       	mov    $0x0,%eax
801022a7:	e9 86 00 00 00       	jmp    80102332 <skipelem+0xb0>
  s = path;
801022ac:	8b 45 08             	mov    0x8(%ebp),%eax
801022af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
801022b2:	eb 04                	jmp    801022b8 <skipelem+0x36>
    path++;
801022b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022b8:	8b 45 08             	mov    0x8(%ebp),%eax
801022bb:	0f b6 00             	movzbl (%eax),%eax
801022be:	3c 2f                	cmp    $0x2f,%al
801022c0:	74 0a                	je     801022cc <skipelem+0x4a>
801022c2:	8b 45 08             	mov    0x8(%ebp),%eax
801022c5:	0f b6 00             	movzbl (%eax),%eax
801022c8:	84 c0                	test   %al,%al
801022ca:	75 e8                	jne    801022b4 <skipelem+0x32>
    path++;
  len = path - s;
801022cc:	8b 55 08             	mov    0x8(%ebp),%edx
801022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d2:	89 d1                	mov    %edx,%ecx
801022d4:	29 c1                	sub    %eax,%ecx
801022d6:	89 c8                	mov    %ecx,%eax
801022d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
801022db:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801022df:	7e 1c                	jle    801022fd <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022e1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022e8:	00 
801022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f3:	89 04 24             	mov    %eax,(%esp)
801022f6:	e8 7a 2f 00 00       	call   80105275 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022fb:	eb 28                	jmp    80102325 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102300:	89 44 24 08          	mov    %eax,0x8(%esp)
80102304:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102307:	89 44 24 04          	mov    %eax,0x4(%esp)
8010230b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010230e:	89 04 24             	mov    %eax,(%esp)
80102311:	e8 5f 2f 00 00       	call   80105275 <memmove>
    name[len] = 0;
80102316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102319:	03 45 0c             	add    0xc(%ebp),%eax
8010231c:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010231f:	eb 04                	jmp    80102325 <skipelem+0xa3>
    path++;
80102321:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102325:	8b 45 08             	mov    0x8(%ebp),%eax
80102328:	0f b6 00             	movzbl (%eax),%eax
8010232b:	3c 2f                	cmp    $0x2f,%al
8010232d:	74 f2                	je     80102321 <skipelem+0x9f>
    path++;
  return path;
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102332:	c9                   	leave  
80102333:	c3                   	ret    

80102334 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102334:	55                   	push   %ebp
80102335:	89 e5                	mov    %esp,%ebp
80102337:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010233a:	8b 45 08             	mov    0x8(%ebp),%eax
8010233d:	0f b6 00             	movzbl (%eax),%eax
80102340:	3c 2f                	cmp    $0x2f,%al
80102342:	75 1c                	jne    80102360 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102344:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010234b:	00 
8010234c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102353:	e8 46 f4 ff ff       	call   8010179e <iget>
80102358:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010235b:	e9 af 00 00 00       	jmp    8010240f <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102366:	8b 40 68             	mov    0x68(%eax),%eax
80102369:	89 04 24             	mov    %eax,(%esp)
8010236c:	e8 00 f5 ff ff       	call   80101871 <idup>
80102371:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
80102374:	e9 96 00 00 00       	jmp    8010240f <namex+0xdb>
    ilock(ip);
80102379:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010237c:	89 04 24             	mov    %eax,(%esp)
8010237f:	e8 1f f5 ff ff       	call   801018a3 <ilock>
    if(ip->type != T_DIR){
80102384:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102387:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010238b:	66 83 f8 01          	cmp    $0x1,%ax
8010238f:	74 15                	je     801023a6 <namex+0x72>
      iunlockput(ip);
80102391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102394:	89 04 24             	mov    %eax,(%esp)
80102397:	e8 8e f7 ff ff       	call   80101b2a <iunlockput>
      return 0;
8010239c:	b8 00 00 00 00       	mov    $0x0,%eax
801023a1:	e9 a3 00 00 00       	jmp    80102449 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023aa:	74 1d                	je     801023c9 <namex+0x95>
801023ac:	8b 45 08             	mov    0x8(%ebp),%eax
801023af:	0f b6 00             	movzbl (%eax),%eax
801023b2:	84 c0                	test   %al,%al
801023b4:	75 13                	jne    801023c9 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b9:	89 04 24             	mov    %eax,(%esp)
801023bc:	e8 33 f6 ff ff       	call   801019f4 <iunlock>
      return ip;
801023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023c4:	e9 80 00 00 00       	jmp    80102449 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023d0:	00 
801023d1:	8b 45 10             	mov    0x10(%ebp),%eax
801023d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023db:	89 04 24             	mov    %eax,(%esp)
801023de:	e8 df fc ff ff       	call   801020c2 <dirlookup>
801023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801023ea:	75 12                	jne    801023fe <namex+0xca>
      iunlockput(ip);
801023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023ef:	89 04 24             	mov    %eax,(%esp)
801023f2:	e8 33 f7 ff ff       	call   80101b2a <iunlockput>
      return 0;
801023f7:	b8 00 00 00 00       	mov    $0x0,%eax
801023fc:	eb 4b                	jmp    80102449 <namex+0x115>
    }
    iunlockput(ip);
801023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102401:	89 04 24             	mov    %eax,(%esp)
80102404:	e8 21 f7 ff ff       	call   80101b2a <iunlockput>
    ip = next;
80102409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010240c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010240f:	8b 45 10             	mov    0x10(%ebp),%eax
80102412:	89 44 24 04          	mov    %eax,0x4(%esp)
80102416:	8b 45 08             	mov    0x8(%ebp),%eax
80102419:	89 04 24             	mov    %eax,(%esp)
8010241c:	e8 61 fe ff ff       	call   80102282 <skipelem>
80102421:	89 45 08             	mov    %eax,0x8(%ebp)
80102424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102428:	0f 85 4b ff ff ff    	jne    80102379 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010242e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102432:	74 12                	je     80102446 <namex+0x112>
    iput(ip);
80102434:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102437:	89 04 24             	mov    %eax,(%esp)
8010243a:	e8 1a f6 ff ff       	call   80101a59 <iput>
    return 0;
8010243f:	b8 00 00 00 00       	mov    $0x0,%eax
80102444:	eb 03                	jmp    80102449 <namex+0x115>
  }
  return ip;
80102446:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80102449:	c9                   	leave  
8010244a:	c3                   	ret    

8010244b <namei>:

struct inode*
namei(char *path)
{
8010244b:	55                   	push   %ebp
8010244c:	89 e5                	mov    %esp,%ebp
8010244e:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102451:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102454:	89 44 24 08          	mov    %eax,0x8(%esp)
80102458:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010245f:	00 
80102460:	8b 45 08             	mov    0x8(%ebp),%eax
80102463:	89 04 24             	mov    %eax,(%esp)
80102466:	e8 c9 fe ff ff       	call   80102334 <namex>
}
8010246b:	c9                   	leave  
8010246c:	c3                   	ret    

8010246d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010246d:	55                   	push   %ebp
8010246e:	89 e5                	mov    %esp,%ebp
80102470:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102473:	8b 45 0c             	mov    0xc(%ebp),%eax
80102476:	89 44 24 08          	mov    %eax,0x8(%esp)
8010247a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102481:	00 
80102482:	8b 45 08             	mov    0x8(%ebp),%eax
80102485:	89 04 24             	mov    %eax,(%esp)
80102488:	e8 a7 fe ff ff       	call   80102334 <namex>
}
8010248d:	c9                   	leave  
8010248e:	c3                   	ret    
	...

80102490 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	83 ec 14             	sub    $0x14,%esp
80102496:	8b 45 08             	mov    0x8(%ebp),%eax
80102499:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010249d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024a1:	89 c2                	mov    %eax,%edx
801024a3:	ec                   	in     (%dx),%al
801024a4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024a7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    

801024ad <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024ad:	55                   	push   %ebp
801024ae:	89 e5                	mov    %esp,%ebp
801024b0:	57                   	push   %edi
801024b1:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024b2:	8b 55 08             	mov    0x8(%ebp),%edx
801024b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024b8:	8b 45 10             	mov    0x10(%ebp),%eax
801024bb:	89 cb                	mov    %ecx,%ebx
801024bd:	89 df                	mov    %ebx,%edi
801024bf:	89 c1                	mov    %eax,%ecx
801024c1:	fc                   	cld    
801024c2:	f3 6d                	rep insl (%dx),%es:(%edi)
801024c4:	89 c8                	mov    %ecx,%eax
801024c6:	89 fb                	mov    %edi,%ebx
801024c8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024cb:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024ce:	5b                   	pop    %ebx
801024cf:	5f                   	pop    %edi
801024d0:	5d                   	pop    %ebp
801024d1:	c3                   	ret    

801024d2 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024d2:	55                   	push   %ebp
801024d3:	89 e5                	mov    %esp,%ebp
801024d5:	83 ec 08             	sub    $0x8,%esp
801024d8:	8b 55 08             	mov    0x8(%ebp),%edx
801024db:	8b 45 0c             	mov    0xc(%ebp),%eax
801024de:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024e2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024e9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ed:	ee                   	out    %al,(%dx)
}
801024ee:	c9                   	leave  
801024ef:	c3                   	ret    

801024f0 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	56                   	push   %esi
801024f4:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024f5:	8b 55 08             	mov    0x8(%ebp),%edx
801024f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024fb:	8b 45 10             	mov    0x10(%ebp),%eax
801024fe:	89 cb                	mov    %ecx,%ebx
80102500:	89 de                	mov    %ebx,%esi
80102502:	89 c1                	mov    %eax,%ecx
80102504:	fc                   	cld    
80102505:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102507:	89 c8                	mov    %ecx,%eax
80102509:	89 f3                	mov    %esi,%ebx
8010250b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010250e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102511:	5b                   	pop    %ebx
80102512:	5e                   	pop    %esi
80102513:	5d                   	pop    %ebp
80102514:	c3                   	ret    

80102515 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102515:	55                   	push   %ebp
80102516:	89 e5                	mov    %esp,%ebp
80102518:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010251b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102522:	e8 69 ff ff ff       	call   80102490 <inb>
80102527:	0f b6 c0             	movzbl %al,%eax
8010252a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010252d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102530:	25 c0 00 00 00       	and    $0xc0,%eax
80102535:	83 f8 40             	cmp    $0x40,%eax
80102538:	75 e1                	jne    8010251b <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010253a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010253e:	74 11                	je     80102551 <idewait+0x3c>
80102540:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102543:	83 e0 21             	and    $0x21,%eax
80102546:	85 c0                	test   %eax,%eax
80102548:	74 07                	je     80102551 <idewait+0x3c>
    return -1;
8010254a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010254f:	eb 05                	jmp    80102556 <idewait+0x41>
  return 0;
80102551:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102556:	c9                   	leave  
80102557:	c3                   	ret    

80102558 <ideinit>:

void
ideinit(void)
{
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010255e:	c7 44 24 04 38 87 10 	movl   $0x80108738,0x4(%esp)
80102565:	80 
80102566:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010256d:	e8 c0 29 00 00       	call   80104f32 <initlock>
  picenable(IRQ_IDE);
80102572:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102579:	e8 37 15 00 00       	call   80103ab5 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010257e:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80102583:	83 e8 01             	sub    $0x1,%eax
80102586:	89 44 24 04          	mov    %eax,0x4(%esp)
8010258a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102591:	e8 10 04 00 00       	call   801029a6 <ioapicenable>
  idewait(0);
80102596:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010259d:	e8 73 ff ff ff       	call   80102515 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025a2:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025a9:	00 
801025aa:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b1:	e8 1c ff ff ff       	call   801024d2 <outb>
  for(i=0; i<1000; i++){
801025b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025bd:	eb 20                	jmp    801025df <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025bf:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025c6:	e8 c5 fe ff ff       	call   80102490 <inb>
801025cb:	84 c0                	test   %al,%al
801025cd:	74 0c                	je     801025db <ideinit+0x83>
      havedisk1 = 1;
801025cf:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
801025d6:	00 00 00 
      break;
801025d9:	eb 0d                	jmp    801025e8 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025df:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025e6:	7e d7                	jle    801025bf <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025e8:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025ef:	00 
801025f0:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025f7:	e8 d6 fe ff ff       	call   801024d2 <outb>
}
801025fc:	c9                   	leave  
801025fd:	c3                   	ret    

801025fe <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025fe:	55                   	push   %ebp
801025ff:	89 e5                	mov    %esp,%ebp
80102601:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102604:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102608:	75 0c                	jne    80102616 <idestart+0x18>
    panic("idestart");
8010260a:	c7 04 24 3c 87 10 80 	movl   $0x8010873c,(%esp)
80102611:	e8 24 df ff ff       	call   8010053a <panic>

  idewait(0);
80102616:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010261d:	e8 f3 fe ff ff       	call   80102515 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102622:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102629:	00 
8010262a:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102631:	e8 9c fe ff ff       	call   801024d2 <outb>
  outb(0x1f2, 1);  // number of sectors
80102636:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010263d:	00 
8010263e:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102645:	e8 88 fe ff ff       	call   801024d2 <outb>
  outb(0x1f3, b->sector & 0xff);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
8010264d:	8b 40 08             	mov    0x8(%eax),%eax
80102650:	0f b6 c0             	movzbl %al,%eax
80102653:	89 44 24 04          	mov    %eax,0x4(%esp)
80102657:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010265e:	e8 6f fe ff ff       	call   801024d2 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102663:	8b 45 08             	mov    0x8(%ebp),%eax
80102666:	8b 40 08             	mov    0x8(%eax),%eax
80102669:	c1 e8 08             	shr    $0x8,%eax
8010266c:	0f b6 c0             	movzbl %al,%eax
8010266f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102673:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010267a:	e8 53 fe ff ff       	call   801024d2 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010267f:	8b 45 08             	mov    0x8(%ebp),%eax
80102682:	8b 40 08             	mov    0x8(%eax),%eax
80102685:	c1 e8 10             	shr    $0x10,%eax
80102688:	0f b6 c0             	movzbl %al,%eax
8010268b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268f:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102696:	e8 37 fe ff ff       	call   801024d2 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	8b 40 04             	mov    0x4(%eax),%eax
801026a1:	83 e0 01             	and    $0x1,%eax
801026a4:	89 c2                	mov    %eax,%edx
801026a6:	c1 e2 04             	shl    $0x4,%edx
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
801026ac:	8b 40 08             	mov    0x8(%eax),%eax
801026af:	c1 e8 18             	shr    $0x18,%eax
801026b2:	83 e0 0f             	and    $0xf,%eax
801026b5:	09 d0                	or     %edx,%eax
801026b7:	83 c8 e0             	or     $0xffffffe0,%eax
801026ba:	0f b6 c0             	movzbl %al,%eax
801026bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026c8:	e8 05 fe ff ff       	call   801024d2 <outb>
  if(b->flags & B_DIRTY){
801026cd:	8b 45 08             	mov    0x8(%ebp),%eax
801026d0:	8b 00                	mov    (%eax),%eax
801026d2:	83 e0 04             	and    $0x4,%eax
801026d5:	85 c0                	test   %eax,%eax
801026d7:	74 34                	je     8010270d <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026d9:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026e0:	00 
801026e1:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e8:	e8 e5 fd ff ff       	call   801024d2 <outb>
    outsl(0x1f0, b->data, 512/4);
801026ed:	8b 45 08             	mov    0x8(%ebp),%eax
801026f0:	83 c0 18             	add    $0x18,%eax
801026f3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026fa:	00 
801026fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801026ff:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102706:	e8 e5 fd ff ff       	call   801024f0 <outsl>
8010270b:	eb 14                	jmp    80102721 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010270d:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102714:	00 
80102715:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010271c:	e8 b1 fd ff ff       	call   801024d2 <outb>
  }
}
80102721:	c9                   	leave  
80102722:	c3                   	ret    

80102723 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102723:	55                   	push   %ebp
80102724:	89 e5                	mov    %esp,%ebp
80102726:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102729:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102730:	e8 1e 28 00 00       	call   80104f53 <acquire>
  if((b = idequeue) == 0){
80102735:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102741:	75 11                	jne    80102754 <ideintr+0x31>
    release(&idelock);
80102743:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010274a:	e8 65 28 00 00       	call   80104fb4 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010274f:	e9 90 00 00 00       	jmp    801027e4 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102757:	8b 40 14             	mov    0x14(%eax),%eax
8010275a:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102762:	8b 00                	mov    (%eax),%eax
80102764:	83 e0 04             	and    $0x4,%eax
80102767:	85 c0                	test   %eax,%eax
80102769:	75 2e                	jne    80102799 <ideintr+0x76>
8010276b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102772:	e8 9e fd ff ff       	call   80102515 <idewait>
80102777:	85 c0                	test   %eax,%eax
80102779:	78 1e                	js     80102799 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277e:	83 c0 18             	add    $0x18,%eax
80102781:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102788:	00 
80102789:	89 44 24 04          	mov    %eax,0x4(%esp)
8010278d:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102794:	e8 14 fd ff ff       	call   801024ad <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279c:	8b 00                	mov    (%eax),%eax
8010279e:	89 c2                	mov    %eax,%edx
801027a0:	83 ca 02             	or     $0x2,%edx
801027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a6:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ab:	8b 00                	mov    (%eax),%eax
801027ad:	89 c2                	mov    %eax,%edx
801027af:	83 e2 fb             	and    $0xfffffffb,%edx
801027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b5:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ba:	89 04 24             	mov    %eax,(%esp)
801027bd:	e8 5d 25 00 00       	call   80104d1f <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c2:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027c7:	85 c0                	test   %eax,%eax
801027c9:	74 0d                	je     801027d8 <ideintr+0xb5>
    idestart(idequeue);
801027cb:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027d0:	89 04 24             	mov    %eax,(%esp)
801027d3:	e8 26 fe ff ff       	call   801025fe <idestart>

  release(&idelock);
801027d8:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027df:	e8 d0 27 00 00       	call   80104fb4 <release>
}
801027e4:	c9                   	leave  
801027e5:	c3                   	ret    

801027e6 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027e6:	55                   	push   %ebp
801027e7:	89 e5                	mov    %esp,%ebp
801027e9:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ec:	8b 45 08             	mov    0x8(%ebp),%eax
801027ef:	8b 00                	mov    (%eax),%eax
801027f1:	83 e0 01             	and    $0x1,%eax
801027f4:	85 c0                	test   %eax,%eax
801027f6:	75 0c                	jne    80102804 <iderw+0x1e>
    panic("iderw: buf not busy");
801027f8:	c7 04 24 45 87 10 80 	movl   $0x80108745,(%esp)
801027ff:	e8 36 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102804:	8b 45 08             	mov    0x8(%ebp),%eax
80102807:	8b 00                	mov    (%eax),%eax
80102809:	83 e0 06             	and    $0x6,%eax
8010280c:	83 f8 02             	cmp    $0x2,%eax
8010280f:	75 0c                	jne    8010281d <iderw+0x37>
    panic("iderw: nothing to do");
80102811:	c7 04 24 59 87 10 80 	movl   $0x80108759,(%esp)
80102818:	e8 1d dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
8010281d:	8b 45 08             	mov    0x8(%ebp),%eax
80102820:	8b 40 04             	mov    0x4(%eax),%eax
80102823:	85 c0                	test   %eax,%eax
80102825:	74 15                	je     8010283c <iderw+0x56>
80102827:	a1 58 b6 10 80       	mov    0x8010b658,%eax
8010282c:	85 c0                	test   %eax,%eax
8010282e:	75 0c                	jne    8010283c <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102830:	c7 04 24 6e 87 10 80 	movl   $0x8010876e,(%esp)
80102837:	e8 fe dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010283c:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102843:	e8 0b 27 00 00       	call   80104f53 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102848:	8b 45 08             	mov    0x8(%ebp),%eax
8010284b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102852:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
80102859:	eb 0b                	jmp    80102866 <iderw+0x80>
8010285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285e:	8b 00                	mov    (%eax),%eax
80102860:	83 c0 14             	add    $0x14,%eax
80102863:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102869:	8b 00                	mov    (%eax),%eax
8010286b:	85 c0                	test   %eax,%eax
8010286d:	75 ec                	jne    8010285b <iderw+0x75>
    ;
  *pp = b;
8010286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102872:	8b 55 08             	mov    0x8(%ebp),%edx
80102875:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102877:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010287c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010287f:	75 22                	jne    801028a3 <iderw+0xbd>
    idestart(b);
80102881:	8b 45 08             	mov    0x8(%ebp),%eax
80102884:	89 04 24             	mov    %eax,(%esp)
80102887:	e8 72 fd ff ff       	call   801025fe <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010288c:	eb 16                	jmp    801028a4 <iderw+0xbe>
    sleep(b, &idelock);
8010288e:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
80102895:	80 
80102896:	8b 45 08             	mov    0x8(%ebp),%eax
80102899:	89 04 24             	mov    %eax,(%esp)
8010289c:	e8 38 23 00 00       	call   80104bd9 <sleep>
801028a1:	eb 01                	jmp    801028a4 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028a3:	90                   	nop
801028a4:	8b 45 08             	mov    0x8(%ebp),%eax
801028a7:	8b 00                	mov    (%eax),%eax
801028a9:	83 e0 06             	and    $0x6,%eax
801028ac:	83 f8 02             	cmp    $0x2,%eax
801028af:	75 dd                	jne    8010288e <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
801028b1:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801028b8:	e8 f7 26 00 00       	call   80104fb4 <release>
}
801028bd:	c9                   	leave  
801028be:	c3                   	ret    
	...

801028c0 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028c3:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028c8:	8b 55 08             	mov    0x8(%ebp),%edx
801028cb:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028cd:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028d2:	8b 40 10             	mov    0x10(%eax),%eax
}
801028d5:	5d                   	pop    %ebp
801028d6:	c3                   	ret    

801028d7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028d7:	55                   	push   %ebp
801028d8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028da:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028df:	8b 55 08             	mov    0x8(%ebp),%edx
801028e2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028e4:	a1 54 f8 10 80       	mov    0x8010f854,%eax
801028e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801028ec:	89 50 10             	mov    %edx,0x10(%eax)
}
801028ef:	5d                   	pop    %ebp
801028f0:	c3                   	ret    

801028f1 <ioapicinit>:

void
ioapicinit(void)
{
801028f1:	55                   	push   %ebp
801028f2:	89 e5                	mov    %esp,%ebp
801028f4:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028f7:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801028fc:	85 c0                	test   %eax,%eax
801028fe:	0f 84 9f 00 00 00    	je     801029a3 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102904:	c7 05 54 f8 10 80 00 	movl   $0xfec00000,0x8010f854
8010290b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010290e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102915:	e8 a6 ff ff ff       	call   801028c0 <ioapicread>
8010291a:	c1 e8 10             	shr    $0x10,%eax
8010291d:	25 ff 00 00 00       	and    $0xff,%eax
80102922:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102925:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010292c:	e8 8f ff ff ff       	call   801028c0 <ioapicread>
80102931:	c1 e8 18             	shr    $0x18,%eax
80102934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
80102937:	0f b6 05 20 f9 10 80 	movzbl 0x8010f920,%eax
8010293e:	0f b6 c0             	movzbl %al,%eax
80102941:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102944:	74 0c                	je     80102952 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102946:	c7 04 24 8c 87 10 80 	movl   $0x8010878c,(%esp)
8010294d:	e8 48 da ff ff       	call   8010039a <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102952:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102959:	eb 3e                	jmp    80102999 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010295e:	83 c0 20             	add    $0x20,%eax
80102961:	0d 00 00 01 00       	or     $0x10000,%eax
80102966:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102969:	83 c2 08             	add    $0x8,%edx
8010296c:	01 d2                	add    %edx,%edx
8010296e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102972:	89 14 24             	mov    %edx,(%esp)
80102975:	e8 5d ff ff ff       	call   801028d7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010297d:	83 c0 08             	add    $0x8,%eax
80102980:	01 c0                	add    %eax,%eax
80102982:	83 c0 01             	add    $0x1,%eax
80102985:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010298c:	00 
8010298d:	89 04 24             	mov    %eax,(%esp)
80102990:	e8 42 ff ff ff       	call   801028d7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102995:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102999:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010299c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010299f:	7e ba                	jle    8010295b <ioapicinit+0x6a>
801029a1:	eb 01                	jmp    801029a4 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029a3:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029a4:	c9                   	leave  
801029a5:	c3                   	ret    

801029a6 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029a6:	55                   	push   %ebp
801029a7:	89 e5                	mov    %esp,%ebp
801029a9:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029ac:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801029b1:	85 c0                	test   %eax,%eax
801029b3:	74 39                	je     801029ee <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029b5:	8b 45 08             	mov    0x8(%ebp),%eax
801029b8:	83 c0 20             	add    $0x20,%eax
801029bb:	8b 55 08             	mov    0x8(%ebp),%edx
801029be:	83 c2 08             	add    $0x8,%edx
801029c1:	01 d2                	add    %edx,%edx
801029c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c7:	89 14 24             	mov    %edx,(%esp)
801029ca:	e8 08 ff ff ff       	call   801028d7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d2:	c1 e0 18             	shl    $0x18,%eax
801029d5:	8b 55 08             	mov    0x8(%ebp),%edx
801029d8:	83 c2 08             	add    $0x8,%edx
801029db:	01 d2                	add    %edx,%edx
801029dd:	83 c2 01             	add    $0x1,%edx
801029e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e4:	89 14 24             	mov    %edx,(%esp)
801029e7:	e8 eb fe ff ff       	call   801028d7 <ioapicwrite>
801029ec:	eb 01                	jmp    801029ef <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029ee:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029ef:	c9                   	leave  
801029f0:	c3                   	ret    
801029f1:	00 00                	add    %al,(%eax)
	...

801029f4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029f4:	55                   	push   %ebp
801029f5:	89 e5                	mov    %esp,%ebp
801029f7:	8b 45 08             	mov    0x8(%ebp),%eax
801029fa:	2d 00 00 00 80       	sub    $0x80000000,%eax
801029ff:	5d                   	pop    %ebp
80102a00:	c3                   	ret    

80102a01 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a01:	55                   	push   %ebp
80102a02:	89 e5                	mov    %esp,%ebp
80102a04:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a07:	c7 44 24 04 be 87 10 	movl   $0x801087be,0x4(%esp)
80102a0e:	80 
80102a0f:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102a16:	e8 17 25 00 00       	call   80104f32 <initlock>
  kmem.use_lock = 0;
80102a1b:	c7 05 94 f8 10 80 00 	movl   $0x0,0x8010f894
80102a22:	00 00 00 
  freerange(vstart, vend);
80102a25:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a28:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2f:	89 04 24             	mov    %eax,(%esp)
80102a32:	e8 26 00 00 00       	call   80102a5d <freerange>
}
80102a37:	c9                   	leave  
80102a38:	c3                   	ret    

80102a39 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a39:	55                   	push   %ebp
80102a3a:	89 e5                	mov    %esp,%ebp
80102a3c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a46:	8b 45 08             	mov    0x8(%ebp),%eax
80102a49:	89 04 24             	mov    %eax,(%esp)
80102a4c:	e8 0c 00 00 00       	call   80102a5d <freerange>
  kmem.use_lock = 1;
80102a51:	c7 05 94 f8 10 80 01 	movl   $0x1,0x8010f894
80102a58:	00 00 00 
}
80102a5b:	c9                   	leave  
80102a5c:	c3                   	ret    

80102a5d <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a5d:	55                   	push   %ebp
80102a5e:	89 e5                	mov    %esp,%ebp
80102a60:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a63:	8b 45 08             	mov    0x8(%ebp),%eax
80102a66:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a73:	eb 12                	jmp    80102a87 <freerange+0x2a>
    kfree(p);
80102a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a78:	89 04 24             	mov    %eax,(%esp)
80102a7b:	e8 19 00 00 00       	call   80102a99 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a80:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a8a:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102a90:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a93:	39 c2                	cmp    %eax,%edx
80102a95:	76 de                	jbe    80102a75 <freerange+0x18>
    kfree(p);
}
80102a97:	c9                   	leave  
80102a98:	c3                   	ret    

80102a99 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a99:	55                   	push   %ebp
80102a9a:	89 e5                	mov    %esp,%ebp
80102a9c:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa2:	25 ff 0f 00 00       	and    $0xfff,%eax
80102aa7:	85 c0                	test   %eax,%eax
80102aa9:	75 1b                	jne    80102ac6 <kfree+0x2d>
80102aab:	81 7d 08 1c 29 11 80 	cmpl   $0x8011291c,0x8(%ebp)
80102ab2:	72 12                	jb     80102ac6 <kfree+0x2d>
80102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab7:	89 04 24             	mov    %eax,(%esp)
80102aba:	e8 35 ff ff ff       	call   801029f4 <v2p>
80102abf:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ac4:	76 0c                	jbe    80102ad2 <kfree+0x39>
    panic("kfree");
80102ac6:	c7 04 24 c3 87 10 80 	movl   $0x801087c3,(%esp)
80102acd:	e8 68 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ad2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ad9:	00 
80102ada:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ae1:	00 
80102ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae5:	89 04 24             	mov    %eax,(%esp)
80102ae8:	e8 b5 26 00 00       	call   801051a2 <memset>

  if(kmem.use_lock)
80102aed:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102af2:	85 c0                	test   %eax,%eax
80102af4:	74 0c                	je     80102b02 <kfree+0x69>
    acquire(&kmem.lock);
80102af6:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102afd:	e8 51 24 00 00       	call   80104f53 <acquire>
  r = (struct run*)v;
80102b02:	8b 45 08             	mov    0x8(%ebp),%eax
80102b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b08:	8b 15 98 f8 10 80    	mov    0x8010f898,%edx
80102b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b11:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b16:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102b1b:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b20:	85 c0                	test   %eax,%eax
80102b22:	74 0c                	je     80102b30 <kfree+0x97>
    release(&kmem.lock);
80102b24:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b2b:	e8 84 24 00 00       	call   80104fb4 <release>
}
80102b30:	c9                   	leave  
80102b31:	c3                   	ret    

80102b32 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b32:	55                   	push   %ebp
80102b33:	89 e5                	mov    %esp,%ebp
80102b35:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b38:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b3d:	85 c0                	test   %eax,%eax
80102b3f:	74 0c                	je     80102b4d <kalloc+0x1b>
    acquire(&kmem.lock);
80102b41:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b48:	e8 06 24 00 00       	call   80104f53 <acquire>
  r = kmem.freelist;
80102b4d:	a1 98 f8 10 80       	mov    0x8010f898,%eax
80102b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b59:	74 0a                	je     80102b65 <kalloc+0x33>
    kmem.freelist = r->next;
80102b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5e:	8b 00                	mov    (%eax),%eax
80102b60:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102b65:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102b6a:	85 c0                	test   %eax,%eax
80102b6c:	74 0c                	je     80102b7a <kalloc+0x48>
    release(&kmem.lock);
80102b6e:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b75:	e8 3a 24 00 00       	call   80104fb4 <release>
  return (char*)r;
80102b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    
	...

80102b80 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 14             	sub    $0x14,%esp
80102b86:	8b 45 08             	mov    0x8(%ebp),%eax
80102b89:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b91:	89 c2                	mov    %eax,%edx
80102b93:	ec                   	in     (%dx),%al
80102b94:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b97:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b9b:	c9                   	leave  
80102b9c:	c3                   	ret    

80102b9d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b9d:	55                   	push   %ebp
80102b9e:	89 e5                	mov    %esp,%ebp
80102ba0:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102ba3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102baa:	e8 d1 ff ff ff       	call   80102b80 <inb>
80102baf:	0f b6 c0             	movzbl %al,%eax
80102bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb8:	83 e0 01             	and    $0x1,%eax
80102bbb:	85 c0                	test   %eax,%eax
80102bbd:	75 0a                	jne    80102bc9 <kbdgetc+0x2c>
    return -1;
80102bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bc4:	e9 20 01 00 00       	jmp    80102ce9 <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102bc9:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102bd0:	e8 ab ff ff ff       	call   80102b80 <inb>
80102bd5:	0f b6 c0             	movzbl %al,%eax
80102bd8:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102bdb:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102be2:	75 17                	jne    80102bfb <kbdgetc+0x5e>
    shift |= E0ESC;
80102be4:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102be9:	83 c8 40             	or     $0x40,%eax
80102bec:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102bf1:	b8 00 00 00 00       	mov    $0x0,%eax
80102bf6:	e9 ee 00 00 00       	jmp    80102ce9 <kbdgetc+0x14c>
  } else if(data & 0x80){
80102bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102bfe:	25 80 00 00 00       	and    $0x80,%eax
80102c03:	85 c0                	test   %eax,%eax
80102c05:	74 44                	je     80102c4b <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c07:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c0c:	83 e0 40             	and    $0x40,%eax
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	75 08                	jne    80102c1b <kbdgetc+0x7e>
80102c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c16:	83 e0 7f             	and    $0x7f,%eax
80102c19:	eb 03                	jmp    80102c1e <kbdgetc+0x81>
80102c1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c24:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c2b:	83 c8 40             	or     $0x40,%eax
80102c2e:	0f b6 c0             	movzbl %al,%eax
80102c31:	f7 d0                	not    %eax
80102c33:	89 c2                	mov    %eax,%edx
80102c35:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c3a:	21 d0                	and    %edx,%eax
80102c3c:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c41:	b8 00 00 00 00       	mov    $0x0,%eax
80102c46:	e9 9e 00 00 00       	jmp    80102ce9 <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102c4b:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c50:	83 e0 40             	and    $0x40,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	74 14                	je     80102c6b <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c57:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102c5e:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c63:	83 e0 bf             	and    $0xffffffbf,%eax
80102c66:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c6e:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102c75:	0f b6 d0             	movzbl %al,%edx
80102c78:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c7d:	09 d0                	or     %edx,%eax
80102c7f:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102c84:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c87:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102c8e:	0f b6 d0             	movzbl %al,%edx
80102c91:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c96:	31 d0                	xor    %edx,%eax
80102c98:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c9d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ca2:	83 e0 03             	and    $0x3,%eax
80102ca5:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102cac:	03 45 f8             	add    -0x8(%ebp),%eax
80102caf:	0f b6 00             	movzbl (%eax),%eax
80102cb2:	0f b6 c0             	movzbl %al,%eax
80102cb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102cb8:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cbd:	83 e0 08             	and    $0x8,%eax
80102cc0:	85 c0                	test   %eax,%eax
80102cc2:	74 22                	je     80102ce6 <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102cc4:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102cc8:	76 0c                	jbe    80102cd6 <kbdgetc+0x139>
80102cca:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102cce:	77 06                	ja     80102cd6 <kbdgetc+0x139>
      c += 'A' - 'a';
80102cd0:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102cd4:	eb 10                	jmp    80102ce6 <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102cd6:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102cda:	76 0a                	jbe    80102ce6 <kbdgetc+0x149>
80102cdc:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102ce0:	77 04                	ja     80102ce6 <kbdgetc+0x149>
      c += 'a' - 'A';
80102ce2:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    

80102ceb <kbdintr>:

void
kbdintr(void)
{
80102ceb:	55                   	push   %ebp
80102cec:	89 e5                	mov    %esp,%ebp
80102cee:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cf1:	c7 04 24 9d 2b 10 80 	movl   $0x80102b9d,(%esp)
80102cf8:	e8 ae da ff ff       	call   801007ab <consoleintr>
}
80102cfd:	c9                   	leave  
80102cfe:	c3                   	ret    
	...

80102d00 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	83 ec 08             	sub    $0x8,%esp
80102d06:	8b 55 08             	mov    0x8(%ebp),%edx
80102d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d0c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d10:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d13:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d17:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d1b:	ee                   	out    %al,(%dx)
}
80102d1c:	c9                   	leave  
80102d1d:	c3                   	ret    

80102d1e <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d1e:	55                   	push   %ebp
80102d1f:	89 e5                	mov    %esp,%ebp
80102d21:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d24:	9c                   	pushf  
80102d25:	58                   	pop    %eax
80102d26:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d2c:	c9                   	leave  
80102d2d:	c3                   	ret    

80102d2e <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d31:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d36:	8b 55 08             	mov    0x8(%ebp),%edx
80102d39:	c1 e2 02             	shl    $0x2,%edx
80102d3c:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d42:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d44:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d49:	83 c0 20             	add    $0x20,%eax
80102d4c:	8b 00                	mov    (%eax),%eax
}
80102d4e:	5d                   	pop    %ebp
80102d4f:	c3                   	ret    

80102d50 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d56:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102d5b:	85 c0                	test   %eax,%eax
80102d5d:	0f 84 46 01 00 00    	je     80102ea9 <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d63:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d6a:	00 
80102d6b:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d72:	e8 b7 ff ff ff       	call   80102d2e <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d77:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d7e:	00 
80102d7f:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d86:	e8 a3 ff ff ff       	call   80102d2e <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d8b:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d92:	00 
80102d93:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d9a:	e8 8f ff ff ff       	call   80102d2e <lapicw>
  lapicw(TICR, 10000000); 
80102d9f:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102da6:	00 
80102da7:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102dae:	e8 7b ff ff ff       	call   80102d2e <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102db3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dba:	00 
80102dbb:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102dc2:	e8 67 ff ff ff       	call   80102d2e <lapicw>
  lapicw(LINT1, MASKED);
80102dc7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dce:	00 
80102dcf:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102dd6:	e8 53 ff ff ff       	call   80102d2e <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ddb:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102de0:	83 c0 30             	add    $0x30,%eax
80102de3:	8b 00                	mov    (%eax),%eax
80102de5:	c1 e8 10             	shr    $0x10,%eax
80102de8:	25 ff 00 00 00       	and    $0xff,%eax
80102ded:	83 f8 03             	cmp    $0x3,%eax
80102df0:	76 14                	jbe    80102e06 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102df2:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102df9:	00 
80102dfa:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e01:	e8 28 ff ff ff       	call   80102d2e <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e06:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e0d:	00 
80102e0e:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e15:	e8 14 ff ff ff       	call   80102d2e <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e21:	00 
80102e22:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e29:	e8 00 ff ff ff       	call   80102d2e <lapicw>
  lapicw(ESR, 0);
80102e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e35:	00 
80102e36:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e3d:	e8 ec fe ff ff       	call   80102d2e <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e49:	00 
80102e4a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e51:	e8 d8 fe ff ff       	call   80102d2e <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e5d:	00 
80102e5e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e65:	e8 c4 fe ff ff       	call   80102d2e <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e6a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e71:	00 
80102e72:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e79:	e8 b0 fe ff ff       	call   80102d2e <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e7e:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e83:	05 00 03 00 00       	add    $0x300,%eax
80102e88:	8b 00                	mov    (%eax),%eax
80102e8a:	25 00 10 00 00       	and    $0x1000,%eax
80102e8f:	85 c0                	test   %eax,%eax
80102e91:	75 eb                	jne    80102e7e <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e9a:	00 
80102e9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102ea2:	e8 87 fe ff ff       	call   80102d2e <lapicw>
80102ea7:	eb 01                	jmp    80102eaa <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102ea9:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102eaa:	c9                   	leave  
80102eab:	c3                   	ret    

80102eac <cpunum>:

int
cpunum(void)
{
80102eac:	55                   	push   %ebp
80102ead:	89 e5                	mov    %esp,%ebp
80102eaf:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102eb2:	e8 67 fe ff ff       	call   80102d1e <readeflags>
80102eb7:	25 00 02 00 00       	and    $0x200,%eax
80102ebc:	85 c0                	test   %eax,%eax
80102ebe:	74 29                	je     80102ee9 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102ec0:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102ec5:	85 c0                	test   %eax,%eax
80102ec7:	0f 94 c2             	sete   %dl
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	a3 60 b6 10 80       	mov    %eax,0x8010b660
80102ed2:	84 d2                	test   %dl,%dl
80102ed4:	74 13                	je     80102ee9 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ed6:	8b 45 04             	mov    0x4(%ebp),%eax
80102ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102edd:	c7 04 24 cc 87 10 80 	movl   $0x801087cc,(%esp)
80102ee4:	e8 b1 d4 ff ff       	call   8010039a <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ee9:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102eee:	85 c0                	test   %eax,%eax
80102ef0:	74 0f                	je     80102f01 <cpunum+0x55>
    return lapic[ID]>>24;
80102ef2:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102ef7:	83 c0 20             	add    $0x20,%eax
80102efa:	8b 00                	mov    (%eax),%eax
80102efc:	c1 e8 18             	shr    $0x18,%eax
80102eff:	eb 05                	jmp    80102f06 <cpunum+0x5a>
  return 0;
80102f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f06:	c9                   	leave  
80102f07:	c3                   	ret    

80102f08 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f08:	55                   	push   %ebp
80102f09:	89 e5                	mov    %esp,%ebp
80102f0b:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f0e:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102f13:	85 c0                	test   %eax,%eax
80102f15:	74 14                	je     80102f2b <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f17:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f1e:	00 
80102f1f:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f26:	e8 03 fe ff ff       	call   80102d2e <lapicw>
}
80102f2b:	c9                   	leave  
80102f2c:	c3                   	ret    

80102f2d <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f2d:	55                   	push   %ebp
80102f2e:	89 e5                	mov    %esp,%ebp
}
80102f30:	5d                   	pop    %ebp
80102f31:	c3                   	ret    

80102f32 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f32:	55                   	push   %ebp
80102f33:	89 e5                	mov    %esp,%ebp
80102f35:	83 ec 1c             	sub    $0x1c,%esp
80102f38:	8b 45 08             	mov    0x8(%ebp),%eax
80102f3b:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f3e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f45:	00 
80102f46:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f4d:	e8 ae fd ff ff       	call   80102d00 <outb>
  outb(IO_RTC+1, 0x0A);
80102f52:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f59:	00 
80102f5a:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f61:	e8 9a fd ff ff       	call   80102d00 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f66:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80102f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f70:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f78:	8d 50 02             	lea    0x2(%eax),%edx
80102f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f7e:	c1 e8 04             	shr    $0x4,%eax
80102f81:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f84:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f88:	c1 e0 18             	shl    $0x18,%eax
80102f8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f8f:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f96:	e8 93 fd ff ff       	call   80102d2e <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f9b:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fa2:	00 
80102fa3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102faa:	e8 7f fd ff ff       	call   80102d2e <lapicw>
  microdelay(200);
80102faf:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb6:	e8 72 ff ff ff       	call   80102f2d <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fbb:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fc2:	00 
80102fc3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fca:	e8 5f fd ff ff       	call   80102d2e <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fcf:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fd6:	e8 52 ff ff ff       	call   80102f2d <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fdb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80102fe2:	eb 40                	jmp    80103024 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fe4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fe8:	c1 e0 18             	shl    $0x18,%eax
80102feb:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fef:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ff6:	e8 33 fd ff ff       	call   80102d2e <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ffe:	c1 e8 0c             	shr    $0xc,%eax
80103001:	80 cc 06             	or     $0x6,%ah
80103004:	89 44 24 04          	mov    %eax,0x4(%esp)
80103008:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010300f:	e8 1a fd ff ff       	call   80102d2e <lapicw>
    microdelay(200);
80103014:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010301b:	e8 0d ff ff ff       	call   80102f2d <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103020:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80103024:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80103028:	7e ba                	jle    80102fe4 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010302a:	c9                   	leave  
8010302b:	c3                   	ret    

8010302c <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
8010302c:	55                   	push   %ebp
8010302d:	89 e5                	mov    %esp,%ebp
8010302f:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
80103032:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103033:	c7 44 24 04 f8 87 10 	movl   $0x801087f8,0x4(%esp)
8010303a:	80 
8010303b:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103042:	e8 eb 1e 00 00       	call   80104f32 <initlock>
  readsb(ROOTDEV, &sb);
80103047:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010304a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010304e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103055:	e8 c2 e2 ff ff       	call   8010131c <readsb>
  log.start = sb.size - sb.nlog;
8010305a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103060:	89 d1                	mov    %edx,%ecx
80103062:	29 c1                	sub    %eax,%ecx
80103064:	89 c8                	mov    %ecx,%eax
80103066:	a3 d4 f8 10 80       	mov    %eax,0x8010f8d4
  log.size = sb.nlog;
8010306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010306e:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  log.dev = ROOTDEV;
80103073:	c7 05 e0 f8 10 80 01 	movl   $0x1,0x8010f8e0
8010307a:	00 00 00 
  recover_from_log();
8010307d:	e8 97 01 00 00       	call   80103219 <recover_from_log>
}
80103082:	c9                   	leave  
80103083:	c3                   	ret    

80103084 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010308a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80103091:	e9 89 00 00 00       	jmp    8010311f <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103096:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
8010309b:	03 45 ec             	add    -0x14(%ebp),%eax
8010309e:	83 c0 01             	add    $0x1,%eax
801030a1:	89 c2                	mov    %eax,%edx
801030a3:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
801030a8:	89 54 24 04          	mov    %edx,0x4(%esp)
801030ac:	89 04 24             	mov    %eax,(%esp)
801030af:	e8 f3 d0 ff ff       	call   801001a7 <bread>
801030b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030ba:	83 c0 10             	add    $0x10,%eax
801030bd:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
801030c4:	89 c2                	mov    %eax,%edx
801030c6:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
801030cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801030cf:	89 04 24             	mov    %eax,(%esp)
801030d2:	e8 d0 d0 ff ff       	call   801001a7 <bread>
801030d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030dd:	8d 50 18             	lea    0x18(%eax),%edx
801030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030e3:	83 c0 18             	add    $0x18,%eax
801030e6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030ed:	00 
801030ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801030f2:	89 04 24             	mov    %eax,(%esp)
801030f5:	e8 7b 21 00 00       	call   80105275 <memmove>
    bwrite(dbuf);  // write dst to disk
801030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030fd:	89 04 24             	mov    %eax,(%esp)
80103100:	e8 d9 d0 ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
80103105:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103108:	89 04 24             	mov    %eax,(%esp)
8010310b:	e8 08 d1 ff ff       	call   80100218 <brelse>
    brelse(dbuf);
80103110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103113:	89 04 24             	mov    %eax,(%esp)
80103116:	e8 fd d0 ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010311b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010311f:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103124:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103127:	0f 8f 69 ff ff ff    	jg     80103096 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010312d:	c9                   	leave  
8010312e:	c3                   	ret    

8010312f <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010312f:	55                   	push   %ebp
80103130:	89 e5                	mov    %esp,%ebp
80103132:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103135:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
8010313a:	89 c2                	mov    %eax,%edx
8010313c:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103141:	89 54 24 04          	mov    %edx,0x4(%esp)
80103145:	89 04 24             	mov    %eax,(%esp)
80103148:	e8 5a d0 ff ff       	call   801001a7 <bread>
8010314d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103150:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103153:	83 c0 18             	add    $0x18,%eax
80103156:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
80103159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010315c:	8b 00                	mov    (%eax),%eax
8010315e:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  for (i = 0; i < log.lh.n; i++) {
80103163:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010316a:	eb 1b                	jmp    80103187 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010316c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010316f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103175:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103179:	8d 51 10             	lea    0x10(%ecx),%edx
8010317c:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103183:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103187:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010318c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010318f:	7f db                	jg     8010316c <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103191:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103194:	89 04 24             	mov    %eax,(%esp)
80103197:	e8 7c d0 ff ff       	call   80100218 <brelse>
}
8010319c:	c9                   	leave  
8010319d:	c3                   	ret    

8010319e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010319e:	55                   	push   %ebp
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801031a4:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
801031a9:	89 c2                	mov    %eax,%edx
801031ab:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
801031b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801031b4:	89 04 24             	mov    %eax,(%esp)
801031b7:	e8 eb cf ff ff       	call   801001a7 <bread>
801031bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c2:	83 c0 18             	add    $0x18,%eax
801031c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
801031c8:	8b 15 e4 f8 10 80    	mov    0x8010f8e4,%edx
801031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031d1:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031da:	eb 1b                	jmp    801031f7 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031e2:	83 c0 10             	add    $0x10,%eax
801031e5:	8b 0c 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%ecx
801031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031ef:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031f7:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801031fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031ff:	7f db                	jg     801031dc <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103201:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103204:	89 04 24             	mov    %eax,(%esp)
80103207:	e8 d2 cf ff ff       	call   801001de <bwrite>
  brelse(buf);
8010320c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010320f:	89 04 24             	mov    %eax,(%esp)
80103212:	e8 01 d0 ff ff       	call   80100218 <brelse>
}
80103217:	c9                   	leave  
80103218:	c3                   	ret    

80103219 <recover_from_log>:

static void
recover_from_log(void)
{
80103219:	55                   	push   %ebp
8010321a:	89 e5                	mov    %esp,%ebp
8010321c:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010321f:	e8 0b ff ff ff       	call   8010312f <read_head>
  install_trans(); // if committed, copy from log to disk
80103224:	e8 5b fe ff ff       	call   80103084 <install_trans>
  log.lh.n = 0;
80103229:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
80103230:	00 00 00 
  write_head(); // clear the log
80103233:	e8 66 ff ff ff       	call   8010319e <write_head>
}
80103238:	c9                   	leave  
80103239:	c3                   	ret    

8010323a <begin_trans>:

void
begin_trans(void)
{
8010323a:	55                   	push   %ebp
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103240:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103247:	e8 07 1d 00 00       	call   80104f53 <acquire>
  while (log.busy) {
8010324c:	eb 14                	jmp    80103262 <begin_trans+0x28>
    sleep(&log, &log.lock);
8010324e:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
80103255:	80 
80103256:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010325d:	e8 77 19 00 00       	call   80104bd9 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103262:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80103267:	85 c0                	test   %eax,%eax
80103269:	75 e3                	jne    8010324e <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010326b:	c7 05 dc f8 10 80 01 	movl   $0x1,0x8010f8dc
80103272:	00 00 00 
  release(&log.lock);
80103275:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010327c:	e8 33 1d 00 00       	call   80104fb4 <release>
}
80103281:	c9                   	leave  
80103282:	c3                   	ret    

80103283 <commit_trans>:

void
commit_trans(void)
{
80103283:	55                   	push   %ebp
80103284:	89 e5                	mov    %esp,%ebp
80103286:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103289:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	7e 19                	jle    801032ab <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103292:	e8 07 ff ff ff       	call   8010319e <write_head>
    install_trans(); // Now install writes to home locations
80103297:	e8 e8 fd ff ff       	call   80103084 <install_trans>
    log.lh.n = 0; 
8010329c:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
801032a3:	00 00 00 
    write_head();    // Erase the transaction from the log
801032a6:	e8 f3 fe ff ff       	call   8010319e <write_head>
  }
  
  acquire(&log.lock);
801032ab:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801032b2:	e8 9c 1c 00 00       	call   80104f53 <acquire>
  log.busy = 0;
801032b7:	c7 05 dc f8 10 80 00 	movl   $0x0,0x8010f8dc
801032be:	00 00 00 
  wakeup(&log);
801032c1:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801032c8:	e8 52 1a 00 00       	call   80104d1f <wakeup>
  release(&log.lock);
801032cd:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801032d4:	e8 db 1c 00 00       	call   80104fb4 <release>
}
801032d9:	c9                   	leave  
801032da:	c3                   	ret    

801032db <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032db:	55                   	push   %ebp
801032dc:	89 e5                	mov    %esp,%ebp
801032de:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032e1:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801032e6:	83 f8 09             	cmp    $0x9,%eax
801032e9:	7f 12                	jg     801032fd <log_write+0x22>
801032eb:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801032f0:	8b 15 d8 f8 10 80    	mov    0x8010f8d8,%edx
801032f6:	83 ea 01             	sub    $0x1,%edx
801032f9:	39 d0                	cmp    %edx,%eax
801032fb:	7c 0c                	jl     80103309 <log_write+0x2e>
    panic("too big a transaction");
801032fd:	c7 04 24 fc 87 10 80 	movl   $0x801087fc,(%esp)
80103304:	e8 31 d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
80103309:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
8010330e:	85 c0                	test   %eax,%eax
80103310:	75 0c                	jne    8010331e <log_write+0x43>
    panic("write outside of trans");
80103312:	c7 04 24 12 88 10 80 	movl   $0x80108812,(%esp)
80103319:	e8 1c d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
8010331e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103325:	eb 1d                	jmp    80103344 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
80103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332a:	83 c0 10             	add    $0x10,%eax
8010332d:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
80103334:	89 c2                	mov    %eax,%edx
80103336:	8b 45 08             	mov    0x8(%ebp),%eax
80103339:	8b 40 08             	mov    0x8(%eax),%eax
8010333c:	39 c2                	cmp    %eax,%edx
8010333e:	74 10                	je     80103350 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103340:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103344:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103349:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010334c:	7f d9                	jg     80103327 <log_write+0x4c>
8010334e:	eb 01                	jmp    80103351 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103350:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103351:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	8b 40 08             	mov    0x8(%eax),%eax
8010335a:	83 c2 10             	add    $0x10,%edx
8010335d:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103364:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103369:	03 45 f0             	add    -0x10(%ebp),%eax
8010336c:	83 c0 01             	add    $0x1,%eax
8010336f:	89 c2                	mov    %eax,%edx
80103371:	8b 45 08             	mov    0x8(%ebp),%eax
80103374:	8b 40 04             	mov    0x4(%eax),%eax
80103377:	89 54 24 04          	mov    %edx,0x4(%esp)
8010337b:	89 04 24             	mov    %eax,(%esp)
8010337e:	e8 24 ce ff ff       	call   801001a7 <bread>
80103383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103386:	8b 45 08             	mov    0x8(%ebp),%eax
80103389:	8d 50 18             	lea    0x18(%eax),%edx
8010338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010338f:	83 c0 18             	add    $0x18,%eax
80103392:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103399:	00 
8010339a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010339e:	89 04 24             	mov    %eax,(%esp)
801033a1:	e8 cf 1e 00 00       	call   80105275 <memmove>
  bwrite(lbuf);
801033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033a9:	89 04 24             	mov    %eax,(%esp)
801033ac:	e8 2d ce ff ff       	call   801001de <bwrite>
  brelse(lbuf);
801033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b4:	89 04 24             	mov    %eax,(%esp)
801033b7:	e8 5c ce ff ff       	call   80100218 <brelse>
  if (i == log.lh.n)
801033bc:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801033c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801033c4:	75 0d                	jne    801033d3 <log_write+0xf8>
    log.lh.n++;
801033c6:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
801033cb:	83 c0 01             	add    $0x1,%eax
801033ce:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033d3:	8b 45 08             	mov    0x8(%ebp),%eax
801033d6:	8b 00                	mov    (%eax),%eax
801033d8:	89 c2                	mov    %eax,%edx
801033da:	83 ca 04             	or     $0x4,%edx
801033dd:	8b 45 08             	mov    0x8(%ebp),%eax
801033e0:	89 10                	mov    %edx,(%eax)
}
801033e2:	c9                   	leave  
801033e3:	c3                   	ret    

801033e4 <v2p>:
801033e4:	55                   	push   %ebp
801033e5:	89 e5                	mov    %esp,%ebp
801033e7:	8b 45 08             	mov    0x8(%ebp),%eax
801033ea:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033ef:	5d                   	pop    %ebp
801033f0:	c3                   	ret    

801033f1 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033f1:	55                   	push   %ebp
801033f2:	89 e5                	mov    %esp,%ebp
801033f4:	8b 45 08             	mov    0x8(%ebp),%eax
801033f7:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033fc:	5d                   	pop    %ebp
801033fd:	c3                   	ret    

801033fe <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033fe:	55                   	push   %ebp
801033ff:	89 e5                	mov    %esp,%ebp
80103401:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103404:	8b 55 08             	mov    0x8(%ebp),%edx
80103407:	8b 45 0c             	mov    0xc(%ebp),%eax
8010340a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010340d:	f0 87 02             	lock xchg %eax,(%edx)
80103410:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103413:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103416:	c9                   	leave  
80103417:	c3                   	ret    

80103418 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103418:	55                   	push   %ebp
80103419:	89 e5                	mov    %esp,%ebp
8010341b:	83 e4 f0             	and    $0xfffffff0,%esp
8010341e:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103421:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103428:	80 
80103429:	c7 04 24 1c 29 11 80 	movl   $0x8011291c,(%esp)
80103430:	e8 cc f5 ff ff       	call   80102a01 <kinit1>
  kvmalloc();      // kernel page table
80103435:	e8 09 4a 00 00       	call   80107e43 <kvmalloc>
  mpinit();        // collect info about this machine
8010343a:	e8 45 04 00 00       	call   80103884 <mpinit>
  lapicinit();
8010343f:	e8 0c f9 ff ff       	call   80102d50 <lapicinit>
  seginit();       // set up segments
80103444:	e8 9c 43 00 00       	call   801077e5 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103449:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010344f:	0f b6 00             	movzbl (%eax),%eax
80103452:	0f b6 c0             	movzbl %al,%eax
80103455:	89 44 24 04          	mov    %eax,0x4(%esp)
80103459:	c7 04 24 29 88 10 80 	movl   $0x80108829,(%esp)
80103460:	e8 35 cf ff ff       	call   8010039a <cprintf>
  picinit();       // interrupt controller
80103465:	e8 80 06 00 00       	call   80103aea <picinit>
  ioapicinit();    // another interrupt controller
8010346a:	e8 82 f4 ff ff       	call   801028f1 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010346f:	e8 14 d6 ff ff       	call   80100a88 <consoleinit>
  uartinit();      // serial port
80103474:	e8 b6 36 00 00       	call   80106b2f <uartinit>
  pinit();         // process table
80103479:	e8 03 0c 00 00       	call   80104081 <pinit>
  tvinit();        // trap vectors
8010347e:	e8 5f 32 00 00       	call   801066e2 <tvinit>
  binit();         // buffer cache
80103483:	e8 ac cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103488:	e8 a3 da ff ff       	call   80100f30 <fileinit>
  iinit();         // inode cache
8010348d:	e8 58 e1 ff ff       	call   801015ea <iinit>
  ideinit();       // disk
80103492:	e8 c1 f0 ff ff       	call   80102558 <ideinit>
  if(!ismp)
80103497:	a1 24 f9 10 80       	mov    0x8010f924,%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	75 05                	jne    801034a5 <main+0x8d>
    timerinit();   // uniprocessor timer
801034a0:	e8 85 31 00 00       	call   8010662a <timerinit>
  startothers();   // start other processors
801034a5:	e8 7f 00 00 00       	call   80103529 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034aa:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034b1:	8e 
801034b2:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801034b9:	e8 7b f5 ff ff       	call   80102a39 <kinit2>
  userinit();      // first user process
801034be:	e8 dd 0c 00 00       	call   801041a0 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034c3:	e8 1a 00 00 00       	call   801034e2 <mpmain>

801034c8 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034c8:	55                   	push   %ebp
801034c9:	89 e5                	mov    %esp,%ebp
801034cb:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801034ce:	e8 87 49 00 00       	call   80107e5a <switchkvm>
  seginit();
801034d3:	e8 0d 43 00 00       	call   801077e5 <seginit>
  lapicinit();
801034d8:	e8 73 f8 ff ff       	call   80102d50 <lapicinit>
  mpmain();
801034dd:	e8 00 00 00 00       	call   801034e2 <mpmain>

801034e2 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034e2:	55                   	push   %ebp
801034e3:	89 e5                	mov    %esp,%ebp
801034e5:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034ee:	0f b6 00             	movzbl (%eax),%eax
801034f1:	0f b6 c0             	movzbl %al,%eax
801034f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801034f8:	c7 04 24 40 88 10 80 	movl   $0x80108840,(%esp)
801034ff:	e8 96 ce ff ff       	call   8010039a <cprintf>
  idtinit();       // load idt register
80103504:	e8 49 33 00 00       	call   80106852 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103509:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010350f:	05 a8 00 00 00       	add    $0xa8,%eax
80103514:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010351b:	00 
8010351c:	89 04 24             	mov    %eax,(%esp)
8010351f:	e8 da fe ff ff       	call   801033fe <xchg>
  scheduler();     // start running processes
80103524:	e8 da 14 00 00       	call   80104a03 <scheduler>

80103529 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103529:	55                   	push   %ebp
8010352a:	89 e5                	mov    %esp,%ebp
8010352c:	53                   	push   %ebx
8010352d:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103530:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103537:	e8 b5 fe ff ff       	call   801033f1 <p2v>
8010353c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010353f:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103544:	89 44 24 08          	mov    %eax,0x8(%esp)
80103548:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
8010354f:	80 
80103550:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103553:	89 04 24             	mov    %eax,(%esp)
80103556:	e8 1a 1d 00 00       	call   80105275 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010355b:	c7 45 f0 40 f9 10 80 	movl   $0x8010f940,-0x10(%ebp)
80103562:	e9 85 00 00 00       	jmp    801035ec <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103567:	e8 40 f9 ff ff       	call   80102eac <cpunum>
8010356c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103572:	05 40 f9 10 80       	add    $0x8010f940,%eax
80103577:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010357a:	74 68                	je     801035e4 <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010357c:	e8 b1 f5 ff ff       	call   80102b32 <kalloc>
80103581:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103584:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103587:	83 e8 04             	sub    $0x4,%eax
8010358a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010358d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103593:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103595:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103598:	83 e8 08             	sub    $0x8,%eax
8010359b:	c7 00 c8 34 10 80    	movl   $0x801034c8,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a4:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035a7:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801035ae:	e8 31 fe ff ff       	call   801033e4 <v2p>
801035b3:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035b8:	89 04 24             	mov    %eax,(%esp)
801035bb:	e8 24 fe ff ff       	call   801033e4 <v2p>
801035c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801035c3:	0f b6 12             	movzbl (%edx),%edx
801035c6:	0f b6 d2             	movzbl %dl,%edx
801035c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801035cd:	89 14 24             	mov    %edx,(%esp)
801035d0:	e8 5d f9 ff ff       	call   80102f32 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035d8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 f3                	je     801035d5 <startothers+0xac>
801035e2:	eb 01                	jmp    801035e5 <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035e4:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035e5:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801035ec:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801035f1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035f7:	05 40 f9 10 80       	add    $0x8010f940,%eax
801035fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801035ff:	0f 87 62 ff ff ff    	ja     80103567 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103605:	83 c4 24             	add    $0x24,%esp
80103608:	5b                   	pop    %ebx
80103609:	5d                   	pop    %ebp
8010360a:	c3                   	ret    
	...

8010360c <p2v>:
8010360c:	55                   	push   %ebp
8010360d:	89 e5                	mov    %esp,%ebp
8010360f:	8b 45 08             	mov    0x8(%ebp),%eax
80103612:	2d 00 00 00 80       	sub    $0x80000000,%eax
80103617:	5d                   	pop    %ebp
80103618:	c3                   	ret    

80103619 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103619:	55                   	push   %ebp
8010361a:	89 e5                	mov    %esp,%ebp
8010361c:	83 ec 14             	sub    $0x14,%esp
8010361f:	8b 45 08             	mov    0x8(%ebp),%eax
80103622:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103626:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010362a:	89 c2                	mov    %eax,%edx
8010362c:	ec                   	in     (%dx),%al
8010362d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103630:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103634:	c9                   	leave  
80103635:	c3                   	ret    

80103636 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103636:	55                   	push   %ebp
80103637:	89 e5                	mov    %esp,%ebp
80103639:	83 ec 08             	sub    $0x8,%esp
8010363c:	8b 55 08             	mov    0x8(%ebp),%edx
8010363f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103642:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103646:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103649:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010364d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103651:	ee                   	out    %al,(%dx)
}
80103652:	c9                   	leave  
80103653:	c3                   	ret    

80103654 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103657:	a1 64 b6 10 80       	mov    0x8010b664,%eax
8010365c:	89 c2                	mov    %eax,%edx
8010365e:	b8 40 f9 10 80       	mov    $0x8010f940,%eax
80103663:	89 d1                	mov    %edx,%ecx
80103665:	29 c1                	sub    %eax,%ecx
80103667:	89 c8                	mov    %ecx,%eax
80103669:	c1 f8 02             	sar    $0x2,%eax
8010366c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103672:	5d                   	pop    %ebp
80103673:	c3                   	ret    

80103674 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103674:	55                   	push   %ebp
80103675:	89 e5                	mov    %esp,%ebp
80103677:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010367a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103681:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103688:	eb 13                	jmp    8010369d <sum+0x29>
    sum += addr[i];
8010368a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010368d:	03 45 08             	add    0x8(%ebp),%eax
80103690:	0f b6 00             	movzbl (%eax),%eax
80103693:	0f b6 c0             	movzbl %al,%eax
80103696:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103699:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010369d:	8b 45 f8             	mov    -0x8(%ebp),%eax
801036a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036a3:	7c e5                	jl     8010368a <sum+0x16>
    sum += addr[i];
  return sum;
801036a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    

801036aa <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036aa:	55                   	push   %ebp
801036ab:	89 e5                	mov    %esp,%ebp
801036ad:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036b0:	8b 45 08             	mov    0x8(%ebp),%eax
801036b3:	89 04 24             	mov    %eax,(%esp)
801036b6:	e8 51 ff ff ff       	call   8010360c <p2v>
801036bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
801036be:	8b 45 0c             	mov    0xc(%ebp),%eax
801036c1:	03 45 f4             	add    -0xc(%ebp),%eax
801036c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
801036cd:	eb 3f                	jmp    8010370e <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036cf:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036d6:	00 
801036d7:	c7 44 24 04 54 88 10 	movl   $0x80108854,0x4(%esp)
801036de:	80 
801036df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036e2:	89 04 24             	mov    %eax,(%esp)
801036e5:	e8 2f 1b 00 00       	call   80105219 <memcmp>
801036ea:	85 c0                	test   %eax,%eax
801036ec:	75 1c                	jne    8010370a <mpsearch1+0x60>
801036ee:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036f5:	00 
801036f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036f9:	89 04 24             	mov    %eax,(%esp)
801036fc:	e8 73 ff ff ff       	call   80103674 <sum>
80103701:	84 c0                	test   %al,%al
80103703:	75 05                	jne    8010370a <mpsearch1+0x60>
      return (struct mp*)p;
80103705:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103708:	eb 11                	jmp    8010371b <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010370a:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
8010370e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103711:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103714:	72 b9                	jb     801036cf <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103716:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010371b:	c9                   	leave  
8010371c:	c3                   	ret    

8010371d <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010371d:	55                   	push   %ebp
8010371e:	89 e5                	mov    %esp,%ebp
80103720:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103723:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010372a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010372d:	83 c0 0f             	add    $0xf,%eax
80103730:	0f b6 00             	movzbl (%eax),%eax
80103733:	0f b6 c0             	movzbl %al,%eax
80103736:	89 c2                	mov    %eax,%edx
80103738:	c1 e2 08             	shl    $0x8,%edx
8010373b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010373e:	83 c0 0e             	add    $0xe,%eax
80103741:	0f b6 00             	movzbl (%eax),%eax
80103744:	0f b6 c0             	movzbl %al,%eax
80103747:	09 d0                	or     %edx,%eax
80103749:	c1 e0 04             	shl    $0x4,%eax
8010374c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010374f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103753:	74 21                	je     80103776 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103755:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010375c:	00 
8010375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103760:	89 04 24             	mov    %eax,(%esp)
80103763:	e8 42 ff ff ff       	call   801036aa <mpsearch1>
80103768:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010376b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010376f:	74 50                	je     801037c1 <mpsearch+0xa4>
      return mp;
80103771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103774:	eb 5f                	jmp    801037d5 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103776:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103779:	83 c0 14             	add    $0x14,%eax
8010377c:	0f b6 00             	movzbl (%eax),%eax
8010377f:	0f b6 c0             	movzbl %al,%eax
80103782:	89 c2                	mov    %eax,%edx
80103784:	c1 e2 08             	shl    $0x8,%edx
80103787:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378a:	83 c0 13             	add    $0x13,%eax
8010378d:	0f b6 00             	movzbl (%eax),%eax
80103790:	0f b6 c0             	movzbl %al,%eax
80103793:	09 d0                	or     %edx,%eax
80103795:	c1 e0 0a             	shl    $0xa,%eax
80103798:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010379b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010379e:	2d 00 04 00 00       	sub    $0x400,%eax
801037a3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037aa:	00 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 f7 fe ff ff       	call   801036aa <mpsearch1>
801037b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037ba:	74 05                	je     801037c1 <mpsearch+0xa4>
      return mp;
801037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037bf:	eb 14                	jmp    801037d5 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801037c1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037c8:	00 
801037c9:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037d0:	e8 d5 fe ff ff       	call   801036aa <mpsearch1>
}
801037d5:	c9                   	leave  
801037d6:	c3                   	ret    

801037d7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037d7:	55                   	push   %ebp
801037d8:	89 e5                	mov    %esp,%ebp
801037da:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037dd:	e8 3b ff ff ff       	call   8010371d <mpsearch>
801037e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037e9:	74 0a                	je     801037f5 <mpconfig+0x1e>
801037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037ee:	8b 40 04             	mov    0x4(%eax),%eax
801037f1:	85 c0                	test   %eax,%eax
801037f3:	75 0a                	jne    801037ff <mpconfig+0x28>
    return 0;
801037f5:	b8 00 00 00 00       	mov    $0x0,%eax
801037fa:	e9 83 00 00 00       	jmp    80103882 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103802:	8b 40 04             	mov    0x4(%eax),%eax
80103805:	89 04 24             	mov    %eax,(%esp)
80103808:	e8 ff fd ff ff       	call   8010360c <p2v>
8010380d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103810:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103817:	00 
80103818:	c7 44 24 04 59 88 10 	movl   $0x80108859,0x4(%esp)
8010381f:	80 
80103820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103823:	89 04 24             	mov    %eax,(%esp)
80103826:	e8 ee 19 00 00       	call   80105219 <memcmp>
8010382b:	85 c0                	test   %eax,%eax
8010382d:	74 07                	je     80103836 <mpconfig+0x5f>
    return 0;
8010382f:	b8 00 00 00 00       	mov    $0x0,%eax
80103834:	eb 4c                	jmp    80103882 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103836:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103839:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010383d:	3c 01                	cmp    $0x1,%al
8010383f:	74 12                	je     80103853 <mpconfig+0x7c>
80103841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103844:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103848:	3c 04                	cmp    $0x4,%al
8010384a:	74 07                	je     80103853 <mpconfig+0x7c>
    return 0;
8010384c:	b8 00 00 00 00       	mov    $0x0,%eax
80103851:	eb 2f                	jmp    80103882 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103856:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010385a:	0f b7 d0             	movzwl %ax,%edx
8010385d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103860:	89 54 24 04          	mov    %edx,0x4(%esp)
80103864:	89 04 24             	mov    %eax,(%esp)
80103867:	e8 08 fe ff ff       	call   80103674 <sum>
8010386c:	84 c0                	test   %al,%al
8010386e:	74 07                	je     80103877 <mpconfig+0xa0>
    return 0;
80103870:	b8 00 00 00 00       	mov    $0x0,%eax
80103875:	eb 0b                	jmp    80103882 <mpconfig+0xab>
  *pmp = mp;
80103877:	8b 45 08             	mov    0x8(%ebp),%eax
8010387a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010387d:	89 10                	mov    %edx,(%eax)
  return conf;
8010387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103882:	c9                   	leave  
80103883:	c3                   	ret    

80103884 <mpinit>:

void
mpinit(void)
{
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010388a:	c7 05 64 b6 10 80 40 	movl   $0x8010f940,0x8010b664
80103891:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103894:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103897:	89 04 24             	mov    %eax,(%esp)
8010389a:	e8 38 ff ff ff       	call   801037d7 <mpconfig>
8010389f:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801038a6:	0f 84 9d 01 00 00    	je     80103a49 <mpinit+0x1c5>
    return;
  ismp = 1;
801038ac:	c7 05 24 f9 10 80 01 	movl   $0x1,0x8010f924
801038b3:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038b9:	8b 40 24             	mov    0x24(%eax),%eax
801038bc:	a3 9c f8 10 80       	mov    %eax,0x8010f89c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038c4:	83 c0 2c             	add    $0x2c,%eax
801038c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038d0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038d4:	0f b7 c0             	movzwl %ax,%eax
801038d7:	8d 04 02             	lea    (%edx,%eax,1),%eax
801038da:	89 45 e8             	mov    %eax,-0x18(%ebp)
801038dd:	e9 f2 00 00 00       	jmp    801039d4 <mpinit+0x150>
    switch(*p){
801038e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038e5:	0f b6 00             	movzbl (%eax),%eax
801038e8:	0f b6 c0             	movzbl %al,%eax
801038eb:	83 f8 04             	cmp    $0x4,%eax
801038ee:	0f 87 bd 00 00 00    	ja     801039b1 <mpinit+0x12d>
801038f4:	8b 04 85 9c 88 10 80 	mov    -0x7fef7764(,%eax,4),%eax
801038fb:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103900:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
80103903:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103906:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010390a:	0f b6 d0             	movzbl %al,%edx
8010390d:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103912:	39 c2                	cmp    %eax,%edx
80103914:	74 2d                	je     80103943 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103919:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010391d:	0f b6 d0             	movzbl %al,%edx
80103920:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103925:	89 54 24 08          	mov    %edx,0x8(%esp)
80103929:	89 44 24 04          	mov    %eax,0x4(%esp)
8010392d:	c7 04 24 5e 88 10 80 	movl   $0x8010885e,(%esp)
80103934:	e8 61 ca ff ff       	call   8010039a <cprintf>
        ismp = 0;
80103939:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
80103940:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103946:	0f b6 40 03          	movzbl 0x3(%eax),%eax
8010394a:	0f b6 c0             	movzbl %al,%eax
8010394d:	83 e0 02             	and    $0x2,%eax
80103950:	85 c0                	test   %eax,%eax
80103952:	74 15                	je     80103969 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103954:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103959:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010395f:	05 40 f9 10 80       	add    $0x8010f940,%eax
80103964:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103969:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010396e:	8b 15 20 ff 10 80    	mov    0x8010ff20,%edx
80103974:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010397a:	88 90 40 f9 10 80    	mov    %dl,-0x7fef06c0(%eax)
      ncpu++;
80103980:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103985:	83 c0 01             	add    $0x1,%eax
80103988:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
      p += sizeof(struct mpproc);
8010398d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103991:	eb 41                	jmp    801039d4 <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103996:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
80103999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010399c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039a0:	a2 20 f9 10 80       	mov    %al,0x8010f920
      p += sizeof(struct mpioapic);
801039a5:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
801039a9:	eb 29                	jmp    801039d4 <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039ab:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
801039af:	eb 23                	jmp    801039d4 <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039b4:	0f b6 00             	movzbl (%eax),%eax
801039b7:	0f b6 c0             	movzbl %al,%eax
801039ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801039be:	c7 04 24 7c 88 10 80 	movl   $0x8010887c,(%esp)
801039c5:	e8 d0 c9 ff ff       	call   8010039a <cprintf>
      ismp = 0;
801039ca:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
801039d1:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039d7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
801039da:	0f 82 02 ff ff ff    	jb     801038e2 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039e0:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801039e5:	85 c0                	test   %eax,%eax
801039e7:	75 1d                	jne    80103a06 <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039e9:	c7 05 20 ff 10 80 01 	movl   $0x1,0x8010ff20
801039f0:	00 00 00 
    lapic = 0;
801039f3:	c7 05 9c f8 10 80 00 	movl   $0x0,0x8010f89c
801039fa:	00 00 00 
    ioapicid = 0;
801039fd:	c6 05 20 f9 10 80 00 	movb   $0x0,0x8010f920
    return;
80103a04:	eb 44                	jmp    80103a4a <mpinit+0x1c6>
  }

  if(mp->imcrp){
80103a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a09:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a0d:	84 c0                	test   %al,%al
80103a0f:	74 39                	je     80103a4a <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a11:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a18:	00 
80103a19:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a20:	e8 11 fc ff ff       	call   80103636 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a25:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a2c:	e8 e8 fb ff ff       	call   80103619 <inb>
80103a31:	83 c8 01             	or     $0x1,%eax
80103a34:	0f b6 c0             	movzbl %al,%eax
80103a37:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a3b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a42:	e8 ef fb ff ff       	call   80103636 <outb>
80103a47:	eb 01                	jmp    80103a4a <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a49:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a4a:	c9                   	leave  
80103a4b:	c3                   	ret    

80103a4c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a4c:	55                   	push   %ebp
80103a4d:	89 e5                	mov    %esp,%ebp
80103a4f:	83 ec 08             	sub    $0x8,%esp
80103a52:	8b 55 08             	mov    0x8(%ebp),%edx
80103a55:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a58:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a5c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a5f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a63:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a67:	ee                   	out    %al,(%dx)
}
80103a68:	c9                   	leave  
80103a69:	c3                   	ret    

80103a6a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a6a:	55                   	push   %ebp
80103a6b:	89 e5                	mov    %esp,%ebp
80103a6d:	83 ec 0c             	sub    $0xc,%esp
80103a70:	8b 45 08             	mov    0x8(%ebp),%eax
80103a73:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a77:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a7b:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a85:	0f b6 c0             	movzbl %al,%eax
80103a88:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a8c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a93:	e8 b4 ff ff ff       	call   80103a4c <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a98:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a9c:	66 c1 e8 08          	shr    $0x8,%ax
80103aa0:	0f b6 c0             	movzbl %al,%eax
80103aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aa7:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103aae:	e8 99 ff ff ff       	call   80103a4c <outb>
}
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    

80103ab5 <picenable>:

void
picenable(int irq)
{
80103ab5:	55                   	push   %ebp
80103ab6:	89 e5                	mov    %esp,%ebp
80103ab8:	53                   	push   %ebx
80103ab9:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103abc:	8b 45 08             	mov    0x8(%ebp),%eax
80103abf:	ba 01 00 00 00       	mov    $0x1,%edx
80103ac4:	89 d3                	mov    %edx,%ebx
80103ac6:	89 c1                	mov    %eax,%ecx
80103ac8:	d3 e3                	shl    %cl,%ebx
80103aca:	89 d8                	mov    %ebx,%eax
80103acc:	89 c2                	mov    %eax,%edx
80103ace:	f7 d2                	not    %edx
80103ad0:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ad7:	21 d0                	and    %edx,%eax
80103ad9:	0f b7 c0             	movzwl %ax,%eax
80103adc:	89 04 24             	mov    %eax,(%esp)
80103adf:	e8 86 ff ff ff       	call   80103a6a <picsetmask>
}
80103ae4:	83 c4 04             	add    $0x4,%esp
80103ae7:	5b                   	pop    %ebx
80103ae8:	5d                   	pop    %ebp
80103ae9:	c3                   	ret    

80103aea <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aea:	55                   	push   %ebp
80103aeb:	89 e5                	mov    %esp,%ebp
80103aed:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103af0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103af7:	00 
80103af8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103aff:	e8 48 ff ff ff       	call   80103a4c <outb>
  outb(IO_PIC2+1, 0xFF);
80103b04:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b0b:	00 
80103b0c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b13:	e8 34 ff ff ff       	call   80103a4c <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b18:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b1f:	00 
80103b20:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b27:	e8 20 ff ff ff       	call   80103a4c <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b2c:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b33:	00 
80103b34:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b3b:	e8 0c ff ff ff       	call   80103a4c <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b40:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b47:	00 
80103b48:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b4f:	e8 f8 fe ff ff       	call   80103a4c <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b54:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b5b:	00 
80103b5c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b63:	e8 e4 fe ff ff       	call   80103a4c <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b68:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b6f:	00 
80103b70:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b77:	e8 d0 fe ff ff       	call   80103a4c <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b7c:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b83:	00 
80103b84:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b8b:	e8 bc fe ff ff       	call   80103a4c <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b90:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b97:	00 
80103b98:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b9f:	e8 a8 fe ff ff       	call   80103a4c <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ba4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bab:	00 
80103bac:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bb3:	e8 94 fe ff ff       	call   80103a4c <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bb8:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bbf:	00 
80103bc0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bc7:	e8 80 fe ff ff       	call   80103a4c <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bcc:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bd3:	00 
80103bd4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bdb:	e8 6c fe ff ff       	call   80103a4c <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103be0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103be7:	00 
80103be8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bef:	e8 58 fe ff ff       	call   80103a4c <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bf4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bfb:	00 
80103bfc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c03:	e8 44 fe ff ff       	call   80103a4c <outb>

  if(irqmask != 0xFFFF)
80103c08:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c0f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103c13:	74 12                	je     80103c27 <picinit+0x13d>
    picsetmask(irqmask);
80103c15:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c1c:	0f b7 c0             	movzwl %ax,%eax
80103c1f:	89 04 24             	mov    %eax,(%esp)
80103c22:	e8 43 fe ff ff       	call   80103a6a <picsetmask>
}
80103c27:	c9                   	leave  
80103c28:	c3                   	ret    
80103c29:	00 00                	add    %al,(%eax)
	...

80103c2c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c2c:	55                   	push   %ebp
80103c2d:	89 e5                	mov    %esp,%ebp
80103c2f:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c45:	8b 10                	mov    (%eax),%edx
80103c47:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c4c:	e8 fb d2 ff ff       	call   80100f4c <filealloc>
80103c51:	8b 55 08             	mov    0x8(%ebp),%edx
80103c54:	89 02                	mov    %eax,(%edx)
80103c56:	8b 45 08             	mov    0x8(%ebp),%eax
80103c59:	8b 00                	mov    (%eax),%eax
80103c5b:	85 c0                	test   %eax,%eax
80103c5d:	0f 84 c8 00 00 00    	je     80103d2b <pipealloc+0xff>
80103c63:	e8 e4 d2 ff ff       	call   80100f4c <filealloc>
80103c68:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c6b:	89 02                	mov    %eax,(%edx)
80103c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c70:	8b 00                	mov    (%eax),%eax
80103c72:	85 c0                	test   %eax,%eax
80103c74:	0f 84 b1 00 00 00    	je     80103d2b <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c7a:	e8 b3 ee ff ff       	call   80102b32 <kalloc>
80103c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c86:	0f 84 9e 00 00 00    	je     80103d2a <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8f:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c96:	00 00 00 
  p->writeopen = 1;
80103c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9c:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ca3:	00 00 00 
  p->nwrite = 0;
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cb0:	00 00 00 
  p->nread = 0;
80103cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb6:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cbd:	00 00 00 
  initlock(&p->lock, "pipe");
80103cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc3:	c7 44 24 04 b0 88 10 	movl   $0x801088b0,0x4(%esp)
80103cca:	80 
80103ccb:	89 04 24             	mov    %eax,(%esp)
80103cce:	e8 5f 12 00 00       	call   80104f32 <initlock>
  (*f0)->type = FD_PIPE;
80103cd3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd6:	8b 00                	mov    (%eax),%eax
80103cd8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cde:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce1:	8b 00                	mov    (%eax),%eax
80103ce3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80103cea:	8b 00                	mov    (%eax),%eax
80103cec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf3:	8b 00                	mov    (%eax),%eax
80103cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cf8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cfe:	8b 00                	mov    (%eax),%eax
80103d00:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d06:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d09:	8b 00                	mov    (%eax),%eax
80103d0b:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d12:	8b 00                	mov    (%eax),%eax
80103d14:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d18:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1b:	8b 00                	mov    (%eax),%eax
80103d1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d20:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d23:	b8 00 00 00 00       	mov    $0x0,%eax
80103d28:	eb 43                	jmp    80103d6d <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d2a:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d2f:	74 0b                	je     80103d3c <pipealloc+0x110>
    kfree((char*)p);
80103d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d34:	89 04 24             	mov    %eax,(%esp)
80103d37:	e8 5d ed ff ff       	call   80102a99 <kfree>
  if(*f0)
80103d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3f:	8b 00                	mov    (%eax),%eax
80103d41:	85 c0                	test   %eax,%eax
80103d43:	74 0d                	je     80103d52 <pipealloc+0x126>
    fileclose(*f0);
80103d45:	8b 45 08             	mov    0x8(%ebp),%eax
80103d48:	8b 00                	mov    (%eax),%eax
80103d4a:	89 04 24             	mov    %eax,(%esp)
80103d4d:	e8 a3 d2 ff ff       	call   80100ff5 <fileclose>
  if(*f1)
80103d52:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d55:	8b 00                	mov    (%eax),%eax
80103d57:	85 c0                	test   %eax,%eax
80103d59:	74 0d                	je     80103d68 <pipealloc+0x13c>
    fileclose(*f1);
80103d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5e:	8b 00                	mov    (%eax),%eax
80103d60:	89 04 24             	mov    %eax,(%esp)
80103d63:	e8 8d d2 ff ff       	call   80100ff5 <fileclose>
  return -1;
80103d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d6d:	c9                   	leave  
80103d6e:	c3                   	ret    

80103d6f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d6f:	55                   	push   %ebp
80103d70:	89 e5                	mov    %esp,%ebp
80103d72:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d75:	8b 45 08             	mov    0x8(%ebp),%eax
80103d78:	89 04 24             	mov    %eax,(%esp)
80103d7b:	e8 d3 11 00 00       	call   80104f53 <acquire>
  if(writable){
80103d80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d84:	74 1f                	je     80103da5 <pipeclose+0x36>
    p->writeopen = 0;
80103d86:	8b 45 08             	mov    0x8(%ebp),%eax
80103d89:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d90:	00 00 00 
    wakeup(&p->nread);
80103d93:	8b 45 08             	mov    0x8(%ebp),%eax
80103d96:	05 34 02 00 00       	add    $0x234,%eax
80103d9b:	89 04 24             	mov    %eax,(%esp)
80103d9e:	e8 7c 0f 00 00       	call   80104d1f <wakeup>
80103da3:	eb 1d                	jmp    80103dc2 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103da5:	8b 45 08             	mov    0x8(%ebp),%eax
80103da8:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103daf:	00 00 00 
    wakeup(&p->nwrite);
80103db2:	8b 45 08             	mov    0x8(%ebp),%eax
80103db5:	05 38 02 00 00       	add    $0x238,%eax
80103dba:	89 04 24             	mov    %eax,(%esp)
80103dbd:	e8 5d 0f 00 00       	call   80104d1f <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dcb:	85 c0                	test   %eax,%eax
80103dcd:	75 25                	jne    80103df4 <pipeclose+0x85>
80103dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	75 18                	jne    80103df4 <pipeclose+0x85>
    release(&p->lock);
80103ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddf:	89 04 24             	mov    %eax,(%esp)
80103de2:	e8 cd 11 00 00       	call   80104fb4 <release>
    kfree((char*)p);
80103de7:	8b 45 08             	mov    0x8(%ebp),%eax
80103dea:	89 04 24             	mov    %eax,(%esp)
80103ded:	e8 a7 ec ff ff       	call   80102a99 <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103df2:	eb 0b                	jmp    80103dff <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103df4:	8b 45 08             	mov    0x8(%ebp),%eax
80103df7:	89 04 24             	mov    %eax,(%esp)
80103dfa:	e8 b5 11 00 00       	call   80104fb4 <release>
}
80103dff:	c9                   	leave  
80103e00:	c3                   	ret    

80103e01 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e01:	55                   	push   %ebp
80103e02:	89 e5                	mov    %esp,%ebp
80103e04:	53                   	push   %ebx
80103e05:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e08:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0b:	89 04 24             	mov    %eax,(%esp)
80103e0e:	e8 40 11 00 00       	call   80104f53 <acquire>
  for(i = 0; i < n; i++){
80103e13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e1a:	e9 a6 00 00 00       	jmp    80103ec5 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e22:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e28:	85 c0                	test   %eax,%eax
80103e2a:	74 0d                	je     80103e39 <pipewrite+0x38>
80103e2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e32:	8b 40 24             	mov    0x24(%eax),%eax
80103e35:	85 c0                	test   %eax,%eax
80103e37:	74 15                	je     80103e4e <pipewrite+0x4d>
        release(&p->lock);
80103e39:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 70 11 00 00       	call   80104fb4 <release>
        return -1;
80103e44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e49:	e9 9d 00 00 00       	jmp    80103eeb <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e51:	05 34 02 00 00       	add    $0x234,%eax
80103e56:	89 04 24             	mov    %eax,(%esp)
80103e59:	e8 c1 0e 00 00       	call   80104d1f <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e61:	8b 55 08             	mov    0x8(%ebp),%edx
80103e64:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6e:	89 14 24             	mov    %edx,(%esp)
80103e71:	e8 63 0d 00 00       	call   80104bd9 <sleep>
80103e76:	eb 01                	jmp    80103e79 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e78:	90                   	nop
80103e79:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e82:	8b 45 08             	mov    0x8(%ebp),%eax
80103e85:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e8b:	05 00 02 00 00       	add    $0x200,%eax
80103e90:	39 c2                	cmp    %eax,%edx
80103e92:	74 8b                	je     80103e1f <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e94:	8b 45 08             	mov    0x8(%ebp),%eax
80103e97:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e9d:	89 c3                	mov    %eax,%ebx
80103e9f:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ea8:	03 55 0c             	add    0xc(%ebp),%edx
80103eab:	0f b6 0a             	movzbl (%edx),%ecx
80103eae:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb1:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103eb5:	8d 50 01             	lea    0x1(%eax),%edx
80103eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebb:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ec1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec8:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ecb:	7c ab                	jl     80103e78 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed0:	05 34 02 00 00       	add    $0x234,%eax
80103ed5:	89 04 24             	mov    %eax,(%esp)
80103ed8:	e8 42 0e 00 00       	call   80104d1f <wakeup>
  release(&p->lock);
80103edd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee0:	89 04 24             	mov    %eax,(%esp)
80103ee3:	e8 cc 10 00 00       	call   80104fb4 <release>
  return n;
80103ee8:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eeb:	83 c4 24             	add    $0x24,%esp
80103eee:	5b                   	pop    %ebx
80103eef:	5d                   	pop    %ebp
80103ef0:	c3                   	ret    

80103ef1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ef1:	55                   	push   %ebp
80103ef2:	89 e5                	mov    %esp,%ebp
80103ef4:	53                   	push   %ebx
80103ef5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80103efb:	89 04 24             	mov    %eax,(%esp)
80103efe:	e8 50 10 00 00       	call   80104f53 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f03:	eb 3a                	jmp    80103f3f <piperead+0x4e>
    if(proc->killed){
80103f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f0b:	8b 40 24             	mov    0x24(%eax),%eax
80103f0e:	85 c0                	test   %eax,%eax
80103f10:	74 15                	je     80103f27 <piperead+0x36>
      release(&p->lock);
80103f12:	8b 45 08             	mov    0x8(%ebp),%eax
80103f15:	89 04 24             	mov    %eax,(%esp)
80103f18:	e8 97 10 00 00       	call   80104fb4 <release>
      return -1;
80103f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f22:	e9 b6 00 00 00       	jmp    80103fdd <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f27:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f2d:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f37:	89 14 24             	mov    %edx,(%esp)
80103f3a:	e8 9a 0c 00 00       	call   80104bd9 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f42:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f48:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f51:	39 c2                	cmp    %eax,%edx
80103f53:	75 0d                	jne    80103f62 <piperead+0x71>
80103f55:	8b 45 08             	mov    0x8(%ebp),%eax
80103f58:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f5e:	85 c0                	test   %eax,%eax
80103f60:	75 a3                	jne    80103f05 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f69:	eb 49                	jmp    80103fb4 <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f74:	8b 45 08             	mov    0x8(%ebp),%eax
80103f77:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f7d:	39 c2                	cmp    %eax,%edx
80103f7f:	74 3d                	je     80103fbe <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f84:	89 c2                	mov    %eax,%edx
80103f86:	03 55 0c             	add    0xc(%ebp),%edx
80103f89:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f92:	89 c3                	mov    %eax,%ebx
80103f94:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103f9d:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103fa2:	88 0a                	mov    %cl,(%edx)
80103fa4:	8d 50 01             	lea    0x1(%eax),%edx
80103fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80103faa:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb7:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fba:	7c af                	jl     80103f6b <piperead+0x7a>
80103fbc:	eb 01                	jmp    80103fbf <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103fbe:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc2:	05 38 02 00 00       	add    $0x238,%eax
80103fc7:	89 04 24             	mov    %eax,(%esp)
80103fca:	e8 50 0d 00 00       	call   80104d1f <wakeup>
  release(&p->lock);
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	89 04 24             	mov    %eax,(%esp)
80103fd5:	e8 da 0f 00 00       	call   80104fb4 <release>
  return i;
80103fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fdd:	83 c4 24             	add    $0x24,%esp
80103fe0:	5b                   	pop    %ebx
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    
	...

80103fe4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fea:	9c                   	pushf  
80103feb:	58                   	pop    %eax
80103fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103ff2:	c9                   	leave  
80103ff3:	c3                   	ret    

80103ff4 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103ff7:	fb                   	sti    
}
80103ff8:	5d                   	pop    %ebp
80103ff9:	c3                   	ret    

80103ffa <memcop>:

static void wakeup1(void *chan);

    void*
memcop(void *dst, void *src, uint n)
{
80103ffa:	55                   	push   %ebp
80103ffb:	89 e5                	mov    %esp,%ebp
80103ffd:	83 ec 10             	sub    $0x10,%esp
    const char *s;
    char *d;

    s = src;
80104000:	8b 45 0c             	mov    0xc(%ebp),%eax
80104003:	89 45 f8             	mov    %eax,-0x8(%ebp)
    d = dst;
80104006:	8b 45 08             	mov    0x8(%ebp),%eax
80104009:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if(s < d && s + n > d){
8010400c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010400f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104012:	73 55                	jae    80104069 <memcop+0x6f>
80104014:	8b 45 10             	mov    0x10(%ebp),%eax
80104017:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010401a:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010401d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104020:	76 4a                	jbe    8010406c <memcop+0x72>
        s += n;
80104022:	8b 45 10             	mov    0x10(%ebp),%eax
80104025:	01 45 f8             	add    %eax,-0x8(%ebp)
        d += n;
80104028:	8b 45 10             	mov    0x10(%ebp),%eax
8010402b:	01 45 fc             	add    %eax,-0x4(%ebp)
        while(n-- > 0)
8010402e:	eb 13                	jmp    80104043 <memcop+0x49>
            *--d = *--s;
80104030:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104034:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104038:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010403b:	0f b6 10             	movzbl (%eax),%edx
8010403e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104041:	88 10                	mov    %dl,(%eax)
    s = src;
    d = dst;
    if(s < d && s + n > d){
        s += n;
        d += n;
        while(n-- > 0)
80104043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104047:	0f 95 c0             	setne  %al
8010404a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010404e:	84 c0                	test   %al,%al
80104050:	75 de                	jne    80104030 <memcop+0x36>
    const char *s;
    char *d;

    s = src;
    d = dst;
    if(s < d && s + n > d){
80104052:	eb 28                	jmp    8010407c <memcop+0x82>
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
            *d++ = *s++;
80104054:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104057:	0f b6 10             	movzbl (%eax),%edx
8010405a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010405d:	88 10                	mov    %dl,(%eax)
8010405f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104063:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104067:	eb 04                	jmp    8010406d <memcop+0x73>
        s += n;
        d += n;
        while(n-- > 0)
            *--d = *--s;
    } else
        while(n-- > 0)
80104069:	90                   	nop
8010406a:	eb 01                	jmp    8010406d <memcop+0x73>
8010406c:	90                   	nop
8010406d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104071:	0f 95 c0             	setne  %al
80104074:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104078:	84 c0                	test   %al,%al
8010407a:	75 d8                	jne    80104054 <memcop+0x5a>
            *d++ = *s++;

    return dst;
8010407c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010407f:	c9                   	leave  
80104080:	c3                   	ret    

80104081 <pinit>:


    void
pinit(void)
{
80104081:	55                   	push   %ebp
80104082:	89 e5                	mov    %esp,%ebp
80104084:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
80104087:	c7 44 24 04 b8 88 10 	movl   $0x801088b8,0x4(%esp)
8010408e:	80 
8010408f:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104096:	e8 97 0e 00 00       	call   80104f32 <initlock>
}
8010409b:	c9                   	leave  
8010409c:	c3                   	ret    

8010409d <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
8010409d:	55                   	push   %ebp
8010409e:	89 e5                	mov    %esp,%ebp
801040a0:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
801040a3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801040aa:	e8 a4 0e 00 00       	call   80104f53 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040af:	c7 45 f0 74 ff 10 80 	movl   $0x8010ff74,-0x10(%ebp)
801040b6:	eb 11                	jmp    801040c9 <allocproc+0x2c>
        if(p->state == UNUSED)
801040b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040bb:	8b 40 0c             	mov    0xc(%eax),%eax
801040be:	85 c0                	test   %eax,%eax
801040c0:	74 27                	je     801040e9 <allocproc+0x4c>
{
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c2:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
801040c9:	b8 74 20 11 80       	mov    $0x80112074,%eax
801040ce:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801040d1:	72 e5                	jb     801040b8 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;
    release(&ptable.lock);
801040d3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801040da:	e8 d5 0e 00 00       	call   80104fb4 <release>
    return 0;
801040df:	b8 00 00 00 00       	mov    $0x0,%eax
801040e4:	e9 b5 00 00 00       	jmp    8010419e <allocproc+0x101>
    char *sp;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;
801040e9:	90                   	nop
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
801040ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040ed:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
801040f4:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040fc:	89 42 10             	mov    %eax,0x10(%edx)
801040ff:	83 c0 01             	add    $0x1,%eax
80104102:	a3 04 b0 10 80       	mov    %eax,0x8010b004
    release(&ptable.lock);
80104107:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010410e:	e8 a1 0e 00 00       	call   80104fb4 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80104113:	e8 1a ea ff ff       	call   80102b32 <kalloc>
80104118:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010411b:	89 42 08             	mov    %eax,0x8(%edx)
8010411e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104121:	8b 40 08             	mov    0x8(%eax),%eax
80104124:	85 c0                	test   %eax,%eax
80104126:	75 11                	jne    80104139 <allocproc+0x9c>
        p->state = UNUSED;
80104128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010412b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
80104132:	b8 00 00 00 00       	mov    $0x0,%eax
80104137:	eb 65                	jmp    8010419e <allocproc+0x101>
    }
    sp = p->kstack + KSTACKSIZE;
80104139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010413c:	8b 40 08             	mov    0x8(%eax),%eax
8010413f:	05 00 10 00 00       	add    $0x1000,%eax
80104144:	89 45 f4             	mov    %eax,-0xc(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104147:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
    p->tf = (struct trapframe*)sp;
8010414b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104151:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
80104154:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
    *(uint*)sp = (uint)trapret;
80104158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415b:	ba 9c 66 10 80       	mov    $0x8010669c,%edx
80104160:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
80104162:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
    p->context = (struct context*)sp;
80104166:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104169:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010416c:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
8010416f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104172:	8b 40 1c             	mov    0x1c(%eax),%eax
80104175:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010417c:	00 
8010417d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104184:	00 
80104185:	89 04 24             	mov    %eax,(%esp)
80104188:	e8 15 10 00 00       	call   801051a2 <memset>
    p->context->eip = (uint)forkret;
8010418d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104190:	8b 40 1c             	mov    0x1c(%eax),%eax
80104193:	ba ad 4b 10 80       	mov    $0x80104bad,%edx
80104198:	89 50 10             	mov    %edx,0x10(%eax)

    return p;
8010419b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010419e:	c9                   	leave  
8010419f:	c3                   	ret    

801041a0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
801041a6:	e8 f2 fe ff ff       	call   8010409d <allocproc>
801041ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    initproc = p;
801041ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b1:	a3 68 b6 10 80       	mov    %eax,0x8010b668
    if((p->pgdir = setupkvm()) == 0)
801041b6:	e8 ca 3b 00 00       	call   80107d85 <setupkvm>
801041bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041be:	89 42 04             	mov    %eax,0x4(%edx)
801041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c4:	8b 40 04             	mov    0x4(%eax),%eax
801041c7:	85 c0                	test   %eax,%eax
801041c9:	75 0c                	jne    801041d7 <userinit+0x37>
        panic("userinit: out of memory?");
801041cb:	c7 04 24 bf 88 10 80 	movl   $0x801088bf,(%esp)
801041d2:	e8 63 c3 ff ff       	call   8010053a <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041d7:	ba 2c 00 00 00       	mov    $0x2c,%edx
801041dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041df:	8b 40 04             	mov    0x4(%eax),%eax
801041e2:	89 54 24 08          	mov    %edx,0x8(%esp)
801041e6:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
801041ed:	80 
801041ee:	89 04 24             	mov    %eax,(%esp)
801041f1:	e8 e8 3d 00 00       	call   80107fde <inituvm>
    p->sz = PGSIZE;
801041f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f9:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104202:	8b 40 18             	mov    0x18(%eax),%eax
80104205:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010420c:	00 
8010420d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104214:	00 
80104215:	89 04 24             	mov    %eax,(%esp)
80104218:	e8 85 0f 00 00       	call   801051a2 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010421d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104220:	8b 40 18             	mov    0x18(%eax),%eax
80104223:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422c:	8b 40 18             	mov    0x18(%eax),%eax
8010422f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
80104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104238:	8b 40 18             	mov    0x18(%eax),%eax
8010423b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423e:	8b 52 18             	mov    0x18(%edx),%edx
80104241:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104245:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424c:	8b 40 18             	mov    0x18(%eax),%eax
8010424f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104252:	8b 52 18             	mov    0x18(%edx),%edx
80104255:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104259:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
8010425d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104260:	8b 40 18             	mov    0x18(%eax),%eax
80104263:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
8010426a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426d:	8b 40 18             	mov    0x18(%eax),%eax
80104270:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427a:	8b 40 18             	mov    0x18(%eax),%eax
8010427d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104287:	83 c0 6c             	add    $0x6c,%eax
8010428a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104291:	00 
80104292:	c7 44 24 04 d8 88 10 	movl   $0x801088d8,0x4(%esp)
80104299:	80 
8010429a:	89 04 24             	mov    %eax,(%esp)
8010429d:	e8 33 11 00 00       	call   801053d5 <safestrcpy>
    p->cwd = namei("/");
801042a2:	c7 04 24 e1 88 10 80 	movl   $0x801088e1,(%esp)
801042a9:	e8 9d e1 ff ff       	call   8010244b <namei>
801042ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b1:	89 42 68             	mov    %eax,0x68(%edx)

    p->state = RUNNABLE;
801042b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801042be:	c9                   	leave  
801042bf:	c3                   	ret    

801042c0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	83 ec 28             	sub    $0x28,%esp
    uint sz;

    sz = proc->sz;
801042c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042cc:	8b 00                	mov    (%eax),%eax
801042ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
801042d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042d5:	7e 34                	jle    8010430b <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801042d7:	8b 45 08             	mov    0x8(%ebp),%eax
801042da:	89 c2                	mov    %eax,%edx
801042dc:	03 55 f4             	add    -0xc(%ebp),%edx
801042df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e5:	8b 40 04             	mov    0x4(%eax),%eax
801042e8:	89 54 24 08          	mov    %edx,0x8(%esp)
801042ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801042f3:	89 04 24             	mov    %eax,(%esp)
801042f6:	e8 5e 3e 00 00       	call   80108159 <allocuvm>
801042fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104302:	75 41                	jne    80104345 <growproc+0x85>
            return -1;
80104304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104309:	eb 58                	jmp    80104363 <growproc+0xa3>
    } else if(n < 0){
8010430b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010430f:	79 34                	jns    80104345 <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104311:	8b 45 08             	mov    0x8(%ebp),%eax
80104314:	89 c2                	mov    %eax,%edx
80104316:	03 55 f4             	add    -0xc(%ebp),%edx
80104319:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431f:	8b 40 04             	mov    0x4(%eax),%eax
80104322:	89 54 24 08          	mov    %edx,0x8(%esp)
80104326:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010432d:	89 04 24             	mov    %eax,(%esp)
80104330:	e8 fe 3e 00 00       	call   80108233 <deallocuvm>
80104335:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010433c:	75 07                	jne    80104345 <growproc+0x85>
            return -1;
8010433e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104343:	eb 1e                	jmp    80104363 <growproc+0xa3>
    }
    proc->sz = sz;
80104345:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010434b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010434e:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
80104350:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104356:	89 04 24             	mov    %eax,(%esp)
80104359:	e8 19 3b 00 00       	call   80107e77 <switchuvm>
    return 0;
8010435e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104363:	c9                   	leave  
80104364:	c3                   	ret    

80104365 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
80104365:	55                   	push   %ebp
80104366:	89 e5                	mov    %esp,%ebp
80104368:	57                   	push   %edi
80104369:	56                   	push   %esi
8010436a:	53                   	push   %ebx
8010436b:	83 ec 2c             	sub    $0x2c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
8010436e:	e8 2a fd ff ff       	call   8010409d <allocproc>
80104373:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104376:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010437a:	75 0a                	jne    80104386 <fork+0x21>
        return -1;
8010437c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104381:	e9 47 01 00 00       	jmp    801044cd <fork+0x168>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104386:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010438c:	8b 10                	mov    (%eax),%edx
8010438e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104394:	8b 40 04             	mov    0x4(%eax),%eax
80104397:	89 54 24 04          	mov    %edx,0x4(%esp)
8010439b:	89 04 24             	mov    %eax,(%esp)
8010439e:	e8 20 40 00 00       	call   801083c3 <copyuvm>
801043a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043a6:	89 42 04             	mov    %eax,0x4(%edx)
801043a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043ac:	8b 40 04             	mov    0x4(%eax),%eax
801043af:	85 c0                	test   %eax,%eax
801043b1:	75 2c                	jne    801043df <fork+0x7a>
        kfree(np->kstack);
801043b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043b6:	8b 40 08             	mov    0x8(%eax),%eax
801043b9:	89 04 24             	mov    %eax,(%esp)
801043bc:	e8 d8 e6 ff ff       	call   80102a99 <kfree>
        np->kstack = 0;
801043c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        np->state = UNUSED;
801043cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return -1;
801043d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043da:	e9 ee 00 00 00       	jmp    801044cd <fork+0x168>
    }
    np->sz = proc->sz;
801043df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043e5:	8b 10                	mov    (%eax),%edx
801043e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043ea:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
801043ec:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043f6:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
801043f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043fc:	8b 50 18             	mov    0x18(%eax),%edx
801043ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104405:	8b 40 18             	mov    0x18(%eax),%eax
80104408:	89 c3                	mov    %eax,%ebx
8010440a:	b8 13 00 00 00       	mov    $0x13,%eax
8010440f:	89 d7                	mov    %edx,%edi
80104411:	89 de                	mov    %ebx,%esi
80104413:	89 c1                	mov    %eax,%ecx
80104415:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 0;
80104417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010441a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104421:	00 00 00 

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104427:	8b 40 18             	mov    0x18(%eax),%eax
8010442a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
80104431:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104438:	eb 3d                	jmp    80104477 <fork+0x112>
        if(proc->ofile[i])
8010443a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104440:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104443:	83 c2 08             	add    $0x8,%edx
80104446:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 25                	je     80104473 <fork+0x10e>
            np->ofile[i] = filedup(proc->ofile[i]);
8010444e:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80104451:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104457:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010445a:	83 c2 08             	add    $0x8,%edx
8010445d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104461:	89 04 24             	mov    %eax,(%esp)
80104464:	e8 44 cb ff ff       	call   80100fad <filedup>
80104469:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010446c:	8d 4b 08             	lea    0x8(%ebx),%ecx
8010446f:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
    np->isthread = 0;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80104473:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80104477:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
8010447b:	7e bd                	jle    8010443a <fork+0xd5>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
8010447d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104483:	8b 40 68             	mov    0x68(%eax),%eax
80104486:	89 04 24             	mov    %eax,(%esp)
80104489:	e8 e3 d3 ff ff       	call   80101871 <idup>
8010448e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104491:	89 42 68             	mov    %eax,0x68(%edx)

    pid = np->pid;
80104494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104497:	8b 40 10             	mov    0x10(%eax),%eax
8010449a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->state = RUNNABLE;
8010449d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044a0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801044a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ad:	8d 50 6c             	lea    0x6c(%eax),%edx
801044b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044b3:	83 c0 6c             	add    $0x6c,%eax
801044b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801044bd:	00 
801044be:	89 54 24 04          	mov    %edx,0x4(%esp)
801044c2:	89 04 24             	mov    %eax,(%esp)
801044c5:	e8 0b 0f 00 00       	call   801053d5 <safestrcpy>
    return pid;
801044ca:	8b 45 e0             	mov    -0x20(%ebp),%eax

}
801044cd:	83 c4 2c             	add    $0x2c,%esp
801044d0:	5b                   	pop    %ebx
801044d1:	5e                   	pop    %esi
801044d2:	5f                   	pop    %edi
801044d3:	5d                   	pop    %ebp
801044d4:	c3                   	ret    

801044d5 <clone>:

//creat a new process but used parent pgdir. 
int clone(int stack, int size, int routine, int arg){ 
801044d5:	55                   	push   %ebp
801044d6:	89 e5                	mov    %esp,%ebp
801044d8:	57                   	push   %edi
801044d9:	56                   	push   %esi
801044da:	53                   	push   %ebx
801044db:	81 ec bc 00 00 00    	sub    $0xbc,%esp
    int i, pid;
    struct proc *np;

    //cprintf("in clone\n");
    // Allocate process.
    if((np = allocproc()) == 0)
801044e1:	e8 b7 fb ff ff       	call   8010409d <allocproc>
801044e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
801044e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
801044ed:	75 0a                	jne    801044f9 <clone+0x24>
        return -1;
801044ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f4:	e9 f4 01 00 00       	jmp    801046ed <clone+0x218>
    if((stack % PGSIZE) != 0 || stack == 0 || routine == 0)
801044f9:	8b 45 08             	mov    0x8(%ebp),%eax
801044fc:	25 ff 0f 00 00       	and    $0xfff,%eax
80104501:	85 c0                	test   %eax,%eax
80104503:	75 0c                	jne    80104511 <clone+0x3c>
80104505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104509:	74 06                	je     80104511 <clone+0x3c>
8010450b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010450f:	75 0a                	jne    8010451b <clone+0x46>
        return -1;
80104511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104516:	e9 d2 01 00 00       	jmp    801046ed <clone+0x218>

    np->pgdir = proc->pgdir;
8010451b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104521:	8b 50 04             	mov    0x4(%eax),%edx
80104524:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104527:	89 50 04             	mov    %edx,0x4(%eax)
    np->sz = proc->sz;
8010452a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104530:	8b 10                	mov    (%eax),%edx
80104532:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104535:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104537:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010453e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104541:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104544:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104547:	8b 50 18             	mov    0x18(%eax),%edx
8010454a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104550:	8b 40 18             	mov    0x18(%eax),%eax
80104553:	89 c3                	mov    %eax,%ebx
80104555:	b8 13 00 00 00       	mov    $0x13,%eax
8010455a:	89 d7                	mov    %edx,%edi
8010455c:	89 de                	mov    %ebx,%esi
8010455e:	89 c1                	mov    %eax,%ecx
80104560:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->isthread = 1;
80104562:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104565:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
8010456c:	00 00 00 
    pid = np->pid;
8010456f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104572:	8b 40 10             	mov    0x10(%eax),%eax
80104575:	89 45 d8             	mov    %eax,-0x28(%ebp)

    struct proc *pp;
    pp = proc;
80104578:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010457e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(pp->isthread == 1){
80104581:	eb 09                	jmp    8010458c <clone+0xb7>
        pp = pp->parent;
80104583:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104586:	8b 40 14             	mov    0x14(%eax),%eax
80104589:	89 45 e0             	mov    %eax,-0x20(%ebp)
    np->isthread = 1;
    pid = np->pid;

    struct proc *pp;
    pp = proc;
    while(pp->isthread == 1){
8010458c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010458f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104595:	83 f8 01             	cmp    $0x1,%eax
80104598:	74 e9                	je     80104583 <clone+0xae>
        pp = pp->parent;
    }
    np->parent = pp;
8010459a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010459d:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045a0:	89 50 14             	mov    %edx,0x14(%eax)
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
801045a3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801045aa:	eb 3d                	jmp    801045e9 <clone+0x114>
        if(proc->ofile[i])
801045ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045b5:	83 c2 08             	add    $0x8,%edx
801045b8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045bc:	85 c0                	test   %eax,%eax
801045be:	74 25                	je     801045e5 <clone+0x110>
            np->ofile[i] = filedup(proc->ofile[i]);
801045c0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801045c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801045cc:	83 c2 08             	add    $0x8,%edx
801045cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045d3:	89 04 24             	mov    %eax,(%esp)
801045d6:	e8 d2 c9 ff ff       	call   80100fad <filedup>
801045db:	8b 55 dc             	mov    -0x24(%ebp),%edx
801045de:	8d 4b 08             	lea    0x8(%ebx),%ecx
801045e1:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        pp = pp->parent;
    }
    np->parent = pp;
    //need to be modified as point to the same address
    //*np->ofile = *proc->ofile;
    for(i = 0; i < NOFILE; i++)
801045e5:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801045e9:	83 7d d4 0f          	cmpl   $0xf,-0x2c(%ebp)
801045ed:	7e bd                	jle    801045ac <clone+0xd7>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801045ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f2:	8b 40 18             	mov    0x18(%eax),%eax
801045f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

   
    uint ustack[MAXARG];
    uint sp = stack + PGSIZE;
801045fc:	8b 45 08             	mov    0x8(%ebp),%eax
801045ff:	05 00 10 00 00       	add    $0x1000,%eax
80104604:	89 45 e4             	mov    %eax,-0x1c(%ebp)
//


//modify here <<<<<

    np->tf->ebp = sp;
80104607:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010460a:	8b 40 18             	mov    0x18(%eax),%eax
8010460d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104610:	89 50 08             	mov    %edx,0x8(%eax)
    ustack[0] = 0xffffffff;
80104613:	c7 85 54 ff ff ff ff 	movl   $0xffffffff,-0xac(%ebp)
8010461a:	ff ff ff 
    ustack[1] = arg;
8010461d:	8b 45 14             	mov    0x14(%ebp),%eax
80104620:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
    sp -= 8;
80104626:	83 6d e4 08          	subl   $0x8,-0x1c(%ebp)
    if(copyout(np->pgdir,sp,ustack,8)<0){
8010462a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010462d:	8b 40 04             	mov    0x4(%eax),%eax
80104630:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
80104637:	00 
80104638:	8d 95 54 ff ff ff    	lea    -0xac(%ebp),%edx
8010463e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104642:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104645:	89 54 24 04          	mov    %edx,0x4(%esp)
80104649:	89 04 24             	mov    %eax,(%esp)
8010464c:	e8 f1 3e 00 00       	call   80108542 <copyout>
80104651:	85 c0                	test   %eax,%eax
80104653:	79 16                	jns    8010466b <clone+0x196>
        cprintf("push arg fails\n");
80104655:	c7 04 24 e3 88 10 80 	movl   $0x801088e3,(%esp)
8010465c:	e8 39 bd ff ff       	call   8010039a <cprintf>
        return -1;
80104661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104666:	e9 82 00 00 00       	jmp    801046ed <clone+0x218>
    }

    np->tf->eip = routine;
8010466b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010466e:	8b 40 18             	mov    0x18(%eax),%eax
80104671:	8b 55 10             	mov    0x10(%ebp),%edx
80104674:	89 50 38             	mov    %edx,0x38(%eax)
    np->tf->esp = sp;
80104677:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010467a:	8b 40 18             	mov    0x18(%eax),%eax
8010467d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104680:	89 50 44             	mov    %edx,0x44(%eax)
    np->cwd = idup(proc->cwd);
80104683:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104689:	8b 40 68             	mov    0x68(%eax),%eax
8010468c:	89 04 24             	mov    %eax,(%esp)
8010468f:	e8 dd d1 ff ff       	call   80101871 <idup>
80104694:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104697:	89 42 68             	mov    %eax,0x68(%edx)

    switchuvm(np);
8010469a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010469d:	89 04 24             	mov    %eax,(%esp)
801046a0:	e8 d2 37 00 00       	call   80107e77 <switchuvm>

     acquire(&ptable.lock);
801046a5:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801046ac:	e8 a2 08 00 00       	call   80104f53 <acquire>
    np->state = RUNNABLE;
801046b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046b4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
     release(&ptable.lock);
801046bb:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801046c2:	e8 ed 08 00 00       	call   80104fb4 <release>
    safestrcpy(np->name, proc->name, sizeof(proc->name));
801046c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046cd:	8d 50 6c             	lea    0x6c(%eax),%edx
801046d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801046d3:	83 c0 6c             	add    $0x6c,%eax
801046d6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801046dd:	00 
801046de:	89 54 24 04          	mov    %edx,0x4(%esp)
801046e2:	89 04 24             	mov    %eax,(%esp)
801046e5:	e8 eb 0c 00 00       	call   801053d5 <safestrcpy>


    return pid;
801046ea:	8b 45 d8             	mov    -0x28(%ebp),%eax

}
801046ed:	81 c4 bc 00 00 00    	add    $0xbc,%esp
801046f3:	5b                   	pop    %ebx
801046f4:	5e                   	pop    %esi
801046f5:	5f                   	pop    %edi
801046f6:	5d                   	pop    %ebp
801046f7:	c3                   	ret    

801046f8 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
801046f8:	55                   	push   %ebp
801046f9:	89 e5                	mov    %esp,%ebp
801046fb:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
801046fe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104705:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010470a:	39 c2                	cmp    %eax,%edx
8010470c:	75 0c                	jne    8010471a <exit+0x22>
        panic("init exiting");
8010470e:	c7 04 24 f3 88 10 80 	movl   $0x801088f3,(%esp)
80104715:	e8 20 be ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010471a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104721:	eb 44                	jmp    80104767 <exit+0x6f>
        if(proc->ofile[fd]){
80104723:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104729:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010472c:	83 c2 08             	add    $0x8,%edx
8010472f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104733:	85 c0                	test   %eax,%eax
80104735:	74 2c                	je     80104763 <exit+0x6b>
            fileclose(proc->ofile[fd]);
80104737:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104740:	83 c2 08             	add    $0x8,%edx
80104743:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104747:	89 04 24             	mov    %eax,(%esp)
8010474a:	e8 a6 c8 ff ff       	call   80100ff5 <fileclose>
            proc->ofile[fd] = 0;
8010474f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104755:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104758:	83 c2 08             	add    $0x8,%edx
8010475b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104762:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104763:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104767:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010476b:	7e b6                	jle    80104723 <exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    iput(proc->cwd);
8010476d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104773:	8b 40 68             	mov    0x68(%eax),%eax
80104776:	89 04 24             	mov    %eax,(%esp)
80104779:	e8 db d2 ff ff       	call   80101a59 <iput>
    proc->cwd = 0;
8010477e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104784:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
8010478b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104792:	e8 bc 07 00 00       	call   80104f53 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104797:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479d:	8b 40 14             	mov    0x14(%eax),%eax
801047a0:	89 04 24             	mov    %eax,(%esp)
801047a3:	e8 cc 04 00 00       	call   80104c74 <wakeup1>

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a8:	c7 45 f0 74 ff 10 80 	movl   $0x8010ff74,-0x10(%ebp)
801047af:	eb 3b                	jmp    801047ec <exit+0xf4>
        if(p->parent == proc){
801047b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047b4:	8b 50 14             	mov    0x14(%eax),%edx
801047b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047bd:	39 c2                	cmp    %eax,%edx
801047bf:	75 24                	jne    801047e5 <exit+0xed>
            p->parent = initproc;
801047c1:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
801047c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047ca:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
801047cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047d0:	8b 40 0c             	mov    0xc(%eax),%eax
801047d3:	83 f8 05             	cmp    $0x5,%eax
801047d6:	75 0d                	jne    801047e5 <exit+0xed>
                wakeup1(initproc);
801047d8:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801047dd:	89 04 24             	mov    %eax,(%esp)
801047e0:	e8 8f 04 00 00       	call   80104c74 <wakeup1>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e5:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
801047ec:	b8 74 20 11 80       	mov    $0x80112074,%eax
801047f1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801047f4:	72 bb                	jb     801047b1 <exit+0xb9>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
801047f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fc:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80104803:	e8 98 02 00 00       	call   80104aa0 <sched>
    panic("zombie exit");
80104808:	c7 04 24 00 89 10 80 	movl   $0x80108900,(%esp)
8010480f:	e8 26 bd ff ff       	call   8010053a <panic>

80104814 <texit>:
}
    void
texit(void)
{
80104814:	55                   	push   %ebp
80104815:	89 e5                	mov    %esp,%ebp
80104817:	83 ec 28             	sub    $0x28,%esp
    //  struct proc *p;
    int fd;

    if(proc == initproc)
8010481a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104821:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104826:	39 c2                	cmp    %eax,%edx
80104828:	75 0c                	jne    80104836 <texit+0x22>
        panic("init exiting");
8010482a:	c7 04 24 f3 88 10 80 	movl   $0x801088f3,(%esp)
80104831:	e8 04 bd ff ff       	call   8010053a <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010483d:	eb 44                	jmp    80104883 <texit+0x6f>
        if(proc->ofile[fd]){
8010483f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104848:	83 c2 08             	add    $0x8,%edx
8010484b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010484f:	85 c0                	test   %eax,%eax
80104851:	74 2c                	je     8010487f <texit+0x6b>
            fileclose(proc->ofile[fd]);
80104853:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104859:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010485c:	83 c2 08             	add    $0x8,%edx
8010485f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104863:	89 04 24             	mov    %eax,(%esp)
80104866:	e8 8a c7 ff ff       	call   80100ff5 <fileclose>
            proc->ofile[fd] = 0;
8010486b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104871:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104874:	83 c2 08             	add    $0x8,%edx
80104877:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010487e:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
8010487f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104883:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104887:	7e b6                	jle    8010483f <texit+0x2b>
        if(proc->ofile[fd]){
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    iput(proc->cwd);
80104889:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488f:	8b 40 68             	mov    0x68(%eax),%eax
80104892:	89 04 24             	mov    %eax,(%esp)
80104895:	e8 bf d1 ff ff       	call   80101a59 <iput>
    proc->cwd = 0;
8010489a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a0:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
801048a7:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801048ae:	e8 a0 06 00 00       	call   80104f53 <acquire>
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
801048b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b9:	8b 40 14             	mov    0x14(%eax),%eax
801048bc:	89 04 24             	mov    %eax,(%esp)
801048bf:	e8 b0 03 00 00       	call   80104c74 <wakeup1>
    //      if(p->state == ZOMBIE)
    //        wakeup1(initproc);
    //    }
    //  }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
801048c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ca:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
801048d1:	e8 ca 01 00 00       	call   80104aa0 <sched>
    panic("zombie exit");
801048d6:	c7 04 24 00 89 10 80 	movl   $0x80108900,(%esp)
801048dd:	e8 58 bc ff ff       	call   8010053a <panic>

801048e2 <wait>:
}
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
801048e2:	55                   	push   %ebp
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
801048e8:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801048ef:	e8 5f 06 00 00       	call   80104f53 <acquire>
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
801048f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048fb:	c7 45 ec 74 ff 10 80 	movl   $0x8010ff74,-0x14(%ebp)
80104902:	e9 ab 00 00 00       	jmp    801049b2 <wait+0xd0>
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
80104907:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010490a:	8b 50 14             	mov    0x14(%eax),%edx
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	39 c2                	cmp    %eax,%edx
80104915:	0f 85 8f 00 00 00    	jne    801049aa <wait+0xc8>
                continue;
            havekids = 1;
8010491b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
80104922:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104925:	8b 40 0c             	mov    0xc(%eax),%eax
80104928:	83 f8 05             	cmp    $0x5,%eax
8010492b:	75 7e                	jne    801049ab <wait+0xc9>
                // Found one.
                pid = p->pid;
8010492d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104930:	8b 40 10             	mov    0x10(%eax),%eax
80104933:	89 45 f4             	mov    %eax,-0xc(%ebp)
                kfree(p->kstack);
80104936:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104939:	8b 40 08             	mov    0x8(%eax),%eax
8010493c:	89 04 24             	mov    %eax,(%esp)
8010493f:	e8 55 e1 ff ff       	call   80102a99 <kfree>
                p->kstack = 0;
80104944:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104947:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                if(p->isthread != 1){
8010494e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104951:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104957:	83 f8 01             	cmp    $0x1,%eax
8010495a:	74 0e                	je     8010496a <wait+0x88>
                    freevm(p->pgdir);
8010495c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010495f:	8b 40 04             	mov    0x4(%eax),%eax
80104962:	89 04 24             	mov    %eax,(%esp)
80104965:	e8 85 39 00 00       	call   801082ef <freevm>
                }
                p->state = UNUSED;
8010496a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010496d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                p->pid = 0;
80104974:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104977:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
8010497e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104981:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104988:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010498b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
8010498f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104992:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104999:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801049a0:	e8 0f 06 00 00       	call   80104fb4 <release>
                return pid;
801049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a8:	eb 57                	jmp    80104a01 <wait+0x11f>
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        //    if(p->parent != proc && p->isthread ==1)
            if(p->parent != proc) 
                continue;
801049aa:	90                   	nop

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ab:	81 45 ec 84 00 00 00 	addl   $0x84,-0x14(%ebp)
801049b2:	b8 74 20 11 80       	mov    $0x80112074,%eax
801049b7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801049ba:	0f 82 47 ff ff ff    	jb     80104907 <wait+0x25>
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
801049c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801049c4:	74 0d                	je     801049d3 <wait+0xf1>
801049c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cc:	8b 40 24             	mov    0x24(%eax),%eax
801049cf:	85 c0                	test   %eax,%eax
801049d1:	74 13                	je     801049e6 <wait+0x104>
            release(&ptable.lock);
801049d3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801049da:	e8 d5 05 00 00       	call   80104fb4 <release>
            return -1;
801049df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e4:	eb 1b                	jmp    80104a01 <wait+0x11f>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
801049e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ec:	c7 44 24 04 40 ff 10 	movl   $0x8010ff40,0x4(%esp)
801049f3:	80 
801049f4:	89 04 24             	mov    %eax,(%esp)
801049f7:	e8 dd 01 00 00       	call   80104bd9 <sleep>
    }
801049fc:	e9 f3 fe ff ff       	jmp    801048f4 <wait+0x12>
}
80104a01:	c9                   	leave  
80104a02:	c3                   	ret    

80104a03 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80104a03:	55                   	push   %ebp
80104a04:	89 e5                	mov    %esp,%ebp
80104a06:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
80104a09:	e8 e6 f5 ff ff       	call   80103ff4 <sti>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104a0e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104a15:	e8 39 05 00 00       	call   80104f53 <acquire>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a1a:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104a21:	eb 62                	jmp    80104a85 <scheduler+0x82>
            if(p->state != RUNNABLE)
80104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a26:	8b 40 0c             	mov    0xc(%eax),%eax
80104a29:	83 f8 03             	cmp    $0x3,%eax
80104a2c:	75 4f                	jne    80104a7d <scheduler+0x7a>
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80104a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a31:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
80104a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3a:	89 04 24             	mov    %eax,(%esp)
80104a3d:	e8 35 34 00 00       	call   80107e77 <switchuvm>
            p->state = RUNNING;
80104a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a45:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104a4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a52:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a55:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a5c:	83 c2 04             	add    $0x4,%edx
80104a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a63:	89 14 24             	mov    %edx,(%esp)
80104a66:	e8 dd 09 00 00       	call   80105448 <swtch>
            switchkvm();
80104a6b:	e8 ea 33 00 00       	call   80107e5a <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80104a70:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104a77:	00 00 00 00 
80104a7b:	eb 01                	jmp    80104a7e <scheduler+0x7b>

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
            if(p->state != RUNNABLE)
                continue;
80104a7d:	90                   	nop
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a7e:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104a85:	b8 74 20 11 80       	mov    $0x80112074,%eax
80104a8a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104a8d:	72 94                	jb     80104a23 <scheduler+0x20>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80104a8f:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104a96:	e8 19 05 00 00       	call   80104fb4 <release>

    }
80104a9b:	e9 69 ff ff ff       	jmp    80104a09 <scheduler+0x6>

80104aa0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
    void
sched(void)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	83 ec 28             	sub    $0x28,%esp
    int intena;

    if(!holding(&ptable.lock))
80104aa6:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104aad:	e8 c0 05 00 00       	call   80105072 <holding>
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	75 0c                	jne    80104ac2 <sched+0x22>
        panic("sched ptable.lock");
80104ab6:	c7 04 24 0c 89 10 80 	movl   $0x8010890c,(%esp)
80104abd:	e8 78 ba ff ff       	call   8010053a <panic>
    if(cpu->ncli != 1){
80104ac2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ac8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ace:	83 f8 01             	cmp    $0x1,%eax
80104ad1:	74 35                	je     80104b08 <sched+0x68>
        cprintf("current proc %d\n cpu->ncli %d\n",proc->pid,cpu->ncli);
80104ad3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ad9:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae5:	8b 40 10             	mov    0x10(%eax),%eax
80104ae8:	89 54 24 08          	mov    %edx,0x8(%esp)
80104aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104af0:	c7 04 24 20 89 10 80 	movl   $0x80108920,(%esp)
80104af7:	e8 9e b8 ff ff       	call   8010039a <cprintf>
        panic("sched locks");
80104afc:	c7 04 24 3f 89 10 80 	movl   $0x8010893f,(%esp)
80104b03:	e8 32 ba ff ff       	call   8010053a <panic>
    }
    if(proc->state == RUNNING)
80104b08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b11:	83 f8 04             	cmp    $0x4,%eax
80104b14:	75 0c                	jne    80104b22 <sched+0x82>
        panic("sched running");
80104b16:	c7 04 24 4b 89 10 80 	movl   $0x8010894b,(%esp)
80104b1d:	e8 18 ba ff ff       	call   8010053a <panic>
    if(readeflags()&FL_IF)
80104b22:	e8 bd f4 ff ff       	call   80103fe4 <readeflags>
80104b27:	25 00 02 00 00       	and    $0x200,%eax
80104b2c:	85 c0                	test   %eax,%eax
80104b2e:	74 0c                	je     80104b3c <sched+0x9c>
        panic("sched interruptible");
80104b30:	c7 04 24 59 89 10 80 	movl   $0x80108959,(%esp)
80104b37:	e8 fe b9 ff ff       	call   8010053a <panic>
    intena = cpu->intena;
80104b3c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b42:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80104b4b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b51:	8b 40 04             	mov    0x4(%eax),%eax
80104b54:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b5b:	83 c2 1c             	add    $0x1c,%edx
80104b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b62:	89 14 24             	mov    %edx,(%esp)
80104b65:	e8 de 08 00 00       	call   80105448 <swtch>
    cpu->intena = intena;
80104b6a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b73:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104b79:	c9                   	leave  
80104b7a:	c3                   	ret    

80104b7b <yield>:

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80104b7b:	55                   	push   %ebp
80104b7c:	89 e5                	mov    %esp,%ebp
80104b7e:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104b81:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b88:	e8 c6 03 00 00       	call   80104f53 <acquire>
    proc->state = RUNNABLE;
80104b8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b93:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80104b9a:	e8 01 ff ff ff       	call   80104aa0 <sched>
    release(&ptable.lock);
80104b9f:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ba6:	e8 09 04 00 00       	call   80104fb4 <release>
}
80104bab:	c9                   	leave  
80104bac:	c3                   	ret    

80104bad <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
80104bad:	55                   	push   %ebp
80104bae:	89 e5                	mov    %esp,%ebp
80104bb0:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80104bb3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104bba:	e8 f5 03 00 00       	call   80104fb4 <release>

    if (first) {
80104bbf:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	74 0f                	je     80104bd7 <forkret+0x2a>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80104bc8:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104bcf:	00 00 00 
        initlog();
80104bd2:	e8 55 e4 ff ff       	call   8010302c <initlog>
    }

    // Return to "caller", actually trapret (see allocproc).
}
80104bd7:	c9                   	leave  
80104bd8:	c3                   	ret    

80104bd9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80104bd9:	55                   	push   %ebp
80104bda:	89 e5                	mov    %esp,%ebp
80104bdc:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
80104bdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be5:	85 c0                	test   %eax,%eax
80104be7:	75 0c                	jne    80104bf5 <sleep+0x1c>
        panic("sleep");
80104be9:	c7 04 24 6d 89 10 80 	movl   $0x8010896d,(%esp)
80104bf0:	e8 45 b9 ff ff       	call   8010053a <panic>

    if(lk == 0)
80104bf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104bf9:	75 0c                	jne    80104c07 <sleep+0x2e>
        panic("sleep without lk");
80104bfb:	c7 04 24 73 89 10 80 	movl   $0x80108973,(%esp)
80104c02:	e8 33 b9 ff ff       	call   8010053a <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80104c07:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104c0e:	74 17                	je     80104c27 <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104c10:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104c17:	e8 37 03 00 00       	call   80104f53 <acquire>
        release(lk);
80104c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c1f:	89 04 24             	mov    %eax,(%esp)
80104c22:	e8 8d 03 00 00       	call   80104fb4 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80104c27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c30:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80104c33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c39:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80104c40:	e8 5b fe ff ff       	call   80104aa0 <sched>

    // Tidy up.
    proc->chan = 0;
80104c45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
80104c52:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104c59:	74 17                	je     80104c72 <sleep+0x99>
        release(&ptable.lock);
80104c5b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104c62:	e8 4d 03 00 00       	call   80104fb4 <release>
        acquire(lk);
80104c67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6a:	89 04 24             	mov    %eax,(%esp)
80104c6d:	e8 e1 02 00 00       	call   80104f53 <acquire>
    }
}
80104c72:	c9                   	leave  
80104c73:	c3                   	ret    

80104c74 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
    static void
wakeup1(void *chan)
{
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c7a:	c7 45 fc 74 ff 10 80 	movl   $0x8010ff74,-0x4(%ebp)
80104c81:	eb 27                	jmp    80104caa <wakeup1+0x36>
        if(p->state == SLEEPING && p->chan == chan)
80104c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c86:	8b 40 0c             	mov    0xc(%eax),%eax
80104c89:	83 f8 02             	cmp    $0x2,%eax
80104c8c:	75 15                	jne    80104ca3 <wakeup1+0x2f>
80104c8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c91:	8b 40 20             	mov    0x20(%eax),%eax
80104c94:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c97:	75 0a                	jne    80104ca3 <wakeup1+0x2f>
            p->state = RUNNABLE;
80104c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c9c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ca3:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104caa:	b8 74 20 11 80       	mov    $0x80112074,%eax
80104caf:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104cb2:	72 cf                	jb     80104c83 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}
80104cb4:	c9                   	leave  
80104cb5:	c3                   	ret    

80104cb6 <twakeup>:

void 
twakeup(int tid){
80104cb6:	55                   	push   %ebp
80104cb7:	89 e5                	mov    %esp,%ebp
80104cb9:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80104cbc:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104cc3:	e8 8b 02 00 00       	call   80104f53 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc8:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104ccf:	eb 36                	jmp    80104d07 <twakeup+0x51>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
80104cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd7:	83 f8 02             	cmp    $0x2,%eax
80104cda:	75 24                	jne    80104d00 <twakeup+0x4a>
80104cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdf:	8b 40 10             	mov    0x10(%eax),%eax
80104ce2:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ce5:	75 19                	jne    80104d00 <twakeup+0x4a>
80104ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cea:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104cf0:	83 f8 01             	cmp    $0x1,%eax
80104cf3:	75 0b                	jne    80104d00 <twakeup+0x4a>
            wakeup1(p);
80104cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf8:	89 04 24             	mov    %eax,(%esp)
80104cfb:	e8 74 ff ff ff       	call   80104c74 <wakeup1>

void 
twakeup(int tid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d00:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104d07:	b8 74 20 11 80       	mov    $0x80112074,%eax
80104d0c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104d0f:	72 c0                	jb     80104cd1 <twakeup+0x1b>
        if(p->state == SLEEPING && p->pid == tid && p->isthread == 1){
            wakeup1(p);
        }
    }
    release(&ptable.lock);
80104d11:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d18:	e8 97 02 00 00       	call   80104fb4 <release>
}
80104d1d:	c9                   	leave  
80104d1e:	c3                   	ret    

80104d1f <wakeup>:

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80104d1f:	55                   	push   %ebp
80104d20:	89 e5                	mov    %esp,%ebp
80104d22:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80104d25:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d2c:	e8 22 02 00 00       	call   80104f53 <acquire>
    wakeup1(chan);
80104d31:	8b 45 08             	mov    0x8(%ebp),%eax
80104d34:	89 04 24             	mov    %eax,(%esp)
80104d37:	e8 38 ff ff ff       	call   80104c74 <wakeup1>
    release(&ptable.lock);
80104d3c:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d43:	e8 6c 02 00 00       	call   80104fb4 <release>
}
80104d48:	c9                   	leave  
80104d49:	c3                   	ret    

80104d4a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80104d4a:	55                   	push   %ebp
80104d4b:	89 e5                	mov    %esp,%ebp
80104d4d:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;

    acquire(&ptable.lock);
80104d50:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d57:	e8 f7 01 00 00       	call   80104f53 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d5c:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104d63:	eb 44                	jmp    80104da9 <kill+0x5f>
        if(p->pid == pid){
80104d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d68:	8b 40 10             	mov    0x10(%eax),%eax
80104d6b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d6e:	75 32                	jne    80104da2 <kill+0x58>
            p->killed = 1;
80104d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80104d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7d:	8b 40 0c             	mov    0xc(%eax),%eax
80104d80:	83 f8 02             	cmp    $0x2,%eax
80104d83:	75 0a                	jne    80104d8f <kill+0x45>
                p->state = RUNNABLE;
80104d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d88:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104d8f:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104d96:	e8 19 02 00 00       	call   80104fb4 <release>
            return 0;
80104d9b:	b8 00 00 00 00       	mov    $0x0,%eax
80104da0:	eb 22                	jmp    80104dc4 <kill+0x7a>
kill(int pid)
{
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104da9:	b8 74 20 11 80       	mov    $0x80112074,%eax
80104dae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104db1:	72 b2                	jb     80104d65 <kill+0x1b>
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80104db3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104dba:	e8 f5 01 00 00       	call   80104fb4 <release>
    return -1;
80104dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc4:	c9                   	leave  
80104dc5:	c3                   	ret    

80104dc6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104dc6:	55                   	push   %ebp
80104dc7:	89 e5                	mov    %esp,%ebp
80104dc9:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dcc:	c7 45 f0 74 ff 10 80 	movl   $0x8010ff74,-0x10(%ebp)
80104dd3:	e9 db 00 00 00       	jmp    80104eb3 <procdump+0xed>
        if(p->state == UNUSED)
80104dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ddb:	8b 40 0c             	mov    0xc(%eax),%eax
80104dde:	85 c0                	test   %eax,%eax
80104de0:	0f 84 c5 00 00 00    	je     80104eab <procdump+0xe5>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104de9:	8b 40 0c             	mov    0xc(%eax),%eax
80104dec:	83 f8 05             	cmp    $0x5,%eax
80104def:	77 23                	ja     80104e14 <procdump+0x4e>
80104df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104df4:	8b 40 0c             	mov    0xc(%eax),%eax
80104df7:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104dfe:	85 c0                	test   %eax,%eax
80104e00:	74 12                	je     80104e14 <procdump+0x4e>
            state = states[p->state];
80104e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e05:	8b 40 0c             	mov    0xc(%eax),%eax
80104e08:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e12:	eb 07                	jmp    80104e1b <procdump+0x55>
            state = states[p->state];
        else
            state = "???";
80104e14:	c7 45 f4 84 89 10 80 	movl   $0x80108984,-0xc(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80104e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e24:	8b 40 10             	mov    0x10(%eax),%eax
80104e27:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e2e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e32:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e36:	c7 04 24 88 89 10 80 	movl   $0x80108988,(%esp)
80104e3d:	e8 58 b5 ff ff       	call   8010039a <cprintf>
        if(p->state == SLEEPING){
80104e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e45:	8b 40 0c             	mov    0xc(%eax),%eax
80104e48:	83 f8 02             	cmp    $0x2,%eax
80104e4b:	75 50                	jne    80104e9d <procdump+0xd7>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80104e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e50:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e53:	8b 40 0c             	mov    0xc(%eax),%eax
80104e56:	83 c0 08             	add    $0x8,%eax
80104e59:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104e5c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e60:	89 04 24             	mov    %eax,(%esp)
80104e63:	e8 9b 01 00 00       	call   80105003 <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
80104e68:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104e6f:	eb 1b                	jmp    80104e8c <procdump+0xc6>
                cprintf(" %p", pc[i]);
80104e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e74:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e78:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e7c:	c7 04 24 91 89 10 80 	movl   $0x80108991,(%esp)
80104e83:	e8 12 b5 ff ff       	call   8010039a <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80104e88:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104e8c:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104e90:	7f 0b                	jg     80104e9d <procdump+0xd7>
80104e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e95:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e99:	85 c0                	test   %eax,%eax
80104e9b:	75 d4                	jne    80104e71 <procdump+0xab>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104e9d:	c7 04 24 95 89 10 80 	movl   $0x80108995,(%esp)
80104ea4:	e8 f1 b4 ff ff       	call   8010039a <cprintf>
80104ea9:	eb 01                	jmp    80104eac <procdump+0xe6>
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80104eab:	90                   	nop
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eac:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104eb3:	b8 74 20 11 80       	mov    $0x80112074,%eax
80104eb8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104ebb:	0f 82 17 ff ff ff    	jb     80104dd8 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104ec1:	c9                   	leave  
80104ec2:	c3                   	ret    

80104ec3 <tsleep>:

void tsleep(void){
80104ec3:	55                   	push   %ebp
80104ec4:	89 e5                	mov    %esp,%ebp
80104ec6:	83 ec 18             	sub    $0x18,%esp
    
    acquire(&ptable.lock); 
80104ec9:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ed0:	e8 7e 00 00 00       	call   80104f53 <acquire>
    sleep(proc, &ptable.lock);
80104ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104edb:	c7 44 24 04 40 ff 10 	movl   $0x8010ff40,0x4(%esp)
80104ee2:	80 
80104ee3:	89 04 24             	mov    %eax,(%esp)
80104ee6:	e8 ee fc ff ff       	call   80104bd9 <sleep>
    release(&ptable.lock);
80104eeb:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ef2:	e8 bd 00 00 00       	call   80104fb4 <release>

}
80104ef7:	c9                   	leave  
80104ef8:	c3                   	ret    
80104ef9:	00 00                	add    %al,(%eax)
	...

80104efc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104efc:	55                   	push   %ebp
80104efd:	89 e5                	mov    %esp,%ebp
80104eff:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f02:	9c                   	pushf  
80104f03:	58                   	pop    %eax
80104f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f0a:	c9                   	leave  
80104f0b:	c3                   	ret    

80104f0c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f0c:	55                   	push   %ebp
80104f0d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f0f:	fa                   	cli    
}
80104f10:	5d                   	pop    %ebp
80104f11:	c3                   	ret    

80104f12 <sti>:

static inline void
sti(void)
{
80104f12:	55                   	push   %ebp
80104f13:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f15:	fb                   	sti    
}
80104f16:	5d                   	pop    %ebp
80104f17:	c3                   	ret    

80104f18 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f18:	55                   	push   %ebp
80104f19:	89 e5                	mov    %esp,%ebp
80104f1b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f1e:	8b 55 08             	mov    0x8(%ebp),%edx
80104f21:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f24:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f27:	f0 87 02             	lock xchg %eax,(%edx)
80104f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f30:	c9                   	leave  
80104f31:	c3                   	ret    

80104f32 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f32:	55                   	push   %ebp
80104f33:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f35:	8b 45 08             	mov    0x8(%ebp),%eax
80104f38:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f3b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f47:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    

80104f53 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f53:	55                   	push   %ebp
80104f54:	89 e5                	mov    %esp,%ebp
80104f56:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f59:	e8 3e 01 00 00       	call   8010509c <pushcli>
  if(holding(lk))
80104f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f61:	89 04 24             	mov    %eax,(%esp)
80104f64:	e8 09 01 00 00       	call   80105072 <holding>
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	74 0c                	je     80104f79 <acquire+0x26>
    panic("acquire");
80104f6d:	c7 04 24 c1 89 10 80 	movl   $0x801089c1,(%esp)
80104f74:	e8 c1 b5 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f79:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f83:	00 
80104f84:	89 04 24             	mov    %eax,(%esp)
80104f87:	e8 8c ff ff ff       	call   80104f18 <xchg>
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	75 e9                	jne    80104f79 <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f90:	8b 45 08             	mov    0x8(%ebp),%eax
80104f93:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f9a:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa0:	83 c0 0c             	add    $0xc,%eax
80104fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa7:	8d 45 08             	lea    0x8(%ebp),%eax
80104faa:	89 04 24             	mov    %eax,(%esp)
80104fad:	e8 51 00 00 00       	call   80105003 <getcallerpcs>
}
80104fb2:	c9                   	leave  
80104fb3:	c3                   	ret    

80104fb4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104fba:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbd:	89 04 24             	mov    %eax,(%esp)
80104fc0:	e8 ad 00 00 00       	call   80105072 <holding>
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	75 0c                	jne    80104fd5 <release+0x21>
    panic("release");
80104fc9:	c7 04 24 c9 89 10 80 	movl   $0x801089c9,(%esp)
80104fd0:	e8 65 b5 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104ff3:	00 
80104ff4:	89 04 24             	mov    %eax,(%esp)
80104ff7:	e8 1c ff ff ff       	call   80104f18 <xchg>

  popcli();
80104ffc:	e8 e3 00 00 00       	call   801050e4 <popcli>
}
80105001:	c9                   	leave  
80105002:	c3                   	ret    

80105003 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105003:	55                   	push   %ebp
80105004:	89 e5                	mov    %esp,%ebp
80105006:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105009:	8b 45 08             	mov    0x8(%ebp),%eax
8010500c:	83 e8 08             	sub    $0x8,%eax
8010500f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80105012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105019:	eb 34                	jmp    8010504f <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010501b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
8010501f:	74 49                	je     8010506a <getcallerpcs+0x67>
80105021:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80105028:	76 40                	jbe    8010506a <getcallerpcs+0x67>
8010502a:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
8010502e:	74 3a                	je     8010506a <getcallerpcs+0x67>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105030:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105033:	c1 e0 02             	shl    $0x2,%eax
80105036:	03 45 0c             	add    0xc(%ebp),%eax
80105039:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010503c:	83 c2 04             	add    $0x4,%edx
8010503f:	8b 12                	mov    (%edx),%edx
80105041:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80105043:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105046:	8b 00                	mov    (%eax),%eax
80105048:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010504b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010504f:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80105053:	7e c6                	jle    8010501b <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105055:	eb 13                	jmp    8010506a <getcallerpcs+0x67>
    pcs[i] = 0;
80105057:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010505a:	c1 e0 02             	shl    $0x2,%eax
8010505d:	03 45 0c             	add    0xc(%ebp),%eax
80105060:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105066:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010506a:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
8010506e:	7e e7                	jle    80105057 <getcallerpcs+0x54>
    pcs[i] = 0;
}
80105070:	c9                   	leave  
80105071:	c3                   	ret    

80105072 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105072:	55                   	push   %ebp
80105073:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105075:	8b 45 08             	mov    0x8(%ebp),%eax
80105078:	8b 00                	mov    (%eax),%eax
8010507a:	85 c0                	test   %eax,%eax
8010507c:	74 17                	je     80105095 <holding+0x23>
8010507e:	8b 45 08             	mov    0x8(%ebp),%eax
80105081:	8b 50 08             	mov    0x8(%eax),%edx
80105084:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010508a:	39 c2                	cmp    %eax,%edx
8010508c:	75 07                	jne    80105095 <holding+0x23>
8010508e:	b8 01 00 00 00       	mov    $0x1,%eax
80105093:	eb 05                	jmp    8010509a <holding+0x28>
80105095:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010509a:	5d                   	pop    %ebp
8010509b:	c3                   	ret    

8010509c <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010509c:	55                   	push   %ebp
8010509d:	89 e5                	mov    %esp,%ebp
8010509f:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050a2:	e8 55 fe ff ff       	call   80104efc <readeflags>
801050a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050aa:	e8 5d fe ff ff       	call   80104f0c <cli>
  if(cpu->ncli++ == 0)
801050af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050b5:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801050bb:	85 d2                	test   %edx,%edx
801050bd:	0f 94 c1             	sete   %cl
801050c0:	83 c2 01             	add    $0x1,%edx
801050c3:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050c9:	84 c9                	test   %cl,%cl
801050cb:	74 15                	je     801050e2 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
801050cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050d6:	81 e2 00 02 00 00    	and    $0x200,%edx
801050dc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801050e2:	c9                   	leave  
801050e3:	c3                   	ret    

801050e4 <popcli>:

void
popcli(void)
{
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801050ea:	e8 0d fe ff ff       	call   80104efc <readeflags>
801050ef:	25 00 02 00 00       	and    $0x200,%eax
801050f4:	85 c0                	test   %eax,%eax
801050f6:	74 0c                	je     80105104 <popcli+0x20>
    panic("popcli - interruptible");
801050f8:	c7 04 24 d1 89 10 80 	movl   $0x801089d1,(%esp)
801050ff:	e8 36 b4 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80105104:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010510a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105110:	83 ea 01             	sub    $0x1,%edx
80105113:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105119:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010511f:	85 c0                	test   %eax,%eax
80105121:	79 0c                	jns    8010512f <popcli+0x4b>
    panic("popcli");
80105123:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
8010512a:	e8 0b b4 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010512f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105135:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010513b:	85 c0                	test   %eax,%eax
8010513d:	75 15                	jne    80105154 <popcli+0x70>
8010513f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105145:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010514b:	85 c0                	test   %eax,%eax
8010514d:	74 05                	je     80105154 <popcli+0x70>
    sti();
8010514f:	e8 be fd ff ff       	call   80104f12 <sti>
}
80105154:	c9                   	leave  
80105155:	c3                   	ret    
	...

80105158 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105158:	55                   	push   %ebp
80105159:	89 e5                	mov    %esp,%ebp
8010515b:	57                   	push   %edi
8010515c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010515d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105160:	8b 55 10             	mov    0x10(%ebp),%edx
80105163:	8b 45 0c             	mov    0xc(%ebp),%eax
80105166:	89 cb                	mov    %ecx,%ebx
80105168:	89 df                	mov    %ebx,%edi
8010516a:	89 d1                	mov    %edx,%ecx
8010516c:	fc                   	cld    
8010516d:	f3 aa                	rep stos %al,%es:(%edi)
8010516f:	89 ca                	mov    %ecx,%edx
80105171:	89 fb                	mov    %edi,%ebx
80105173:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105176:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105179:	5b                   	pop    %ebx
8010517a:	5f                   	pop    %edi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    

8010517d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010517d:	55                   	push   %ebp
8010517e:	89 e5                	mov    %esp,%ebp
80105180:	57                   	push   %edi
80105181:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105182:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105185:	8b 55 10             	mov    0x10(%ebp),%edx
80105188:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518b:	89 cb                	mov    %ecx,%ebx
8010518d:	89 df                	mov    %ebx,%edi
8010518f:	89 d1                	mov    %edx,%ecx
80105191:	fc                   	cld    
80105192:	f3 ab                	rep stos %eax,%es:(%edi)
80105194:	89 ca                	mov    %ecx,%edx
80105196:	89 fb                	mov    %edi,%ebx
80105198:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010519b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010519e:	5b                   	pop    %ebx
8010519f:	5f                   	pop    %edi
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret    

801051a2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051a2:	55                   	push   %ebp
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051a8:	8b 45 08             	mov    0x8(%ebp),%eax
801051ab:	83 e0 03             	and    $0x3,%eax
801051ae:	85 c0                	test   %eax,%eax
801051b0:	75 49                	jne    801051fb <memset+0x59>
801051b2:	8b 45 10             	mov    0x10(%ebp),%eax
801051b5:	83 e0 03             	and    $0x3,%eax
801051b8:	85 c0                	test   %eax,%eax
801051ba:	75 3f                	jne    801051fb <memset+0x59>
    c &= 0xFF;
801051bc:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051c3:	8b 45 10             	mov    0x10(%ebp),%eax
801051c6:	c1 e8 02             	shr    $0x2,%eax
801051c9:	89 c2                	mov    %eax,%edx
801051cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ce:	89 c1                	mov    %eax,%ecx
801051d0:	c1 e1 18             	shl    $0x18,%ecx
801051d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d6:	c1 e0 10             	shl    $0x10,%eax
801051d9:	09 c1                	or     %eax,%ecx
801051db:	8b 45 0c             	mov    0xc(%ebp),%eax
801051de:	c1 e0 08             	shl    $0x8,%eax
801051e1:	09 c8                	or     %ecx,%eax
801051e3:	0b 45 0c             	or     0xc(%ebp),%eax
801051e6:	89 54 24 08          	mov    %edx,0x8(%esp)
801051ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ee:	8b 45 08             	mov    0x8(%ebp),%eax
801051f1:	89 04 24             	mov    %eax,(%esp)
801051f4:	e8 84 ff ff ff       	call   8010517d <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
801051f9:	eb 19                	jmp    80105214 <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
801051fb:	8b 45 10             	mov    0x10(%ebp),%eax
801051fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105202:	8b 45 0c             	mov    0xc(%ebp),%eax
80105205:	89 44 24 04          	mov    %eax,0x4(%esp)
80105209:	8b 45 08             	mov    0x8(%ebp),%eax
8010520c:	89 04 24             	mov    %eax,(%esp)
8010520f:	e8 44 ff ff ff       	call   80105158 <stosb>
  return dst;
80105214:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105217:	c9                   	leave  
80105218:	c3                   	ret    

80105219 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105219:	55                   	push   %ebp
8010521a:	89 e5                	mov    %esp,%ebp
8010521c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010521f:	8b 45 08             	mov    0x8(%ebp),%eax
80105222:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
80105225:	8b 45 0c             	mov    0xc(%ebp),%eax
80105228:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
8010522b:	eb 32                	jmp    8010525f <memcmp+0x46>
    if(*s1 != *s2)
8010522d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105230:	0f b6 10             	movzbl (%eax),%edx
80105233:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105236:	0f b6 00             	movzbl (%eax),%eax
80105239:	38 c2                	cmp    %al,%dl
8010523b:	74 1a                	je     80105257 <memcmp+0x3e>
      return *s1 - *s2;
8010523d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105240:	0f b6 00             	movzbl (%eax),%eax
80105243:	0f b6 d0             	movzbl %al,%edx
80105246:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105249:	0f b6 00             	movzbl (%eax),%eax
8010524c:	0f b6 c0             	movzbl %al,%eax
8010524f:	89 d1                	mov    %edx,%ecx
80105251:	29 c1                	sub    %eax,%ecx
80105253:	89 c8                	mov    %ecx,%eax
80105255:	eb 1c                	jmp    80105273 <memcmp+0x5a>
    s1++, s2++;
80105257:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010525b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010525f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105263:	0f 95 c0             	setne  %al
80105266:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010526a:	84 c0                	test   %al,%al
8010526c:	75 bf                	jne    8010522d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010526e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105273:	c9                   	leave  
80105274:	c3                   	ret    

80105275 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105275:	55                   	push   %ebp
80105276:	89 e5                	mov    %esp,%ebp
80105278:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010527b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
80105281:	8b 45 08             	mov    0x8(%ebp),%eax
80105284:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
80105287:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010528a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010528d:	73 55                	jae    801052e4 <memmove+0x6f>
8010528f:	8b 45 10             	mov    0x10(%ebp),%eax
80105292:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105295:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105298:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010529b:	76 4a                	jbe    801052e7 <memmove+0x72>
    s += n;
8010529d:	8b 45 10             	mov    0x10(%ebp),%eax
801052a0:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
801052a3:	8b 45 10             	mov    0x10(%ebp),%eax
801052a6:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
801052a9:	eb 13                	jmp    801052be <memmove+0x49>
      *--d = *--s;
801052ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052af:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052b6:	0f b6 10             	movzbl (%eax),%edx
801052b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052bc:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052c2:	0f 95 c0             	setne  %al
801052c5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052c9:	84 c0                	test   %al,%al
801052cb:	75 de                	jne    801052ab <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052cd:	eb 28                	jmp    801052f7 <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801052cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052d2:	0f b6 10             	movzbl (%eax),%edx
801052d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052d8:	88 10                	mov    %dl,(%eax)
801052da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801052de:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052e2:	eb 04                	jmp    801052e8 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052e4:	90                   	nop
801052e5:	eb 01                	jmp    801052e8 <memmove+0x73>
801052e7:	90                   	nop
801052e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052ec:	0f 95 c0             	setne  %al
801052ef:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052f3:	84 c0                	test   %al,%al
801052f5:	75 d8                	jne    801052cf <memmove+0x5a>
      *d++ = *s++;

  return dst;
801052f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052fa:	c9                   	leave  
801052fb:	c3                   	ret    

801052fc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052fc:	55                   	push   %ebp
801052fd:	89 e5                	mov    %esp,%ebp
801052ff:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105302:	8b 45 10             	mov    0x10(%ebp),%eax
80105305:	89 44 24 08          	mov    %eax,0x8(%esp)
80105309:	8b 45 0c             	mov    0xc(%ebp),%eax
8010530c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105310:	8b 45 08             	mov    0x8(%ebp),%eax
80105313:	89 04 24             	mov    %eax,(%esp)
80105316:	e8 5a ff ff ff       	call   80105275 <memmove>
}
8010531b:	c9                   	leave  
8010531c:	c3                   	ret    

8010531d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010531d:	55                   	push   %ebp
8010531e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105320:	eb 0c                	jmp    8010532e <strncmp+0x11>
    n--, p++, q++;
80105322:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010532a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010532e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105332:	74 1a                	je     8010534e <strncmp+0x31>
80105334:	8b 45 08             	mov    0x8(%ebp),%eax
80105337:	0f b6 00             	movzbl (%eax),%eax
8010533a:	84 c0                	test   %al,%al
8010533c:	74 10                	je     8010534e <strncmp+0x31>
8010533e:	8b 45 08             	mov    0x8(%ebp),%eax
80105341:	0f b6 10             	movzbl (%eax),%edx
80105344:	8b 45 0c             	mov    0xc(%ebp),%eax
80105347:	0f b6 00             	movzbl (%eax),%eax
8010534a:	38 c2                	cmp    %al,%dl
8010534c:	74 d4                	je     80105322 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010534e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105352:	75 07                	jne    8010535b <strncmp+0x3e>
    return 0;
80105354:	b8 00 00 00 00       	mov    $0x0,%eax
80105359:	eb 18                	jmp    80105373 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
8010535b:	8b 45 08             	mov    0x8(%ebp),%eax
8010535e:	0f b6 00             	movzbl (%eax),%eax
80105361:	0f b6 d0             	movzbl %al,%edx
80105364:	8b 45 0c             	mov    0xc(%ebp),%eax
80105367:	0f b6 00             	movzbl (%eax),%eax
8010536a:	0f b6 c0             	movzbl %al,%eax
8010536d:	89 d1                	mov    %edx,%ecx
8010536f:	29 c1                	sub    %eax,%ecx
80105371:	89 c8                	mov    %ecx,%eax
}
80105373:	5d                   	pop    %ebp
80105374:	c3                   	ret    

80105375 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105375:	55                   	push   %ebp
80105376:	89 e5                	mov    %esp,%ebp
80105378:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010537b:	8b 45 08             	mov    0x8(%ebp),%eax
8010537e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105385:	0f 9f c0             	setg   %al
80105388:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010538c:	84 c0                	test   %al,%al
8010538e:	74 30                	je     801053c0 <strncpy+0x4b>
80105390:	8b 45 0c             	mov    0xc(%ebp),%eax
80105393:	0f b6 10             	movzbl (%eax),%edx
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
80105399:	88 10                	mov    %dl,(%eax)
8010539b:	8b 45 08             	mov    0x8(%ebp),%eax
8010539e:	0f b6 00             	movzbl (%eax),%eax
801053a1:	84 c0                	test   %al,%al
801053a3:	0f 95 c0             	setne  %al
801053a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053aa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053ae:	84 c0                	test   %al,%al
801053b0:	75 cf                	jne    80105381 <strncpy+0xc>
    ;
  while(n-- > 0)
801053b2:	eb 0d                	jmp    801053c1 <strncpy+0x4c>
    *s++ = 0;
801053b4:	8b 45 08             	mov    0x8(%ebp),%eax
801053b7:	c6 00 00             	movb   $0x0,(%eax)
801053ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053be:	eb 01                	jmp    801053c1 <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053c0:	90                   	nop
801053c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053c5:	0f 9f c0             	setg   %al
801053c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053cc:	84 c0                	test   %al,%al
801053ce:	75 e4                	jne    801053b4 <strncpy+0x3f>
    *s++ = 0;
  return os;
801053d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053d3:	c9                   	leave  
801053d4:	c3                   	ret    

801053d5 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053d5:	55                   	push   %ebp
801053d6:	89 e5                	mov    %esp,%ebp
801053d8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053db:	8b 45 08             	mov    0x8(%ebp),%eax
801053de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053e5:	7f 05                	jg     801053ec <safestrcpy+0x17>
    return os;
801053e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ea:	eb 35                	jmp    80105421 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
801053ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f4:	7e 22                	jle    80105418 <safestrcpy+0x43>
801053f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f9:	0f b6 10             	movzbl (%eax),%edx
801053fc:	8b 45 08             	mov    0x8(%ebp),%eax
801053ff:	88 10                	mov    %dl,(%eax)
80105401:	8b 45 08             	mov    0x8(%ebp),%eax
80105404:	0f b6 00             	movzbl (%eax),%eax
80105407:	84 c0                	test   %al,%al
80105409:	0f 95 c0             	setne  %al
8010540c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105410:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105414:	84 c0                	test   %al,%al
80105416:	75 d4                	jne    801053ec <safestrcpy+0x17>
    ;
  *s = 0;
80105418:	8b 45 08             	mov    0x8(%ebp),%eax
8010541b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010541e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105421:	c9                   	leave  
80105422:	c3                   	ret    

80105423 <strlen>:

int
strlen(const char *s)
{
80105423:	55                   	push   %ebp
80105424:	89 e5                	mov    %esp,%ebp
80105426:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105429:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105430:	eb 04                	jmp    80105436 <strlen+0x13>
80105432:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105436:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105439:	03 45 08             	add    0x8(%ebp),%eax
8010543c:	0f b6 00             	movzbl (%eax),%eax
8010543f:	84 c0                	test   %al,%al
80105441:	75 ef                	jne    80105432 <strlen+0xf>
    ;
  return n;
80105443:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105446:	c9                   	leave  
80105447:	c3                   	ret    

80105448 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105448:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010544c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105450:	55                   	push   %ebp
  pushl %ebx
80105451:	53                   	push   %ebx
  pushl %esi
80105452:	56                   	push   %esi
  pushl %edi
80105453:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105454:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105456:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105458:	5f                   	pop    %edi
  popl %esi
80105459:	5e                   	pop    %esi
  popl %ebx
8010545a:	5b                   	pop    %ebx
  popl %ebp
8010545b:	5d                   	pop    %ebp
  ret
8010545c:	c3                   	ret    
8010545d:	00 00                	add    %al,(%eax)
	...

80105460 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105463:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105469:	8b 00                	mov    (%eax),%eax
8010546b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010546e:	76 12                	jbe    80105482 <fetchint+0x22>
80105470:	8b 45 08             	mov    0x8(%ebp),%eax
80105473:	8d 50 04             	lea    0x4(%eax),%edx
80105476:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547c:	8b 00                	mov    (%eax),%eax
8010547e:	39 c2                	cmp    %eax,%edx
80105480:	76 07                	jbe    80105489 <fetchint+0x29>
    return -1;
80105482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105487:	eb 0f                	jmp    80105498 <fetchint+0x38>
  *ip = *(int*)(addr);
80105489:	8b 45 08             	mov    0x8(%ebp),%eax
8010548c:	8b 10                	mov    (%eax),%edx
8010548e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105491:	89 10                	mov    %edx,(%eax)
  return 0;
80105493:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105498:	5d                   	pop    %ebp
80105499:	c3                   	ret    

8010549a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010549a:	55                   	push   %ebp
8010549b:	89 e5                	mov    %esp,%ebp
8010549d:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801054a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a6:	8b 00                	mov    (%eax),%eax
801054a8:	3b 45 08             	cmp    0x8(%ebp),%eax
801054ab:	77 07                	ja     801054b4 <fetchstr+0x1a>
    return -1;
801054ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b2:	eb 48                	jmp    801054fc <fetchstr+0x62>
  *pp = (char*)addr;
801054b4:	8b 55 08             	mov    0x8(%ebp),%edx
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c2:	8b 00                	mov    (%eax),%eax
801054c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
801054c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ca:	8b 00                	mov    (%eax),%eax
801054cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
801054cf:	eb 1e                	jmp    801054ef <fetchstr+0x55>
    if(*s == 0)
801054d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054d4:	0f b6 00             	movzbl (%eax),%eax
801054d7:	84 c0                	test   %al,%al
801054d9:	75 10                	jne    801054eb <fetchstr+0x51>
      return s - *pp;
801054db:	8b 55 f8             	mov    -0x8(%ebp),%edx
801054de:	8b 45 0c             	mov    0xc(%ebp),%eax
801054e1:	8b 00                	mov    (%eax),%eax
801054e3:	89 d1                	mov    %edx,%ecx
801054e5:	29 c1                	sub    %eax,%ecx
801054e7:	89 c8                	mov    %ecx,%eax
801054e9:	eb 11                	jmp    801054fc <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054eb:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801054f5:	72 da                	jb     801054d1 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801054f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fc:	c9                   	leave  
801054fd:	c3                   	ret    

801054fe <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054fe:	55                   	push   %ebp
801054ff:	89 e5                	mov    %esp,%ebp
80105501:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105504:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550a:	8b 40 18             	mov    0x18(%eax),%eax
8010550d:	8b 50 44             	mov    0x44(%eax),%edx
80105510:	8b 45 08             	mov    0x8(%ebp),%eax
80105513:	c1 e0 02             	shl    $0x2,%eax
80105516:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105519:	8d 50 04             	lea    0x4(%eax),%edx
8010551c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010551f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105523:	89 14 24             	mov    %edx,(%esp)
80105526:	e8 35 ff ff ff       	call   80105460 <fetchint>
}
8010552b:	c9                   	leave  
8010552c:	c3                   	ret    

8010552d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010552d:	55                   	push   %ebp
8010552e:	89 e5                	mov    %esp,%ebp
80105530:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105533:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105536:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553a:	8b 45 08             	mov    0x8(%ebp),%eax
8010553d:	89 04 24             	mov    %eax,(%esp)
80105540:	e8 b9 ff ff ff       	call   801054fe <argint>
80105545:	85 c0                	test   %eax,%eax
80105547:	79 07                	jns    80105550 <argptr+0x23>
    return -1;
80105549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554e:	eb 44                	jmp    80105594 <argptr+0x67>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz || (uint)i == 0)
80105550:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105553:	89 c2                	mov    %eax,%edx
80105555:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010555b:	8b 00                	mov    (%eax),%eax
8010555d:	39 c2                	cmp    %eax,%edx
8010555f:	73 1d                	jae    8010557e <argptr+0x51>
80105561:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105564:	89 c2                	mov    %eax,%edx
80105566:	8b 45 10             	mov    0x10(%ebp),%eax
80105569:	01 c2                	add    %eax,%edx
8010556b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105571:	8b 00                	mov    (%eax),%eax
80105573:	39 c2                	cmp    %eax,%edx
80105575:	77 07                	ja     8010557e <argptr+0x51>
80105577:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010557a:	85 c0                	test   %eax,%eax
8010557c:	75 07                	jne    80105585 <argptr+0x58>
    return -1;
8010557e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105583:	eb 0f                	jmp    80105594 <argptr+0x67>
  *pp = (char*)i;
80105585:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105588:	89 c2                	mov    %eax,%edx
8010558a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010558d:	89 10                	mov    %edx,(%eax)
  return 0;
8010558f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105594:	c9                   	leave  
80105595:	c3                   	ret    

80105596 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105596:	55                   	push   %ebp
80105597:	89 e5                	mov    %esp,%ebp
80105599:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010559c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010559f:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a3:	8b 45 08             	mov    0x8(%ebp),%eax
801055a6:	89 04 24             	mov    %eax,(%esp)
801055a9:	e8 50 ff ff ff       	call   801054fe <argint>
801055ae:	85 c0                	test   %eax,%eax
801055b0:	79 07                	jns    801055b9 <argstr+0x23>
    return -1;
801055b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b7:	eb 12                	jmp    801055cb <argstr+0x35>
  return fetchstr(addr, pp);
801055b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801055bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801055c3:	89 04 24             	mov    %eax,(%esp)
801055c6:	e8 cf fe ff ff       	call   8010549a <fetchstr>
}
801055cb:	c9                   	leave  
801055cc:	c3                   	ret    

801055cd <syscall>:
[SYS_twakeup]   sys_twakeup,
};

void
syscall(void)
{
801055cd:	55                   	push   %ebp
801055ce:	89 e5                	mov    %esp,%ebp
801055d0:	53                   	push   %ebx
801055d1:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801055d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055da:	8b 40 18             	mov    0x18(%eax),%eax
801055dd:	8b 40 1c             	mov    0x1c(%eax),%eax
801055e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055e7:	7e 30                	jle    80105619 <syscall+0x4c>
801055e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ec:	83 f8 19             	cmp    $0x19,%eax
801055ef:	77 28                	ja     80105619 <syscall+0x4c>
801055f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f4:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055fb:	85 c0                	test   %eax,%eax
801055fd:	74 1a                	je     80105619 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105605:	8b 58 18             	mov    0x18(%eax),%ebx
80105608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010560b:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105612:	ff d0                	call   *%eax
80105614:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105617:	eb 3d                	jmp    80105656 <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105619:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010561f:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
80105622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105628:	8b 40 10             	mov    0x10(%eax),%eax
8010562b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010562e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105632:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105636:	89 44 24 04          	mov    %eax,0x4(%esp)
8010563a:	c7 04 24 ef 89 10 80 	movl   $0x801089ef,(%esp)
80105641:	e8 54 ad ff ff       	call   8010039a <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105646:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010564c:	8b 40 18             	mov    0x18(%eax),%eax
8010564f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105656:	83 c4 24             	add    $0x24,%esp
80105659:	5b                   	pop    %ebx
8010565a:	5d                   	pop    %ebp
8010565b:	c3                   	ret    

8010565c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010565c:	55                   	push   %ebp
8010565d:	89 e5                	mov    %esp,%ebp
8010565f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105662:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105665:	89 44 24 04          	mov    %eax,0x4(%esp)
80105669:	8b 45 08             	mov    0x8(%ebp),%eax
8010566c:	89 04 24             	mov    %eax,(%esp)
8010566f:	e8 8a fe ff ff       	call   801054fe <argint>
80105674:	85 c0                	test   %eax,%eax
80105676:	79 07                	jns    8010567f <argfd+0x23>
    return -1;
80105678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567d:	eb 50                	jmp    801056cf <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010567f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105682:	85 c0                	test   %eax,%eax
80105684:	78 21                	js     801056a7 <argfd+0x4b>
80105686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105689:	83 f8 0f             	cmp    $0xf,%eax
8010568c:	7f 19                	jg     801056a7 <argfd+0x4b>
8010568e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105694:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105697:	83 c2 08             	add    $0x8,%edx
8010569a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010569e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056a5:	75 07                	jne    801056ae <argfd+0x52>
    return -1;
801056a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ac:	eb 21                	jmp    801056cf <argfd+0x73>
  if(pfd)
801056ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801056b2:	74 08                	je     801056bc <argfd+0x60>
    *pfd = fd;
801056b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ba:	89 10                	mov    %edx,(%eax)
  if(pf)
801056bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c0:	74 08                	je     801056ca <argfd+0x6e>
    *pf = f;
801056c2:	8b 45 10             	mov    0x10(%ebp),%eax
801056c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056c8:	89 10                	mov    %edx,(%eax)
  return 0;
801056ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056cf:	c9                   	leave  
801056d0:	c3                   	ret    

801056d1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056d1:	55                   	push   %ebp
801056d2:	89 e5                	mov    %esp,%ebp
801056d4:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056de:	eb 30                	jmp    80105710 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801056e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056e9:	83 c2 08             	add    $0x8,%edx
801056ec:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056f0:	85 c0                	test   %eax,%eax
801056f2:	75 18                	jne    8010570c <fdalloc+0x3b>
      proc->ofile[fd] = f;
801056f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056fd:	8d 4a 08             	lea    0x8(%edx),%ecx
80105700:	8b 55 08             	mov    0x8(%ebp),%edx
80105703:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105707:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010570a:	eb 0f                	jmp    8010571b <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010570c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105710:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105714:	7e ca                	jle    801056e0 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571b:	c9                   	leave  
8010571c:	c3                   	ret    

8010571d <sys_dup>:

int
sys_dup(void)
{
8010571d:	55                   	push   %ebp
8010571e:	89 e5                	mov    %esp,%ebp
80105720:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105723:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105726:	89 44 24 08          	mov    %eax,0x8(%esp)
8010572a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105731:	00 
80105732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105739:	e8 1e ff ff ff       	call   8010565c <argfd>
8010573e:	85 c0                	test   %eax,%eax
80105740:	79 07                	jns    80105749 <sys_dup+0x2c>
    return -1;
80105742:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105747:	eb 29                	jmp    80105772 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105749:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574c:	89 04 24             	mov    %eax,(%esp)
8010574f:	e8 7d ff ff ff       	call   801056d1 <fdalloc>
80105754:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010575b:	79 07                	jns    80105764 <sys_dup+0x47>
    return -1;
8010575d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105762:	eb 0e                	jmp    80105772 <sys_dup+0x55>
  filedup(f);
80105764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105767:	89 04 24             	mov    %eax,(%esp)
8010576a:	e8 3e b8 ff ff       	call   80100fad <filedup>
  return fd;
8010576f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105772:	c9                   	leave  
80105773:	c3                   	ret    

80105774 <sys_read>:

int
sys_read(void)
{
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010577a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105781:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105788:	00 
80105789:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105790:	e8 c7 fe ff ff       	call   8010565c <argfd>
80105795:	85 c0                	test   %eax,%eax
80105797:	78 35                	js     801057ce <sys_read+0x5a>
80105799:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010579c:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801057a7:	e8 52 fd ff ff       	call   801054fe <argint>
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 1e                	js     801057ce <sys_read+0x5a>
801057b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057b7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801057be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057c5:	e8 63 fd ff ff       	call   8010552d <argptr>
801057ca:	85 c0                	test   %eax,%eax
801057cc:	79 07                	jns    801057d5 <sys_read+0x61>
    return -1;
801057ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d3:	eb 19                	jmp    801057ee <sys_read+0x7a>
  return fileread(f, p, n);
801057d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057de:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801057e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801057e6:	89 04 24             	mov    %eax,(%esp)
801057e9:	e8 2c b9 ff ff       	call   8010111a <fileread>
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <sys_write>:

int
sys_write(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801057fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105804:	00 
80105805:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010580c:	e8 4b fe ff ff       	call   8010565c <argfd>
80105811:	85 c0                	test   %eax,%eax
80105813:	78 35                	js     8010584a <sys_write+0x5a>
80105815:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105818:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105823:	e8 d6 fc ff ff       	call   801054fe <argint>
80105828:	85 c0                	test   %eax,%eax
8010582a:	78 1e                	js     8010584a <sys_write+0x5a>
8010582c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105833:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105836:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105841:	e8 e7 fc ff ff       	call   8010552d <argptr>
80105846:	85 c0                	test   %eax,%eax
80105848:	79 07                	jns    80105851 <sys_write+0x61>
    return -1;
8010584a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584f:	eb 19                	jmp    8010586a <sys_write+0x7a>
  return filewrite(f, p, n);
80105851:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105854:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010585e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105862:	89 04 24             	mov    %eax,(%esp)
80105865:	e8 6c b9 ff ff       	call   801011d6 <filewrite>
}
8010586a:	c9                   	leave  
8010586b:	c3                   	ret    

8010586c <sys_close>:

int
sys_close(void)
{
8010586c:	55                   	push   %ebp
8010586d:	89 e5                	mov    %esp,%ebp
8010586f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105872:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105875:	89 44 24 08          	mov    %eax,0x8(%esp)
80105879:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105880:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105887:	e8 d0 fd ff ff       	call   8010565c <argfd>
8010588c:	85 c0                	test   %eax,%eax
8010588e:	79 07                	jns    80105897 <sys_close+0x2b>
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	eb 24                	jmp    801058bb <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105897:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010589d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058a0:	83 c2 08             	add    $0x8,%edx
801058a3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801058aa:	00 
  fileclose(f);
801058ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058ae:	89 04 24             	mov    %eax,(%esp)
801058b1:	e8 3f b7 ff ff       	call   80100ff5 <fileclose>
  return 0;
801058b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058bb:	c9                   	leave  
801058bc:	c3                   	ret    

801058bd <sys_fstat>:

int
sys_fstat(void)
{
801058bd:	55                   	push   %ebp
801058be:	89 e5                	mov    %esp,%ebp
801058c0:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058d1:	00 
801058d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058d9:	e8 7e fd ff ff       	call   8010565c <argfd>
801058de:	85 c0                	test   %eax,%eax
801058e0:	78 1f                	js     80105901 <sys_fstat+0x44>
801058e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058e5:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801058ec:	00 
801058ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058f8:	e8 30 fc ff ff       	call   8010552d <argptr>
801058fd:	85 c0                	test   %eax,%eax
801058ff:	79 07                	jns    80105908 <sys_fstat+0x4b>
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105906:	eb 12                	jmp    8010591a <sys_fstat+0x5d>
  return filestat(f, st);
80105908:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010590b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105912:	89 04 24             	mov    %eax,(%esp)
80105915:	e8 b1 b7 ff ff       	call   801010cb <filestat>
}
8010591a:	c9                   	leave  
8010591b:	c3                   	ret    

8010591c <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010591c:	55                   	push   %ebp
8010591d:	89 e5                	mov    %esp,%ebp
8010591f:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105922:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105925:	89 44 24 04          	mov    %eax,0x4(%esp)
80105929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105930:	e8 61 fc ff ff       	call   80105596 <argstr>
80105935:	85 c0                	test   %eax,%eax
80105937:	78 17                	js     80105950 <sys_link+0x34>
80105939:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010593c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105940:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105947:	e8 4a fc ff ff       	call   80105596 <argstr>
8010594c:	85 c0                	test   %eax,%eax
8010594e:	79 0a                	jns    8010595a <sys_link+0x3e>
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105955:	e9 3c 01 00 00       	jmp    80105a96 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
8010595a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010595d:	89 04 24             	mov    %eax,(%esp)
80105960:	e8 e6 ca ff ff       	call   8010244b <namei>
80105965:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010596c:	75 0a                	jne    80105978 <sys_link+0x5c>
    return -1;
8010596e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105973:	e9 1e 01 00 00       	jmp    80105a96 <sys_link+0x17a>

  begin_trans();
80105978:	e8 bd d8 ff ff       	call   8010323a <begin_trans>

  ilock(ip);
8010597d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105980:	89 04 24             	mov    %eax,(%esp)
80105983:	e8 1b bf ff ff       	call   801018a3 <ilock>
  if(ip->type == T_DIR){
80105988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010598f:	66 83 f8 01          	cmp    $0x1,%ax
80105993:	75 1a                	jne    801059af <sys_link+0x93>
    iunlockput(ip);
80105995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105998:	89 04 24             	mov    %eax,(%esp)
8010599b:	e8 8a c1 ff ff       	call   80101b2a <iunlockput>
    commit_trans();
801059a0:	e8 de d8 ff ff       	call   80103283 <commit_trans>
    return -1;
801059a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059aa:	e9 e7 00 00 00       	jmp    80105a96 <sys_link+0x17a>
  }

  ip->nlink++;
801059af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059b6:	8d 50 01             	lea    0x1(%eax),%edx
801059b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bc:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801059c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c3:	89 04 24             	mov    %eax,(%esp)
801059c6:	e8 18 bd ff ff       	call   801016e3 <iupdate>
  iunlock(ip);
801059cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ce:	89 04 24             	mov    %eax,(%esp)
801059d1:	e8 1e c0 ff ff       	call   801019f4 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801059d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059d9:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801059e0:	89 04 24             	mov    %eax,(%esp)
801059e3:	e8 85 ca ff ff       	call   8010246d <nameiparent>
801059e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059ef:	74 68                	je     80105a59 <sys_link+0x13d>
    goto bad;
  ilock(dp);
801059f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f4:	89 04 24             	mov    %eax,(%esp)
801059f7:	e8 a7 be ff ff       	call   801018a3 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ff:	8b 10                	mov    (%eax),%edx
80105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a04:	8b 00                	mov    (%eax),%eax
80105a06:	39 c2                	cmp    %eax,%edx
80105a08:	75 20                	jne    80105a2a <sys_link+0x10e>
80105a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0d:	8b 40 04             	mov    0x4(%eax),%eax
80105a10:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a14:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1e:	89 04 24             	mov    %eax,(%esp)
80105a21:	e8 64 c7 ff ff       	call   8010218a <dirlink>
80105a26:	85 c0                	test   %eax,%eax
80105a28:	79 0d                	jns    80105a37 <sys_link+0x11b>
    iunlockput(dp);
80105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2d:	89 04 24             	mov    %eax,(%esp)
80105a30:	e8 f5 c0 ff ff       	call   80101b2a <iunlockput>
    goto bad;
80105a35:	eb 23                	jmp    80105a5a <sys_link+0x13e>
  }
  iunlockput(dp);
80105a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3a:	89 04 24             	mov    %eax,(%esp)
80105a3d:	e8 e8 c0 ff ff       	call   80101b2a <iunlockput>
  iput(ip);
80105a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a45:	89 04 24             	mov    %eax,(%esp)
80105a48:	e8 0c c0 ff ff       	call   80101a59 <iput>

  commit_trans();
80105a4d:	e8 31 d8 ff ff       	call   80103283 <commit_trans>

  return 0;
80105a52:	b8 00 00 00 00       	mov    $0x0,%eax
80105a57:	eb 3d                	jmp    80105a96 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a59:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5d:	89 04 24             	mov    %eax,(%esp)
80105a60:	e8 3e be ff ff       	call   801018a3 <ilock>
  ip->nlink--;
80105a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a68:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a6c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a72:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a79:	89 04 24             	mov    %eax,(%esp)
80105a7c:	e8 62 bc ff ff       	call   801016e3 <iupdate>
  iunlockput(ip);
80105a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a84:	89 04 24             	mov    %eax,(%esp)
80105a87:	e8 9e c0 ff ff       	call   80101b2a <iunlockput>
  commit_trans();
80105a8c:	e8 f2 d7 ff ff       	call   80103283 <commit_trans>
  return -1;
80105a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a96:	c9                   	leave  
80105a97:	c3                   	ret    

80105a98 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a98:	55                   	push   %ebp
80105a99:	89 e5                	mov    %esp,%ebp
80105a9b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a9e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105aa5:	eb 4b                	jmp    80105af2 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aaa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105aad:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105ab4:	00 
80105ab5:	89 54 24 08          	mov    %edx,0x8(%esp)
80105ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105abd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac0:	89 04 24             	mov    %eax,(%esp)
80105ac3:	e8 d4 c2 ff ff       	call   80101d9c <readi>
80105ac8:	83 f8 10             	cmp    $0x10,%eax
80105acb:	74 0c                	je     80105ad9 <isdirempty+0x41>
      panic("isdirempty: readi");
80105acd:	c7 04 24 0b 8a 10 80 	movl   $0x80108a0b,(%esp)
80105ad4:	e8 61 aa ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105ad9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105add:	66 85 c0             	test   %ax,%ax
80105ae0:	74 07                	je     80105ae9 <isdirempty+0x51>
      return 0;
80105ae2:	b8 00 00 00 00       	mov    $0x0,%eax
80105ae7:	eb 1b                	jmp    80105b04 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aec:	83 c0 10             	add    $0x10,%eax
80105aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105af5:	8b 45 08             	mov    0x8(%ebp),%eax
80105af8:	8b 40 18             	mov    0x18(%eax),%eax
80105afb:	39 c2                	cmp    %eax,%edx
80105afd:	72 a8                	jb     80105aa7 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105aff:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b04:	c9                   	leave  
80105b05:	c3                   	ret    

80105b06 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b06:	55                   	push   %ebp
80105b07:	89 e5                	mov    %esp,%ebp
80105b09:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b0c:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b1a:	e8 77 fa ff ff       	call   80105596 <argstr>
80105b1f:	85 c0                	test   %eax,%eax
80105b21:	79 0a                	jns    80105b2d <sys_unlink+0x27>
    return -1;
80105b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b28:	e9 aa 01 00 00       	jmp    80105cd7 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105b2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b30:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b33:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b37:	89 04 24             	mov    %eax,(%esp)
80105b3a:	e8 2e c9 ff ff       	call   8010246d <nameiparent>
80105b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b46:	75 0a                	jne    80105b52 <sys_unlink+0x4c>
    return -1;
80105b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b4d:	e9 85 01 00 00       	jmp    80105cd7 <sys_unlink+0x1d1>

  begin_trans();
80105b52:	e8 e3 d6 ff ff       	call   8010323a <begin_trans>

  ilock(dp);
80105b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5a:	89 04 24             	mov    %eax,(%esp)
80105b5d:	e8 41 bd ff ff       	call   801018a3 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b62:	c7 44 24 04 1d 8a 10 	movl   $0x80108a1d,0x4(%esp)
80105b69:	80 
80105b6a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b6d:	89 04 24             	mov    %eax,(%esp)
80105b70:	e8 2b c5 ff ff       	call   801020a0 <namecmp>
80105b75:	85 c0                	test   %eax,%eax
80105b77:	0f 84 45 01 00 00    	je     80105cc2 <sys_unlink+0x1bc>
80105b7d:	c7 44 24 04 1f 8a 10 	movl   $0x80108a1f,0x4(%esp)
80105b84:	80 
80105b85:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b88:	89 04 24             	mov    %eax,(%esp)
80105b8b:	e8 10 c5 ff ff       	call   801020a0 <namecmp>
80105b90:	85 c0                	test   %eax,%eax
80105b92:	0f 84 2a 01 00 00    	je     80105cc2 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b98:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b9b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b9f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba9:	89 04 24             	mov    %eax,(%esp)
80105bac:	e8 11 c5 ff ff       	call   801020c2 <dirlookup>
80105bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bb8:	0f 84 03 01 00 00    	je     80105cc1 <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
80105bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc1:	89 04 24             	mov    %eax,(%esp)
80105bc4:	e8 da bc ff ff       	call   801018a3 <ilock>

  if(ip->nlink < 1)
80105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bd0:	66 85 c0             	test   %ax,%ax
80105bd3:	7f 0c                	jg     80105be1 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105bd5:	c7 04 24 22 8a 10 80 	movl   $0x80108a22,(%esp)
80105bdc:	e8 59 a9 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105be8:	66 83 f8 01          	cmp    $0x1,%ax
80105bec:	75 1f                	jne    80105c0d <sys_unlink+0x107>
80105bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf1:	89 04 24             	mov    %eax,(%esp)
80105bf4:	e8 9f fe ff ff       	call   80105a98 <isdirempty>
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	75 10                	jne    80105c0d <sys_unlink+0x107>
    iunlockput(ip);
80105bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c00:	89 04 24             	mov    %eax,(%esp)
80105c03:	e8 22 bf ff ff       	call   80101b2a <iunlockput>
    goto bad;
80105c08:	e9 b5 00 00 00       	jmp    80105cc2 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105c0d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c14:	00 
80105c15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c1c:	00 
80105c1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c20:	89 04 24             	mov    %eax,(%esp)
80105c23:	e8 7a f5 ff ff       	call   801051a2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c28:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105c2b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c35:	00 
80105c36:	89 54 24 08          	mov    %edx,0x8(%esp)
80105c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c41:	89 04 24             	mov    %eax,(%esp)
80105c44:	e8 bf c2 ff ff       	call   80101f08 <writei>
80105c49:	83 f8 10             	cmp    $0x10,%eax
80105c4c:	74 0c                	je     80105c5a <sys_unlink+0x154>
    panic("unlink: writei");
80105c4e:	c7 04 24 34 8a 10 80 	movl   $0x80108a34,(%esp)
80105c55:	e8 e0 a8 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c61:	66 83 f8 01          	cmp    $0x1,%ax
80105c65:	75 1c                	jne    80105c83 <sys_unlink+0x17d>
    dp->nlink--;
80105c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c6e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c74:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7b:	89 04 24             	mov    %eax,(%esp)
80105c7e:	e8 60 ba ff ff       	call   801016e3 <iupdate>
  }
  iunlockput(dp);
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	89 04 24             	mov    %eax,(%esp)
80105c89:	e8 9c be ff ff       	call   80101b2a <iunlockput>

  ip->nlink--;
80105c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c91:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c95:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca2:	89 04 24             	mov    %eax,(%esp)
80105ca5:	e8 39 ba ff ff       	call   801016e3 <iupdate>
  iunlockput(ip);
80105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cad:	89 04 24             	mov    %eax,(%esp)
80105cb0:	e8 75 be ff ff       	call   80101b2a <iunlockput>

  commit_trans();
80105cb5:	e8 c9 d5 ff ff       	call   80103283 <commit_trans>

  return 0;
80105cba:	b8 00 00 00 00       	mov    $0x0,%eax
80105cbf:	eb 16                	jmp    80105cd7 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105cc1:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc5:	89 04 24             	mov    %eax,(%esp)
80105cc8:	e8 5d be ff ff       	call   80101b2a <iunlockput>
  commit_trans();
80105ccd:	e8 b1 d5 ff ff       	call   80103283 <commit_trans>
  return -1;
80105cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd7:	c9                   	leave  
80105cd8:	c3                   	ret    

80105cd9 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cd9:	55                   	push   %ebp
80105cda:	89 e5                	mov    %esp,%ebp
80105cdc:	83 ec 48             	sub    $0x48,%esp
80105cdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ce2:	8b 55 10             	mov    0x10(%ebp),%edx
80105ce5:	8b 45 14             	mov    0x14(%ebp),%eax
80105ce8:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cec:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cf0:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cf4:	8d 45 de             	lea    -0x22(%ebp),%eax
80105cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80105cfe:	89 04 24             	mov    %eax,(%esp)
80105d01:	e8 67 c7 ff ff       	call   8010246d <nameiparent>
80105d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d0d:	75 0a                	jne    80105d19 <create+0x40>
    return 0;
80105d0f:	b8 00 00 00 00       	mov    $0x0,%eax
80105d14:	e9 7e 01 00 00       	jmp    80105e97 <create+0x1be>
  ilock(dp);
80105d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1c:	89 04 24             	mov    %eax,(%esp)
80105d1f:	e8 7f bb ff ff       	call   801018a3 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d24:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d27:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d2b:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d35:	89 04 24             	mov    %eax,(%esp)
80105d38:	e8 85 c3 ff ff       	call   801020c2 <dirlookup>
80105d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d44:	74 47                	je     80105d8d <create+0xb4>
    iunlockput(dp);
80105d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d49:	89 04 24             	mov    %eax,(%esp)
80105d4c:	e8 d9 bd ff ff       	call   80101b2a <iunlockput>
    ilock(ip);
80105d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d54:	89 04 24             	mov    %eax,(%esp)
80105d57:	e8 47 bb ff ff       	call   801018a3 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d5c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d61:	75 15                	jne    80105d78 <create+0x9f>
80105d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d66:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d6a:	66 83 f8 02          	cmp    $0x2,%ax
80105d6e:	75 08                	jne    80105d78 <create+0x9f>
      return ip;
80105d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d73:	e9 1f 01 00 00       	jmp    80105e97 <create+0x1be>
    iunlockput(ip);
80105d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7b:	89 04 24             	mov    %eax,(%esp)
80105d7e:	e8 a7 bd ff ff       	call   80101b2a <iunlockput>
    return 0;
80105d83:	b8 00 00 00 00       	mov    $0x0,%eax
80105d88:	e9 0a 01 00 00       	jmp    80105e97 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d8d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d94:	8b 00                	mov    (%eax),%eax
80105d96:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d9a:	89 04 24             	mov    %eax,(%esp)
80105d9d:	e8 64 b8 ff ff       	call   80101606 <ialloc>
80105da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105da5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105da9:	75 0c                	jne    80105db7 <create+0xde>
    panic("create: ialloc");
80105dab:	c7 04 24 43 8a 10 80 	movl   $0x80108a43,(%esp)
80105db2:	e8 83 a7 ff ff       	call   8010053a <panic>

  ilock(ip);
80105db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dba:	89 04 24             	mov    %eax,(%esp)
80105dbd:	e8 e1 ba ff ff       	call   801018a3 <ilock>
  ip->major = major;
80105dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc5:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105dc9:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd0:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105dd4:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddb:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de4:	89 04 24             	mov    %eax,(%esp)
80105de7:	e8 f7 b8 ff ff       	call   801016e3 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105dec:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105df1:	75 6a                	jne    80105e5d <create+0x184>
    dp->nlink++;  // for ".."
80105df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dfa:	8d 50 01             	lea    0x1(%eax),%edx
80105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e00:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e07:	89 04 24             	mov    %eax,(%esp)
80105e0a:	e8 d4 b8 ff ff       	call   801016e3 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e12:	8b 40 04             	mov    0x4(%eax),%eax
80105e15:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e19:	c7 44 24 04 1d 8a 10 	movl   $0x80108a1d,0x4(%esp)
80105e20:	80 
80105e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e24:	89 04 24             	mov    %eax,(%esp)
80105e27:	e8 5e c3 ff ff       	call   8010218a <dirlink>
80105e2c:	85 c0                	test   %eax,%eax
80105e2e:	78 21                	js     80105e51 <create+0x178>
80105e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e33:	8b 40 04             	mov    0x4(%eax),%eax
80105e36:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e3a:	c7 44 24 04 1f 8a 10 	movl   $0x80108a1f,0x4(%esp)
80105e41:	80 
80105e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e45:	89 04 24             	mov    %eax,(%esp)
80105e48:	e8 3d c3 ff ff       	call   8010218a <dirlink>
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	79 0c                	jns    80105e5d <create+0x184>
      panic("create dots");
80105e51:	c7 04 24 52 8a 10 80 	movl   $0x80108a52,(%esp)
80105e58:	e8 dd a6 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e60:	8b 40 04             	mov    0x4(%eax),%eax
80105e63:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e67:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e71:	89 04 24             	mov    %eax,(%esp)
80105e74:	e8 11 c3 ff ff       	call   8010218a <dirlink>
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	79 0c                	jns    80105e89 <create+0x1b0>
    panic("create: dirlink");
80105e7d:	c7 04 24 5e 8a 10 80 	movl   $0x80108a5e,(%esp)
80105e84:	e8 b1 a6 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8c:	89 04 24             	mov    %eax,(%esp)
80105e8f:	e8 96 bc ff ff       	call   80101b2a <iunlockput>

  return ip;
80105e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e97:	c9                   	leave  
80105e98:	c3                   	ret    

80105e99 <sys_open>:

int
sys_open(void)
{
80105e99:	55                   	push   %ebp
80105e9a:	89 e5                	mov    %esp,%ebp
80105e9c:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e9f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ea2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ea6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ead:	e8 e4 f6 ff ff       	call   80105596 <argstr>
80105eb2:	85 c0                	test   %eax,%eax
80105eb4:	78 17                	js     80105ecd <sys_open+0x34>
80105eb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ebd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ec4:	e8 35 f6 ff ff       	call   801054fe <argint>
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	79 0a                	jns    80105ed7 <sys_open+0x3e>
    return -1;
80105ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed2:	e9 46 01 00 00       	jmp    8010601d <sys_open+0x184>
  if(omode & O_CREATE){
80105ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105eda:	25 00 02 00 00       	and    $0x200,%eax
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	74 40                	je     80105f23 <sys_open+0x8a>
    begin_trans();
80105ee3:	e8 52 d3 ff ff       	call   8010323a <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eeb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ef2:	00 
80105ef3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105efa:	00 
80105efb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f02:	00 
80105f03:	89 04 24             	mov    %eax,(%esp)
80105f06:	e8 ce fd ff ff       	call   80105cd9 <create>
80105f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105f0e:	e8 70 d3 ff ff       	call   80103283 <commit_trans>
    if(ip == 0)
80105f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f17:	75 5c                	jne    80105f75 <sys_open+0xdc>
      return -1;
80105f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1e:	e9 fa 00 00 00       	jmp    8010601d <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f26:	89 04 24             	mov    %eax,(%esp)
80105f29:	e8 1d c5 ff ff       	call   8010244b <namei>
80105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f35:	75 0a                	jne    80105f41 <sys_open+0xa8>
      return -1;
80105f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3c:	e9 dc 00 00 00       	jmp    8010601d <sys_open+0x184>
    ilock(ip);
80105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f44:	89 04 24             	mov    %eax,(%esp)
80105f47:	e8 57 b9 ff ff       	call   801018a3 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f53:	66 83 f8 01          	cmp    $0x1,%ax
80105f57:	75 1c                	jne    80105f75 <sys_open+0xdc>
80105f59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f5c:	85 c0                	test   %eax,%eax
80105f5e:	74 15                	je     80105f75 <sys_open+0xdc>
      iunlockput(ip);
80105f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f63:	89 04 24             	mov    %eax,(%esp)
80105f66:	e8 bf bb ff ff       	call   80101b2a <iunlockput>
      return -1;
80105f6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f70:	e9 a8 00 00 00       	jmp    8010601d <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f75:	e8 d2 af ff ff       	call   80100f4c <filealloc>
80105f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f81:	74 14                	je     80105f97 <sys_open+0xfe>
80105f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f86:	89 04 24             	mov    %eax,(%esp)
80105f89:	e8 43 f7 ff ff       	call   801056d1 <fdalloc>
80105f8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f95:	79 23                	jns    80105fba <sys_open+0x121>
    if(f)
80105f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f9b:	74 0b                	je     80105fa8 <sys_open+0x10f>
      fileclose(f);
80105f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa0:	89 04 24             	mov    %eax,(%esp)
80105fa3:	e8 4d b0 ff ff       	call   80100ff5 <fileclose>
    iunlockput(ip);
80105fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fab:	89 04 24             	mov    %eax,(%esp)
80105fae:	e8 77 bb ff ff       	call   80101b2a <iunlockput>
    return -1;
80105fb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb8:	eb 63                	jmp    8010601d <sys_open+0x184>
  }
  iunlock(ip);
80105fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fbd:	89 04 24             	mov    %eax,(%esp)
80105fc0:	e8 2f ba ff ff       	call   801019f4 <iunlock>

  f->type = FD_INODE;
80105fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fda:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe4:	83 e0 01             	and    $0x1,%eax
80105fe7:	85 c0                	test   %eax,%eax
80105fe9:	0f 94 c2             	sete   %dl
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff5:	83 e0 01             	and    $0x1,%eax
80105ff8:	84 c0                	test   %al,%al
80105ffa:	75 0a                	jne    80106006 <sys_open+0x16d>
80105ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fff:	83 e0 02             	and    $0x2,%eax
80106002:	85 c0                	test   %eax,%eax
80106004:	74 07                	je     8010600d <sys_open+0x174>
80106006:	b8 01 00 00 00       	mov    $0x1,%eax
8010600b:	eb 05                	jmp    80106012 <sys_open+0x179>
8010600d:	b8 00 00 00 00       	mov    $0x0,%eax
80106012:	89 c2                	mov    %eax,%edx
80106014:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106017:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010601a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010601d:	c9                   	leave  
8010601e:	c3                   	ret    

8010601f <sys_mkdir>:

int
sys_mkdir(void)
{
8010601f:	55                   	push   %ebp
80106020:	89 e5                	mov    %esp,%ebp
80106022:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106025:	e8 10 d2 ff ff       	call   8010323a <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010602a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010602d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106031:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106038:	e8 59 f5 ff ff       	call   80105596 <argstr>
8010603d:	85 c0                	test   %eax,%eax
8010603f:	78 2c                	js     8010606d <sys_mkdir+0x4e>
80106041:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106044:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010604b:	00 
8010604c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106053:	00 
80106054:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010605b:	00 
8010605c:	89 04 24             	mov    %eax,(%esp)
8010605f:	e8 75 fc ff ff       	call   80105cd9 <create>
80106064:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010606b:	75 0c                	jne    80106079 <sys_mkdir+0x5a>
    commit_trans();
8010606d:	e8 11 d2 ff ff       	call   80103283 <commit_trans>
    return -1;
80106072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106077:	eb 15                	jmp    8010608e <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607c:	89 04 24             	mov    %eax,(%esp)
8010607f:	e8 a6 ba ff ff       	call   80101b2a <iunlockput>
  commit_trans();
80106084:	e8 fa d1 ff ff       	call   80103283 <commit_trans>
  return 0;
80106089:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010608e:	c9                   	leave  
8010608f:	c3                   	ret    

80106090 <sys_mknod>:

int
sys_mknod(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106096:	e8 9f d1 ff ff       	call   8010323a <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
8010609b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010609e:	89 44 24 04          	mov    %eax,0x4(%esp)
801060a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060a9:	e8 e8 f4 ff ff       	call   80105596 <argstr>
801060ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b5:	78 5e                	js     80106115 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801060b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801060be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060c5:	e8 34 f4 ff ff       	call   801054fe <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801060ca:	85 c0                	test   %eax,%eax
801060cc:	78 47                	js     80106115 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060dc:	e8 1d f4 ff ff       	call   801054fe <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
801060e1:	85 c0                	test   %eax,%eax
801060e3:	78 30                	js     80106115 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060e8:	0f bf c8             	movswl %ax,%ecx
801060eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060ee:	0f bf d0             	movswl %ax,%edx
801060f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060f4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801060f8:	89 54 24 08          	mov    %edx,0x8(%esp)
801060fc:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106103:	00 
80106104:	89 04 24             	mov    %eax,(%esp)
80106107:	e8 cd fb ff ff       	call   80105cd9 <create>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
8010610c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010610f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106113:	75 0c                	jne    80106121 <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106115:	e8 69 d1 ff ff       	call   80103283 <commit_trans>
    return -1;
8010611a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611f:	eb 15                	jmp    80106136 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106121:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106124:	89 04 24             	mov    %eax,(%esp)
80106127:	e8 fe b9 ff ff       	call   80101b2a <iunlockput>
  commit_trans();
8010612c:	e8 52 d1 ff ff       	call   80103283 <commit_trans>
  return 0;
80106131:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106136:	c9                   	leave  
80106137:	c3                   	ret    

80106138 <sys_chdir>:

int
sys_chdir(void)
{
80106138:	55                   	push   %ebp
80106139:	89 e5                	mov    %esp,%ebp
8010613b:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010613e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106141:	89 44 24 04          	mov    %eax,0x4(%esp)
80106145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010614c:	e8 45 f4 ff ff       	call   80105596 <argstr>
80106151:	85 c0                	test   %eax,%eax
80106153:	78 14                	js     80106169 <sys_chdir+0x31>
80106155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106158:	89 04 24             	mov    %eax,(%esp)
8010615b:	e8 eb c2 ff ff       	call   8010244b <namei>
80106160:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106163:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106167:	75 07                	jne    80106170 <sys_chdir+0x38>
    return -1;
80106169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616e:	eb 57                	jmp    801061c7 <sys_chdir+0x8f>
  ilock(ip);
80106170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106173:	89 04 24             	mov    %eax,(%esp)
80106176:	e8 28 b7 ff ff       	call   801018a3 <ilock>
  if(ip->type != T_DIR){
8010617b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106182:	66 83 f8 01          	cmp    $0x1,%ax
80106186:	74 12                	je     8010619a <sys_chdir+0x62>
    iunlockput(ip);
80106188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618b:	89 04 24             	mov    %eax,(%esp)
8010618e:	e8 97 b9 ff ff       	call   80101b2a <iunlockput>
    return -1;
80106193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106198:	eb 2d                	jmp    801061c7 <sys_chdir+0x8f>
  }
  iunlock(ip);
8010619a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619d:	89 04 24             	mov    %eax,(%esp)
801061a0:	e8 4f b8 ff ff       	call   801019f4 <iunlock>
  iput(proc->cwd);
801061a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061ab:	8b 40 68             	mov    0x68(%eax),%eax
801061ae:	89 04 24             	mov    %eax,(%esp)
801061b1:	e8 a3 b8 ff ff       	call   80101a59 <iput>
  proc->cwd = ip;
801061b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061bf:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061c7:	c9                   	leave  
801061c8:	c3                   	ret    

801061c9 <sys_exec>:

int
sys_exec(void)
{
801061c9:	55                   	push   %ebp
801061ca:	89 e5                	mov    %esp,%ebp
801061cc:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801061d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061e0:	e8 b1 f3 ff ff       	call   80105596 <argstr>
801061e5:	85 c0                	test   %eax,%eax
801061e7:	78 1a                	js     80106203 <sys_exec+0x3a>
801061e9:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061fa:	e8 ff f2 ff ff       	call   801054fe <argint>
801061ff:	85 c0                	test   %eax,%eax
80106201:	79 0a                	jns    8010620d <sys_exec+0x44>
    return -1;
80106203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106208:	e9 cd 00 00 00       	jmp    801062da <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
8010620d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106214:	00 
80106215:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010621c:	00 
8010621d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106223:	89 04 24             	mov    %eax,(%esp)
80106226:	e8 77 ef ff ff       	call   801051a2 <memset>
  for(i=0;; i++){
8010622b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106235:	83 f8 1f             	cmp    $0x1f,%eax
80106238:	76 0a                	jbe    80106244 <sys_exec+0x7b>
      return -1;
8010623a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623f:	e9 96 00 00 00       	jmp    801062da <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106244:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010624a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010624d:	c1 e2 02             	shl    $0x2,%edx
80106250:	89 d1                	mov    %edx,%ecx
80106252:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80106258:	8d 14 11             	lea    (%ecx,%edx,1),%edx
8010625b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010625f:	89 14 24             	mov    %edx,(%esp)
80106262:	e8 f9 f1 ff ff       	call   80105460 <fetchint>
80106267:	85 c0                	test   %eax,%eax
80106269:	79 07                	jns    80106272 <sys_exec+0xa9>
      return -1;
8010626b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106270:	eb 68                	jmp    801062da <sys_exec+0x111>
    if(uarg == 0){
80106272:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106278:	85 c0                	test   %eax,%eax
8010627a:	75 26                	jne    801062a2 <sys_exec+0xd9>
      argv[i] = 0;
8010627c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106286:	00 00 00 00 
      break;
8010628a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010628b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010628e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106294:	89 54 24 04          	mov    %edx,0x4(%esp)
80106298:	89 04 24             	mov    %eax,(%esp)
8010629b:	e8 58 a8 ff ff       	call   80100af8 <exec>
801062a0:	eb 38                	jmp    801062da <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801062ac:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062b2:	01 d0                	add    %edx,%eax
801062b4:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
801062ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801062be:	89 14 24             	mov    %edx,(%esp)
801062c1:	e8 d4 f1 ff ff       	call   8010549a <fetchstr>
801062c6:	85 c0                	test   %eax,%eax
801062c8:	79 07                	jns    801062d1 <sys_exec+0x108>
      return -1;
801062ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cf:	eb 09                	jmp    801062da <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062d5:	e9 58 ff ff ff       	jmp    80106232 <sys_exec+0x69>
  return exec(path, argv);
}
801062da:	c9                   	leave  
801062db:	c3                   	ret    

801062dc <sys_pipe>:

int
sys_pipe(void)
{
801062dc:	55                   	push   %ebp
801062dd:	89 e5                	mov    %esp,%ebp
801062df:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062e5:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801062ec:	00 
801062ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801062f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062f8:	e8 30 f2 ff ff       	call   8010552d <argptr>
801062fd:	85 c0                	test   %eax,%eax
801062ff:	79 0a                	jns    8010630b <sys_pipe+0x2f>
    return -1;
80106301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106306:	e9 9b 00 00 00       	jmp    801063a6 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010630b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010630e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106312:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106315:	89 04 24             	mov    %eax,(%esp)
80106318:	e8 0f d9 ff ff       	call   80103c2c <pipealloc>
8010631d:	85 c0                	test   %eax,%eax
8010631f:	79 07                	jns    80106328 <sys_pipe+0x4c>
    return -1;
80106321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106326:	eb 7e                	jmp    801063a6 <sys_pipe+0xca>
  fd0 = -1;
80106328:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010632f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106332:	89 04 24             	mov    %eax,(%esp)
80106335:	e8 97 f3 ff ff       	call   801056d1 <fdalloc>
8010633a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010633d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106341:	78 14                	js     80106357 <sys_pipe+0x7b>
80106343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106346:	89 04 24             	mov    %eax,(%esp)
80106349:	e8 83 f3 ff ff       	call   801056d1 <fdalloc>
8010634e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106355:	79 37                	jns    8010638e <sys_pipe+0xb2>
    if(fd0 >= 0)
80106357:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010635b:	78 14                	js     80106371 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
8010635d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106363:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106366:	83 c2 08             	add    $0x8,%edx
80106369:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106370:	00 
    fileclose(rf);
80106371:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106374:	89 04 24             	mov    %eax,(%esp)
80106377:	e8 79 ac ff ff       	call   80100ff5 <fileclose>
    fileclose(wf);
8010637c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010637f:	89 04 24             	mov    %eax,(%esp)
80106382:	e8 6e ac ff ff       	call   80100ff5 <fileclose>
    return -1;
80106387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638c:	eb 18                	jmp    801063a6 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010638e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106391:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106394:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106396:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106399:	8d 50 04             	lea    0x4(%eax),%edx
8010639c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639f:	89 02                	mov    %eax,(%edx)
  return 0;
801063a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063a6:	c9                   	leave  
801063a7:	c3                   	ret    

801063a8 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063a8:	55                   	push   %ebp
801063a9:	89 e5                	mov    %esp,%ebp
801063ab:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063ae:	e8 b2 df ff ff       	call   80104365 <fork>
}
801063b3:	c9                   	leave  
801063b4:	c3                   	ret    

801063b5 <sys_clone>:

int
sys_clone(){
801063b5:	55                   	push   %ebp
801063b6:	89 e5                	mov    %esp,%ebp
801063b8:	53                   	push   %ebx
801063b9:	83 ec 24             	sub    $0x24,%esp
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
801063bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801063ca:	e8 2f f1 ff ff       	call   801054fe <argint>
801063cf:	85 c0                	test   %eax,%eax
801063d1:	78 4c                	js     8010641f <sys_clone+0x6a>
801063d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d6:	85 c0                	test   %eax,%eax
801063d8:	7e 45                	jle    8010641f <sys_clone+0x6a>
801063da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801063e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063e8:	e8 11 f1 ff ff       	call   801054fe <argint>
801063ed:	85 c0                	test   %eax,%eax
801063ef:	78 2e                	js     8010641f <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
801063f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801063f8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801063ff:	e8 fa f0 ff ff       	call   801054fe <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
80106404:	85 c0                	test   %eax,%eax
80106406:	78 17                	js     8010641f <sys_clone+0x6a>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
80106408:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010640b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010640f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80106416:	e8 e3 f0 ff ff       	call   801054fe <argint>
    int stack;
    int size;
    int routine;
    int arg;

    if(argint(1,&size) < 0 || size <=0 || argint(0,&stack) <0 ||
8010641b:	85 c0                	test   %eax,%eax
8010641d:	79 07                	jns    80106426 <sys_clone+0x71>
            argint(2,&routine) < 0 || argint(3,&arg)<0){
        return -1;
8010641f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106424:	eb 20                	jmp    80106446 <sys_clone+0x91>
    }
    return clone(stack,size,routine,arg);
80106426:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80106429:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010642c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010642f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106432:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106436:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010643a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010643e:	89 04 24             	mov    %eax,(%esp)
80106441:	e8 8f e0 ff ff       	call   801044d5 <clone>
}
80106446:	83 c4 24             	add    $0x24,%esp
80106449:	5b                   	pop    %ebx
8010644a:	5d                   	pop    %ebp
8010644b:	c3                   	ret    

8010644c <sys_exit>:

int
sys_exit(void)
{
8010644c:	55                   	push   %ebp
8010644d:	89 e5                	mov    %esp,%ebp
8010644f:	83 ec 08             	sub    $0x8,%esp
  exit();
80106452:	e8 a1 e2 ff ff       	call   801046f8 <exit>
  return 0;  // not reached
80106457:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010645c:	c9                   	leave  
8010645d:	c3                   	ret    

8010645e <sys_texit>:

int
sys_texit(void)
{
8010645e:	55                   	push   %ebp
8010645f:	89 e5                	mov    %esp,%ebp
80106461:	83 ec 08             	sub    $0x8,%esp
    texit();
80106464:	e8 ab e3 ff ff       	call   80104814 <texit>
    return 0;
80106469:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010646e:	c9                   	leave  
8010646f:	c3                   	ret    

80106470 <sys_wait>:

int
sys_wait(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106476:	e8 67 e4 ff ff       	call   801048e2 <wait>
}
8010647b:	c9                   	leave  
8010647c:	c3                   	ret    

8010647d <sys_kill>:

int
sys_kill(void)
{
8010647d:	55                   	push   %ebp
8010647e:	89 e5                	mov    %esp,%ebp
80106480:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106483:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106486:	89 44 24 04          	mov    %eax,0x4(%esp)
8010648a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106491:	e8 68 f0 ff ff       	call   801054fe <argint>
80106496:	85 c0                	test   %eax,%eax
80106498:	79 07                	jns    801064a1 <sys_kill+0x24>
    return -1;
8010649a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649f:	eb 0b                	jmp    801064ac <sys_kill+0x2f>
  return kill(pid);
801064a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064a4:	89 04 24             	mov    %eax,(%esp)
801064a7:	e8 9e e8 ff ff       	call   80104d4a <kill>
}
801064ac:	c9                   	leave  
801064ad:	c3                   	ret    

801064ae <sys_getpid>:

int
sys_getpid(void)
{
801064ae:	55                   	push   %ebp
801064af:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801064b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064b7:	8b 40 10             	mov    0x10(%eax),%eax
}
801064ba:	5d                   	pop    %ebp
801064bb:	c3                   	ret    

801064bc <sys_sbrk>:

int
sys_sbrk(void)
{
801064bc:	55                   	push   %ebp
801064bd:	89 e5                	mov    %esp,%ebp
801064bf:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801064c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801064c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064d0:	e8 29 f0 ff ff       	call   801054fe <argint>
801064d5:	85 c0                	test   %eax,%eax
801064d7:	79 07                	jns    801064e0 <sys_sbrk+0x24>
    return -1;
801064d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064de:	eb 24                	jmp    80106504 <sys_sbrk+0x48>
  addr = proc->sz;
801064e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064e6:	8b 00                	mov    (%eax),%eax
801064e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801064eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ee:	89 04 24             	mov    %eax,(%esp)
801064f1:	e8 ca dd ff ff       	call   801042c0 <growproc>
801064f6:	85 c0                	test   %eax,%eax
801064f8:	79 07                	jns    80106501 <sys_sbrk+0x45>
    return -1;
801064fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ff:	eb 03                	jmp    80106504 <sys_sbrk+0x48>
  return addr;
80106501:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106504:	c9                   	leave  
80106505:	c3                   	ret    

80106506 <sys_sleep>:

int
sys_sleep(void)
{
80106506:	55                   	push   %ebp
80106507:	89 e5                	mov    %esp,%ebp
80106509:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010650c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010650f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106513:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010651a:	e8 df ef ff ff       	call   801054fe <argint>
8010651f:	85 c0                	test   %eax,%eax
80106521:	79 07                	jns    8010652a <sys_sleep+0x24>
    return -1;
80106523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106528:	eb 6c                	jmp    80106596 <sys_sleep+0x90>
  acquire(&tickslock);
8010652a:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80106531:	e8 1d ea ff ff       	call   80104f53 <acquire>
  ticks0 = ticks;
80106536:	a1 c0 28 11 80       	mov    0x801128c0,%eax
8010653b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010653e:	eb 34                	jmp    80106574 <sys_sleep+0x6e>
    if(proc->killed){
80106540:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106546:	8b 40 24             	mov    0x24(%eax),%eax
80106549:	85 c0                	test   %eax,%eax
8010654b:	74 13                	je     80106560 <sys_sleep+0x5a>
      release(&tickslock);
8010654d:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80106554:	e8 5b ea ff ff       	call   80104fb4 <release>
      return -1;
80106559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010655e:	eb 36                	jmp    80106596 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106560:	c7 44 24 04 80 20 11 	movl   $0x80112080,0x4(%esp)
80106567:	80 
80106568:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
8010656f:	e8 65 e6 ff ff       	call   80104bd9 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106574:	a1 c0 28 11 80       	mov    0x801128c0,%eax
80106579:	89 c2                	mov    %eax,%edx
8010657b:	2b 55 f4             	sub    -0xc(%ebp),%edx
8010657e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106581:	39 c2                	cmp    %eax,%edx
80106583:	72 bb                	jb     80106540 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106585:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010658c:	e8 23 ea ff ff       	call   80104fb4 <release>
  return 0;
80106591:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106596:	c9                   	leave  
80106597:	c3                   	ret    

80106598 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106598:	55                   	push   %ebp
80106599:	89 e5                	mov    %esp,%ebp
8010659b:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010659e:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801065a5:	e8 a9 e9 ff ff       	call   80104f53 <acquire>
  xticks = ticks;
801065aa:	a1 c0 28 11 80       	mov    0x801128c0,%eax
801065af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801065b2:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801065b9:	e8 f6 e9 ff ff       	call   80104fb4 <release>
  return xticks;
801065be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    

801065c3 <sys_tsleep>:

int
sys_tsleep(void)
{
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	83 ec 08             	sub    $0x8,%esp
    tsleep();
801065c9:	e8 f5 e8 ff ff       	call   80104ec3 <tsleep>
    return 0;
801065ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065d3:	c9                   	leave  
801065d4:	c3                   	ret    

801065d5 <sys_twakeup>:

int 
sys_twakeup(void)
{
801065d5:	55                   	push   %ebp
801065d6:	89 e5                	mov    %esp,%ebp
801065d8:	83 ec 28             	sub    $0x28,%esp
    int tid;
    if(argint(0,&tid) < 0){
801065db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065de:	89 44 24 04          	mov    %eax,0x4(%esp)
801065e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065e9:	e8 10 ef ff ff       	call   801054fe <argint>
801065ee:	85 c0                	test   %eax,%eax
801065f0:	79 07                	jns    801065f9 <sys_twakeup+0x24>
        return -1;
801065f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f7:	eb 10                	jmp    80106609 <sys_twakeup+0x34>
    }
        twakeup(tid);
801065f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fc:	89 04 24             	mov    %eax,(%esp)
801065ff:	e8 b2 e6 ff ff       	call   80104cb6 <twakeup>
        return 0;
80106604:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106609:	c9                   	leave  
8010660a:	c3                   	ret    
	...

8010660c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010660c:	55                   	push   %ebp
8010660d:	89 e5                	mov    %esp,%ebp
8010660f:	83 ec 08             	sub    $0x8,%esp
80106612:	8b 55 08             	mov    0x8(%ebp),%edx
80106615:	8b 45 0c             	mov    0xc(%ebp),%eax
80106618:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010661c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010661f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106623:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106627:	ee                   	out    %al,(%dx)
}
80106628:	c9                   	leave  
80106629:	c3                   	ret    

8010662a <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010662a:	55                   	push   %ebp
8010662b:	89 e5                	mov    %esp,%ebp
8010662d:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106630:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106637:	00 
80106638:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010663f:	e8 c8 ff ff ff       	call   8010660c <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106644:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010664b:	00 
8010664c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106653:	e8 b4 ff ff ff       	call   8010660c <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106658:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010665f:	00 
80106660:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106667:	e8 a0 ff ff ff       	call   8010660c <outb>
  picenable(IRQ_TIMER);
8010666c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106673:	e8 3d d4 ff ff       	call   80103ab5 <picenable>
}
80106678:	c9                   	leave  
80106679:	c3                   	ret    
	...

8010667c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010667c:	1e                   	push   %ds
  pushl %es
8010667d:	06                   	push   %es
  pushl %fs
8010667e:	0f a0                	push   %fs
  pushl %gs
80106680:	0f a8                	push   %gs
  pushal
80106682:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106683:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106687:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106689:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010668b:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010668f:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106691:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106693:	54                   	push   %esp
  call trap
80106694:	e8 d5 01 00 00       	call   8010686e <trap>
  addl $4, %esp
80106699:	83 c4 04             	add    $0x4,%esp

8010669c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010669c:	61                   	popa   
  popl %gs
8010669d:	0f a9                	pop    %gs
  popl %fs
8010669f:	0f a1                	pop    %fs
  popl %es
801066a1:	07                   	pop    %es
  popl %ds
801066a2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066a3:	83 c4 08             	add    $0x8,%esp
  iret
801066a6:	cf                   	iret   
	...

801066a8 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801066a8:	55                   	push   %ebp
801066a9:	89 e5                	mov    %esp,%ebp
801066ab:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801066ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801066b1:	83 e8 01             	sub    $0x1,%eax
801066b4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066b8:	8b 45 08             	mov    0x8(%ebp),%eax
801066bb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066bf:	8b 45 08             	mov    0x8(%ebp),%eax
801066c2:	c1 e8 10             	shr    $0x10,%eax
801066c5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801066c9:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066cc:	0f 01 18             	lidtl  (%eax)
}
801066cf:	c9                   	leave  
801066d0:	c3                   	ret    

801066d1 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801066d1:	55                   	push   %ebp
801066d2:	89 e5                	mov    %esp,%ebp
801066d4:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066d7:	0f 20 d0             	mov    %cr2,%eax
801066da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801066dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066e0:	c9                   	leave  
801066e1:	c3                   	ret    

801066e2 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801066e2:	55                   	push   %ebp
801066e3:	89 e5                	mov    %esp,%ebp
801066e5:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801066e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066ef:	e9 bf 00 00 00       	jmp    801067b3 <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801066f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066fa:	8b 14 95 a8 b0 10 80 	mov    -0x7fef4f58(,%edx,4),%edx
80106701:	66 89 14 c5 c0 20 11 	mov    %dx,-0x7feedf40(,%eax,8)
80106708:	80 
80106709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670c:	66 c7 04 c5 c2 20 11 	movw   $0x8,-0x7feedf3e(,%eax,8)
80106713:	80 08 00 
80106716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106719:	0f b6 14 c5 c4 20 11 	movzbl -0x7feedf3c(,%eax,8),%edx
80106720:	80 
80106721:	83 e2 e0             	and    $0xffffffe0,%edx
80106724:	88 14 c5 c4 20 11 80 	mov    %dl,-0x7feedf3c(,%eax,8)
8010672b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672e:	0f b6 14 c5 c4 20 11 	movzbl -0x7feedf3c(,%eax,8),%edx
80106735:	80 
80106736:	83 e2 1f             	and    $0x1f,%edx
80106739:	88 14 c5 c4 20 11 80 	mov    %dl,-0x7feedf3c(,%eax,8)
80106740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106743:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
8010674a:	80 
8010674b:	83 e2 f0             	and    $0xfffffff0,%edx
8010674e:	83 ca 0e             	or     $0xe,%edx
80106751:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
80106758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675b:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
80106762:	80 
80106763:	83 e2 ef             	and    $0xffffffef,%edx
80106766:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
8010676d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106770:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
80106777:	80 
80106778:	83 e2 9f             	and    $0xffffff9f,%edx
8010677b:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
80106782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106785:	0f b6 14 c5 c5 20 11 	movzbl -0x7feedf3b(,%eax,8),%edx
8010678c:	80 
8010678d:	83 ca 80             	or     $0xffffff80,%edx
80106790:	88 14 c5 c5 20 11 80 	mov    %dl,-0x7feedf3b(,%eax,8)
80106797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010679d:	8b 14 95 a8 b0 10 80 	mov    -0x7fef4f58(,%edx,4),%edx
801067a4:	c1 ea 10             	shr    $0x10,%edx
801067a7:	66 89 14 c5 c6 20 11 	mov    %dx,-0x7feedf3a(,%eax,8)
801067ae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801067af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067b3:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801067ba:	0f 8e 34 ff ff ff    	jle    801066f4 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801067c0:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
801067c5:	66 a3 c0 22 11 80    	mov    %ax,0x801122c0
801067cb:	66 c7 05 c2 22 11 80 	movw   $0x8,0x801122c2
801067d2:	08 00 
801067d4:	0f b6 05 c4 22 11 80 	movzbl 0x801122c4,%eax
801067db:	83 e0 e0             	and    $0xffffffe0,%eax
801067de:	a2 c4 22 11 80       	mov    %al,0x801122c4
801067e3:	0f b6 05 c4 22 11 80 	movzbl 0x801122c4,%eax
801067ea:	83 e0 1f             	and    $0x1f,%eax
801067ed:	a2 c4 22 11 80       	mov    %al,0x801122c4
801067f2:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
801067f9:	83 c8 0f             	or     $0xf,%eax
801067fc:	a2 c5 22 11 80       	mov    %al,0x801122c5
80106801:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
80106808:	83 e0 ef             	and    $0xffffffef,%eax
8010680b:	a2 c5 22 11 80       	mov    %al,0x801122c5
80106810:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
80106817:	83 c8 60             	or     $0x60,%eax
8010681a:	a2 c5 22 11 80       	mov    %al,0x801122c5
8010681f:	0f b6 05 c5 22 11 80 	movzbl 0x801122c5,%eax
80106826:	83 c8 80             	or     $0xffffff80,%eax
80106829:	a2 c5 22 11 80       	mov    %al,0x801122c5
8010682e:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
80106833:	c1 e8 10             	shr    $0x10,%eax
80106836:	66 a3 c6 22 11 80    	mov    %ax,0x801122c6
  
  initlock(&tickslock, "time");
8010683c:	c7 44 24 04 70 8a 10 	movl   $0x80108a70,0x4(%esp)
80106843:	80 
80106844:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
8010684b:	e8 e2 e6 ff ff       	call   80104f32 <initlock>
}
80106850:	c9                   	leave  
80106851:	c3                   	ret    

80106852 <idtinit>:

void
idtinit(void)
{
80106852:	55                   	push   %ebp
80106853:	89 e5                	mov    %esp,%ebp
80106855:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106858:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010685f:	00 
80106860:	c7 04 24 c0 20 11 80 	movl   $0x801120c0,(%esp)
80106867:	e8 3c fe ff ff       	call   801066a8 <lidt>
}
8010686c:	c9                   	leave  
8010686d:	c3                   	ret    

8010686e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010686e:	55                   	push   %ebp
8010686f:	89 e5                	mov    %esp,%ebp
80106871:	57                   	push   %edi
80106872:	56                   	push   %esi
80106873:	53                   	push   %ebx
80106874:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106877:	8b 45 08             	mov    0x8(%ebp),%eax
8010687a:	8b 40 30             	mov    0x30(%eax),%eax
8010687d:	83 f8 40             	cmp    $0x40,%eax
80106880:	75 3e                	jne    801068c0 <trap+0x52>
    if(proc->killed)
80106882:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106888:	8b 40 24             	mov    0x24(%eax),%eax
8010688b:	85 c0                	test   %eax,%eax
8010688d:	74 05                	je     80106894 <trap+0x26>
      exit();
8010688f:	e8 64 de ff ff       	call   801046f8 <exit>
    proc->tf = tf;
80106894:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010689a:	8b 55 08             	mov    0x8(%ebp),%edx
8010689d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801068a0:	e8 28 ed ff ff       	call   801055cd <syscall>
    if(proc->killed)
801068a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ab:	8b 40 24             	mov    0x24(%eax),%eax
801068ae:	85 c0                	test   %eax,%eax
801068b0:	0f 84 34 02 00 00    	je     80106aea <trap+0x27c>
      exit();
801068b6:	e8 3d de ff ff       	call   801046f8 <exit>
    return;
801068bb:	e9 2b 02 00 00       	jmp    80106aeb <trap+0x27d>
  }

  switch(tf->trapno){
801068c0:	8b 45 08             	mov    0x8(%ebp),%eax
801068c3:	8b 40 30             	mov    0x30(%eax),%eax
801068c6:	83 e8 20             	sub    $0x20,%eax
801068c9:	83 f8 1f             	cmp    $0x1f,%eax
801068cc:	0f 87 bc 00 00 00    	ja     8010698e <trap+0x120>
801068d2:	8b 04 85 18 8b 10 80 	mov    -0x7fef74e8(,%eax,4),%eax
801068d9:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801068db:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068e1:	0f b6 00             	movzbl (%eax),%eax
801068e4:	84 c0                	test   %al,%al
801068e6:	75 31                	jne    80106919 <trap+0xab>
      acquire(&tickslock);
801068e8:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
801068ef:	e8 5f e6 ff ff       	call   80104f53 <acquire>
      ticks++;
801068f4:	a1 c0 28 11 80       	mov    0x801128c0,%eax
801068f9:	83 c0 01             	add    $0x1,%eax
801068fc:	a3 c0 28 11 80       	mov    %eax,0x801128c0
      wakeup(&ticks);
80106901:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
80106908:	e8 12 e4 ff ff       	call   80104d1f <wakeup>
      release(&tickslock);
8010690d:	c7 04 24 80 20 11 80 	movl   $0x80112080,(%esp)
80106914:	e8 9b e6 ff ff       	call   80104fb4 <release>
    }
    lapiceoi();
80106919:	e8 ea c5 ff ff       	call   80102f08 <lapiceoi>
    break;
8010691e:	e9 41 01 00 00       	jmp    80106a64 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106923:	e8 fb bd ff ff       	call   80102723 <ideintr>
    lapiceoi();
80106928:	e8 db c5 ff ff       	call   80102f08 <lapiceoi>
    break;
8010692d:	e9 32 01 00 00       	jmp    80106a64 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106932:	e8 b4 c3 ff ff       	call   80102ceb <kbdintr>
    lapiceoi();
80106937:	e8 cc c5 ff ff       	call   80102f08 <lapiceoi>
    break;
8010693c:	e9 23 01 00 00       	jmp    80106a64 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106941:	e8 9d 03 00 00       	call   80106ce3 <uartintr>
    lapiceoi();
80106946:	e8 bd c5 ff ff       	call   80102f08 <lapiceoi>
    break;
8010694b:	e9 14 01 00 00       	jmp    80106a64 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106950:	8b 45 08             	mov    0x8(%ebp),%eax
80106953:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106956:	8b 45 08             	mov    0x8(%ebp),%eax
80106959:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010695d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106960:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106966:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106969:	0f b6 c0             	movzbl %al,%eax
8010696c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106970:	89 54 24 08          	mov    %edx,0x8(%esp)
80106974:	89 44 24 04          	mov    %eax,0x4(%esp)
80106978:	c7 04 24 78 8a 10 80 	movl   $0x80108a78,(%esp)
8010697f:	e8 16 9a ff ff       	call   8010039a <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106984:	e8 7f c5 ff ff       	call   80102f08 <lapiceoi>
    break;
80106989:	e9 d6 00 00 00       	jmp    80106a64 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010698e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106994:	85 c0                	test   %eax,%eax
80106996:	74 11                	je     801069a9 <trap+0x13b>
80106998:	8b 45 08             	mov    0x8(%ebp),%eax
8010699b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010699f:	0f b7 c0             	movzwl %ax,%eax
801069a2:	83 e0 03             	and    $0x3,%eax
801069a5:	85 c0                	test   %eax,%eax
801069a7:	75 46                	jne    801069ef <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069a9:	e8 23 fd ff ff       	call   801066d1 <rcr2>
801069ae:	8b 55 08             	mov    0x8(%ebp),%edx
801069b1:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801069b4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801069bb:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069be:	0f b6 ca             	movzbl %dl,%ecx
801069c1:	8b 55 08             	mov    0x8(%ebp),%edx
801069c4:	8b 52 30             	mov    0x30(%edx),%edx
801069c7:	89 44 24 10          	mov    %eax,0x10(%esp)
801069cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801069cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801069d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801069d7:	c7 04 24 9c 8a 10 80 	movl   $0x80108a9c,(%esp)
801069de:	e8 b7 99 ff ff       	call   8010039a <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801069e3:	c7 04 24 ce 8a 10 80 	movl   $0x80108ace,(%esp)
801069ea:	e8 4b 9b ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ef:	e8 dd fc ff ff       	call   801066d1 <rcr2>
801069f4:	89 c2                	mov    %eax,%edx
801069f6:	8b 45 08             	mov    0x8(%ebp),%eax
801069f9:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069fc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a02:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a05:	0f b6 f0             	movzbl %al,%esi
80106a08:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0b:	8b 58 34             	mov    0x34(%eax),%ebx
80106a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a11:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106a14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a1a:	83 c0 6c             	add    $0x6c,%eax
80106a1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106a20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a26:	8b 40 10             	mov    0x10(%eax),%eax
80106a29:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106a2d:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106a31:	89 74 24 14          	mov    %esi,0x14(%esp)
80106a35:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106a39:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a40:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a44:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a48:	c7 04 24 d4 8a 10 80 	movl   $0x80108ad4,(%esp)
80106a4f:	e8 46 99 ff ff       	call   8010039a <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106a54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a61:	eb 01                	jmp    80106a64 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106a63:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6a:	85 c0                	test   %eax,%eax
80106a6c:	74 24                	je     80106a92 <trap+0x224>
80106a6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a74:	8b 40 24             	mov    0x24(%eax),%eax
80106a77:	85 c0                	test   %eax,%eax
80106a79:	74 17                	je     80106a92 <trap+0x224>
80106a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a7e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a82:	0f b7 c0             	movzwl %ax,%eax
80106a85:	83 e0 03             	and    $0x3,%eax
80106a88:	83 f8 03             	cmp    $0x3,%eax
80106a8b:	75 05                	jne    80106a92 <trap+0x224>
    exit();
80106a8d:	e8 66 dc ff ff       	call   801046f8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	74 1e                	je     80106aba <trap+0x24c>
80106a9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aa2:	8b 40 0c             	mov    0xc(%eax),%eax
80106aa5:	83 f8 04             	cmp    $0x4,%eax
80106aa8:	75 10                	jne    80106aba <trap+0x24c>
80106aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106aad:	8b 40 30             	mov    0x30(%eax),%eax
80106ab0:	83 f8 20             	cmp    $0x20,%eax
80106ab3:	75 05                	jne    80106aba <trap+0x24c>
    yield();
80106ab5:	e8 c1 e0 ff ff       	call   80104b7b <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106aba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac0:	85 c0                	test   %eax,%eax
80106ac2:	74 27                	je     80106aeb <trap+0x27d>
80106ac4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106aca:	8b 40 24             	mov    0x24(%eax),%eax
80106acd:	85 c0                	test   %eax,%eax
80106acf:	74 1a                	je     80106aeb <trap+0x27d>
80106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ad8:	0f b7 c0             	movzwl %ax,%eax
80106adb:	83 e0 03             	and    $0x3,%eax
80106ade:	83 f8 03             	cmp    $0x3,%eax
80106ae1:	75 08                	jne    80106aeb <trap+0x27d>
    exit();
80106ae3:	e8 10 dc ff ff       	call   801046f8 <exit>
80106ae8:	eb 01                	jmp    80106aeb <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106aea:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106aeb:	83 c4 3c             	add    $0x3c,%esp
80106aee:	5b                   	pop    %ebx
80106aef:	5e                   	pop    %esi
80106af0:	5f                   	pop    %edi
80106af1:	5d                   	pop    %ebp
80106af2:	c3                   	ret    
	...

80106af4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106af4:	55                   	push   %ebp
80106af5:	89 e5                	mov    %esp,%ebp
80106af7:	83 ec 14             	sub    $0x14,%esp
80106afa:	8b 45 08             	mov    0x8(%ebp),%eax
80106afd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b01:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106b05:	89 c2                	mov    %eax,%edx
80106b07:	ec                   	in     (%dx),%al
80106b08:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106b0b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106b0f:	c9                   	leave  
80106b10:	c3                   	ret    

80106b11 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106b11:	55                   	push   %ebp
80106b12:	89 e5                	mov    %esp,%ebp
80106b14:	83 ec 08             	sub    $0x8,%esp
80106b17:	8b 55 08             	mov    0x8(%ebp),%edx
80106b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b1d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b21:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b24:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b28:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b2c:	ee                   	out    %al,(%dx)
}
80106b2d:	c9                   	leave  
80106b2e:	c3                   	ret    

80106b2f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b2f:	55                   	push   %ebp
80106b30:	89 e5                	mov    %esp,%ebp
80106b32:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b3c:	00 
80106b3d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b44:	e8 c8 ff ff ff       	call   80106b11 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b49:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106b50:	00 
80106b51:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b58:	e8 b4 ff ff ff       	call   80106b11 <outb>
  outb(COM1+0, 115200/9600);
80106b5d:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106b64:	00 
80106b65:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b6c:	e8 a0 ff ff ff       	call   80106b11 <outb>
  outb(COM1+1, 0);
80106b71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b78:	00 
80106b79:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b80:	e8 8c ff ff ff       	call   80106b11 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b85:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b8c:	00 
80106b8d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b94:	e8 78 ff ff ff       	call   80106b11 <outb>
  outb(COM1+4, 0);
80106b99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ba0:	00 
80106ba1:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106ba8:	e8 64 ff ff ff       	call   80106b11 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106bb4:	00 
80106bb5:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106bbc:	e8 50 ff ff ff       	call   80106b11 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106bc1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106bc8:	e8 27 ff ff ff       	call   80106af4 <inb>
80106bcd:	3c ff                	cmp    $0xff,%al
80106bcf:	74 6c                	je     80106c3d <uartinit+0x10e>
    return;
  uart = 1;
80106bd1:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106bd8:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106bdb:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106be2:	e8 0d ff ff ff       	call   80106af4 <inb>
  inb(COM1+0);
80106be7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106bee:	e8 01 ff ff ff       	call   80106af4 <inb>
  picenable(IRQ_COM1);
80106bf3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106bfa:	e8 b6 ce ff ff       	call   80103ab5 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106bff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c06:	00 
80106c07:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106c0e:	e8 93 bd ff ff       	call   801029a6 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c13:	c7 45 f4 98 8b 10 80 	movl   $0x80108b98,-0xc(%ebp)
80106c1a:	eb 15                	jmp    80106c31 <uartinit+0x102>
    uartputc(*p);
80106c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c1f:	0f b6 00             	movzbl (%eax),%eax
80106c22:	0f be c0             	movsbl %al,%eax
80106c25:	89 04 24             	mov    %eax,(%esp)
80106c28:	e8 13 00 00 00       	call   80106c40 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c34:	0f b6 00             	movzbl (%eax),%eax
80106c37:	84 c0                	test   %al,%al
80106c39:	75 e1                	jne    80106c1c <uartinit+0xed>
80106c3b:	eb 01                	jmp    80106c3e <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106c3d:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106c3e:	c9                   	leave  
80106c3f:	c3                   	ret    

80106c40 <uartputc>:

void
uartputc(int c)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106c46:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	74 4d                	je     80106c9c <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c56:	eb 10                	jmp    80106c68 <uartputc+0x28>
    microdelay(10);
80106c58:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106c5f:	e8 c9 c2 ff ff       	call   80102f2d <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c68:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c6c:	7f 16                	jg     80106c84 <uartputc+0x44>
80106c6e:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c75:	e8 7a fe ff ff       	call   80106af4 <inb>
80106c7a:	0f b6 c0             	movzbl %al,%eax
80106c7d:	83 e0 20             	and    $0x20,%eax
80106c80:	85 c0                	test   %eax,%eax
80106c82:	74 d4                	je     80106c58 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106c84:	8b 45 08             	mov    0x8(%ebp),%eax
80106c87:	0f b6 c0             	movzbl %al,%eax
80106c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c8e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c95:	e8 77 fe ff ff       	call   80106b11 <outb>
80106c9a:	eb 01                	jmp    80106c9d <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106c9c:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106c9d:	c9                   	leave  
80106c9e:	c3                   	ret    

80106c9f <uartgetc>:

static int
uartgetc(void)
{
80106c9f:	55                   	push   %ebp
80106ca0:	89 e5                	mov    %esp,%ebp
80106ca2:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ca5:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106caa:	85 c0                	test   %eax,%eax
80106cac:	75 07                	jne    80106cb5 <uartgetc+0x16>
    return -1;
80106cae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb3:	eb 2c                	jmp    80106ce1 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106cb5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cbc:	e8 33 fe ff ff       	call   80106af4 <inb>
80106cc1:	0f b6 c0             	movzbl %al,%eax
80106cc4:	83 e0 01             	and    $0x1,%eax
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	75 07                	jne    80106cd2 <uartgetc+0x33>
    return -1;
80106ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cd0:	eb 0f                	jmp    80106ce1 <uartgetc+0x42>
  return inb(COM1+0);
80106cd2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cd9:	e8 16 fe ff ff       	call   80106af4 <inb>
80106cde:	0f b6 c0             	movzbl %al,%eax
}
80106ce1:	c9                   	leave  
80106ce2:	c3                   	ret    

80106ce3 <uartintr>:

void
uartintr(void)
{
80106ce3:	55                   	push   %ebp
80106ce4:	89 e5                	mov    %esp,%ebp
80106ce6:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106ce9:	c7 04 24 9f 6c 10 80 	movl   $0x80106c9f,(%esp)
80106cf0:	e8 b6 9a ff ff       	call   801007ab <consoleintr>
}
80106cf5:	c9                   	leave  
80106cf6:	c3                   	ret    
	...

80106cf8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $0
80106cfa:	6a 00                	push   $0x0
  jmp alltraps
80106cfc:	e9 7b f9 ff ff       	jmp    8010667c <alltraps>

80106d01 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $1
80106d03:	6a 01                	push   $0x1
  jmp alltraps
80106d05:	e9 72 f9 ff ff       	jmp    8010667c <alltraps>

80106d0a <vector2>:
.globl vector2
vector2:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $2
80106d0c:	6a 02                	push   $0x2
  jmp alltraps
80106d0e:	e9 69 f9 ff ff       	jmp    8010667c <alltraps>

80106d13 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $3
80106d15:	6a 03                	push   $0x3
  jmp alltraps
80106d17:	e9 60 f9 ff ff       	jmp    8010667c <alltraps>

80106d1c <vector4>:
.globl vector4
vector4:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $4
80106d1e:	6a 04                	push   $0x4
  jmp alltraps
80106d20:	e9 57 f9 ff ff       	jmp    8010667c <alltraps>

80106d25 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $5
80106d27:	6a 05                	push   $0x5
  jmp alltraps
80106d29:	e9 4e f9 ff ff       	jmp    8010667c <alltraps>

80106d2e <vector6>:
.globl vector6
vector6:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $6
80106d30:	6a 06                	push   $0x6
  jmp alltraps
80106d32:	e9 45 f9 ff ff       	jmp    8010667c <alltraps>

80106d37 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $7
80106d39:	6a 07                	push   $0x7
  jmp alltraps
80106d3b:	e9 3c f9 ff ff       	jmp    8010667c <alltraps>

80106d40 <vector8>:
.globl vector8
vector8:
  pushl $8
80106d40:	6a 08                	push   $0x8
  jmp alltraps
80106d42:	e9 35 f9 ff ff       	jmp    8010667c <alltraps>

80106d47 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $9
80106d49:	6a 09                	push   $0x9
  jmp alltraps
80106d4b:	e9 2c f9 ff ff       	jmp    8010667c <alltraps>

80106d50 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d50:	6a 0a                	push   $0xa
  jmp alltraps
80106d52:	e9 25 f9 ff ff       	jmp    8010667c <alltraps>

80106d57 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d57:	6a 0b                	push   $0xb
  jmp alltraps
80106d59:	e9 1e f9 ff ff       	jmp    8010667c <alltraps>

80106d5e <vector12>:
.globl vector12
vector12:
  pushl $12
80106d5e:	6a 0c                	push   $0xc
  jmp alltraps
80106d60:	e9 17 f9 ff ff       	jmp    8010667c <alltraps>

80106d65 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d65:	6a 0d                	push   $0xd
  jmp alltraps
80106d67:	e9 10 f9 ff ff       	jmp    8010667c <alltraps>

80106d6c <vector14>:
.globl vector14
vector14:
  pushl $14
80106d6c:	6a 0e                	push   $0xe
  jmp alltraps
80106d6e:	e9 09 f9 ff ff       	jmp    8010667c <alltraps>

80106d73 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $15
80106d75:	6a 0f                	push   $0xf
  jmp alltraps
80106d77:	e9 00 f9 ff ff       	jmp    8010667c <alltraps>

80106d7c <vector16>:
.globl vector16
vector16:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $16
80106d7e:	6a 10                	push   $0x10
  jmp alltraps
80106d80:	e9 f7 f8 ff ff       	jmp    8010667c <alltraps>

80106d85 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d85:	6a 11                	push   $0x11
  jmp alltraps
80106d87:	e9 f0 f8 ff ff       	jmp    8010667c <alltraps>

80106d8c <vector18>:
.globl vector18
vector18:
  pushl $0
80106d8c:	6a 00                	push   $0x0
  pushl $18
80106d8e:	6a 12                	push   $0x12
  jmp alltraps
80106d90:	e9 e7 f8 ff ff       	jmp    8010667c <alltraps>

80106d95 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d95:	6a 00                	push   $0x0
  pushl $19
80106d97:	6a 13                	push   $0x13
  jmp alltraps
80106d99:	e9 de f8 ff ff       	jmp    8010667c <alltraps>

80106d9e <vector20>:
.globl vector20
vector20:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $20
80106da0:	6a 14                	push   $0x14
  jmp alltraps
80106da2:	e9 d5 f8 ff ff       	jmp    8010667c <alltraps>

80106da7 <vector21>:
.globl vector21
vector21:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $21
80106da9:	6a 15                	push   $0x15
  jmp alltraps
80106dab:	e9 cc f8 ff ff       	jmp    8010667c <alltraps>

80106db0 <vector22>:
.globl vector22
vector22:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $22
80106db2:	6a 16                	push   $0x16
  jmp alltraps
80106db4:	e9 c3 f8 ff ff       	jmp    8010667c <alltraps>

80106db9 <vector23>:
.globl vector23
vector23:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $23
80106dbb:	6a 17                	push   $0x17
  jmp alltraps
80106dbd:	e9 ba f8 ff ff       	jmp    8010667c <alltraps>

80106dc2 <vector24>:
.globl vector24
vector24:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $24
80106dc4:	6a 18                	push   $0x18
  jmp alltraps
80106dc6:	e9 b1 f8 ff ff       	jmp    8010667c <alltraps>

80106dcb <vector25>:
.globl vector25
vector25:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $25
80106dcd:	6a 19                	push   $0x19
  jmp alltraps
80106dcf:	e9 a8 f8 ff ff       	jmp    8010667c <alltraps>

80106dd4 <vector26>:
.globl vector26
vector26:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $26
80106dd6:	6a 1a                	push   $0x1a
  jmp alltraps
80106dd8:	e9 9f f8 ff ff       	jmp    8010667c <alltraps>

80106ddd <vector27>:
.globl vector27
vector27:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $27
80106ddf:	6a 1b                	push   $0x1b
  jmp alltraps
80106de1:	e9 96 f8 ff ff       	jmp    8010667c <alltraps>

80106de6 <vector28>:
.globl vector28
vector28:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $28
80106de8:	6a 1c                	push   $0x1c
  jmp alltraps
80106dea:	e9 8d f8 ff ff       	jmp    8010667c <alltraps>

80106def <vector29>:
.globl vector29
vector29:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $29
80106df1:	6a 1d                	push   $0x1d
  jmp alltraps
80106df3:	e9 84 f8 ff ff       	jmp    8010667c <alltraps>

80106df8 <vector30>:
.globl vector30
vector30:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $30
80106dfa:	6a 1e                	push   $0x1e
  jmp alltraps
80106dfc:	e9 7b f8 ff ff       	jmp    8010667c <alltraps>

80106e01 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $31
80106e03:	6a 1f                	push   $0x1f
  jmp alltraps
80106e05:	e9 72 f8 ff ff       	jmp    8010667c <alltraps>

80106e0a <vector32>:
.globl vector32
vector32:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $32
80106e0c:	6a 20                	push   $0x20
  jmp alltraps
80106e0e:	e9 69 f8 ff ff       	jmp    8010667c <alltraps>

80106e13 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $33
80106e15:	6a 21                	push   $0x21
  jmp alltraps
80106e17:	e9 60 f8 ff ff       	jmp    8010667c <alltraps>

80106e1c <vector34>:
.globl vector34
vector34:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $34
80106e1e:	6a 22                	push   $0x22
  jmp alltraps
80106e20:	e9 57 f8 ff ff       	jmp    8010667c <alltraps>

80106e25 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $35
80106e27:	6a 23                	push   $0x23
  jmp alltraps
80106e29:	e9 4e f8 ff ff       	jmp    8010667c <alltraps>

80106e2e <vector36>:
.globl vector36
vector36:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $36
80106e30:	6a 24                	push   $0x24
  jmp alltraps
80106e32:	e9 45 f8 ff ff       	jmp    8010667c <alltraps>

80106e37 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $37
80106e39:	6a 25                	push   $0x25
  jmp alltraps
80106e3b:	e9 3c f8 ff ff       	jmp    8010667c <alltraps>

80106e40 <vector38>:
.globl vector38
vector38:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $38
80106e42:	6a 26                	push   $0x26
  jmp alltraps
80106e44:	e9 33 f8 ff ff       	jmp    8010667c <alltraps>

80106e49 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $39
80106e4b:	6a 27                	push   $0x27
  jmp alltraps
80106e4d:	e9 2a f8 ff ff       	jmp    8010667c <alltraps>

80106e52 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $40
80106e54:	6a 28                	push   $0x28
  jmp alltraps
80106e56:	e9 21 f8 ff ff       	jmp    8010667c <alltraps>

80106e5b <vector41>:
.globl vector41
vector41:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $41
80106e5d:	6a 29                	push   $0x29
  jmp alltraps
80106e5f:	e9 18 f8 ff ff       	jmp    8010667c <alltraps>

80106e64 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $42
80106e66:	6a 2a                	push   $0x2a
  jmp alltraps
80106e68:	e9 0f f8 ff ff       	jmp    8010667c <alltraps>

80106e6d <vector43>:
.globl vector43
vector43:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $43
80106e6f:	6a 2b                	push   $0x2b
  jmp alltraps
80106e71:	e9 06 f8 ff ff       	jmp    8010667c <alltraps>

80106e76 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $44
80106e78:	6a 2c                	push   $0x2c
  jmp alltraps
80106e7a:	e9 fd f7 ff ff       	jmp    8010667c <alltraps>

80106e7f <vector45>:
.globl vector45
vector45:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $45
80106e81:	6a 2d                	push   $0x2d
  jmp alltraps
80106e83:	e9 f4 f7 ff ff       	jmp    8010667c <alltraps>

80106e88 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $46
80106e8a:	6a 2e                	push   $0x2e
  jmp alltraps
80106e8c:	e9 eb f7 ff ff       	jmp    8010667c <alltraps>

80106e91 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $47
80106e93:	6a 2f                	push   $0x2f
  jmp alltraps
80106e95:	e9 e2 f7 ff ff       	jmp    8010667c <alltraps>

80106e9a <vector48>:
.globl vector48
vector48:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $48
80106e9c:	6a 30                	push   $0x30
  jmp alltraps
80106e9e:	e9 d9 f7 ff ff       	jmp    8010667c <alltraps>

80106ea3 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $49
80106ea5:	6a 31                	push   $0x31
  jmp alltraps
80106ea7:	e9 d0 f7 ff ff       	jmp    8010667c <alltraps>

80106eac <vector50>:
.globl vector50
vector50:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $50
80106eae:	6a 32                	push   $0x32
  jmp alltraps
80106eb0:	e9 c7 f7 ff ff       	jmp    8010667c <alltraps>

80106eb5 <vector51>:
.globl vector51
vector51:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $51
80106eb7:	6a 33                	push   $0x33
  jmp alltraps
80106eb9:	e9 be f7 ff ff       	jmp    8010667c <alltraps>

80106ebe <vector52>:
.globl vector52
vector52:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $52
80106ec0:	6a 34                	push   $0x34
  jmp alltraps
80106ec2:	e9 b5 f7 ff ff       	jmp    8010667c <alltraps>

80106ec7 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $53
80106ec9:	6a 35                	push   $0x35
  jmp alltraps
80106ecb:	e9 ac f7 ff ff       	jmp    8010667c <alltraps>

80106ed0 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $54
80106ed2:	6a 36                	push   $0x36
  jmp alltraps
80106ed4:	e9 a3 f7 ff ff       	jmp    8010667c <alltraps>

80106ed9 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $55
80106edb:	6a 37                	push   $0x37
  jmp alltraps
80106edd:	e9 9a f7 ff ff       	jmp    8010667c <alltraps>

80106ee2 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $56
80106ee4:	6a 38                	push   $0x38
  jmp alltraps
80106ee6:	e9 91 f7 ff ff       	jmp    8010667c <alltraps>

80106eeb <vector57>:
.globl vector57
vector57:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $57
80106eed:	6a 39                	push   $0x39
  jmp alltraps
80106eef:	e9 88 f7 ff ff       	jmp    8010667c <alltraps>

80106ef4 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $58
80106ef6:	6a 3a                	push   $0x3a
  jmp alltraps
80106ef8:	e9 7f f7 ff ff       	jmp    8010667c <alltraps>

80106efd <vector59>:
.globl vector59
vector59:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $59
80106eff:	6a 3b                	push   $0x3b
  jmp alltraps
80106f01:	e9 76 f7 ff ff       	jmp    8010667c <alltraps>

80106f06 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $60
80106f08:	6a 3c                	push   $0x3c
  jmp alltraps
80106f0a:	e9 6d f7 ff ff       	jmp    8010667c <alltraps>

80106f0f <vector61>:
.globl vector61
vector61:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $61
80106f11:	6a 3d                	push   $0x3d
  jmp alltraps
80106f13:	e9 64 f7 ff ff       	jmp    8010667c <alltraps>

80106f18 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $62
80106f1a:	6a 3e                	push   $0x3e
  jmp alltraps
80106f1c:	e9 5b f7 ff ff       	jmp    8010667c <alltraps>

80106f21 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $63
80106f23:	6a 3f                	push   $0x3f
  jmp alltraps
80106f25:	e9 52 f7 ff ff       	jmp    8010667c <alltraps>

80106f2a <vector64>:
.globl vector64
vector64:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $64
80106f2c:	6a 40                	push   $0x40
  jmp alltraps
80106f2e:	e9 49 f7 ff ff       	jmp    8010667c <alltraps>

80106f33 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $65
80106f35:	6a 41                	push   $0x41
  jmp alltraps
80106f37:	e9 40 f7 ff ff       	jmp    8010667c <alltraps>

80106f3c <vector66>:
.globl vector66
vector66:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $66
80106f3e:	6a 42                	push   $0x42
  jmp alltraps
80106f40:	e9 37 f7 ff ff       	jmp    8010667c <alltraps>

80106f45 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $67
80106f47:	6a 43                	push   $0x43
  jmp alltraps
80106f49:	e9 2e f7 ff ff       	jmp    8010667c <alltraps>

80106f4e <vector68>:
.globl vector68
vector68:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $68
80106f50:	6a 44                	push   $0x44
  jmp alltraps
80106f52:	e9 25 f7 ff ff       	jmp    8010667c <alltraps>

80106f57 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $69
80106f59:	6a 45                	push   $0x45
  jmp alltraps
80106f5b:	e9 1c f7 ff ff       	jmp    8010667c <alltraps>

80106f60 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $70
80106f62:	6a 46                	push   $0x46
  jmp alltraps
80106f64:	e9 13 f7 ff ff       	jmp    8010667c <alltraps>

80106f69 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $71
80106f6b:	6a 47                	push   $0x47
  jmp alltraps
80106f6d:	e9 0a f7 ff ff       	jmp    8010667c <alltraps>

80106f72 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $72
80106f74:	6a 48                	push   $0x48
  jmp alltraps
80106f76:	e9 01 f7 ff ff       	jmp    8010667c <alltraps>

80106f7b <vector73>:
.globl vector73
vector73:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $73
80106f7d:	6a 49                	push   $0x49
  jmp alltraps
80106f7f:	e9 f8 f6 ff ff       	jmp    8010667c <alltraps>

80106f84 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $74
80106f86:	6a 4a                	push   $0x4a
  jmp alltraps
80106f88:	e9 ef f6 ff ff       	jmp    8010667c <alltraps>

80106f8d <vector75>:
.globl vector75
vector75:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $75
80106f8f:	6a 4b                	push   $0x4b
  jmp alltraps
80106f91:	e9 e6 f6 ff ff       	jmp    8010667c <alltraps>

80106f96 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $76
80106f98:	6a 4c                	push   $0x4c
  jmp alltraps
80106f9a:	e9 dd f6 ff ff       	jmp    8010667c <alltraps>

80106f9f <vector77>:
.globl vector77
vector77:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $77
80106fa1:	6a 4d                	push   $0x4d
  jmp alltraps
80106fa3:	e9 d4 f6 ff ff       	jmp    8010667c <alltraps>

80106fa8 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $78
80106faa:	6a 4e                	push   $0x4e
  jmp alltraps
80106fac:	e9 cb f6 ff ff       	jmp    8010667c <alltraps>

80106fb1 <vector79>:
.globl vector79
vector79:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $79
80106fb3:	6a 4f                	push   $0x4f
  jmp alltraps
80106fb5:	e9 c2 f6 ff ff       	jmp    8010667c <alltraps>

80106fba <vector80>:
.globl vector80
vector80:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $80
80106fbc:	6a 50                	push   $0x50
  jmp alltraps
80106fbe:	e9 b9 f6 ff ff       	jmp    8010667c <alltraps>

80106fc3 <vector81>:
.globl vector81
vector81:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $81
80106fc5:	6a 51                	push   $0x51
  jmp alltraps
80106fc7:	e9 b0 f6 ff ff       	jmp    8010667c <alltraps>

80106fcc <vector82>:
.globl vector82
vector82:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $82
80106fce:	6a 52                	push   $0x52
  jmp alltraps
80106fd0:	e9 a7 f6 ff ff       	jmp    8010667c <alltraps>

80106fd5 <vector83>:
.globl vector83
vector83:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $83
80106fd7:	6a 53                	push   $0x53
  jmp alltraps
80106fd9:	e9 9e f6 ff ff       	jmp    8010667c <alltraps>

80106fde <vector84>:
.globl vector84
vector84:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $84
80106fe0:	6a 54                	push   $0x54
  jmp alltraps
80106fe2:	e9 95 f6 ff ff       	jmp    8010667c <alltraps>

80106fe7 <vector85>:
.globl vector85
vector85:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $85
80106fe9:	6a 55                	push   $0x55
  jmp alltraps
80106feb:	e9 8c f6 ff ff       	jmp    8010667c <alltraps>

80106ff0 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $86
80106ff2:	6a 56                	push   $0x56
  jmp alltraps
80106ff4:	e9 83 f6 ff ff       	jmp    8010667c <alltraps>

80106ff9 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $87
80106ffb:	6a 57                	push   $0x57
  jmp alltraps
80106ffd:	e9 7a f6 ff ff       	jmp    8010667c <alltraps>

80107002 <vector88>:
.globl vector88
vector88:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $88
80107004:	6a 58                	push   $0x58
  jmp alltraps
80107006:	e9 71 f6 ff ff       	jmp    8010667c <alltraps>

8010700b <vector89>:
.globl vector89
vector89:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $89
8010700d:	6a 59                	push   $0x59
  jmp alltraps
8010700f:	e9 68 f6 ff ff       	jmp    8010667c <alltraps>

80107014 <vector90>:
.globl vector90
vector90:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $90
80107016:	6a 5a                	push   $0x5a
  jmp alltraps
80107018:	e9 5f f6 ff ff       	jmp    8010667c <alltraps>

8010701d <vector91>:
.globl vector91
vector91:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $91
8010701f:	6a 5b                	push   $0x5b
  jmp alltraps
80107021:	e9 56 f6 ff ff       	jmp    8010667c <alltraps>

80107026 <vector92>:
.globl vector92
vector92:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $92
80107028:	6a 5c                	push   $0x5c
  jmp alltraps
8010702a:	e9 4d f6 ff ff       	jmp    8010667c <alltraps>

8010702f <vector93>:
.globl vector93
vector93:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $93
80107031:	6a 5d                	push   $0x5d
  jmp alltraps
80107033:	e9 44 f6 ff ff       	jmp    8010667c <alltraps>

80107038 <vector94>:
.globl vector94
vector94:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $94
8010703a:	6a 5e                	push   $0x5e
  jmp alltraps
8010703c:	e9 3b f6 ff ff       	jmp    8010667c <alltraps>

80107041 <vector95>:
.globl vector95
vector95:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $95
80107043:	6a 5f                	push   $0x5f
  jmp alltraps
80107045:	e9 32 f6 ff ff       	jmp    8010667c <alltraps>

8010704a <vector96>:
.globl vector96
vector96:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $96
8010704c:	6a 60                	push   $0x60
  jmp alltraps
8010704e:	e9 29 f6 ff ff       	jmp    8010667c <alltraps>

80107053 <vector97>:
.globl vector97
vector97:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $97
80107055:	6a 61                	push   $0x61
  jmp alltraps
80107057:	e9 20 f6 ff ff       	jmp    8010667c <alltraps>

8010705c <vector98>:
.globl vector98
vector98:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $98
8010705e:	6a 62                	push   $0x62
  jmp alltraps
80107060:	e9 17 f6 ff ff       	jmp    8010667c <alltraps>

80107065 <vector99>:
.globl vector99
vector99:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $99
80107067:	6a 63                	push   $0x63
  jmp alltraps
80107069:	e9 0e f6 ff ff       	jmp    8010667c <alltraps>

8010706e <vector100>:
.globl vector100
vector100:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $100
80107070:	6a 64                	push   $0x64
  jmp alltraps
80107072:	e9 05 f6 ff ff       	jmp    8010667c <alltraps>

80107077 <vector101>:
.globl vector101
vector101:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $101
80107079:	6a 65                	push   $0x65
  jmp alltraps
8010707b:	e9 fc f5 ff ff       	jmp    8010667c <alltraps>

80107080 <vector102>:
.globl vector102
vector102:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $102
80107082:	6a 66                	push   $0x66
  jmp alltraps
80107084:	e9 f3 f5 ff ff       	jmp    8010667c <alltraps>

80107089 <vector103>:
.globl vector103
vector103:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $103
8010708b:	6a 67                	push   $0x67
  jmp alltraps
8010708d:	e9 ea f5 ff ff       	jmp    8010667c <alltraps>

80107092 <vector104>:
.globl vector104
vector104:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $104
80107094:	6a 68                	push   $0x68
  jmp alltraps
80107096:	e9 e1 f5 ff ff       	jmp    8010667c <alltraps>

8010709b <vector105>:
.globl vector105
vector105:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $105
8010709d:	6a 69                	push   $0x69
  jmp alltraps
8010709f:	e9 d8 f5 ff ff       	jmp    8010667c <alltraps>

801070a4 <vector106>:
.globl vector106
vector106:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $106
801070a6:	6a 6a                	push   $0x6a
  jmp alltraps
801070a8:	e9 cf f5 ff ff       	jmp    8010667c <alltraps>

801070ad <vector107>:
.globl vector107
vector107:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $107
801070af:	6a 6b                	push   $0x6b
  jmp alltraps
801070b1:	e9 c6 f5 ff ff       	jmp    8010667c <alltraps>

801070b6 <vector108>:
.globl vector108
vector108:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $108
801070b8:	6a 6c                	push   $0x6c
  jmp alltraps
801070ba:	e9 bd f5 ff ff       	jmp    8010667c <alltraps>

801070bf <vector109>:
.globl vector109
vector109:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $109
801070c1:	6a 6d                	push   $0x6d
  jmp alltraps
801070c3:	e9 b4 f5 ff ff       	jmp    8010667c <alltraps>

801070c8 <vector110>:
.globl vector110
vector110:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $110
801070ca:	6a 6e                	push   $0x6e
  jmp alltraps
801070cc:	e9 ab f5 ff ff       	jmp    8010667c <alltraps>

801070d1 <vector111>:
.globl vector111
vector111:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $111
801070d3:	6a 6f                	push   $0x6f
  jmp alltraps
801070d5:	e9 a2 f5 ff ff       	jmp    8010667c <alltraps>

801070da <vector112>:
.globl vector112
vector112:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $112
801070dc:	6a 70                	push   $0x70
  jmp alltraps
801070de:	e9 99 f5 ff ff       	jmp    8010667c <alltraps>

801070e3 <vector113>:
.globl vector113
vector113:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $113
801070e5:	6a 71                	push   $0x71
  jmp alltraps
801070e7:	e9 90 f5 ff ff       	jmp    8010667c <alltraps>

801070ec <vector114>:
.globl vector114
vector114:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $114
801070ee:	6a 72                	push   $0x72
  jmp alltraps
801070f0:	e9 87 f5 ff ff       	jmp    8010667c <alltraps>

801070f5 <vector115>:
.globl vector115
vector115:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $115
801070f7:	6a 73                	push   $0x73
  jmp alltraps
801070f9:	e9 7e f5 ff ff       	jmp    8010667c <alltraps>

801070fe <vector116>:
.globl vector116
vector116:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $116
80107100:	6a 74                	push   $0x74
  jmp alltraps
80107102:	e9 75 f5 ff ff       	jmp    8010667c <alltraps>

80107107 <vector117>:
.globl vector117
vector117:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $117
80107109:	6a 75                	push   $0x75
  jmp alltraps
8010710b:	e9 6c f5 ff ff       	jmp    8010667c <alltraps>

80107110 <vector118>:
.globl vector118
vector118:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $118
80107112:	6a 76                	push   $0x76
  jmp alltraps
80107114:	e9 63 f5 ff ff       	jmp    8010667c <alltraps>

80107119 <vector119>:
.globl vector119
vector119:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $119
8010711b:	6a 77                	push   $0x77
  jmp alltraps
8010711d:	e9 5a f5 ff ff       	jmp    8010667c <alltraps>

80107122 <vector120>:
.globl vector120
vector120:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $120
80107124:	6a 78                	push   $0x78
  jmp alltraps
80107126:	e9 51 f5 ff ff       	jmp    8010667c <alltraps>

8010712b <vector121>:
.globl vector121
vector121:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $121
8010712d:	6a 79                	push   $0x79
  jmp alltraps
8010712f:	e9 48 f5 ff ff       	jmp    8010667c <alltraps>

80107134 <vector122>:
.globl vector122
vector122:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $122
80107136:	6a 7a                	push   $0x7a
  jmp alltraps
80107138:	e9 3f f5 ff ff       	jmp    8010667c <alltraps>

8010713d <vector123>:
.globl vector123
vector123:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $123
8010713f:	6a 7b                	push   $0x7b
  jmp alltraps
80107141:	e9 36 f5 ff ff       	jmp    8010667c <alltraps>

80107146 <vector124>:
.globl vector124
vector124:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $124
80107148:	6a 7c                	push   $0x7c
  jmp alltraps
8010714a:	e9 2d f5 ff ff       	jmp    8010667c <alltraps>

8010714f <vector125>:
.globl vector125
vector125:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $125
80107151:	6a 7d                	push   $0x7d
  jmp alltraps
80107153:	e9 24 f5 ff ff       	jmp    8010667c <alltraps>

80107158 <vector126>:
.globl vector126
vector126:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $126
8010715a:	6a 7e                	push   $0x7e
  jmp alltraps
8010715c:	e9 1b f5 ff ff       	jmp    8010667c <alltraps>

80107161 <vector127>:
.globl vector127
vector127:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $127
80107163:	6a 7f                	push   $0x7f
  jmp alltraps
80107165:	e9 12 f5 ff ff       	jmp    8010667c <alltraps>

8010716a <vector128>:
.globl vector128
vector128:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $128
8010716c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107171:	e9 06 f5 ff ff       	jmp    8010667c <alltraps>

80107176 <vector129>:
.globl vector129
vector129:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $129
80107178:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010717d:	e9 fa f4 ff ff       	jmp    8010667c <alltraps>

80107182 <vector130>:
.globl vector130
vector130:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $130
80107184:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107189:	e9 ee f4 ff ff       	jmp    8010667c <alltraps>

8010718e <vector131>:
.globl vector131
vector131:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $131
80107190:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107195:	e9 e2 f4 ff ff       	jmp    8010667c <alltraps>

8010719a <vector132>:
.globl vector132
vector132:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $132
8010719c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071a1:	e9 d6 f4 ff ff       	jmp    8010667c <alltraps>

801071a6 <vector133>:
.globl vector133
vector133:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $133
801071a8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071ad:	e9 ca f4 ff ff       	jmp    8010667c <alltraps>

801071b2 <vector134>:
.globl vector134
vector134:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $134
801071b4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071b9:	e9 be f4 ff ff       	jmp    8010667c <alltraps>

801071be <vector135>:
.globl vector135
vector135:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $135
801071c0:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071c5:	e9 b2 f4 ff ff       	jmp    8010667c <alltraps>

801071ca <vector136>:
.globl vector136
vector136:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $136
801071cc:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071d1:	e9 a6 f4 ff ff       	jmp    8010667c <alltraps>

801071d6 <vector137>:
.globl vector137
vector137:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $137
801071d8:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071dd:	e9 9a f4 ff ff       	jmp    8010667c <alltraps>

801071e2 <vector138>:
.globl vector138
vector138:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $138
801071e4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071e9:	e9 8e f4 ff ff       	jmp    8010667c <alltraps>

801071ee <vector139>:
.globl vector139
vector139:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $139
801071f0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071f5:	e9 82 f4 ff ff       	jmp    8010667c <alltraps>

801071fa <vector140>:
.globl vector140
vector140:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $140
801071fc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107201:	e9 76 f4 ff ff       	jmp    8010667c <alltraps>

80107206 <vector141>:
.globl vector141
vector141:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $141
80107208:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010720d:	e9 6a f4 ff ff       	jmp    8010667c <alltraps>

80107212 <vector142>:
.globl vector142
vector142:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $142
80107214:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107219:	e9 5e f4 ff ff       	jmp    8010667c <alltraps>

8010721e <vector143>:
.globl vector143
vector143:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $143
80107220:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107225:	e9 52 f4 ff ff       	jmp    8010667c <alltraps>

8010722a <vector144>:
.globl vector144
vector144:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $144
8010722c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107231:	e9 46 f4 ff ff       	jmp    8010667c <alltraps>

80107236 <vector145>:
.globl vector145
vector145:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $145
80107238:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010723d:	e9 3a f4 ff ff       	jmp    8010667c <alltraps>

80107242 <vector146>:
.globl vector146
vector146:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $146
80107244:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107249:	e9 2e f4 ff ff       	jmp    8010667c <alltraps>

8010724e <vector147>:
.globl vector147
vector147:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $147
80107250:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107255:	e9 22 f4 ff ff       	jmp    8010667c <alltraps>

8010725a <vector148>:
.globl vector148
vector148:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $148
8010725c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107261:	e9 16 f4 ff ff       	jmp    8010667c <alltraps>

80107266 <vector149>:
.globl vector149
vector149:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $149
80107268:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010726d:	e9 0a f4 ff ff       	jmp    8010667c <alltraps>

80107272 <vector150>:
.globl vector150
vector150:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $150
80107274:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107279:	e9 fe f3 ff ff       	jmp    8010667c <alltraps>

8010727e <vector151>:
.globl vector151
vector151:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $151
80107280:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107285:	e9 f2 f3 ff ff       	jmp    8010667c <alltraps>

8010728a <vector152>:
.globl vector152
vector152:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $152
8010728c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107291:	e9 e6 f3 ff ff       	jmp    8010667c <alltraps>

80107296 <vector153>:
.globl vector153
vector153:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $153
80107298:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010729d:	e9 da f3 ff ff       	jmp    8010667c <alltraps>

801072a2 <vector154>:
.globl vector154
vector154:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $154
801072a4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072a9:	e9 ce f3 ff ff       	jmp    8010667c <alltraps>

801072ae <vector155>:
.globl vector155
vector155:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $155
801072b0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072b5:	e9 c2 f3 ff ff       	jmp    8010667c <alltraps>

801072ba <vector156>:
.globl vector156
vector156:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $156
801072bc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072c1:	e9 b6 f3 ff ff       	jmp    8010667c <alltraps>

801072c6 <vector157>:
.globl vector157
vector157:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $157
801072c8:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072cd:	e9 aa f3 ff ff       	jmp    8010667c <alltraps>

801072d2 <vector158>:
.globl vector158
vector158:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $158
801072d4:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072d9:	e9 9e f3 ff ff       	jmp    8010667c <alltraps>

801072de <vector159>:
.globl vector159
vector159:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $159
801072e0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072e5:	e9 92 f3 ff ff       	jmp    8010667c <alltraps>

801072ea <vector160>:
.globl vector160
vector160:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $160
801072ec:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801072f1:	e9 86 f3 ff ff       	jmp    8010667c <alltraps>

801072f6 <vector161>:
.globl vector161
vector161:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $161
801072f8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072fd:	e9 7a f3 ff ff       	jmp    8010667c <alltraps>

80107302 <vector162>:
.globl vector162
vector162:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $162
80107304:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107309:	e9 6e f3 ff ff       	jmp    8010667c <alltraps>

8010730e <vector163>:
.globl vector163
vector163:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $163
80107310:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107315:	e9 62 f3 ff ff       	jmp    8010667c <alltraps>

8010731a <vector164>:
.globl vector164
vector164:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $164
8010731c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107321:	e9 56 f3 ff ff       	jmp    8010667c <alltraps>

80107326 <vector165>:
.globl vector165
vector165:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $165
80107328:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010732d:	e9 4a f3 ff ff       	jmp    8010667c <alltraps>

80107332 <vector166>:
.globl vector166
vector166:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $166
80107334:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107339:	e9 3e f3 ff ff       	jmp    8010667c <alltraps>

8010733e <vector167>:
.globl vector167
vector167:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $167
80107340:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107345:	e9 32 f3 ff ff       	jmp    8010667c <alltraps>

8010734a <vector168>:
.globl vector168
vector168:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $168
8010734c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107351:	e9 26 f3 ff ff       	jmp    8010667c <alltraps>

80107356 <vector169>:
.globl vector169
vector169:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $169
80107358:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010735d:	e9 1a f3 ff ff       	jmp    8010667c <alltraps>

80107362 <vector170>:
.globl vector170
vector170:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $170
80107364:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107369:	e9 0e f3 ff ff       	jmp    8010667c <alltraps>

8010736e <vector171>:
.globl vector171
vector171:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $171
80107370:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107375:	e9 02 f3 ff ff       	jmp    8010667c <alltraps>

8010737a <vector172>:
.globl vector172
vector172:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $172
8010737c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107381:	e9 f6 f2 ff ff       	jmp    8010667c <alltraps>

80107386 <vector173>:
.globl vector173
vector173:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $173
80107388:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010738d:	e9 ea f2 ff ff       	jmp    8010667c <alltraps>

80107392 <vector174>:
.globl vector174
vector174:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $174
80107394:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107399:	e9 de f2 ff ff       	jmp    8010667c <alltraps>

8010739e <vector175>:
.globl vector175
vector175:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $175
801073a0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073a5:	e9 d2 f2 ff ff       	jmp    8010667c <alltraps>

801073aa <vector176>:
.globl vector176
vector176:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $176
801073ac:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073b1:	e9 c6 f2 ff ff       	jmp    8010667c <alltraps>

801073b6 <vector177>:
.globl vector177
vector177:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $177
801073b8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073bd:	e9 ba f2 ff ff       	jmp    8010667c <alltraps>

801073c2 <vector178>:
.globl vector178
vector178:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $178
801073c4:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073c9:	e9 ae f2 ff ff       	jmp    8010667c <alltraps>

801073ce <vector179>:
.globl vector179
vector179:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $179
801073d0:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073d5:	e9 a2 f2 ff ff       	jmp    8010667c <alltraps>

801073da <vector180>:
.globl vector180
vector180:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $180
801073dc:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073e1:	e9 96 f2 ff ff       	jmp    8010667c <alltraps>

801073e6 <vector181>:
.globl vector181
vector181:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $181
801073e8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073ed:	e9 8a f2 ff ff       	jmp    8010667c <alltraps>

801073f2 <vector182>:
.globl vector182
vector182:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $182
801073f4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073f9:	e9 7e f2 ff ff       	jmp    8010667c <alltraps>

801073fe <vector183>:
.globl vector183
vector183:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $183
80107400:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107405:	e9 72 f2 ff ff       	jmp    8010667c <alltraps>

8010740a <vector184>:
.globl vector184
vector184:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $184
8010740c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107411:	e9 66 f2 ff ff       	jmp    8010667c <alltraps>

80107416 <vector185>:
.globl vector185
vector185:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $185
80107418:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010741d:	e9 5a f2 ff ff       	jmp    8010667c <alltraps>

80107422 <vector186>:
.globl vector186
vector186:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $186
80107424:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107429:	e9 4e f2 ff ff       	jmp    8010667c <alltraps>

8010742e <vector187>:
.globl vector187
vector187:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $187
80107430:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107435:	e9 42 f2 ff ff       	jmp    8010667c <alltraps>

8010743a <vector188>:
.globl vector188
vector188:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $188
8010743c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107441:	e9 36 f2 ff ff       	jmp    8010667c <alltraps>

80107446 <vector189>:
.globl vector189
vector189:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $189
80107448:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010744d:	e9 2a f2 ff ff       	jmp    8010667c <alltraps>

80107452 <vector190>:
.globl vector190
vector190:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $190
80107454:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107459:	e9 1e f2 ff ff       	jmp    8010667c <alltraps>

8010745e <vector191>:
.globl vector191
vector191:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $191
80107460:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107465:	e9 12 f2 ff ff       	jmp    8010667c <alltraps>

8010746a <vector192>:
.globl vector192
vector192:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $192
8010746c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107471:	e9 06 f2 ff ff       	jmp    8010667c <alltraps>

80107476 <vector193>:
.globl vector193
vector193:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $193
80107478:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010747d:	e9 fa f1 ff ff       	jmp    8010667c <alltraps>

80107482 <vector194>:
.globl vector194
vector194:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $194
80107484:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107489:	e9 ee f1 ff ff       	jmp    8010667c <alltraps>

8010748e <vector195>:
.globl vector195
vector195:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $195
80107490:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107495:	e9 e2 f1 ff ff       	jmp    8010667c <alltraps>

8010749a <vector196>:
.globl vector196
vector196:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $196
8010749c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074a1:	e9 d6 f1 ff ff       	jmp    8010667c <alltraps>

801074a6 <vector197>:
.globl vector197
vector197:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $197
801074a8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074ad:	e9 ca f1 ff ff       	jmp    8010667c <alltraps>

801074b2 <vector198>:
.globl vector198
vector198:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $198
801074b4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074b9:	e9 be f1 ff ff       	jmp    8010667c <alltraps>

801074be <vector199>:
.globl vector199
vector199:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $199
801074c0:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074c5:	e9 b2 f1 ff ff       	jmp    8010667c <alltraps>

801074ca <vector200>:
.globl vector200
vector200:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $200
801074cc:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074d1:	e9 a6 f1 ff ff       	jmp    8010667c <alltraps>

801074d6 <vector201>:
.globl vector201
vector201:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $201
801074d8:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074dd:	e9 9a f1 ff ff       	jmp    8010667c <alltraps>

801074e2 <vector202>:
.globl vector202
vector202:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $202
801074e4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074e9:	e9 8e f1 ff ff       	jmp    8010667c <alltraps>

801074ee <vector203>:
.globl vector203
vector203:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $203
801074f0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074f5:	e9 82 f1 ff ff       	jmp    8010667c <alltraps>

801074fa <vector204>:
.globl vector204
vector204:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $204
801074fc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107501:	e9 76 f1 ff ff       	jmp    8010667c <alltraps>

80107506 <vector205>:
.globl vector205
vector205:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $205
80107508:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010750d:	e9 6a f1 ff ff       	jmp    8010667c <alltraps>

80107512 <vector206>:
.globl vector206
vector206:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $206
80107514:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107519:	e9 5e f1 ff ff       	jmp    8010667c <alltraps>

8010751e <vector207>:
.globl vector207
vector207:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $207
80107520:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107525:	e9 52 f1 ff ff       	jmp    8010667c <alltraps>

8010752a <vector208>:
.globl vector208
vector208:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $208
8010752c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107531:	e9 46 f1 ff ff       	jmp    8010667c <alltraps>

80107536 <vector209>:
.globl vector209
vector209:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $209
80107538:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010753d:	e9 3a f1 ff ff       	jmp    8010667c <alltraps>

80107542 <vector210>:
.globl vector210
vector210:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $210
80107544:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107549:	e9 2e f1 ff ff       	jmp    8010667c <alltraps>

8010754e <vector211>:
.globl vector211
vector211:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $211
80107550:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107555:	e9 22 f1 ff ff       	jmp    8010667c <alltraps>

8010755a <vector212>:
.globl vector212
vector212:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $212
8010755c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107561:	e9 16 f1 ff ff       	jmp    8010667c <alltraps>

80107566 <vector213>:
.globl vector213
vector213:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $213
80107568:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010756d:	e9 0a f1 ff ff       	jmp    8010667c <alltraps>

80107572 <vector214>:
.globl vector214
vector214:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $214
80107574:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107579:	e9 fe f0 ff ff       	jmp    8010667c <alltraps>

8010757e <vector215>:
.globl vector215
vector215:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $215
80107580:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107585:	e9 f2 f0 ff ff       	jmp    8010667c <alltraps>

8010758a <vector216>:
.globl vector216
vector216:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $216
8010758c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107591:	e9 e6 f0 ff ff       	jmp    8010667c <alltraps>

80107596 <vector217>:
.globl vector217
vector217:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $217
80107598:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010759d:	e9 da f0 ff ff       	jmp    8010667c <alltraps>

801075a2 <vector218>:
.globl vector218
vector218:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $218
801075a4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075a9:	e9 ce f0 ff ff       	jmp    8010667c <alltraps>

801075ae <vector219>:
.globl vector219
vector219:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $219
801075b0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075b5:	e9 c2 f0 ff ff       	jmp    8010667c <alltraps>

801075ba <vector220>:
.globl vector220
vector220:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $220
801075bc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075c1:	e9 b6 f0 ff ff       	jmp    8010667c <alltraps>

801075c6 <vector221>:
.globl vector221
vector221:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $221
801075c8:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075cd:	e9 aa f0 ff ff       	jmp    8010667c <alltraps>

801075d2 <vector222>:
.globl vector222
vector222:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $222
801075d4:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075d9:	e9 9e f0 ff ff       	jmp    8010667c <alltraps>

801075de <vector223>:
.globl vector223
vector223:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $223
801075e0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075e5:	e9 92 f0 ff ff       	jmp    8010667c <alltraps>

801075ea <vector224>:
.globl vector224
vector224:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $224
801075ec:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801075f1:	e9 86 f0 ff ff       	jmp    8010667c <alltraps>

801075f6 <vector225>:
.globl vector225
vector225:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $225
801075f8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075fd:	e9 7a f0 ff ff       	jmp    8010667c <alltraps>

80107602 <vector226>:
.globl vector226
vector226:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $226
80107604:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107609:	e9 6e f0 ff ff       	jmp    8010667c <alltraps>

8010760e <vector227>:
.globl vector227
vector227:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $227
80107610:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107615:	e9 62 f0 ff ff       	jmp    8010667c <alltraps>

8010761a <vector228>:
.globl vector228
vector228:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $228
8010761c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107621:	e9 56 f0 ff ff       	jmp    8010667c <alltraps>

80107626 <vector229>:
.globl vector229
vector229:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $229
80107628:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010762d:	e9 4a f0 ff ff       	jmp    8010667c <alltraps>

80107632 <vector230>:
.globl vector230
vector230:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $230
80107634:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107639:	e9 3e f0 ff ff       	jmp    8010667c <alltraps>

8010763e <vector231>:
.globl vector231
vector231:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $231
80107640:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107645:	e9 32 f0 ff ff       	jmp    8010667c <alltraps>

8010764a <vector232>:
.globl vector232
vector232:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $232
8010764c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107651:	e9 26 f0 ff ff       	jmp    8010667c <alltraps>

80107656 <vector233>:
.globl vector233
vector233:
  pushl $0
80107656:	6a 00                	push   $0x0
  pushl $233
80107658:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010765d:	e9 1a f0 ff ff       	jmp    8010667c <alltraps>

80107662 <vector234>:
.globl vector234
vector234:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $234
80107664:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107669:	e9 0e f0 ff ff       	jmp    8010667c <alltraps>

8010766e <vector235>:
.globl vector235
vector235:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $235
80107670:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107675:	e9 02 f0 ff ff       	jmp    8010667c <alltraps>

8010767a <vector236>:
.globl vector236
vector236:
  pushl $0
8010767a:	6a 00                	push   $0x0
  pushl $236
8010767c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107681:	e9 f6 ef ff ff       	jmp    8010667c <alltraps>

80107686 <vector237>:
.globl vector237
vector237:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $237
80107688:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010768d:	e9 ea ef ff ff       	jmp    8010667c <alltraps>

80107692 <vector238>:
.globl vector238
vector238:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $238
80107694:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107699:	e9 de ef ff ff       	jmp    8010667c <alltraps>

8010769e <vector239>:
.globl vector239
vector239:
  pushl $0
8010769e:	6a 00                	push   $0x0
  pushl $239
801076a0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076a5:	e9 d2 ef ff ff       	jmp    8010667c <alltraps>

801076aa <vector240>:
.globl vector240
vector240:
  pushl $0
801076aa:	6a 00                	push   $0x0
  pushl $240
801076ac:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076b1:	e9 c6 ef ff ff       	jmp    8010667c <alltraps>

801076b6 <vector241>:
.globl vector241
vector241:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $241
801076b8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076bd:	e9 ba ef ff ff       	jmp    8010667c <alltraps>

801076c2 <vector242>:
.globl vector242
vector242:
  pushl $0
801076c2:	6a 00                	push   $0x0
  pushl $242
801076c4:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076c9:	e9 ae ef ff ff       	jmp    8010667c <alltraps>

801076ce <vector243>:
.globl vector243
vector243:
  pushl $0
801076ce:	6a 00                	push   $0x0
  pushl $243
801076d0:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076d5:	e9 a2 ef ff ff       	jmp    8010667c <alltraps>

801076da <vector244>:
.globl vector244
vector244:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $244
801076dc:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076e1:	e9 96 ef ff ff       	jmp    8010667c <alltraps>

801076e6 <vector245>:
.globl vector245
vector245:
  pushl $0
801076e6:	6a 00                	push   $0x0
  pushl $245
801076e8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076ed:	e9 8a ef ff ff       	jmp    8010667c <alltraps>

801076f2 <vector246>:
.globl vector246
vector246:
  pushl $0
801076f2:	6a 00                	push   $0x0
  pushl $246
801076f4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076f9:	e9 7e ef ff ff       	jmp    8010667c <alltraps>

801076fe <vector247>:
.globl vector247
vector247:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $247
80107700:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107705:	e9 72 ef ff ff       	jmp    8010667c <alltraps>

8010770a <vector248>:
.globl vector248
vector248:
  pushl $0
8010770a:	6a 00                	push   $0x0
  pushl $248
8010770c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107711:	e9 66 ef ff ff       	jmp    8010667c <alltraps>

80107716 <vector249>:
.globl vector249
vector249:
  pushl $0
80107716:	6a 00                	push   $0x0
  pushl $249
80107718:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010771d:	e9 5a ef ff ff       	jmp    8010667c <alltraps>

80107722 <vector250>:
.globl vector250
vector250:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $250
80107724:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107729:	e9 4e ef ff ff       	jmp    8010667c <alltraps>

8010772e <vector251>:
.globl vector251
vector251:
  pushl $0
8010772e:	6a 00                	push   $0x0
  pushl $251
80107730:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107735:	e9 42 ef ff ff       	jmp    8010667c <alltraps>

8010773a <vector252>:
.globl vector252
vector252:
  pushl $0
8010773a:	6a 00                	push   $0x0
  pushl $252
8010773c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107741:	e9 36 ef ff ff       	jmp    8010667c <alltraps>

80107746 <vector253>:
.globl vector253
vector253:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $253
80107748:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010774d:	e9 2a ef ff ff       	jmp    8010667c <alltraps>

80107752 <vector254>:
.globl vector254
vector254:
  pushl $0
80107752:	6a 00                	push   $0x0
  pushl $254
80107754:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107759:	e9 1e ef ff ff       	jmp    8010667c <alltraps>

8010775e <vector255>:
.globl vector255
vector255:
  pushl $0
8010775e:	6a 00                	push   $0x0
  pushl $255
80107760:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107765:	e9 12 ef ff ff       	jmp    8010667c <alltraps>
	...

8010776c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010776c:	55                   	push   %ebp
8010776d:	89 e5                	mov    %esp,%ebp
8010776f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107772:	8b 45 0c             	mov    0xc(%ebp),%eax
80107775:	83 e8 01             	sub    $0x1,%eax
80107778:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010777c:	8b 45 08             	mov    0x8(%ebp),%eax
8010777f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107783:	8b 45 08             	mov    0x8(%ebp),%eax
80107786:	c1 e8 10             	shr    $0x10,%eax
80107789:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010778d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107790:	0f 01 10             	lgdtl  (%eax)
}
80107793:	c9                   	leave  
80107794:	c3                   	ret    

80107795 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107795:	55                   	push   %ebp
80107796:	89 e5                	mov    %esp,%ebp
80107798:	83 ec 04             	sub    $0x4,%esp
8010779b:	8b 45 08             	mov    0x8(%ebp),%eax
8010779e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801077a2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077a6:	0f 00 d8             	ltr    %ax
}
801077a9:	c9                   	leave  
801077aa:	c3                   	ret    

801077ab <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801077ab:	55                   	push   %ebp
801077ac:	89 e5                	mov    %esp,%ebp
801077ae:	83 ec 04             	sub    $0x4,%esp
801077b1:	8b 45 08             	mov    0x8(%ebp),%eax
801077b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801077b8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077bc:	8e e8                	mov    %eax,%gs
}
801077be:	c9                   	leave  
801077bf:	c3                   	ret    

801077c0 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077c3:	8b 45 08             	mov    0x8(%ebp),%eax
801077c6:	0f 22 d8             	mov    %eax,%cr3
}
801077c9:	5d                   	pop    %ebp
801077ca:	c3                   	ret    

801077cb <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801077cb:	55                   	push   %ebp
801077cc:	89 e5                	mov    %esp,%ebp
801077ce:	8b 45 08             	mov    0x8(%ebp),%eax
801077d1:	2d 00 00 00 80       	sub    $0x80000000,%eax
801077d6:	5d                   	pop    %ebp
801077d7:	c3                   	ret    

801077d8 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801077d8:	55                   	push   %ebp
801077d9:	89 e5                	mov    %esp,%ebp
801077db:	8b 45 08             	mov    0x8(%ebp),%eax
801077de:	2d 00 00 00 80       	sub    $0x80000000,%eax
801077e3:	5d                   	pop    %ebp
801077e4:	c3                   	ret    

801077e5 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077e5:	55                   	push   %ebp
801077e6:	89 e5                	mov    %esp,%ebp
801077e8:	53                   	push   %ebx
801077e9:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801077ec:	e8 bb b6 ff ff       	call   80102eac <cpunum>
801077f1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801077f7:	05 40 f9 10 80       	add    $0x8010f940,%eax
801077fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107802:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780b:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107814:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010781f:	83 e2 f0             	and    $0xfffffff0,%edx
80107822:	83 ca 0a             	or     $0xa,%edx
80107825:	88 50 7d             	mov    %dl,0x7d(%eax)
80107828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010782f:	83 ca 10             	or     $0x10,%edx
80107832:	88 50 7d             	mov    %dl,0x7d(%eax)
80107835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107838:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010783c:	83 e2 9f             	and    $0xffffff9f,%edx
8010783f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107845:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107849:	83 ca 80             	or     $0xffffff80,%edx
8010784c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010784f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107852:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107856:	83 ca 0f             	or     $0xf,%edx
80107859:	88 50 7e             	mov    %dl,0x7e(%eax)
8010785c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107863:	83 e2 ef             	and    $0xffffffef,%edx
80107866:	88 50 7e             	mov    %dl,0x7e(%eax)
80107869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107870:	83 e2 df             	and    $0xffffffdf,%edx
80107873:	88 50 7e             	mov    %dl,0x7e(%eax)
80107876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107879:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010787d:	83 ca 40             	or     $0x40,%edx
80107880:	88 50 7e             	mov    %dl,0x7e(%eax)
80107883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107886:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010788a:	83 ca 80             	or     $0xffffff80,%edx
8010788d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107893:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801078a1:	ff ff 
801078a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a6:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801078ad:	00 00 
801078af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801078b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bc:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078c3:	83 e2 f0             	and    $0xfffffff0,%edx
801078c6:	83 ca 02             	or     $0x2,%edx
801078c9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078d9:	83 ca 10             	or     $0x10,%edx
801078dc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078ec:	83 e2 9f             	and    $0xffffff9f,%edx
801078ef:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078ff:	83 ca 80             	or     $0xffffff80,%edx
80107902:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107912:	83 ca 0f             	or     $0xf,%edx
80107915:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010791b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107925:	83 e2 ef             	and    $0xffffffef,%edx
80107928:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010792e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107931:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107938:	83 e2 df             	and    $0xffffffdf,%edx
8010793b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107944:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010794b:	83 ca 40             	or     $0x40,%edx
8010794e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107957:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010795e:	83 ca 80             	or     $0xffffff80,%edx
80107961:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107974:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010797b:	ff ff 
8010797d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107980:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107987:	00 00 
80107989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107996:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010799d:	83 e2 f0             	and    $0xfffffff0,%edx
801079a0:	83 ca 0a             	or     $0xa,%edx
801079a3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ac:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079b3:	83 ca 10             	or     $0x10,%edx
801079b6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079c6:	83 ca 60             	or     $0x60,%edx
801079c9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801079d9:	83 ca 80             	or     $0xffffff80,%edx
801079dc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801079e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079ec:	83 ca 0f             	or     $0xf,%edx
801079ef:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079ff:	83 e2 ef             	and    $0xffffffef,%edx
80107a02:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a12:	83 e2 df             	and    $0xffffffdf,%edx
80107a15:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a25:	83 ca 40             	or     $0x40,%edx
80107a28:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a31:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107a38:	83 ca 80             	or     $0xffffff80,%edx
80107a3b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a44:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4e:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107a55:	ff ff 
80107a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a61:	00 00 
80107a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a66:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a70:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a77:	83 e2 f0             	and    $0xfffffff0,%edx
80107a7a:	83 ca 02             	or     $0x2,%edx
80107a7d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a86:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a8d:	83 ca 10             	or     $0x10,%edx
80107a90:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a99:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107aa0:	83 ca 60             	or     $0x60,%edx
80107aa3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aac:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ab3:	83 ca 80             	or     $0xffffff80,%edx
80107ab6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107abf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ac6:	83 ca 0f             	or     $0xf,%edx
80107ac9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ad9:	83 e2 ef             	and    $0xffffffef,%edx
80107adc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107aec:	83 e2 df             	and    $0xffffffdf,%edx
80107aef:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107aff:	83 ca 40             	or     $0x40,%edx
80107b02:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107b12:	83 ca 80             	or     $0xffffff80,%edx
80107b15:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b28:	05 b4 00 00 00       	add    $0xb4,%eax
80107b2d:	89 c3                	mov    %eax,%ebx
80107b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b32:	05 b4 00 00 00       	add    $0xb4,%eax
80107b37:	c1 e8 10             	shr    $0x10,%eax
80107b3a:	89 c1                	mov    %eax,%ecx
80107b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3f:	05 b4 00 00 00       	add    $0xb4,%eax
80107b44:	c1 e8 18             	shr    $0x18,%eax
80107b47:	89 c2                	mov    %eax,%edx
80107b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4c:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107b53:	00 00 
80107b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b58:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b62:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6b:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b72:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b75:	83 c9 02             	or     $0x2,%ecx
80107b78:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b81:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b88:	83 c9 10             	or     $0x10,%ecx
80107b8b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b94:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b9b:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b9e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107bae:	83 c9 80             	or     $0xffffff80,%ecx
80107bb1:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bba:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107bc1:	83 e1 f0             	and    $0xfffffff0,%ecx
80107bc4:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcd:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107bd4:	83 e1 ef             	and    $0xffffffef,%ecx
80107bd7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be0:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107be7:	83 e1 df             	and    $0xffffffdf,%ecx
80107bea:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf3:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107bfa:	83 c9 40             	or     $0x40,%ecx
80107bfd:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c06:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107c0d:	83 c9 80             	or     $0xffffff80,%ecx
80107c10:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c19:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c22:	83 c0 70             	add    $0x70,%eax
80107c25:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107c2c:	00 
80107c2d:	89 04 24             	mov    %eax,(%esp)
80107c30:	e8 37 fb ff ff       	call   8010776c <lgdt>
  loadgs(SEG_KCPU << 3);
80107c35:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107c3c:	e8 6a fb ff ff       	call   801077ab <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c44:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107c4a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107c51:	00 00 00 00 
}
80107c55:	83 c4 24             	add    $0x24,%esp
80107c58:	5b                   	pop    %ebx
80107c59:	5d                   	pop    %ebp
80107c5a:	c3                   	ret    

80107c5b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c5b:	55                   	push   %ebp
80107c5c:	89 e5                	mov    %esp,%ebp
80107c5e:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c61:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c64:	c1 e8 16             	shr    $0x16,%eax
80107c67:	c1 e0 02             	shl    $0x2,%eax
80107c6a:	03 45 08             	add    0x8(%ebp),%eax
80107c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c73:	8b 00                	mov    (%eax),%eax
80107c75:	83 e0 01             	and    $0x1,%eax
80107c78:	84 c0                	test   %al,%al
80107c7a:	74 17                	je     80107c93 <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c7f:	8b 00                	mov    (%eax),%eax
80107c81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c86:	89 04 24             	mov    %eax,(%esp)
80107c89:	e8 4a fb ff ff       	call   801077d8 <p2v>
80107c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c91:	eb 4b                	jmp    80107cde <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c97:	74 0e                	je     80107ca7 <walkpgdir+0x4c>
80107c99:	e8 94 ae ff ff       	call   80102b32 <kalloc>
80107c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ca5:	75 07                	jne    80107cae <walkpgdir+0x53>
      return 0;
80107ca7:	b8 00 00 00 00       	mov    $0x0,%eax
80107cac:	eb 41                	jmp    80107cef <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107cae:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107cb5:	00 
80107cb6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cbd:	00 
80107cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc1:	89 04 24             	mov    %eax,(%esp)
80107cc4:	e8 d9 d4 ff ff       	call   801051a2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccc:	89 04 24             	mov    %eax,(%esp)
80107ccf:	e8 f7 fa ff ff       	call   801077cb <v2p>
80107cd4:	89 c2                	mov    %eax,%edx
80107cd6:	83 ca 07             	or     $0x7,%edx
80107cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cdc:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107cde:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ce1:	c1 e8 0c             	shr    $0xc,%eax
80107ce4:	25 ff 03 00 00       	and    $0x3ff,%eax
80107ce9:	c1 e0 02             	shl    $0x2,%eax
80107cec:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107cef:	c9                   	leave  
80107cf0:	c3                   	ret    

80107cf1 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107cf1:	55                   	push   %ebp
80107cf2:	89 e5                	mov    %esp,%ebp
80107cf4:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d05:	03 45 10             	add    0x10(%ebp),%eax
80107d08:	83 e8 01             	sub    $0x1,%eax
80107d0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107d13:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107d1a:	00 
80107d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d22:	8b 45 08             	mov    0x8(%ebp),%eax
80107d25:	89 04 24             	mov    %eax,(%esp)
80107d28:	e8 2e ff ff ff       	call   80107c5b <walkpgdir>
80107d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d34:	75 07                	jne    80107d3d <mappages+0x4c>
      return -1;
80107d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d3b:	eb 46                	jmp    80107d83 <mappages+0x92>
    if(*pte & PTE_P)
80107d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d40:	8b 00                	mov    (%eax),%eax
80107d42:	83 e0 01             	and    $0x1,%eax
80107d45:	84 c0                	test   %al,%al
80107d47:	74 0c                	je     80107d55 <mappages+0x64>
      panic("remap");
80107d49:	c7 04 24 a0 8b 10 80 	movl   $0x80108ba0,(%esp)
80107d50:	e8 e5 87 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107d55:	8b 45 18             	mov    0x18(%ebp),%eax
80107d58:	0b 45 14             	or     0x14(%ebp),%eax
80107d5b:	89 c2                	mov    %eax,%edx
80107d5d:	83 ca 01             	or     $0x1,%edx
80107d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d63:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d6b:	74 10                	je     80107d7d <mappages+0x8c>
      break;
    a += PGSIZE;
80107d6d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107d74:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d7b:	eb 96                	jmp    80107d13 <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107d7d:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d83:	c9                   	leave  
80107d84:	c3                   	ret    

80107d85 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107d85:	55                   	push   %ebp
80107d86:	89 e5                	mov    %esp,%ebp
80107d88:	53                   	push   %ebx
80107d89:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d8c:	e8 a1 ad ff ff       	call   80102b32 <kalloc>
80107d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d98:	75 0a                	jne    80107da4 <setupkvm+0x1f>
    return 0;
80107d9a:	b8 00 00 00 00       	mov    $0x0,%eax
80107d9f:	e9 99 00 00 00       	jmp    80107e3d <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
80107da4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107dab:	00 
80107dac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107db3:	00 
80107db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db7:	89 04 24             	mov    %eax,(%esp)
80107dba:	e8 e3 d3 ff ff       	call   801051a2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107dbf:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107dc6:	e8 0d fa ff ff       	call   801077d8 <p2v>
80107dcb:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107dd0:	76 0c                	jbe    80107dde <setupkvm+0x59>
    panic("PHYSTOP too high");
80107dd2:	c7 04 24 a6 8b 10 80 	movl   $0x80108ba6,(%esp)
80107dd9:	e8 5c 87 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dde:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107de5:	eb 49                	jmp    80107e30 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dea:	8b 48 0c             	mov    0xc(%eax),%ecx
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	8b 50 04             	mov    0x4(%eax),%edx
80107df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df6:	8b 58 08             	mov    0x8(%eax),%ebx
80107df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfc:	8b 40 04             	mov    0x4(%eax),%eax
80107dff:	29 c3                	sub    %eax,%ebx
80107e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e04:	8b 00                	mov    (%eax),%eax
80107e06:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107e0a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107e0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e19:	89 04 24             	mov    %eax,(%esp)
80107e1c:	e8 d0 fe ff ff       	call   80107cf1 <mappages>
80107e21:	85 c0                	test   %eax,%eax
80107e23:	79 07                	jns    80107e2c <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107e25:	b8 00 00 00 00       	mov    $0x0,%eax
80107e2a:	eb 11                	jmp    80107e3d <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e2c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107e30:	b8 00 b5 10 80       	mov    $0x8010b500,%eax
80107e35:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107e38:	72 ad                	jb     80107de7 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107e3d:	83 c4 34             	add    $0x34,%esp
80107e40:	5b                   	pop    %ebx
80107e41:	5d                   	pop    %ebp
80107e42:	c3                   	ret    

80107e43 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107e43:	55                   	push   %ebp
80107e44:	89 e5                	mov    %esp,%ebp
80107e46:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e49:	e8 37 ff ff ff       	call   80107d85 <setupkvm>
80107e4e:	a3 18 29 11 80       	mov    %eax,0x80112918
  switchkvm();
80107e53:	e8 02 00 00 00       	call   80107e5a <switchkvm>
}
80107e58:	c9                   	leave  
80107e59:	c3                   	ret    

80107e5a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e5a:	55                   	push   %ebp
80107e5b:	89 e5                	mov    %esp,%ebp
80107e5d:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e60:	a1 18 29 11 80       	mov    0x80112918,%eax
80107e65:	89 04 24             	mov    %eax,(%esp)
80107e68:	e8 5e f9 ff ff       	call   801077cb <v2p>
80107e6d:	89 04 24             	mov    %eax,(%esp)
80107e70:	e8 4b f9 ff ff       	call   801077c0 <lcr3>
}
80107e75:	c9                   	leave  
80107e76:	c3                   	ret    

80107e77 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e77:	55                   	push   %ebp
80107e78:	89 e5                	mov    %esp,%ebp
80107e7a:	53                   	push   %ebx
80107e7b:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107e7e:	e8 19 d2 ff ff       	call   8010509c <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e89:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e90:	83 c2 08             	add    $0x8,%edx
80107e93:	89 d3                	mov    %edx,%ebx
80107e95:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e9c:	83 c2 08             	add    $0x8,%edx
80107e9f:	c1 ea 10             	shr    $0x10,%edx
80107ea2:	89 d1                	mov    %edx,%ecx
80107ea4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107eab:	83 c2 08             	add    $0x8,%edx
80107eae:	c1 ea 18             	shr    $0x18,%edx
80107eb1:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107eb8:	67 00 
80107eba:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107ec1:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107ec7:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ece:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ed1:	83 c9 09             	or     $0x9,%ecx
80107ed4:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107eda:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ee1:	83 c9 10             	or     $0x10,%ecx
80107ee4:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107eea:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ef1:	83 e1 9f             	and    $0xffffff9f,%ecx
80107ef4:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107efa:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107f01:	83 c9 80             	or     $0xffffff80,%ecx
80107f04:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107f0a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f11:	83 e1 f0             	and    $0xfffffff0,%ecx
80107f14:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f1a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f21:	83 e1 ef             	and    $0xffffffef,%ecx
80107f24:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f2a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f31:	83 e1 df             	and    $0xffffffdf,%ecx
80107f34:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f3a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f41:	83 c9 40             	or     $0x40,%ecx
80107f44:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f4a:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107f51:	83 e1 7f             	and    $0x7f,%ecx
80107f54:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f5a:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f60:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f66:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f6d:	83 e2 ef             	and    $0xffffffef,%edx
80107f70:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f76:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f7c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f82:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f88:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107f8f:	8b 52 08             	mov    0x8(%edx),%edx
80107f92:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f98:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f9b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107fa2:	e8 ee f7 ff ff       	call   80107795 <ltr>
  if(p->pgdir == 0)
80107fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80107faa:	8b 40 04             	mov    0x4(%eax),%eax
80107fad:	85 c0                	test   %eax,%eax
80107faf:	75 0c                	jne    80107fbd <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107fb1:	c7 04 24 b7 8b 10 80 	movl   $0x80108bb7,(%esp)
80107fb8:	e8 7d 85 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107fbd:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc0:	8b 40 04             	mov    0x4(%eax),%eax
80107fc3:	89 04 24             	mov    %eax,(%esp)
80107fc6:	e8 00 f8 ff ff       	call   801077cb <v2p>
80107fcb:	89 04 24             	mov    %eax,(%esp)
80107fce:	e8 ed f7 ff ff       	call   801077c0 <lcr3>
  popcli();
80107fd3:	e8 0c d1 ff ff       	call   801050e4 <popcli>
}
80107fd8:	83 c4 14             	add    $0x14,%esp
80107fdb:	5b                   	pop    %ebx
80107fdc:	5d                   	pop    %ebp
80107fdd:	c3                   	ret    

80107fde <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107fde:	55                   	push   %ebp
80107fdf:	89 e5                	mov    %esp,%ebp
80107fe1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107fe4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107feb:	76 0c                	jbe    80107ff9 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107fed:	c7 04 24 cb 8b 10 80 	movl   $0x80108bcb,(%esp)
80107ff4:	e8 41 85 ff ff       	call   8010053a <panic>
  mem = kalloc();
80107ff9:	e8 34 ab ff ff       	call   80102b32 <kalloc>
80107ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108001:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108008:	00 
80108009:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108010:	00 
80108011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108014:	89 04 24             	mov    %eax,(%esp)
80108017:	e8 86 d1 ff ff       	call   801051a2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010801c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801f:	89 04 24             	mov    %eax,(%esp)
80108022:	e8 a4 f7 ff ff       	call   801077cb <v2p>
80108027:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010802e:	00 
8010802f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108033:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010803a:	00 
8010803b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108042:	00 
80108043:	8b 45 08             	mov    0x8(%ebp),%eax
80108046:	89 04 24             	mov    %eax,(%esp)
80108049:	e8 a3 fc ff ff       	call   80107cf1 <mappages>
  memmove(mem, init, sz);
8010804e:	8b 45 10             	mov    0x10(%ebp),%eax
80108051:	89 44 24 08          	mov    %eax,0x8(%esp)
80108055:	8b 45 0c             	mov    0xc(%ebp),%eax
80108058:	89 44 24 04          	mov    %eax,0x4(%esp)
8010805c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805f:	89 04 24             	mov    %eax,(%esp)
80108062:	e8 0e d2 ff ff       	call   80105275 <memmove>
}
80108067:	c9                   	leave  
80108068:	c3                   	ret    

80108069 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108069:	55                   	push   %ebp
8010806a:	89 e5                	mov    %esp,%ebp
8010806c:	53                   	push   %ebx
8010806d:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108070:	8b 45 0c             	mov    0xc(%ebp),%eax
80108073:	25 ff 0f 00 00       	and    $0xfff,%eax
80108078:	85 c0                	test   %eax,%eax
8010807a:	74 0c                	je     80108088 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010807c:	c7 04 24 e8 8b 10 80 	movl   $0x80108be8,(%esp)
80108083:	e8 b2 84 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108088:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
8010808f:	e9 ae 00 00 00       	jmp    80108142 <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108094:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108097:	8b 55 0c             	mov    0xc(%ebp),%edx
8010809a:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010809d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080a4:	00 
801080a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080a9:	8b 45 08             	mov    0x8(%ebp),%eax
801080ac:	89 04 24             	mov    %eax,(%esp)
801080af:	e8 a7 fb ff ff       	call   80107c5b <walkpgdir>
801080b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801080b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080bb:	75 0c                	jne    801080c9 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801080bd:	c7 04 24 0b 8c 10 80 	movl   $0x80108c0b,(%esp)
801080c4:	e8 71 84 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801080c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cc:	8b 00                	mov    (%eax),%eax
801080ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
801080d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080d9:	8b 55 18             	mov    0x18(%ebp),%edx
801080dc:	89 d1                	mov    %edx,%ecx
801080de:	29 c1                	sub    %eax,%ecx
801080e0:	89 c8                	mov    %ecx,%eax
801080e2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801080e7:	77 11                	ja     801080fa <loaduvm+0x91>
      n = sz - i;
801080e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080ec:	8b 55 18             	mov    0x18(%ebp),%edx
801080ef:	89 d1                	mov    %edx,%ecx
801080f1:	29 c1                	sub    %eax,%ecx
801080f3:	89 c8                	mov    %ecx,%eax
801080f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080f8:	eb 07                	jmp    80108101 <loaduvm+0x98>
    else
      n = PGSIZE;
801080fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108101:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108104:	8b 55 14             	mov    0x14(%ebp),%edx
80108107:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010810a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010810d:	89 04 24             	mov    %eax,(%esp)
80108110:	e8 c3 f6 ff ff       	call   801077d8 <p2v>
80108115:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108118:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010811c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108120:	89 44 24 04          	mov    %eax,0x4(%esp)
80108124:	8b 45 10             	mov    0x10(%ebp),%eax
80108127:	89 04 24             	mov    %eax,(%esp)
8010812a:	e8 6d 9c ff ff       	call   80101d9c <readi>
8010812f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108132:	74 07                	je     8010813b <loaduvm+0xd2>
      return -1;
80108134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108139:	eb 18                	jmp    80108153 <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010813b:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
80108142:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108145:	3b 45 18             	cmp    0x18(%ebp),%eax
80108148:	0f 82 46 ff ff ff    	jb     80108094 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010814e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108153:	83 c4 24             	add    $0x24,%esp
80108156:	5b                   	pop    %ebx
80108157:	5d                   	pop    %ebp
80108158:	c3                   	ret    

80108159 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108159:	55                   	push   %ebp
8010815a:	89 e5                	mov    %esp,%ebp
8010815c:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010815f:	8b 45 10             	mov    0x10(%ebp),%eax
80108162:	85 c0                	test   %eax,%eax
80108164:	79 0a                	jns    80108170 <allocuvm+0x17>
    return 0;
80108166:	b8 00 00 00 00       	mov    $0x0,%eax
8010816b:	e9 c1 00 00 00       	jmp    80108231 <allocuvm+0xd8>
  if(newsz < oldsz)
80108170:	8b 45 10             	mov    0x10(%ebp),%eax
80108173:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108176:	73 08                	jae    80108180 <allocuvm+0x27>
    return oldsz;
80108178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817b:	e9 b1 00 00 00       	jmp    80108231 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108180:	8b 45 0c             	mov    0xc(%ebp),%eax
80108183:	05 ff 0f 00 00       	add    $0xfff,%eax
80108188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010818d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108190:	e9 8d 00 00 00       	jmp    80108222 <allocuvm+0xc9>
    mem = kalloc();
80108195:	e8 98 a9 ff ff       	call   80102b32 <kalloc>
8010819a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010819d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081a1:	75 2c                	jne    801081cf <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801081a3:	c7 04 24 29 8c 10 80 	movl   $0x80108c29,(%esp)
801081aa:	e8 eb 81 ff ff       	call   8010039a <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081af:	8b 45 0c             	mov    0xc(%ebp),%eax
801081b2:	89 44 24 08          	mov    %eax,0x8(%esp)
801081b6:	8b 45 10             	mov    0x10(%ebp),%eax
801081b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801081bd:	8b 45 08             	mov    0x8(%ebp),%eax
801081c0:	89 04 24             	mov    %eax,(%esp)
801081c3:	e8 6b 00 00 00       	call   80108233 <deallocuvm>
      return 0;
801081c8:	b8 00 00 00 00       	mov    $0x0,%eax
801081cd:	eb 62                	jmp    80108231 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801081cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081d6:	00 
801081d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801081de:	00 
801081df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e2:	89 04 24             	mov    %eax,(%esp)
801081e5:	e8 b8 cf ff ff       	call   801051a2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801081ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ed:	89 04 24             	mov    %eax,(%esp)
801081f0:	e8 d6 f5 ff ff       	call   801077cb <v2p>
801081f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081f8:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801081ff:	00 
80108200:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108204:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010820b:	00 
8010820c:	89 54 24 04          	mov    %edx,0x4(%esp)
80108210:	8b 45 08             	mov    0x8(%ebp),%eax
80108213:	89 04 24             	mov    %eax,(%esp)
80108216:	e8 d6 fa ff ff       	call   80107cf1 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010821b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108225:	3b 45 10             	cmp    0x10(%ebp),%eax
80108228:	0f 82 67 ff ff ff    	jb     80108195 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010822e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108231:	c9                   	leave  
80108232:	c3                   	ret    

80108233 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108233:	55                   	push   %ebp
80108234:	89 e5                	mov    %esp,%ebp
80108236:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108239:	8b 45 10             	mov    0x10(%ebp),%eax
8010823c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010823f:	72 08                	jb     80108249 <deallocuvm+0x16>
    return oldsz;
80108241:	8b 45 0c             	mov    0xc(%ebp),%eax
80108244:	e9 a4 00 00 00       	jmp    801082ed <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108249:	8b 45 10             	mov    0x10(%ebp),%eax
8010824c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108251:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108256:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108259:	e9 80 00 00 00       	jmp    801082de <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010825e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108261:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108268:	00 
80108269:	89 44 24 04          	mov    %eax,0x4(%esp)
8010826d:	8b 45 08             	mov    0x8(%ebp),%eax
80108270:	89 04 24             	mov    %eax,(%esp)
80108273:	e8 e3 f9 ff ff       	call   80107c5b <walkpgdir>
80108278:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
8010827b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010827f:	75 09                	jne    8010828a <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108281:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80108288:	eb 4d                	jmp    801082d7 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010828a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010828d:	8b 00                	mov    (%eax),%eax
8010828f:	83 e0 01             	and    $0x1,%eax
80108292:	84 c0                	test   %al,%al
80108294:	74 41                	je     801082d7 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108296:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108299:	8b 00                	mov    (%eax),%eax
8010829b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
801082a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082a7:	75 0c                	jne    801082b5 <deallocuvm+0x82>
        panic("kfree");
801082a9:	c7 04 24 41 8c 10 80 	movl   $0x80108c41,(%esp)
801082b0:	e8 85 82 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
801082b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082b8:	89 04 24             	mov    %eax,(%esp)
801082bb:	e8 18 f5 ff ff       	call   801077d8 <p2v>
801082c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	89 04 24             	mov    %eax,(%esp)
801082c9:	e8 cb a7 ff ff       	call   80102a99 <kfree>
      *pte = 0;
801082ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801082d7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801082de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801082e4:	0f 82 74 ff ff ff    	jb     8010825e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801082ea:	8b 45 10             	mov    0x10(%ebp),%eax
}
801082ed:	c9                   	leave  
801082ee:	c3                   	ret    

801082ef <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801082ef:	55                   	push   %ebp
801082f0:	89 e5                	mov    %esp,%ebp
801082f2:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801082f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801082f9:	75 0c                	jne    80108307 <freevm+0x18>
    panic("freevm: no pgdir");
801082fb:	c7 04 24 47 8c 10 80 	movl   $0x80108c47,(%esp)
80108302:	e8 33 82 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108307:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010830e:	00 
8010830f:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108316:	80 
80108317:	8b 45 08             	mov    0x8(%ebp),%eax
8010831a:	89 04 24             	mov    %eax,(%esp)
8010831d:	e8 11 ff ff ff       	call   80108233 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108322:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108329:	eb 3c                	jmp    80108367 <freevm+0x78>
    if(pgdir[i] & PTE_P){
8010832b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010832e:	c1 e0 02             	shl    $0x2,%eax
80108331:	03 45 08             	add    0x8(%ebp),%eax
80108334:	8b 00                	mov    (%eax),%eax
80108336:	83 e0 01             	and    $0x1,%eax
80108339:	84 c0                	test   %al,%al
8010833b:	74 26                	je     80108363 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010833d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108340:	c1 e0 02             	shl    $0x2,%eax
80108343:	03 45 08             	add    0x8(%ebp),%eax
80108346:	8b 00                	mov    (%eax),%eax
80108348:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010834d:	89 04 24             	mov    %eax,(%esp)
80108350:	e8 83 f4 ff ff       	call   801077d8 <p2v>
80108355:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	89 04 24             	mov    %eax,(%esp)
8010835e:	e8 36 a7 ff ff       	call   80102a99 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108363:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108367:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
8010836e:	76 bb                	jbe    8010832b <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108370:	8b 45 08             	mov    0x8(%ebp),%eax
80108373:	89 04 24             	mov    %eax,(%esp)
80108376:	e8 1e a7 ff ff       	call   80102a99 <kfree>
}
8010837b:	c9                   	leave  
8010837c:	c3                   	ret    

8010837d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010837d:	55                   	push   %ebp
8010837e:	89 e5                	mov    %esp,%ebp
80108380:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108383:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010838a:	00 
8010838b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010838e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108392:	8b 45 08             	mov    0x8(%ebp),%eax
80108395:	89 04 24             	mov    %eax,(%esp)
80108398:	e8 be f8 ff ff       	call   80107c5b <walkpgdir>
8010839d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801083a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083a4:	75 0c                	jne    801083b2 <clearpteu+0x35>
    panic("clearpteu");
801083a6:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801083ad:	e8 88 81 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
801083b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b5:	8b 00                	mov    (%eax),%eax
801083b7:	89 c2                	mov    %eax,%edx
801083b9:	83 e2 fb             	and    $0xfffffffb,%edx
801083bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bf:	89 10                	mov    %edx,(%eax)
}
801083c1:	c9                   	leave  
801083c2:	c3                   	ret    

801083c3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801083c3:	55                   	push   %ebp
801083c4:	89 e5                	mov    %esp,%ebp
801083c6:	53                   	push   %ebx
801083c7:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801083ca:	e8 b6 f9 ff ff       	call   80107d85 <setupkvm>
801083cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801083d6:	75 0a                	jne    801083e2 <copyuvm+0x1f>
    return 0;
801083d8:	b8 00 00 00 00       	mov    $0x0,%eax
801083dd:	e9 fd 00 00 00       	jmp    801084df <copyuvm+0x11c>
  for(i = PGSIZE; i < sz; i += PGSIZE){
801083e2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
801083e9:	e9 cc 00 00 00       	jmp    801084ba <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801083ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083f8:	00 
801083f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801083fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108400:	89 04 24             	mov    %eax,(%esp)
80108403:	e8 53 f8 ff ff       	call   80107c5b <walkpgdir>
80108408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010840b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010840f:	75 0c                	jne    8010841d <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108411:	c7 04 24 62 8c 10 80 	movl   $0x80108c62,(%esp)
80108418:	e8 1d 81 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
8010841d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108420:	8b 00                	mov    (%eax),%eax
80108422:	83 e0 01             	and    $0x1,%eax
80108425:	85 c0                	test   %eax,%eax
80108427:	75 0c                	jne    80108435 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108429:	c7 04 24 7c 8c 10 80 	movl   $0x80108c7c,(%esp)
80108430:	e8 05 81 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108438:	8b 00                	mov    (%eax),%eax
8010843a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010843f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108445:	8b 00                	mov    (%eax),%eax
80108447:	25 ff 0f 00 00       	and    $0xfff,%eax
8010844c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
8010844f:	e8 de a6 ff ff       	call   80102b32 <kalloc>
80108454:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010845b:	74 6e                	je     801084cb <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010845d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108460:	89 04 24             	mov    %eax,(%esp)
80108463:	e8 70 f3 ff ff       	call   801077d8 <p2v>
80108468:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010846f:	00 
80108470:	89 44 24 04          	mov    %eax,0x4(%esp)
80108474:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108477:	89 04 24             	mov    %eax,(%esp)
8010847a:	e8 f6 cd ff ff       	call   80105275 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010847f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108485:	89 04 24             	mov    %eax,(%esp)
80108488:	e8 3e f3 ff ff       	call   801077cb <v2p>
8010848d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108490:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108494:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108498:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010849f:	00 
801084a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801084a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084a7:	89 04 24             	mov    %eax,(%esp)
801084aa:	e8 42 f8 ff ff       	call   80107cf1 <mappages>
801084af:	85 c0                	test   %eax,%eax
801084b1:	78 1b                	js     801084ce <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = PGSIZE; i < sz; i += PGSIZE){
801084b3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801084ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084c0:	0f 82 28 ff ff ff    	jb     801083ee <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801084c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084c9:	eb 14                	jmp    801084df <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801084cb:	90                   	nop
801084cc:	eb 01                	jmp    801084cf <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801084ce:	90                   	nop
  }
  return d;

bad:
     // current = getpid();
  freevm(d);
801084cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084d2:	89 04 24             	mov    %eax,(%esp)
801084d5:	e8 15 fe ff ff       	call   801082ef <freevm>
  return 0;
801084da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084df:	83 c4 44             	add    $0x44,%esp
801084e2:	5b                   	pop    %ebx
801084e3:	5d                   	pop    %ebp
801084e4:	c3                   	ret    

801084e5 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801084e5:	55                   	push   %ebp
801084e6:	89 e5                	mov    %esp,%ebp
801084e8:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801084eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084f2:	00 
801084f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801084f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801084fa:	8b 45 08             	mov    0x8(%ebp),%eax
801084fd:	89 04 24             	mov    %eax,(%esp)
80108500:	e8 56 f7 ff ff       	call   80107c5b <walkpgdir>
80108505:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010850b:	8b 00                	mov    (%eax),%eax
8010850d:	83 e0 01             	and    $0x1,%eax
80108510:	85 c0                	test   %eax,%eax
80108512:	75 07                	jne    8010851b <uva2ka+0x36>
    return 0;
80108514:	b8 00 00 00 00       	mov    $0x0,%eax
80108519:	eb 25                	jmp    80108540 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010851b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010851e:	8b 00                	mov    (%eax),%eax
80108520:	83 e0 04             	and    $0x4,%eax
80108523:	85 c0                	test   %eax,%eax
80108525:	75 07                	jne    8010852e <uva2ka+0x49>
    return 0;
80108527:	b8 00 00 00 00       	mov    $0x0,%eax
8010852c:	eb 12                	jmp    80108540 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108531:	8b 00                	mov    (%eax),%eax
80108533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108538:	89 04 24             	mov    %eax,(%esp)
8010853b:	e8 98 f2 ff ff       	call   801077d8 <p2v>
}
80108540:	c9                   	leave  
80108541:	c3                   	ret    

80108542 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108542:	55                   	push   %ebp
80108543:	89 e5                	mov    %esp,%ebp
80108545:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108548:	8b 45 10             	mov    0x10(%ebp),%eax
8010854b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
8010854e:	e9 8b 00 00 00       	jmp    801085de <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
80108553:	8b 45 0c             	mov    0xc(%ebp),%eax
80108556:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010855b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010855e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108561:	89 44 24 04          	mov    %eax,0x4(%esp)
80108565:	8b 45 08             	mov    0x8(%ebp),%eax
80108568:	89 04 24             	mov    %eax,(%esp)
8010856b:	e8 75 ff ff ff       	call   801084e5 <uva2ka>
80108570:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
80108573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108577:	75 07                	jne    80108580 <copyout+0x3e>
      return -1;
80108579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010857e:	eb 6d                	jmp    801085ed <copyout+0xab>
    n = PGSIZE - (va - va0);
80108580:	8b 45 0c             	mov    0xc(%ebp),%eax
80108583:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108586:	89 d1                	mov    %edx,%ecx
80108588:	29 c1                	sub    %eax,%ecx
8010858a:	89 c8                	mov    %ecx,%eax
8010858c:	05 00 10 00 00       	add    $0x1000,%eax
80108591:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108597:	3b 45 14             	cmp    0x14(%ebp),%eax
8010859a:	76 06                	jbe    801085a2 <copyout+0x60>
      n = len;
8010859c:	8b 45 14             	mov    0x14(%ebp),%eax
8010859f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801085a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801085a8:	89 d1                	mov    %edx,%ecx
801085aa:	29 c1                	sub    %eax,%ecx
801085ac:	89 c8                	mov    %ecx,%eax
801085ae:	03 45 ec             	add    -0x14(%ebp),%eax
801085b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801085b4:	89 54 24 08          	mov    %edx,0x8(%esp)
801085b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801085bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801085bf:	89 04 24             	mov    %eax,(%esp)
801085c2:	e8 ae cc ff ff       	call   80105275 <memmove>
    len -= n;
801085c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085ca:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801085cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d0:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
801085d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d6:	05 00 10 00 00       	add    $0x1000,%eax
801085db:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801085de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801085e2:	0f 85 6b ff ff ff    	jne    80108553 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801085e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085ed:	c9                   	leave  
801085ee:	c3                   	ret    
