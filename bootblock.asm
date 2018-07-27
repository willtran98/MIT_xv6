
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	78 7c                	js     7c9e <readsect+0xb>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:	ea 31 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c31

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c48:	e8 e7 00 00 00       	call   7d34 <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4d:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c51:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c54:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c56:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5a:	66 ef                	out    %ax,(%dx)

00007c5c <spin>:
spin:
  jmp     spin
    7c5c:	eb fe                	jmp    7c5c <spin>
    7c5e:	66 90                	xchg   %ax,%ax

00007c60 <gdt>:
	...
    7c68:	ff                   	(bad)  
    7c69:	ff 00                	incl   (%eax)
    7c6b:	00 00                	add    %al,(%eax)
    7c6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c74:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c78 <gdtdesc>:
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%eax)
	...

00007c7e <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7c7e:	55                   	push   %ebp
    7c7f:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c81:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c86:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c87:	25 c0 00 00 00       	and    $0xc0,%eax
    7c8c:	83 f8 40             	cmp    $0x40,%eax
    7c8f:	75 f5                	jne    7c86 <waitdisk+0x8>
    ;
}
    7c91:	5d                   	pop    %ebp
    7c92:	c3                   	ret    

00007c93 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c93:	55                   	push   %ebp
    7c94:	89 e5                	mov    %esp,%ebp
    7c96:	57                   	push   %edi
    7c97:	53                   	push   %ebx
    7c98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c9b:	e8 de ff ff ff       	call   7c7e <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7ca0:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca5:	b8 01 00 00 00       	mov    $0x1,%eax
    7caa:	ee                   	out    %al,(%dx)
    7cab:	b2 f3                	mov    $0xf3,%dl
    7cad:	89 d8                	mov    %ebx,%eax
    7caf:	ee                   	out    %al,(%dx)
    7cb0:	89 d8                	mov    %ebx,%eax
    7cb2:	c1 e8 08             	shr    $0x8,%eax
    7cb5:	b2 f4                	mov    $0xf4,%dl
    7cb7:	ee                   	out    %al,(%dx)
    7cb8:	89 d8                	mov    %ebx,%eax
    7cba:	c1 e8 10             	shr    $0x10,%eax
    7cbd:	b2 f5                	mov    $0xf5,%dl
    7cbf:	ee                   	out    %al,(%dx)
    7cc0:	c1 eb 18             	shr    $0x18,%ebx
    7cc3:	89 d8                	mov    %ebx,%eax
    7cc5:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc8:	b2 f6                	mov    $0xf6,%dl
    7cca:	ee                   	out    %al,(%dx)
    7ccb:	b2 f7                	mov    $0xf7,%dl
    7ccd:	b8 20 00 00 00       	mov    $0x20,%eax
    7cd2:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd3:	e8 a6 ff ff ff       	call   7c7e <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7cd8:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cdb:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ce0:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce5:	fc                   	cld    
    7ce6:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7ce8:	5b                   	pop    %ebx
    7ce9:	5f                   	pop    %edi
    7cea:	5d                   	pop    %ebp
    7ceb:	c3                   	ret    

00007cec <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7cec:	55                   	push   %ebp
    7ced:	89 e5                	mov    %esp,%ebp
    7cef:	57                   	push   %edi
    7cf0:	56                   	push   %esi
    7cf1:	53                   	push   %ebx
    7cf2:	83 ec 08             	sub    $0x8,%esp
    7cf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cf8:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7cfb:	89 df                	mov    %ebx,%edi
    7cfd:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d00:	89 f0                	mov    %esi,%eax
    7d02:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d07:	29 c3                	sub    %eax,%ebx
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d09:	39 df                	cmp    %ebx,%edi
    7d0b:	76 1f                	jbe    7d2c <readseg+0x40>

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d0d:	c1 ee 09             	shr    $0x9,%esi
    7d10:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
    7d13:	89 74 24 04          	mov    %esi,0x4(%esp)
    7d17:	89 1c 24             	mov    %ebx,(%esp)
    7d1a:	e8 74 ff ff ff       	call   7c93 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d1f:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d25:	83 c6 01             	add    $0x1,%esi
    7d28:	39 df                	cmp    %ebx,%edi
    7d2a:	77 e7                	ja     7d13 <readseg+0x27>
    readsect(pa, offset);
}
    7d2c:	83 c4 08             	add    $0x8,%esp
    7d2f:	5b                   	pop    %ebx
    7d30:	5e                   	pop    %esi
    7d31:	5f                   	pop    %edi
    7d32:	5d                   	pop    %ebp
    7d33:	c3                   	ret    

00007d34 <bootmain>:

void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d34:	55                   	push   %ebp
    7d35:	89 e5                	mov    %esp,%ebp
    7d37:	57                   	push   %edi
    7d38:	56                   	push   %esi
    7d39:	53                   	push   %ebx
    7d3a:	83 ec 2c             	sub    $0x2c,%esp
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    7d44:	00 
    7d45:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d4c:	00 
    7d4d:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d54:	e8 93 ff ff ff       	call   7cec <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d59:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d60:	45 4c 46 
    7d63:	75 5d                	jne    7dc2 <bootmain+0x8e>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d65:	b8 00 00 01 00       	mov    $0x10000,%eax
    7d6a:	8b 58 1c             	mov    0x1c(%eax),%ebx
    7d6d:	81 c3 00 00 01 00    	add    $0x10000,%ebx
  eph = ph + elf->phnum;
    7d73:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
    7d77:	c1 e0 05             	shl    $0x5,%eax
    7d7a:	8d 04 03             	lea    (%ebx,%eax,1),%eax
    7d7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; ph < eph; ph++){
    7d80:	39 c3                	cmp    %eax,%ebx
    7d82:	73 38                	jae    7dbc <bootmain+0x88>
    pa = (uchar*)ph->paddr;
    7d84:	8b 73 0c             	mov    0xc(%ebx),%esi
    readseg(pa, ph->filesz, ph->off);
    7d87:	8b 43 04             	mov    0x4(%ebx),%eax
    7d8a:	89 44 24 08          	mov    %eax,0x8(%esp)
    7d8e:	8b 43 10             	mov    0x10(%ebx),%eax
    7d91:	89 44 24 04          	mov    %eax,0x4(%esp)
    7d95:	89 34 24             	mov    %esi,(%esp)
    7d98:	e8 4f ff ff ff       	call   7cec <readseg>
    if(ph->memsz > ph->filesz)
    7d9d:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7da0:	8b 43 10             	mov    0x10(%ebx),%eax
    7da3:	39 c1                	cmp    %eax,%ecx
    7da5:	76 0d                	jbe    7db4 <bootmain+0x80>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7da7:	8d 3c 06             	lea    (%esi,%eax,1),%edi
    7daa:	29 c1                	sub    %eax,%ecx
    7dac:	b8 00 00 00 00       	mov    $0x0,%eax
    7db1:	fc                   	cld    
    7db2:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7db4:	83 c3 20             	add    $0x20,%ebx
    7db7:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
    7dba:	77 c8                	ja     7d84 <bootmain+0x50>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7dbc:	ff 15 18 00 01 00    	call   *0x10018
}
    7dc2:	83 c4 2c             	add    $0x2c,%esp
    7dc5:	5b                   	pop    %ebx
    7dc6:	5e                   	pop    %esi
    7dc7:	5f                   	pop    %edi
    7dc8:	5d                   	pop    %ebp
    7dc9:	c3                   	ret    
