
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2e 10 80       	mov    $0x80102e80,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	56                   	push   %esi
80100044:	53                   	push   %ebx
80100045:	83 ec 10             	sub    $0x10,%esp
80100048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010004b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010004e:	89 34 24             	mov    %esi,(%esp)
80100051:	e8 1a 40 00 00       	call   80104070 <holdingsleep>
80100056:	85 c0                	test   %eax,%eax
80100058:	74 62                	je     801000bc <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
8010005a:	89 34 24             	mov    %esi,(%esp)
8010005d:	e8 3e 40 00 00       	call   801040a0 <releasesleep>

  acquire(&bcache.lock);
80100062:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100069:	e8 c2 42 00 00       	call   80104330 <acquire>
  b->refcnt--;
8010006e:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100071:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100074:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100076:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100079:	75 2f                	jne    801000aa <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010007b:	8b 43 54             	mov    0x54(%ebx),%eax
8010007e:	8b 53 50             	mov    0x50(%ebx),%edx
80100081:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100084:	8b 43 50             	mov    0x50(%ebx),%eax
80100087:	8b 53 54             	mov    0x54(%ebx),%edx
8010008a:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010008d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100092:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100099:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
8010009c:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
801000a1:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000a4:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
801000aa:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
801000b1:	83 c4 10             	add    $0x10,%esp
801000b4:	5b                   	pop    %ebx
801000b5:	5e                   	pop    %esi
801000b6:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
801000b7:	e9 24 42 00 00       	jmp    801042e0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
801000bc:	c7 04 24 80 6f 10 80 	movl   $0x80106f80,(%esp)
801000c3:	e8 e8 02 00 00       	call   801003b0 <panic>
801000c8:	90                   	nop
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	53                   	push   %ebx
801000d4:	83 ec 14             	sub    $0x14,%esp
801000d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801000da:	8d 43 0c             	lea    0xc(%ebx),%eax
801000dd:	89 04 24             	mov    %eax,(%esp)
801000e0:	e8 8b 3f 00 00       	call   80104070 <holdingsleep>
801000e5:	85 c0                	test   %eax,%eax
801000e7:	74 10                	je     801000f9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801000e9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801000ec:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801000ef:	83 c4 14             	add    $0x14,%esp
801000f2:	5b                   	pop    %ebx
801000f3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801000f4:	e9 77 1f 00 00       	jmp    80102070 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801000f9:	c7 04 24 87 6f 10 80 	movl   $0x80106f87,(%esp)
80100100:	e8 ab 02 00 00       	call   801003b0 <panic>
80100105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100110 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100110:	55                   	push   %ebp
80100111:	89 e5                	mov    %esp,%ebp
80100113:	57                   	push   %edi
80100114:	56                   	push   %esi
80100115:	53                   	push   %ebx
80100116:	83 ec 1c             	sub    $0x1c,%esp
80100119:	8b 75 08             	mov    0x8(%ebp),%esi
8010011c:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
8010011f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100126:	e8 05 42 00 00       	call   80104330 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012b:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
80100131:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100137:	75 12                	jne    8010014b <bread+0x3b>
80100139:	eb 2d                	jmp    80100168 <bread+0x58>
8010013b:	90                   	nop
8010013c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100140:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100143:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100149:	74 1d                	je     80100168 <bread+0x58>
    if(b->dev == dev && b->blockno == blockno){
8010014b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010014e:	66 90                	xchg   %ax,%ax
80100150:	75 ee                	jne    80100140 <bread+0x30>
80100152:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100155:	75 e9                	jne    80100140 <bread+0x30>
      b->refcnt++;
80100157:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
8010015b:	90                   	nop
8010015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100160:	eb 40                	jmp    801001a2 <bread+0x92>
80100162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100168:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
8010016e:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100174:	75 0d                	jne    80100183 <bread+0x73>
80100176:	eb 58                	jmp    801001d0 <bread+0xc0>
80100178:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010017b:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100181:	74 4d                	je     801001d0 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100183:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100186:	85 c0                	test   %eax,%eax
80100188:	75 ee                	jne    80100178 <bread+0x68>
8010018a:	f6 03 04             	testb  $0x4,(%ebx)
8010018d:	75 e9                	jne    80100178 <bread+0x68>
      b->dev = dev;
8010018f:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100192:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100195:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010019b:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801001a2:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001a9:	e8 32 41 00 00       	call   801042e0 <release>
      acquiresleep(&b->lock);
801001ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b1:	89 04 24             	mov    %eax,(%esp)
801001b4:	e8 27 3f 00 00       	call   801040e0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
801001b9:	f6 03 02             	testb  $0x2,(%ebx)
801001bc:	75 08                	jne    801001c6 <bread+0xb6>
    iderw(b);
801001be:	89 1c 24             	mov    %ebx,(%esp)
801001c1:	e8 aa 1e 00 00       	call   80102070 <iderw>
  }
  return b;
}
801001c6:	83 c4 1c             	add    $0x1c,%esp
801001c9:	89 d8                	mov    %ebx,%eax
801001cb:	5b                   	pop    %ebx
801001cc:	5e                   	pop    %esi
801001cd:	5f                   	pop    %edi
801001ce:	5d                   	pop    %ebp
801001cf:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001d0:	c7 04 24 8e 6f 10 80 	movl   $0x80106f8e,(%esp)
801001d7:	e8 d4 01 00 00       	call   801003b0 <panic>
801001dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	53                   	push   %ebx
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
801001e4:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
801001e9:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
801001ec:	c7 44 24 04 9f 6f 10 	movl   $0x80106f9f,0x4(%esp)
801001f3:	80 
801001f4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001fb:	e8 80 3f 00 00       	call   80104180 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
80100200:	b8 dc fc 10 80       	mov    $0x8010fcdc,%eax

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100205:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010020c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010020f:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100216:	fc 10 80 
80100219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100220:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100223:	8d 43 0c             	lea    0xc(%ebx),%eax
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
80100226:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010022d:	89 04 24             	mov    %eax,(%esp)
80100230:	c7 44 24 04 a6 6f 10 	movl   $0x80106fa6,0x4(%esp)
80100237:	80 
80100238:	e8 03 3f 00 00       	call   80104140 <initsleeplock>
    bcache.head.next->prev = b;
8010023d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100242:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100245:	89 d8                	mov    %ebx,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
80100247:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010024d:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100253:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100259:	75 c5                	jne    80100220 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
8010025b:	83 c4 14             	add    $0x14,%esp
8010025e:	5b                   	pop    %ebx
8010025f:	5d                   	pop    %ebp
80100260:	c3                   	ret    
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100276:	c7 44 24 04 ad 6f 10 	movl   $0x80106fad,0x4(%esp)
8010027d:	80 
8010027e:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100285:	e8 f6 3e 00 00       	call   80104180 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010028a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100291:	00 
80100292:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100299:	c7 05 8c 09 11 80 b0 	movl   $0x801005b0,0x8011098c
801002a0:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801002a3:	c7 05 88 09 11 80 c0 	movl   $0x801002c0,0x80110988
801002aa:	02 10 80 
  cons.locking = 1;
801002ad:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
801002b4:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801002b7:	e8 a4 1f 00 00       	call   80102260 <ioapicenable>
}
801002bc:	c9                   	leave  
801002bd:	c3                   	ret    
801002be:	66 90                	xchg   %ax,%ax

801002c0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002c0:	55                   	push   %ebp
801002c1:	89 e5                	mov    %esp,%ebp
801002c3:	57                   	push   %edi
801002c4:	56                   	push   %esi
801002c5:	53                   	push   %ebx
801002c6:	83 ec 2c             	sub    $0x2c,%esp
801002c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002cc:	8b 75 08             	mov    0x8(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002cf:	89 34 24             	mov    %esi,(%esp)
801002d2:	e8 09 1a 00 00       	call   80101ce0 <iunlock>
  target = n;
801002d7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
801002da:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801002e1:	e8 4a 40 00 00       	call   80104330 <acquire>
  while(n > 0){
801002e6:	85 db                	test   %ebx,%ebx
801002e8:	7f 26                	jg     80100310 <consoleread+0x50>
801002ea:	e9 bb 00 00 00       	jmp    801003aa <consoleread+0xea>
801002ef:	90                   	nop
    while(input.r == input.w){
      if(myproc()->killed){
801002f0:	e8 bb 37 00 00       	call   80103ab0 <myproc>
801002f5:	8b 40 24             	mov    0x24(%eax),%eax
801002f8:	85 c0                	test   %eax,%eax
801002fa:	75 5c                	jne    80100358 <consoleread+0x98>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002fc:	c7 44 24 04 40 a5 10 	movl   $0x8010a540,0x4(%esp)
80100303:	80 
80100304:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
8010030b:	e8 00 3a 00 00       	call   80103d10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100310:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
80100315:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010031b:	74 d3                	je     801002f0 <consoleread+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
8010031d:	89 c2                	mov    %eax,%edx
8010031f:	83 e2 7f             	and    $0x7f,%edx
80100322:	0f b6 8a 40 ff 10 80 	movzbl -0x7fef00c0(%edx),%ecx
80100329:	8d 78 01             	lea    0x1(%eax),%edi
8010032c:	89 3d c0 ff 10 80    	mov    %edi,0x8010ffc0
80100332:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
80100335:	83 fa 04             	cmp    $0x4,%edx
80100338:	74 3f                	je     80100379 <consoleread+0xb9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010033a:	8b 45 0c             	mov    0xc(%ebp),%eax
    --n;
8010033d:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100340:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100343:	88 08                	mov    %cl,(%eax)
    --n;
    if(c == '\n')
80100345:	74 3c                	je     80100383 <consoleread+0xc3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100347:	85 db                	test   %ebx,%ebx
80100349:	7e 38                	jle    80100383 <consoleread+0xc3>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010034b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010034f:	eb bf                	jmp    80100310 <consoleread+0x50>
80100351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100358:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010035f:	e8 7c 3f 00 00       	call   801042e0 <release>
        ilock(ip);
80100364:	89 34 24             	mov    %esi,(%esp)
80100367:	e8 44 16 00 00       	call   801019b0 <ilock>
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010036c:	83 c4 2c             	add    $0x2c,%esp
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
8010036f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100379:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010037c:	76 05                	jbe    80100383 <consoleread+0xc3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010037e:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100386:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100388:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010038f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100392:	e8 49 3f 00 00       	call   801042e0 <release>
  ilock(ip);
80100397:	89 34 24             	mov    %esi,(%esp)
8010039a:	e8 11 16 00 00       	call   801019b0 <ilock>
8010039f:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
801003a2:	83 c4 2c             	add    $0x2c,%esp
801003a5:	5b                   	pop    %ebx
801003a6:	5e                   	pop    %esi
801003a7:	5f                   	pop    %edi
801003a8:	5d                   	pop    %ebp
801003a9:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801003aa:	31 c0                	xor    %eax,%eax
801003ac:	eb da                	jmp    80100388 <consoleread+0xc8>
801003ae:	66 90                	xchg   %ax,%ax

801003b0 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
801003b0:	55                   	push   %ebp
801003b1:	89 e5                	mov    %esp,%ebp
801003b3:	56                   	push   %esi
801003b4:	53                   	push   %ebx
801003b5:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
801003b8:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
801003bf:	00 00 00 
}

static inline void
cli(void)
{
  asm volatile("cli");
801003c2:	fa                   	cli    
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801003c3:	e8 78 23 00 00       	call   80102740 <lapicid>
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
801003c8:	8d 75 d0             	lea    -0x30(%ebp),%esi
801003cb:	31 db                	xor    %ebx,%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801003cd:	c7 04 24 b5 6f 10 80 	movl   $0x80106fb5,(%esp)
801003d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003d8:	e8 73 04 00 00       	call   80100850 <cprintf>
  cprintf(s);
801003dd:	8b 45 08             	mov    0x8(%ebp),%eax
801003e0:	89 04 24             	mov    %eax,(%esp)
801003e3:	e8 68 04 00 00       	call   80100850 <cprintf>
  cprintf("\n");
801003e8:	c7 04 24 25 79 10 80 	movl   $0x80107925,(%esp)
801003ef:	e8 5c 04 00 00       	call   80100850 <cprintf>
  getcallerpcs(&s, pcs);
801003f4:	8d 45 08             	lea    0x8(%ebp),%eax
801003f7:	89 74 24 04          	mov    %esi,0x4(%esp)
801003fb:	89 04 24             	mov    %eax,(%esp)
801003fe:	e8 9d 3d 00 00       	call   801041a0 <getcallerpcs>
80100403:	90                   	nop
80100404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
80100408:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010040b:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
8010040e:	c7 04 24 c9 6f 10 80 	movl   $0x80106fc9,(%esp)
80100415:	89 44 24 04          	mov    %eax,0x4(%esp)
80100419:	e8 32 04 00 00       	call   80100850 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010041e:	83 fb 0a             	cmp    $0xa,%ebx
80100421:	75 e5                	jne    80100408 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100423:	c7 05 20 a5 10 80 01 	movl   $0x1,0x8010a520
8010042a:	00 00 00 
8010042d:	eb fe                	jmp    8010042d <panic+0x7d>
8010042f:	90                   	nop

80100430 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100430:	55                   	push   %ebp
80100431:	89 e5                	mov    %esp,%ebp
80100433:	57                   	push   %edi
80100434:	56                   	push   %esi
80100435:	89 c6                	mov    %eax,%esi
80100437:	53                   	push   %ebx
80100438:	83 ec 1c             	sub    $0x1c,%esp
  if(panicked){
8010043b:	83 3d 20 a5 10 80 00 	cmpl   $0x0,0x8010a520
80100442:	74 03                	je     80100447 <consputc+0x17>
80100444:	fa                   	cli    
80100445:	eb fe                	jmp    80100445 <consputc+0x15>
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
80100447:	3d 00 01 00 00       	cmp    $0x100,%eax
8010044c:	0f 84 ac 00 00 00    	je     801004fe <consputc+0xce>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100452:	89 04 24             	mov    %eax,(%esp)
80100455:	e8 26 56 00 00       	call   80105a80 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
8010045f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100464:	89 ca                	mov    %ecx,%edx
80100466:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	bf d5 03 00 00       	mov    $0x3d5,%edi
8010046c:	89 fa                	mov    %edi,%edx
8010046e:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
8010046f:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100472:	89 ca                	mov    %ecx,%edx
80100474:	c1 e3 08             	shl    $0x8,%ebx
80100477:	b8 0f 00 00 00       	mov    $0xf,%eax
8010047c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010047d:	89 fa                	mov    %edi,%edx
8010047f:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100480:	0f b6 c0             	movzbl %al,%eax
80100483:	09 c3                	or     %eax,%ebx

  if(c == '\n')
80100485:	83 fe 0a             	cmp    $0xa,%esi
80100488:	0f 84 fb 00 00 00    	je     80100589 <consputc+0x159>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
8010048e:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100494:	0f 84 e1 00 00 00    	je     8010057b <consputc+0x14b>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010049a:	66 81 e6 ff 00       	and    $0xff,%si
8010049f:	66 81 ce 00 07       	or     $0x700,%si
801004a4:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
801004ab:	80 
801004ac:	83 c3 01             	add    $0x1,%ebx

  if(pos < 0 || pos > 25*80)
801004af:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004b5:	0f 87 b4 00 00 00    	ja     8010056f <consputc+0x13f>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
801004bb:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004c1:	8d bc 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edi
801004c8:	7f 5d                	jg     80100527 <consputc+0xf7>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ca:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801004cf:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d4:	89 ca                	mov    %ecx,%edx
801004d6:	ee                   	out    %al,(%dx)
801004d7:	be d5 03 00 00       	mov    $0x3d5,%esi
801004dc:	89 d8                	mov    %ebx,%eax
801004de:	c1 f8 08             	sar    $0x8,%eax
801004e1:	89 f2                	mov    %esi,%edx
801004e3:	ee                   	out    %al,(%dx)
801004e4:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e9:	89 ca                	mov    %ecx,%edx
801004eb:	ee                   	out    %al,(%dx)
801004ec:	89 d8                	mov    %ebx,%eax
801004ee:	89 f2                	mov    %esi,%edx
801004f0:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004f1:	66 c7 07 20 07       	movw   $0x720,(%edi)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004f6:	83 c4 1c             	add    $0x1c,%esp
801004f9:	5b                   	pop    %ebx
801004fa:	5e                   	pop    %esi
801004fb:	5f                   	pop    %edi
801004fc:	5d                   	pop    %ebp
801004fd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100505:	e8 76 55 00 00       	call   80105a80 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 55 00 00       	call   80105a80 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 55 00 00       	call   80105a80 <uartputc>
80100522:	e9 33 ff ff ff       	jmp    8010045a <consputc+0x2a>
  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
80100527:	83 eb 50             	sub    $0x50,%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010052a:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
80100531:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100532:	8d bc 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100539:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
80100540:	80 
80100541:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100548:	e8 13 3f 00 00       	call   80104460 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010054d:	b8 80 07 00 00       	mov    $0x780,%eax
80100552:	29 d8                	sub    %ebx,%eax
80100554:	01 c0                	add    %eax,%eax
80100556:	89 44 24 08          	mov    %eax,0x8(%esp)
8010055a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100561:	00 
80100562:	89 3c 24             	mov    %edi,(%esp)
80100565:	e8 36 3e 00 00       	call   801043a0 <memset>
8010056a:	e9 5b ff ff ff       	jmp    801004ca <consputc+0x9a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010056f:	c7 04 24 cd 6f 10 80 	movl   $0x80106fcd,(%esp)
80100576:	e8 35 fe ff ff       	call   801003b0 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010057b:	31 c0                	xor    %eax,%eax
8010057d:	85 db                	test   %ebx,%ebx
8010057f:	0f 9f c0             	setg   %al
80100582:	29 c3                	sub    %eax,%ebx
80100584:	e9 26 ff ff ff       	jmp    801004af <consputc+0x7f>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100589:	89 da                	mov    %ebx,%edx
8010058b:	89 d8                	mov    %ebx,%eax
8010058d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100592:	83 c3 50             	add    $0x50,%ebx
80100595:	c1 fa 1f             	sar    $0x1f,%edx
80100598:	f7 f9                	idiv   %ecx
8010059a:	29 d3                	sub    %edx,%ebx
8010059c:	e9 0e ff ff ff       	jmp    801004af <consputc+0x7f>
801005a1:	eb 0d                	jmp    801005b0 <consolewrite>
801005a3:	90                   	nop
801005a4:	90                   	nop
801005a5:	90                   	nop
801005a6:	90                   	nop
801005a7:	90                   	nop
801005a8:	90                   	nop
801005a9:	90                   	nop
801005aa:	90                   	nop
801005ab:	90                   	nop
801005ac:	90                   	nop
801005ad:	90                   	nop
801005ae:	90                   	nop
801005af:	90                   	nop

801005b0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005bc:	8b 75 10             	mov    0x10(%ebp),%esi
801005bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
801005c2:	89 04 24             	mov    %eax,(%esp)
801005c5:	e8 16 17 00 00       	call   80101ce0 <iunlock>
  acquire(&cons.lock);
801005ca:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801005d1:	e8 5a 3d 00 00       	call   80104330 <acquire>
  for(i = 0; i < n; i++)
801005d6:	85 f6                	test   %esi,%esi
801005d8:	7e 16                	jle    801005f0 <consolewrite+0x40>
801005da:	31 db                	xor    %ebx,%ebx
801005dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
801005e0:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005e4:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
801005e7:	e8 44 fe ff ff       	call   80100430 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005ec:	39 de                	cmp    %ebx,%esi
801005ee:	7f f0                	jg     801005e0 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
801005f0:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801005f7:	e8 e4 3c 00 00       	call   801042e0 <release>
  ilock(ip);
801005fc:	8b 45 08             	mov    0x8(%ebp),%eax
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 a9 13 00 00       	call   801019b0 <ilock>

  return n;
}
80100607:	83 c4 1c             	add    $0x1c,%esp
8010060a:	89 f0                	mov    %esi,%eax
8010060c:	5b                   	pop    %ebx
8010060d:	5e                   	pop    %esi
8010060e:	5f                   	pop    %edi
8010060f:	5d                   	pop    %ebp
80100610:	c3                   	ret    
80100611:	eb 0d                	jmp    80100620 <consoleintr>
80100613:	90                   	nop
80100614:	90                   	nop
80100615:	90                   	nop
80100616:	90                   	nop
80100617:	90                   	nop
80100618:	90                   	nop
80100619:	90                   	nop
8010061a:	90                   	nop
8010061b:	90                   	nop
8010061c:	90                   	nop
8010061d:	90                   	nop
8010061e:	90                   	nop
8010061f:	90                   	nop

80100620 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
  int c, doprocdump = 0;

  acquire(&cons.lock);
80100624:	31 ff                	xor    %edi,%edi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100626:	56                   	push   %esi
80100627:	53                   	push   %ebx
80100628:	83 ec 1c             	sub    $0x1c,%esp
8010062b:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, doprocdump = 0;

  acquire(&cons.lock);
8010062e:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
80100635:	e8 f6 3c 00 00       	call   80104330 <acquire>
8010063a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
80100640:	ff d6                	call   *%esi
80100642:	85 c0                	test   %eax,%eax
80100644:	89 c3                	mov    %eax,%ebx
80100646:	0f 88 98 00 00 00    	js     801006e4 <consoleintr+0xc4>
    switch(c){
8010064c:	83 fb 10             	cmp    $0x10,%ebx
8010064f:	90                   	nop
80100650:	0f 84 32 01 00 00    	je     80100788 <consoleintr+0x168>
80100656:	0f 8f a4 00 00 00    	jg     80100700 <consoleintr+0xe0>
8010065c:	83 fb 08             	cmp    $0x8,%ebx
8010065f:	90                   	nop
80100660:	0f 84 a8 00 00 00    	je     8010070e <consoleintr+0xee>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100666:	85 db                	test   %ebx,%ebx
80100668:	74 d6                	je     80100640 <consoleintr+0x20>
8010066a:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010066f:	89 c2                	mov    %eax,%edx
80100671:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100677:	83 fa 7f             	cmp    $0x7f,%edx
8010067a:	77 c4                	ja     80100640 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
8010067c:	83 fb 0d             	cmp    $0xd,%ebx
8010067f:	0f 84 0d 01 00 00    	je     80100792 <consoleintr+0x172>
        input.buf[input.e++ % INPUT_BUF] = c;
80100685:	89 c2                	mov    %eax,%edx
80100687:	83 c0 01             	add    $0x1,%eax
8010068a:	83 e2 7f             	and    $0x7f,%edx
8010068d:	88 9a 40 ff 10 80    	mov    %bl,-0x7fef00c0(%edx)
80100693:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(c);
80100698:	89 d8                	mov    %ebx,%eax
8010069a:	e8 91 fd ff ff       	call   80100430 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010069f:	83 fb 04             	cmp    $0x4,%ebx
801006a2:	0f 84 08 01 00 00    	je     801007b0 <consoleintr+0x190>
801006a8:	83 fb 0a             	cmp    $0xa,%ebx
801006ab:	0f 84 ff 00 00 00    	je     801007b0 <consoleintr+0x190>
801006b1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801006b7:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801006bc:	83 ea 80             	sub    $0xffffff80,%edx
801006bf:	39 d0                	cmp    %edx,%eax
801006c1:	0f 85 79 ff ff ff    	jne    80100640 <consoleintr+0x20>
          input.w = input.e;
801006c7:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801006cc:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
801006d3:	e8 e8 2f 00 00       	call   801036c0 <wakeup>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801006d8:	ff d6                	call   *%esi
801006da:	85 c0                	test   %eax,%eax
801006dc:	89 c3                	mov    %eax,%ebx
801006de:	0f 89 68 ff ff ff    	jns    8010064c <consoleintr+0x2c>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801006e4:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801006eb:	e8 f0 3b 00 00       	call   801042e0 <release>
  if(doprocdump) {
801006f0:	85 ff                	test   %edi,%edi
801006f2:	0f 85 c2 00 00 00    	jne    801007ba <consoleintr+0x19a>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100700:	83 fb 15             	cmp    $0x15,%ebx
80100703:	74 33                	je     80100738 <consoleintr+0x118>
80100705:	83 fb 7f             	cmp    $0x7f,%ebx
80100708:	0f 85 58 ff ff ff    	jne    80100666 <consoleintr+0x46>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010070e:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100713:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100719:	0f 84 21 ff ff ff    	je     80100640 <consoleintr+0x20>
        input.e--;
8010071f:	83 e8 01             	sub    $0x1,%eax
80100722:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100727:	b8 00 01 00 00       	mov    $0x100,%eax
8010072c:	e8 ff fc ff ff       	call   80100430 <consputc>
80100731:	e9 0a ff ff ff       	jmp    80100640 <consoleintr+0x20>
80100736:	66 90                	xchg   %ax,%ax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100738:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010073d:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100743:	75 2b                	jne    80100770 <consoleintr+0x150>
80100745:	e9 f6 fe ff ff       	jmp    80100640 <consoleintr+0x20>
8010074a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100750:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100755:	b8 00 01 00 00       	mov    $0x100,%eax
8010075a:	e8 d1 fc ff ff       	call   80100430 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010075f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100764:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010076a:	0f 84 d0 fe ff ff    	je     80100640 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100770:	83 e8 01             	sub    $0x1,%eax
80100773:	89 c2                	mov    %eax,%edx
80100775:	83 e2 7f             	and    $0x7f,%edx
80100778:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010077f:	75 cf                	jne    80100750 <consoleintr+0x130>
80100781:	e9 ba fe ff ff       	jmp    80100640 <consoleintr+0x20>
80100786:	66 90                	xchg   %ax,%ax
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100788:	bf 01 00 00 00       	mov    $0x1,%edi
8010078d:	e9 ae fe ff ff       	jmp    80100640 <consoleintr+0x20>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
80100792:	89 c2                	mov    %eax,%edx
80100794:	83 c0 01             	add    $0x1,%eax
80100797:	83 e2 7f             	and    $0x7f,%edx
8010079a:	c6 82 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%edx)
801007a1:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(c);
801007a6:	b8 0a 00 00 00       	mov    $0xa,%eax
801007ab:	e8 80 fc ff ff       	call   80100430 <consputc>
801007b0:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801007b5:	e9 0d ff ff ff       	jmp    801006c7 <consoleintr+0xa7>
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801007ba:	83 c4 1c             	add    $0x1c,%esp
801007bd:	5b                   	pop    %ebx
801007be:	5e                   	pop    %esi
801007bf:	5f                   	pop    %edi
801007c0:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
801007c1:	e9 9a 2d 00 00       	jmp    80103560 <procdump>
801007c6:	8d 76 00             	lea    0x0(%esi),%esi
801007c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007d0 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	57                   	push   %edi
801007d4:	56                   	push   %esi
801007d5:	89 d6                	mov    %edx,%esi
801007d7:	53                   	push   %ebx
801007d8:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801007db:	85 c9                	test   %ecx,%ecx
801007dd:	74 04                	je     801007e3 <printint+0x13>
801007df:	85 c0                	test   %eax,%eax
801007e1:	78 55                	js     80100838 <printint+0x68>
    x = -xx;
  else
    x = xx;
801007e3:	31 ff                	xor    %edi,%edi
801007e5:	31 c9                	xor    %ecx,%ecx
801007e7:	8d 5d d8             	lea    -0x28(%ebp),%ebx
801007ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  i = 0;
  do{
    buf[i++] = digits[x % base];
801007f0:	31 d2                	xor    %edx,%edx
801007f2:	f7 f6                	div    %esi
801007f4:	0f b6 92 f0 6f 10 80 	movzbl -0x7fef9010(%edx),%edx
801007fb:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
801007fe:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
80100801:	85 c0                	test   %eax,%eax
80100803:	75 eb                	jne    801007f0 <printint+0x20>

  if(sign)
80100805:	85 ff                	test   %edi,%edi
80100807:	74 08                	je     80100811 <printint+0x41>
    buf[i++] = '-';
80100809:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
8010080e:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
80100811:	8d 71 ff             	lea    -0x1(%ecx),%esi
80100814:	01 f3                	add    %esi,%ebx
80100816:	66 90                	xchg   %ax,%ax
    consputc(buf[i]);
80100818:	0f be 03             	movsbl (%ebx),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010081b:	83 ee 01             	sub    $0x1,%esi
8010081e:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
80100821:	e8 0a fc ff ff       	call   80100430 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100826:	83 fe ff             	cmp    $0xffffffff,%esi
80100829:	75 ed                	jne    80100818 <printint+0x48>
    consputc(buf[i]);
}
8010082b:	83 c4 1c             	add    $0x1c,%esp
8010082e:	5b                   	pop    %ebx
8010082f:	5e                   	pop    %esi
80100830:	5f                   	pop    %edi
80100831:	5d                   	pop    %ebp
80100832:	c3                   	ret    
80100833:	90                   	nop
80100834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
80100838:	f7 d8                	neg    %eax
8010083a:	bf 01 00 00 00       	mov    $0x1,%edi
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010083f:	eb a4                	jmp    801007e5 <printint+0x15>
80100841:	eb 0d                	jmp    80100850 <cprintf>
80100843:	90                   	nop
80100844:	90                   	nop
80100845:	90                   	nop
80100846:	90                   	nop
80100847:	90                   	nop
80100848:	90                   	nop
80100849:	90                   	nop
8010084a:	90                   	nop
8010084b:	90                   	nop
8010084c:	90                   	nop
8010084d:	90                   	nop
8010084e:	90                   	nop
8010084f:	90                   	nop

80100850 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100850:	55                   	push   %ebp
80100851:	89 e5                	mov    %esp,%ebp
80100853:	57                   	push   %edi
80100854:	56                   	push   %esi
80100855:	53                   	push   %ebx
80100856:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100859:	8b 3d 74 a5 10 80    	mov    0x8010a574,%edi
  if(locking)
8010085f:	85 ff                	test   %edi,%edi
80100861:	0f 85 39 01 00 00    	jne    801009a0 <cprintf+0x150>
    acquire(&cons.lock);

  if (fmt == 0)
80100867:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010086a:	85 c9                	test   %ecx,%ecx
8010086c:	0f 84 3f 01 00 00    	je     801009b1 <cprintf+0x161>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100872:	0f b6 01             	movzbl (%ecx),%eax
80100875:	85 c0                	test   %eax,%eax
80100877:	0f 84 93 00 00 00    	je     80100910 <cprintf+0xc0>
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
8010087d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100880:	31 db                	xor    %ebx,%ebx
80100882:	eb 3f                	jmp    801008c3 <cprintf+0x73>
80100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100888:	83 fa 25             	cmp    $0x25,%edx
8010088b:	0f 84 b7 00 00 00    	je     80100948 <cprintf+0xf8>
80100891:	83 fa 64             	cmp    $0x64,%edx
80100894:	0f 84 8e 00 00 00    	je     80100928 <cprintf+0xd8>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010089a:	b8 25 00 00 00       	mov    $0x25,%eax
8010089f:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008a2:	e8 89 fb ff ff       	call   80100430 <consputc>
      consputc(c);
801008a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008aa:	89 d0                	mov    %edx,%eax
801008ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008b0:	e8 7b fb ff ff       	call   80100430 <consputc>
801008b5:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008b8:	83 c3 01             	add    $0x1,%ebx
801008bb:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
801008bf:	85 c0                	test   %eax,%eax
801008c1:	74 4d                	je     80100910 <cprintf+0xc0>
    if(c != '%'){
801008c3:	83 f8 25             	cmp    $0x25,%eax
801008c6:	75 e8                	jne    801008b0 <cprintf+0x60>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801008c8:	83 c3 01             	add    $0x1,%ebx
801008cb:	0f b6 14 19          	movzbl (%ecx,%ebx,1),%edx
    if(c == 0)
801008cf:	85 d2                	test   %edx,%edx
801008d1:	74 3d                	je     80100910 <cprintf+0xc0>
      break;
    switch(c){
801008d3:	83 fa 70             	cmp    $0x70,%edx
801008d6:	74 12                	je     801008ea <cprintf+0x9a>
801008d8:	7e ae                	jle    80100888 <cprintf+0x38>
801008da:	83 fa 73             	cmp    $0x73,%edx
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
801008e0:	74 7e                	je     80100960 <cprintf+0x110>
801008e2:	83 fa 78             	cmp    $0x78,%edx
801008e5:	8d 76 00             	lea    0x0(%esi),%esi
801008e8:	75 b0                	jne    8010089a <cprintf+0x4a>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801008ea:	8b 06                	mov    (%esi),%eax
801008ec:	31 c9                	xor    %ecx,%ecx
801008ee:	ba 10 00 00 00       	mov    $0x10,%edx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008f3:	83 c3 01             	add    $0x1,%ebx
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801008f6:	83 c6 04             	add    $0x4,%esi
801008f9:	e8 d2 fe ff ff       	call   801007d0 <printint>
801008fe:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100901:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
80100905:	85 c0                	test   %eax,%eax
80100907:	75 ba                	jne    801008c3 <cprintf+0x73>
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc(c);
      break;
    }
  }

  if(locking)
80100910:	85 ff                	test   %edi,%edi
80100912:	74 0c                	je     80100920 <cprintf+0xd0>
    release(&cons.lock);
80100914:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
8010091b:	e8 c0 39 00 00       	call   801042e0 <release>
}
80100920:	83 c4 2c             	add    $0x2c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
80100927:	c3                   	ret    
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
80100928:	8b 06                	mov    (%esi),%eax
8010092a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010092f:	ba 0a 00 00 00       	mov    $0xa,%edx
80100934:	83 c6 04             	add    $0x4,%esi
80100937:	e8 94 fe ff ff       	call   801007d0 <printint>
8010093c:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
8010093f:	e9 74 ff ff ff       	jmp    801008b8 <cprintf+0x68>
80100944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100948:	b8 25 00 00 00       	mov    $0x25,%eax
8010094d:	e8 de fa ff ff       	call   80100430 <consputc>
80100952:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
80100955:	e9 5e ff ff ff       	jmp    801008b8 <cprintf+0x68>
8010095a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100960:	8b 16                	mov    (%esi),%edx
80100962:	b8 e9 6f 10 80       	mov    $0x80106fe9,%eax
80100967:	83 c6 04             	add    $0x4,%esi
8010096a:	85 d2                	test   %edx,%edx
8010096c:	0f 44 d0             	cmove  %eax,%edx
        s = "(null)";
      for(; *s; s++)
8010096f:	0f b6 02             	movzbl (%edx),%eax
80100972:	84 c0                	test   %al,%al
80100974:	0f 84 3e ff ff ff    	je     801008b8 <cprintf+0x68>
8010097a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010097d:	89 d3                	mov    %edx,%ebx
8010097f:	90                   	nop
        consputc(*s);
80100980:	0f be c0             	movsbl %al,%eax
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100983:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100986:	e8 a5 fa ff ff       	call   80100430 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010098b:	0f b6 03             	movzbl (%ebx),%eax
8010098e:	84 c0                	test   %al,%al
80100990:	75 ee                	jne    80100980 <cprintf+0x130>
80100992:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100995:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100998:	e9 1b ff ff ff       	jmp    801008b8 <cprintf+0x68>
8010099d:	8d 76 00             	lea    0x0(%esi),%esi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801009a0:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801009a7:	e8 84 39 00 00       	call   80104330 <acquire>
801009ac:	e9 b6 fe ff ff       	jmp    80100867 <cprintf+0x17>

  if (fmt == 0)
    panic("null fmt");
801009b1:	c7 04 24 e0 6f 10 80 	movl   $0x80106fe0,(%esp)
801009b8:	e8 f3 f9 ff ff       	call   801003b0 <panic>
801009bd:	66 90                	xchg   %ax,%ax
801009bf:	90                   	nop

801009c0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	57                   	push   %edi
801009c4:	56                   	push   %esi
801009c5:	53                   	push   %ebx
801009c6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009cc:	e8 df 30 00 00       	call   80103ab0 <myproc>
801009d1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801009d7:	e8 44 23 00 00       	call   80102d20 <begin_op>

  if((ip = namei(path)) == 0){
801009dc:	8b 45 08             	mov    0x8(%ebp),%eax
801009df:	89 04 24             	mov    %eax,(%esp)
801009e2:	e8 f9 14 00 00       	call   80101ee0 <namei>
801009e7:	85 c0                	test   %eax,%eax
801009e9:	89 c7                	mov    %eax,%edi
801009eb:	0f 84 34 03 00 00    	je     80100d25 <exec+0x365>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009f1:	89 04 24             	mov    %eax,(%esp)
801009f4:	e8 b7 0f 00 00       	call   801019b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009f9:	8d 45 94             	lea    -0x6c(%ebp),%eax
801009fc:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100a03:	00 
80100a04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100a0b:	00 
80100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a10:	89 3c 24             	mov    %edi,(%esp)
80100a13:	e8 08 0d 00 00       	call   80101720 <readi>
80100a18:	83 f8 34             	cmp    $0x34,%eax
80100a1b:	0f 85 f7 01 00 00    	jne    80100c18 <exec+0x258>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a21:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
80100a28:	0f 85 ea 01 00 00    	jne    80100c18 <exec+0x258>
80100a2e:	66 90                	xchg   %ax,%ax
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a30:	e8 cb 5f 00 00       	call   80106a00 <setupkvm>
80100a35:	85 c0                	test   %eax,%eax
80100a37:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a3d:	0f 84 d5 01 00 00    	je     80100c18 <exec+0x258>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a43:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
80100a48:	8b 5d b0             	mov    -0x50(%ebp),%ebx
80100a4b:	0f 84 c8 02 00 00    	je     80100d19 <exec+0x359>
80100a51:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a58:	00 00 00 
80100a5b:	31 f6                	xor    %esi,%esi
80100a5d:	eb 13                	jmp    80100a72 <exec+0xb2>
80100a5f:	90                   	nop
80100a60:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80100a64:	83 c6 01             	add    $0x1,%esi
80100a67:	39 f0                	cmp    %esi,%eax
80100a69:	0f 8e c1 00 00 00    	jle    80100b30 <exec+0x170>
80100a6f:	83 c3 20             	add    $0x20,%ebx
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a72:	8d 55 c8             	lea    -0x38(%ebp),%edx
80100a75:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a7c:	00 
80100a7d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100a81:	89 54 24 04          	mov    %edx,0x4(%esp)
80100a85:	89 3c 24             	mov    %edi,(%esp)
80100a88:	e8 93 0c 00 00       	call   80101720 <readi>
80100a8d:	83 f8 20             	cmp    $0x20,%eax
80100a90:	75 76                	jne    80100b08 <exec+0x148>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a92:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
80100a96:	75 c8                	jne    80100a60 <exec+0xa0>
      continue;
    if(ph.memsz < ph.filesz)
80100a98:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a9b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100a9e:	66 90                	xchg   %ax,%ax
80100aa0:	72 66                	jb     80100b08 <exec+0x148>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aa2:	03 45 d0             	add    -0x30(%ebp),%eax
80100aa5:	72 61                	jb     80100b08 <exec+0x148>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aa7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100aab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100ab1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ab7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100abb:	89 04 24             	mov    %eax,(%esp)
80100abe:	e8 dd 60 00 00       	call   80106ba0 <allocuvm>
80100ac3:	85 c0                	test   %eax,%eax
80100ac5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100acb:	74 3b                	je     80100b08 <exec+0x148>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100acd:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ad0:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ad5:	75 31                	jne    80100b08 <exec+0x148>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ad7:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100ada:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100ade:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ae2:	89 54 24 10          	mov    %edx,0x10(%esp)
80100ae6:	8b 55 cc             	mov    -0x34(%ebp),%edx
80100ae9:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100aed:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100af3:	89 14 24             	mov    %edx,(%esp)
80100af6:	e8 d5 61 00 00       	call   80106cd0 <loaduvm>
80100afb:	85 c0                	test   %eax,%eax
80100afd:	0f 89 5d ff ff ff    	jns    80100a60 <exec+0xa0>
80100b03:	90                   	nop
80100b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b08:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b0e:	89 04 24             	mov    %eax,(%esp)
80100b11:	e8 6a 5e 00 00       	call   80106980 <freevm>
  if(ip){
80100b16:	85 ff                	test   %edi,%edi
80100b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1d:	0f 85 f5 00 00 00    	jne    80100c18 <exec+0x258>
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100b23:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100b29:	5b                   	pop    %ebx
80100b2a:	5e                   	pop    %esi
80100b2b:	5f                   	pop    %edi
80100b2c:	5d                   	pop    %ebp
80100b2d:	c3                   	ret    
80100b2e:	66 90                	xchg   %ax,%ax
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b30:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100b36:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80100b3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80100b42:	8d b3 00 20 00 00    	lea    0x2000(%ebx),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b48:	89 3c 24             	mov    %edi,(%esp)
80100b4b:	e8 e0 11 00 00       	call   80101d30 <iunlockput>
  end_op();
80100b50:	e8 9b 20 00 00       	call   80102bf0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b5b:	89 74 24 08          	mov    %esi,0x8(%esp)
80100b5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100b63:	89 0c 24             	mov    %ecx,(%esp)
80100b66:	e8 35 60 00 00       	call   80106ba0 <allocuvm>
80100b6b:	85 c0                	test   %eax,%eax
80100b6d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b73:	0f 84 96 00 00 00    	je     80100c0f <exec+0x24f>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b79:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b82:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b88:	89 04 24             	mov    %eax,(%esp)
80100b8b:	e8 e0 5b 00 00       	call   80106770 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b90:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b93:	8b 02                	mov    (%edx),%eax
80100b95:	85 c0                	test   %eax,%eax
80100b97:	0f 84 a1 01 00 00    	je     80100d3e <exec+0x37e>
80100b9d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ba0:	31 f6                	xor    %esi,%esi
80100ba2:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100ba8:	eb 28                	jmp    80100bd2 <exec+0x212>
80100baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bb0:	89 9c b5 10 ff ff ff 	mov    %ebx,-0xf0(%ebp,%esi,4)
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bba:	83 c6 01             	add    $0x1,%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bbd:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100bc3:	8d 3c b0             	lea    (%eax,%esi,4),%edi
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bc6:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 67                	je     80100c34 <exec+0x274>
    if(argc >= MAXARG)
80100bcd:	83 fe 20             	cmp    $0x20,%esi
80100bd0:	74 3d                	je     80100c0f <exec+0x24f>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd2:	89 04 24             	mov    %eax,(%esp)
80100bd5:	e8 e6 39 00 00       	call   801045c0 <strlen>
80100bda:	f7 d0                	not    %eax
80100bdc:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bdf:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be1:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100be4:	89 04 24             	mov    %eax,(%esp)
80100be7:	e8 d4 39 00 00       	call   801045c0 <strlen>
80100bec:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bf2:	83 c0 01             	add    $0x1,%eax
80100bf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bf9:	8b 07                	mov    (%edi),%eax
80100bfb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bff:	89 0c 24             	mov    %ecx,(%esp)
80100c02:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c06:	e8 c5 5a 00 00       	call   801066d0 <copyout>
80100c0b:	85 c0                	test   %eax,%eax
80100c0d:	79 a1                	jns    80100bb0 <exec+0x1f0>
 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
80100c0f:	31 ff                	xor    %edi,%edi
80100c11:	e9 f2 fe ff ff       	jmp    80100b08 <exec+0x148>
80100c16:	66 90                	xchg   %ax,%ax

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c18:	89 3c 24             	mov    %edi,(%esp)
80100c1b:	90                   	nop
80100c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c20:	e8 0b 11 00 00       	call   80101d30 <iunlockput>
    end_op();
80100c25:	e8 c6 1f 00 00       	call   80102bf0 <end_op>
80100c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2f:	e9 ef fe ff ff       	jmp    80100b23 <exec+0x163>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c34:	8d 4e 03             	lea    0x3(%esi),%ecx
80100c37:	8d 3c b5 04 00 00 00 	lea    0x4(,%esi,4),%edi
80100c3e:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c45:	c7 84 8d 04 ff ff ff 	movl   $0x0,-0xfc(%ebp,%ecx,4)
80100c4c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c50:	89 d9                	mov    %ebx,%ecx

  sp -= (3+argc+1) * 4;
80100c52:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c54:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5e:	29 f9                	sub    %edi,%ecx
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c60:	c7 85 04 ff ff ff ff 	movl   $0xffffffff,-0xfc(%ebp)
80100c67:	ff ff ff 
  ustack[1] = argc;
80100c6a:	89 b5 08 ff ff ff    	mov    %esi,-0xf8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c70:	89 8d 0c ff ff ff    	mov    %ecx,-0xf4(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c76:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c7a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c7e:	89 04 24             	mov    %eax,(%esp)
80100c81:	e8 4a 5a 00 00       	call   801066d0 <copyout>
80100c86:	85 c0                	test   %eax,%eax
80100c88:	78 85                	js     80100c0f <exec+0x24f>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c8d:	0f b6 11             	movzbl (%ecx),%edx
80100c90:	84 d2                	test   %dl,%dl
80100c92:	74 1c                	je     80100cb0 <exec+0x2f0>
80100c94:	89 c8                	mov    %ecx,%eax
80100c96:	83 c0 01             	add    $0x1,%eax
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(*s == '/')
80100ca0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
80100ca6:	0f 44 c8             	cmove  %eax,%ecx
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca9:	83 c0 01             	add    $0x1,%eax
80100cac:	84 d2                	test   %dl,%dl
80100cae:	75 f0                	jne    80100ca0 <exec+0x2e0>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cb0:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100cba:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc1:	00 
80100cc2:	83 c0 6c             	add    $0x6c,%eax
80100cc5:	89 04 24             	mov    %eax,(%esp)
80100cc8:	e8 b3 38 00 00       	call   80104580 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ccd:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100cd3:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cd9:	8b 70 04             	mov    0x4(%eax),%esi
  curproc->pgdir = pgdir;
80100cdc:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100cdf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100ce5:	89 08                	mov    %ecx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ce7:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100ced:	8b 42 18             	mov    0x18(%edx),%eax
80100cf0:	8b 55 ac             	mov    -0x54(%ebp),%edx
80100cf3:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cf6:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cfc:	8b 41 18             	mov    0x18(%ecx),%eax
80100cff:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d02:	89 0c 24             	mov    %ecx,(%esp)
80100d05:	e8 86 60 00 00       	call   80106d90 <switchuvm>
  freevm(oldpgdir);
80100d0a:	89 34 24             	mov    %esi,(%esp)
80100d0d:	e8 6e 5c 00 00       	call   80106980 <freevm>
80100d12:	31 c0                	xor    %eax,%eax
  return 0;
80100d14:	e9 0a fe ff ff       	jmp    80100b23 <exec+0x163>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d19:	be 00 20 00 00       	mov    $0x2000,%esi
80100d1e:	31 db                	xor    %ebx,%ebx
80100d20:	e9 23 fe ff ff       	jmp    80100b48 <exec+0x188>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100d25:	e8 c6 1e 00 00       	call   80102bf0 <end_op>
    cprintf("exec: fail\n");
80100d2a:	c7 04 24 01 70 10 80 	movl   $0x80107001,(%esp)
80100d31:	e8 1a fb ff ff       	call   80100850 <cprintf>
80100d36:	83 c8 ff             	or     $0xffffffff,%eax
    return -1;
80100d39:	e9 e5 fd ff ff       	jmp    80100b23 <exec+0x163>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d3e:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100d44:	b0 10                	mov    $0x10,%al
80100d46:	bf 04 00 00 00       	mov    $0x4,%edi
80100d4b:	b9 03 00 00 00       	mov    $0x3,%ecx
80100d50:	31 f6                	xor    %esi,%esi
80100d52:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
80100d58:	e9 e8 fe ff ff       	jmp    80100c45 <exec+0x285>
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	57                   	push   %edi
80100d64:	56                   	push   %esi
80100d65:	53                   	push   %ebx
80100d66:	83 ec 2c             	sub    $0x2c,%esp
80100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d72:	8b 45 10             	mov    0x10(%ebp),%eax
80100d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100d78:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100d7c:	0f 84 ae 00 00 00    	je     80100e30 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100d82:	8b 03                	mov    (%ebx),%eax
80100d84:	83 f8 01             	cmp    $0x1,%eax
80100d87:	0f 84 c2 00 00 00    	je     80100e4f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100d8d:	83 f8 02             	cmp    $0x2,%eax
80100d90:	0f 85 d7 00 00 00    	jne    80100e6d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d99:	31 f6                	xor    %esi,%esi
80100d9b:	85 c0                	test   %eax,%eax
80100d9d:	7f 31                	jg     80100dd0 <filewrite+0x70>
80100d9f:	90                   	nop
80100da0:	e9 9b 00 00 00       	jmp    80100e40 <filewrite+0xe0>
80100da5:	8d 76 00             	lea    0x0(%esi),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100da8:	8b 53 10             	mov    0x10(%ebx),%edx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100dab:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80100dae:	89 14 24             	mov    %edx,(%esp)
80100db1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100db4:	e8 27 0f 00 00       	call   80101ce0 <iunlock>
      end_op();
80100db9:	e8 32 1e 00 00       	call   80102bf0 <end_op>
80100dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80100dc1:	39 f8                	cmp    %edi,%eax
80100dc3:	0f 85 98 00 00 00    	jne    80100e61 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80100dc9:	01 c6                	add    %eax,%esi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100dcb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100dce:	7e 70                	jle    80100e40 <filewrite+0xe0>
      int n1 = n - i;
80100dd0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100dd3:	b8 00 06 00 00       	mov    $0x600,%eax
80100dd8:	29 f7                	sub    %esi,%edi
80100dda:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80100de0:	0f 4f f8             	cmovg  %eax,%edi
      if(n1 > max)
        n1 = max;

      begin_op();
80100de3:	e8 38 1f 00 00       	call   80102d20 <begin_op>
      ilock(f->ip);
80100de8:	8b 43 10             	mov    0x10(%ebx),%eax
80100deb:	89 04 24             	mov    %eax,(%esp)
80100dee:	e8 bd 0b 00 00       	call   801019b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100df3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100df7:	8b 43 14             	mov    0x14(%ebx),%eax
80100dfa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e01:	01 f0                	add    %esi,%eax
80100e03:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e07:	8b 43 10             	mov    0x10(%ebx),%eax
80100e0a:	89 04 24             	mov    %eax,(%esp)
80100e0d:	e8 ee 07 00 00       	call   80101600 <writei>
80100e12:	85 c0                	test   %eax,%eax
80100e14:	7f 92                	jg     80100da8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80100e16:	8b 53 10             	mov    0x10(%ebx),%edx
80100e19:	89 14 24             	mov    %edx,(%esp)
80100e1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100e1f:	e8 bc 0e 00 00       	call   80101ce0 <iunlock>
      end_op();
80100e24:	e8 c7 1d 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80100e29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	74 91                	je     80100dc1 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100e30:	83 c4 2c             	add    $0x2c,%esp
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e38:	5b                   	pop    %ebx
80100e39:	5e                   	pop    %esi
80100e3a:	5f                   	pop    %edi
80100e3b:	5d                   	pop    %ebp
80100e3c:	c3                   	ret    
80100e3d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100e40:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  }
  panic("filewrite");
80100e43:	89 f0                	mov    %esi,%eax
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100e45:	75 e9                	jne    80100e30 <filewrite+0xd0>
  }
  panic("filewrite");
}
80100e47:	83 c4 2c             	add    $0x2c,%esp
80100e4a:	5b                   	pop    %ebx
80100e4b:	5e                   	pop    %esi
80100e4c:	5f                   	pop    %edi
80100e4d:	5d                   	pop    %ebp
80100e4e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100e4f:	8b 43 0c             	mov    0xc(%ebx),%eax
80100e52:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100e55:	83 c4 2c             	add    $0x2c,%esp
80100e58:	5b                   	pop    %ebx
80100e59:	5e                   	pop    %esi
80100e5a:	5f                   	pop    %edi
80100e5b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100e5c:	e9 8f 24 00 00       	jmp    801032f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80100e61:	c7 04 24 0d 70 10 80 	movl   $0x8010700d,(%esp)
80100e68:	e8 43 f5 ff ff       	call   801003b0 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80100e6d:	c7 04 24 13 70 10 80 	movl   $0x80107013,(%esp)
80100e74:	e8 37 f5 ff ff       	call   801003b0 <panic>
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <fileread>:
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 38             	sub    $0x38,%esp
80100e86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100e8f:	8b 75 0c             	mov    0xc(%ebp),%esi
80100e92:	89 7d fc             	mov    %edi,-0x4(%ebp)
80100e95:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100e98:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e9c:	74 5a                	je     80100ef8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100e9e:	8b 03                	mov    (%ebx),%eax
80100ea0:	83 f8 01             	cmp    $0x1,%eax
80100ea3:	74 5b                	je     80100f00 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ea5:	83 f8 02             	cmp    $0x2,%eax
80100ea8:	75 6d                	jne    80100f17 <fileread+0x97>
    ilock(f->ip);
80100eaa:	8b 43 10             	mov    0x10(%ebx),%eax
80100ead:	89 04 24             	mov    %eax,(%esp)
80100eb0:	e8 fb 0a 00 00       	call   801019b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100eb9:	8b 43 14             	mov    0x14(%ebx),%eax
80100ebc:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ec4:	8b 43 10             	mov    0x10(%ebx),%eax
80100ec7:	89 04 24             	mov    %eax,(%esp)
80100eca:	e8 51 08 00 00       	call   80101720 <readi>
80100ecf:	85 c0                	test   %eax,%eax
80100ed1:	7e 03                	jle    80100ed6 <fileread+0x56>
      f->off += r;
80100ed3:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ed6:	8b 53 10             	mov    0x10(%ebx),%edx
80100ed9:	89 14 24             	mov    %edx,(%esp)
80100edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100edf:	e8 fc 0d 00 00       	call   80101ce0 <iunlock>
    return r;
80100ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100ee7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100eea:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100eed:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100ef0:	89 ec                	mov    %ebp,%esp
80100ef2:	5d                   	pop    %ebp
80100ef3:	c3                   	ret    
80100ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100efd:	eb e8                	jmp    80100ee7 <fileread+0x67>
80100eff:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f00:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f03:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f06:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f09:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f0c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f0f:	89 ec                	mov    %ebp,%esp
80100f11:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f12:	e9 e9 22 00 00       	jmp    80103200 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f17:	c7 04 24 1d 70 10 80 	movl   $0x8010701d,(%esp)
80100f1e:	e8 8d f4 ff ff       	call   801003b0 <panic>
80100f23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f30 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
  if(f->type == FD_INODE){
80100f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f36:	89 e5                	mov    %esp,%ebp
80100f38:	53                   	push   %ebx
80100f39:	83 ec 14             	sub    $0x14,%esp
80100f3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3f:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f42:	74 0c                	je     80100f50 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
80100f44:	83 c4 14             	add    $0x14,%esp
80100f47:	5b                   	pop    %ebx
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
80100f50:	8b 43 10             	mov    0x10(%ebx),%eax
80100f53:	89 04 24             	mov    %eax,(%esp)
80100f56:	e8 55 0a 00 00       	call   801019b0 <ilock>
    stati(f->ip, st);
80100f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f62:	8b 43 10             	mov    0x10(%ebx),%eax
80100f65:	89 04 24             	mov    %eax,(%esp)
80100f68:	e8 e3 01 00 00       	call   80101150 <stati>
    iunlock(f->ip);
80100f6d:	8b 43 10             	mov    0x10(%ebx),%eax
80100f70:	89 04 24             	mov    %eax,(%esp)
80100f73:	e8 68 0d 00 00       	call   80101ce0 <iunlock>
    return 0;
  }
  return -1;
}
80100f78:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
80100f7b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
80100f7d:	5b                   	pop    %ebx
80100f7e:	5d                   	pop    %ebp
80100f7f:	c3                   	ret    

80100f80 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	53                   	push   %ebx
80100f84:	83 ec 14             	sub    $0x14,%esp
80100f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f8a:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100f91:	e8 9a 33 00 00       	call   80104330 <acquire>
  if(f->ref < 1)
80100f96:	8b 43 04             	mov    0x4(%ebx),%eax
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	7e 1a                	jle    80100fb7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100f9d:	83 c0 01             	add    $0x1,%eax
80100fa0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fa3:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100faa:	e8 31 33 00 00       	call   801042e0 <release>
  return f;
}
80100faf:	89 d8                	mov    %ebx,%eax
80100fb1:	83 c4 14             	add    $0x14,%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100fb7:	c7 04 24 26 70 10 80 	movl   $0x80107026,(%esp)
80100fbe:	e8 ed f3 ff ff       	call   801003b0 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fd7:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80100fde:	e8 4d 33 00 00       	call   80104330 <acquire>
}

static inline void
sti(void)
{
  asm volatile("sti");
80100fe3:	fb                   	sti    
  sti();
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100fe4:	8b 0d 18 00 11 80    	mov    0x80110018,%ecx
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
80100fea:	bb 2c 00 11 80       	mov    $0x8011002c,%ebx
  struct file *f;

  acquire(&ftable.lock);
  sti();
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100fef:	85 c9                	test   %ecx,%ecx
80100ff1:	75 10                	jne    80101003 <filealloc+0x33>
80100ff3:	eb 4a                	jmp    8010103f <filealloc+0x6f>
80100ff5:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct file *f;

  acquire(&ftable.lock);
  sti();
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ff8:	83 c3 18             	add    $0x18,%ebx
80100ffb:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80101001:	74 25                	je     80101028 <filealloc+0x58>
    if(f->ref == 0){
80101003:	8b 53 04             	mov    0x4(%ebx),%edx
80101006:	85 d2                	test   %edx,%edx
80101008:	75 ee                	jne    80100ff8 <filealloc+0x28>
      f->ref = 1;
8010100a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
}

static inline void
cli(void)
{
  asm volatile("cli");
80101011:	fa                   	cli    
      cli();
      release(&ftable.lock);
80101012:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101019:	e8 c2 32 00 00       	call   801042e0 <release>
    }
  }
  cli();
  release(&ftable.lock);
  return 0;
}
8010101e:	89 d8                	mov    %ebx,%eax
80101020:	83 c4 14             	add    $0x14,%esp
80101023:	5b                   	pop    %ebx
80101024:	5d                   	pop    %ebp
80101025:	c3                   	ret    
80101026:	66 90                	xchg   %ax,%ax
80101028:	fa                   	cli    
      release(&ftable.lock);
      return f;
    }
  }
  cli();
  release(&ftable.lock);
80101029:	31 db                	xor    %ebx,%ebx
8010102b:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101032:	e8 a9 32 00 00       	call   801042e0 <release>
  return 0;
}
80101037:	89 d8                	mov    %ebx,%eax
80101039:	83 c4 14             	add    $0x14,%esp
8010103c:	5b                   	pop    %ebx
8010103d:	5d                   	pop    %ebp
8010103e:	c3                   	ret    
  struct file *f;

  acquire(&ftable.lock);
  sti();
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
8010103f:	bb 14 00 11 80       	mov    $0x80110014,%ebx
80101044:	eb c4                	jmp    8010100a <filealloc+0x3a>
80101046:	8d 76 00             	lea    0x0(%esi),%esi
80101049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101050 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101050:	55                   	push   %ebp
80101051:	89 e5                	mov    %esp,%ebp
80101053:	83 ec 38             	sub    $0x38,%esp
80101056:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101059:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010105c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010105f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
80101062:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101069:	e8 c2 32 00 00       	call   80104330 <acquire>
  if(f->ref < 1)
8010106e:	8b 43 04             	mov    0x4(%ebx),%eax
80101071:	85 c0                	test   %eax,%eax
80101073:	0f 8e a4 00 00 00    	jle    8010111d <fileclose+0xcd>
    panic("fileclose");
  if(--f->ref > 0){
80101079:	83 e8 01             	sub    $0x1,%eax
8010107c:	85 c0                	test   %eax,%eax
8010107e:	89 43 04             	mov    %eax,0x4(%ebx)
80101081:	74 1d                	je     801010a0 <fileclose+0x50>
    release(&ftable.lock);
80101083:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010108a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010108d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101090:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101093:	89 ec                	mov    %ebp,%esp
80101095:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80101096:	e9 45 32 00 00       	jmp    801042e0 <release>
8010109b:	90                   	nop
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	8b 7b 10             	mov    0x10(%ebx),%edi
801010a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a9:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801010ad:	88 45 e7             	mov    %al,-0x19(%ebp)
801010b0:	8b 33                	mov    (%ebx),%esi
  f->ref = 0;
801010b2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
801010b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
801010bf:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
801010c6:	e8 15 32 00 00       	call   801042e0 <release>

  if(ff.type == FD_PIPE)
801010cb:	83 fe 01             	cmp    $0x1,%esi
801010ce:	74 38                	je     80101108 <fileclose+0xb8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801010d0:	83 fe 02             	cmp    $0x2,%esi
801010d3:	74 13                	je     801010e8 <fileclose+0x98>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801010d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801010d8:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010db:	8b 7d fc             	mov    -0x4(%ebp),%edi
801010de:	89 ec                	mov    %ebp,%esp
801010e0:	5d                   	pop    %ebp
801010e1:	c3                   	ret    
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
801010e8:	e8 33 1c 00 00       	call   80102d20 <begin_op>
    iput(ff.ip);
801010ed:	89 3c 24             	mov    %edi,(%esp)
801010f0:	e8 9b 09 00 00       	call   80101a90 <iput>
    end_op();
  }
}
801010f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801010f8:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010fb:	8b 7d fc             	mov    -0x4(%ebp),%edi
801010fe:	89 ec                	mov    %ebp,%esp
80101100:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80101101:	e9 ea 1a 00 00       	jmp    80102bf0 <end_op>
80101106:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101108:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
8010110c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101110:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101113:	89 04 24             	mov    %eax,(%esp)
80101116:	e8 c5 22 00 00       	call   801033e0 <pipeclose>
8010111b:	eb b8                	jmp    801010d5 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010111d:	c7 04 24 2e 70 10 80 	movl   $0x8010702e,(%esp)
80101124:	e8 87 f2 ff ff       	call   801003b0 <panic>
80101129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101130 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80101136:	c7 44 24 04 38 70 10 	movl   $0x80107038,0x4(%esp)
8010113d:	80 
8010113e:	c7 04 24 e0 ff 10 80 	movl   $0x8010ffe0,(%esp)
80101145:	e8 36 30 00 00       	call   80104180 <initlock>
}
8010114a:	c9                   	leave  
8010114b:	c3                   	ret    
8010114c:	66 90                	xchg   %ax,%ax
8010114e:	66 90                	xchg   %ax,%ax

80101150 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	8b 55 08             	mov    0x8(%ebp),%edx
80101156:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101159:	8b 0a                	mov    (%edx),%ecx
8010115b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010115e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101161:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101164:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101168:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010116b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010116f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101173:	8b 52 58             	mov    0x58(%edx),%edx
80101176:	89 50 10             	mov    %edx,0x10(%eax)
}
80101179:	5d                   	pop    %ebp
8010117a:	c3                   	ret    
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101180 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	53                   	push   %ebx
80101184:	83 ec 14             	sub    $0x14,%esp
80101187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010118a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101191:	e8 9a 31 00 00       	call   80104330 <acquire>
  ip->ref++;
80101196:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010119a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801011a1:	e8 3a 31 00 00       	call   801042e0 <release>
  return ip;
}
801011a6:	89 d8                	mov    %ebx,%eax
801011a8:	83 c4 14             	add    $0x14,%esp
801011ab:	5b                   	pop    %ebx
801011ac:	5d                   	pop    %ebp
801011ad:	c3                   	ret    
801011ae:	66 90                	xchg   %ax,%ax

801011b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	89 d7                	mov    %edx,%edi
801011b6:	56                   	push   %esi

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
801011b7:	31 f6                	xor    %esi,%esi
{
801011b9:	53                   	push   %ebx
801011ba:	89 c3                	mov    %eax,%ebx
801011bc:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011bf:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801011c6:	e8 65 31 00 00       	call   80104330 <acquire>

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
801011cb:	b8 34 0a 11 80       	mov    $0x80110a34,%eax
801011d0:	eb 16                	jmp    801011e8 <iget+0x38>
801011d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011d8:	85 f6                	test   %esi,%esi
801011da:	74 3c                	je     80101218 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011dc:	05 90 00 00 00       	add    $0x90,%eax
801011e1:	3d 54 26 11 80       	cmp    $0x80112654,%eax
801011e6:	74 48                	je     80101230 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011e8:	8b 48 08             	mov    0x8(%eax),%ecx
801011eb:	85 c9                	test   %ecx,%ecx
801011ed:	7e e9                	jle    801011d8 <iget+0x28>
801011ef:	39 18                	cmp    %ebx,(%eax)
801011f1:	75 e5                	jne    801011d8 <iget+0x28>
801011f3:	39 78 04             	cmp    %edi,0x4(%eax)
801011f6:	75 e0                	jne    801011d8 <iget+0x28>
      ip->ref++;
801011f8:	83 c1 01             	add    $0x1,%ecx
801011fb:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
801011fe:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101205:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101208:	e8 d3 30 00 00       	call   801042e0 <release>
      return ip;
8010120d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
80101210:	83 c4 2c             	add    $0x2c,%esp
80101213:	5b                   	pop    %ebx
80101214:	5e                   	pop    %esi
80101215:	5f                   	pop    %edi
80101216:	5d                   	pop    %ebp
80101217:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101218:	85 c9                	test   %ecx,%ecx
8010121a:	0f 44 f0             	cmove  %eax,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121d:	05 90 00 00 00       	add    $0x90,%eax
80101222:	3d 54 26 11 80       	cmp    $0x80112654,%eax
80101227:	75 bf                	jne    801011e8 <iget+0x38>
80101229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101230:	85 f6                	test   %esi,%esi
80101232:	74 29                	je     8010125d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101234:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
80101236:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
80101239:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101240:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101247:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010124e:	e8 8d 30 00 00       	call   801042e0 <release>

  return ip;
}
80101253:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101256:	89 f0                	mov    %esi,%eax

  return ip;
}
80101258:	5b                   	pop    %ebx
80101259:	5e                   	pop    %esi
8010125a:	5f                   	pop    %edi
8010125b:	5d                   	pop    %ebp
8010125c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010125d:	c7 04 24 3f 70 10 80 	movl   $0x8010703f,(%esp)
80101264:	e8 47 f1 ff ff       	call   801003b0 <panic>
80101269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101270 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101276:	8b 45 0c             	mov    0xc(%ebp),%eax
80101279:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101280:	00 
80101281:	89 44 24 04          	mov    %eax,0x4(%esp)
80101285:	8b 45 08             	mov    0x8(%ebp),%eax
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 40 32 00 00       	call   801044d0 <strncmp>
}
80101290:	c9                   	leave  
80101291:	c3                   	ret    
80101292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	56                   	push   %esi
801012a4:	53                   	push   %ebx
801012a5:	83 ec 10             	sub    $0x10,%esp
801012a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801012ab:	8b 43 04             	mov    0x4(%ebx),%eax
801012ae:	c1 e8 03             	shr    $0x3,%eax
801012b1:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801012b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801012bb:	8b 03                	mov    (%ebx),%eax
801012bd:	89 04 24             	mov    %eax,(%esp)
801012c0:	e8 4b ee ff ff       	call   80100110 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801012c5:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801012c9:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801012cb:	8b 43 04             	mov    0x4(%ebx),%eax
801012ce:	83 e0 07             	and    $0x7,%eax
801012d1:	c1 e0 06             	shl    $0x6,%eax
801012d4:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801012d8:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801012db:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
801012df:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801012e3:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801012e7:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801012eb:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801012ef:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801012f3:	8b 53 58             	mov    0x58(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801012f6:	83 c3 5c             	add    $0x5c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
801012f9:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801012fc:	83 c0 0c             	add    $0xc,%eax
801012ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101303:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010130a:	00 
8010130b:	89 04 24             	mov    %eax,(%esp)
8010130e:	e8 4d 31 00 00       	call   80104460 <memmove>
  log_write(bp);
80101313:	89 34 24             	mov    %esi,(%esp)
80101316:	e8 15 17 00 00       	call   80102a30 <log_write>
  brelse(bp);
8010131b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010131e:	83 c4 10             	add    $0x10,%esp
80101321:	5b                   	pop    %ebx
80101322:	5e                   	pop    %esi
80101323:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101324:	e9 17 ed ff ff       	jmp    80100040 <brelse>
80101329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101330 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	83 ec 18             	sub    $0x18,%esp
80101336:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80101339:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010133c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
8010133f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101346:	00 
80101347:	8b 45 08             	mov    0x8(%ebp),%eax
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 be ed ff ff       	call   80100110 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101352:	89 34 24             	mov    %esi,(%esp)
80101355:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010135c:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
8010135d:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010135f:	83 c0 5c             	add    $0x5c,%eax
80101362:	89 44 24 04          	mov    %eax,0x4(%esp)
80101366:	e8 f5 30 00 00       	call   80104460 <memmove>
  brelse(bp);
}
8010136b:	8b 75 fc             	mov    -0x4(%ebp),%esi
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
8010136e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101371:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80101374:	89 ec                	mov    %ebp,%esp
80101376:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101377:	e9 c4 ec ff ff       	jmp    80100040 <brelse>
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	83 ec 28             	sub    $0x28,%esp
80101386:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101389:	89 d6                	mov    %edx,%esi
8010138b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010138e:	89 c3                	mov    %eax,%ebx
80101390:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101393:	89 04 24             	mov    %eax,(%esp)
80101396:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
8010139d:	80 
8010139e:	e8 8d ff ff ff       	call   80101330 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013a3:	89 f0                	mov    %esi,%eax
801013a5:	c1 e8 0c             	shr    $0xc,%eax
801013a8:	03 05 f8 09 11 80    	add    0x801109f8,%eax
801013ae:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
801013b1:	89 f3                	mov    %esi,%ebx
801013b3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801013bd:	c1 fb 03             	sar    $0x3,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013c0:	e8 4b ed ff ff       	call   80100110 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013c5:	89 f1                	mov    %esi,%ecx
801013c7:	be 01 00 00 00       	mov    $0x1,%esi
801013cc:	83 e1 07             	and    $0x7,%ecx
801013cf:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
801013d1:	0f b6 54 18 5c       	movzbl 0x5c(%eax,%ebx,1),%edx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013d6:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801013d8:	0f b6 c2             	movzbl %dl,%eax
801013db:	85 f0                	test   %esi,%eax
801013dd:	74 27                	je     80101406 <bfree+0x86>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013df:	89 f0                	mov    %esi,%eax
801013e1:	f7 d0                	not    %eax
801013e3:	21 d0                	and    %edx,%eax
801013e5:	88 44 1f 5c          	mov    %al,0x5c(%edi,%ebx,1)
  log_write(bp);
801013e9:	89 3c 24             	mov    %edi,(%esp)
801013ec:	e8 3f 16 00 00       	call   80102a30 <log_write>
  brelse(bp);
801013f1:	89 3c 24             	mov    %edi,(%esp)
801013f4:	e8 47 ec ff ff       	call   80100040 <brelse>
}
801013f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801013fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
801013ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101402:	89 ec                	mov    %ebp,%esp
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101406:	c7 04 24 4f 70 10 80 	movl   $0x8010704f,(%esp)
8010140d:	e8 9e ef ff ff       	call   801003b0 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	53                   	push   %ebx
80101426:	83 ec 3c             	sub    $0x3c,%esp
80101429:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010142c:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 84 90 00 00 00    	je     801014c9 <balloc+0xa9>
80101439:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101440:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101443:	c1 f8 0c             	sar    $0xc,%eax
80101446:	03 05 f8 09 11 80    	add    0x801109f8,%eax
8010144c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101450:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101453:	89 04 24             	mov    %eax,(%esp)
80101456:	e8 b5 ec ff ff       	call   80100110 <bread>
8010145b:	8b 15 e0 09 11 80    	mov    0x801109e0,%edx
80101461:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101464:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101467:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010146a:	31 c0                	xor    %eax,%eax
8010146c:	eb 35                	jmp    801014a3 <balloc+0x83>
8010146e:	66 90                	xchg   %ax,%ax
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101470:	89 c1                	mov    %eax,%ecx
80101472:	bf 01 00 00 00       	mov    $0x1,%edi
80101477:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010147a:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010147c:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010147e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101481:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101484:	89 7d d4             	mov    %edi,-0x2c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101487:	0f b6 74 11 5c       	movzbl 0x5c(%ecx,%edx,1),%esi
8010148c:	89 f1                	mov    %esi,%ecx
8010148e:	0f b6 f9             	movzbl %cl,%edi
80101491:	85 7d d4             	test   %edi,-0x2c(%ebp)
80101494:	74 42                	je     801014d8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101496:	83 c0 01             	add    $0x1,%eax
80101499:	83 c3 01             	add    $0x1,%ebx
8010149c:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014a1:	74 05                	je     801014a8 <balloc+0x88>
801014a3:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801014a6:	72 c8                	jb     80101470 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ab:	89 14 24             	mov    %edx,(%esp)
801014ae:	e8 8d eb ff ff       	call   80100040 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014b3:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801014bd:	39 0d e0 09 11 80    	cmp    %ecx,0x801109e0
801014c3:	0f 87 77 ff ff ff    	ja     80101440 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014c9:	c7 04 24 62 70 10 80 	movl   $0x80107062,(%esp)
801014d0:	e8 db ee ff ff       	call   801003b0 <panic>
801014d5:	8d 76 00             	lea    0x0(%esi),%esi
801014d8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801014db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801014de:	09 f1                	or     %esi,%ecx
801014e0:	88 4c 17 5c          	mov    %cl,0x5c(%edi,%edx,1)
        log_write(bp);
801014e4:	89 3c 24             	mov    %edi,(%esp)
801014e7:	e8 44 15 00 00       	call   80102a30 <log_write>
        brelse(bp);
801014ec:	89 3c 24             	mov    %edi,(%esp)
801014ef:	e8 4c eb ff ff       	call   80100040 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801014f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801014fb:	89 04 24             	mov    %eax,(%esp)
801014fe:	e8 0d ec ff ff       	call   80100110 <bread>
  memset(bp->data, 0, BSIZE);
80101503:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010150a:	00 
8010150b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101512:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101513:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80101515:	83 c0 5c             	add    $0x5c,%eax
80101518:	89 04 24             	mov    %eax,(%esp)
8010151b:	e8 80 2e 00 00       	call   801043a0 <memset>
  log_write(bp);
80101520:	89 34 24             	mov    %esi,(%esp)
80101523:	e8 08 15 00 00       	call   80102a30 <log_write>
  brelse(bp);
80101528:	89 34 24             	mov    %esi,(%esp)
8010152b:	e8 10 eb ff ff       	call   80100040 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101530:	83 c4 3c             	add    $0x3c,%esp
80101533:	89 d8                	mov    %ebx,%eax
80101535:	5b                   	pop    %ebx
80101536:	5e                   	pop    %esi
80101537:	5f                   	pop    %edi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret    
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101540 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101546:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101549:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010154c:	89 c3                	mov    %eax,%ebx
8010154e:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101551:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101554:	77 1a                	ja     80101570 <bmap+0x30>
    if((addr = ip->addrs[bn]) == 0)
80101556:	8d 7a 14             	lea    0x14(%edx),%edi
80101559:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
8010155d:	85 c0                	test   %eax,%eax
8010155f:	74 67                	je     801015c8 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
80101561:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101564:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101567:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010156a:	89 ec                	mov    %ebp,%esp
8010156c:	5d                   	pop    %ebp
8010156d:	c3                   	ret    
8010156e:	66 90                	xchg   %ax,%ax
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101570:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
80101573:	83 ff 7f             	cmp    $0x7f,%edi
80101576:	77 6f                	ja     801015e7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101578:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010157e:	85 c0                	test   %eax,%eax
80101580:	74 56                	je     801015d8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101582:	89 44 24 04          	mov    %eax,0x4(%esp)
80101586:	8b 03                	mov    (%ebx),%eax
80101588:	89 04 24             	mov    %eax,(%esp)
8010158b:	e8 80 eb ff ff       	call   80100110 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101590:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101594:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101596:	8b 07                	mov    (%edi),%eax
80101598:	85 c0                	test   %eax,%eax
8010159a:	75 17                	jne    801015b3 <bmap+0x73>
      a[bn] = addr = balloc(ip->dev);
8010159c:	8b 03                	mov    (%ebx),%eax
8010159e:	e8 7d fe ff ff       	call   80101420 <balloc>
801015a3:	89 07                	mov    %eax,(%edi)
      log_write(bp);
801015a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015a8:	89 34 24             	mov    %esi,(%esp)
801015ab:	e8 80 14 00 00       	call   80102a30 <log_write>
801015b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
801015b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015b6:	89 34 24             	mov    %esi,(%esp)
801015b9:	e8 82 ea ff ff       	call   80100040 <brelse>
    return addr;
801015be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015c1:	eb 9e                	jmp    80101561 <bmap+0x21>
801015c3:	90                   	nop
801015c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801015c8:	8b 03                	mov    (%ebx),%eax
801015ca:	e8 51 fe ff ff       	call   80101420 <balloc>
801015cf:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
801015d3:	eb 8c                	jmp    80101561 <bmap+0x21>
801015d5:	8d 76 00             	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015d8:	8b 03                	mov    (%ebx),%eax
801015da:	e8 41 fe ff ff       	call   80101420 <balloc>
801015df:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801015e5:	eb 9b                	jmp    80101582 <bmap+0x42>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801015e7:	c7 04 24 78 70 10 80 	movl   $0x80107078,(%esp)
801015ee:	e8 bd ed ff ff       	call   801003b0 <panic>
801015f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101600 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	83 ec 38             	sub    $0x38,%esp
80101606:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010160c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010160f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101612:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101615:	8b 75 10             	mov    0x10(%ebp),%esi
80101618:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010161b:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101620:	74 1e                	je     80101640 <writei+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101622:	39 73 58             	cmp    %esi,0x58(%ebx)
80101625:	73 41                	jae    80101668 <writei+0x68>

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010162c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010162f:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101632:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101635:	89 ec                	mov    %ebp,%esp
80101637:	5d                   	pop    %ebp
80101638:	c3                   	ret    
80101639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101640:	0f b7 43 52          	movzwl 0x52(%ebx),%eax
80101644:	66 83 f8 09          	cmp    $0x9,%ax
80101648:	77 dd                	ja     80101627 <writei+0x27>
8010164a:	98                   	cwtl   
8010164b:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101652:	85 c0                	test   %eax,%eax
80101654:	74 d1                	je     80101627 <writei+0x27>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101656:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101659:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010165c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010165f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101662:	89 ec                	mov    %ebp,%esp
80101664:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101665:	ff e0                	jmp    *%eax
80101667:	90                   	nop
  }

  if(off > ip->size || off + n < off)
80101668:	89 f8                	mov    %edi,%eax
8010166a:	01 f0                	add    %esi,%eax
8010166c:	72 b9                	jb     80101627 <writei+0x27>
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010166e:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101673:	77 b2                	ja     80101627 <writei+0x27>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101675:	85 ff                	test   %edi,%edi
80101677:	0f 84 8a 00 00 00    	je     80101707 <writei+0x107>
8010167d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101684:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101687:	89 7d dc             	mov    %edi,-0x24(%ebp)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010168a:	89 f2                	mov    %esi,%edx
8010168c:	89 d8                	mov    %ebx,%eax
8010168e:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101691:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101696:	e8 a5 fe ff ff       	call   80101540 <bmap>
8010169b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010169f:	8b 03                	mov    (%ebx),%eax
801016a1:	89 04 24             	mov    %eax,(%esp)
801016a4:	e8 67 ea ff ff       	call   80100110 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801016a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801016ac:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801016af:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801016b1:	89 f0                	mov    %esi,%eax
801016b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801016b8:	29 c7                	sub    %eax,%edi
801016ba:	39 cf                	cmp    %ecx,%edi
801016bc:	0f 47 f9             	cmova  %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
801016bf:	89 7c 24 08          	mov    %edi,0x8(%esp)
801016c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016c6:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801016ca:	89 04 24             	mov    %eax,(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801016cd:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
801016cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801016d3:	89 55 d8             	mov    %edx,-0x28(%ebp)
801016d6:	e8 85 2d 00 00       	call   80104460 <memmove>
    log_write(bp);
801016db:	8b 55 d8             	mov    -0x28(%ebp),%edx
801016de:	89 14 24             	mov    %edx,(%esp)
801016e1:	e8 4a 13 00 00       	call   80102a30 <log_write>
    brelse(bp);
801016e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
801016e9:	89 14 24             	mov    %edx,(%esp)
801016ec:	e8 4f e9 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801016f1:	01 7d e4             	add    %edi,-0x1c(%ebp)
801016f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016f7:	01 7d e0             	add    %edi,-0x20(%ebp)
801016fa:	39 45 dc             	cmp    %eax,-0x24(%ebp)
801016fd:	77 8b                	ja     8010168a <writei+0x8a>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801016ff:	3b 73 58             	cmp    0x58(%ebx),%esi
80101702:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101705:	77 07                	ja     8010170e <writei+0x10e>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101707:	89 f8                	mov    %edi,%eax
80101709:	e9 1e ff ff ff       	jmp    8010162c <writei+0x2c>
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
8010170e:	89 73 58             	mov    %esi,0x58(%ebx)
    iupdate(ip);
80101711:	89 1c 24             	mov    %ebx,(%esp)
80101714:	e8 87 fb ff ff       	call   801012a0 <iupdate>
  }
  return n;
80101719:	89 f8                	mov    %edi,%eax
8010171b:	e9 0c ff ff ff       	jmp    8010162c <writei+0x2c>

80101720 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	83 ec 38             	sub    $0x38,%esp
80101726:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010172c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010172f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101732:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101735:	8b 75 10             	mov    0x10(%ebp),%esi
80101738:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010173b:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101740:	74 1e                	je     80101760 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101742:	8b 43 58             	mov    0x58(%ebx),%eax
80101745:	39 f0                	cmp    %esi,%eax
80101747:	73 3f                	jae    80101788 <readi+0x68>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101749:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010174e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101751:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101754:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101757:	89 ec                	mov    %ebp,%esp
80101759:	5d                   	pop    %ebp
8010175a:	c3                   	ret    
8010175b:	90                   	nop
8010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101760:	0f b7 43 52          	movzwl 0x52(%ebx),%eax
80101764:	66 83 f8 09          	cmp    $0x9,%ax
80101768:	77 df                	ja     80101749 <readi+0x29>
8010176a:	98                   	cwtl   
8010176b:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	74 d3                	je     80101749 <readi+0x29>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101776:	89 4d 10             	mov    %ecx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101779:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010177c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010177f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101782:	89 ec                	mov    %ebp,%esp
80101784:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101785:	ff e0                	jmp    *%eax
80101787:	90                   	nop
  }

  if(off > ip->size || off + n < off)
80101788:	89 ca                	mov    %ecx,%edx
8010178a:	01 f2                	add    %esi,%edx
8010178c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010178f:	72 b8                	jb     80101749 <readi+0x29>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101791:	89 c2                	mov    %eax,%edx
80101793:	29 f2                	sub    %esi,%edx
80101795:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101798:	0f 42 ca             	cmovb  %edx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010179b:	85 c9                	test   %ecx,%ecx
8010179d:	74 7e                	je     8010181d <readi+0xfd>
8010179f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801017a6:	89 7d e0             	mov    %edi,-0x20(%ebp)
801017a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017b0:	89 f2                	mov    %esi,%edx
801017b2:	89 d8                	mov    %ebx,%eax
801017b4:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801017b7:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017bc:	e8 7f fd ff ff       	call   80101540 <bmap>
801017c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801017c5:	8b 03                	mov    (%ebx),%eax
801017c7:	89 04 24             	mov    %eax,(%esp)
801017ca:	e8 41 e9 ff ff       	call   80100110 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801017cf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801017d2:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017d5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801017d7:	89 f0                	mov    %esi,%eax
801017d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801017de:	29 c7                	sub    %eax,%edi
801017e0:	39 cf                	cmp    %ecx,%edi
801017e2:	0f 47 f9             	cmova  %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801017e5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017e9:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801017eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
801017ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801017f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801017f6:	89 04 24             	mov    %eax,(%esp)
801017f9:	89 55 d8             	mov    %edx,-0x28(%ebp)
801017fc:	e8 5f 2c 00 00       	call   80104460 <memmove>
    brelse(bp);
80101801:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101804:	89 14 24             	mov    %edx,(%esp)
80101807:	e8 34 e8 ff ff       	call   80100040 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010180c:	01 7d e4             	add    %edi,-0x1c(%ebp)
8010180f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101812:	01 7d e0             	add    %edi,-0x20(%ebp)
80101815:	39 55 dc             	cmp    %edx,-0x24(%ebp)
80101818:	77 96                	ja     801017b0 <readi+0x90>
8010181a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010181d:	89 c8                	mov    %ecx,%eax
8010181f:	e9 2a ff ff ff       	jmp    8010174e <readi+0x2e>
80101824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010182a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101830 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	56                   	push   %esi
80101835:	53                   	push   %ebx
80101836:	83 ec 2c             	sub    $0x2c,%esp
80101839:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010183c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101841:	0f 85 8c 00 00 00    	jne    801018d3 <dirlookup+0xa3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101847:	8b 4b 58             	mov    0x58(%ebx),%ecx
8010184a:	85 c9                	test   %ecx,%ecx
8010184c:	74 4c                	je     8010189a <dirlookup+0x6a>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
8010184e:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101851:	31 f6                	xor    %esi,%esi
80101853:	90                   	nop
80101854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101858:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010185f:	00 
80101860:	89 74 24 08          	mov    %esi,0x8(%esp)
80101864:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101868:	89 1c 24             	mov    %ebx,(%esp)
8010186b:	e8 b0 fe ff ff       	call   80101720 <readi>
80101870:	83 f8 10             	cmp    $0x10,%eax
80101873:	75 52                	jne    801018c7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101875:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010187a:	74 16                	je     80101892 <dirlookup+0x62>
      continue;
    if(namecmp(name, de.name) == 0){
8010187c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010187f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101883:	8b 45 0c             	mov    0xc(%ebp),%eax
80101886:	89 04 24             	mov    %eax,(%esp)
80101889:	e8 e2 f9 ff ff       	call   80101270 <namecmp>
8010188e:	85 c0                	test   %eax,%eax
80101890:	74 16                	je     801018a8 <dirlookup+0x78>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101892:	83 c6 10             	add    $0x10,%esi
80101895:	39 73 58             	cmp    %esi,0x58(%ebx)
80101898:	77 be                	ja     80101858 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
8010189a:	83 c4 2c             	add    $0x2c,%esp
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010189d:	31 c0                	xor    %eax,%eax
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
8010189f:	5b                   	pop    %ebx
801018a0:	5e                   	pop    %esi
801018a1:	5f                   	pop    %edi
801018a2:	5d                   	pop    %ebp
801018a3:	c3                   	ret    
801018a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      if(poff)
801018a8:	8b 55 10             	mov    0x10(%ebp),%edx
801018ab:	85 d2                	test   %edx,%edx
801018ad:	74 05                	je     801018b4 <dirlookup+0x84>
        *poff = off;
801018af:	8b 45 10             	mov    0x10(%ebp),%eax
801018b2:	89 30                	mov    %esi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
801018b4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
801018b8:	8b 03                	mov    (%ebx),%eax
801018ba:	e8 f1 f8 ff ff       	call   801011b0 <iget>
    }
  }

  return 0;
}
801018bf:	83 c4 2c             	add    $0x2c,%esp
801018c2:	5b                   	pop    %ebx
801018c3:	5e                   	pop    %esi
801018c4:	5f                   	pop    %edi
801018c5:	5d                   	pop    %ebp
801018c6:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
801018c7:	c7 04 24 9d 70 10 80 	movl   $0x8010709d,(%esp)
801018ce:	e8 dd ea ff ff       	call   801003b0 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
801018d3:	c7 04 24 8b 70 10 80 	movl   $0x8010708b,(%esp)
801018da:	e8 d1 ea ff ff       	call   801003b0 <panic>
801018df:	90                   	nop

801018e0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 2c             	sub    $0x2c,%esp
801018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018ec:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018f6:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
801018fa:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018fe:	0f 86 95 00 00 00    	jbe    80101999 <ialloc+0xb9>
80101904:	be 01 00 00 00       	mov    $0x1,%esi
80101909:	bb 01 00 00 00       	mov    $0x1,%ebx
8010190e:	eb 15                	jmp    80101925 <ialloc+0x45>
80101910:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101913:	89 3c 24             	mov    %edi,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101916:	89 de                	mov    %ebx,%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101918:	e8 23 e7 ff ff       	call   80100040 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010191d:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101923:	76 74                	jbe    80101999 <ialloc+0xb9>
    bp = bread(dev, IBLOCK(inum, sb));
80101925:	89 f0                	mov    %esi,%eax
80101927:	c1 e8 03             	shr    $0x3,%eax
8010192a:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101930:	89 44 24 04          	mov    %eax,0x4(%esp)
80101934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101937:	89 04 24             	mov    %eax,(%esp)
8010193a:	e8 d1 e7 ff ff       	call   80100110 <bread>
8010193f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101941:	89 f0                	mov    %esi,%eax
80101943:	83 e0 07             	and    $0x7,%eax
80101946:	c1 e0 06             	shl    $0x6,%eax
80101949:	8d 54 07 5c          	lea    0x5c(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
8010194d:	66 83 3a 00          	cmpw   $0x0,(%edx)
80101951:	75 bd                	jne    80101910 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101953:	89 14 24             	mov    %edx,(%esp)
80101956:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010195d:	00 
8010195e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101965:	00 
80101966:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101969:	e8 32 2a 00 00       	call   801043a0 <memset>
      dip->type = type;
8010196e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101971:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
80101975:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101978:	89 3c 24             	mov    %edi,(%esp)
8010197b:	e8 b0 10 00 00       	call   80102a30 <log_write>
      brelse(bp);
80101980:	89 3c 24             	mov    %edi,(%esp)
80101983:	e8 b8 e6 ff ff       	call   80100040 <brelse>
      return iget(dev, inum);
80101988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010198b:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010198d:	83 c4 2c             	add    $0x2c,%esp
80101990:	5b                   	pop    %ebx
80101991:	5e                   	pop    %esi
80101992:	5f                   	pop    %edi
80101993:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101994:	e9 17 f8 ff ff       	jmp    801011b0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101999:	c7 04 24 ac 70 10 80 	movl   $0x801070ac,(%esp)
801019a0:	e8 0b ea ff ff       	call   801003b0 <panic>
801019a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801019b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	56                   	push   %esi
801019b4:	53                   	push   %ebx
801019b5:	83 ec 10             	sub    $0x10,%esp
801019b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019bb:	85 db                	test   %ebx,%ebx
801019bd:	0f 84 b3 00 00 00    	je     80101a76 <ilock+0xc6>
801019c3:	8b 43 08             	mov    0x8(%ebx),%eax
801019c6:	85 c0                	test   %eax,%eax
801019c8:	0f 8e a8 00 00 00    	jle    80101a76 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801019ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801019d1:	89 04 24             	mov    %eax,(%esp)
801019d4:	e8 07 27 00 00       	call   801040e0 <acquiresleep>

  if(ip->valid == 0){
801019d9:	8b 73 4c             	mov    0x4c(%ebx),%esi
801019dc:	85 f6                	test   %esi,%esi
801019de:	74 08                	je     801019e8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801019e0:	83 c4 10             	add    $0x10,%esp
801019e3:	5b                   	pop    %ebx
801019e4:	5e                   	pop    %esi
801019e5:	5d                   	pop    %ebp
801019e6:	c3                   	ret    
801019e7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019e8:	8b 43 04             	mov    0x4(%ebx),%eax
801019eb:	c1 e8 03             	shr    $0x3,%eax
801019ee:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f8:	8b 03                	mov    (%ebx),%eax
801019fa:	89 04 24             	mov    %eax,(%esp)
801019fd:	e8 0e e7 ff ff       	call   80100110 <bread>
80101a02:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a04:	8b 43 04             	mov    0x4(%ebx),%eax
80101a07:	83 e0 07             	and    $0x7,%eax
80101a0a:	c1 e0 06             	shl    $0x6,%eax
80101a0d:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a11:	0f b7 10             	movzwl (%eax),%edx
80101a14:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a18:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a1c:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a20:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a24:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a28:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a2c:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a30:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a33:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
80101a36:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a39:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a3d:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a40:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a47:	00 
80101a48:	89 04 24             	mov    %eax,(%esp)
80101a4b:	e8 10 2a 00 00       	call   80104460 <memmove>
    brelse(bp);
80101a50:	89 34 24             	mov    %esi,(%esp)
80101a53:	e8 e8 e5 ff ff       	call   80100040 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101a58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
80101a5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a64:	0f 85 76 ff ff ff    	jne    801019e0 <ilock+0x30>
      panic("ilock: no type");
80101a6a:	c7 04 24 c4 70 10 80 	movl   $0x801070c4,(%esp)
80101a71:	e8 3a e9 ff ff       	call   801003b0 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101a76:	c7 04 24 be 70 10 80 	movl   $0x801070be,(%esp)
80101a7d:	e8 2e e9 ff ff       	call   801003b0 <panic>
80101a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101a90 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	83 ec 38             	sub    $0x38,%esp
80101a96:	89 75 f8             	mov    %esi,-0x8(%ebp)
80101a99:	8b 75 08             	mov    0x8(%ebp),%esi
80101a9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101a9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  acquiresleep(&ip->lock);
80101aa2:	8d 7e 0c             	lea    0xc(%esi),%edi
80101aa5:	89 3c 24             	mov    %edi,(%esp)
80101aa8:	e8 33 26 00 00       	call   801040e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101aad:	8b 56 4c             	mov    0x4c(%esi),%edx
80101ab0:	85 d2                	test   %edx,%edx
80101ab2:	74 07                	je     80101abb <iput+0x2b>
80101ab4:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101ab9:	74 35                	je     80101af0 <iput+0x60>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101abb:	89 3c 24             	mov    %edi,(%esp)
80101abe:	e8 dd 25 00 00       	call   801040a0 <releasesleep>

  acquire(&icache.lock);
80101ac3:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101aca:	e8 61 28 00 00       	call   80104330 <acquire>
  ip->ref--;
80101acf:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
}
80101ad3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101ad6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101add:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101ae0:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101ae3:	89 ec                	mov    %ebp,%esp
80101ae5:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101ae6:	e9 f5 27 00 00       	jmp    801042e0 <release>
80101aeb:	90                   	nop
80101aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101af0:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101af7:	e8 34 28 00 00       	call   80104330 <acquire>
    int r = ip->ref;
80101afc:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101aff:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101b06:	e8 d5 27 00 00       	call   801042e0 <release>
    if(r == 1){
80101b0b:	83 fb 01             	cmp    $0x1,%ebx
80101b0e:	75 ab                	jne    80101abb <iput+0x2b>
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
80101b10:	8d 4e 30             	lea    0x30(%esi),%ecx
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
80101b13:	89 f3                	mov    %esi,%ebx
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
80101b15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b18:	89 f7                	mov    %esi,%edi
80101b1a:	89 ce                	mov    %ecx,%esi
80101b1c:	eb 09                	jmp    80101b27 <iput+0x97>
80101b1e:	66 90                	xchg   %ax,%ax
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
80101b20:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b23:	39 f3                	cmp    %esi,%ebx
80101b25:	74 19                	je     80101b40 <iput+0xb0>
    if(ip->addrs[i]){
80101b27:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101b2a:	85 d2                	test   %edx,%edx
80101b2c:	74 f2                	je     80101b20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b2e:	8b 07                	mov    (%edi),%eax
80101b30:	e8 4b f8 ff ff       	call   80101380 <bfree>
      ip->addrs[i] = 0;
80101b35:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
80101b3c:	eb e2                	jmp    80101b20 <iput+0x90>
80101b3e:	66 90                	xchg   %ax,%ax
80101b40:	89 fe                	mov    %edi,%esi
80101b42:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b45:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101b4b:	85 c0                	test   %eax,%eax
80101b4d:	75 29                	jne    80101b78 <iput+0xe8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101b4f:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101b56:	89 34 24             	mov    %esi,(%esp)
80101b59:	e8 42 f7 ff ff       	call   801012a0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101b5e:	66 c7 46 50 00 00    	movw   $0x0,0x50(%esi)
      iupdate(ip);
80101b64:	89 34 24             	mov    %esi,(%esp)
80101b67:	e8 34 f7 ff ff       	call   801012a0 <iupdate>
      ip->valid = 0;
80101b6c:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101b73:	e9 43 ff ff ff       	jmp    80101abb <iput+0x2b>
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b78:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b7c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
80101b7e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b80:	89 04 24             	mov    %eax,(%esp)
80101b83:	e8 88 e5 ff ff       	call   80100110 <bread>
    a = (uint*)bp->data;
80101b88:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b8b:	89 f7                	mov    %esi,%edi
80101b8d:	89 c1                	mov    %eax,%ecx
80101b8f:	83 c1 5c             	add    $0x5c,%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b95:	89 ce                	mov    %ecx,%esi
80101b97:	31 c0                	xor    %eax,%eax
80101b99:	eb 12                	jmp    80101bad <iput+0x11d>
80101b9b:	90                   	nop
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
80101ba0:	83 c3 01             	add    $0x1,%ebx
80101ba3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101ba9:	89 d8                	mov    %ebx,%eax
80101bab:	74 10                	je     80101bbd <iput+0x12d>
      if(a[j])
80101bad:	8b 14 86             	mov    (%esi,%eax,4),%edx
80101bb0:	85 d2                	test   %edx,%edx
80101bb2:	74 ec                	je     80101ba0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101bb4:	8b 07                	mov    (%edi),%eax
80101bb6:	e8 c5 f7 ff ff       	call   80101380 <bfree>
80101bbb:	eb e3                	jmp    80101ba0 <iput+0x110>
    }
    brelse(bp);
80101bbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc0:	89 fe                	mov    %edi,%esi
80101bc2:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc5:	89 04 24             	mov    %eax,(%esp)
80101bc8:	e8 73 e4 ff ff       	call   80100040 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bcd:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101bd3:	8b 06                	mov    (%esi),%eax
80101bd5:	e8 a6 f7 ff ff       	call   80101380 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bda:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101be1:	00 00 00 
80101be4:	e9 66 ff ff ff       	jmp    80101b4f <iput+0xbf>
80101be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101bf0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101c06:	00 
80101c07:	89 34 24             	mov    %esi,(%esp)
80101c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0e:	e8 1d fc ff ff       	call   80101830 <dirlookup>
80101c13:	85 c0                	test   %eax,%eax
80101c15:	0f 85 89 00 00 00    	jne    80101ca4 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c1b:	8b 4e 58             	mov    0x58(%esi),%ecx
80101c1e:	85 c9                	test   %ecx,%ecx
80101c20:	0f 84 8d 00 00 00    	je     80101cb3 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
80101c26:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c29:	31 db                	xor    %ebx,%ebx
80101c2b:	eb 0b                	jmp    80101c38 <dirlink+0x48>
80101c2d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c30:	83 c3 10             	add    $0x10,%ebx
80101c33:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101c36:	76 24                	jbe    80101c5c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c38:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c3f:	00 
80101c40:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101c44:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101c48:	89 34 24             	mov    %esi,(%esp)
80101c4b:	e8 d0 fa ff ff       	call   80101720 <readi>
80101c50:	83 f8 10             	cmp    $0x10,%eax
80101c53:	75 65                	jne    80101cba <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
80101c55:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c5a:	75 d4                	jne    80101c30 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c5f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c66:	00 
80101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c6b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c6e:	89 04 24             	mov    %eax,(%esp)
80101c71:	e8 ba 28 00 00       	call   80104530 <strncpy>
  de.inum = inum;
80101c76:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c79:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c80:	00 
80101c81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101c85:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101c89:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c8d:	89 34 24             	mov    %esi,(%esp)
80101c90:	e8 6b f9 ff ff       	call   80101600 <writei>
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 2c                	jne    80101cc6 <dirlink+0xd6>
    panic("dirlink");
80101c9a:	31 c0                	xor    %eax,%eax

  return 0;
}
80101c9c:	83 c4 2c             	add    $0x2c,%esp
80101c9f:	5b                   	pop    %ebx
80101ca0:	5e                   	pop    %esi
80101ca1:	5f                   	pop    %edi
80101ca2:	5d                   	pop    %ebp
80101ca3:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ca4:	89 04 24             	mov    %eax,(%esp)
80101ca7:	e8 e4 fd ff ff       	call   80101a90 <iput>
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80101cb1:	eb e9                	jmp    80101c9c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101cb6:	31 db                	xor    %ebx,%ebx
80101cb8:	eb a2                	jmp    80101c5c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101cba:	c7 04 24 d3 70 10 80 	movl   $0x801070d3,(%esp)
80101cc1:	e8 ea e6 ff ff       	call   801003b0 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101cc6:	c7 04 24 c6 76 10 80 	movl   $0x801076c6,(%esp)
80101ccd:	e8 de e6 ff ff       	call   801003b0 <panic>
80101cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ce0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	83 ec 18             	sub    $0x18,%esp
80101ce6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101cec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101cef:	85 db                	test   %ebx,%ebx
80101cf1:	74 27                	je     80101d1a <iunlock+0x3a>
80101cf3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101cf6:	89 34 24             	mov    %esi,(%esp)
80101cf9:	e8 72 23 00 00       	call   80104070 <holdingsleep>
80101cfe:	85 c0                	test   %eax,%eax
80101d00:	74 18                	je     80101d1a <iunlock+0x3a>
80101d02:	8b 5b 08             	mov    0x8(%ebx),%ebx
80101d05:	85 db                	test   %ebx,%ebx
80101d07:	7e 11                	jle    80101d1a <iunlock+0x3a>
    panic("iunlock");

  releasesleep(&ip->lock);
80101d09:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d0c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80101d0f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80101d12:	89 ec                	mov    %ebp,%esp
80101d14:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101d15:	e9 86 23 00 00       	jmp    801040a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101d1a:	c7 04 24 e0 70 10 80 	movl   $0x801070e0,(%esp)
80101d21:	e8 8a e6 ff ff       	call   801003b0 <panic>
80101d26:	8d 76 00             	lea    0x0(%esi),%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d30 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	53                   	push   %ebx
80101d34:	83 ec 14             	sub    $0x14,%esp
80101d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d3a:	89 1c 24             	mov    %ebx,(%esp)
80101d3d:	e8 9e ff ff ff       	call   80101ce0 <iunlock>
  iput(ip);
80101d42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101d45:	83 c4 14             	add    $0x14,%esp
80101d48:	5b                   	pop    %ebx
80101d49:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101d4a:	e9 41 fd ff ff       	jmp    80101a90 <iput>
80101d4f:	90                   	nop

80101d50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	89 c3                	mov    %eax,%ebx
80101d58:	83 ec 2c             	sub    $0x2c,%esp
80101d5b:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d61:	80 38 2f             	cmpb   $0x2f,(%eax)
80101d64:	0f 84 14 01 00 00    	je     80101e7e <namex+0x12e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d6a:	e8 41 1d 00 00       	call   80103ab0 <myproc>
80101d6f:	8b 40 68             	mov    0x68(%eax),%eax
80101d72:	89 04 24             	mov    %eax,(%esp)
80101d75:	e8 06 f4 ff ff       	call   80101180 <idup>
80101d7a:	89 c7                	mov    %eax,%edi
80101d7c:	eb 05                	jmp    80101d83 <namex+0x33>
80101d7e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 f6                	je     80101d80 <namex+0x30>
    path++;
  if(*path == 0)
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 1a                	jne    80101da8 <namex+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8e:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101d91:	85 f6                	test   %esi,%esi
80101d93:	0f 85 0d 01 00 00    	jne    80101ea6 <namex+0x156>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d99:	83 c4 2c             	add    $0x2c,%esp
80101d9c:	89 f8                	mov    %edi,%eax
80101d9e:	5b                   	pop    %ebx
80101d9f:	5e                   	pop    %esi
80101da0:	5f                   	pop    %edi
80101da1:	5d                   	pop    %ebp
80101da2:	c3                   	ret    
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101da8:	3c 2f                	cmp    $0x2f,%al
80101daa:	0f 84 94 00 00 00    	je     80101e44 <namex+0xf4>
80101db0:	89 de                	mov    %ebx,%esi
80101db2:	eb 08                	jmp    80101dbc <namex+0x6c>
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db8:	3c 2f                	cmp    $0x2f,%al
80101dba:	74 0a                	je     80101dc6 <namex+0x76>
    path++;
80101dbc:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dbf:	0f b6 06             	movzbl (%esi),%eax
80101dc2:	84 c0                	test   %al,%al
80101dc4:	75 f2                	jne    80101db8 <namex+0x68>
80101dc6:	89 f2                	mov    %esi,%edx
80101dc8:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101dca:	83 fa 0d             	cmp    $0xd,%edx
80101dcd:	7e 79                	jle    80101e48 <namex+0xf8>
    memmove(name, s, DIRSIZ);
80101dcf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101dd6:	00 
80101dd7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dde:	89 04 24             	mov    %eax,(%esp)
80101de1:	e8 7a 26 00 00       	call   80104460 <memmove>
80101de6:	eb 03                	jmp    80101deb <namex+0x9b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
80101de8:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101deb:	80 3e 2f             	cmpb   $0x2f,(%esi)
80101dee:	74 f8                	je     80101de8 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80101df0:	85 f6                	test   %esi,%esi
80101df2:	74 9a                	je     80101d8e <namex+0x3e>
    ilock(ip);
80101df4:	89 3c 24             	mov    %edi,(%esp)
80101df7:	e8 b4 fb ff ff       	call   801019b0 <ilock>
    if(ip->type != T_DIR){
80101dfc:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101e01:	75 67                	jne    80101e6a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e06:	85 c0                	test   %eax,%eax
80101e08:	74 0c                	je     80101e16 <namex+0xc6>
80101e0a:	80 3e 00             	cmpb   $0x0,(%esi)
80101e0d:	8d 76 00             	lea    0x0(%esi),%esi
80101e10:	0f 84 7e 00 00 00    	je     80101e94 <namex+0x144>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e1d:	00 
80101e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e21:	89 3c 24             	mov    %edi,(%esp)
80101e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e28:	e8 03 fa ff ff       	call   80101830 <dirlookup>
80101e2d:	85 c0                	test   %eax,%eax
80101e2f:	89 c3                	mov    %eax,%ebx
80101e31:	74 37                	je     80101e6a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
80101e33:	89 3c 24             	mov    %edi,(%esp)
80101e36:	89 df                	mov    %ebx,%edi
80101e38:	89 f3                	mov    %esi,%ebx
80101e3a:	e8 f1 fe ff ff       	call   80101d30 <iunlockput>
80101e3f:	e9 3f ff ff ff       	jmp    80101d83 <namex+0x33>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101e44:	89 de                	mov    %ebx,%esi
80101e46:	31 d2                	xor    %edx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e48:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e4c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e53:	89 04 24             	mov    %eax,(%esp)
80101e56:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e59:	e8 02 26 00 00       	call   80104460 <memmove>
    name[len] = 0;
80101e5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e64:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
80101e68:	eb 81                	jmp    80101deb <namex+0x9b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
80101e6a:	89 3c 24             	mov    %edi,(%esp)
80101e6d:	31 ff                	xor    %edi,%edi
80101e6f:	e8 bc fe ff ff       	call   80101d30 <iunlockput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e74:	83 c4 2c             	add    $0x2c,%esp
80101e77:	89 f8                	mov    %edi,%eax
80101e79:	5b                   	pop    %ebx
80101e7a:	5e                   	pop    %esi
80101e7b:	5f                   	pop    %edi
80101e7c:	5d                   	pop    %ebp
80101e7d:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e7e:	ba 01 00 00 00       	mov    $0x1,%edx
80101e83:	b8 01 00 00 00       	mov    $0x1,%eax
80101e88:	e8 23 f3 ff ff       	call   801011b0 <iget>
80101e8d:	89 c7                	mov    %eax,%edi
80101e8f:	e9 ef fe ff ff       	jmp    80101d83 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e94:	89 3c 24             	mov    %edi,(%esp)
80101e97:	e8 44 fe ff ff       	call   80101ce0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e9c:	83 c4 2c             	add    $0x2c,%esp
80101e9f:	89 f8                	mov    %edi,%eax
80101ea1:	5b                   	pop    %ebx
80101ea2:	5e                   	pop    %esi
80101ea3:	5f                   	pop    %edi
80101ea4:	5d                   	pop    %ebp
80101ea5:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101ea6:	89 3c 24             	mov    %edi,(%esp)
80101ea9:	31 ff                	xor    %edi,%edi
80101eab:	e8 e0 fb ff ff       	call   80101a90 <iput>
    return 0;
80101eb0:	e9 e4 fe ff ff       	jmp    80101d99 <namex+0x49>
80101eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ec0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ec1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ec6:	89 e5                	mov    %esp,%ebp
80101ec8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ece:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ed1:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ed2:	e9 79 fe ff ff       	jmp    80101d50 <namex>
80101ed7:	89 f6                	mov    %esi,%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 5d fe ff ff       	call   80101d50 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	53                   	push   %ebx
  int i = 0;
  
  initlock(&icache.lock, "icache");
80101f04:	31 db                	xor    %ebx,%ebx
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101f06:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
80101f09:	c7 44 24 04 e8 70 10 	movl   $0x801070e8,0x4(%esp)
80101f10:	80 
80101f11:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101f18:	e8 63 22 00 00       	call   80104180 <initlock>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101f20:	8d 04 db             	lea    (%ebx,%ebx,8),%eax
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101f23:	83 c3 01             	add    $0x1,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101f26:	c1 e0 04             	shl    $0x4,%eax
80101f29:	05 40 0a 11 80       	add    $0x80110a40,%eax
80101f2e:	c7 44 24 04 ef 70 10 	movl   $0x801070ef,0x4(%esp)
80101f35:	80 
80101f36:	89 04 24             	mov    %eax,(%esp)
80101f39:	e8 02 22 00 00       	call   80104140 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101f3e:	83 fb 32             	cmp    $0x32,%ebx
80101f41:	75 dd                	jne    80101f20 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
80101f43:	8b 45 08             	mov    0x8(%ebp),%eax
80101f46:	c7 44 24 04 e0 09 11 	movl   $0x801109e0,0x4(%esp)
80101f4d:	80 
80101f4e:	89 04 24             	mov    %eax,(%esp)
80101f51:	e8 da f3 ff ff       	call   80101330 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101f56:	a1 f8 09 11 80       	mov    0x801109f8,%eax
80101f5b:	c7 04 24 f8 70 10 80 	movl   $0x801070f8,(%esp)
80101f62:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101f66:	a1 f4 09 11 80       	mov    0x801109f4,%eax
80101f6b:	89 44 24 18          	mov    %eax,0x18(%esp)
80101f6f:	a1 f0 09 11 80       	mov    0x801109f0,%eax
80101f74:	89 44 24 14          	mov    %eax,0x14(%esp)
80101f78:	a1 ec 09 11 80       	mov    0x801109ec,%eax
80101f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
80101f81:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101f86:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101f8a:	a1 e4 09 11 80       	mov    0x801109e4,%eax
80101f8f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f93:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101f98:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f9c:	e8 af e8 ff ff       	call   80100850 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101fa1:	83 c4 24             	add    $0x24,%esp
80101fa4:	5b                   	pop    %ebx
80101fa5:	5d                   	pop    %ebp
80101fa6:	c3                   	ret    
80101fa7:	66 90                	xchg   %ax,%ax
80101fa9:	66 90                	xchg   %ax,%ax
80101fab:	66 90                	xchg   %ax,%ax
80101fad:	66 90                	xchg   %ax,%ax
80101faf:	90                   	nop

80101fb0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 c1                	mov    %eax,%ecx
80101fb3:	89 e5                	mov    %esp,%ebp
80101fb5:	56                   	push   %esi
80101fb6:	53                   	push   %ebx
80101fb7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101fba:	85 c0                	test   %eax,%eax
80101fbc:	0f 84 99 00 00 00    	je     8010205b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fc2:	8b 58 08             	mov    0x8(%eax),%ebx
80101fc5:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fcb:	0f 87 7e 00 00 00    	ja     8010204f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd6:	66 90                	xchg   %ax,%ax
80101fd8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fd9:	25 c0 00 00 00       	and    $0xc0,%eax
80101fde:	83 f8 40             	cmp    $0x40,%eax
80101fe1:	75 f5                	jne    80101fd8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fe3:	31 f6                	xor    %esi,%esi
80101fe5:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fea:	89 f0                	mov    %esi,%eax
80101fec:	ee                   	out    %al,(%dx)
80101fed:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ff2:	b8 01 00 00 00       	mov    $0x1,%eax
80101ff7:	ee                   	out    %al,(%dx)
80101ff8:	b2 f3                	mov    $0xf3,%dl
80101ffa:	89 d8                	mov    %ebx,%eax
80101ffc:	ee                   	out    %al,(%dx)
80101ffd:	89 d8                	mov    %ebx,%eax
80101fff:	b2 f4                	mov    $0xf4,%dl
80102001:	c1 f8 08             	sar    $0x8,%eax
80102004:	ee                   	out    %al,(%dx)
80102005:	b2 f5                	mov    $0xf5,%dl
80102007:	89 f0                	mov    %esi,%eax
80102009:	ee                   	out    %al,(%dx)
8010200a:	8b 41 04             	mov    0x4(%ecx),%eax
8010200d:	b2 f6                	mov    $0xf6,%dl
8010200f:	83 e0 01             	and    $0x1,%eax
80102012:	c1 e0 04             	shl    $0x4,%eax
80102015:	83 c8 e0             	or     $0xffffffe0,%eax
80102018:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102019:	f6 01 04             	testb  $0x4,(%ecx)
8010201c:	75 12                	jne    80102030 <idestart+0x80>
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	b8 20 00 00 00       	mov    $0x20,%eax
80102028:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	5b                   	pop    %ebx
8010202d:	5e                   	pop    %esi
8010202e:	5d                   	pop    %ebp
8010202f:	c3                   	ret    
80102030:	b2 f7                	mov    $0xf7,%dl
80102032:	b8 30 00 00 00       	mov    $0x30,%eax
80102037:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102038:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010203d:	8d 71 5c             	lea    0x5c(%ecx),%esi
80102040:	b9 80 00 00 00       	mov    $0x80,%ecx
80102045:	fc                   	cld    
80102046:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	5b                   	pop    %ebx
8010204c:	5e                   	pop    %esi
8010204d:	5d                   	pop    %ebp
8010204e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010204f:	c7 04 24 54 71 10 80 	movl   $0x80107154,(%esp)
80102056:	e8 55 e3 ff ff       	call   801003b0 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010205b:	c7 04 24 4b 71 10 80 	movl   $0x8010714b,(%esp)
80102062:	e8 49 e3 ff ff       	call   801003b0 <panic>
80102067:	89 f6                	mov    %esi,%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102070 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	53                   	push   %ebx
80102074:	83 ec 14             	sub    $0x14,%esp
80102077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010207a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010207d:	89 04 24             	mov    %eax,(%esp)
80102080:	e8 eb 1f 00 00       	call   80104070 <holdingsleep>
80102085:	85 c0                	test   %eax,%eax
80102087:	0f 84 8f 00 00 00    	je     8010211c <iderw+0xac>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010208d:	8b 03                	mov    (%ebx),%eax
8010208f:	83 e0 06             	and    $0x6,%eax
80102092:	83 f8 02             	cmp    $0x2,%eax
80102095:	0f 84 99 00 00 00    	je     80102134 <iderw+0xc4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010209b:	8b 53 04             	mov    0x4(%ebx),%edx
8010209e:	85 d2                	test   %edx,%edx
801020a0:	74 09                	je     801020ab <iderw+0x3b>
801020a2:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801020a7:	85 c0                	test   %eax,%eax
801020a9:	74 7d                	je     80102128 <iderw+0xb8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801020ab:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020b2:	e8 79 22 00 00       	call   80104330 <acquire>

  //sti();
  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020b7:	ba b4 a5 10 80       	mov    $0x8010a5b4,%edx

  acquire(&idelock);  //DOC:acquire-lock

  //sti();
  // Append b to idequeue.
  b->qnext = 0;
801020bc:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
801020c3:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020c8:	85 c0                	test   %eax,%eax
801020ca:	74 0e                	je     801020da <iderw+0x6a>
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020d0:	8d 50 58             	lea    0x58(%eax),%edx
801020d3:	8b 40 58             	mov    0x58(%eax),%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	75 f6                	jne    801020d0 <iderw+0x60>
    ;
  *pp = b;
801020da:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801020dc:	39 1d b4 a5 10 80    	cmp    %ebx,0x8010a5b4
801020e2:	75 14                	jne    801020f8 <iderw+0x88>
801020e4:	eb 2d                	jmp    80102113 <iderw+0xa3>
801020e6:	66 90                	xchg   %ax,%ax
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
801020e8:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801020ef:	80 
801020f0:	89 1c 24             	mov    %ebx,(%esp)
801020f3:	e8 18 1c 00 00       	call   80103d10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020f8:	8b 03                	mov    (%ebx),%eax
801020fa:	83 e0 06             	and    $0x6,%eax
801020fd:	83 f8 02             	cmp    $0x2,%eax
80102100:	75 e6                	jne    801020e8 <iderw+0x78>
    sleep(b, &idelock);
  }
  //cli();
  release(&idelock);
80102102:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102109:	83 c4 14             	add    $0x14,%esp
8010210c:	5b                   	pop    %ebx
8010210d:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }
  //cli();
  release(&idelock);
8010210e:	e9 cd 21 00 00       	jmp    801042e0 <release>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102113:	89 d8                	mov    %ebx,%eax
80102115:	e8 96 fe ff ff       	call   80101fb0 <idestart>
8010211a:	eb dc                	jmp    801020f8 <iderw+0x88>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010211c:	c7 04 24 66 71 10 80 	movl   $0x80107166,(%esp)
80102123:	e8 88 e2 ff ff       	call   801003b0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102128:	c7 04 24 91 71 10 80 	movl   $0x80107191,(%esp)
8010212f:	e8 7c e2 ff ff       	call   801003b0 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102134:	c7 04 24 7c 71 10 80 	movl   $0x8010717c,(%esp)
8010213b:	e8 70 e2 ff ff       	call   801003b0 <panic>

80102140 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	53                   	push   %ebx
80102145:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102148:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010214f:	e8 dc 21 00 00       	call   80104330 <acquire>

  if((b = idequeue) == 0){
80102154:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010215a:	85 db                	test   %ebx,%ebx
8010215c:	74 2d                	je     8010218b <ideintr+0x4b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010215e:	8b 43 58             	mov    0x58(%ebx),%eax
80102161:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102166:	8b 0b                	mov    (%ebx),%ecx
80102168:	f6 c1 04             	test   $0x4,%cl
8010216b:	74 33                	je     801021a0 <ideintr+0x60>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
8010216d:	83 c9 02             	or     $0x2,%ecx
80102170:	83 e1 fb             	and    $0xfffffffb,%ecx
80102173:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102175:	89 1c 24             	mov    %ebx,(%esp)
80102178:	e8 43 15 00 00       	call   801036c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010217d:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
80102182:	85 c0                	test   %eax,%eax
80102184:	74 05                	je     8010218b <ideintr+0x4b>
    idestart(idequeue);
80102186:	e8 25 fe ff ff       	call   80101fb0 <idestart>

  release(&idelock);
8010218b:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102192:	e8 49 21 00 00       	call   801042e0 <release>
}
80102197:	83 c4 10             	add    $0x10,%esp
8010219a:	5b                   	pop    %ebx
8010219b:	5f                   	pop    %edi
8010219c:	5d                   	pop    %ebp
8010219d:	c3                   	ret    
8010219e:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	8d 76 00             	lea    0x0(%esi),%esi
801021a8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021a9:	0f b6 c0             	movzbl %al,%eax
801021ac:	89 c7                	mov    %eax,%edi
801021ae:	81 e7 c0 00 00 00    	and    $0xc0,%edi
801021b4:	83 ff 40             	cmp    $0x40,%edi
801021b7:	75 ef                	jne    801021a8 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021b9:	a8 21                	test   $0x21,%al
801021bb:	75 b0                	jne    8010216d <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801021bd:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801021c0:	b9 80 00 00 00       	mov    $0x80,%ecx
801021c5:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ca:	fc                   	cld    
801021cb:	f3 6d                	rep insl (%dx),%es:(%edi)
801021cd:	8b 0b                	mov    (%ebx),%ecx
801021cf:	eb 9c                	jmp    8010216d <ideintr+0x2d>
801021d1:	eb 0d                	jmp    801021e0 <ideinit>
801021d3:	90                   	nop
801021d4:	90                   	nop
801021d5:	90                   	nop
801021d6:	90                   	nop
801021d7:	90                   	nop
801021d8:	90                   	nop
801021d9:	90                   	nop
801021da:	90                   	nop
801021db:	90                   	nop
801021dc:	90                   	nop
801021dd:	90                   	nop
801021de:	90                   	nop
801021df:	90                   	nop

801021e0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801021e6:	c7 44 24 04 af 71 10 	movl   $0x801071af,0x4(%esp)
801021ed:	80 
801021ee:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021f5:	e8 86 1f 00 00       	call   80104180 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021fa:	a1 20 2d 11 80       	mov    0x80112d20,%eax
801021ff:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102206:	83 e8 01             	sub    $0x1,%eax
80102209:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220d:	e8 4e 00 00 00       	call   80102260 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102212:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102217:	90                   	nop
80102218:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102219:	25 c0 00 00 00       	and    $0xc0,%eax
8010221e:	83 f8 40             	cmp    $0x40,%eax
80102221:	75 f5                	jne    80102218 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102223:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102228:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010222d:	ee                   	out    %al,(%dx)
8010222e:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102230:	b2 f7                	mov    $0xf7,%dl
80102232:	eb 0f                	jmp    80102243 <ideinit+0x63>
80102234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102238:	83 c1 01             	add    $0x1,%ecx
8010223b:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
80102241:	74 0f                	je     80102252 <ideinit+0x72>
80102243:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102244:	84 c0                	test   %al,%al
80102246:	74 f0                	je     80102238 <ideinit+0x58>
      havedisk1 = 1;
80102248:	c7 05 b8 a5 10 80 01 	movl   $0x1,0x8010a5b8
8010224f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102252:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102257:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010225c:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010225d:	c9                   	leave  
8010225e:	c3                   	ret    
8010225f:	90                   	nop

80102260 <ioapicenable>:
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102260:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102261:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102267:	89 e5                	mov    %esp,%ebp
80102269:	8b 55 08             	mov    0x8(%ebp),%edx
8010226c:	53                   	push   %ebx
8010226d:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102270:	8d 5a 20             	lea    0x20(%edx),%ebx
80102273:	8d 54 12 10          	lea    0x10(%edx,%edx,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102277:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102279:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227f:	83 c2 01             	add    $0x1,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102282:	c1 e0 18             	shl    $0x18,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102285:	89 59 10             	mov    %ebx,0x10(%ecx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102288:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010228e:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102290:	8b 15 54 26 11 80    	mov    0x80112654,%edx
80102296:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102299:	5b                   	pop    %ebx
8010229a:	5d                   	pop    %ebp
8010229b:	c3                   	ret    
8010229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	56                   	push   %esi
801022a4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022a5:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022aa:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022ad:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022b4:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022bb:	00 00 00 
  return ioapic->data;
801022be:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022c4:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
801022cb:	00 00 00 
  return ioapic->data;
801022ce:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
void
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022d3:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801022da:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022dd:	c1 ee 10             	shr    $0x10,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022e0:	c1 e8 18             	shr    $0x18,%eax
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022e3:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022e9:	39 c2                	cmp    %eax,%edx
801022eb:	74 12                	je     801022ff <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022ed:	c7 04 24 b4 71 10 80 	movl   $0x801071b4,(%esp)
801022f4:	e8 57 e5 ff ff       	call   80100850 <cprintf>
801022f9:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801022ff:	ba 10 00 00 00       	mov    $0x10,%edx
80102304:	31 c0                	xor    %eax,%eax
80102306:	eb 06                	jmp    8010230e <ioapicinit+0x6e>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102308:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010230e:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102310:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102316:	8d 48 20             	lea    0x20(%eax),%ecx
80102319:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010231f:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102322:	89 4b 10             	mov    %ecx,0x10(%ebx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102325:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010232b:	8d 5a 01             	lea    0x1(%edx),%ebx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010232e:	83 c2 02             	add    $0x2,%edx
80102331:	39 c6                	cmp    %eax,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102333:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102335:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010233b:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102342:	7d c4                	jge    80102308 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102344:	83 c4 10             	add    $0x10,%esp
80102347:	5b                   	pop    %ebx
80102348:	5e                   	pop    %esi
80102349:	5d                   	pop    %ebp
8010234a:	c3                   	ret    
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102357:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010235d:	85 d2                	test   %edx,%edx
8010235f:	75 2f                	jne    80102390 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102361:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102367:	85 db                	test   %ebx,%ebx
80102369:	74 07                	je     80102372 <kalloc+0x22>
    kmem.freelist = r->next;
8010236b:	8b 03                	mov    (%ebx),%eax
8010236d:	a3 98 26 11 80       	mov    %eax,0x80112698
  if(kmem.use_lock)
80102372:	a1 94 26 11 80       	mov    0x80112694,%eax
80102377:	85 c0                	test   %eax,%eax
80102379:	74 0c                	je     80102387 <kalloc+0x37>
    release(&kmem.lock);
8010237b:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102382:	e8 59 1f 00 00       	call   801042e0 <release>
  return (char*)r;
}
80102387:	89 d8                	mov    %ebx,%eax
80102389:	83 c4 14             	add    $0x14,%esp
8010238c:	5b                   	pop    %ebx
8010238d:	5d                   	pop    %ebp
8010238e:	c3                   	ret    
8010238f:	90                   	nop
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102390:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102397:	e8 94 1f 00 00       	call   80104330 <acquire>
8010239c:	eb c3                	jmp    80102361 <kalloc+0x11>
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	53                   	push   %ebx
801023a4:	83 ec 14             	sub    $0x14,%esp
801023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023b0:	75 7c                	jne    8010242e <kfree+0x8e>
801023b2:	81 fb c8 57 11 80    	cmp    $0x801157c8,%ebx
801023b8:	72 74                	jb     8010242e <kfree+0x8e>
801023ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023c5:	77 67                	ja     8010242e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801023ce:	00 
801023cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023d6:	00 
801023d7:	89 1c 24             	mov    %ebx,(%esp)
801023da:	e8 c1 1f 00 00       	call   801043a0 <memset>

  if(kmem.use_lock)
801023df:	a1 94 26 11 80       	mov    0x80112694,%eax
801023e4:	85 c0                	test   %eax,%eax
801023e6:	75 38                	jne    80102420 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023e8:	a1 98 26 11 80       	mov    0x80112698,%eax
801023ed:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023ef:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023f5:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801023fb:	85 c9                	test   %ecx,%ecx
801023fd:	75 09                	jne    80102408 <kfree+0x68>
    release(&kmem.lock);
}
801023ff:	83 c4 14             	add    $0x14,%esp
80102402:	5b                   	pop    %ebx
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102408:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010240f:	83 c4 14             	add    $0x14,%esp
80102412:	5b                   	pop    %ebx
80102413:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102414:	e9 c7 1e 00 00       	jmp    801042e0 <release>
80102419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102420:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
80102427:	e8 04 1f 00 00       	call   80104330 <acquire>
8010242c:	eb ba                	jmp    801023e8 <kfree+0x48>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010242e:	c7 04 24 e6 71 10 80 	movl   $0x801071e6,(%esp)
80102435:	e8 76 df ff ff       	call   801003b0 <panic>
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102440 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 55 08             	mov    0x8(%ebp),%edx
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 f3                	cmp    %esi,%ebx
80102462:	76 08                	jbe    8010246c <freerange+0x2c>
80102464:	eb 18                	jmp    8010247e <freerange+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 2c ff ff ff       	call   801023a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 f0                	cmp    %esi,%eax
8010247c:	76 ea                	jbe    80102468 <freerange+0x28>
    kfree(p);
}
8010247e:	83 c4 10             	add    $0x10,%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102496:	8b 45 0c             	mov    0xc(%ebp),%eax
80102499:	89 44 24 04          	mov    %eax,0x4(%esp)
8010249d:	8b 45 08             	mov    0x8(%ebp),%eax
801024a0:	89 04 24             	mov    %eax,(%esp)
801024a3:	e8 98 ff ff ff       	call   80102440 <freerange>
  kmem.use_lock = 1;
801024a8:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801024af:	00 00 00 
}
801024b2:	c9                   	leave  
801024b3:	c3                   	ret    
801024b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801024c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	83 ec 18             	sub    $0x18,%esp
801024c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801024c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801024cc:	89 75 fc             	mov    %esi,-0x4(%ebp)
801024cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024d2:	c7 44 24 04 ec 71 10 	movl   $0x801071ec,0x4(%esp)
801024d9:	80 
801024da:	c7 04 24 60 26 11 80 	movl   $0x80112660,(%esp)
801024e1:	e8 9a 1c 00 00       	call   80104180 <initlock>
  kmem.use_lock = 0;
801024e6:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801024ed:	00 00 00 
  freerange(vstart, vend);
801024f0:	89 75 0c             	mov    %esi,0xc(%ebp)
}
801024f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801024f9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801024fc:	89 ec                	mov    %ebp,%esp
801024fe:	5d                   	pop    %ebp
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024ff:	e9 3c ff ff ff       	jmp    80102440 <freerange>
80102504:	66 90                	xchg   %ax,%ax
80102506:	66 90                	xchg   %ax,%ax
80102508:	66 90                	xchg   %ax,%ax
8010250a:	66 90                	xchg   %ax,%ax
8010250c:	66 90                	xchg   %ax,%ax
8010250e:	66 90                	xchg   %ax,%ax

80102510 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102510:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102511:	ba 64 00 00 00       	mov    $0x64,%edx
80102516:	89 e5                	mov    %esp,%ebp
80102518:	ec                   	in     (%dx),%al
80102519:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010251b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102520:	83 e2 01             	and    $0x1,%edx
80102523:	74 41                	je     80102566 <kbdgetc+0x56>
80102525:	ba 60 00 00 00       	mov    $0x60,%edx
8010252a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010252b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
8010252e:	3d e0 00 00 00       	cmp    $0xe0,%eax
80102533:	0f 84 7f 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102539:	84 c0                	test   %al,%al
8010253b:	79 2b                	jns    80102568 <kbdgetc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010253d:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80102543:	89 c1                	mov    %eax,%ecx
80102545:	83 e1 7f             	and    $0x7f,%ecx
80102548:	f6 c2 40             	test   $0x40,%dl
8010254b:	0f 44 c1             	cmove  %ecx,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010254e:	0f b6 80 00 72 10 80 	movzbl -0x7fef8e00(%eax),%eax
80102555:	83 c8 40             	or     $0x40,%eax
80102558:	0f b6 c0             	movzbl %al,%eax
8010255b:	f7 d0                	not    %eax
8010255d:	21 d0                	and    %edx,%eax
8010255f:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
80102564:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102566:	5d                   	pop    %ebp
80102567:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102568:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
8010256e:	f6 c1 40             	test   $0x40,%cl
80102571:	74 05                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102573:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
80102575:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102578:	0f b6 90 00 72 10 80 	movzbl -0x7fef8e00(%eax),%edx
8010257f:	09 ca                	or     %ecx,%edx
80102581:	0f b6 88 00 73 10 80 	movzbl -0x7fef8d00(%eax),%ecx
80102588:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d1                	mov    %edx,%ecx
8010258c:	83 e1 03             	and    $0x3,%ecx
8010258f:	8b 0c 8d 00 74 10 80 	mov    -0x7fef8c00(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102596:	89 15 bc a5 10 80    	mov    %edx,0x8010a5bc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 c1                	je     80102566 <kbdgetc+0x56>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5d                   	pop    %ebp
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b8:	30 c0                	xor    %al,%al
801025ba:	83 0d bc a5 10 80 40 	orl    $0x40,0x8010a5bc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	90                   	nop
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
801025d6:	8d 76 00             	lea    0x0(%esi),%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 2e e0 ff ff       	call   80100620 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102600:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102605:	55                   	push   %ebp
80102606:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102608:	85 c0                	test   %eax,%eax
8010260a:	0f 84 09 01 00 00    	je     80102719 <lapicinit+0x119>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102610:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102617:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010261a:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010261f:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102622:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102629:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010262c:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102631:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102634:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010263b:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
8010263e:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102643:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102646:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010264d:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102650:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102655:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102658:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010265f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102662:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102667:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266a:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102671:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102679:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010267c:	8b 50 30             	mov    0x30(%eax),%edx
8010267f:	c1 ea 10             	shr    $0x10,%edx
80102682:	80 fa 03             	cmp    $0x3,%dl
80102685:	0f 87 95 00 00 00    	ja     80102720 <lapicinit+0x120>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268b:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102692:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102695:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010269a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026ac:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026af:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026b6:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b9:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026d0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d3:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026e2:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e5:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026ec:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026ef:	8b 0d 9c 26 11 80    	mov    0x8011269c,%ecx
801026f5:	8b 41 20             	mov    0x20(%ecx),%eax
801026f8:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
801026fe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 02                	mov    (%edx),%eax
80102702:	f6 c4 10             	test   $0x10,%ah
80102705:	75 f9                	jne    80102700 <lapicinit+0x100>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102707:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
8010270e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102711:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102716:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010272f:	8b 50 20             	mov    0x20(%eax),%edx
80102732:	e9 54 ff ff ff       	jmp    8010268b <lapicinit+0x8b>
80102737:	89 f6                	mov    %esi,%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
80102746:	31 c0                	xor    %eax,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102748:	55                   	push   %ebp
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 12                	je     8010277e <lapiceoi+0x1e>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010277b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
8010277e:	5d                   	pop    %ebp
8010277f:	c3                   	ret    

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	ba 70 00 00 00       	mov    $0x70,%edx
80102796:	89 e5                	mov    %esp,%ebp
80102798:	b8 0f 00 00 00       	mov    $0xf,%eax
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
801027a5:	ee                   	out    %al,(%dx)
801027a6:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ab:	b2 71                	mov    $0x71,%dl
801027ad:	ee                   	out    %al,(%dx)
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027ae:	89 c8                	mov    %ecx,%eax
801027b0:	c1 e8 04             	shr    $0x4,%eax
801027b3:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b9:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027be:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c1:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801027c8:	00 00 
//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
801027ca:	c1 e9 0c             	shr    $0xc,%ecx
801027cd:	80 cd 06             	or     $0x6,%ch

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d6:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027db:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027de:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e5:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e8:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027ed:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f0:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f7:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fa:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027ff:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102802:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102808:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010280d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102810:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102816:	a1 9c 26 11 80       	mov    0x8011269c,%eax
8010281b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281e:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102829:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282c:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
80102839:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 6c             	sub    $0x6c,%esp
80102853:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102857:	bb 70 00 00 00       	mov    $0x70,%ebx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285c:	88 45 a7             	mov    %al,-0x59(%ebp)
8010285f:	90                   	nop
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102860:	31 c0                	xor    %eax,%eax
80102862:	89 da                	mov    %ebx,%edx
80102864:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102865:	b9 71 00 00 00       	mov    $0x71,%ecx
8010286a:	89 ca                	mov    %ecx,%edx
8010286c:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010286d:	0f b6 f0             	movzbl %al,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	89 da                	mov    %ebx,%edx
80102872:	b8 02 00 00 00       	mov    $0x2,%eax
80102877:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102878:	89 ca                	mov    %ecx,%edx
8010287a:	ec                   	in     (%dx),%al
8010287b:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287e:	89 da                	mov    %ebx,%edx
80102880:	89 45 a8             	mov    %eax,-0x58(%ebp)
80102883:	b8 04 00 00 00       	mov    $0x4,%eax
80102888:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102889:	89 ca                	mov    %ecx,%edx
8010288b:	ec                   	in     (%dx),%al
8010288c:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	89 45 ac             	mov    %eax,-0x54(%ebp)
80102894:	b8 07 00 00 00       	mov    $0x7,%eax
80102899:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
8010289d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a0:	89 da                	mov    %ebx,%edx
801028a2:	89 45 b0             	mov    %eax,-0x50(%ebp)
801028a5:	b8 08 00 00 00       	mov    $0x8,%eax
801028aa:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ab:	89 ca                	mov    %ecx,%edx
801028ad:	ec                   	in     (%dx),%al
801028ae:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b1:	89 da                	mov    %ebx,%edx
801028b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801028b6:	b8 09 00 00 00       	mov    $0x9,%eax
801028bb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bc:	89 ca                	mov    %ecx,%edx
801028be:	ec                   	in     (%dx),%al
801028bf:	0f b6 f8             	movzbl %al,%edi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c2:	89 da                	mov    %ebx,%edx
801028c4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028c9:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ca:	89 ca                	mov    %ecx,%edx
801028cc:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028cd:	84 c0                	test   %al,%al
801028cf:	78 8f                	js     80102860 <cmostime+0x20>
801028d1:	8b 45 a8             	mov    -0x58(%ebp),%eax
801028d4:	8b 55 ac             	mov    -0x54(%ebp),%edx
801028d7:	89 75 d0             	mov    %esi,-0x30(%ebp)
801028da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801028dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
801028e3:	89 55 d8             	mov    %edx,-0x28(%ebp)
801028e6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801028e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	31 c0                	xor    %eax,%eax
801028ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
801028f1:	89 da                	mov    %ebx,%edx
801028f3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f4:	89 ca                	mov    %ecx,%edx
801028f6:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028f7:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028fa:	89 da                	mov    %ebx,%edx
801028fc:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028ff:	b8 02 00 00 00       	mov    $0x2,%eax
80102904:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102905:	89 ca                	mov    %ecx,%edx
80102907:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102908:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290b:	89 da                	mov    %ebx,%edx
8010290d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102910:	b8 04 00 00 00       	mov    $0x4,%eax
80102915:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102916:	89 ca                	mov    %ecx,%edx
80102918:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102919:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291c:	89 da                	mov    %ebx,%edx
8010291e:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102921:	b8 07 00 00 00       	mov    $0x7,%eax
80102926:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102927:	89 ca                	mov    %ecx,%edx
80102929:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
8010292a:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292d:	89 da                	mov    %ebx,%edx
8010292f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102932:	b8 08 00 00 00       	mov    $0x8,%eax
80102937:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102938:	89 ca                	mov    %ecx,%edx
8010293a:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
8010293b:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010293e:	89 da                	mov    %ebx,%edx
80102940:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102943:	b8 09 00 00 00       	mov    $0x9,%eax
80102948:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102949:	89 ca                	mov    %ecx,%edx
8010294b:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
8010294c:	0f b6 c8             	movzbl %al,%ecx
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294f:	8d 55 d0             	lea    -0x30(%ebp),%edx
80102952:	8d 45 b8             	lea    -0x48(%ebp),%eax
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102955:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102958:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010295f:	00 
80102960:	89 44 24 04          	mov    %eax,0x4(%esp)
80102964:	89 14 24             	mov    %edx,(%esp)
80102967:	e8 94 1a 00 00       	call   80104400 <memcmp>
8010296c:	85 c0                	test   %eax,%eax
8010296e:	0f 85 ec fe ff ff    	jne    80102860 <cmostime+0x20>
      break;
  }

  // convert
  if(bcd) {
80102974:	f6 45 a7 04          	testb  $0x4,-0x59(%ebp)
80102978:	75 78                	jne    801029f2 <cmostime+0x1b2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010297a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010297d:	89 c2                	mov    %eax,%edx
8010297f:	83 e0 0f             	and    $0xf,%eax
80102982:	c1 ea 04             	shr    $0x4,%edx
80102985:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102988:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010298e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102991:	89 c2                	mov    %eax,%edx
80102993:	83 e0 0f             	and    $0xf,%eax
80102996:	c1 ea 04             	shr    $0x4,%edx
80102999:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801029a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801029a5:	89 c2                	mov    %eax,%edx
801029a7:	83 e0 0f             	and    $0xf,%eax
801029aa:	c1 ea 04             	shr    $0x4,%edx
801029ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801029b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801029b9:	89 c2                	mov    %eax,%edx
801029bb:	83 e0 0f             	and    $0xf,%eax
801029be:	c1 ea 04             	shr    $0x4,%edx
801029c1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801029ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801029cd:	89 c2                	mov    %eax,%edx
801029cf:	83 e0 0f             	and    $0xf,%eax
801029d2:	c1 ea 04             	shr    $0x4,%edx
801029d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801029de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801029e1:	89 c2                	mov    %eax,%edx
801029e3:	83 e0 0f             	and    $0xf,%eax
801029e6:	c1 ea 04             	shr    $0x4,%edx
801029e9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ec:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801029f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
801029f5:	8b 55 08             	mov    0x8(%ebp),%edx
801029f8:	89 02                	mov    %eax,(%edx)
801029fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801029fd:	89 42 04             	mov    %eax,0x4(%edx)
80102a00:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102a03:	89 42 08             	mov    %eax,0x8(%edx)
80102a06:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102a09:	89 42 0c             	mov    %eax,0xc(%edx)
80102a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102a0f:	89 42 10             	mov    %eax,0x10(%edx)
80102a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102a15:	89 42 14             	mov    %eax,0x14(%edx)
  r->year += 2000;
80102a18:	81 42 14 d0 07 00 00 	addl   $0x7d0,0x14(%edx)
}
80102a1f:	83 c4 6c             	add    $0x6c,%esp
80102a22:	5b                   	pop    %ebx
80102a23:	5e                   	pop    %esi
80102a24:	5f                   	pop    %edi
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
80102a34:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a37:	a1 e8 26 11 80       	mov    0x801126e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a3f:	83 f8 1d             	cmp    $0x1d,%eax
80102a42:	7f 7e                	jg     80102ac2 <log_write+0x92>
80102a44:	8b 15 d8 26 11 80    	mov    0x801126d8,%edx
80102a4a:	83 ea 01             	sub    $0x1,%edx
80102a4d:	39 d0                	cmp    %edx,%eax
80102a4f:	7d 71                	jge    80102ac2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a51:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102a56:	85 c0                	test   %eax,%eax
80102a58:	7e 74                	jle    80102ace <log_write+0x9e>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a5a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102a61:	e8 ca 18 00 00       	call   80104330 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a66:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102a6c:	85 c9                	test   %ecx,%ecx
80102a6e:	7e 4b                	jle    80102abb <log_write+0x8b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a70:	8b 53 08             	mov    0x8(%ebx),%edx
80102a73:	31 c0                	xor    %eax,%eax
80102a75:	39 15 ec 26 11 80    	cmp    %edx,0x801126ec
80102a7b:	75 0c                	jne    80102a89 <log_write+0x59>
80102a7d:	eb 11                	jmp    80102a90 <log_write+0x60>
80102a7f:	90                   	nop
80102a80:	3b 14 85 ec 26 11 80 	cmp    -0x7feed914(,%eax,4),%edx
80102a87:	74 07                	je     80102a90 <log_write+0x60>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102a89:	83 c0 01             	add    $0x1,%eax
80102a8c:	39 c8                	cmp    %ecx,%eax
80102a8e:	7c f0                	jl     80102a80 <log_write+0x50>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102a90:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102a97:	39 05 e8 26 11 80    	cmp    %eax,0x801126e8
80102a9d:	75 08                	jne    80102aa7 <log_write+0x77>
    log.lh.n++;
80102a9f:	83 c0 01             	add    $0x1,%eax
80102aa2:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102aa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102aaa:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102ab1:	83 c4 14             	add    $0x14,%esp
80102ab4:	5b                   	pop    %ebx
80102ab5:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102ab6:	e9 25 18 00 00       	jmp    801042e0 <release>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102abb:	8b 53 08             	mov    0x8(%ebx),%edx
80102abe:	31 c0                	xor    %eax,%eax
80102ac0:	eb ce                	jmp    80102a90 <log_write+0x60>
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102ac2:	c7 04 24 10 74 10 80 	movl   $0x80107410,(%esp)
80102ac9:	e8 e2 d8 ff ff       	call   801003b0 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ace:	c7 04 24 26 74 10 80 	movl   $0x80107426,(%esp)
80102ad5:	e8 d6 d8 ff ff       	call   801003b0 <panic>
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	57                   	push   %edi
80102ae4:	56                   	push   %esi
80102ae5:	53                   	push   %ebx
80102ae6:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ae9:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102aef:	85 d2                	test   %edx,%edx
80102af1:	7e 78                	jle    80102b6b <install_trans+0x8b>
80102af3:	31 db                	xor    %ebx,%ebx
80102af5:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102af8:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102afd:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
80102b01:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b05:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b0a:	89 04 24             	mov    %eax,(%esp)
80102b0d:	e8 fe d5 ff ff       	call   80100110 <bread>
80102b12:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b14:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b1b:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b22:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b27:	89 04 24             	mov    %eax,(%esp)
80102b2a:	e8 e1 d5 ff ff       	call   80100110 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b2f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102b36:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b37:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b39:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b43:	89 04 24             	mov    %eax,(%esp)
80102b46:	e8 15 19 00 00       	call   80104460 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b4b:	89 34 24             	mov    %esi,(%esp)
80102b4e:	e8 7d d5 ff ff       	call   801000d0 <bwrite>
    brelse(lbuf);
80102b53:	89 3c 24             	mov    %edi,(%esp)
80102b56:	e8 e5 d4 ff ff       	call   80100040 <brelse>
    brelse(dbuf);
80102b5b:	89 34 24             	mov    %esi,(%esp)
80102b5e:	e8 dd d4 ff ff       	call   80100040 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b63:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102b69:	7f 8d                	jg     80102af8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102b6b:	83 c4 1c             	add    $0x1c,%esp
80102b6e:	5b                   	pop    %ebx
80102b6f:	5e                   	pop    %esi
80102b70:	5f                   	pop    %edi
80102b71:	5d                   	pop    %ebp
80102b72:	c3                   	ret    
80102b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
80102b85:	83 ec 10             	sub    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b88:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b91:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102b96:	89 04 24             	mov    %eax,(%esp)
80102b99:	e8 72 d5 ff ff       	call   80100110 <bread>
80102b9e:	89 c6                	mov    %eax,%esi
  struct logheader *hb = (struct logheader *) (buf->data);
80102ba0:	8d 58 5c             	lea    0x5c(%eax),%ebx
  int i;
  hb->n = log.lh.n;
80102ba3:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ba8:	89 46 5c             	mov    %eax,0x5c(%esi)
  for (i = 0; i < log.lh.n; i++) {
80102bab:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bb1:	85 c9                	test   %ecx,%ecx
80102bb3:	7e 19                	jle    80102bce <write_head+0x4e>
80102bb5:	31 d2                	xor    %edx,%edx
80102bb7:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102bb8:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102bbf:	89 4c 93 04          	mov    %ecx,0x4(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bc3:	83 c2 01             	add    $0x1,%edx
80102bc6:	39 15 e8 26 11 80    	cmp    %edx,0x801126e8
80102bcc:	7f ea                	jg     80102bb8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102bce:	89 34 24             	mov    %esi,(%esp)
80102bd1:	e8 fa d4 ff ff       	call   801000d0 <bwrite>
  brelse(buf);
80102bd6:	89 34 24             	mov    %esi,(%esp)
80102bd9:	e8 62 d4 ff ff       	call   80100040 <brelse>
}
80102bde:	83 c4 10             	add    $0x10,%esp
80102be1:	5b                   	pop    %ebx
80102be2:	5e                   	pop    %esi
80102be3:	5d                   	pop    %ebp
80102be4:	c3                   	ret    
80102be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c00:	e8 2b 17 00 00       	call   80104330 <acquire>
  log.outstanding -= 1;
80102c05:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c0a:	8b 3d e0 26 11 80    	mov    0x801126e0,%edi
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c10:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c13:	85 ff                	test   %edi,%edi
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c15:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c1a:	0f 85 f2 00 00 00    	jne    80102d12 <end_op+0x122>
    panic("log.committing");
  if(log.outstanding == 0){
80102c20:	85 c0                	test   %eax,%eax
80102c22:	0f 85 ca 00 00 00    	jne    80102cf2 <end_op+0x102>
    do_commit = 1;
    log.committing = 1;
80102c28:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c2f:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c32:	31 db                	xor    %ebx,%ebx
80102c34:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102c3b:	e8 a0 16 00 00       	call   801042e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c40:	8b 35 e8 26 11 80    	mov    0x801126e8,%esi
80102c46:	85 f6                	test   %esi,%esi
80102c48:	0f 8e 8e 00 00 00    	jle    80102cdc <end_op+0xec>
80102c4e:	66 90                	xchg   %ax,%ax
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c55:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
80102c59:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5d:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c62:	89 04 24             	mov    %eax,(%esp)
80102c65:	e8 a6 d4 ff ff       	call   80100110 <bread>
80102c6a:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c6c:	8b 04 9d ec 26 11 80 	mov    -0x7feed914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c73:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c76:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7a:	a1 e4 26 11 80       	mov    0x801126e4,%eax
80102c7f:	89 04 24             	mov    %eax,(%esp)
80102c82:	e8 89 d4 ff ff       	call   80100110 <bread>
    memmove(to->data, from->data, BSIZE);
80102c87:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c8e:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c8f:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c91:	83 c0 5c             	add    $0x5c,%eax
80102c94:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c98:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9b:	89 04 24             	mov    %eax,(%esp)
80102c9e:	e8 bd 17 00 00       	call   80104460 <memmove>
    bwrite(to);  // write the log
80102ca3:	89 34 24             	mov    %esi,(%esp)
80102ca6:	e8 25 d4 ff ff       	call   801000d0 <bwrite>
    brelse(from);
80102cab:	89 3c 24             	mov    %edi,(%esp)
80102cae:	e8 8d d3 ff ff       	call   80100040 <brelse>
    brelse(to);
80102cb3:	89 34 24             	mov    %esi,(%esp)
80102cb6:	e8 85 d3 ff ff       	call   80100040 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cbb:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cc1:	7c 8d                	jl     80102c50 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc3:	e8 b8 fe ff ff       	call   80102b80 <write_head>
    install_trans(); // Now install writes to home locations
80102cc8:	e8 13 fe ff ff       	call   80102ae0 <install_trans>
    log.lh.n = 0;
80102ccd:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cd4:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd7:	e8 a4 fe ff ff       	call   80102b80 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdc:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ce3:	e8 48 16 00 00       	call   80104330 <acquire>
    log.committing = 0;
80102ce8:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102cef:	00 00 00 
    wakeup(&log);
80102cf2:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102cf9:	e8 c2 09 00 00       	call   801036c0 <wakeup>
    release(&log.lock);
80102cfe:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d05:	e8 d6 15 00 00       	call   801042e0 <release>
  }
}
80102d0a:	83 c4 1c             	add    $0x1c,%esp
80102d0d:	5b                   	pop    %ebx
80102d0e:	5e                   	pop    %esi
80102d0f:	5f                   	pop    %edi
80102d10:	5d                   	pop    %ebp
80102d11:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d12:	c7 04 24 41 74 10 80 	movl   $0x80107441,(%esp)
80102d19:	e8 92 d6 ff ff       	call   801003b0 <panic>
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102d26:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d2d:	e8 fe 15 00 00       	call   80104330 <acquire>
80102d32:	eb 18                	jmp    80102d4c <begin_op+0x2c>
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80102d38:	c7 44 24 04 a0 26 11 	movl   $0x801126a0,0x4(%esp)
80102d3f:	80 
80102d40:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d47:	e8 c4 0f 00 00       	call   80103d10 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102d4c:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d51:	85 c0                	test   %eax,%eax
80102d53:	75 e3                	jne    80102d38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d55:	8b 15 dc 26 11 80    	mov    0x801126dc,%edx
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102d61:	01 c0                	add    %eax,%eax
80102d63:	03 05 e8 26 11 80    	add    0x801126e8,%eax
80102d69:	83 f8 1e             	cmp    $0x1e,%eax
80102d6c:	7f ca                	jg     80102d38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d6e:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102d75:	89 15 dc 26 11 80    	mov    %edx,0x801126dc
      release(&log.lock);
80102d7b:	e8 60 15 00 00       	call   801042e0 <release>
      break;
    }
  }
}
80102d80:	c9                   	leave  
80102d81:	c3                   	ret    
80102d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d90 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	56                   	push   %esi
80102d94:	53                   	push   %ebx
80102d95:	83 ec 30             	sub    $0x30,%esp
80102d98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102d9b:	c7 44 24 04 50 74 10 	movl   $0x80107450,0x4(%esp)
80102da2:	80 
80102da3:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102daa:	e8 d1 13 00 00       	call   80104180 <initlock>
  readsb(dev, &sb);
80102daf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102db2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db6:	89 1c 24             	mov    %ebx,(%esp)
80102db9:	e8 72 e5 ff ff       	call   80101330 <readsb>
  log.start = sb.logstart;
80102dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102dc1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.dev = dev;
80102dc4:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102dca:	89 1c 24             	mov    %ebx,(%esp)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102dcd:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102dd2:	89 15 d8 26 11 80    	mov    %edx,0x801126d8

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ddc:	e8 2f d3 ff ff       	call   80100110 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102de1:	8b 58 5c             	mov    0x5c(%eax),%ebx
// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
80102de4:	8d 70 5c             	lea    0x5c(%eax),%esi
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102de7:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102de9:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102def:	7e 19                	jle    80102e0a <initlog+0x7a>
80102df1:	31 d2                	xor    %edx,%edx
80102df3:	90                   	nop
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102df8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102dfc:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102e03:	83 c2 01             	add    $0x1,%edx
80102e06:	39 da                	cmp    %ebx,%edx
80102e08:	75 ee                	jne    80102df8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102e0a:	89 04 24             	mov    %eax,(%esp)
80102e0d:	e8 2e d2 ff ff       	call   80100040 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e12:	e8 c9 fc ff ff       	call   80102ae0 <install_trans>
  log.lh.n = 0;
80102e17:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e1e:	00 00 00 
  write_head(); // clear the log
80102e21:	e8 5a fd ff ff       	call   80102b80 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102e26:	83 c4 30             	add    $0x30,%esp
80102e29:	5b                   	pop    %ebx
80102e2a:	5e                   	pop    %esi
80102e2b:	5d                   	pop    %ebp
80102e2c:	c3                   	ret    
80102e2d:	66 90                	xchg   %ax,%ax
80102e2f:	90                   	nop

80102e30 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e37:	e8 f4 11 00 00       	call   80104030 <cpuid>
80102e3c:	89 c3                	mov    %eax,%ebx
80102e3e:	e8 ed 11 00 00       	call   80104030 <cpuid>
80102e43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e47:	c7 04 24 54 74 10 80 	movl   $0x80107454,(%esp)
80102e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e52:	e8 f9 d9 ff ff       	call   80100850 <cprintf>
  idtinit();       // load idt register
80102e57:	e8 64 27 00 00       	call   801055c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e5c:	e8 2f 0b 00 00       	call   80103990 <mycpu>
80102e61:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e63:	b8 01 00 00 00       	mov    $0x1,%eax
80102e68:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e6f:	e8 9c 0b 00 00       	call   80103a10 <scheduler>
80102e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e80 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 e4 f0             	and    $0xfffffff0,%esp
80102e86:	53                   	push   %ebx
80102e87:	83 ec 1c             	sub    $0x1c,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e8a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e91:	80 
80102e92:	c7 04 24 c8 57 11 80 	movl   $0x801157c8,(%esp)
80102e99:	e8 22 f6 ff ff       	call   801024c0 <kinit1>
  kvmalloc();      // kernel page table
80102e9e:	e8 fd 3b 00 00       	call   80106aa0 <kvmalloc>
  mpinit();        // detect other processors
80102ea3:	e8 98 01 00 00       	call   80103040 <mpinit>
  lapicinit();     // interrupt controller
80102ea8:	e8 53 f7 ff ff       	call   80102600 <lapicinit>
80102ead:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102eb0:	e8 db 3f 00 00       	call   80106e90 <seginit>
  picinit();       // disable pic
80102eb5:	e8 26 03 00 00       	call   801031e0 <picinit>
  ioapicinit();    // another interrupt controller
80102eba:	e8 e1 f3 ff ff       	call   801022a0 <ioapicinit>
80102ebf:	90                   	nop
  consoleinit();   // console hardware
80102ec0:	e8 ab d3 ff ff       	call   80100270 <consoleinit>
  uartinit();      // serial port
80102ec5:	e8 06 2c 00 00       	call   80105ad0 <uartinit>
  pinit();         // process table
80102eca:	e8 81 11 00 00       	call   80104050 <pinit>
80102ecf:	90                   	nop
  tvinit();        // trap vectors
80102ed0:	e8 cb 2a 00 00       	call   801059a0 <tvinit>
  binit();         // buffer cache
80102ed5:	e8 06 d3 ff ff       	call   801001e0 <binit>
  fileinit();      // file table
80102eda:	e8 51 e2 ff ff       	call   80101130 <fileinit>
80102edf:	90                   	nop
  ideinit();       // disk 
80102ee0:	e8 fb f2 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee5:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102eec:	00 
80102eed:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102ef4:	80 
80102ef5:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102efc:	e8 5f 15 00 00       	call   80104460 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f01:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102f08:	00 00 00 
80102f0b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f10:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80102f15:	76 6c                	jbe    80102f83 <main+0x103>
80102f17:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f20:	e8 6b 0a 00 00       	call   80103990 <mycpu>
80102f25:	39 d8                	cmp    %ebx,%eax
80102f27:	74 41                	je     80102f6a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f29:	e8 22 f4 ff ff       	call   80102350 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f2e:	c7 05 f8 6f 00 80 b0 	movl   $0x80102fb0,0x80006ff8
80102f35:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f38:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f3f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f42:	05 00 10 00 00       	add    $0x1000,%eax
80102f47:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f4c:	0f b6 03             	movzbl (%ebx),%eax
80102f4f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f56:	00 
80102f57:	89 04 24             	mov    %eax,(%esp)
80102f5a:	e8 31 f8 ff ff       	call   80102790 <lapicstartap>
80102f5f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80102f71:	00 00 00 
80102f74:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f7a:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 9d                	jb     80102f20 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f8a:	8e 
80102f8b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f92:	e8 f9 f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102f97:	e8 f4 08 00 00       	call   80103890 <userinit>
  mpmain();        // finish this processor's setup
80102f9c:	e8 8f fe ff ff       	call   80102e30 <mpmain>
80102fa1:	eb 0d                	jmp    80102fb0 <mpenter>
80102fa3:	90                   	nop
80102fa4:	90                   	nop
80102fa5:	90                   	nop
80102fa6:	90                   	nop
80102fa7:	90                   	nop
80102fa8:	90                   	nop
80102fa9:	90                   	nop
80102faa:	90                   	nop
80102fab:	90                   	nop
80102fac:	90                   	nop
80102fad:	90                   	nop
80102fae:	90                   	nop
80102faf:	90                   	nop

80102fb0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fb6:	e8 25 36 00 00       	call   801065e0 <switchkvm>
  seginit();
80102fbb:	e8 d0 3e 00 00       	call   80106e90 <seginit>
  lapicinit();
80102fc0:	e8 3b f6 ff ff       	call   80102600 <lapicinit>
  mpmain();
80102fc5:	e8 66 fe ff ff       	call   80102e30 <mpmain>
80102fca:	66 90                	xchg   %ax,%ax
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	56                   	push   %esi
80102fd4:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fdb:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fde:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe1:	39 f3                	cmp    %esi,%ebx
80102fe3:	73 3c                	jae    80103021 <mpsearch1+0x51>
80102fe5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fef:	00 
80102ff0:	c7 44 24 04 68 74 10 	movl   $0x80107468,0x4(%esp)
80102ff7:	80 
80102ff8:	89 1c 24             	mov    %ebx,(%esp)
80102ffb:	e8 00 14 00 00       	call   80104400 <memcmp>
80103000:	85 c0                	test   %eax,%eax
80103002:	75 16                	jne    8010301a <mpsearch1+0x4a>
80103004:	31 d2                	xor    %edx,%edx
80103006:	66 90                	xchg   %ax,%ax
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103008:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010300c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010300f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103011:	83 f8 10             	cmp    $0x10,%eax
80103014:	75 f2                	jne    80103008 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103016:	84 d2                	test   %dl,%dl
80103018:	74 10                	je     8010302a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010301a:	83 c3 10             	add    $0x10,%ebx
8010301d:	39 de                	cmp    %ebx,%esi
8010301f:	77 c7                	ja     80102fe8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103021:	83 c4 10             	add    $0x10,%esp
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103024:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103026:	5b                   	pop    %ebx
80103027:	5e                   	pop    %esi
80103028:	5d                   	pop    %ebp
80103029:	c3                   	ret    
8010302a:	83 c4 10             	add    $0x10,%esp

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
8010302d:	89 d8                	mov    %ebx,%eax
  return 0;
}
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5d                   	pop    %ebp
80103032:	c3                   	ret    
80103033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103040 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 48 ff ff ff       	call   80102fd0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 c7                	mov    %eax,%edi
8010308c:	0f 84 9b 00 00 00    	je     8010312d <mpinit+0xed>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103092:	8b 77 04             	mov    0x4(%edi),%esi
80103095:	85 f6                	test   %esi,%esi
80103097:	75 0c                	jne    801030a5 <mpinit+0x65>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103099:	c7 04 24 72 74 10 80 	movl   $0x80107472,(%esp)
801030a0:	e8 0b d3 ff ff       	call   801003b0 <panic>
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030a5:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
  if(memcmp(conf, "PCMP", 4) != 0)
801030ab:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030b2:	00 
801030b3:	c7 44 24 04 6d 74 10 	movl   $0x8010746d,0x4(%esp)
801030ba:	80 
801030bb:	89 1c 24             	mov    %ebx,(%esp)
801030be:	e8 3d 13 00 00       	call   80104400 <memcmp>
801030c3:	85 c0                	test   %eax,%eax
801030c5:	75 d2                	jne    80103099 <mpinit+0x59>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030c7:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
801030cb:	3c 04                	cmp    $0x4,%al
801030cd:	74 04                	je     801030d3 <mpinit+0x93>
801030cf:	3c 01                	cmp    $0x1,%al
801030d1:	75 c6                	jne    80103099 <mpinit+0x59>
  *pmp = mp;
  return conf;
}

void
mpinit(void)
801030d3:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030d7:	89 d8                	mov    %ebx,%eax
  *pmp = mp;
  return conf;
}

void
mpinit(void)
801030d9:	8d 8c 16 00 00 00 80 	lea    -0x80000000(%esi,%edx,1),%ecx
801030e0:	31 d2                	xor    %edx,%edx
801030e2:	eb 08                	jmp    801030ec <mpinit+0xac>
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801030e4:	0f b6 30             	movzbl (%eax),%esi
801030e7:	83 c0 01             	add    $0x1,%eax
801030ea:	01 f2                	add    %esi,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030ec:	39 c8                	cmp    %ecx,%eax
801030ee:	75 f4                	jne    801030e4 <mpinit+0xa4>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030f0:	84 d2                	test   %dl,%dl
801030f2:	75 a5                	jne    80103099 <mpinit+0x59>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030f4:	8b 43 24             	mov    0x24(%ebx),%eax
801030f7:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030fc:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
80103100:	8d 43 2c             	lea    0x2c(%ebx),%eax
80103103:	8d 14 13             	lea    (%ebx,%edx,1),%edx
80103106:	bb 01 00 00 00       	mov    $0x1,%ebx
8010310b:	90                   	nop
8010310c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103110:	39 d0                	cmp    %edx,%eax
80103112:	73 4b                	jae    8010315f <mpinit+0x11f>
80103114:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103117:	80 f9 04             	cmp    $0x4,%cl
8010311a:	76 07                	jbe    80103123 <mpinit+0xe3>

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010311c:	31 db                	xor    %ebx,%ebx
    switch(*p){
8010311e:	80 f9 04             	cmp    $0x4,%cl
80103121:	77 f9                	ja     8010311c <mpinit+0xdc>
80103123:	0f b6 c9             	movzbl %cl,%ecx
80103126:	ff 24 8d ac 74 10 80 	jmp    *-0x7fef8b54(,%ecx,4)
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010312d:	ba 00 00 01 00       	mov    $0x10000,%edx
80103132:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103137:	e8 94 fe ff ff       	call   80102fd0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010313c:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010313e:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103140:	0f 85 4c ff ff ff    	jne    80103092 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103146:	c7 04 24 72 74 10 80 	movl   $0x80107472,(%esp)
8010314d:	e8 5e d2 ff ff       	call   801003b0 <panic>
80103152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103158:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315b:	39 d0                	cmp    %edx,%eax
8010315d:	72 b5                	jb     80103114 <mpinit+0xd4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010315f:	85 db                	test   %ebx,%ebx
80103161:	74 6f                	je     801031d2 <mpinit+0x192>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103163:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80103167:	74 12                	je     8010317b <mpinit+0x13b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103169:	ba 22 00 00 00       	mov    $0x22,%edx
8010316e:	b8 70 00 00 00       	mov    $0x70,%eax
80103173:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103174:	b2 23                	mov    $0x23,%dl
80103176:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103177:	83 c8 01             	or     $0x1,%eax
8010317a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010317b:	83 c4 2c             	add    $0x2c,%esp
8010317e:	5b                   	pop    %ebx
8010317f:	5e                   	pop    %esi
80103180:	5f                   	pop    %edi
80103181:	5d                   	pop    %ebp
80103182:	c3                   	ret    
80103183:	90                   	nop
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103188:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103194:	7f 1c                	jg     801031b2 <mpinit+0x172>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103196:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
8010319c:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801031a0:	88 8e a0 27 11 80    	mov    %cl,-0x7feed860(%esi)
        ncpu++;
801031a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801031a9:	83 c1 01             	add    $0x1,%ecx
801031ac:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
      }
      p += sizeof(struct mpproc);
801031b2:	83 c0 14             	add    $0x14,%eax
      continue;
801031b5:	e9 56 ff ff ff       	jmp    80103110 <mpinit+0xd0>
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801031c4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801031cd:	e9 3e ff ff ff       	jmp    80103110 <mpinit+0xd0>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031d2:	c7 04 24 8c 74 10 80 	movl   $0x8010748c,(%esp)
801031d9:	e8 d2 d1 ff ff       	call   801003b0 <panic>
801031de:	66 90                	xchg   %ax,%ax

801031e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	ba 21 00 00 00       	mov    $0x21,%edx
801031e6:	89 e5                	mov    %esp,%ebp
801031e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031ed:	ee                   	out    %al,(%dx)
801031ee:	b2 a1                	mov    $0xa1,%dl
801031f0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031f1:	5d                   	pop    %ebp
801031f2:	c3                   	ret    
801031f3:	66 90                	xchg   %ax,%ax
801031f5:	66 90                	xchg   %ax,%ax
801031f7:	66 90                	xchg   %ax,%ax
801031f9:	66 90                	xchg   %ax,%ax
801031fb:	66 90                	xchg   %ax,%ax
801031fd:	66 90                	xchg   %ax,%ax
801031ff:	90                   	nop

80103200 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
80103205:	53                   	push   %ebx
80103206:	83 ec 1c             	sub    $0x1c,%esp
80103209:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010320c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010320f:	89 1c 24             	mov    %ebx,(%esp)
80103212:	e8 19 11 00 00       	call   80104330 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103217:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010321d:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103223:	75 5b                	jne    80103280 <piperead+0x80>
80103225:	8b 8b 40 02 00 00    	mov    0x240(%ebx),%ecx
8010322b:	85 c9                	test   %ecx,%ecx
8010322d:	74 51                	je     80103280 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010322f:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103235:	eb 25                	jmp    8010325c <piperead+0x5c>
80103237:	90                   	nop
80103238:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010323c:	89 34 24             	mov    %esi,(%esp)
8010323f:	e8 cc 0a 00 00       	call   80103d10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103244:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010324a:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103250:	75 2e                	jne    80103280 <piperead+0x80>
80103252:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103258:	85 c0                	test   %eax,%eax
8010325a:	74 24                	je     80103280 <piperead+0x80>
    if(myproc()->killed){
8010325c:	e8 4f 08 00 00       	call   80103ab0 <myproc>
80103261:	8b 50 24             	mov    0x24(%eax),%edx
80103264:	85 d2                	test   %edx,%edx
80103266:	74 d0                	je     80103238 <piperead+0x38>
      release(&p->lock);
80103268:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010326d:	89 1c 24             	mov    %ebx,(%esp)
80103270:	e8 6b 10 00 00       	call   801042e0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103275:	83 c4 1c             	add    $0x1c,%esp
80103278:	89 f0                	mov    %esi,%eax
8010327a:	5b                   	pop    %ebx
8010327b:	5e                   	pop    %esi
8010327c:	5f                   	pop    %edi
8010327d:	5d                   	pop    %ebp
8010327e:	c3                   	ret    
8010327f:	90                   	nop
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103280:	85 ff                	test   %edi,%edi
80103282:	7e 5e                	jle    801032e2 <piperead+0xe2>
    if(p->nread == p->nwrite)
80103284:	31 f6                	xor    %esi,%esi
80103286:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
8010328c:	75 12                	jne    801032a0 <piperead+0xa0>
8010328e:	66 90                	xchg   %ax,%ax
80103290:	eb 50                	jmp    801032e2 <piperead+0xe2>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103298:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
8010329e:	74 22                	je     801032c2 <piperead+0xc2>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801032a0:	89 d0                	mov    %edx,%eax
801032a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801032a5:	83 c2 01             	add    $0x1,%edx
801032a8:	25 ff 01 00 00       	and    $0x1ff,%eax
801032ad:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801032b2:	88 04 31             	mov    %al,(%ecx,%esi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801032b5:	83 c6 01             	add    $0x1,%esi
801032b8:	39 f7                	cmp    %esi,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801032ba:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801032c0:	7f d6                	jg     80103298 <piperead+0x98>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801032c2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 f0 03 00 00       	call   801036c0 <wakeup>
  release(&p->lock);
801032d0:	89 1c 24             	mov    %ebx,(%esp)
801032d3:	e8 08 10 00 00       	call   801042e0 <release>
  return i;
}
801032d8:	83 c4 1c             	add    $0x1c,%esp
801032db:	89 f0                	mov    %esi,%eax
801032dd:	5b                   	pop    %ebx
801032de:	5e                   	pop    %esi
801032df:	5f                   	pop    %edi
801032e0:	5d                   	pop    %ebp
801032e1:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801032e2:	31 f6                	xor    %esi,%esi
801032e4:	eb dc                	jmp    801032c2 <piperead+0xc2>
801032e6:	8d 76 00             	lea    0x0(%esi),%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801032f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 3c             	sub    $0x3c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80103305:	e8 26 10 00 00       	call   80104330 <acquire>
  for(i = 0; i < n; i++){
8010330a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010330d:	85 c9                	test   %ecx,%ecx
8010330f:	0f 8e 8c 00 00 00    	jle    801033a1 <pipewrite+0xb1>
80103315:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010331b:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
80103321:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103328:	eb 36                	jmp    80103360 <pipewrite+0x70>
8010332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
80103330:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103336:	85 d2                	test   %edx,%edx
80103338:	74 7e                	je     801033b8 <pipewrite+0xc8>
8010333a:	e8 71 07 00 00       	call   80103ab0 <myproc>
8010333f:	8b 40 24             	mov    0x24(%eax),%eax
80103342:	85 c0                	test   %eax,%eax
80103344:	75 72                	jne    801033b8 <pipewrite+0xc8>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103346:	89 34 24             	mov    %esi,(%esp)
80103349:	e8 72 03 00 00       	call   801036c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010334e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103352:	89 3c 24             	mov    %edi,(%esp)
80103355:	e8 b6 09 00 00       	call   80103d10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010335a:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103360:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
80103366:	81 c2 00 02 00 00    	add    $0x200,%edx
8010336c:	39 d0                	cmp    %edx,%eax
8010336e:	74 c0                	je     80103330 <pipewrite+0x40>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103370:	89 c2                	mov    %eax,%edx
80103372:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103375:	83 c0 01             	add    $0x1,%eax
80103378:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010337e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80103381:	8b 55 0c             	mov    0xc(%ebp),%edx
80103384:	0f b6 0c 0a          	movzbl (%edx,%ecx,1),%ecx
80103388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010338b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010338f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103395:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103399:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339c:	39 4d 10             	cmp    %ecx,0x10(%ebp)
8010339f:	7f bf                	jg     80103360 <pipewrite+0x70>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033a1:	89 34 24             	mov    %esi,(%esp)
801033a4:	e8 17 03 00 00       	call   801036c0 <wakeup>
  release(&p->lock);
801033a9:	89 1c 24             	mov    %ebx,(%esp)
801033ac:	e8 2f 0f 00 00       	call   801042e0 <release>
  return n;
801033b1:	eb 14                	jmp    801033c7 <pipewrite+0xd7>
801033b3:	90                   	nop
801033b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
801033b8:	89 1c 24             	mov    %ebx,(%esp)
801033bb:	e8 20 0f 00 00       	call   801042e0 <release>
801033c0:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033c7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ca:	83 c4 3c             	add    $0x3c,%esp
801033cd:	5b                   	pop    %ebx
801033ce:	5e                   	pop    %esi
801033cf:	5f                   	pop    %edi
801033d0:	5d                   	pop    %ebp
801033d1:	c3                   	ret    
801033d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	83 ec 18             	sub    $0x18,%esp
801033e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
801033ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033f2:	89 1c 24             	mov    %ebx,(%esp)
801033f5:	e8 36 0f 00 00       	call   80104330 <acquire>
  if(writable){
801033fa:	85 f6                	test   %esi,%esi
801033fc:	74 42                	je     80103440 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103404:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010340b:	00 00 00 
    wakeup(&p->nread);
8010340e:	89 04 24             	mov    %eax,(%esp)
80103411:	e8 aa 02 00 00       	call   801036c0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103416:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010341c:	85 c0                	test   %eax,%eax
8010341e:	75 0a                	jne    8010342a <pipeclose+0x4a>
80103420:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103426:	85 f6                	test   %esi,%esi
80103428:	74 36                	je     80103460 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010342a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010342d:	8b 75 fc             	mov    -0x4(%ebp),%esi
80103430:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103433:	89 ec                	mov    %ebp,%esp
80103435:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103436:	e9 a5 0e 00 00       	jmp    801042e0 <release>
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103440:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103446:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
8010344d:	00 00 00 
    wakeup(&p->nwrite);
80103450:	89 04 24             	mov    %eax,(%esp)
80103453:	e8 68 02 00 00       	call   801036c0 <wakeup>
80103458:	eb bc                	jmp    80103416 <pipeclose+0x36>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103460:	89 1c 24             	mov    %ebx,(%esp)
80103463:	e8 78 0e 00 00       	call   801042e0 <release>
    kfree((char*)p);
  } else
    release(&p->lock);
}
80103468:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
8010346b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
8010346e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103471:	89 ec                	mov    %ebp,%esp
80103473:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103474:	e9 27 ef ff ff       	jmp    801023a0 <kfree>
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 1c             	sub    $0x1c,%esp
80103489:	8b 75 08             	mov    0x8(%ebp),%esi
8010348c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 30 db ff ff       	call   80100fd0 <filealloc>
801034a0:	85 c0                	test   %eax,%eax
801034a2:	89 06                	mov    %eax,(%esi)
801034a4:	0f 84 9c 00 00 00    	je     80103546 <pipealloc+0xc6>
801034aa:	e8 21 db ff ff       	call   80100fd0 <filealloc>
801034af:	85 c0                	test   %eax,%eax
801034b1:	89 03                	mov    %eax,(%ebx)
801034b3:	0f 84 7f 00 00 00    	je     80103538 <pipealloc+0xb8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 92 ee ff ff       	call   80102350 <kalloc>
801034be:	85 c0                	test   %eax,%eax
801034c0:	89 c7                	mov    %eax,%edi
801034c2:	74 74                	je     80103538 <pipealloc+0xb8>
    goto bad;
  p->readopen = 1;
801034c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cb:	00 00 00 
  p->writeopen = 1;
801034ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034d5:	00 00 00 
  p->nwrite = 0;
801034d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034df:	00 00 00 
  p->nread = 0;
801034e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034e9:	00 00 00 
  initlock(&p->lock, "pipe");
801034ec:	89 04 24             	mov    %eax,(%esp)
801034ef:	c7 44 24 04 c0 74 10 	movl   $0x801074c0,0x4(%esp)
801034f6:	80 
801034f7:	e8 84 0c 00 00       	call   80104180 <initlock>
  (*f0)->type = FD_PIPE;
801034fc:	8b 06                	mov    (%esi),%eax
801034fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103504:	8b 06                	mov    (%esi),%eax
80103506:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350a:	8b 06                	mov    (%esi),%eax
8010350c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103510:	8b 06                	mov    (%esi),%eax
80103512:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103515:	8b 03                	mov    (%ebx),%eax
80103517:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010351d:	8b 03                	mov    (%ebx),%eax
8010351f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103523:	8b 03                	mov    (%ebx),%eax
80103525:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103529:	8b 03                	mov    (%ebx),%eax
8010352b:	89 78 0c             	mov    %edi,0xc(%eax)
8010352e:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103530:	83 c4 1c             	add    $0x1c,%esp
80103533:	5b                   	pop    %ebx
80103534:	5e                   	pop    %esi
80103535:	5f                   	pop    %edi
80103536:	5d                   	pop    %ebp
80103537:	c3                   	ret    

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	74 08                	je     80103546 <pipealloc+0xc6>
    fileclose(*f0);
8010353e:	89 04 24             	mov    %eax,(%esp)
80103541:	e8 0a db ff ff       	call   80101050 <fileclose>
  if(*f1)
80103546:	8b 13                	mov    (%ebx),%edx
80103548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010354d:	85 d2                	test   %edx,%edx
8010354f:	74 df                	je     80103530 <pipealloc+0xb0>
    fileclose(*f1);
80103551:	89 14 24             	mov    %edx,(%esp)
80103554:	e8 f7 da ff ff       	call   80101050 <fileclose>
80103559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010355e:	eb d0                	jmp    80103530 <pipealloc+0xb0>

80103560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
80103566:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
8010356b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010356e:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103571:	eb 4e                	jmp    801035c1 <procdump+0x61>
80103573:	90                   	nop
80103574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103578:	8b 04 85 d0 75 10 80 	mov    -0x7fef8a30(,%eax,4),%eax
8010357f:	85 c0                	test   %eax,%eax
80103581:	74 4a                	je     801035cd <procdump+0x6d>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103583:	89 44 24 08          	mov    %eax,0x8(%esp)
80103587:	8b 43 10             	mov    0x10(%ebx),%eax
8010358a:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010358d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80103591:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
80103598:	89 44 24 04          	mov    %eax,0x4(%esp)
8010359c:	e8 af d2 ff ff       	call   80100850 <cprintf>
    if(p->state == SLEEPING){
801035a1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801035a5:	74 31                	je     801035d8 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801035a7:	c7 04 24 25 79 10 80 	movl   $0x80107925,(%esp)
801035ae:	e8 9d d2 ff ff       	call   80100850 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035b3:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035b9:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801035bf:	74 57                	je     80103618 <procdump+0xb8>
    if(p->state == UNUSED)
801035c1:	8b 43 0c             	mov    0xc(%ebx),%eax
801035c4:	85 c0                	test   %eax,%eax
801035c6:	74 eb                	je     801035b3 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801035c8:	83 f8 05             	cmp    $0x5,%eax
801035cb:	76 ab                	jbe    80103578 <procdump+0x18>
801035cd:	b8 c5 74 10 80       	mov    $0x801074c5,%eax
801035d2:	eb af                	jmp    80103583 <procdump+0x23>
801035d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
801035d8:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035db:	31 f6                	xor    %esi,%esi
801035dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
801035e1:	8b 40 0c             	mov    0xc(%eax),%eax
801035e4:	83 c0 08             	add    $0x8,%eax
801035e7:	89 04 24             	mov    %eax,(%esp)
801035ea:	e8 b1 0b 00 00       	call   801041a0 <getcallerpcs>
801035ef:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
801035f0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
801035f3:	85 c0                	test   %eax,%eax
801035f5:	74 b0                	je     801035a7 <procdump+0x47>
801035f7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
801035fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801035fe:	c7 04 24 c9 6f 10 80 	movl   $0x80106fc9,(%esp)
80103605:	e8 46 d2 ff ff       	call   80100850 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010360a:	83 fe 0a             	cmp    $0xa,%esi
8010360d:	75 e1                	jne    801035f0 <procdump+0x90>
8010360f:	eb 96                	jmp    801035a7 <procdump+0x47>
80103611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103618:	83 c4 4c             	add    $0x4c,%esp
8010361b:	5b                   	pop    %ebx
8010361c:	5e                   	pop    %esi
8010361d:	5f                   	pop    %edi
8010361e:	5d                   	pop    %ebp
8010361f:	90                   	nop
80103620:	c3                   	ret    
80103621:	eb 0d                	jmp    80103630 <kill>
80103623:	90                   	nop
80103624:	90                   	nop
80103625:	90                   	nop
80103626:	90                   	nop
80103627:	90                   	nop
80103628:	90                   	nop
80103629:	90                   	nop
8010362a:	90                   	nop
8010362b:	90                   	nop
8010362c:	90                   	nop
8010362d:	90                   	nop
8010362e:	90                   	nop
8010362f:	90                   	nop

80103630 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
80103634:	83 ec 14             	sub    $0x14,%esp
80103637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010363a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103641:	e8 ea 0c 00 00       	call   80104330 <acquire>

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
80103646:	b8 fc 2d 11 80       	mov    $0x80112dfc,%eax
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
8010364b:	39 1d 84 2d 11 80    	cmp    %ebx,0x80112d84
80103651:	75 11                	jne    80103664 <kill+0x34>
80103653:	eb 62                	jmp    801036b7 <kill+0x87>
80103655:	8d 76 00             	lea    0x0(%esi),%esi
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103658:	05 88 00 00 00       	add    $0x88,%eax
8010365d:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103662:	74 3c                	je     801036a0 <kill+0x70>
    if(p->pid == pid){
80103664:	39 58 10             	cmp    %ebx,0x10(%eax)
80103667:	75 ef                	jne    80103658 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103669:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
8010366d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103674:	74 1a                	je     80103690 <kill+0x60>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103676:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010367d:	e8 5e 0c 00 00       	call   801042e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103682:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
80103685:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103687:	5b                   	pop    %ebx
80103688:	5d                   	pop    %ebp
80103689:	c3                   	ret    
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103690:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103697:	eb dd                	jmp    80103676 <kill+0x46>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801036a0:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801036a7:	e8 34 0c 00 00       	call   801042e0 <release>
  return -1;
}
801036ac:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801036af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
801036b4:	5b                   	pop    %ebx
801036b5:	5d                   	pop    %ebp
801036b6:	c3                   	ret    
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801036b7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801036bc:	eb ab                	jmp    80103669 <kill+0x39>
801036be:	66 90                	xchg   %ax,%ax

801036c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 14             	sub    $0x14,%esp
801036c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801036ca:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801036d1:	e8 5a 0c 00 00       	call   80104330 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
801036d6:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801036db:	eb 0f                	jmp    801036ec <wakeup+0x2c>
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036e0:	05 88 00 00 00       	add    $0x88,%eax
801036e5:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
801036ea:	74 24                	je     80103710 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
801036ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801036f0:	75 ee                	jne    801036e0 <wakeup+0x20>
801036f2:	3b 58 20             	cmp    0x20(%eax),%ebx
801036f5:	75 e9                	jne    801036e0 <wakeup+0x20>
      p->state = RUNNABLE;
801036f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036fe:	05 88 00 00 00       	add    $0x88,%eax
80103703:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103708:	75 e2                	jne    801036ec <wakeup+0x2c>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103710:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80103717:	83 c4 14             	add    $0x14,%esp
8010371a:	5b                   	pop    %ebx
8010371b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010371c:	e9 bf 0b 00 00       	jmp    801042e0 <release>
80103721:	eb 0d                	jmp    80103730 <forkret>
80103723:	90                   	nop
80103724:	90                   	nop
80103725:	90                   	nop
80103726:	90                   	nop
80103727:	90                   	nop
80103728:	90                   	nop
80103729:	90                   	nop
8010372a:	90                   	nop
8010372b:	90                   	nop
8010372c:	90                   	nop
8010372d:	90                   	nop
8010372e:	90                   	nop
8010372f:	90                   	nop

80103730 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103736:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010373d:	e8 9e 0b 00 00       	call   801042e0 <release>

  if (first) {
80103742:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103747:	85 c0                	test   %eax,%eax
80103749:	75 05                	jne    80103750 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010374b:	c9                   	leave  
8010374c:	c3                   	ret    
8010374d:	8d 76 00             	lea    0x0(%esi),%esi

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103750:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
80103757:	00 00 00 
    iinit(ROOTDEV);
8010375a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103761:	e8 9a e7 ff ff       	call   80101f00 <iinit>
    initlog(ROOTDEV);
80103766:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010376d:	e8 1e f6 ff ff       	call   80102d90 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103772:	c9                   	leave  
80103773:	c3                   	ret    
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
80103784:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103787:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010378e:	e8 9d 0b 00 00       	call   80104330 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
80103793:	8b 0d 80 2d 11 80    	mov    0x80112d80,%ecx
80103799:	85 c9                	test   %ecx,%ecx
8010379b:	0f 84 cd 00 00 00    	je     8010386e <allocproc+0xee>
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
801037a1:	bb fc 2d 11 80       	mov    $0x80112dfc,%ebx
801037a6:	eb 12                	jmp    801037ba <allocproc+0x3a>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801037ae:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801037b4:	0f 84 9e 00 00 00    	je     80103858 <allocproc+0xd8>
    if(p->state == UNUSED)
801037ba:	8b 53 0c             	mov    0xc(%ebx),%edx
801037bd:	85 d2                	test   %edx,%edx
801037bf:	75 e7                	jne    801037a8 <allocproc+0x28>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801037c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037c8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037cd:	89 43 10             	mov    %eax,0x10(%ebx)
801037d0:	83 c0 01             	add    $0x1,%eax
801037d3:	a3 00 a0 10 80       	mov    %eax,0x8010a000

  release(&ptable.lock);
801037d8:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801037df:	e8 fc 0a 00 00       	call   801042e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037e4:	e8 67 eb ff ff       	call   80102350 <kalloc>
801037e9:	85 c0                	test   %eax,%eax
801037eb:	89 43 08             	mov    %eax,0x8(%ebx)
801037ee:	0f 84 84 00 00 00    	je     80103878 <allocproc+0xf8>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037f4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801037fa:	89 53 18             	mov    %edx,0x18(%ebx)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037fd:	c7 80 b0 0f 00 00 b4 	movl   $0x801055b4,0xfb0(%eax)
80103804:	55 10 80 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103807:	05 9c 0f 00 00       	add    $0xf9c,%eax
8010380c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010380f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103816:	00 
80103817:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010381e:	00 
8010381f:	89 04 24             	mov    %eax,(%esp)
80103822:	e8 79 0b 00 00       	call   801043a0 <memset>
  p->context->eip = (uint)forkret;
80103827:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010382a:	c7 40 10 30 37 10 80 	movl   $0x80103730,0x10(%eax)

  p->alarmticks = 0;
80103831:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->alarmhandler = 0;
80103838:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010383f:	00 00 00 
  p->ticks = 0;
80103842:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103849:	00 00 00 
  return p;
}
8010384c:	89 d8                	mov    %ebx,%eax
8010384e:	83 c4 14             	add    $0x14,%esp
80103851:	5b                   	pop    %ebx
80103852:	5d                   	pop    %ebp
80103853:	c3                   	ret    
80103854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103858:	31 db                	xor    %ebx,%ebx
8010385a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103861:	e8 7a 0a 00 00       	call   801042e0 <release>

  p->alarmticks = 0;
  p->alarmhandler = 0;
  p->ticks = 0;
  return p;
}
80103866:	89 d8                	mov    %ebx,%eax
80103868:	83 c4 14             	add    $0x14,%esp
8010386b:	5b                   	pop    %ebx
8010386c:	5d                   	pop    %ebp
8010386d:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
8010386e:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103873:	e9 49 ff ff ff       	jmp    801037c1 <allocproc+0x41>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103878:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010387f:	31 db                	xor    %ebx,%ebx
    return 0;
80103881:	eb c9                	jmp    8010384c <allocproc+0xcc>
80103883:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103897:	e8 e4 fe ff ff       	call   80103780 <allocproc>
8010389c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010389e:	a3 c0 a5 10 80       	mov    %eax,0x8010a5c0
  if((p->pgdir = setupkvm()) == 0)
801038a3:	e8 58 31 00 00       	call   80106a00 <setupkvm>
801038a8:	85 c0                	test   %eax,%eax
801038aa:	89 43 04             	mov    %eax,0x4(%ebx)
801038ad:	0f 84 ce 00 00 00    	je     80103981 <userinit+0xf1>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038b3:	89 04 24             	mov    %eax,(%esp)
801038b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801038bd:	00 
801038be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801038c5:	80 
801038c6:	e8 65 2f 00 00       	call   80106830 <inituvm>
  p->sz = PGSIZE;
801038cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801038d8:	00 
801038d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801038e0:	00 
801038e1:	8b 43 18             	mov    0x18(%ebx),%eax
801038e4:	89 04 24             	mov    %eax,(%esp)
801038e7:	e8 b4 0a 00 00       	call   801043a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038ec:	8b 43 18             	mov    0x18(%ebx),%eax
801038ef:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038f5:	8b 43 18             	mov    0x18(%ebx),%eax
801038f8:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038fe:	8b 43 18             	mov    0x18(%ebx),%eax
80103901:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103905:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103909:	8b 43 18             	mov    0x18(%ebx),%eax
8010390c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103910:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103914:	8b 43 18             	mov    0x18(%ebx),%eax
80103917:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010391e:	8b 43 18             	mov    0x18(%ebx),%eax
80103921:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103928:	8b 43 18             	mov    0x18(%ebx),%eax
8010392b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103932:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103935:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010393c:	00 
8010393d:	c7 44 24 04 eb 74 10 	movl   $0x801074eb,0x4(%esp)
80103944:	80 
80103945:	89 04 24             	mov    %eax,(%esp)
80103948:	e8 33 0c 00 00       	call   80104580 <safestrcpy>
  p->cwd = namei("/");
8010394d:	c7 04 24 f4 74 10 80 	movl   $0x801074f4,(%esp)
80103954:	e8 87 e5 ff ff       	call   80101ee0 <namei>
80103959:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010395c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103963:	e8 c8 09 00 00       	call   80104330 <acquire>

  p->state = RUNNABLE;
80103968:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010396f:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103976:	e8 65 09 00 00       	call   801042e0 <release>
}
8010397b:	83 c4 14             	add    $0x14,%esp
8010397e:	5b                   	pop    %ebx
8010397f:	5d                   	pop    %ebp
80103980:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103981:	c7 04 24 d2 74 10 80 	movl   $0x801074d2,(%esp)
80103988:	e8 23 ca ff ff       	call   801003b0 <panic>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103999:	9c                   	pushf  
8010399a:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010399b:	f6 c4 02             	test   $0x2,%ah
8010399e:	75 5e                	jne    801039fe <mycpu+0x6e>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801039a0:	e8 9b ed ff ff       	call   80102740 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039a5:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
801039ab:	85 f6                	test   %esi,%esi
801039ad:	7e 43                	jle    801039f2 <mycpu+0x62>
    if (cpus[i].apicid == apicid)
801039af:	0f b6 3d a0 27 11 80 	movzbl 0x801127a0,%edi
801039b6:	31 d2                	xor    %edx,%edx
801039b8:	b9 50 28 11 80       	mov    $0x80112850,%ecx
801039bd:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801039c2:	39 f8                	cmp    %edi,%eax
801039c4:	74 22                	je     801039e8 <mycpu+0x58>
801039c6:	66 90                	xchg   %ax,%ax
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039c8:	83 c2 01             	add    $0x1,%edx
801039cb:	39 f2                	cmp    %esi,%edx
801039cd:	7d 23                	jge    801039f2 <mycpu+0x62>
    if (cpus[i].apicid == apicid)
801039cf:	0f b6 19             	movzbl (%ecx),%ebx
801039d2:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039d8:	39 d8                	cmp    %ebx,%eax
801039da:	75 ec                	jne    801039c8 <mycpu+0x38>
801039dc:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
801039e2:	8d 9a a0 27 11 80    	lea    -0x7feed860(%edx),%ebx
      return &cpus[i];
  }
  panic("unknown apicid\n");
}
801039e8:	83 c4 1c             	add    $0x1c,%esp
801039eb:	89 d8                	mov    %ebx,%eax
801039ed:	5b                   	pop    %ebx
801039ee:	5e                   	pop    %esi
801039ef:	5f                   	pop    %edi
801039f0:	5d                   	pop    %ebp
801039f1:	c3                   	ret    
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801039f2:	c7 04 24 f6 74 10 80 	movl   $0x801074f6,(%esp)
801039f9:	e8 b2 c9 ff ff       	call   801003b0 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801039fe:	c7 04 24 a8 75 10 80 	movl   $0x801075a8,(%esp)
80103a05:	e8 a6 c9 ff ff       	call   801003b0 <panic>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a19:	e8 72 ff ff ff       	call   80103990 <mycpu>
80103a1e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a20:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a27:	00 00 00 
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a2a:	8d 78 04             	lea    0x4(%eax),%edi
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a30:	fb                   	sti    
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
80103a31:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a36:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103a3d:	e8 ee 08 00 00       	call   80104330 <acquire>
80103a42:	eb 12                	jmp    80103a56 <scheduler+0x46>
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a48:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a4e:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103a54:	74 4a                	je     80103aa0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103a56:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a5a:	75 ec                	jne    80103a48 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a5c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a62:	89 1c 24             	mov    %ebx,(%esp)
80103a65:	e8 26 33 00 00       	call   80106d90 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a6a:	8b 43 1c             	mov    0x1c(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a6d:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a74:	81 c3 88 00 00 00    	add    $0x88,%ebx
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a7a:	89 3c 24             	mov    %edi,(%esp)
80103a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a81:	e8 55 0b 00 00       	call   801045db <swtch>
      switchkvm();
80103a86:	e8 55 2b 00 00       	call   801065e0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a8b:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a91:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a98:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9b:	75 b9                	jne    80103a56 <scheduler+0x46>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103aa0:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103aa7:	e8 34 08 00 00       	call   801042e0 <release>

  }
80103aac:	eb 82                	jmp    80103a30 <scheduler+0x20>
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ab7:	e8 b4 07 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103abc:	e8 cf fe ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 34 07 00 00       	call   80104200 <popcli>
  return p;
}
80103acc:	83 c4 04             	add    $0x4,%esp
80103acf:	89 d8                	mov    %ebx,%eax
80103ad1:	5b                   	pop    %ebx
80103ad2:	5d                   	pop    %ebp
80103ad3:	c3                   	ret    
80103ad4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ada:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ae0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103ae5:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103aea:	53                   	push   %ebx
80103aeb:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103aee:	e8 bd ff ff ff       	call   80103ab0 <myproc>
80103af3:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103af5:	e8 86 fc ff ff       	call   80103780 <allocproc>
80103afa:	85 c0                	test   %eax,%eax
80103afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aff:	0f 84 bf 00 00 00    	je     80103bc4 <fork+0xe4>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b05:	8b 03                	mov    (%ebx),%eax
80103b07:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b0b:	8b 43 04             	mov    0x4(%ebx),%eax
80103b0e:	89 04 24             	mov    %eax,(%esp)
80103b11:	e8 aa 2f 00 00       	call   80106ac0 <copyuvm>
80103b16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b19:	85 c0                	test   %eax,%eax
80103b1b:	89 42 04             	mov    %eax,0x4(%edx)
80103b1e:	0f 84 aa 00 00 00    	je     80103bce <fork+0xee>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103b24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103b27:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103b2c:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103b2e:	89 5a 14             	mov    %ebx,0x14(%edx)
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103b31:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103b33:	8b 42 18             	mov    0x18(%edx),%eax
80103b36:	8b 73 18             	mov    0x18(%ebx),%esi
80103b39:	89 c7                	mov    %eax,%edi
80103b3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103b3d:	31 f6                	xor    %esi,%esi
80103b3f:	8b 42 18             	mov    0x18(%edx),%eax
80103b42:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103b50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b54:	85 c0                	test   %eax,%eax
80103b56:	74 0f                	je     80103b67 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b58:	89 04 24             	mov    %eax,(%esp)
80103b5b:	e8 20 d4 ff ff       	call   80100f80 <filedup>
80103b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b63:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b67:	83 c6 01             	add    $0x1,%esi
80103b6a:	83 fe 10             	cmp    $0x10,%esi
80103b6d:	75 e1                	jne    80103b50 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b6f:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b72:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103b75:	89 04 24             	mov    %eax,(%esp)
80103b78:	e8 03 d6 ff ff       	call   80101180 <idup>
80103b7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b80:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b83:	89 d0                	mov    %edx,%eax
80103b85:	83 c0 6c             	add    $0x6c,%eax
80103b88:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103b8f:	00 
80103b90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103b94:	89 04 24             	mov    %eax,(%esp)
80103b97:	e8 e4 09 00 00       	call   80104580 <safestrcpy>

  pid = np->pid;
80103b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b9f:	8b 70 10             	mov    0x10(%eax),%esi

  acquire(&ptable.lock);
80103ba2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ba9:	e8 82 07 00 00       	call   80104330 <acquire>

  np->state = RUNNABLE;
80103bae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

  release(&ptable.lock);
80103bb8:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103bbf:	e8 1c 07 00 00       	call   801042e0 <release>

  return pid;
}
80103bc4:	83 c4 2c             	add    $0x2c,%esp
80103bc7:	89 f0                	mov    %esi,%eax
80103bc9:	5b                   	pop    %ebx
80103bca:	5e                   	pop    %esi
80103bcb:	5f                   	pop    %edi
80103bcc:	5d                   	pop    %ebp
80103bcd:	c3                   	ret    
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103bce:	8b 42 08             	mov    0x8(%edx),%eax
80103bd1:	89 04 24             	mov    %eax,(%esp)
80103bd4:	e8 c7 e7 ff ff       	call   801023a0 <kfree>
    np->kstack = 0;
80103bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bdc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103be3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103bea:	eb d8                	jmp    80103bc4 <fork+0xe4>
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	83 ec 18             	sub    $0x18,%esp
80103bf6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103bf9:	89 75 fc             	mov    %esi,-0x4(%ebp)
80103bfc:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
80103bff:	e8 ac fe ff ff       	call   80103ab0 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103c04:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103c07:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103c09:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103c0b:	7f 1b                	jg     80103c28 <growproc+0x38>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103c0d:	75 39                	jne    80103c48 <growproc+0x58>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103c0f:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c11:	89 1c 24             	mov    %ebx,(%esp)
80103c14:	e8 77 31 00 00       	call   80106d90 <switchuvm>
80103c19:	31 c0                	xor    %eax,%eax
  return 0;
}
80103c1b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103c1e:	8b 75 fc             	mov    -0x4(%ebp),%esi
80103c21:	89 ec                	mov    %ebp,%esp
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret    
80103c25:	8d 76 00             	lea    0x0(%esi),%esi
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c28:	01 c6                	add    %eax,%esi
80103c2a:	89 74 24 08          	mov    %esi,0x8(%esp)
80103c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c32:	8b 43 04             	mov    0x4(%ebx),%eax
80103c35:	89 04 24             	mov    %eax,(%esp)
80103c38:	e8 63 2f 00 00       	call   80106ba0 <allocuvm>
80103c3d:	85 c0                	test   %eax,%eax
80103c3f:	75 ce                	jne    80103c0f <growproc+0x1f>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
80103c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c46:	eb d3                	jmp    80103c1b <growproc+0x2b>
  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c48:	01 c6                	add    %eax,%esi
80103c4a:	89 74 24 08          	mov    %esi,0x8(%esp)
80103c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c52:	8b 43 04             	mov    0x4(%ebx),%eax
80103c55:	89 04 24             	mov    %eax,(%esp)
80103c58:	e8 73 2c 00 00       	call   801068d0 <deallocuvm>
80103c5d:	85 c0                	test   %eax,%eax
80103c5f:	75 ae                	jne    80103c0f <growproc+0x1f>
80103c61:	eb de                	jmp    80103c41 <growproc+0x51>
80103c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c70 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
80103c75:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103c78:	e8 33 fe ff ff       	call   80103ab0 <myproc>

  if(!holding(&ptable.lock))
80103c7d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103c84:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103c86:	e8 25 06 00 00       	call   801042b0 <holding>
80103c8b:	85 c0                	test   %eax,%eax
80103c8d:	74 4f                	je     80103cde <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103c8f:	e8 fc fc ff ff       	call   80103990 <mycpu>
80103c94:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c9b:	75 65                	jne    80103d02 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103c9d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ca1:	74 53                	je     80103cf6 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ca3:	9c                   	pushf  
80103ca4:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ca5:	f6 c4 02             	test   $0x2,%ah
80103ca8:	75 40                	jne    80103cea <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103caa:	e8 e1 fc ff ff       	call   80103990 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103caf:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103cb2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cb8:	e8 d3 fc ff ff       	call   80103990 <mycpu>
80103cbd:	8b 40 04             	mov    0x4(%eax),%eax
80103cc0:	89 1c 24             	mov    %ebx,(%esp)
80103cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cc7:	e8 0f 09 00 00       	call   801045db <swtch>
  mycpu()->intena = intena;
80103ccc:	e8 bf fc ff ff       	call   80103990 <mycpu>
80103cd1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	5b                   	pop    %ebx
80103cdb:	5e                   	pop    %esi
80103cdc:	5d                   	pop    %ebp
80103cdd:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103cde:	c7 04 24 06 75 10 80 	movl   $0x80107506,(%esp)
80103ce5:	e8 c6 c6 ff ff       	call   801003b0 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103cea:	c7 04 24 32 75 10 80 	movl   $0x80107532,(%esp)
80103cf1:	e8 ba c6 ff ff       	call   801003b0 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103cf6:	c7 04 24 24 75 10 80 	movl   $0x80107524,(%esp)
80103cfd:	e8 ae c6 ff ff       	call   801003b0 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103d02:	c7 04 24 18 75 10 80 	movl   $0x80107518,(%esp)
80103d09:	e8 a2 c6 ff ff       	call   801003b0 <panic>
80103d0e:	66 90                	xchg   %ax,%ax

80103d10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	83 ec 28             	sub    $0x28,%esp
80103d16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103d19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103d1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80103d1f:	8b 75 08             	mov    0x8(%ebp),%esi
80103d22:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct proc *p = myproc();
80103d25:	e8 86 fd ff ff       	call   80103ab0 <myproc>
  
  if(p == 0)
80103d2a:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103d2c:	89 c7                	mov    %eax,%edi
  
  if(p == 0)
80103d2e:	0f 84 8b 00 00 00    	je     80103dbf <sleep+0xaf>
    panic("sleep");

  if(lk == 0)
80103d34:	85 db                	test   %ebx,%ebx
80103d36:	74 7b                	je     80103db3 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d38:	81 fb 40 2d 11 80    	cmp    $0x80112d40,%ebx
80103d3e:	74 50                	je     80103d90 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d40:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103d47:	e8 e4 05 00 00       	call   80104330 <acquire>
    release(lk);
80103d4c:	89 1c 24             	mov    %ebx,(%esp)
80103d4f:	e8 8c 05 00 00       	call   801042e0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d54:	89 77 20             	mov    %esi,0x20(%edi)
  p->state = SLEEPING;
80103d57:	c7 47 0c 02 00 00 00 	movl   $0x2,0xc(%edi)

  sched();
80103d5e:	e8 0d ff ff ff       	call   80103c70 <sched>

  // Tidy up.
  p->chan = 0;
80103d63:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d6a:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103d71:	e8 6a 05 00 00       	call   801042e0 <release>
    acquire(lk);
  }
}
80103d76:	8b 75 f8             	mov    -0x8(%ebp),%esi
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d79:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103d7c:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103d7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103d82:	89 ec                	mov    %ebp,%esp
80103d84:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d85:	e9 a6 05 00 00       	jmp    80104330 <acquire>
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d90:	89 70 20             	mov    %esi,0x20(%eax)
  p->state = SLEEPING;
80103d93:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d9a:	e8 d1 fe ff ff       	call   80103c70 <sched>

  // Tidy up.
  p->chan = 0;
80103d9f:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103da6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103da9:	8b 75 f8             	mov    -0x8(%ebp),%esi
80103dac:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103daf:	89 ec                	mov    %ebp,%esp
80103db1:	5d                   	pop    %ebp
80103db2:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103db3:	c7 04 24 4c 75 10 80 	movl   $0x8010754c,(%esp)
80103dba:	e8 f1 c5 ff ff       	call   801003b0 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103dbf:	c7 04 24 46 75 10 80 	movl   $0x80107546,(%esp)
80103dc6:	e8 e5 c5 ff ff       	call   801003b0 <panic>
80103dcb:	90                   	nop
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103dd5:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dda:	83 ec 20             	sub    $0x20,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103ddd:	e8 ce fc ff ff       	call   80103ab0 <myproc>
  
  acquire(&ptable.lock);
80103de2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103de9:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103deb:	e8 40 05 00 00       	call   80104330 <acquire>
80103df0:	31 c0                	xor    %eax,%eax
80103df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df8:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103dfe:	72 2a                	jb     80103e2a <wait+0x5a>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 4c                	je     80103e50 <wait+0x80>
80103e04:	8b 5e 24             	mov    0x24(%esi),%ebx
80103e07:	85 db                	test   %ebx,%ebx
80103e09:	75 45                	jne    80103e50 <wait+0x80>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e0b:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103e10:	c7 44 24 04 40 2d 11 	movl   $0x80112d40,0x4(%esp)
80103e17:	80 
80103e18:	89 34 24             	mov    %esi,(%esp)
80103e1b:	e8 f0 fe ff ff       	call   80103d10 <sleep>
80103e20:	31 c0                	xor    %eax,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e22:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103e28:	73 d6                	jae    80103e00 <wait+0x30>
      if(p->parent != curproc)
80103e2a:	3b 73 14             	cmp    0x14(%ebx),%esi
80103e2d:	74 09                	je     80103e38 <wait+0x68>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e2f:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e35:	eb c1                	jmp    80103df8 <wait+0x28>
80103e37:	90                   	nop
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e38:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	74 26                	je     80103e68 <wait+0x98>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e42:	b8 01 00 00 00       	mov    $0x1,%eax
80103e47:	eb e6                	jmp    80103e2f <wait+0x5f>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e50:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e57:	e8 84 04 00 00       	call   801042e0 <release>
80103e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e61:	83 c4 20             	add    $0x20,%esp
80103e64:	5b                   	pop    %ebx
80103e65:	5e                   	pop    %esi
80103e66:	5d                   	pop    %ebp
80103e67:	c3                   	ret    
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e68:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
80103e6b:	8b 53 08             	mov    0x8(%ebx),%edx
80103e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e71:	89 14 24             	mov    %edx,(%esp)
80103e74:	e8 27 e5 ff ff       	call   801023a0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e79:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e7c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e83:	89 14 24             	mov    %edx,(%esp)
80103e86:	e8 f5 2a 00 00       	call   80106980 <freevm>
        p->pid = 0;
80103e8b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e92:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e99:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e9d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ea4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103eab:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103eb2:	e8 29 04 00 00       	call   801042e0 <release>
        return pid;
80103eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eba:	eb a5                	jmp    80103e61 <wait+0x91>
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ec6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ecd:	e8 5e 04 00 00       	call   80104330 <acquire>
  myproc()->state = RUNNABLE;
80103ed2:	e8 d9 fb ff ff       	call   80103ab0 <myproc>
80103ed7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103ede:	e8 8d fd ff ff       	call   80103c70 <sched>
  release(&ptable.lock);
80103ee3:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103eea:	e8 f1 03 00 00       	call   801042e0 <release>
}
80103eef:	c9                   	leave  
80103ef0:	c3                   	ret    
80103ef1:	eb 0d                	jmp    80103f00 <exit>
80103ef3:	90                   	nop
80103ef4:	90                   	nop
80103ef5:	90                   	nop
80103ef6:	90                   	nop
80103ef7:	90                   	nop
80103ef8:	90                   	nop
80103ef9:	90                   	nop
80103efa:	90                   	nop
80103efb:	90                   	nop
80103efc:	90                   	nop
80103efd:	90                   	nop
80103efe:	90                   	nop
80103eff:	90                   	nop

80103f00 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103f04:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f06:	53                   	push   %ebx
80103f07:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103f0a:	e8 a1 fb ff ff       	call   80103ab0 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f0f:	3b 05 c0 a5 10 80    	cmp    0x8010a5c0,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103f15:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f17:	0f 84 fd 00 00 00    	je     8010401a <exit+0x11a>
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103f20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 10                	je     80103f38 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103f28:	89 04 24             	mov    %eax,(%esp)
80103f2b:	e8 20 d1 ff ff       	call   80101050 <fileclose>
      curproc->ofile[fd] = 0;
80103f30:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103f37:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103f38:	83 c6 01             	add    $0x1,%esi
80103f3b:	83 fe 10             	cmp    $0x10,%esi
80103f3e:	75 e0                	jne    80103f20 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103f40:	e8 db ed ff ff       	call   80102d20 <begin_op>
  iput(curproc->cwd);
80103f45:	8b 43 68             	mov    0x68(%ebx),%eax
80103f48:	89 04 24             	mov    %eax,(%esp)
80103f4b:	e8 40 db ff ff       	call   80101a90 <iput>
  end_op();
80103f50:	e8 9b ec ff ff       	call   80102bf0 <end_op>
  curproc->cwd = 0;
80103f55:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103f5c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103f63:	e8 c8 03 00 00       	call   80104330 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f68:	8b 43 14             	mov    0x14(%ebx),%eax

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
80103f6b:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103f70:	eb 14                	jmp    80103f86 <exit+0x86>
80103f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f78:	81 c2 88 00 00 00    	add    $0x88,%edx
80103f7e:	81 fa 74 4f 11 80    	cmp    $0x80114f74,%edx
80103f84:	74 20                	je     80103fa6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f86:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103f8a:	75 ec                	jne    80103f78 <exit+0x78>
80103f8c:	3b 42 20             	cmp    0x20(%edx),%eax
80103f8f:	75 e7                	jne    80103f78 <exit+0x78>
      p->state = RUNNABLE;
80103f91:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f98:	81 c2 88 00 00 00    	add    $0x88,%edx
80103f9e:	81 fa 74 4f 11 80    	cmp    $0x80114f74,%edx
80103fa4:	75 e0                	jne    80103f86 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103fa6:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80103fab:	b9 74 2d 11 80       	mov    $0x80112d74,%ecx
80103fb0:	eb 14                	jmp    80103fc6 <exit+0xc6>
80103fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb8:	81 c1 88 00 00 00    	add    $0x88,%ecx
80103fbe:	81 f9 74 4f 11 80    	cmp    $0x80114f74,%ecx
80103fc4:	74 3c                	je     80104002 <exit+0x102>
    if(p->parent == curproc){
80103fc6:	3b 59 14             	cmp    0x14(%ecx),%ebx
80103fc9:	75 ed                	jne    80103fb8 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103fcb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103fcf:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103fd2:	75 e4                	jne    80103fb8 <exit+0xb8>
80103fd4:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103fd9:	eb 13                	jmp    80103fee <exit+0xee>
80103fdb:	90                   	nop
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103fe6:	81 fa 74 4f 11 80    	cmp    $0x80114f74,%edx
80103fec:	74 ca                	je     80103fb8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fee:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103ff2:	75 ec                	jne    80103fe0 <exit+0xe0>
80103ff4:	3b 42 20             	cmp    0x20(%edx),%eax
80103ff7:	75 e7                	jne    80103fe0 <exit+0xe0>
      p->state = RUNNABLE;
80103ff9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80104000:	eb de                	jmp    80103fe0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104002:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104009:	e8 62 fc ff ff       	call   80103c70 <sched>
  panic("zombie exit");
8010400e:	c7 04 24 6a 75 10 80 	movl   $0x8010756a,(%esp)
80104015:	e8 96 c3 ff ff       	call   801003b0 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
8010401a:	c7 04 24 5d 75 10 80 	movl   $0x8010755d,(%esp)
80104021:	e8 8a c3 ff ff       	call   801003b0 <panic>
80104026:	8d 76 00             	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104036:	e8 55 f9 ff ff       	call   80103990 <mycpu>
}
8010403b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010403c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80104041:	c1 f8 04             	sar    $0x4,%eax
80104044:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010404a:	c3                   	ret    
8010404b:	90                   	nop
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104050 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104056:	c7 44 24 04 76 75 10 	movl   $0x80107576,0x4(%esp)
8010405d:	80 
8010405e:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104065:	e8 16 01 00 00       	call   80104180 <initlock>
}
8010406a:	c9                   	leave  
8010406b:	c3                   	ret    
8010406c:	66 90                	xchg   %ax,%ax
8010406e:	66 90                	xchg   %ax,%ax

80104070 <holdingsleep>:
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	83 ec 18             	sub    $0x18,%esp
80104076:	89 75 fc             	mov    %esi,-0x4(%ebp)
80104079:	8b 75 08             	mov    0x8(%ebp),%esi
8010407c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int r;
  
  acquire(&lk->lk);
8010407f:	8d 5e 04             	lea    0x4(%esi),%ebx
80104082:	89 1c 24             	mov    %ebx,(%esp)
80104085:	e8 a6 02 00 00       	call   80104330 <acquire>
  r = lk->locked;
8010408a:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
8010408c:	89 1c 24             	mov    %ebx,(%esp)
8010408f:	e8 4c 02 00 00       	call   801042e0 <release>
  return r;
}
80104094:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104097:	89 f0                	mov    %esi,%eax
80104099:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010409c:	89 ec                	mov    %ebp,%esp
8010409e:	5d                   	pop    %ebp
8010409f:	c3                   	ret    

801040a0 <releasesleep>:
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 18             	sub    $0x18,%esp
801040a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801040a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
801040af:	8d 73 04             	lea    0x4(%ebx),%esi
801040b2:	89 34 24             	mov    %esi,(%esp)
801040b5:	e8 76 02 00 00       	call   80104330 <acquire>
  lk->locked = 0;
801040ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040c0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801040c7:	89 1c 24             	mov    %ebx,(%esp)
801040ca:	e8 f1 f5 ff ff       	call   801036c0 <wakeup>
  release(&lk->lk);
}
801040cf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801040d2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040d5:	8b 75 fc             	mov    -0x4(%ebp),%esi
801040d8:	89 ec                	mov    %ebp,%esp
801040da:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801040db:	e9 00 02 00 00       	jmp    801042e0 <release>

801040e0 <acquiresleep>:
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
801040e5:	83 ec 10             	sub    $0x10,%esp
801040e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040eb:	8d 73 04             	lea    0x4(%ebx),%esi
801040ee:	89 34 24             	mov    %esi,(%esp)
801040f1:	e8 3a 02 00 00       	call   80104330 <acquire>
  while (lk->locked) {
801040f6:	8b 13                	mov    (%ebx),%edx
801040f8:	85 d2                	test   %edx,%edx
801040fa:	74 16                	je     80104112 <acquiresleep+0x32>
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104100:	89 74 24 04          	mov    %esi,0x4(%esp)
80104104:	89 1c 24             	mov    %ebx,(%esp)
80104107:	e8 04 fc ff ff       	call   80103d10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010410c:	8b 03                	mov    (%ebx),%eax
8010410e:	85 c0                	test   %eax,%eax
80104110:	75 ee                	jne    80104100 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104112:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104118:	e8 93 f9 ff ff       	call   80103ab0 <myproc>
8010411d:	8b 40 10             	mov    0x10(%eax),%eax
80104120:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104123:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104126:	83 c4 10             	add    $0x10,%esp
80104129:	5b                   	pop    %ebx
8010412a:	5e                   	pop    %esi
8010412b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010412c:	e9 af 01 00 00       	jmp    801042e0 <release>
80104131:	eb 0d                	jmp    80104140 <initsleeplock>
80104133:	90                   	nop
80104134:	90                   	nop
80104135:	90                   	nop
80104136:	90                   	nop
80104137:	90                   	nop
80104138:	90                   	nop
80104139:	90                   	nop
8010413a:	90                   	nop
8010413b:	90                   	nop
8010413c:	90                   	nop
8010413d:	90                   	nop
8010413e:	90                   	nop
8010413f:	90                   	nop

80104140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 14             	sub    $0x14,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010414a:	c7 44 24 04 e8 75 10 	movl   $0x801075e8,0x4(%esp)
80104151:	80 
80104152:	8d 43 04             	lea    0x4(%ebx),%eax
80104155:	89 04 24             	mov    %eax,(%esp)
80104158:	e8 23 00 00 00       	call   80104180 <initlock>
  lk->name = name;
8010415d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104160:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104166:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010416d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104170:	83 c4 14             	add    $0x14,%esp
80104173:	5b                   	pop    %ebx
80104174:	5d                   	pop    %ebp
80104175:	c3                   	ret    
80104176:	66 90                	xchg   %ax,%ax
80104178:	66 90                	xchg   %ax,%ax
8010417a:	66 90                	xchg   %ax,%ax
8010417c:	66 90                	xchg   %ax,%ax
8010417e:	66 90                	xchg   %ax,%ax

80104180 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104186:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010418f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104192:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104199:	5d                   	pop    %ebp
8010419a:	c3                   	ret    
8010419b:	90                   	nop
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041a1:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a3:	89 e5                	mov    %esp,%ebp
801041a5:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041a6:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041ac:	83 ea 08             	sub    $0x8,%edx
801041af:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041b0:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
801041b6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801041bc:	77 1a                	ja     801041d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041be:	8b 4a 04             	mov    0x4(%edx),%ecx
801041c1:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041c4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041c7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041c9:	83 f8 0a             	cmp    $0xa,%eax
801041cc:	75 e2                	jne    801041b0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ce:	5b                   	pop    %ebx
801041cf:	5d                   	pop    %ebp
801041d0:	c3                   	ret    
801041d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041d8:	83 f8 09             	cmp    $0x9,%eax
801041db:	7f f1                	jg     801041ce <getcallerpcs+0x2e>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041dd:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
801041e0:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
801041e3:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041e9:	83 c2 04             	add    $0x4,%edx
801041ec:	83 f8 0a             	cmp    $0xa,%eax
801041ef:	75 ef                	jne    801041e0 <getcallerpcs+0x40>
    pcs[i] = 0;
}
801041f1:	5b                   	pop    %ebx
801041f2:	5d                   	pop    %ebp
801041f3:	c3                   	ret    
801041f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104200 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	83 ec 18             	sub    $0x18,%esp
80104206:	9c                   	pushf  
80104207:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104208:	f6 c4 02             	test   $0x2,%ah
8010420b:	75 49                	jne    80104256 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010420d:	e8 7e f7 ff ff       	call   80103990 <mycpu>
80104212:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104218:	83 ea 01             	sub    $0x1,%edx
8010421b:	85 d2                	test   %edx,%edx
8010421d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104223:	78 25                	js     8010424a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104225:	e8 66 f7 ff ff       	call   80103990 <mycpu>
8010422a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104230:	85 d2                	test   %edx,%edx
80104232:	74 04                	je     80104238 <popcli+0x38>
    sti();
}
80104234:	c9                   	leave  
80104235:	c3                   	ret    
80104236:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104238:	e8 53 f7 ff ff       	call   80103990 <mycpu>
8010423d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104243:	85 c0                	test   %eax,%eax
80104245:	74 ed                	je     80104234 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104247:	fb                   	sti    
    sti();
}
80104248:	c9                   	leave  
80104249:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010424a:	c7 04 24 0a 76 10 80 	movl   $0x8010760a,(%esp)
80104251:	e8 5a c1 ff ff       	call   801003b0 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104256:	c7 04 24 f3 75 10 80 	movl   $0x801075f3,(%esp)
8010425d:	e8 4e c1 ff ff       	call   801003b0 <panic>
80104262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104277:	9c                   	pushf  
80104278:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104279:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010427a:	e8 11 f7 ff ff       	call   80103990 <mycpu>
8010427f:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104285:	85 c9                	test   %ecx,%ecx
80104287:	75 11                	jne    8010429a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104289:	e8 02 f7 ff ff       	call   80103990 <mycpu>
8010428e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104294:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010429a:	e8 f1 f6 ff ff       	call   80103990 <mycpu>
8010429f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042a6:	83 c4 04             	add    $0x4,%esp
801042a9:	5b                   	pop    %ebx
801042aa:	5d                   	pop    %ebp
801042ab:	c3                   	ret    
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042b0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801042b1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042b3:	89 e5                	mov    %esp,%ebp
801042b5:	53                   	push   %ebx
801042b6:	83 ec 04             	sub    $0x4,%esp
801042b9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042bc:	8b 1a                	mov    (%edx),%ebx
801042be:	85 db                	test   %ebx,%ebx
801042c0:	75 06                	jne    801042c8 <holding+0x18>
}
801042c2:	83 c4 04             	add    $0x4,%esp
801042c5:	5b                   	pop    %ebx
801042c6:	5d                   	pop    %ebp
801042c7:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042c8:	8b 5a 08             	mov    0x8(%edx),%ebx
801042cb:	e8 c0 f6 ff ff       	call   80103990 <mycpu>
801042d0:	39 c3                	cmp    %eax,%ebx
801042d2:	0f 94 c0             	sete   %al
}
801042d5:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042d8:	0f b6 c0             	movzbl %al,%eax
}
801042db:	5b                   	pop    %ebx
801042dc:	5d                   	pop    %ebp
801042dd:	c3                   	ret    
801042de:	66 90                	xchg   %ax,%ax

801042e0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 14             	sub    $0x14,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801042ea:	89 1c 24             	mov    %ebx,(%esp)
801042ed:	e8 be ff ff ff       	call   801042b0 <holding>
801042f2:	85 c0                	test   %eax,%eax
801042f4:	74 23                	je     80104319 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
801042f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042fd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104304:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104309:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
8010430f:	83 c4 14             	add    $0x14,%esp
80104312:	5b                   	pop    %ebx
80104313:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104314:	e9 e7 fe ff ff       	jmp    80104200 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104319:	c7 04 24 11 76 10 80 	movl   $0x80107611,(%esp)
80104320:	e8 8b c0 ff ff       	call   801003b0 <panic>
80104325:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104337:	e8 34 ff ff ff       	call   80104270 <pushcli>

  if(holding(lk))
8010433c:	8b 45 08             	mov    0x8(%ebp),%eax
8010433f:	89 04 24             	mov    %eax,(%esp)
80104342:	e8 69 ff ff ff       	call   801042b0 <holding>
80104347:	85 c0                	test   %eax,%eax
80104349:	75 3c                	jne    80104387 <acquire+0x57>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010434b:	b9 01 00 00 00       	mov    $0x1,%ecx
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104350:	8b 55 08             	mov    0x8(%ebp),%edx
80104353:	89 c8                	mov    %ecx,%eax
80104355:	f0 87 02             	lock xchg %eax,(%edx)
80104358:	85 c0                	test   %eax,%eax
8010435a:	75 f4                	jne    80104350 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010435c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104361:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104364:	e8 27 f6 ff ff       	call   80103990 <mycpu>
80104369:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010436c:	8b 45 08             	mov    0x8(%ebp),%eax
8010436f:	83 c0 0c             	add    $0xc,%eax
80104372:	89 44 24 04          	mov    %eax,0x4(%esp)
80104376:	8d 45 08             	lea    0x8(%ebp),%eax
80104379:	89 04 24             	mov    %eax,(%esp)
8010437c:	e8 1f fe ff ff       	call   801041a0 <getcallerpcs>
}
80104381:	83 c4 14             	add    $0x14,%esp
80104384:	5b                   	pop    %ebx
80104385:	5d                   	pop    %ebp
80104386:	c3                   	ret    
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.

  if(holding(lk))
    panic("acquire");
80104387:	c7 04 24 19 76 10 80 	movl   $0x80107619,(%esp)
8010438e:	e8 1d c0 ff ff       	call   801003b0 <panic>
80104393:	66 90                	xchg   %ax,%ax
80104395:	66 90                	xchg   %ax,%ax
80104397:	66 90                	xchg   %ax,%ax
80104399:	66 90                	xchg   %ax,%ax
8010439b:	66 90                	xchg   %ax,%ax
8010439d:	66 90                	xchg   %ax,%ax
8010439f:	90                   	nop

801043a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 08             	sub    $0x8,%esp
801043a6:	8b 55 08             	mov    0x8(%ebp),%edx
801043a9:	89 1c 24             	mov    %ebx,(%esp)
801043ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801043af:	89 7c 24 04          	mov    %edi,0x4(%esp)
801043b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801043b6:	f6 c2 03             	test   $0x3,%dl
801043b9:	75 05                	jne    801043c0 <memset+0x20>
801043bb:	f6 c1 03             	test   $0x3,%cl
801043be:	74 18                	je     801043d8 <memset+0x38>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043c0:	89 d7                	mov    %edx,%edi
801043c2:	fc                   	cld    
801043c3:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043c5:	89 d0                	mov    %edx,%eax
801043c7:	8b 1c 24             	mov    (%esp),%ebx
801043ca:	8b 7c 24 04          	mov    0x4(%esp),%edi
801043ce:	89 ec                	mov    %ebp,%esp
801043d0:	5d                   	pop    %ebp
801043d1:	c3                   	ret    
801043d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043d8:	0f b6 f8             	movzbl %al,%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043db:	89 f8                	mov    %edi,%eax
801043dd:	89 fb                	mov    %edi,%ebx
801043df:	c1 e0 18             	shl    $0x18,%eax
801043e2:	c1 e3 10             	shl    $0x10,%ebx
801043e5:	09 d8                	or     %ebx,%eax
801043e7:	09 f8                	or     %edi,%eax
801043e9:	c1 e7 08             	shl    $0x8,%edi
801043ec:	09 f8                	or     %edi,%eax
801043ee:	89 d7                	mov    %edx,%edi
801043f0:	c1 e9 02             	shr    $0x2,%ecx
801043f3:	fc                   	cld    
801043f4:	f3 ab                	rep stos %eax,%es:(%edi)
801043f6:	eb cd                	jmp    801043c5 <memset+0x25>
801043f8:	90                   	nop
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <memcmp>:
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	53                   	push   %ebx
80104406:	8b 55 10             	mov    0x10(%ebp),%edx
80104409:	8b 75 08             	mov    0x8(%ebp),%esi
8010440c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010440f:	85 d2                	test   %edx,%edx
80104411:	74 2d                	je     80104440 <memcmp+0x40>
    if(*s1 != *s2)
80104413:	0f b6 1e             	movzbl (%esi),%ebx
80104416:	0f b6 0f             	movzbl (%edi),%ecx
80104419:	38 cb                	cmp    %cl,%bl
8010441b:	75 2b                	jne    80104448 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010441d:	83 ea 01             	sub    $0x1,%edx
80104420:	31 c0                	xor    %eax,%eax
80104422:	eb 18                	jmp    8010443c <memcmp+0x3c>
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s1 != *s2)
80104428:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
8010442d:	83 ea 01             	sub    $0x1,%edx
80104430:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
80104435:	83 c0 01             	add    $0x1,%eax
80104438:	38 cb                	cmp    %cl,%bl
8010443a:	75 0c                	jne    80104448 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010443c:	85 d2                	test   %edx,%edx
8010443e:	75 e8                	jne    80104428 <memcmp+0x28>
80104440:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104442:	5b                   	pop    %ebx
80104443:	5e                   	pop    %esi
80104444:	5f                   	pop    %edi
80104445:	5d                   	pop    %ebp
80104446:	c3                   	ret    
80104447:	90                   	nop

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104448:	0f b6 c3             	movzbl %bl,%eax
8010444b:	0f b6 c9             	movzbl %cl,%ecx
8010444e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104450:	5b                   	pop    %ebx
80104451:	5e                   	pop    %esi
80104452:	5f                   	pop    %edi
80104453:	5d                   	pop    %ebp
80104454:	c3                   	ret    
80104455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	8b 45 08             	mov    0x8(%ebp),%eax
80104469:	8b 75 0c             	mov    0xc(%ebp),%esi
8010446c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010446f:	39 c6                	cmp    %eax,%esi
80104471:	73 2d                	jae    801044a0 <memmove+0x40>
80104473:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
80104476:	39 f8                	cmp    %edi,%eax
80104478:	73 26                	jae    801044a0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
8010447a:	85 db                	test   %ebx,%ebx
8010447c:	74 1d                	je     8010449b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010447e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80104481:	31 d2                	xor    %edx,%edx
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
80104488:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
8010448d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
80104491:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104494:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80104497:	85 c9                	test   %ecx,%ecx
80104499:	75 ed                	jne    80104488 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010449b:	5b                   	pop    %ebx
8010449c:	5e                   	pop    %esi
8010449d:	5f                   	pop    %edi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044a0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
801044a2:	85 db                	test   %ebx,%ebx
801044a4:	74 f5                	je     8010449b <memmove+0x3b>
801044a6:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801044a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044af:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044b2:	39 d3                	cmp    %edx,%ebx
801044b4:	75 f2                	jne    801044a8 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
801044b6:	5b                   	pop    %ebx
801044b7:	5e                   	pop    %esi
801044b8:	5f                   	pop    %edi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	90                   	nop
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044c3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044c4:	e9 97 ff ff ff       	jmp    80104460 <memmove>
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	56                   	push   %esi
801044d5:	53                   	push   %ebx
801044d6:	8b 7d 10             	mov    0x10(%ebp),%edi
801044d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044df:	85 ff                	test   %edi,%edi
801044e1:	74 3d                	je     80104520 <strncmp+0x50>
801044e3:	0f b6 01             	movzbl (%ecx),%eax
801044e6:	84 c0                	test   %al,%al
801044e8:	75 18                	jne    80104502 <strncmp+0x32>
801044ea:	eb 3c                	jmp    80104528 <strncmp+0x58>
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f0:	83 ef 01             	sub    $0x1,%edi
801044f3:	74 2b                	je     80104520 <strncmp+0x50>
    n--, p++, q++;
801044f5:	83 c1 01             	add    $0x1,%ecx
801044f8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044fb:	0f b6 01             	movzbl (%ecx),%eax
801044fe:	84 c0                	test   %al,%al
80104500:	74 26                	je     80104528 <strncmp+0x58>
80104502:	0f b6 33             	movzbl (%ebx),%esi
80104505:	89 f2                	mov    %esi,%edx
80104507:	38 d0                	cmp    %dl,%al
80104509:	74 e5                	je     801044f0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010450b:	81 e6 ff 00 00 00    	and    $0xff,%esi
80104511:	0f b6 c0             	movzbl %al,%eax
80104514:	29 f0                	sub    %esi,%eax
}
80104516:	5b                   	pop    %ebx
80104517:	5e                   	pop    %esi
80104518:	5f                   	pop    %edi
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104520:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104522:	5b                   	pop    %ebx
80104523:	5e                   	pop    %esi
80104524:	5f                   	pop    %edi
80104525:	5d                   	pop    %ebp
80104526:	c3                   	ret    
80104527:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104528:	0f b6 33             	movzbl (%ebx),%esi
8010452b:	eb de                	jmp    8010450b <strncmp+0x3b>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi

80104530 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
80104536:	56                   	push   %esi
80104537:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010453a:	53                   	push   %ebx
8010453b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010453e:	89 c3                	mov    %eax,%ebx
80104540:	eb 09                	jmp    8010454b <strncpy+0x1b>
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104548:	83 c6 01             	add    $0x1,%esi
8010454b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
8010454e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104551:	85 d2                	test   %edx,%edx
80104553:	7e 0c                	jle    80104561 <strncpy+0x31>
80104555:	0f b6 16             	movzbl (%esi),%edx
80104558:	88 13                	mov    %dl,(%ebx)
8010455a:	83 c3 01             	add    $0x1,%ebx
8010455d:	84 d2                	test   %dl,%dl
8010455f:	75 e7                	jne    80104548 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
80104561:	31 d2                	xor    %edx,%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104563:	85 c9                	test   %ecx,%ecx
80104565:	7e 0c                	jle    80104573 <strncpy+0x43>
80104567:	90                   	nop
    *s++ = 0;
80104568:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
8010456c:	83 c2 01             	add    $0x1,%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010456f:	39 ca                	cmp    %ecx,%edx
80104571:	75 f5                	jne    80104568 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104573:	5b                   	pop    %ebx
80104574:	5e                   	pop    %esi
80104575:	5d                   	pop    %ebp
80104576:	c3                   	ret    
80104577:	89 f6                	mov    %esi,%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 55 10             	mov    0x10(%ebp),%edx
80104586:	56                   	push   %esi
80104587:	8b 45 08             	mov    0x8(%ebp),%eax
8010458a:	53                   	push   %ebx
8010458b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;

  os = s;
  if(n <= 0)
8010458e:	85 d2                	test   %edx,%edx
80104590:	7e 1f                	jle    801045b1 <safestrcpy+0x31>
80104592:	89 c1                	mov    %eax,%ecx
80104594:	eb 05                	jmp    8010459b <safestrcpy+0x1b>
80104596:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104598:	83 c6 01             	add    $0x1,%esi
8010459b:	83 ea 01             	sub    $0x1,%edx
8010459e:	85 d2                	test   %edx,%edx
801045a0:	7e 0c                	jle    801045ae <safestrcpy+0x2e>
801045a2:	0f b6 1e             	movzbl (%esi),%ebx
801045a5:	88 19                	mov    %bl,(%ecx)
801045a7:	83 c1 01             	add    $0x1,%ecx
801045aa:	84 db                	test   %bl,%bl
801045ac:	75 ea                	jne    80104598 <safestrcpy+0x18>
    ;
  *s = 0;
801045ae:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045b1:	5b                   	pop    %ebx
801045b2:	5e                   	pop    %esi
801045b3:	5d                   	pop    %ebp
801045b4:	c3                   	ret    
801045b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <strlen>:

int
strlen(const char *s)
{
801045c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045c8:	80 3a 00             	cmpb   $0x0,(%edx)
801045cb:	74 0c                	je     801045d9 <strlen+0x19>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	83 c0 01             	add    $0x1,%eax
801045d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045d7:	75 f7                	jne    801045d0 <strlen+0x10>
    ;
  return n;
}
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    

801045db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045e3:	55                   	push   %ebp
  pushl %ebx
801045e4:	53                   	push   %ebx
  pushl %esi
801045e5:	56                   	push   %esi
  pushl %edi
801045e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045eb:	5f                   	pop    %edi
  popl %esi
801045ec:	5e                   	pop    %esi
  popl %ebx
801045ed:	5b                   	pop    %ebx
  popl %ebp
801045ee:	5d                   	pop    %ebp
  ret
801045ef:	c3                   	ret    

801045f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801045fa:	e8 b1 f4 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
801045ff:	39 18                	cmp    %ebx,(%eax)
80104601:	77 0d                	ja     80104610 <fetchstr+0x20>
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104608:	83 c4 04             	add    $0x4,%esp
8010460b:	5b                   	pop    %ebx
8010460c:	5d                   	pop    %ebp
8010460d:	c3                   	ret    
8010460e:	66 90                	xchg   %ax,%ax
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
80104610:	8b 55 0c             	mov    0xc(%ebp),%edx
80104613:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104615:	8b 08                	mov    (%eax),%ecx
  for(s = *pp; s < ep; s++){
80104617:	39 cb                	cmp    %ecx,%ebx
80104619:	73 e8                	jae    80104603 <fetchstr+0x13>
    if(*s == 0)
8010461b:	31 c0                	xor    %eax,%eax
8010461d:	89 da                	mov    %ebx,%edx
8010461f:	80 3b 00             	cmpb   $0x0,(%ebx)
80104622:	74 e4                	je     80104608 <fetchstr+0x18>
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104628:	83 c2 01             	add    $0x1,%edx
8010462b:	39 d1                	cmp    %edx,%ecx
8010462d:	76 d4                	jbe    80104603 <fetchstr+0x13>
    if(*s == 0)
8010462f:	80 3a 00             	cmpb   $0x0,(%edx)
80104632:	75 f4                	jne    80104628 <fetchstr+0x38>
80104634:	89 d0                	mov    %edx,%eax
80104636:	29 d8                	sub    %ebx,%eax
80104638:	eb ce                	jmp    80104608 <fetchstr+0x18>
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104640 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 04             	sub    $0x4,%esp
80104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010464a:	e8 61 f4 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010464f:	8b 00                	mov    (%eax),%eax
80104651:	39 d8                	cmp    %ebx,%eax
80104653:	77 0b                	ja     80104660 <fetchint+0x20>
    return -1;
  *ip = *(int*)(addr);
  return 0;
80104655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010465a:	83 c4 04             	add    $0x4,%esp
8010465d:	5b                   	pop    %ebx
8010465e:	5d                   	pop    %ebp
8010465f:	c3                   	ret    
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104660:	8d 53 04             	lea    0x4(%ebx),%edx
80104663:	39 d0                	cmp    %edx,%eax
80104665:	72 ee                	jb     80104655 <fetchint+0x15>
    return -1;
  *ip = *(int*)(addr);
80104667:	8b 45 0c             	mov    0xc(%ebp),%eax
8010466a:	8b 13                	mov    (%ebx),%edx
8010466c:	89 10                	mov    %edx,(%eax)
8010466e:	31 c0                	xor    %eax,%eax
  return 0;
80104670:	eb e8                	jmp    8010465a <fetchint+0x1a>
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 08             	sub    $0x8,%esp
80104686:	89 1c 24             	mov    %ebx,(%esp)
80104689:	89 74 24 04          	mov    %esi,0x4(%esp)
8010468d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104690:	8b 75 0c             	mov    0xc(%ebp),%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104693:	e8 18 f4 ff ff       	call   80103ab0 <myproc>
80104698:	89 75 0c             	mov    %esi,0xc(%ebp)
8010469b:	8b 40 18             	mov    0x18(%eax),%eax
8010469e:	8b 40 44             	mov    0x44(%eax),%eax
801046a1:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046a5:	89 45 08             	mov    %eax,0x8(%ebp)
}
801046a8:	8b 1c 24             	mov    (%esp),%ebx
801046ab:	8b 74 24 04          	mov    0x4(%esp),%esi
801046af:	89 ec                	mov    %ebp,%esp
801046b1:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046b2:	e9 89 ff ff ff       	jmp    80104640 <fetchint>
801046b7:	89 f6                	mov    %esi,%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801046c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046cd:	8b 45 08             	mov    0x8(%ebp),%eax
801046d0:	89 04 24             	mov    %eax,(%esp)
801046d3:	e8 a8 ff ff ff       	call   80104680 <argint>
801046d8:	89 c2                	mov    %eax,%edx
801046da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046df:	85 d2                	test   %edx,%edx
801046e1:	78 12                	js     801046f5 <argstr+0x35>
    return -1;
  return fetchstr(addr, pp);
801046e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801046e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ed:	89 04 24             	mov    %eax,(%esp)
801046f0:	e8 fb fe ff ff       	call   801045f0 <fetchstr>
}
801046f5:	c9                   	leave  
801046f6:	c3                   	ret    
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 28             	sub    $0x28,%esp
80104706:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104709:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010470c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int i;
  struct proc *curproc = myproc();
8010470f:	e8 9c f3 ff ff       	call   80103ab0 <myproc>
80104714:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104716:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104719:	89 44 24 04          	mov    %eax,0x4(%esp)
8010471d:	8b 45 08             	mov    0x8(%ebp),%eax
80104720:	89 04 24             	mov    %eax,(%esp)
80104723:	e8 58 ff ff ff       	call   80104680 <argint>
80104728:	85 c0                	test   %eax,%eax
8010472a:	79 14                	jns    80104740 <argptr+0x40>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
8010472c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104731:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104734:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104737:	89 ec                	mov    %ebp,%esp
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104740:	85 db                	test   %ebx,%ebx
80104742:	78 e8                	js     8010472c <argptr+0x2c>
80104744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104747:	8b 16                	mov    (%esi),%edx
80104749:	39 d0                	cmp    %edx,%eax
8010474b:	73 df                	jae    8010472c <argptr+0x2c>
8010474d:	01 c3                	add    %eax,%ebx
8010474f:	39 da                	cmp    %ebx,%edx
80104751:	72 d9                	jb     8010472c <argptr+0x2c>
    return -1;
  *pp = (char*)i;
80104753:	8b 55 0c             	mov    0xc(%ebp),%edx
80104756:	89 02                	mov    %eax,(%edx)
80104758:	31 c0                	xor    %eax,%eax
  return 0;
8010475a:	eb d5                	jmp    80104731 <argptr+0x31>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <syscall>:
  [SYS_alarm]   "alarm",
};
*/
void
syscall(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	83 ec 18             	sub    $0x18,%esp
80104766:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104769:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  struct proc *curproc = myproc();
8010476c:	e8 3f f3 ff ff       	call   80103ab0 <myproc>

  num = curproc->tf->eax;
80104771:	8b 58 18             	mov    0x18(%eax),%ebx
*/
void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104774:	89 c6                	mov    %eax,%esi

  num = curproc->tf->eax;
80104776:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104779:	8d 50 ff             	lea    -0x1(%eax),%edx
8010477c:	83 fa 16             	cmp    $0x16,%edx
8010477f:	77 1f                	ja     801047a0 <syscall+0x40>
80104781:	8b 14 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%edx
80104788:	85 d2                	test   %edx,%edx
8010478a:	74 14                	je     801047a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010478c:	ff d2                	call   *%edx
8010478e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104791:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104794:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104797:	89 ec                	mov    %ebp,%esp
80104799:	5d                   	pop    %ebp
8010479a:	c3                   	ret    
8010479b:	90                   	nop
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
    //cprintf("%s -> %d\n", syscall_names[num], curproc->tf->eax);
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
801047a4:	8d 46 6c             	lea    0x6c(%esi),%eax
801047a7:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ab:	8b 46 10             	mov    0x10(%esi),%eax
801047ae:	c7 04 24 21 76 10 80 	movl   $0x80107621,(%esp)
801047b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b9:	e8 92 c0 ff ff       	call   80100850 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047be:	8b 46 18             	mov    0x18(%esi),%eax
801047c1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047c8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801047cb:	8b 75 fc             	mov    -0x4(%ebp),%esi
801047ce:	89 ec                	mov    %ebp,%esp
801047d0:	5d                   	pop    %ebp
801047d1:	c3                   	ret    
801047d2:	66 90                	xchg   %ax,%ax
801047d4:	66 90                	xchg   %ax,%ax
801047d6:	66 90                	xchg   %ax,%ax
801047d8:	66 90                	xchg   %ax,%ax
801047da:	66 90                	xchg   %ax,%ax
801047dc:	66 90                	xchg   %ax,%ax
801047de:	66 90                	xchg   %ax,%ax

801047e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	89 c3                	mov    %eax,%ebx
801047e6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801047e9:	e8 c2 f2 ff ff       	call   80103ab0 <myproc>
801047ee:	89 c2                	mov    %eax,%edx
801047f0:	31 c0                	xor    %eax,%eax
801047f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801047f8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801047fc:	85 c9                	test   %ecx,%ecx
801047fe:	74 18                	je     80104818 <fdalloc+0x38>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	83 f8 10             	cmp    $0x10,%eax
80104806:	75 f0                	jne    801047f8 <fdalloc+0x18>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104808:	83 c4 04             	add    $0x4,%esp
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
8010480b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104810:	5b                   	pop    %ebx
80104811:	5d                   	pop    %ebp
80104812:	c3                   	ret    
80104813:	90                   	nop
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104818:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
    }
  }
  return -1;
}
8010481c:	83 c4 04             	add    $0x4,%esp
8010481f:	5b                   	pop    %ebx
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104837:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010483a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104841:	00 
80104842:	89 44 24 04          	mov    %eax,0x4(%esp)
80104846:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010484d:	e8 ae fe ff ff       	call   80104700 <argptr>
80104852:	85 c0                	test   %eax,%eax
80104854:	79 12                	jns    80104868 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80104856:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010485b:	83 c4 24             	add    $0x24,%esp
8010485e:	5b                   	pop    %ebx
8010485f:	5d                   	pop    %ebp
80104860:	c3                   	ret    
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104868:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010486b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010486f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104872:	89 04 24             	mov    %eax,(%esp)
80104875:	e8 06 ec ff ff       	call   80103480 <pipealloc>
8010487a:	85 c0                	test   %eax,%eax
8010487c:	78 d8                	js     80104856 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010487e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104881:	e8 5a ff ff ff       	call   801047e0 <fdalloc>
80104886:	85 c0                	test   %eax,%eax
80104888:	89 c3                	mov    %eax,%ebx
8010488a:	78 28                	js     801048b4 <sys_pipe+0x84>
8010488c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488f:	e8 4c ff ff ff       	call   801047e0 <fdalloc>
80104894:	85 c0                	test   %eax,%eax
80104896:	78 0f                	js     801048a7 <sys_pipe+0x77>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104898:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010489b:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010489d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048a0:	89 42 04             	mov    %eax,0x4(%edx)
801048a3:	31 c0                	xor    %eax,%eax
  return 0;
801048a5:	eb b4                	jmp    8010485b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801048a7:	e8 04 f2 ff ff       	call   80103ab0 <myproc>
801048ac:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801048b3:	00 
    fileclose(rf);
801048b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048b7:	89 04 24             	mov    %eax,(%esp)
801048ba:	e8 91 c7 ff ff       	call   80101050 <fileclose>
    fileclose(wf);
801048bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048c2:	89 04 24             	mov    %eax,(%esp)
801048c5:	e8 86 c7 ff ff       	call   80101050 <fileclose>
801048ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
801048cf:	eb 8a                	jmp    8010485b <sys_pipe+0x2b>
801048d1:	eb 0d                	jmp    801048e0 <sys_exec>
801048d3:	90                   	nop
801048d4:	90                   	nop
801048d5:	90                   	nop
801048d6:	90                   	nop
801048d7:	90                   	nop
801048d8:	90                   	nop
801048d9:	90                   	nop
801048da:	90                   	nop
801048db:	90                   	nop
801048dc:	90                   	nop
801048dd:	90                   	nop
801048de:	90                   	nop
801048df:	90                   	nop

801048e0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	81 ec b8 00 00 00    	sub    $0xb8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801048e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801048ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801048ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
801048f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801048f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801048f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104900:	e8 bb fd ff ff       	call   801046c0 <argstr>
80104905:	85 c0                	test   %eax,%eax
80104907:	79 17                	jns    80104920 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
80104909:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010490e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104911:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104914:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104917:	89 ec                	mov    %ebp,%esp
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    
8010491b:	90                   	nop
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104920:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104923:	89 44 24 04          	mov    %eax,0x4(%esp)
80104927:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010492e:	e8 4d fd ff ff       	call   80104680 <argint>
80104933:	85 c0                	test   %eax,%eax
80104935:	78 d2                	js     80104909 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104937:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
8010493d:	31 f6                	xor    %esi,%esi
8010493f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80104946:	00 
80104947:	31 db                	xor    %ebx,%ebx
80104949:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104950:	00 
80104951:	89 3c 24             	mov    %edi,(%esp)
80104954:	e8 47 fa ff ff       	call   801043a0 <memset>
80104959:	eb 22                	jmp    8010497d <sys_exec+0x9d>
8010495b:	90                   	nop
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104960:	8d 14 b7             	lea    (%edi,%esi,4),%edx
80104963:	89 54 24 04          	mov    %edx,0x4(%esp)
80104967:	89 04 24             	mov    %eax,(%esp)
8010496a:	e8 81 fc ff ff       	call   801045f0 <fetchstr>
8010496f:	85 c0                	test   %eax,%eax
80104971:	78 96                	js     80104909 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104973:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104976:	83 fb 20             	cmp    $0x20,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80104979:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
8010497b:	74 8c                	je     80104909 <sys_exec+0x29>
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010497d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104980:	89 44 24 04          	mov    %eax,0x4(%esp)
80104984:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
8010498b:	03 45 e0             	add    -0x20(%ebp),%eax
8010498e:	89 04 24             	mov    %eax,(%esp)
80104991:	e8 aa fc ff ff       	call   80104640 <fetchint>
80104996:	85 c0                	test   %eax,%eax
80104998:	0f 88 6b ff ff ff    	js     80104909 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
8010499e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801049a1:	85 c0                	test   %eax,%eax
801049a3:	75 bb                	jne    80104960 <sys_exec+0x80>
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801049a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801049a8:	c7 84 9d 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%ebx,4)
801049af:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801049b3:	89 7c 24 04          	mov    %edi,0x4(%esp)
801049b7:	89 04 24             	mov    %eax,(%esp)
801049ba:	e8 01 c0 ff ff       	call   801009c0 <exec>
801049bf:	e9 4a ff ff ff       	jmp    8010490e <sys_exec+0x2e>
801049c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049d0 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801049d8:	e8 d3 f0 ff ff       	call   80103ab0 <myproc>
801049dd:	89 c3                	mov    %eax,%ebx
  
  begin_op();
801049df:	e8 3c e3 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801049e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049f2:	e8 c9 fc ff ff       	call   801046c0 <argstr>
801049f7:	85 c0                	test   %eax,%eax
801049f9:	78 4d                	js     80104a48 <sys_chdir+0x78>
801049fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049fe:	89 04 24             	mov    %eax,(%esp)
80104a01:	e8 da d4 ff ff       	call   80101ee0 <namei>
80104a06:	85 c0                	test   %eax,%eax
80104a08:	89 c6                	mov    %eax,%esi
80104a0a:	74 3c                	je     80104a48 <sys_chdir+0x78>
    end_op();
    return -1;
  }
  ilock(ip);
80104a0c:	89 04 24             	mov    %eax,(%esp)
80104a0f:	e8 9c cf ff ff       	call   801019b0 <ilock>
  if(ip->type != T_DIR){
80104a14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104a19:	75 25                	jne    80104a40 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104a1b:	89 34 24             	mov    %esi,(%esp)
80104a1e:	e8 bd d2 ff ff       	call   80101ce0 <iunlock>
  iput(curproc->cwd);
80104a23:	8b 43 68             	mov    0x68(%ebx),%eax
80104a26:	89 04 24             	mov    %eax,(%esp)
80104a29:	e8 62 d0 ff ff       	call   80101a90 <iput>
  end_op();
80104a2e:	e8 bd e1 ff ff       	call   80102bf0 <end_op>
  curproc->cwd = ip;
80104a33:	31 c0                	xor    %eax,%eax
80104a35:	89 73 68             	mov    %esi,0x68(%ebx)
  return 0;
}
80104a38:	83 c4 20             	add    $0x20,%esp
80104a3b:	5b                   	pop    %ebx
80104a3c:	5e                   	pop    %esi
80104a3d:	5d                   	pop    %ebp
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80104a40:	89 34 24             	mov    %esi,(%esp)
80104a43:	e8 e8 d2 ff ff       	call   80101d30 <iunlockput>
    end_op();
80104a48:	e8 a3 e1 ff ff       	call   80102bf0 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80104a4d:	83 c4 20             	add    $0x20,%esp
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80104a55:	5b                   	pop    %ebx
80104a56:	5e                   	pop    %esi
80104a57:	5d                   	pop    %ebp
80104a58:	c3                   	ret    
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	83 ec 58             	sub    $0x58,%esp
80104a66:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a6f:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a72:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a75:	31 db                	xor    %ebx,%ebx
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a77:	89 7d fc             	mov    %edi,-0x4(%ebp)
80104a7a:	89 d7                	mov    %edx,%edi
80104a7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a7f:	89 74 24 04          	mov    %esi,0x4(%esp)
80104a83:	89 04 24             	mov    %eax,(%esp)
80104a86:	e8 35 d4 ff ff       	call   80101ec0 <nameiparent>
80104a8b:	85 c0                	test   %eax,%eax
80104a8d:	74 47                	je     80104ad6 <create+0x76>
    return 0;
  ilock(dp);
80104a8f:	89 04 24             	mov    %eax,(%esp)
80104a92:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104a95:	e8 16 cf ff ff       	call   801019b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a9a:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104a9d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aa4:	89 74 24 04          	mov    %esi,0x4(%esp)
80104aa8:	89 14 24             	mov    %edx,(%esp)
80104aab:	e8 80 cd ff ff       	call   80101830 <dirlookup>
80104ab0:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104ab3:	85 c0                	test   %eax,%eax
80104ab5:	89 c3                	mov    %eax,%ebx
80104ab7:	74 3f                	je     80104af8 <create+0x98>
    iunlockput(dp);
80104ab9:	89 14 24             	mov    %edx,(%esp)
80104abc:	e8 6f d2 ff ff       	call   80101d30 <iunlockput>
    ilock(ip);
80104ac1:	89 1c 24             	mov    %ebx,(%esp)
80104ac4:	e8 e7 ce ff ff       	call   801019b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ac9:	66 83 ff 02          	cmp    $0x2,%di
80104acd:	75 19                	jne    80104ae8 <create+0x88>
80104acf:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104ad4:	75 12                	jne    80104ae8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ad6:	89 d8                	mov    %ebx,%eax
80104ad8:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104adb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104ade:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104ae1:	89 ec                	mov    %ebp,%esp
80104ae3:	5d                   	pop    %ebp
80104ae4:	c3                   	ret    
80104ae5:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104ae8:	89 1c 24             	mov    %ebx,(%esp)
80104aeb:	31 db                	xor    %ebx,%ebx
80104aed:	e8 3e d2 ff ff       	call   80101d30 <iunlockput>
    return 0;
80104af2:	eb e2                	jmp    80104ad6 <create+0x76>
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104af8:	0f bf c7             	movswl %di,%eax
80104afb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aff:	8b 02                	mov    (%edx),%eax
80104b01:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104b04:	89 04 24             	mov    %eax,(%esp)
80104b07:	e8 d4 cd ff ff       	call   801018e0 <ialloc>
80104b0c:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	89 c3                	mov    %eax,%ebx
80104b13:	0f 84 b7 00 00 00    	je     80104bd0 <create+0x170>
    panic("create: ialloc");

  ilock(ip);
80104b19:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104b1c:	89 04 24             	mov    %eax,(%esp)
80104b1f:	e8 8c ce ff ff       	call   801019b0 <ilock>
  ip->major = major;
80104b24:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
80104b28:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104b2c:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
80104b30:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
80104b36:	66 89 4b 54          	mov    %cx,0x54(%ebx)
  ip->nlink = 1;
  iupdate(ip);
80104b3a:	89 1c 24             	mov    %ebx,(%esp)
80104b3d:	e8 5e c7 ff ff       	call   801012a0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104b42:	66 83 ff 01          	cmp    $0x1,%di
80104b46:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104b49:	74 2d                	je     80104b78 <create+0x118>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104b4b:	8b 43 04             	mov    0x4(%ebx),%eax
80104b4e:	89 14 24             	mov    %edx,(%esp)
80104b51:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104b54:	89 74 24 04          	mov    %esi,0x4(%esp)
80104b58:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b5c:	e8 8f d0 ff ff       	call   80101bf0 <dirlink>
80104b61:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104b64:	85 c0                	test   %eax,%eax
80104b66:	78 74                	js     80104bdc <create+0x17c>
    panic("create: dirlink");

  iunlockput(dp);
80104b68:	89 14 24             	mov    %edx,(%esp)
80104b6b:	e8 c0 d1 ff ff       	call   80101d30 <iunlockput>

  return ip;
80104b70:	e9 61 ff ff ff       	jmp    80104ad6 <create+0x76>
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104b78:	66 83 42 56 01       	addw   $0x1,0x56(%edx)
    iupdate(dp);
80104b7d:	89 14 24             	mov    %edx,(%esp)
80104b80:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104b83:	e8 18 c7 ff ff       	call   801012a0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b88:	8b 43 04             	mov    0x4(%ebx),%eax
80104b8b:	c7 44 24 04 b0 76 10 	movl   $0x801076b0,0x4(%esp)
80104b92:	80 
80104b93:	89 1c 24             	mov    %ebx,(%esp)
80104b96:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b9a:	e8 51 d0 ff ff       	call   80101bf0 <dirlink>
80104b9f:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	78 1e                	js     80104bc4 <create+0x164>
80104ba6:	8b 42 04             	mov    0x4(%edx),%eax
80104ba9:	c7 44 24 04 af 76 10 	movl   $0x801076af,0x4(%esp)
80104bb0:	80 
80104bb1:	89 1c 24             	mov    %ebx,(%esp)
80104bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bb8:	e8 33 d0 ff ff       	call   80101bf0 <dirlink>
80104bbd:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	79 87                	jns    80104b4b <create+0xeb>
      panic("create dots");
80104bc4:	c7 04 24 b2 76 10 80 	movl   $0x801076b2,(%esp)
80104bcb:	e8 e0 b7 ff ff       	call   801003b0 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104bd0:	c7 04 24 a0 76 10 80 	movl   $0x801076a0,(%esp)
80104bd7:	e8 d4 b7 ff ff       	call   801003b0 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104bdc:	c7 04 24 be 76 10 80 	movl   $0x801076be,(%esp)
80104be3:	e8 c8 b7 ff ff       	call   801003b0 <panic>
80104be8:	90                   	nop
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104bf6:	e8 25 e1 ff ff       	call   80102d20 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104bfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c09:	e8 b2 fa ff ff       	call   801046c0 <argstr>
80104c0e:	85 c0                	test   %eax,%eax
80104c10:	78 5e                	js     80104c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104c12:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c20:	e8 5b fa ff ff       	call   80104680 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104c25:	85 c0                	test   %eax,%eax
80104c27:	78 47                	js     80104c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104c29:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c30:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104c37:	e8 44 fa ff ff       	call   80104680 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104c3c:	85 c0                	test   %eax,%eax
80104c3e:	78 30                	js     80104c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80104c40:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104c44:	ba 03 00 00 00       	mov    $0x3,%edx
80104c49:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104c4d:	89 04 24             	mov    %eax,(%esp)
80104c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c53:	e8 08 fe ff ff       	call   80104a60 <create>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104c58:	85 c0                	test   %eax,%eax
80104c5a:	74 14                	je     80104c70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c5c:	89 04 24             	mov    %eax,(%esp)
80104c5f:	e8 cc d0 ff ff       	call   80101d30 <iunlockput>
  end_op();
80104c64:	e8 87 df ff ff       	call   80102bf0 <end_op>
80104c69:	31 c0                	xor    %eax,%eax
  return 0;
}
80104c6b:	c9                   	leave  
80104c6c:	c3                   	ret    
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80104c70:	e8 7b df ff ff       	call   80102bf0 <end_op>
80104c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104c7a:	c9                   	leave  
80104c7b:	c3                   	ret    
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c80 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104c86:	e8 95 e0 ff ff       	call   80102d20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104c8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c99:	e8 22 fa ff ff       	call   801046c0 <argstr>
80104c9e:	85 c0                	test   %eax,%eax
80104ca0:	78 2e                	js     80104cd0 <sys_mkdir+0x50>
80104ca2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cac:	31 c9                	xor    %ecx,%ecx
80104cae:	ba 01 00 00 00       	mov    $0x1,%edx
80104cb3:	e8 a8 fd ff ff       	call   80104a60 <create>
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	74 14                	je     80104cd0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104cbc:	89 04 24             	mov    %eax,(%esp)
80104cbf:	e8 6c d0 ff ff       	call   80101d30 <iunlockput>
  end_op();
80104cc4:	e8 27 df ff ff       	call   80102bf0 <end_op>
80104cc9:	31 c0                	xor    %eax,%eax
  return 0;
}
80104ccb:	c9                   	leave  
80104ccc:	c3                   	ret    
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80104cd0:	e8 1b df ff ff       	call   80102bf0 <end_op>
80104cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104cda:	c9                   	leave  
80104cdb:	c3                   	ret    
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ce6:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ce9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104cec:	89 75 f8             	mov    %esi,-0x8(%ebp)
80104cef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cfd:	e8 be f9 ff ff       	call   801046c0 <argstr>
80104d02:	85 c0                	test   %eax,%eax
80104d04:	79 12                	jns    80104d18 <sys_link+0x38>
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104d0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104d11:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104d14:	89 ec                	mov    %ebp,%esp
80104d16:	5d                   	pop    %ebp
80104d17:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d18:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d26:	e8 95 f9 ff ff       	call   801046c0 <argstr>
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	78 d7                	js     80104d06 <sys_link+0x26>
    return -1;

  begin_op();
80104d2f:	e8 ec df ff ff       	call   80102d20 <begin_op>
  if((ip = namei(old)) == 0){
80104d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d37:	89 04 24             	mov    %eax,(%esp)
80104d3a:	e8 a1 d1 ff ff       	call   80101ee0 <namei>
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	89 c3                	mov    %eax,%ebx
80104d43:	0f 84 a6 00 00 00    	je     80104def <sys_link+0x10f>
    end_op();
    return -1;
  }

  ilock(ip);
80104d49:	89 04 24             	mov    %eax,(%esp)
80104d4c:	e8 5f cc ff ff       	call   801019b0 <ilock>
  if(ip->type == T_DIR){
80104d51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d56:	0f 84 8b 00 00 00    	je     80104de7 <sys_link+0x107>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d61:	8d 7d d2             	lea    -0x2e(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d64:	89 1c 24             	mov    %ebx,(%esp)
80104d67:	e8 34 c5 ff ff       	call   801012a0 <iupdate>
  iunlock(ip);
80104d6c:	89 1c 24             	mov    %ebx,(%esp)
80104d6f:	e8 6c cf ff ff       	call   80101ce0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d77:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d7b:	89 04 24             	mov    %eax,(%esp)
80104d7e:	e8 3d d1 ff ff       	call   80101ec0 <nameiparent>
80104d83:	85 c0                	test   %eax,%eax
80104d85:	89 c6                	mov    %eax,%esi
80104d87:	74 49                	je     80104dd2 <sys_link+0xf2>
    goto bad;
  ilock(dp);
80104d89:	89 04 24             	mov    %eax,(%esp)
80104d8c:	e8 1f cc ff ff       	call   801019b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d91:	8b 06                	mov    (%esi),%eax
80104d93:	3b 03                	cmp    (%ebx),%eax
80104d95:	75 33                	jne    80104dca <sys_link+0xea>
80104d97:	8b 43 04             	mov    0x4(%ebx),%eax
80104d9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d9e:	89 34 24             	mov    %esi,(%esp)
80104da1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104da5:	e8 46 ce ff ff       	call   80101bf0 <dirlink>
80104daa:	85 c0                	test   %eax,%eax
80104dac:	78 1c                	js     80104dca <sys_link+0xea>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104dae:	89 34 24             	mov    %esi,(%esp)
80104db1:	e8 7a cf ff ff       	call   80101d30 <iunlockput>
  iput(ip);
80104db6:	89 1c 24             	mov    %ebx,(%esp)
80104db9:	e8 d2 cc ff ff       	call   80101a90 <iput>

  end_op();
80104dbe:	e8 2d de ff ff       	call   80102bf0 <end_op>
80104dc3:	31 c0                	xor    %eax,%eax

  return 0;
80104dc5:	e9 41 ff ff ff       	jmp    80104d0b <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104dca:	89 34 24             	mov    %esi,(%esp)
80104dcd:	e8 5e cf ff ff       	call   80101d30 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104dd2:	89 1c 24             	mov    %ebx,(%esp)
80104dd5:	e8 d6 cb ff ff       	call   801019b0 <ilock>
  ip->nlink--;
80104dda:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ddf:	89 1c 24             	mov    %ebx,(%esp)
80104de2:	e8 b9 c4 ff ff       	call   801012a0 <iupdate>
  iunlockput(ip);
80104de7:	89 1c 24             	mov    %ebx,(%esp)
80104dea:	e8 41 cf ff ff       	call   80101d30 <iunlockput>
  end_op();
80104def:	e8 fc dd ff ff       	call   80102bf0 <end_op>
80104df4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
80104df9:	e9 0d ff ff ff       	jmp    80104d0b <sys_link+0x2b>
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104e09:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104e0c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e1a:	e8 a1 f8 ff ff       	call   801046c0 <argstr>
80104e1f:	85 c0                	test   %eax,%eax
80104e21:	79 15                	jns    80104e38 <sys_open+0x38>
  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104e23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e28:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104e2b:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104e2e:	89 ec                	mov    %ebp,%esp
80104e30:	5d                   	pop    %ebp
80104e31:	c3                   	ret    
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e46:	e8 35 f8 ff ff       	call   80104680 <argint>
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	78 d4                	js     80104e23 <sys_open+0x23>
    return -1;

  begin_op();
80104e4f:	e8 cc de ff ff       	call   80102d20 <begin_op>

  if(omode & O_CREATE){
80104e54:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
80104e58:	74 76                	je     80104ed0 <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
80104e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5d:	31 c9                	xor    %ecx,%ecx
80104e5f:	ba 02 00 00 00       	mov    $0x2,%edx
80104e64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e6b:	e8 f0 fb ff ff       	call   80104a60 <create>
    if(ip == 0){
80104e70:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e72:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e74:	0f 84 a2 00 00 00    	je     80104f1c <sys_open+0x11c>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e7a:	e8 51 c1 ff ff       	call   80100fd0 <filealloc>
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	89 c3                	mov    %eax,%ebx
80104e83:	0f 84 8b 00 00 00    	je     80104f14 <sys_open+0x114>
80104e89:	e8 52 f9 ff ff       	call   801047e0 <fdalloc>
80104e8e:	85 c0                	test   %eax,%eax
80104e90:	78 7a                	js     80104f0c <sys_open+0x10c>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104e95:	89 34 24             	mov    %esi,(%esp)
80104e98:	e8 43 ce ff ff       	call   80101ce0 <iunlock>
  end_op();
80104e9d:	e8 4e dd ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80104ea2:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104ea8:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104eab:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104eb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104eb5:	83 f2 01             	xor    $0x1,%edx
80104eb8:	83 e2 01             	and    $0x1,%edx
80104ebb:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ebe:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
80104ec2:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
80104ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ec9:	e9 5a ff ff ff       	jmp    80104e28 <sys_open+0x28>
80104ece:	66 90                	xchg   %ax,%ax
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed3:	89 04 24             	mov    %eax,(%esp)
80104ed6:	e8 05 d0 ff ff       	call   80101ee0 <namei>
80104edb:	85 c0                	test   %eax,%eax
80104edd:	89 c6                	mov    %eax,%esi
80104edf:	74 3b                	je     80104f1c <sys_open+0x11c>
      end_op();
      return -1;
    }
    ilock(ip);
80104ee1:	89 04 24             	mov    %eax,(%esp)
80104ee4:	e8 c7 ca ff ff       	call   801019b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ee9:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104eee:	75 8a                	jne    80104e7a <sys_open+0x7a>
80104ef0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80104ef3:	85 db                	test   %ebx,%ebx
80104ef5:	74 83                	je     80104e7a <sys_open+0x7a>
      iunlockput(ip);
80104ef7:	89 34 24             	mov    %esi,(%esp)
80104efa:	e8 31 ce ff ff       	call   80101d30 <iunlockput>
      end_op();
80104eff:	e8 ec dc ff ff       	call   80102bf0 <end_op>
80104f04:	83 c8 ff             	or     $0xffffffff,%eax
      return -1;
80104f07:	e9 1c ff ff ff       	jmp    80104e28 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104f0c:	89 1c 24             	mov    %ebx,(%esp)
80104f0f:	e8 3c c1 ff ff       	call   80101050 <fileclose>
    iunlockput(ip);
80104f14:	89 34 24             	mov    %esi,(%esp)
80104f17:	e8 14 ce ff ff       	call   80101d30 <iunlockput>
    end_op();
80104f1c:	e8 cf dc ff ff       	call   80102bf0 <end_op>
80104f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
80104f26:	e9 fd fe ff ff       	jmp    80104e28 <sys_open+0x28>
80104f2b:	90                   	nop
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f30 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	53                   	push   %ebx
80104f36:	83 ec 6c             	sub    $0x6c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104f39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f47:	e8 74 f7 ff ff       	call   801046c0 <argstr>
80104f4c:	89 c2                	mov    %eax,%edx
80104f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f53:	85 d2                	test   %edx,%edx
80104f55:	0f 88 0b 01 00 00    	js     80105066 <sys_unlink+0x136>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104f5b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104f5e:	e8 bd dd ff ff       	call   80102d20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f63:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f6a:	89 04 24             	mov    %eax,(%esp)
80104f6d:	e8 4e cf ff ff       	call   80101ec0 <nameiparent>
80104f72:	85 c0                	test   %eax,%eax
80104f74:	89 45 a4             	mov    %eax,-0x5c(%ebp)
80104f77:	0f 84 53 01 00 00    	je     801050d0 <sys_unlink+0x1a0>
    end_op();
    return -1;
  }

  ilock(dp);
80104f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104f80:	89 04 24             	mov    %eax,(%esp)
80104f83:	e8 28 ca ff ff       	call   801019b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f88:	c7 44 24 04 b0 76 10 	movl   $0x801076b0,0x4(%esp)
80104f8f:	80 
80104f90:	89 1c 24             	mov    %ebx,(%esp)
80104f93:	e8 d8 c2 ff ff       	call   80101270 <namecmp>
80104f98:	85 c0                	test   %eax,%eax
80104f9a:	0f 84 25 01 00 00    	je     801050c5 <sys_unlink+0x195>
80104fa0:	c7 44 24 04 af 76 10 	movl   $0x801076af,0x4(%esp)
80104fa7:	80 
80104fa8:	89 1c 24             	mov    %ebx,(%esp)
80104fab:	e8 c0 c2 ff ff       	call   80101270 <namecmp>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	0f 84 0d 01 00 00    	je     801050c5 <sys_unlink+0x195>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104fb8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104fbb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104fc3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104fc6:	89 04 24             	mov    %eax,(%esp)
80104fc9:	e8 62 c8 ff ff       	call   80101830 <dirlookup>
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	89 c6                	mov    %eax,%esi
80104fd2:	0f 84 ed 00 00 00    	je     801050c5 <sys_unlink+0x195>
    goto bad;
  ilock(ip);
80104fd8:	89 04 24             	mov    %eax,(%esp)
80104fdb:	e8 d0 c9 ff ff       	call   801019b0 <ilock>

  if(ip->nlink < 1)
80104fe0:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80104fe5:	0f 8e 2a 01 00 00    	jle    80105115 <sys_unlink+0x1e5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104feb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ff0:	74 7e                	je     80105070 <sys_unlink+0x140>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104ff2:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
80104ff5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ffc:	00 
80104ffd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105004:	00 
80105005:	89 1c 24             	mov    %ebx,(%esp)
80105008:	e8 93 f3 ff ff       	call   801043a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010500d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105014:	00 
80105015:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105018:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010501c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105020:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105023:	89 04 24             	mov    %eax,(%esp)
80105026:	e8 d5 c5 ff ff       	call   80101600 <writei>
8010502b:	83 f8 10             	cmp    $0x10,%eax
8010502e:	0f 85 d5 00 00 00    	jne    80105109 <sys_unlink+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105034:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105039:	0f 84 a9 00 00 00    	je     801050e8 <sys_unlink+0x1b8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010503f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105042:	89 04 24             	mov    %eax,(%esp)
80105045:	e8 e6 cc ff ff       	call   80101d30 <iunlockput>

  ip->nlink--;
8010504a:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
  iupdate(ip);
8010504f:	89 34 24             	mov    %esi,(%esp)
80105052:	e8 49 c2 ff ff       	call   801012a0 <iupdate>
  iunlockput(ip);
80105057:	89 34 24             	mov    %esi,(%esp)
8010505a:	e8 d1 cc ff ff       	call   80101d30 <iunlockput>

  end_op();
8010505f:	e8 8c db ff ff       	call   80102bf0 <end_op>
80105064:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105066:	83 c4 6c             	add    $0x6c,%esp
80105069:	5b                   	pop    %ebx
8010506a:	5e                   	pop    %esi
8010506b:	5f                   	pop    %edi
8010506c:	5d                   	pop    %ebp
8010506d:	c3                   	ret    
8010506e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105070:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105074:	0f 86 78 ff ff ff    	jbe    80104ff2 <sys_unlink+0xc2>
8010507a:	8d 7d b2             	lea    -0x4e(%ebp),%edi
8010507d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105082:	eb 10                	jmp    80105094 <sys_unlink+0x164>
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105088:	83 c3 10             	add    $0x10,%ebx
8010508b:	3b 5e 58             	cmp    0x58(%esi),%ebx
8010508e:	0f 83 5e ff ff ff    	jae    80104ff2 <sys_unlink+0xc2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105094:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010509b:	00 
8010509c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801050a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050a4:	89 34 24             	mov    %esi,(%esp)
801050a7:	e8 74 c6 ff ff       	call   80101720 <readi>
801050ac:	83 f8 10             	cmp    $0x10,%eax
801050af:	75 4c                	jne    801050fd <sys_unlink+0x1cd>
      panic("isdirempty: readi");
    if(de.inum != 0)
801050b1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
801050b6:	74 d0                	je     80105088 <sys_unlink+0x158>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801050b8:	89 34 24             	mov    %esi,(%esp)
801050bb:	90                   	nop
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050c0:	e8 6b cc ff ff       	call   80101d30 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
801050c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801050c8:	89 04 24             	mov    %eax,(%esp)
801050cb:	e8 60 cc ff ff       	call   80101d30 <iunlockput>
  end_op();
801050d0:	e8 1b db ff ff       	call   80102bf0 <end_op>
  return -1;
}
801050d5:	83 c4 6c             	add    $0x6c,%esp

  return 0;

bad:
  iunlockput(dp);
  end_op();
801050d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
801050dd:	5b                   	pop    %ebx
801050de:	5e                   	pop    %esi
801050df:	5f                   	pop    %edi
801050e0:	5d                   	pop    %ebp
801050e1:	c3                   	ret    
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801050e8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801050eb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801050f0:	89 04 24             	mov    %eax,(%esp)
801050f3:	e8 a8 c1 ff ff       	call   801012a0 <iupdate>
801050f8:	e9 42 ff ff ff       	jmp    8010503f <sys_unlink+0x10f>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801050fd:	c7 04 24 e0 76 10 80 	movl   $0x801076e0,(%esp)
80105104:	e8 a7 b2 ff ff       	call   801003b0 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105109:	c7 04 24 f2 76 10 80 	movl   $0x801076f2,(%esp)
80105110:	e8 9b b2 ff ff       	call   801003b0 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105115:	c7 04 24 ce 76 10 80 	movl   $0x801076ce,(%esp)
8010511c:	e8 8f b2 ff ff       	call   801003b0 <panic>
80105121:	eb 0d                	jmp    80105130 <T.62>
80105123:	90                   	nop
80105124:	90                   	nop
80105125:	90                   	nop
80105126:	90                   	nop
80105127:	90                   	nop
80105128:	90                   	nop
80105129:	90                   	nop
8010512a:	90                   	nop
8010512b:	90                   	nop
8010512c:	90                   	nop
8010512d:	90                   	nop
8010512e:	90                   	nop
8010512f:	90                   	nop

80105130 <T.62>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 28             	sub    $0x28,%esp
80105136:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80105139:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010513b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010513e:	89 75 fc             	mov    %esi,-0x4(%ebp)
80105141:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105143:	89 44 24 04          	mov    %eax,0x4(%esp)
80105147:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010514e:	e8 2d f5 ff ff       	call   80104680 <argint>
80105153:	85 c0                	test   %eax,%eax
80105155:	79 11                	jns    80105168 <T.62+0x38>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
80105157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
8010515c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010515f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80105162:	89 ec                	mov    %ebp,%esp
80105164:	5d                   	pop    %ebp
80105165:	c3                   	ret    
80105166:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105168:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010516c:	77 e9                	ja     80105157 <T.62+0x27>
8010516e:	e8 3d e9 ff ff       	call   80103ab0 <myproc>
80105173:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105176:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
8010517a:	85 d2                	test   %edx,%edx
8010517c:	74 d9                	je     80105157 <T.62+0x27>
    return -1;
  if(pfd)
8010517e:	85 db                	test   %ebx,%ebx
80105180:	74 02                	je     80105184 <T.62+0x54>
    *pfd = fd;
80105182:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
80105184:	31 c0                	xor    %eax,%eax
80105186:	85 f6                	test   %esi,%esi
80105188:	74 d2                	je     8010515c <T.62+0x2c>
    *pf = f;
8010518a:	89 16                	mov    %edx,(%esi)
8010518c:	eb ce                	jmp    8010515c <T.62+0x2c>
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105190:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105191:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	53                   	push   %ebx
80105196:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105199:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010519c:	e8 8f ff ff ff       	call   80105130 <T.62>
801051a1:	85 c0                	test   %eax,%eax
801051a3:	79 13                	jns    801051b8 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801051a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051aa:	89 d8                	mov    %ebx,%eax
801051ac:	83 c4 24             	add    $0x24,%esp
801051af:	5b                   	pop    %ebx
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801051b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bb:	e8 20 f6 ff ff       	call   801047e0 <fdalloc>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	89 c3                	mov    %eax,%ebx
801051c4:	78 df                	js     801051a5 <sys_dup+0x15>
    return -1;
  filedup(f);
801051c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c9:	89 04 24             	mov    %eax,(%esp)
801051cc:	e8 af bd ff ff       	call   80100f80 <filedup>
  return fd;
801051d1:	eb d7                	jmp    801051aa <sys_dup+0x1a>
801051d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <sys_read>:
}

int
sys_read(void)
{
801051e0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051eb:	e8 40 ff ff ff       	call   80105130 <T.62>
801051f0:	85 c0                	test   %eax,%eax
801051f2:	79 0c                	jns    80105200 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
801051f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f9:	c9                   	leave  
801051fa:	c3                   	ret    
801051fb:	90                   	nop
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105200:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105203:	89 44 24 04          	mov    %eax,0x4(%esp)
80105207:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010520e:	e8 6d f4 ff ff       	call   80104680 <argint>
80105213:	85 c0                	test   %eax,%eax
80105215:	78 dd                	js     801051f4 <sys_read+0x14>
80105217:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010521a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105221:	89 44 24 08          	mov    %eax,0x8(%esp)
80105225:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105228:	89 44 24 04          	mov    %eax,0x4(%esp)
8010522c:	e8 cf f4 ff ff       	call   80104700 <argptr>
80105231:	85 c0                	test   %eax,%eax
80105233:	78 bf                	js     801051f4 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
80105235:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105238:	89 44 24 08          	mov    %eax,0x8(%esp)
8010523c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010523f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105246:	89 04 24             	mov    %eax,(%esp)
80105249:	e8 32 bc ff ff       	call   80100e80 <fileread>
}
8010524e:	c9                   	leave  
8010524f:	c3                   	ret    

80105250 <sys_write>:

int
sys_write(void)
{
80105250:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105251:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105258:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010525b:	e8 d0 fe ff ff       	call   80105130 <T.62>
80105260:	85 c0                	test   %eax,%eax
80105262:	79 0c                	jns    80105270 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
80105264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105269:	c9                   	leave  
8010526a:	c3                   	ret    
8010526b:	90                   	nop
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105270:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105273:	89 44 24 04          	mov    %eax,0x4(%esp)
80105277:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010527e:	e8 fd f3 ff ff       	call   80104680 <argint>
80105283:	85 c0                	test   %eax,%eax
80105285:	78 dd                	js     80105264 <sys_write+0x14>
80105287:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010528a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105291:	89 44 24 08          	mov    %eax,0x8(%esp)
80105295:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105298:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529c:	e8 5f f4 ff ff       	call   80104700 <argptr>
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 bf                	js     80105264 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
801052a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801052ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052af:	89 44 24 04          	mov    %eax,0x4(%esp)
801052b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b6:	89 04 24             	mov    %eax,(%esp)
801052b9:	e8 a2 ba ff ff       	call   80100d60 <filewrite>
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    

801052c0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
801052c0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052c1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801052c3:	89 e5                	mov    %esp,%ebp
801052c5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052c8:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052cb:	e8 60 fe ff ff       	call   80105130 <T.62>
801052d0:	85 c0                	test   %eax,%eax
801052d2:	79 0c                	jns    801052e0 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
801052d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d9:	c9                   	leave  
801052da:	c3                   	ret    
801052db:	90                   	nop
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e3:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801052ea:	00 
801052eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052f6:	e8 05 f4 ff ff       	call   80104700 <argptr>
801052fb:	85 c0                	test   %eax,%eax
801052fd:	78 d5                	js     801052d4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
801052ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105302:	89 44 24 04          	mov    %eax,0x4(%esp)
80105306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105309:	89 04 24             	mov    %eax,(%esp)
8010530c:	e8 1f bc ff ff       	call   80100f30 <filestat>
}
80105311:	c9                   	leave  
80105312:	c3                   	ret    
80105313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105326:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105329:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532c:	e8 ff fd ff ff       	call   80105130 <T.62>
80105331:	89 c2                	mov    %eax,%edx
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105338:	85 d2                	test   %edx,%edx
8010533a:	78 1d                	js     80105359 <sys_close+0x39>
    return -1;
  myproc()->ofile[fd] = 0;
8010533c:	e8 6f e7 ff ff       	call   80103ab0 <myproc>
80105341:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105344:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010534b:	00 
  fileclose(f);
8010534c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010534f:	89 04 24             	mov    %eax,(%esp)
80105352:	e8 f9 bc ff ff       	call   80101050 <fileclose>
80105357:	31 c0                	xor    %eax,%eax
  return 0;
}
80105359:	c9                   	leave  
8010535a:	c3                   	ret    
8010535b:	66 90                	xchg   %ax,%ax
8010535d:	66 90                	xchg   %ax,%ax
8010535f:	90                   	nop

80105360 <sys_alarm>:

}

int
sys_alarm(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 28             	sub    $0x28,%esp
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
80105366:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105374:	e8 07 f3 ff ff       	call   80104680 <argint>
80105379:	85 c0                	test   %eax,%eax
8010537b:	79 0b                	jns    80105388 <sys_alarm+0x28>
    return -1;
  if(argptr(1, (char**)&handler, 1) < 0)
    return -1;
  myproc()->alarmticks = ticks;
  myproc()->alarmhandler = handler;
    return 0;
8010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105382:	c9                   	leave  
80105383:	c3                   	ret    
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int ticks;
  void (*handler)();

  if(argint(0, &ticks) < 0)
    return -1;
  if(argptr(1, (char**)&handler, 1) < 0)
80105388:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010538b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80105392:	00 
80105393:	89 44 24 04          	mov    %eax,0x4(%esp)
80105397:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010539e:	e8 5d f3 ff ff       	call   80104700 <argptr>
801053a3:	85 c0                	test   %eax,%eax
801053a5:	78 d6                	js     8010537d <sys_alarm+0x1d>
    return -1;
  myproc()->alarmticks = ticks;
801053a7:	e8 04 e7 ff ff       	call   80103ab0 <myproc>
801053ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053af:	89 50 7c             	mov    %edx,0x7c(%eax)
  myproc()->alarmhandler = handler;
801053b2:	e8 f9 e6 ff ff       	call   80103ab0 <myproc>
801053b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053ba:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
801053c0:	31 c0                	xor    %eax,%eax
    return 0;
}
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053d0 <sys_sbrk>:
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053d4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801053d9:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053df:	89 44 24 04          	mov    %eax,0x4(%esp)
801053e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053ea:	e8 91 f2 ff ff       	call   80104680 <argint>
801053ef:	85 c0                	test   %eax,%eax
801053f1:	78 11                	js     80105404 <sys_sbrk+0x34>
    return -1;
  addr = myproc()->sz;
801053f3:	e8 b8 e6 ff ff       	call   80103ab0 <myproc>
801053f8:	8b 18                	mov    (%eax),%ebx
  myproc()->sz += n;
801053fa:	e8 b1 e6 ff ff       	call   80103ab0 <myproc>
801053ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105402:	01 10                	add    %edx,(%eax)
  //if(growproc(n) < 0)
  //  return -1;
  return addr;
}
80105404:	89 d8                	mov    %ebx,%eax
80105406:	83 c4 24             	add    $0x24,%esp
80105409:	5b                   	pop    %ebx
8010540a:	5d                   	pop    %ebp
8010540b:	c3                   	ret    
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105416:	e8 95 e6 ff ff       	call   80103ab0 <myproc>
8010541b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010541e:	c9                   	leave  
8010541f:	c3                   	ret    

80105420 <sys_date>:
  return xticks;
}

int
sys_date(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 28             	sub    $0x28,%esp
  char * hold;

  if(argptr(0, &hold, sizeof(struct rtcdate *)) < 0) //definition and parameters of function
80105426:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105429:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105430:	00 
80105431:	89 44 24 04          	mov    %eax,0x4(%esp)
80105435:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010543c:	e8 bf f2 ff ff       	call   80104700 <argptr>
80105441:	89 c2                	mov    %eax,%edx
80105443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105448:	85 d2                	test   %edx,%edx
8010544a:	78 0d                	js     80105459 <sys_date+0x39>
    return -1;                                       //argptr can be found in syscall.c
  
  cmostime((struct rtcdate *) hold); //cast char * hold to struct rtcdate *
8010544c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544f:	89 04 24             	mov    %eax,(%esp)
80105452:	e8 e9 d3 ff ff       	call   80102840 <cmostime>
80105457:	31 c0                	xor    %eax,%eax
  return 0;

}
80105459:	c9                   	leave  
8010545a:	c3                   	ret    
8010545b:	90                   	nop
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105467:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
8010546e:	e8 bd ee ff ff       	call   80104330 <acquire>
  xticks = ticks;
80105473:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  release(&tickslock);
80105479:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105480:	e8 5b ee ff ff       	call   801042e0 <release>
  return xticks;
}
80105485:	83 c4 14             	add    $0x14,%esp
80105488:	89 d8                	mov    %ebx,%eax
8010548a:	5b                   	pop    %ebx
8010548b:	5d                   	pop    %ebp
8010548c:	c3                   	ret    
8010548d:	8d 76 00             	lea    0x0(%esi),%esi

80105490 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a5:	e8 d6 f1 ff ff       	call   80104680 <argint>
801054aa:	89 c2                	mov    %eax,%edx
801054ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b1:	85 d2                	test   %edx,%edx
801054b3:	78 58                	js     8010550d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801054b5:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801054bc:	e8 6f ee ff ff       	call   80104330 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801054c4:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  while(ticks - ticks0 < n){
801054ca:	85 d2                	test   %edx,%edx
801054cc:	75 22                	jne    801054f0 <sys_sleep+0x60>
801054ce:	eb 48                	jmp    80105518 <sys_sleep+0x88>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054d0:	c7 44 24 04 80 4f 11 	movl   $0x80114f80,0x4(%esp)
801054d7:	80 
801054d8:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
801054df:	e8 2c e8 ff ff       	call   80103d10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054e4:	a1 c0 57 11 80       	mov    0x801157c0,%eax
801054e9:	29 d8                	sub    %ebx,%eax
801054eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054ee:	73 28                	jae    80105518 <sys_sleep+0x88>
    if(myproc()->killed){
801054f0:	e8 bb e5 ff ff       	call   80103ab0 <myproc>
801054f5:	8b 40 24             	mov    0x24(%eax),%eax
801054f8:	85 c0                	test   %eax,%eax
801054fa:	74 d4                	je     801054d0 <sys_sleep+0x40>
      release(&tickslock);
801054fc:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105503:	e8 d8 ed ff ff       	call   801042e0 <release>
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010550d:	83 c4 24             	add    $0x24,%esp
80105510:	5b                   	pop    %ebx
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105518:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
8010551f:	e8 bc ed ff ff       	call   801042e0 <release>
  return 0;
}
80105524:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105527:	31 c0                	xor    %eax,%eax
  return 0;
}
80105529:	5b                   	pop    %ebx
8010552a:	5d                   	pop    %ebp
8010552b:	c3                   	ret    
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105536:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105539:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105544:	e8 37 f1 ff ff       	call   80104680 <argint>
80105549:	89 c2                	mov    %eax,%edx
8010554b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105550:	85 d2                	test   %edx,%edx
80105552:	78 0b                	js     8010555f <sys_kill+0x2f>
    return -1;
  return kill(pid);
80105554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105557:	89 04 24             	mov    %eax,(%esp)
8010555a:	e8 d1 e0 ff ff       	call   80103630 <kill>
}
8010555f:	c9                   	leave  
80105560:	c3                   	ret    
80105561:	eb 0d                	jmp    80105570 <sys_wait>
80105563:	90                   	nop
80105564:	90                   	nop
80105565:	90                   	nop
80105566:	90                   	nop
80105567:	90                   	nop
80105568:	90                   	nop
80105569:	90                   	nop
8010556a:	90                   	nop
8010556b:	90                   	nop
8010556c:	90                   	nop
8010556d:	90                   	nop
8010556e:	90                   	nop
8010556f:	90                   	nop

80105570 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
80105576:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
80105577:	e9 54 e8 ff ff       	jmp    80103dd0 <wait>
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  exit();
80105586:	e8 75 e9 ff ff       	call   80103f00 <exit>
  return 0;  // not reached
}
8010558b:	31 c0                	xor    %eax,%eax
8010558d:	c9                   	leave  
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
80105596:	c9                   	leave  
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105597:	e9 44 e5 ff ff       	jmp    80103ae0 <fork>

8010559c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010559c:	1e                   	push   %ds
  pushl %es
8010559d:	06                   	push   %es
  pushl %fs
8010559e:	0f a0                	push   %fs
  pushl %gs
801055a0:	0f a8                	push   %gs
  pushal
801055a2:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801055a3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801055a7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801055a9:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801055ab:	54                   	push   %esp
  call trap
801055ac:	e8 3f 00 00 00       	call   801055f0 <trap>
  addl $4, %esp
801055b1:	83 c4 04             	add    $0x4,%esp

801055b4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801055b4:	61                   	popa   
  popl %gs
801055b5:	0f a9                	pop    %gs
  popl %fs
801055b7:	0f a1                	pop    %fs
  popl %es
801055b9:	07                   	pop    %es
  popl %ds
801055ba:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801055bb:	83 c4 08             	add    $0x8,%esp
  iret
801055be:	cf                   	iret   
801055bf:	90                   	nop

801055c0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
801055c0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
801055c1:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
801055c6:	89 e5                	mov    %esp,%ebp
801055c8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801055cb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801055d1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055d5:	c1 e8 10             	shr    $0x10,%eax
801055d8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801055dc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055df:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    
801055e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801055f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 48             	sub    $0x48,%esp
801055f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801055f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801055ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
80105602:	8b 43 30             	mov    0x30(%ebx),%eax
80105605:	83 f8 40             	cmp    $0x40,%eax
80105608:	0f 84 b2 02 00 00    	je     801058c0 <trap+0x2d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010560e:	83 e8 0e             	sub    $0xe,%eax
80105611:	83 f8 31             	cmp    $0x31,%eax
80105614:	0f 86 fe 00 00 00    	jbe    80105718 <trap+0x128>
      }
      break;
    }
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010561a:	e8 91 e4 ff ff       	call   80103ab0 <myproc>
8010561f:	85 c0                	test   %eax,%eax
80105621:	0f 84 41 03 00 00    	je     80105968 <trap+0x378>
80105627:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010562b:	0f 84 37 03 00 00    	je     80105968 <trap+0x378>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105631:	0f 20 d2             	mov    %cr2,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105634:	8b 7b 38             	mov    0x38(%ebx),%edi
80105637:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010563a:	e8 f1 e9 ff ff       	call   80104030 <cpuid>
8010563f:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105642:	89 c6                	mov    %eax,%esi
80105644:	8b 43 30             	mov    0x30(%ebx),%eax
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105647:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010564a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010564d:	e8 5e e4 ff ff       	call   80103ab0 <myproc>
80105652:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105655:	e8 56 e4 ff ff       	call   80103ab0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010565a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010565d:	89 7c 24 18          	mov    %edi,0x18(%esp)
80105661:	89 74 24 14          	mov    %esi,0x14(%esp)
80105665:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80105669:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010566c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105673:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105677:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010567a:	83 c2 6c             	add    $0x6c,%edx
8010567d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105681:	8b 40 10             	mov    0x10(%eax),%eax
80105684:	c7 04 24 5c 77 10 80 	movl   $0x8010775c,(%esp)
8010568b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010568f:	e8 bc b1 ff ff       	call   80100850 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105694:	e8 17 e4 ff ff       	call   80103ab0 <myproc>
80105699:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056a0:	e8 0b e4 ff ff       	call   80103ab0 <myproc>
801056a5:	85 c0                	test   %eax,%eax
801056a7:	74 1c                	je     801056c5 <trap+0xd5>
801056a9:	e8 02 e4 ff ff       	call   80103ab0 <myproc>
801056ae:	8b 50 24             	mov    0x24(%eax),%edx
801056b1:	85 d2                	test   %edx,%edx
801056b3:	74 10                	je     801056c5 <trap+0xd5>
801056b5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056b9:	83 e0 03             	and    $0x3,%eax
801056bc:	83 f8 03             	cmp    $0x3,%eax
801056bf:	0f 84 3b 02 00 00    	je     80105900 <trap+0x310>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056c5:	e8 e6 e3 ff ff       	call   80103ab0 <myproc>
801056ca:	85 c0                	test   %eax,%eax
801056cc:	74 11                	je     801056df <trap+0xef>
801056ce:	66 90                	xchg   %ax,%ax
801056d0:	e8 db e3 ff ff       	call   80103ab0 <myproc>
801056d5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056d9:	0f 84 c9 01 00 00    	je     801058a8 <trap+0x2b8>
801056df:	90                   	nop
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056e0:	e8 cb e3 ff ff       	call   80103ab0 <myproc>
801056e5:	85 c0                	test   %eax,%eax
801056e7:	74 1c                	je     80105705 <trap+0x115>
801056e9:	e8 c2 e3 ff ff       	call   80103ab0 <myproc>
801056ee:	8b 40 24             	mov    0x24(%eax),%eax
801056f1:	85 c0                	test   %eax,%eax
801056f3:	74 10                	je     80105705 <trap+0x115>
801056f5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056f9:	83 e0 03             	and    $0x3,%eax
801056fc:	83 f8 03             	cmp    $0x3,%eax
801056ff:	0f 84 e4 01 00 00    	je     801058e9 <trap+0x2f9>
    exit();
}
80105705:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105708:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010570b:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010570e:	89 ec                	mov    %ebp,%esp
80105710:	5d                   	pop    %ebp
80105711:	c3                   	ret    
80105712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105718:	ff 24 85 cc 77 10 80 	jmp    *-0x7fef8834(,%eax,4)
8010571f:	90                   	nop
    }

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105720:	e8 1b ca ff ff       	call   80102140 <ideintr>
80105725:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105728:	e8 33 d0 ff ff       	call   80102760 <lapiceoi>
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
80105730:	e9 6b ff ff ff       	jmp    801056a0 <trap+0xb0>
80105735:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105738:	8b 7b 38             	mov    0x38(%ebx),%edi
8010573b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010573f:	e8 ec e8 ff ff       	call   80104030 <cpuid>
80105744:	c7 04 24 04 77 10 80 	movl   $0x80107704,(%esp)
8010574b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
8010574f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105753:	89 44 24 04          	mov    %eax,0x4(%esp)
80105757:	e8 f4 b0 ff ff       	call   80100850 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
8010575c:	e8 ff cf ff ff       	call   80102760 <lapiceoi>
    break;
80105761:	e9 3a ff ff ff       	jmp    801056a0 <trap+0xb0>
80105766:	66 90                	xchg   %ax,%ax
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105770:	e8 eb 02 00 00       	call   80105a60 <uartintr>
80105775:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105778:	e8 e3 cf ff ff       	call   80102760 <lapiceoi>
8010577d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
80105780:	e9 1b ff ff ff       	jmp    801056a0 <trap+0xb0>
80105785:	8d 76 00             	lea    0x0(%esi),%esi
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105790:	e8 4b ce ff ff       	call   801025e0 <kbdintr>
80105795:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105798:	e8 c3 cf ff ff       	call   80102760 <lapiceoi>
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
801057a0:	e9 fb fe ff ff       	jmp    801056a0 <trap+0xb0>
801057a5:	8d 76 00             	lea    0x0(%esi),%esi
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801057b0:	e8 7b e8 ff ff       	call   80104030 <cpuid>
801057b5:	85 c0                	test   %eax,%eax
801057b7:	0f 84 63 01 00 00    	je     80105920 <trap+0x330>
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    
    //xv6 cpu alarm
//    if(cpuid() == 1) {
      if(myproc() != 0 && (tf->cs & SEG_UCODE) == SEG_UCODE) {
801057c0:	e8 eb e2 ff ff       	call   80103ab0 <myproc>
801057c5:	85 c0                	test   %eax,%eax
801057c7:	0f 84 58 ff ff ff    	je     80105725 <trap+0x135>
801057cd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057d1:	83 e0 03             	and    $0x3,%eax
801057d4:	83 f8 03             	cmp    $0x3,%eax
801057d7:	0f 85 48 ff ff ff    	jne    80105725 <trap+0x135>
      //if(myproc() && (tf->cs & 3) == DPL_USER) {
        struct proc * pproc = myproc();
801057dd:	e8 ce e2 ff ff       	call   80103ab0 <myproc>
        pproc->ticks++;
801057e2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801057e8:	83 c2 01             	add    $0x1,%edx

        if(pproc->ticks >= pproc->alarmticks){
801057eb:	3b 50 7c             	cmp    0x7c(%eax),%edx
    //xv6 cpu alarm
//    if(cpuid() == 1) {
      if(myproc() != 0 && (tf->cs & SEG_UCODE) == SEG_UCODE) {
      //if(myproc() && (tf->cs & 3) == DPL_USER) {
        struct proc * pproc = myproc();
        pproc->ticks++;
801057ee:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

        if(pproc->ticks >= pproc->alarmticks){
801057f4:	0f 82 2b ff ff ff    	jb     80105725 <trap+0x135>
          //Place the original user-prog return address on
          // the user's stack, as if the user-prog issued a `call`
          // instruction.
          tf->esp -= 4;
801057fa:	8b 53 44             	mov    0x44(%ebx),%edx
801057fd:	8d 4a fc             	lea    -0x4(%edx),%ecx
80105800:	89 4b 44             	mov    %ecx,0x44(%ebx)
          //if( tf->esp > KERNBASE)
          //  return;

          *(uint*)(tf->esp) = tf->eip;
80105803:	8b 4b 38             	mov    0x38(%ebx),%ecx
80105806:	89 4a fc             	mov    %ecx,-0x4(%edx)
          // tf->esp -= 4;
          //*(uint*)(tf->esp) = tf->esp;

          tf->eip = (uint)pproc->alarmhandler;
80105809:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010580f:	89 53 38             	mov    %edx,0x38(%ebx)

          pproc->alarmticks = 0;
80105812:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
80105819:	e9 07 ff ff ff       	jmp    80105725 <trap+0x135>
8010581e:	66 90                	xchg   %ax,%ax
  //my code here
  case T_PGFLT:
    {
      void * mem;

      mem = kalloc(); //allocate memory here
80105820:	e8 2b cb ff ff       	call   80102350 <kalloc>
      if(mem == 0){
80105825:	85 c0                	test   %eax,%eax
  //my code here
  case T_PGFLT:
    {
      void * mem;

      mem = kalloc(); //allocate memory here
80105827:	89 c6                	mov    %eax,%esi
      if(mem == 0){
80105829:	0f 84 21 01 00 00    	je     80105950 <trap+0x360>
        cprintf("allocuvm out of memory\n");
      //deallocuvm(pgdir, newsz, oldsz);
        return;
      }
      memset(mem, 0, PGSIZE);
8010582f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105836:	00 
80105837:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010583e:	00 
8010583f:	89 04 24             	mov    %eax,(%esp)
80105842:	e8 59 eb ff ff       	call   801043a0 <memset>
80105847:	0f 20 d7             	mov    %cr2,%edi
      if(mappages(myproc()->pgdir, (void*) PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010584a:	e8 61 e2 ff ff       	call   80103ab0 <myproc>
8010584f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80105855:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
8010585b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80105862:	00 
80105863:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105867:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010586e:	00 
8010586f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105873:	8b 40 04             	mov    0x4(%eax),%eax
80105876:	89 04 24             	mov    %eax,(%esp)
80105879:	e8 22 0f 00 00       	call   801067a0 <mappages>
8010587e:	85 c0                	test   %eax,%eax
80105880:	0f 89 1a fe ff ff    	jns    801056a0 <trap+0xb0>
        cprintf("allocuvm\n");
80105886:	c7 04 24 b7 77 10 80 	movl   $0x801077b7,(%esp)
8010588d:	e8 be af ff ff       	call   80100850 <cprintf>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105892:	8b 5d f4             	mov    -0xc(%ebp),%ebx
      }
      memset(mem, 0, PGSIZE);
      if(mappages(myproc()->pgdir, (void*) PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
        cprintf("allocuvm\n");
        //deallocuvm(pgdir, newsz, oldsz);
        kfree(mem);
80105895:	89 75 08             	mov    %esi,0x8(%ebp)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105898:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010589b:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010589e:	89 ec                	mov    %ebp,%esp
801058a0:	5d                   	pop    %ebp
      }
      memset(mem, 0, PGSIZE);
      if(mappages(myproc()->pgdir, (void*) PGROUNDDOWN(rcr2()), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
        cprintf("allocuvm\n");
        //deallocuvm(pgdir, newsz, oldsz);
        kfree(mem);
801058a1:	e9 fa ca ff ff       	jmp    801023a0 <kfree>
801058a6:	66 90                	xchg   %ax,%ax
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
801058a8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801058ac:	0f 85 2d fe ff ff    	jne    801056df <trap+0xef>
    yield();
801058b2:	e8 09 e6 ff ff       	call   80103ec0 <yield>
801058b7:	e9 23 fe ff ff       	jmp    801056df <trap+0xef>
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801058c0:	e8 eb e1 ff ff       	call   80103ab0 <myproc>
801058c5:	8b 70 24             	mov    0x24(%eax),%esi
801058c8:	85 f6                	test   %esi,%esi
801058ca:	75 44                	jne    80105910 <trap+0x320>
      exit();
    myproc()->tf = tf;
801058cc:	e8 df e1 ff ff       	call   80103ab0 <myproc>
801058d1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801058d4:	e8 87 ee ff ff       	call   80104760 <syscall>
    if(myproc()->killed)
801058d9:	e8 d2 e1 ff ff       	call   80103ab0 <myproc>
801058de:	8b 48 24             	mov    0x24(%eax),%ecx
801058e1:	85 c9                	test   %ecx,%ecx
801058e3:	0f 84 1c fe ff ff    	je     80105705 <trap+0x115>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801058e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801058ec:	8b 75 f8             	mov    -0x8(%ebp),%esi
801058ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
801058f2:	89 ec                	mov    %ebp,%esp
801058f4:	5d                   	pop    %ebp
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
801058f5:	e9 06 e6 ff ff       	jmp    80103f00 <exit>
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
80105900:	e8 fb e5 ff ff       	call   80103f00 <exit>
80105905:	e9 bb fd ff ff       	jmp    801056c5 <trap+0xd5>
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105910:	e8 eb e5 ff ff       	call   80103f00 <exit>
80105915:	8d 76 00             	lea    0x0(%esi),%esi
80105918:	eb b2                	jmp    801058cc <trap+0x2dc>
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105920:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105927:	e8 04 ea ff ff       	call   80104330 <acquire>
      ticks++;
8010592c:	83 05 c0 57 11 80 01 	addl   $0x1,0x801157c0
      wakeup(&ticks);
80105933:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
8010593a:	e8 81 dd ff ff       	call   801036c0 <wakeup>
      release(&tickslock);
8010593f:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105946:	e8 95 e9 ff ff       	call   801042e0 <release>
8010594b:	e9 6d fe ff ff       	jmp    801057bd <trap+0x1cd>
    {
      void * mem;

      mem = kalloc(); //allocate memory here
      if(mem == 0){
        cprintf("allocuvm out of memory\n");
80105950:	c7 45 08 9f 77 10 80 	movl   $0x8010779f,0x8(%ebp)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105957:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010595a:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010595d:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105960:	89 ec                	mov    %ebp,%esp
80105962:	5d                   	pop    %ebp
    {
      void * mem;

      mem = kalloc(); //allocate memory here
      if(mem == 0){
        cprintf("allocuvm out of memory\n");
80105963:	e9 e8 ae ff ff       	jmp    80100850 <cprintf>
80105968:	0f 20 d7             	mov    %cr2,%edi
    }
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010596b:	8b 73 38             	mov    0x38(%ebx),%esi
8010596e:	e8 bd e6 ff ff       	call   80104030 <cpuid>
80105973:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105977:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010597b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010597f:	8b 43 30             	mov    0x30(%ebx),%eax
80105982:	c7 04 24 28 77 10 80 	movl   $0x80107728,(%esp)
80105989:	89 44 24 04          	mov    %eax,0x4(%esp)
8010598d:	e8 be ae ff ff       	call   80100850 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105992:	c7 04 24 c1 77 10 80 	movl   $0x801077c1,(%esp)
80105999:	e8 12 aa ff ff       	call   801003b0 <panic>
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <tvinit>:
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);
uint ticks;

void
tvinit(void)
{
801059a0:	55                   	push   %ebp
801059a1:	31 c0                	xor    %eax,%eax
801059a3:	89 e5                	mov    %esp,%ebp
801059a5:	ba c0 4f 11 80       	mov    $0x80114fc0,%edx
801059aa:	83 ec 18             	sub    $0x18,%esp
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801059b0:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
801059b7:	66 89 0c c5 c0 4f 11 	mov    %cx,-0x7feeb040(,%eax,8)
801059be:	80 
801059bf:	c1 e9 10             	shr    $0x10,%ecx
801059c2:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
801059c9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
801059ce:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
801059d3:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801059d8:	83 c0 01             	add    $0x1,%eax
801059db:	3d 00 01 00 00       	cmp    $0x100,%eax
801059e0:	75 ce                	jne    801059b0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059e2:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801059e7:	c7 44 24 04 c6 77 10 	movl   $0x801077c6,0x4(%esp)
801059ee:	80 
801059ef:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059f6:	66 c7 05 c2 51 11 80 	movw   $0x8,0x801151c2
801059fd:	08 00 
801059ff:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
80105a05:	c1 e8 10             	shr    $0x10,%eax
80105a08:	c6 05 c4 51 11 80 00 	movb   $0x0,0x801151c4
80105a0f:	c6 05 c5 51 11 80 ef 	movb   $0xef,0x801151c5
80105a16:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6

  initlock(&tickslock, "time");
80105a1c:	e8 5f e7 ff ff       	call   80104180 <initlock>
}
80105a21:	c9                   	leave  
80105a22:	c3                   	ret    
80105a23:	66 90                	xchg   %ax,%ax
80105a25:	66 90                	xchg   %ax,%ax
80105a27:	66 90                	xchg   %ax,%ax
80105a29:	66 90                	xchg   %ax,%ax
80105a2b:	66 90                	xchg   %ax,%ax
80105a2d:	66 90                	xchg   %ax,%ax
80105a2f:	90                   	nop

80105a30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a30:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a35:	55                   	push   %ebp
80105a36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	75 0c                	jne    80105a48 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
80105a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a41:	5d                   	pop    %ebp
80105a42:	c3                   	ret    
80105a43:	90                   	nop
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a48:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a4d:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a4e:	a8 01                	test   $0x1,%al
80105a50:	74 ea                	je     80105a3c <uartgetc+0xc>
80105a52:	b2 f8                	mov    $0xf8,%dl
80105a54:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a55:	0f b6 c0             	movzbl %al,%eax
}
80105a58:	5d                   	pop    %ebp
80105a59:	c3                   	ret    
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a60 <uartintr>:

void
uartintr(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105a66:	c7 04 24 30 5a 10 80 	movl   $0x80105a30,(%esp)
80105a6d:	e8 ae ab ff ff       	call   80100620 <consoleintr>
}
80105a72:	c9                   	leave  
80105a73:	c3                   	ret    
80105a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105a80 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	56                   	push   %esi
80105a84:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a89:	53                   	push   %ebx
  int i;

  if(!uart)
80105a8a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105a8c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
80105a8f:	8b 15 c4 a5 10 80    	mov    0x8010a5c4,%edx
80105a95:	85 d2                	test   %edx,%edx
80105a97:	75 1e                	jne    80105ab7 <uartputc+0x37>
80105a99:	eb 2c                	jmp    80105ac7 <uartputc+0x47>
80105a9b:	90                   	nop
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aa0:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
80105aa3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105aaa:	e8 d1 cc ff ff       	call   80102780 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aaf:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80105ab5:	74 07                	je     80105abe <uartputc+0x3e>
80105ab7:	89 f2                	mov    %esi,%edx
80105ab9:	ec                   	in     (%dx),%al
80105aba:	a8 20                	test   $0x20,%al
80105abc:	74 e2                	je     80105aa0 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105abe:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac6:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	5b                   	pop    %ebx
80105acb:	5e                   	pop    %esi
80105acc:	5d                   	pop    %ebp
80105acd:	c3                   	ret    
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	31 c9                	xor    %ecx,%ecx
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	89 c8                	mov    %ecx,%eax
80105ad7:	57                   	push   %edi
80105ad8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105add:	56                   	push   %esi
80105ade:	89 fa                	mov    %edi,%edx
80105ae0:	53                   	push   %ebx
80105ae1:	83 ec 1c             	sub    $0x1c,%esp
80105ae4:	ee                   	out    %al,(%dx)
80105ae5:	bb fb 03 00 00       	mov    $0x3fb,%ebx
80105aea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105aef:	89 da                	mov    %ebx,%edx
80105af1:	ee                   	out    %al,(%dx)
80105af2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105af7:	b2 f8                	mov    $0xf8,%dl
80105af9:	ee                   	out    %al,(%dx)
80105afa:	be f9 03 00 00       	mov    $0x3f9,%esi
80105aff:	89 c8                	mov    %ecx,%eax
80105b01:	89 f2                	mov    %esi,%edx
80105b03:	ee                   	out    %al,(%dx)
80105b04:	b8 03 00 00 00       	mov    $0x3,%eax
80105b09:	89 da                	mov    %ebx,%edx
80105b0b:	ee                   	out    %al,(%dx)
80105b0c:	b2 fc                	mov    $0xfc,%dl
80105b0e:	89 c8                	mov    %ecx,%eax
80105b10:	ee                   	out    %al,(%dx)
80105b11:	b8 01 00 00 00       	mov    $0x1,%eax
80105b16:	89 f2                	mov    %esi,%edx
80105b18:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b19:	b2 fd                	mov    $0xfd,%dl
80105b1b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b1c:	3c ff                	cmp    $0xff,%al
80105b1e:	74 45                	je     80105b65 <uartinit+0x95>
    return;
  uart = 1;
80105b20:	c7 05 c4 a5 10 80 01 	movl   $0x1,0x8010a5c4
80105b27:	00 00 00 
80105b2a:	89 fa                	mov    %edi,%edx
80105b2c:	ec                   	in     (%dx),%al
80105b2d:	b2 f8                	mov    $0xf8,%dl
80105b2f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b30:	bb 94 78 10 80       	mov    $0x80107894,%ebx
80105b35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b3c:	00 
80105b3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105b44:	e8 17 c7 ff ff       	call   80102260 <ioapicenable>
80105b49:	b8 78 00 00 00       	mov    $0x78,%eax
80105b4e:	66 90                	xchg   %ax,%ax

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
80105b50:	0f be c0             	movsbl %al,%eax
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b53:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105b56:	89 04 24             	mov    %eax,(%esp)
80105b59:	e8 22 ff ff ff       	call   80105a80 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b5e:	0f b6 03             	movzbl (%ebx),%eax
80105b61:	84 c0                	test   %al,%al
80105b63:	75 eb                	jne    80105b50 <uartinit+0x80>
    uartputc(*p);
}
80105b65:	83 c4 1c             	add    $0x1c,%esp
80105b68:	5b                   	pop    %ebx
80105b69:	5e                   	pop    %esi
80105b6a:	5f                   	pop    %edi
80105b6b:	5d                   	pop    %ebp
80105b6c:	c3                   	ret    

80105b6d <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $0
80105b6f:	6a 00                	push   $0x0
  jmp alltraps
80105b71:	e9 26 fa ff ff       	jmp    8010559c <alltraps>

80105b76 <vector1>:
.globl vector1
vector1:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $1
80105b78:	6a 01                	push   $0x1
  jmp alltraps
80105b7a:	e9 1d fa ff ff       	jmp    8010559c <alltraps>

80105b7f <vector2>:
.globl vector2
vector2:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $2
80105b81:	6a 02                	push   $0x2
  jmp alltraps
80105b83:	e9 14 fa ff ff       	jmp    8010559c <alltraps>

80105b88 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $3
80105b8a:	6a 03                	push   $0x3
  jmp alltraps
80105b8c:	e9 0b fa ff ff       	jmp    8010559c <alltraps>

80105b91 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $4
80105b93:	6a 04                	push   $0x4
  jmp alltraps
80105b95:	e9 02 fa ff ff       	jmp    8010559c <alltraps>

80105b9a <vector5>:
.globl vector5
vector5:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $5
80105b9c:	6a 05                	push   $0x5
  jmp alltraps
80105b9e:	e9 f9 f9 ff ff       	jmp    8010559c <alltraps>

80105ba3 <vector6>:
.globl vector6
vector6:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $6
80105ba5:	6a 06                	push   $0x6
  jmp alltraps
80105ba7:	e9 f0 f9 ff ff       	jmp    8010559c <alltraps>

80105bac <vector7>:
.globl vector7
vector7:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $7
80105bae:	6a 07                	push   $0x7
  jmp alltraps
80105bb0:	e9 e7 f9 ff ff       	jmp    8010559c <alltraps>

80105bb5 <vector8>:
.globl vector8
vector8:
  pushl $8
80105bb5:	6a 08                	push   $0x8
  jmp alltraps
80105bb7:	e9 e0 f9 ff ff       	jmp    8010559c <alltraps>

80105bbc <vector9>:
.globl vector9
vector9:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $9
80105bbe:	6a 09                	push   $0x9
  jmp alltraps
80105bc0:	e9 d7 f9 ff ff       	jmp    8010559c <alltraps>

80105bc5 <vector10>:
.globl vector10
vector10:
  pushl $10
80105bc5:	6a 0a                	push   $0xa
  jmp alltraps
80105bc7:	e9 d0 f9 ff ff       	jmp    8010559c <alltraps>

80105bcc <vector11>:
.globl vector11
vector11:
  pushl $11
80105bcc:	6a 0b                	push   $0xb
  jmp alltraps
80105bce:	e9 c9 f9 ff ff       	jmp    8010559c <alltraps>

80105bd3 <vector12>:
.globl vector12
vector12:
  pushl $12
80105bd3:	6a 0c                	push   $0xc
  jmp alltraps
80105bd5:	e9 c2 f9 ff ff       	jmp    8010559c <alltraps>

80105bda <vector13>:
.globl vector13
vector13:
  pushl $13
80105bda:	6a 0d                	push   $0xd
  jmp alltraps
80105bdc:	e9 bb f9 ff ff       	jmp    8010559c <alltraps>

80105be1 <vector14>:
.globl vector14
vector14:
  pushl $14
80105be1:	6a 0e                	push   $0xe
  jmp alltraps
80105be3:	e9 b4 f9 ff ff       	jmp    8010559c <alltraps>

80105be8 <vector15>:
.globl vector15
vector15:
  pushl $0
80105be8:	6a 00                	push   $0x0
  pushl $15
80105bea:	6a 0f                	push   $0xf
  jmp alltraps
80105bec:	e9 ab f9 ff ff       	jmp    8010559c <alltraps>

80105bf1 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bf1:	6a 00                	push   $0x0
  pushl $16
80105bf3:	6a 10                	push   $0x10
  jmp alltraps
80105bf5:	e9 a2 f9 ff ff       	jmp    8010559c <alltraps>

80105bfa <vector17>:
.globl vector17
vector17:
  pushl $17
80105bfa:	6a 11                	push   $0x11
  jmp alltraps
80105bfc:	e9 9b f9 ff ff       	jmp    8010559c <alltraps>

80105c01 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c01:	6a 00                	push   $0x0
  pushl $18
80105c03:	6a 12                	push   $0x12
  jmp alltraps
80105c05:	e9 92 f9 ff ff       	jmp    8010559c <alltraps>

80105c0a <vector19>:
.globl vector19
vector19:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $19
80105c0c:	6a 13                	push   $0x13
  jmp alltraps
80105c0e:	e9 89 f9 ff ff       	jmp    8010559c <alltraps>

80105c13 <vector20>:
.globl vector20
vector20:
  pushl $0
80105c13:	6a 00                	push   $0x0
  pushl $20
80105c15:	6a 14                	push   $0x14
  jmp alltraps
80105c17:	e9 80 f9 ff ff       	jmp    8010559c <alltraps>

80105c1c <vector21>:
.globl vector21
vector21:
  pushl $0
80105c1c:	6a 00                	push   $0x0
  pushl $21
80105c1e:	6a 15                	push   $0x15
  jmp alltraps
80105c20:	e9 77 f9 ff ff       	jmp    8010559c <alltraps>

80105c25 <vector22>:
.globl vector22
vector22:
  pushl $0
80105c25:	6a 00                	push   $0x0
  pushl $22
80105c27:	6a 16                	push   $0x16
  jmp alltraps
80105c29:	e9 6e f9 ff ff       	jmp    8010559c <alltraps>

80105c2e <vector23>:
.globl vector23
vector23:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $23
80105c30:	6a 17                	push   $0x17
  jmp alltraps
80105c32:	e9 65 f9 ff ff       	jmp    8010559c <alltraps>

80105c37 <vector24>:
.globl vector24
vector24:
  pushl $0
80105c37:	6a 00                	push   $0x0
  pushl $24
80105c39:	6a 18                	push   $0x18
  jmp alltraps
80105c3b:	e9 5c f9 ff ff       	jmp    8010559c <alltraps>

80105c40 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $25
80105c42:	6a 19                	push   $0x19
  jmp alltraps
80105c44:	e9 53 f9 ff ff       	jmp    8010559c <alltraps>

80105c49 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $26
80105c4b:	6a 1a                	push   $0x1a
  jmp alltraps
80105c4d:	e9 4a f9 ff ff       	jmp    8010559c <alltraps>

80105c52 <vector27>:
.globl vector27
vector27:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $27
80105c54:	6a 1b                	push   $0x1b
  jmp alltraps
80105c56:	e9 41 f9 ff ff       	jmp    8010559c <alltraps>

80105c5b <vector28>:
.globl vector28
vector28:
  pushl $0
80105c5b:	6a 00                	push   $0x0
  pushl $28
80105c5d:	6a 1c                	push   $0x1c
  jmp alltraps
80105c5f:	e9 38 f9 ff ff       	jmp    8010559c <alltraps>

80105c64 <vector29>:
.globl vector29
vector29:
  pushl $0
80105c64:	6a 00                	push   $0x0
  pushl $29
80105c66:	6a 1d                	push   $0x1d
  jmp alltraps
80105c68:	e9 2f f9 ff ff       	jmp    8010559c <alltraps>

80105c6d <vector30>:
.globl vector30
vector30:
  pushl $0
80105c6d:	6a 00                	push   $0x0
  pushl $30
80105c6f:	6a 1e                	push   $0x1e
  jmp alltraps
80105c71:	e9 26 f9 ff ff       	jmp    8010559c <alltraps>

80105c76 <vector31>:
.globl vector31
vector31:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $31
80105c78:	6a 1f                	push   $0x1f
  jmp alltraps
80105c7a:	e9 1d f9 ff ff       	jmp    8010559c <alltraps>

80105c7f <vector32>:
.globl vector32
vector32:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $32
80105c81:	6a 20                	push   $0x20
  jmp alltraps
80105c83:	e9 14 f9 ff ff       	jmp    8010559c <alltraps>

80105c88 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $33
80105c8a:	6a 21                	push   $0x21
  jmp alltraps
80105c8c:	e9 0b f9 ff ff       	jmp    8010559c <alltraps>

80105c91 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c91:	6a 00                	push   $0x0
  pushl $34
80105c93:	6a 22                	push   $0x22
  jmp alltraps
80105c95:	e9 02 f9 ff ff       	jmp    8010559c <alltraps>

80105c9a <vector35>:
.globl vector35
vector35:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $35
80105c9c:	6a 23                	push   $0x23
  jmp alltraps
80105c9e:	e9 f9 f8 ff ff       	jmp    8010559c <alltraps>

80105ca3 <vector36>:
.globl vector36
vector36:
  pushl $0
80105ca3:	6a 00                	push   $0x0
  pushl $36
80105ca5:	6a 24                	push   $0x24
  jmp alltraps
80105ca7:	e9 f0 f8 ff ff       	jmp    8010559c <alltraps>

80105cac <vector37>:
.globl vector37
vector37:
  pushl $0
80105cac:	6a 00                	push   $0x0
  pushl $37
80105cae:	6a 25                	push   $0x25
  jmp alltraps
80105cb0:	e9 e7 f8 ff ff       	jmp    8010559c <alltraps>

80105cb5 <vector38>:
.globl vector38
vector38:
  pushl $0
80105cb5:	6a 00                	push   $0x0
  pushl $38
80105cb7:	6a 26                	push   $0x26
  jmp alltraps
80105cb9:	e9 de f8 ff ff       	jmp    8010559c <alltraps>

80105cbe <vector39>:
.globl vector39
vector39:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $39
80105cc0:	6a 27                	push   $0x27
  jmp alltraps
80105cc2:	e9 d5 f8 ff ff       	jmp    8010559c <alltraps>

80105cc7 <vector40>:
.globl vector40
vector40:
  pushl $0
80105cc7:	6a 00                	push   $0x0
  pushl $40
80105cc9:	6a 28                	push   $0x28
  jmp alltraps
80105ccb:	e9 cc f8 ff ff       	jmp    8010559c <alltraps>

80105cd0 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cd0:	6a 00                	push   $0x0
  pushl $41
80105cd2:	6a 29                	push   $0x29
  jmp alltraps
80105cd4:	e9 c3 f8 ff ff       	jmp    8010559c <alltraps>

80105cd9 <vector42>:
.globl vector42
vector42:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $42
80105cdb:	6a 2a                	push   $0x2a
  jmp alltraps
80105cdd:	e9 ba f8 ff ff       	jmp    8010559c <alltraps>

80105ce2 <vector43>:
.globl vector43
vector43:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $43
80105ce4:	6a 2b                	push   $0x2b
  jmp alltraps
80105ce6:	e9 b1 f8 ff ff       	jmp    8010559c <alltraps>

80105ceb <vector44>:
.globl vector44
vector44:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $44
80105ced:	6a 2c                	push   $0x2c
  jmp alltraps
80105cef:	e9 a8 f8 ff ff       	jmp    8010559c <alltraps>

80105cf4 <vector45>:
.globl vector45
vector45:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $45
80105cf6:	6a 2d                	push   $0x2d
  jmp alltraps
80105cf8:	e9 9f f8 ff ff       	jmp    8010559c <alltraps>

80105cfd <vector46>:
.globl vector46
vector46:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $46
80105cff:	6a 2e                	push   $0x2e
  jmp alltraps
80105d01:	e9 96 f8 ff ff       	jmp    8010559c <alltraps>

80105d06 <vector47>:
.globl vector47
vector47:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $47
80105d08:	6a 2f                	push   $0x2f
  jmp alltraps
80105d0a:	e9 8d f8 ff ff       	jmp    8010559c <alltraps>

80105d0f <vector48>:
.globl vector48
vector48:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $48
80105d11:	6a 30                	push   $0x30
  jmp alltraps
80105d13:	e9 84 f8 ff ff       	jmp    8010559c <alltraps>

80105d18 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $49
80105d1a:	6a 31                	push   $0x31
  jmp alltraps
80105d1c:	e9 7b f8 ff ff       	jmp    8010559c <alltraps>

80105d21 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d21:	6a 00                	push   $0x0
  pushl $50
80105d23:	6a 32                	push   $0x32
  jmp alltraps
80105d25:	e9 72 f8 ff ff       	jmp    8010559c <alltraps>

80105d2a <vector51>:
.globl vector51
vector51:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $51
80105d2c:	6a 33                	push   $0x33
  jmp alltraps
80105d2e:	e9 69 f8 ff ff       	jmp    8010559c <alltraps>

80105d33 <vector52>:
.globl vector52
vector52:
  pushl $0
80105d33:	6a 00                	push   $0x0
  pushl $52
80105d35:	6a 34                	push   $0x34
  jmp alltraps
80105d37:	e9 60 f8 ff ff       	jmp    8010559c <alltraps>

80105d3c <vector53>:
.globl vector53
vector53:
  pushl $0
80105d3c:	6a 00                	push   $0x0
  pushl $53
80105d3e:	6a 35                	push   $0x35
  jmp alltraps
80105d40:	e9 57 f8 ff ff       	jmp    8010559c <alltraps>

80105d45 <vector54>:
.globl vector54
vector54:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $54
80105d47:	6a 36                	push   $0x36
  jmp alltraps
80105d49:	e9 4e f8 ff ff       	jmp    8010559c <alltraps>

80105d4e <vector55>:
.globl vector55
vector55:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $55
80105d50:	6a 37                	push   $0x37
  jmp alltraps
80105d52:	e9 45 f8 ff ff       	jmp    8010559c <alltraps>

80105d57 <vector56>:
.globl vector56
vector56:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $56
80105d59:	6a 38                	push   $0x38
  jmp alltraps
80105d5b:	e9 3c f8 ff ff       	jmp    8010559c <alltraps>

80105d60 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $57
80105d62:	6a 39                	push   $0x39
  jmp alltraps
80105d64:	e9 33 f8 ff ff       	jmp    8010559c <alltraps>

80105d69 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $58
80105d6b:	6a 3a                	push   $0x3a
  jmp alltraps
80105d6d:	e9 2a f8 ff ff       	jmp    8010559c <alltraps>

80105d72 <vector59>:
.globl vector59
vector59:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $59
80105d74:	6a 3b                	push   $0x3b
  jmp alltraps
80105d76:	e9 21 f8 ff ff       	jmp    8010559c <alltraps>

80105d7b <vector60>:
.globl vector60
vector60:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $60
80105d7d:	6a 3c                	push   $0x3c
  jmp alltraps
80105d7f:	e9 18 f8 ff ff       	jmp    8010559c <alltraps>

80105d84 <vector61>:
.globl vector61
vector61:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $61
80105d86:	6a 3d                	push   $0x3d
  jmp alltraps
80105d88:	e9 0f f8 ff ff       	jmp    8010559c <alltraps>

80105d8d <vector62>:
.globl vector62
vector62:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $62
80105d8f:	6a 3e                	push   $0x3e
  jmp alltraps
80105d91:	e9 06 f8 ff ff       	jmp    8010559c <alltraps>

80105d96 <vector63>:
.globl vector63
vector63:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $63
80105d98:	6a 3f                	push   $0x3f
  jmp alltraps
80105d9a:	e9 fd f7 ff ff       	jmp    8010559c <alltraps>

80105d9f <vector64>:
.globl vector64
vector64:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $64
80105da1:	6a 40                	push   $0x40
  jmp alltraps
80105da3:	e9 f4 f7 ff ff       	jmp    8010559c <alltraps>

80105da8 <vector65>:
.globl vector65
vector65:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $65
80105daa:	6a 41                	push   $0x41
  jmp alltraps
80105dac:	e9 eb f7 ff ff       	jmp    8010559c <alltraps>

80105db1 <vector66>:
.globl vector66
vector66:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $66
80105db3:	6a 42                	push   $0x42
  jmp alltraps
80105db5:	e9 e2 f7 ff ff       	jmp    8010559c <alltraps>

80105dba <vector67>:
.globl vector67
vector67:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $67
80105dbc:	6a 43                	push   $0x43
  jmp alltraps
80105dbe:	e9 d9 f7 ff ff       	jmp    8010559c <alltraps>

80105dc3 <vector68>:
.globl vector68
vector68:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $68
80105dc5:	6a 44                	push   $0x44
  jmp alltraps
80105dc7:	e9 d0 f7 ff ff       	jmp    8010559c <alltraps>

80105dcc <vector69>:
.globl vector69
vector69:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $69
80105dce:	6a 45                	push   $0x45
  jmp alltraps
80105dd0:	e9 c7 f7 ff ff       	jmp    8010559c <alltraps>

80105dd5 <vector70>:
.globl vector70
vector70:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $70
80105dd7:	6a 46                	push   $0x46
  jmp alltraps
80105dd9:	e9 be f7 ff ff       	jmp    8010559c <alltraps>

80105dde <vector71>:
.globl vector71
vector71:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $71
80105de0:	6a 47                	push   $0x47
  jmp alltraps
80105de2:	e9 b5 f7 ff ff       	jmp    8010559c <alltraps>

80105de7 <vector72>:
.globl vector72
vector72:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $72
80105de9:	6a 48                	push   $0x48
  jmp alltraps
80105deb:	e9 ac f7 ff ff       	jmp    8010559c <alltraps>

80105df0 <vector73>:
.globl vector73
vector73:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $73
80105df2:	6a 49                	push   $0x49
  jmp alltraps
80105df4:	e9 a3 f7 ff ff       	jmp    8010559c <alltraps>

80105df9 <vector74>:
.globl vector74
vector74:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $74
80105dfb:	6a 4a                	push   $0x4a
  jmp alltraps
80105dfd:	e9 9a f7 ff ff       	jmp    8010559c <alltraps>

80105e02 <vector75>:
.globl vector75
vector75:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $75
80105e04:	6a 4b                	push   $0x4b
  jmp alltraps
80105e06:	e9 91 f7 ff ff       	jmp    8010559c <alltraps>

80105e0b <vector76>:
.globl vector76
vector76:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $76
80105e0d:	6a 4c                	push   $0x4c
  jmp alltraps
80105e0f:	e9 88 f7 ff ff       	jmp    8010559c <alltraps>

80105e14 <vector77>:
.globl vector77
vector77:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $77
80105e16:	6a 4d                	push   $0x4d
  jmp alltraps
80105e18:	e9 7f f7 ff ff       	jmp    8010559c <alltraps>

80105e1d <vector78>:
.globl vector78
vector78:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $78
80105e1f:	6a 4e                	push   $0x4e
  jmp alltraps
80105e21:	e9 76 f7 ff ff       	jmp    8010559c <alltraps>

80105e26 <vector79>:
.globl vector79
vector79:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $79
80105e28:	6a 4f                	push   $0x4f
  jmp alltraps
80105e2a:	e9 6d f7 ff ff       	jmp    8010559c <alltraps>

80105e2f <vector80>:
.globl vector80
vector80:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $80
80105e31:	6a 50                	push   $0x50
  jmp alltraps
80105e33:	e9 64 f7 ff ff       	jmp    8010559c <alltraps>

80105e38 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $81
80105e3a:	6a 51                	push   $0x51
  jmp alltraps
80105e3c:	e9 5b f7 ff ff       	jmp    8010559c <alltraps>

80105e41 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $82
80105e43:	6a 52                	push   $0x52
  jmp alltraps
80105e45:	e9 52 f7 ff ff       	jmp    8010559c <alltraps>

80105e4a <vector83>:
.globl vector83
vector83:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $83
80105e4c:	6a 53                	push   $0x53
  jmp alltraps
80105e4e:	e9 49 f7 ff ff       	jmp    8010559c <alltraps>

80105e53 <vector84>:
.globl vector84
vector84:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $84
80105e55:	6a 54                	push   $0x54
  jmp alltraps
80105e57:	e9 40 f7 ff ff       	jmp    8010559c <alltraps>

80105e5c <vector85>:
.globl vector85
vector85:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $85
80105e5e:	6a 55                	push   $0x55
  jmp alltraps
80105e60:	e9 37 f7 ff ff       	jmp    8010559c <alltraps>

80105e65 <vector86>:
.globl vector86
vector86:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $86
80105e67:	6a 56                	push   $0x56
  jmp alltraps
80105e69:	e9 2e f7 ff ff       	jmp    8010559c <alltraps>

80105e6e <vector87>:
.globl vector87
vector87:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $87
80105e70:	6a 57                	push   $0x57
  jmp alltraps
80105e72:	e9 25 f7 ff ff       	jmp    8010559c <alltraps>

80105e77 <vector88>:
.globl vector88
vector88:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $88
80105e79:	6a 58                	push   $0x58
  jmp alltraps
80105e7b:	e9 1c f7 ff ff       	jmp    8010559c <alltraps>

80105e80 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $89
80105e82:	6a 59                	push   $0x59
  jmp alltraps
80105e84:	e9 13 f7 ff ff       	jmp    8010559c <alltraps>

80105e89 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $90
80105e8b:	6a 5a                	push   $0x5a
  jmp alltraps
80105e8d:	e9 0a f7 ff ff       	jmp    8010559c <alltraps>

80105e92 <vector91>:
.globl vector91
vector91:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $91
80105e94:	6a 5b                	push   $0x5b
  jmp alltraps
80105e96:	e9 01 f7 ff ff       	jmp    8010559c <alltraps>

80105e9b <vector92>:
.globl vector92
vector92:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $92
80105e9d:	6a 5c                	push   $0x5c
  jmp alltraps
80105e9f:	e9 f8 f6 ff ff       	jmp    8010559c <alltraps>

80105ea4 <vector93>:
.globl vector93
vector93:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $93
80105ea6:	6a 5d                	push   $0x5d
  jmp alltraps
80105ea8:	e9 ef f6 ff ff       	jmp    8010559c <alltraps>

80105ead <vector94>:
.globl vector94
vector94:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $94
80105eaf:	6a 5e                	push   $0x5e
  jmp alltraps
80105eb1:	e9 e6 f6 ff ff       	jmp    8010559c <alltraps>

80105eb6 <vector95>:
.globl vector95
vector95:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $95
80105eb8:	6a 5f                	push   $0x5f
  jmp alltraps
80105eba:	e9 dd f6 ff ff       	jmp    8010559c <alltraps>

80105ebf <vector96>:
.globl vector96
vector96:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $96
80105ec1:	6a 60                	push   $0x60
  jmp alltraps
80105ec3:	e9 d4 f6 ff ff       	jmp    8010559c <alltraps>

80105ec8 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $97
80105eca:	6a 61                	push   $0x61
  jmp alltraps
80105ecc:	e9 cb f6 ff ff       	jmp    8010559c <alltraps>

80105ed1 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $98
80105ed3:	6a 62                	push   $0x62
  jmp alltraps
80105ed5:	e9 c2 f6 ff ff       	jmp    8010559c <alltraps>

80105eda <vector99>:
.globl vector99
vector99:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $99
80105edc:	6a 63                	push   $0x63
  jmp alltraps
80105ede:	e9 b9 f6 ff ff       	jmp    8010559c <alltraps>

80105ee3 <vector100>:
.globl vector100
vector100:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $100
80105ee5:	6a 64                	push   $0x64
  jmp alltraps
80105ee7:	e9 b0 f6 ff ff       	jmp    8010559c <alltraps>

80105eec <vector101>:
.globl vector101
vector101:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $101
80105eee:	6a 65                	push   $0x65
  jmp alltraps
80105ef0:	e9 a7 f6 ff ff       	jmp    8010559c <alltraps>

80105ef5 <vector102>:
.globl vector102
vector102:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $102
80105ef7:	6a 66                	push   $0x66
  jmp alltraps
80105ef9:	e9 9e f6 ff ff       	jmp    8010559c <alltraps>

80105efe <vector103>:
.globl vector103
vector103:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $103
80105f00:	6a 67                	push   $0x67
  jmp alltraps
80105f02:	e9 95 f6 ff ff       	jmp    8010559c <alltraps>

80105f07 <vector104>:
.globl vector104
vector104:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $104
80105f09:	6a 68                	push   $0x68
  jmp alltraps
80105f0b:	e9 8c f6 ff ff       	jmp    8010559c <alltraps>

80105f10 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $105
80105f12:	6a 69                	push   $0x69
  jmp alltraps
80105f14:	e9 83 f6 ff ff       	jmp    8010559c <alltraps>

80105f19 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $106
80105f1b:	6a 6a                	push   $0x6a
  jmp alltraps
80105f1d:	e9 7a f6 ff ff       	jmp    8010559c <alltraps>

80105f22 <vector107>:
.globl vector107
vector107:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $107
80105f24:	6a 6b                	push   $0x6b
  jmp alltraps
80105f26:	e9 71 f6 ff ff       	jmp    8010559c <alltraps>

80105f2b <vector108>:
.globl vector108
vector108:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $108
80105f2d:	6a 6c                	push   $0x6c
  jmp alltraps
80105f2f:	e9 68 f6 ff ff       	jmp    8010559c <alltraps>

80105f34 <vector109>:
.globl vector109
vector109:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $109
80105f36:	6a 6d                	push   $0x6d
  jmp alltraps
80105f38:	e9 5f f6 ff ff       	jmp    8010559c <alltraps>

80105f3d <vector110>:
.globl vector110
vector110:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $110
80105f3f:	6a 6e                	push   $0x6e
  jmp alltraps
80105f41:	e9 56 f6 ff ff       	jmp    8010559c <alltraps>

80105f46 <vector111>:
.globl vector111
vector111:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $111
80105f48:	6a 6f                	push   $0x6f
  jmp alltraps
80105f4a:	e9 4d f6 ff ff       	jmp    8010559c <alltraps>

80105f4f <vector112>:
.globl vector112
vector112:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $112
80105f51:	6a 70                	push   $0x70
  jmp alltraps
80105f53:	e9 44 f6 ff ff       	jmp    8010559c <alltraps>

80105f58 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $113
80105f5a:	6a 71                	push   $0x71
  jmp alltraps
80105f5c:	e9 3b f6 ff ff       	jmp    8010559c <alltraps>

80105f61 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $114
80105f63:	6a 72                	push   $0x72
  jmp alltraps
80105f65:	e9 32 f6 ff ff       	jmp    8010559c <alltraps>

80105f6a <vector115>:
.globl vector115
vector115:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $115
80105f6c:	6a 73                	push   $0x73
  jmp alltraps
80105f6e:	e9 29 f6 ff ff       	jmp    8010559c <alltraps>

80105f73 <vector116>:
.globl vector116
vector116:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $116
80105f75:	6a 74                	push   $0x74
  jmp alltraps
80105f77:	e9 20 f6 ff ff       	jmp    8010559c <alltraps>

80105f7c <vector117>:
.globl vector117
vector117:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $117
80105f7e:	6a 75                	push   $0x75
  jmp alltraps
80105f80:	e9 17 f6 ff ff       	jmp    8010559c <alltraps>

80105f85 <vector118>:
.globl vector118
vector118:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $118
80105f87:	6a 76                	push   $0x76
  jmp alltraps
80105f89:	e9 0e f6 ff ff       	jmp    8010559c <alltraps>

80105f8e <vector119>:
.globl vector119
vector119:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $119
80105f90:	6a 77                	push   $0x77
  jmp alltraps
80105f92:	e9 05 f6 ff ff       	jmp    8010559c <alltraps>

80105f97 <vector120>:
.globl vector120
vector120:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $120
80105f99:	6a 78                	push   $0x78
  jmp alltraps
80105f9b:	e9 fc f5 ff ff       	jmp    8010559c <alltraps>

80105fa0 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $121
80105fa2:	6a 79                	push   $0x79
  jmp alltraps
80105fa4:	e9 f3 f5 ff ff       	jmp    8010559c <alltraps>

80105fa9 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $122
80105fab:	6a 7a                	push   $0x7a
  jmp alltraps
80105fad:	e9 ea f5 ff ff       	jmp    8010559c <alltraps>

80105fb2 <vector123>:
.globl vector123
vector123:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $123
80105fb4:	6a 7b                	push   $0x7b
  jmp alltraps
80105fb6:	e9 e1 f5 ff ff       	jmp    8010559c <alltraps>

80105fbb <vector124>:
.globl vector124
vector124:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $124
80105fbd:	6a 7c                	push   $0x7c
  jmp alltraps
80105fbf:	e9 d8 f5 ff ff       	jmp    8010559c <alltraps>

80105fc4 <vector125>:
.globl vector125
vector125:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $125
80105fc6:	6a 7d                	push   $0x7d
  jmp alltraps
80105fc8:	e9 cf f5 ff ff       	jmp    8010559c <alltraps>

80105fcd <vector126>:
.globl vector126
vector126:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $126
80105fcf:	6a 7e                	push   $0x7e
  jmp alltraps
80105fd1:	e9 c6 f5 ff ff       	jmp    8010559c <alltraps>

80105fd6 <vector127>:
.globl vector127
vector127:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $127
80105fd8:	6a 7f                	push   $0x7f
  jmp alltraps
80105fda:	e9 bd f5 ff ff       	jmp    8010559c <alltraps>

80105fdf <vector128>:
.globl vector128
vector128:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $128
80105fe1:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fe6:	e9 b1 f5 ff ff       	jmp    8010559c <alltraps>

80105feb <vector129>:
.globl vector129
vector129:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $129
80105fed:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ff2:	e9 a5 f5 ff ff       	jmp    8010559c <alltraps>

80105ff7 <vector130>:
.globl vector130
vector130:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $130
80105ff9:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ffe:	e9 99 f5 ff ff       	jmp    8010559c <alltraps>

80106003 <vector131>:
.globl vector131
vector131:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $131
80106005:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010600a:	e9 8d f5 ff ff       	jmp    8010559c <alltraps>

8010600f <vector132>:
.globl vector132
vector132:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $132
80106011:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106016:	e9 81 f5 ff ff       	jmp    8010559c <alltraps>

8010601b <vector133>:
.globl vector133
vector133:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $133
8010601d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106022:	e9 75 f5 ff ff       	jmp    8010559c <alltraps>

80106027 <vector134>:
.globl vector134
vector134:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $134
80106029:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010602e:	e9 69 f5 ff ff       	jmp    8010559c <alltraps>

80106033 <vector135>:
.globl vector135
vector135:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $135
80106035:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010603a:	e9 5d f5 ff ff       	jmp    8010559c <alltraps>

8010603f <vector136>:
.globl vector136
vector136:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $136
80106041:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106046:	e9 51 f5 ff ff       	jmp    8010559c <alltraps>

8010604b <vector137>:
.globl vector137
vector137:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $137
8010604d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106052:	e9 45 f5 ff ff       	jmp    8010559c <alltraps>

80106057 <vector138>:
.globl vector138
vector138:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $138
80106059:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010605e:	e9 39 f5 ff ff       	jmp    8010559c <alltraps>

80106063 <vector139>:
.globl vector139
vector139:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $139
80106065:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010606a:	e9 2d f5 ff ff       	jmp    8010559c <alltraps>

8010606f <vector140>:
.globl vector140
vector140:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $140
80106071:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106076:	e9 21 f5 ff ff       	jmp    8010559c <alltraps>

8010607b <vector141>:
.globl vector141
vector141:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $141
8010607d:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106082:	e9 15 f5 ff ff       	jmp    8010559c <alltraps>

80106087 <vector142>:
.globl vector142
vector142:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $142
80106089:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010608e:	e9 09 f5 ff ff       	jmp    8010559c <alltraps>

80106093 <vector143>:
.globl vector143
vector143:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $143
80106095:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010609a:	e9 fd f4 ff ff       	jmp    8010559c <alltraps>

8010609f <vector144>:
.globl vector144
vector144:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $144
801060a1:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060a6:	e9 f1 f4 ff ff       	jmp    8010559c <alltraps>

801060ab <vector145>:
.globl vector145
vector145:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $145
801060ad:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060b2:	e9 e5 f4 ff ff       	jmp    8010559c <alltraps>

801060b7 <vector146>:
.globl vector146
vector146:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $146
801060b9:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060be:	e9 d9 f4 ff ff       	jmp    8010559c <alltraps>

801060c3 <vector147>:
.globl vector147
vector147:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $147
801060c5:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060ca:	e9 cd f4 ff ff       	jmp    8010559c <alltraps>

801060cf <vector148>:
.globl vector148
vector148:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $148
801060d1:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060d6:	e9 c1 f4 ff ff       	jmp    8010559c <alltraps>

801060db <vector149>:
.globl vector149
vector149:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $149
801060dd:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060e2:	e9 b5 f4 ff ff       	jmp    8010559c <alltraps>

801060e7 <vector150>:
.globl vector150
vector150:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $150
801060e9:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060ee:	e9 a9 f4 ff ff       	jmp    8010559c <alltraps>

801060f3 <vector151>:
.globl vector151
vector151:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $151
801060f5:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801060fa:	e9 9d f4 ff ff       	jmp    8010559c <alltraps>

801060ff <vector152>:
.globl vector152
vector152:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $152
80106101:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106106:	e9 91 f4 ff ff       	jmp    8010559c <alltraps>

8010610b <vector153>:
.globl vector153
vector153:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $153
8010610d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106112:	e9 85 f4 ff ff       	jmp    8010559c <alltraps>

80106117 <vector154>:
.globl vector154
vector154:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $154
80106119:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010611e:	e9 79 f4 ff ff       	jmp    8010559c <alltraps>

80106123 <vector155>:
.globl vector155
vector155:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $155
80106125:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010612a:	e9 6d f4 ff ff       	jmp    8010559c <alltraps>

8010612f <vector156>:
.globl vector156
vector156:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $156
80106131:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106136:	e9 61 f4 ff ff       	jmp    8010559c <alltraps>

8010613b <vector157>:
.globl vector157
vector157:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $157
8010613d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106142:	e9 55 f4 ff ff       	jmp    8010559c <alltraps>

80106147 <vector158>:
.globl vector158
vector158:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $158
80106149:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010614e:	e9 49 f4 ff ff       	jmp    8010559c <alltraps>

80106153 <vector159>:
.globl vector159
vector159:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $159
80106155:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010615a:	e9 3d f4 ff ff       	jmp    8010559c <alltraps>

8010615f <vector160>:
.globl vector160
vector160:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $160
80106161:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106166:	e9 31 f4 ff ff       	jmp    8010559c <alltraps>

8010616b <vector161>:
.globl vector161
vector161:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $161
8010616d:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106172:	e9 25 f4 ff ff       	jmp    8010559c <alltraps>

80106177 <vector162>:
.globl vector162
vector162:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $162
80106179:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010617e:	e9 19 f4 ff ff       	jmp    8010559c <alltraps>

80106183 <vector163>:
.globl vector163
vector163:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $163
80106185:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010618a:	e9 0d f4 ff ff       	jmp    8010559c <alltraps>

8010618f <vector164>:
.globl vector164
vector164:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $164
80106191:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106196:	e9 01 f4 ff ff       	jmp    8010559c <alltraps>

8010619b <vector165>:
.globl vector165
vector165:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $165
8010619d:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061a2:	e9 f5 f3 ff ff       	jmp    8010559c <alltraps>

801061a7 <vector166>:
.globl vector166
vector166:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $166
801061a9:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061ae:	e9 e9 f3 ff ff       	jmp    8010559c <alltraps>

801061b3 <vector167>:
.globl vector167
vector167:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $167
801061b5:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061ba:	e9 dd f3 ff ff       	jmp    8010559c <alltraps>

801061bf <vector168>:
.globl vector168
vector168:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $168
801061c1:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061c6:	e9 d1 f3 ff ff       	jmp    8010559c <alltraps>

801061cb <vector169>:
.globl vector169
vector169:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $169
801061cd:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061d2:	e9 c5 f3 ff ff       	jmp    8010559c <alltraps>

801061d7 <vector170>:
.globl vector170
vector170:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $170
801061d9:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061de:	e9 b9 f3 ff ff       	jmp    8010559c <alltraps>

801061e3 <vector171>:
.globl vector171
vector171:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $171
801061e5:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061ea:	e9 ad f3 ff ff       	jmp    8010559c <alltraps>

801061ef <vector172>:
.globl vector172
vector172:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $172
801061f1:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061f6:	e9 a1 f3 ff ff       	jmp    8010559c <alltraps>

801061fb <vector173>:
.globl vector173
vector173:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $173
801061fd:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106202:	e9 95 f3 ff ff       	jmp    8010559c <alltraps>

80106207 <vector174>:
.globl vector174
vector174:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $174
80106209:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010620e:	e9 89 f3 ff ff       	jmp    8010559c <alltraps>

80106213 <vector175>:
.globl vector175
vector175:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $175
80106215:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010621a:	e9 7d f3 ff ff       	jmp    8010559c <alltraps>

8010621f <vector176>:
.globl vector176
vector176:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $176
80106221:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106226:	e9 71 f3 ff ff       	jmp    8010559c <alltraps>

8010622b <vector177>:
.globl vector177
vector177:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $177
8010622d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106232:	e9 65 f3 ff ff       	jmp    8010559c <alltraps>

80106237 <vector178>:
.globl vector178
vector178:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $178
80106239:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010623e:	e9 59 f3 ff ff       	jmp    8010559c <alltraps>

80106243 <vector179>:
.globl vector179
vector179:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $179
80106245:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010624a:	e9 4d f3 ff ff       	jmp    8010559c <alltraps>

8010624f <vector180>:
.globl vector180
vector180:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $180
80106251:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106256:	e9 41 f3 ff ff       	jmp    8010559c <alltraps>

8010625b <vector181>:
.globl vector181
vector181:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $181
8010625d:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106262:	e9 35 f3 ff ff       	jmp    8010559c <alltraps>

80106267 <vector182>:
.globl vector182
vector182:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $182
80106269:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010626e:	e9 29 f3 ff ff       	jmp    8010559c <alltraps>

80106273 <vector183>:
.globl vector183
vector183:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $183
80106275:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010627a:	e9 1d f3 ff ff       	jmp    8010559c <alltraps>

8010627f <vector184>:
.globl vector184
vector184:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $184
80106281:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106286:	e9 11 f3 ff ff       	jmp    8010559c <alltraps>

8010628b <vector185>:
.globl vector185
vector185:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $185
8010628d:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106292:	e9 05 f3 ff ff       	jmp    8010559c <alltraps>

80106297 <vector186>:
.globl vector186
vector186:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $186
80106299:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010629e:	e9 f9 f2 ff ff       	jmp    8010559c <alltraps>

801062a3 <vector187>:
.globl vector187
vector187:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $187
801062a5:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062aa:	e9 ed f2 ff ff       	jmp    8010559c <alltraps>

801062af <vector188>:
.globl vector188
vector188:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $188
801062b1:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062b6:	e9 e1 f2 ff ff       	jmp    8010559c <alltraps>

801062bb <vector189>:
.globl vector189
vector189:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $189
801062bd:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062c2:	e9 d5 f2 ff ff       	jmp    8010559c <alltraps>

801062c7 <vector190>:
.globl vector190
vector190:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $190
801062c9:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062ce:	e9 c9 f2 ff ff       	jmp    8010559c <alltraps>

801062d3 <vector191>:
.globl vector191
vector191:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $191
801062d5:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062da:	e9 bd f2 ff ff       	jmp    8010559c <alltraps>

801062df <vector192>:
.globl vector192
vector192:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $192
801062e1:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062e6:	e9 b1 f2 ff ff       	jmp    8010559c <alltraps>

801062eb <vector193>:
.globl vector193
vector193:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $193
801062ed:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062f2:	e9 a5 f2 ff ff       	jmp    8010559c <alltraps>

801062f7 <vector194>:
.globl vector194
vector194:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $194
801062f9:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801062fe:	e9 99 f2 ff ff       	jmp    8010559c <alltraps>

80106303 <vector195>:
.globl vector195
vector195:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $195
80106305:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010630a:	e9 8d f2 ff ff       	jmp    8010559c <alltraps>

8010630f <vector196>:
.globl vector196
vector196:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $196
80106311:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106316:	e9 81 f2 ff ff       	jmp    8010559c <alltraps>

8010631b <vector197>:
.globl vector197
vector197:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $197
8010631d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106322:	e9 75 f2 ff ff       	jmp    8010559c <alltraps>

80106327 <vector198>:
.globl vector198
vector198:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $198
80106329:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010632e:	e9 69 f2 ff ff       	jmp    8010559c <alltraps>

80106333 <vector199>:
.globl vector199
vector199:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $199
80106335:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010633a:	e9 5d f2 ff ff       	jmp    8010559c <alltraps>

8010633f <vector200>:
.globl vector200
vector200:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $200
80106341:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106346:	e9 51 f2 ff ff       	jmp    8010559c <alltraps>

8010634b <vector201>:
.globl vector201
vector201:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $201
8010634d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106352:	e9 45 f2 ff ff       	jmp    8010559c <alltraps>

80106357 <vector202>:
.globl vector202
vector202:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $202
80106359:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010635e:	e9 39 f2 ff ff       	jmp    8010559c <alltraps>

80106363 <vector203>:
.globl vector203
vector203:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $203
80106365:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010636a:	e9 2d f2 ff ff       	jmp    8010559c <alltraps>

8010636f <vector204>:
.globl vector204
vector204:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $204
80106371:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106376:	e9 21 f2 ff ff       	jmp    8010559c <alltraps>

8010637b <vector205>:
.globl vector205
vector205:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $205
8010637d:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106382:	e9 15 f2 ff ff       	jmp    8010559c <alltraps>

80106387 <vector206>:
.globl vector206
vector206:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $206
80106389:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010638e:	e9 09 f2 ff ff       	jmp    8010559c <alltraps>

80106393 <vector207>:
.globl vector207
vector207:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $207
80106395:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010639a:	e9 fd f1 ff ff       	jmp    8010559c <alltraps>

8010639f <vector208>:
.globl vector208
vector208:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $208
801063a1:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063a6:	e9 f1 f1 ff ff       	jmp    8010559c <alltraps>

801063ab <vector209>:
.globl vector209
vector209:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $209
801063ad:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063b2:	e9 e5 f1 ff ff       	jmp    8010559c <alltraps>

801063b7 <vector210>:
.globl vector210
vector210:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $210
801063b9:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063be:	e9 d9 f1 ff ff       	jmp    8010559c <alltraps>

801063c3 <vector211>:
.globl vector211
vector211:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $211
801063c5:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063ca:	e9 cd f1 ff ff       	jmp    8010559c <alltraps>

801063cf <vector212>:
.globl vector212
vector212:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $212
801063d1:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063d6:	e9 c1 f1 ff ff       	jmp    8010559c <alltraps>

801063db <vector213>:
.globl vector213
vector213:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $213
801063dd:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063e2:	e9 b5 f1 ff ff       	jmp    8010559c <alltraps>

801063e7 <vector214>:
.globl vector214
vector214:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $214
801063e9:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063ee:	e9 a9 f1 ff ff       	jmp    8010559c <alltraps>

801063f3 <vector215>:
.globl vector215
vector215:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $215
801063f5:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801063fa:	e9 9d f1 ff ff       	jmp    8010559c <alltraps>

801063ff <vector216>:
.globl vector216
vector216:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $216
80106401:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106406:	e9 91 f1 ff ff       	jmp    8010559c <alltraps>

8010640b <vector217>:
.globl vector217
vector217:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $217
8010640d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106412:	e9 85 f1 ff ff       	jmp    8010559c <alltraps>

80106417 <vector218>:
.globl vector218
vector218:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $218
80106419:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010641e:	e9 79 f1 ff ff       	jmp    8010559c <alltraps>

80106423 <vector219>:
.globl vector219
vector219:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $219
80106425:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010642a:	e9 6d f1 ff ff       	jmp    8010559c <alltraps>

8010642f <vector220>:
.globl vector220
vector220:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $220
80106431:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106436:	e9 61 f1 ff ff       	jmp    8010559c <alltraps>

8010643b <vector221>:
.globl vector221
vector221:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $221
8010643d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106442:	e9 55 f1 ff ff       	jmp    8010559c <alltraps>

80106447 <vector222>:
.globl vector222
vector222:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $222
80106449:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010644e:	e9 49 f1 ff ff       	jmp    8010559c <alltraps>

80106453 <vector223>:
.globl vector223
vector223:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $223
80106455:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010645a:	e9 3d f1 ff ff       	jmp    8010559c <alltraps>

8010645f <vector224>:
.globl vector224
vector224:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $224
80106461:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106466:	e9 31 f1 ff ff       	jmp    8010559c <alltraps>

8010646b <vector225>:
.globl vector225
vector225:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $225
8010646d:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106472:	e9 25 f1 ff ff       	jmp    8010559c <alltraps>

80106477 <vector226>:
.globl vector226
vector226:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $226
80106479:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010647e:	e9 19 f1 ff ff       	jmp    8010559c <alltraps>

80106483 <vector227>:
.globl vector227
vector227:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $227
80106485:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010648a:	e9 0d f1 ff ff       	jmp    8010559c <alltraps>

8010648f <vector228>:
.globl vector228
vector228:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $228
80106491:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106496:	e9 01 f1 ff ff       	jmp    8010559c <alltraps>

8010649b <vector229>:
.globl vector229
vector229:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $229
8010649d:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064a2:	e9 f5 f0 ff ff       	jmp    8010559c <alltraps>

801064a7 <vector230>:
.globl vector230
vector230:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $230
801064a9:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064ae:	e9 e9 f0 ff ff       	jmp    8010559c <alltraps>

801064b3 <vector231>:
.globl vector231
vector231:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $231
801064b5:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064ba:	e9 dd f0 ff ff       	jmp    8010559c <alltraps>

801064bf <vector232>:
.globl vector232
vector232:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $232
801064c1:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064c6:	e9 d1 f0 ff ff       	jmp    8010559c <alltraps>

801064cb <vector233>:
.globl vector233
vector233:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $233
801064cd:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064d2:	e9 c5 f0 ff ff       	jmp    8010559c <alltraps>

801064d7 <vector234>:
.globl vector234
vector234:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $234
801064d9:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064de:	e9 b9 f0 ff ff       	jmp    8010559c <alltraps>

801064e3 <vector235>:
.globl vector235
vector235:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $235
801064e5:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064ea:	e9 ad f0 ff ff       	jmp    8010559c <alltraps>

801064ef <vector236>:
.globl vector236
vector236:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $236
801064f1:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064f6:	e9 a1 f0 ff ff       	jmp    8010559c <alltraps>

801064fb <vector237>:
.globl vector237
vector237:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $237
801064fd:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106502:	e9 95 f0 ff ff       	jmp    8010559c <alltraps>

80106507 <vector238>:
.globl vector238
vector238:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $238
80106509:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010650e:	e9 89 f0 ff ff       	jmp    8010559c <alltraps>

80106513 <vector239>:
.globl vector239
vector239:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $239
80106515:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010651a:	e9 7d f0 ff ff       	jmp    8010559c <alltraps>

8010651f <vector240>:
.globl vector240
vector240:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $240
80106521:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106526:	e9 71 f0 ff ff       	jmp    8010559c <alltraps>

8010652b <vector241>:
.globl vector241
vector241:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $241
8010652d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106532:	e9 65 f0 ff ff       	jmp    8010559c <alltraps>

80106537 <vector242>:
.globl vector242
vector242:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $242
80106539:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010653e:	e9 59 f0 ff ff       	jmp    8010559c <alltraps>

80106543 <vector243>:
.globl vector243
vector243:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $243
80106545:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010654a:	e9 4d f0 ff ff       	jmp    8010559c <alltraps>

8010654f <vector244>:
.globl vector244
vector244:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $244
80106551:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106556:	e9 41 f0 ff ff       	jmp    8010559c <alltraps>

8010655b <vector245>:
.globl vector245
vector245:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $245
8010655d:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106562:	e9 35 f0 ff ff       	jmp    8010559c <alltraps>

80106567 <vector246>:
.globl vector246
vector246:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $246
80106569:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010656e:	e9 29 f0 ff ff       	jmp    8010559c <alltraps>

80106573 <vector247>:
.globl vector247
vector247:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $247
80106575:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010657a:	e9 1d f0 ff ff       	jmp    8010559c <alltraps>

8010657f <vector248>:
.globl vector248
vector248:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $248
80106581:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106586:	e9 11 f0 ff ff       	jmp    8010559c <alltraps>

8010658b <vector249>:
.globl vector249
vector249:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $249
8010658d:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106592:	e9 05 f0 ff ff       	jmp    8010559c <alltraps>

80106597 <vector250>:
.globl vector250
vector250:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $250
80106599:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010659e:	e9 f9 ef ff ff       	jmp    8010559c <alltraps>

801065a3 <vector251>:
.globl vector251
vector251:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $251
801065a5:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065aa:	e9 ed ef ff ff       	jmp    8010559c <alltraps>

801065af <vector252>:
.globl vector252
vector252:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $252
801065b1:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065b6:	e9 e1 ef ff ff       	jmp    8010559c <alltraps>

801065bb <vector253>:
.globl vector253
vector253:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $253
801065bd:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065c2:	e9 d5 ef ff ff       	jmp    8010559c <alltraps>

801065c7 <vector254>:
.globl vector254
vector254:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $254
801065c9:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065ce:	e9 c9 ef ff ff       	jmp    8010559c <alltraps>

801065d3 <vector255>:
.globl vector255
vector255:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $255
801065d5:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065da:	e9 bd ef ff ff       	jmp    8010559c <alltraps>
801065df:	90                   	nop

801065e0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065e0:	a1 c4 57 11 80       	mov    0x801157c4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801065e5:	55                   	push   %ebp
801065e6:	89 e5                	mov    %esp,%ebp
801065e8:	2d 00 00 00 80       	sub    $0x80000000,%eax
801065ed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
801065f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 28             	sub    $0x28,%esp
80106606:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106609:	89 d3                	mov    %edx,%ebx
8010660b:	c1 eb 16             	shr    $0x16,%ebx
8010660e:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106611:	89 75 fc             	mov    %esi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106614:	8b 33                	mov    (%ebx),%esi
80106616:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010661c:	74 22                	je     80106640 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010661e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106624:	81 ee 00 00 00 80    	sub    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010662a:	c1 ea 0a             	shr    $0xa,%edx
8010662d:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106633:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
80106636:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80106639:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010663c:	89 ec                	mov    %ebp,%esp
8010663e:	5d                   	pop    %ebp
8010663f:	c3                   	ret    

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106640:	85 c9                	test   %ecx,%ecx
80106642:	75 04                	jne    80106648 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106644:	31 c0                	xor    %eax,%eax
80106646:	eb ee                	jmp    80106636 <walkpgdir+0x36>

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106648:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010664b:	90                   	nop
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106650:	e8 fb bc ff ff       	call   80102350 <kalloc>
80106655:	85 c0                	test   %eax,%eax
80106657:	89 c6                	mov    %eax,%esi
80106659:	74 e9                	je     80106644 <walkpgdir+0x44>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010665b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106662:	00 
80106663:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010666a:	00 
8010666b:	89 04 24             	mov    %eax,(%esp)
8010666e:	e8 2d dd ff ff       	call   801043a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106673:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106679:	83 c8 07             	or     $0x7,%eax
8010667c:	89 03                	mov    %eax,(%ebx)
8010667e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106681:	eb a7                	jmp    8010662a <walkpgdir+0x2a>
80106683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106690 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106690:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106691:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106693:	89 e5                	mov    %esp,%ebp
80106695:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106698:	8b 55 0c             	mov    0xc(%ebp),%edx
8010669b:	8b 45 08             	mov    0x8(%ebp),%eax
8010669e:	e8 5d ff ff ff       	call   80106600 <walkpgdir>
  if((*pte & PTE_P) == 0)
801066a3:	8b 00                	mov    (%eax),%eax
801066a5:	a8 01                	test   $0x1,%al
801066a7:	75 07                	jne    801066b0 <uva2ka+0x20>
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801066a9:	31 c0                	xor    %eax,%eax
}
801066ab:	c9                   	leave  
801066ac:	c3                   	ret    
801066ad:	8d 76 00             	lea    0x0(%esi),%esi
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
801066b0:	a8 04                	test   $0x4,%al
801066b2:	74 f5                	je     801066a9 <uva2ka+0x19>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801066b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066b9:	2d 00 00 00 80       	sub    $0x80000000,%eax
}
801066be:	c9                   	leave  
801066bf:	90                   	nop
801066c0:	c3                   	ret    
801066c1:	eb 0d                	jmp    801066d0 <copyout>
801066c3:	90                   	nop
801066c4:	90                   	nop
801066c5:	90                   	nop
801066c6:	90                   	nop
801066c7:	90                   	nop
801066c8:	90                   	nop
801066c9:	90                   	nop
801066ca:	90                   	nop
801066cb:	90                   	nop
801066cc:	90                   	nop
801066cd:	90                   	nop
801066ce:	90                   	nop
801066cf:	90                   	nop

801066d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 2c             	sub    $0x2c,%esp
801066d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801066dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801066df:	85 db                	test   %ebx,%ebx
801066e1:	74 75                	je     80106758 <copyout+0x88>
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801066e3:	8b 45 10             	mov    0x10(%ebp),%eax
801066e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066e9:	eb 39                	jmp    80106724 <copyout+0x54>
801066eb:	90                   	nop
801066ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801066f0:	89 f7                	mov    %esi,%edi
801066f2:	29 d7                	sub    %edx,%edi
801066f4:	81 c7 00 10 00 00    	add    $0x1000,%edi
801066fa:	39 df                	cmp    %ebx,%edi
801066fc:	0f 47 fb             	cmova  %ebx,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801066ff:	29 f2                	sub    %esi,%edx
80106701:	89 7c 24 08          	mov    %edi,0x8(%esp)
80106705:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106708:	8d 14 10             	lea    (%eax,%edx,1),%edx
8010670b:	89 14 24             	mov    %edx,(%esp)
8010670e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106712:	e8 49 dd ff ff       	call   80104460 <memmove>
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106717:	29 fb                	sub    %edi,%ebx
80106719:	74 3d                	je     80106758 <copyout+0x88>
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010671b:	01 7d e4             	add    %edi,-0x1c(%ebp)
    va = va0 + PGSIZE;
8010671e:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106724:	89 d6                	mov    %edx,%esi
80106726:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010672c:	89 74 24 04          	mov    %esi,0x4(%esp)
80106730:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106733:	89 0c 24             	mov    %ecx,(%esp)
80106736:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106739:	e8 52 ff ff ff       	call   80106690 <uva2ka>
    if(pa0 == 0)
8010673e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106741:	85 c0                	test   %eax,%eax
80106743:	75 ab                	jne    801066f0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106745:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010674d:	5b                   	pop    %ebx
8010674e:	5e                   	pop    %esi
8010674f:	5f                   	pop    %edi
80106750:	5d                   	pop    %ebp
80106751:	c3                   	ret    
80106752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106758:	83 c4 2c             	add    $0x2c,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010675b:	31 c0                	xor    %eax,%eax
  }
  return 0;
}
8010675d:	5b                   	pop    %ebx
8010675e:	5e                   	pop    %esi
8010675f:	5f                   	pop    %edi
80106760:	5d                   	pop    %ebp
80106761:	c3                   	ret    
80106762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106770:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106771:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106773:	89 e5                	mov    %esp,%ebp
80106775:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106778:	8b 55 0c             	mov    0xc(%ebp),%edx
8010677b:	8b 45 08             	mov    0x8(%ebp),%eax
8010677e:	e8 7d fe ff ff       	call   80106600 <walkpgdir>
  if(pte == 0)
80106783:	85 c0                	test   %eax,%eax
80106785:	74 05                	je     8010678c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106787:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010678a:	c9                   	leave  
8010678b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010678c:	c7 04 24 9c 78 10 80 	movl   $0x8010789c,(%esp)
80106793:	e8 18 9c ff ff       	call   801003b0 <panic>
80106798:	90                   	nop
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	83 ec 1c             	sub    $0x1c,%esp
801067a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801067ac:	8b 75 14             	mov    0x14(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067af:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067b3:	89 fb                	mov    %edi,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067b5:	03 7d 10             	add    0x10(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067be:	83 ef 01             	sub    $0x1,%edi
801067c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801067c7:	eb 23                	jmp    801067ec <mappages+0x4c>
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801067d0:	f6 00 01             	testb  $0x1,(%eax)
801067d3:	75 45                	jne    8010681a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801067d5:	8b 55 18             	mov    0x18(%ebp),%edx
801067d8:	09 f2                	or     %esi,%edx
    if(a == last)
801067da:	39 fb                	cmp    %edi,%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067dc:	89 10                	mov    %edx,(%eax)
    if(a == last)
801067de:	74 30                	je     80106810 <mappages+0x70>
      break;
    a += PGSIZE;
801067e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801067e6:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067ec:	8b 45 08             	mov    0x8(%ebp),%eax
801067ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801067f4:	89 da                	mov    %ebx,%edx
801067f6:	e8 05 fe ff ff       	call   80106600 <walkpgdir>
801067fb:	85 c0                	test   %eax,%eax
801067fd:	75 d1                	jne    801067d0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067ff:	83 c4 1c             	add    $0x1c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
80106802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
80106807:	5b                   	pop    %ebx
80106808:	5e                   	pop    %esi
80106809:	5f                   	pop    %edi
8010680a:	5d                   	pop    %ebp
8010680b:	c3                   	ret    
8010680c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106810:	83 c4 1c             	add    $0x1c,%esp
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
80106813:	31 c0                	xor    %eax,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106815:	5b                   	pop    %ebx
80106816:	5e                   	pop    %esi
80106817:	5f                   	pop    %edi
80106818:	5d                   	pop    %ebp
80106819:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010681a:	c7 04 24 a6 78 10 80 	movl   $0x801078a6,(%esp)
80106821:	e8 8a 9b ff ff       	call   801003b0 <panic>
80106826:	8d 76 00             	lea    0x0(%esi),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106830 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 48             	sub    $0x48,%esp
80106836:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106839:	8b 75 10             	mov    0x10(%ebp),%esi
8010683c:	89 7d fc             	mov    %edi,-0x4(%ebp)
8010683f:	8b 55 08             	mov    0x8(%ebp),%edx
80106842:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80106845:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106848:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010684e:	77 69                	ja     801068b9 <inituvm+0x89>
    panic("inituvm: more than a page");
  mem = kalloc();
80106850:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106853:	e8 f8 ba ff ff       	call   80102350 <kalloc>
  memset(mem, 0, PGSIZE);
80106858:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010685f:	00 
80106860:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106867:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106868:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010686a:	89 04 24             	mov    %eax,(%esp)
8010686d:	e8 2e db ff ff       	call   801043a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106872:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106878:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010687f:	00 
80106880:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106884:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010688b:	00 
8010688c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106893:	00 
80106894:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106897:	89 14 24             	mov    %edx,(%esp)
8010689a:	e8 01 ff ff ff       	call   801067a0 <mappages>
  memmove(mem, init, sz);
8010689f:	89 75 10             	mov    %esi,0x10(%ebp)
}
801068a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068a5:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
801068a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801068b1:	89 ec                	mov    %ebp,%esp
801068b3:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068b4:	e9 a7 db ff ff       	jmp    80104460 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801068b9:	c7 04 24 ac 78 10 80 	movl   $0x801078ac,(%esp)
801068c0:	e8 eb 9a ff ff       	call   801003b0 <panic>
801068c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
801068d6:	83 ec 2c             	sub    $0x2c,%esp
801068d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801068dc:	39 75 10             	cmp    %esi,0x10(%ebp)
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801068df:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
801068e2:	89 f0                	mov    %esi,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801068e4:	73 7d                	jae    80106963 <deallocuvm+0x93>
    return oldsz;

  a = PGROUNDUP(newsz);
801068e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801068e9:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
801068ef:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068f5:	39 de                	cmp    %ebx,%esi
801068f7:	77 3d                	ja     80106936 <deallocuvm+0x66>
801068f9:	eb 65                	jmp    80106960 <deallocuvm+0x90>
801068fb:	90                   	nop
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106900:	8b 10                	mov    (%eax),%edx
80106902:	f6 c2 01             	test   $0x1,%dl
80106905:	74 25                	je     8010692c <deallocuvm+0x5c>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106907:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
80106910:	74 59                	je     8010696b <deallocuvm+0x9b>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106912:	81 ea 00 00 00 80    	sub    $0x80000000,%edx
80106918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010691b:	89 14 24             	mov    %edx,(%esp)
8010691e:	e8 7d ba ff ff       	call   801023a0 <kfree>
      *pte = 0;
80106923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106926:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010692c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106932:	39 de                	cmp    %ebx,%esi
80106934:	76 2a                	jbe    80106960 <deallocuvm+0x90>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106936:	31 c9                	xor    %ecx,%ecx
80106938:	89 da                	mov    %ebx,%edx
8010693a:	89 f8                	mov    %edi,%eax
8010693c:	e8 bf fc ff ff       	call   80106600 <walkpgdir>
    if(!pte)
80106941:	85 c0                	test   %eax,%eax
80106943:	75 bb                	jne    80106900 <deallocuvm+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106945:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010694b:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106951:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106957:	39 de                	cmp    %ebx,%esi
80106959:	77 db                	ja     80106936 <deallocuvm+0x66>
8010695b:	90                   	nop
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106960:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106963:	83 c4 2c             	add    $0x2c,%esp
80106966:	5b                   	pop    %ebx
80106967:	5e                   	pop    %esi
80106968:	5f                   	pop    %edi
80106969:	5d                   	pop    %ebp
8010696a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010696b:	c7 04 24 e6 71 10 80 	movl   $0x801071e6,(%esp)
80106972:	e8 39 9a ff ff       	call   801003b0 <panic>
80106977:	89 f6                	mov    %esi,%esi
80106979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106980 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	56                   	push   %esi
80106984:	53                   	push   %ebx
80106985:	83 ec 10             	sub    $0x10,%esp
80106988:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(pgdir == 0)
8010698b:	85 db                	test   %ebx,%ebx
8010698d:	74 5e                	je     801069ed <freevm+0x6d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010698f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106996:	00 
80106997:	31 f6                	xor    %esi,%esi
80106999:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801069a0:	80 
801069a1:	89 1c 24             	mov    %ebx,(%esp)
801069a4:	e8 27 ff ff ff       	call   801068d0 <deallocuvm>
801069a9:	eb 10                	jmp    801069bb <freevm+0x3b>
801069ab:	90                   	nop
801069ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
801069b0:	83 c6 01             	add    $0x1,%esi
801069b3:	81 fe 00 04 00 00    	cmp    $0x400,%esi
801069b9:	74 24                	je     801069df <freevm+0x5f>
    if(pgdir[i] & PTE_P){
801069bb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
801069be:	a8 01                	test   $0x1,%al
801069c0:	74 ee                	je     801069b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801069c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069c7:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801069ca:	2d 00 00 00 80       	sub    $0x80000000,%eax
801069cf:	89 04 24             	mov    %eax,(%esp)
801069d2:	e8 c9 b9 ff ff       	call   801023a0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069d7:	81 fe 00 04 00 00    	cmp    $0x400,%esi
801069dd:	75 dc                	jne    801069bb <freevm+0x3b>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801069df:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801069e2:	83 c4 10             	add    $0x10,%esp
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801069e8:	e9 b3 b9 ff ff       	jmp    801023a0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801069ed:	c7 04 24 c6 78 10 80 	movl   $0x801078c6,(%esp)
801069f4:	e8 b7 99 ff ff       	call   801003b0 <panic>
801069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a00 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	56                   	push   %esi
80106a04:	53                   	push   %ebx
80106a05:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106a08:	e8 43 b9 ff ff       	call   80102350 <kalloc>
80106a0d:	85 c0                	test   %eax,%eax
80106a0f:	89 c6                	mov    %eax,%esi
80106a11:	74 5d                	je     80106a70 <setupkvm+0x70>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a13:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a1a:	00 
80106a1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a22:	00 
80106a23:	89 04 24             	mov    %eax,(%esp)
80106a26:	e8 75 d9 ff ff       	call   801043a0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a2b:	b8 60 a4 10 80       	mov    $0x8010a460,%eax
80106a30:	3d 20 a4 10 80       	cmp    $0x8010a420,%eax
80106a35:	76 39                	jbe    80106a70 <setupkvm+0x70>
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
80106a37:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a3c:	8b 53 04             	mov    0x4(%ebx),%edx
80106a3f:	8b 43 0c             	mov    0xc(%ebx),%eax
80106a42:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106a46:	89 44 24 10          	mov    %eax,0x10(%esp)
80106a4a:	8b 43 08             	mov    0x8(%ebx),%eax
80106a4d:	29 d0                	sub    %edx,%eax
80106a4f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a53:	8b 03                	mov    (%ebx),%eax
80106a55:	89 34 24             	mov    %esi,(%esp)
80106a58:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a5c:	e8 3f fd ff ff       	call   801067a0 <mappages>
80106a61:	85 c0                	test   %eax,%eax
80106a63:	78 1b                	js     80106a80 <setupkvm+0x80>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a65:	83 c3 10             	add    $0x10,%ebx
80106a68:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a6e:	75 cc                	jne    80106a3c <setupkvm+0x3c>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106a70:	83 c4 20             	add    $0x20,%esp
80106a73:	89 f0                	mov    %esi,%eax
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5d                   	pop    %ebp
80106a78:	c3                   	ret    
80106a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106a80:	89 34 24             	mov    %esi,(%esp)
80106a83:	31 f6                	xor    %esi,%esi
80106a85:	e8 f6 fe ff ff       	call   80106980 <freevm>
      return 0;
    }
  return pgdir;
}
80106a8a:	83 c4 20             	add    $0x20,%esp
80106a8d:	89 f0                	mov    %esi,%eax
80106a8f:	5b                   	pop    %ebx
80106a90:	5e                   	pop    %esi
80106a91:	5d                   	pop    %ebp
80106a92:	c3                   	ret    
80106a93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106aa0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106aa6:	e8 55 ff ff ff       	call   80106a00 <setupkvm>
80106aab:	a3 c4 57 11 80       	mov    %eax,0x801157c4
80106ab0:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106ab5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106ab8:	c9                   	leave  
80106ab9:	c3                   	ret    
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ac0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 3c             	sub    $0x3c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ac9:	e8 32 ff ff ff       	call   80106a00 <setupkvm>
80106ace:	85 c0                	test   %eax,%eax
80106ad0:	89 c6                	mov    %eax,%esi
80106ad2:	0f 84 98 00 00 00    	je     80106b70 <copyuvm+0xb0>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106adb:	85 c0                	test   %eax,%eax
80106add:	0f 84 8d 00 00 00    	je     80106b70 <copyuvm+0xb0>
80106ae3:	31 db                	xor    %ebx,%ebx
80106ae5:	eb 5b                	jmp    80106b42 <copyuvm+0x82>
80106ae7:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106aeb:	89 3c 24             	mov    %edi,(%esp)
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106aee:	81 ef 00 00 00 80    	sub    $0x80000000,%edi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106af4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106afb:	00 
80106afc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b01:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106b06:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b0a:	e8 51 d9 ff ff       	call   80104460 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b12:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106b16:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b1d:	00 
80106b1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b22:	25 ff 0f 00 00       	and    $0xfff,%eax
80106b27:	89 44 24 10          	mov    %eax,0x10(%esp)
80106b2b:	89 34 24             	mov    %esi,(%esp)
80106b2e:	e8 6d fc ff ff       	call   801067a0 <mappages>
80106b33:	85 c0                	test   %eax,%eax
80106b35:	78 2f                	js     80106b66 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b3d:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b40:	76 2e                	jbe    80106b70 <copyuvm+0xb0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b42:	8b 45 08             	mov    0x8(%ebp),%eax
80106b45:	31 c9                	xor    %ecx,%ecx
80106b47:	89 da                	mov    %ebx,%edx
80106b49:	e8 b2 fa ff ff       	call   80106600 <walkpgdir>
80106b4e:	85 c0                	test   %eax,%eax
80106b50:	74 28                	je     80106b7a <copyuvm+0xba>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106b52:	8b 00                	mov    (%eax),%eax
80106b54:	a8 01                	test   $0x1,%al
80106b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b59:	74 2b                	je     80106b86 <copyuvm+0xc6>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106b5b:	e8 f0 b7 ff ff       	call   80102350 <kalloc>
80106b60:	85 c0                	test   %eax,%eax
80106b62:	89 c7                	mov    %eax,%edi
80106b64:	75 82                	jne    80106ae8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106b66:	89 34 24             	mov    %esi,(%esp)
80106b69:	31 f6                	xor    %esi,%esi
80106b6b:	e8 10 fe ff ff       	call   80106980 <freevm>
  return 0;
}
80106b70:	83 c4 3c             	add    $0x3c,%esp
80106b73:	89 f0                	mov    %esi,%eax
80106b75:	5b                   	pop    %ebx
80106b76:	5e                   	pop    %esi
80106b77:	5f                   	pop    %edi
80106b78:	5d                   	pop    %ebp
80106b79:	c3                   	ret    

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106b7a:	c7 04 24 d7 78 10 80 	movl   $0x801078d7,(%esp)
80106b81:	e8 2a 98 ff ff       	call   801003b0 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106b86:	c7 04 24 f1 78 10 80 	movl   $0x801078f1,(%esp)
80106b8d:	e8 1e 98 ff ff       	call   801003b0 <panic>
80106b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ba0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 3c             	sub    $0x3c,%esp
80106ba9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106bac:	85 ff                	test   %edi,%edi
80106bae:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106bb1:	0f 88 ae 00 00 00    	js     80106c65 <allocuvm+0xc5>
    return 0;
  if(newsz < oldsz)
80106bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bba:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80106bbd:	0f 82 b5 00 00 00    	jb     80106c78 <allocuvm+0xd8>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106bc3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106bc6:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80106bcc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106bd2:	39 df                	cmp    %ebx,%edi
80106bd4:	0f 86 a1 00 00 00    	jbe    80106c7b <allocuvm+0xdb>
80106bda:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106bdd:	8b 7d 08             	mov    0x8(%ebp),%edi
80106be0:	eb 53                	jmp    80106c35 <allocuvm+0x95>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106be8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bef:	00 
80106bf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bf7:	00 
80106bf8:	89 04 24             	mov    %eax,(%esp)
80106bfb:	e8 a0 d7 ff ff       	call   801043a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c00:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c06:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106c0d:	00 
80106c0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106c12:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c19:	00 
80106c1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c1e:	89 3c 24             	mov    %edi,(%esp)
80106c21:	e8 7a fb ff ff       	call   801067a0 <mappages>
80106c26:	85 c0                	test   %eax,%eax
80106c28:	78 5e                	js     80106c88 <allocuvm+0xe8>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c30:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106c33:	76 46                	jbe    80106c7b <allocuvm+0xdb>
    mem = kalloc();
80106c35:	e8 16 b7 ff ff       	call   80102350 <kalloc>
    if(mem == 0){
80106c3a:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c3c:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c3e:	75 a8                	jne    80106be8 <allocuvm+0x48>
80106c40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      cprintf("allocuvm out of memory\n");
80106c43:	c7 04 24 9f 77 10 80 	movl   $0x8010779f,(%esp)
80106c4a:	e8 01 9c ff ff       	call   80100850 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c52:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c56:	89 44 24 08          	mov    %eax,0x8(%esp)
80106c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5d:	89 04 24             	mov    %eax,(%esp)
80106c60:	e8 6b fc ff ff       	call   801068d0 <deallocuvm>
80106c65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c6f:	83 c4 3c             	add    $0x3c,%esp
80106c72:	5b                   	pop    %ebx
80106c73:	5e                   	pop    %esi
80106c74:	5f                   	pop    %edi
80106c75:	5d                   	pop    %ebp
80106c76:	c3                   	ret    
80106c77:	90                   	nop
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
80106c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c7e:	83 c4 3c             	add    $0x3c,%esp
80106c81:	5b                   	pop    %ebx
80106c82:	5e                   	pop    %esi
80106c83:	5f                   	pop    %edi
80106c84:	5d                   	pop    %ebp
80106c85:	c3                   	ret    
80106c86:	66 90                	xchg   %ax,%ax
80106c88:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c8b:	c7 04 24 0b 79 10 80 	movl   $0x8010790b,(%esp)
80106c92:	e8 b9 9b ff ff       	call   80100850 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c9e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca5:	89 04 24             	mov    %eax,(%esp)
80106ca8:	e8 23 fc ff ff       	call   801068d0 <deallocuvm>
      kfree(mem);
80106cad:	89 34 24             	mov    %esi,(%esp)
80106cb0:	e8 eb b6 ff ff       	call   801023a0 <kfree>
80106cb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
      return 0;
    }
  }
  return newsz;
}
80106cbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cbf:	83 c4 3c             	add    $0x3c,%esp
80106cc2:	5b                   	pop    %ebx
80106cc3:	5e                   	pop    %esi
80106cc4:	5f                   	pop    %edi
80106cc5:	5d                   	pop    %ebp
80106cc6:	c3                   	ret    
80106cc7:	89 f6                	mov    %esi,%esi
80106cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cd0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 2c             	sub    $0x2c,%esp
80106cd9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106cdc:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
80106ce2:	0f 85 96 00 00 00    	jne    80106d7e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
80106ce8:	8b 75 18             	mov    0x18(%ebp),%esi
80106ceb:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80106ced:	85 f6                	test   %esi,%esi
80106cef:	75 18                	jne    80106d09 <loaduvm+0x39>
80106cf1:	eb 75                	jmp    80106d68 <loaduvm+0x98>
80106cf3:	90                   	nop
80106cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cf8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d04:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d07:	76 5f                	jbe    80106d68 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d09:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0c:	31 c9                	xor    %ecx,%ecx
80106d0e:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80106d11:	e8 ea f8 ff ff       	call   80106600 <walkpgdir>
80106d16:	85 c0                	test   %eax,%eax
80106d18:	74 58                	je     80106d72 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106d1a:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106d20:	ba 00 10 00 00       	mov    $0x1000,%edx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d25:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
80106d27:	0f 42 d6             	cmovb  %esi,%edx
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d2a:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106d2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106d31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d36:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106d3b:	8d 0c 0b             	lea    (%ebx,%ecx,1),%ecx
80106d3e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106d42:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d46:	8b 45 10             	mov    0x10(%ebp),%eax
80106d49:	89 04 24             	mov    %eax,(%esp)
80106d4c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d4f:	e8 cc a9 ff ff       	call   80101720 <readi>
80106d54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d57:	39 d0                	cmp    %edx,%eax
80106d59:	74 9d                	je     80106cf8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106d5b:	83 c4 2c             	add    $0x2c,%esp
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return 0;
}
80106d63:	5b                   	pop    %ebx
80106d64:	5e                   	pop    %esi
80106d65:	5f                   	pop    %edi
80106d66:	5d                   	pop    %ebp
80106d67:	c3                   	ret    
80106d68:	83 c4 2c             	add    $0x2c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106d6b:	31 c0                	xor    %eax,%eax
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}
80106d6d:	5b                   	pop    %ebx
80106d6e:	5e                   	pop    %esi
80106d6f:	5f                   	pop    %edi
80106d70:	5d                   	pop    %ebp
80106d71:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106d72:	c7 04 24 27 79 10 80 	movl   $0x80107927,(%esp)
80106d79:	e8 32 96 ff ff       	call   801003b0 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106d7e:	c7 04 24 84 79 10 80 	movl   $0x80107984,(%esp)
80106d85:	e8 26 96 ff ff       	call   801003b0 <panic>
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d90 <switchuvm>:
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 2c             	sub    $0x2c,%esp
80106d99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d9c:	85 f6                	test   %esi,%esi
80106d9e:	0f 84 c4 00 00 00    	je     80106e68 <switchuvm+0xd8>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106da4:	8b 4e 08             	mov    0x8(%esi),%ecx
80106da7:	85 c9                	test   %ecx,%ecx
80106da9:	0f 84 d1 00 00 00    	je     80106e80 <switchuvm+0xf0>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106daf:	8b 56 04             	mov    0x4(%esi),%edx
80106db2:	85 d2                	test   %edx,%edx
80106db4:	0f 84 ba 00 00 00    	je     80106e74 <switchuvm+0xe4>
    panic("switchuvm: no pgdir");

  pushcli();
80106dba:	e8 b1 d4 ff ff       	call   80104270 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dbf:	e8 cc cb ff ff       	call   80103990 <mycpu>
80106dc4:	89 c3                	mov    %eax,%ebx
80106dc6:	e8 c5 cb ff ff       	call   80103990 <mycpu>
80106dcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dce:	e8 bd cb ff ff       	call   80103990 <mycpu>
80106dd3:	89 c7                	mov    %eax,%edi
80106dd5:	e8 b6 cb ff ff       	call   80103990 <mycpu>
80106dda:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106de1:	67 00 
80106de3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106de6:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106ded:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106df4:	83 c2 08             	add    $0x8,%edx
80106df7:	66 89 93 9a 00 00 00 	mov    %dx,0x9a(%ebx)
80106dfe:	83 c0 08             	add    $0x8,%eax
80106e01:	8d 57 08             	lea    0x8(%edi),%edx
80106e04:	c1 ea 10             	shr    $0x10,%edx
80106e07:	c1 e8 18             	shr    $0x18,%eax
80106e0a:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106e10:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106e16:	e8 75 cb ff ff       	call   80103990 <mycpu>
80106e1b:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e22:	e8 69 cb ff ff       	call   80103990 <mycpu>
80106e27:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e2d:	e8 5e cb ff ff       	call   80103990 <mycpu>
80106e32:	8b 56 08             	mov    0x8(%esi),%edx
80106e35:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106e3b:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e3e:	e8 4d cb ff ff       	call   80103990 <mycpu>
80106e43:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106e49:	b8 28 00 00 00       	mov    $0x28,%eax
80106e4e:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e51:	8b 46 04             	mov    0x4(%esi),%eax
80106e54:	2d 00 00 00 80       	sub    $0x80000000,%eax
80106e59:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106e5c:	83 c4 2c             	add    $0x2c,%esp
80106e5f:	5b                   	pop    %ebx
80106e60:	5e                   	pop    %esi
80106e61:	5f                   	pop    %edi
80106e62:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106e63:	e9 98 d3 ff ff       	jmp    80104200 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106e68:	c7 04 24 45 79 10 80 	movl   $0x80107945,(%esp)
80106e6f:	e8 3c 95 ff ff       	call   801003b0 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106e74:	c7 04 24 70 79 10 80 	movl   $0x80107970,(%esp)
80106e7b:	e8 30 95 ff ff       	call   801003b0 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106e80:	c7 04 24 5b 79 10 80 	movl   $0x8010795b,(%esp)
80106e87:	e8 24 95 ff ff       	call   801003b0 <panic>
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e90 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106e96:	e8 95 d1 ff ff       	call   80104030 <cpuid>
80106e9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ea1:	05 a0 27 11 80       	add    $0x801127a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ea6:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80106eac:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80106eb2:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106eb6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80106eba:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
80106ebe:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ec2:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80106ec9:	ff ff 
80106ecb:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80106ed2:	00 00 
80106ed4:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106edb:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106ee2:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
80106ee9:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ef0:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80106ef7:	ff ff 
80106ef9:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80106f00:	00 00 
80106f02:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80106f09:	c6 80 8d 00 00 00 fa 	movb   $0xfa,0x8d(%eax)
80106f10:	c6 80 8e 00 00 00 cf 	movb   $0xcf,0x8e(%eax)
80106f17:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f1e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80106f25:	ff ff 
80106f27:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80106f2e:	00 00 
80106f30:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106f37:	c6 80 95 00 00 00 f2 	movb   $0xf2,0x95(%eax)
80106f3e:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
80106f45:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106f4c:	83 c0 70             	add    $0x70,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106f4f:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106f55:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f59:	c1 e8 10             	shr    $0x10,%eax
80106f5c:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106f60:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f63:	0f 01 10             	lgdtl  (%eax)
}
80106f66:	c9                   	leave  
80106f67:	c3                   	ret    
