
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
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(argc != 3){
   d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  11:	74 1d                	je     30 <main+0x30>
    printf(2, "Usage: ln old new\n");
  13:	c7 44 24 04 76 07 00 	movl   $0x776,0x4(%esp)
  1a:	00 
  1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  22:	e8 d9 03 00 00       	call   400 <printf>
    exit();
  27:	e8 79 02 00 00       	call   2a5 <exit>
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  if(link(argv[1], argv[2]) < 0)
  30:	8b 43 08             	mov    0x8(%ebx),%eax
  33:	89 44 24 04          	mov    %eax,0x4(%esp)
  37:	8b 43 04             	mov    0x4(%ebx),%eax
  3a:	89 04 24             	mov    %eax,(%esp)
  3d:	e8 c3 02 00 00       	call   305 <link>
  42:	85 c0                	test   %eax,%eax
  44:	78 0a                	js     50 <main+0x50>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  46:	e8 5a 02 00 00       	call   2a5 <exit>
  4b:	90                   	nop
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(argc != 3){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  50:	8b 43 08             	mov    0x8(%ebx),%eax
  53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  57:	8b 43 04             	mov    0x4(%ebx),%eax
  5a:	c7 44 24 04 89 07 00 	movl   $0x789,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	89 44 24 08          	mov    %eax,0x8(%esp)
  6d:	e8 8e 03 00 00       	call   400 <printf>
  72:	eb d2                	jmp    46 <main+0x46>
  74:	66 90                	xchg   %ax,%ax
  76:	66 90                	xchg   %ax,%ax
  78:	66 90                	xchg   %ax,%ax
  7a:	66 90                	xchg   %ax,%ax
  7c:	66 90                	xchg   %ax,%ax
  7e:	66 90                	xchg   %ax,%ax

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	31 d2                	xor    %edx,%edx
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	53                   	push   %ebx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 c9                	test   %cl,%cl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	eb 0d                	jmp    b0 <strcmp>
  a3:	90                   	nop
  a4:	90                   	nop
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop
  a8:	90                   	nop
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop
  ac:	90                   	nop
  ad:	90                   	nop
  ae:	90                   	nop
  af:	90                   	nop

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	0f b6 01             	movzbl (%ecx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 14                	jne    d5 <strcmp+0x25>
  c1:	eb 25                	jmp    e8 <strcmp+0x38>
  c3:	90                   	nop
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  c8:	83 c1 01             	add    $0x1,%ecx
  cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	0f b6 01             	movzbl (%ecx),%eax
  d1:	84 c0                	test   %al,%al
  d3:	74 13                	je     e8 <strcmp+0x38>
  d5:	0f b6 1a             	movzbl (%edx),%ebx
  d8:	38 d8                	cmp    %bl,%al
  da:	74 ec                	je     c8 <strcmp+0x18>
  dc:	0f b6 db             	movzbl %bl,%ebx
  df:	0f b6 c0             	movzbl %al,%eax
  e2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	0f b6 1a             	movzbl (%edx),%ebx
  eb:	31 c0                	xor    %eax,%eax
  ed:	0f b6 db             	movzbl %bl,%ebx
  f0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f2:	5b                   	pop    %ebx
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 105:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10a:	80 39 00             	cmpb   $0x0,(%ecx)
 10d:	74 0c                	je     11b <strlen+0x1b>
 10f:	90                   	nop
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 11                	jne    162 <strchr+0x22>
 151:	eb 15                	jmp    168 <strchr+0x28>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 158:	83 c0 01             	add    $0x1,%eax
 15b:	0f b6 10             	movzbl (%eax),%edx
 15e:	84 d2                	test   %dl,%dl
 160:	74 06                	je     168 <strchr+0x28>
    if(*s == c)
 162:	38 ca                	cmp    %cl,%dl
 164:	75 f2                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 16a:	5d                   	pop    %ebp
 16b:	90                   	nop
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <atoi>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 181:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 183:	89 e5                	mov    %esp,%ebp
 185:	8b 4d 08             	mov    0x8(%ebp),%ecx
 188:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 189:	0f b6 11             	movzbl (%ecx),%edx
 18c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18f:	80 fb 09             	cmp    $0x9,%bl
 192:	77 1c                	ja     1b0 <atoi+0x30>
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 198:	0f be d2             	movsbl %dl,%edx
 19b:	83 c1 01             	add    $0x1,%ecx
 19e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a5:	0f b6 11             	movzbl (%ecx),%edx
 1a8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ab:	80 fb 09             	cmp    $0x9,%bl
 1ae:	76 e8                	jbe    198 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	53                   	push   %ebx
 1c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ce:	85 db                	test   %ebx,%ebx
 1d0:	7e 14                	jle    1e6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1d2:	31 d2                	xor    %edx,%edx
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1df:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1e2:	39 da                	cmp    %ebx,%edx
 1e4:	75 f2                	jne    1d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1ff:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 204:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20b:	00 
 20c:	89 04 24             	mov    %eax,(%esp)
 20f:	e8 d1 00 00 00       	call   2e5 <open>
  if(fd < 0)
 214:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 218:	78 19                	js     233 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 1c 24             	mov    %ebx,(%esp)
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	e8 d4 00 00 00       	call   2fd <fstat>
  close(fd);
 229:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 22c:	89 c6                	mov    %eax,%esi
  close(fd);
 22e:	e8 9a 00 00 00       	call   2cd <close>
  return r;
}
 233:	89 f0                	mov    %esi,%eax
 235:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 238:	8b 75 fc             	mov    -0x4(%ebp),%esi
 23b:	89 ec                	mov    %ebp,%esp
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
 23f:	90                   	nop

00000240 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	31 f6                	xor    %esi,%esi
 247:	53                   	push   %ebx
 248:	83 ec 2c             	sub    $0x2c,%esp
 24b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24e:	eb 06                	jmp    256 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 250:	3c 0a                	cmp    $0xa,%al
 252:	74 39                	je     28d <gets+0x4d>
 254:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	8d 5e 01             	lea    0x1(%esi),%ebx
 259:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25c:	7d 31                	jge    28f <gets+0x4f>
    cc = read(0, &c, 1);
 25e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 261:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 268:	00 
 269:	89 44 24 04          	mov    %eax,0x4(%esp)
 26d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 274:	e8 44 00 00 00       	call   2bd <read>
    if(cc < 1)
 279:	85 c0                	test   %eax,%eax
 27b:	7e 12                	jle    28f <gets+0x4f>
      break;
    buf[i++] = c;
 27d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 281:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 285:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 289:	3c 0d                	cmp    $0xd,%al
 28b:	75 c3                	jne    250 <gets+0x10>
 28d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 28f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 293:	89 f8                	mov    %edi,%eax
 295:	83 c4 2c             	add    $0x2c,%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    

0000029d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 29d:	b8 01 00 00 00       	mov    $0x1,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <exit>:
SYSCALL(exit)
 2a5:	b8 02 00 00 00       	mov    $0x2,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <wait>:
SYSCALL(wait)
 2ad:	b8 03 00 00 00       	mov    $0x3,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <pipe>:
SYSCALL(pipe)
 2b5:	b8 04 00 00 00       	mov    $0x4,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <read>:
SYSCALL(read)
 2bd:	b8 05 00 00 00       	mov    $0x5,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <write>:
SYSCALL(write)
 2c5:	b8 10 00 00 00       	mov    $0x10,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <close>:
SYSCALL(close)
 2cd:	b8 15 00 00 00       	mov    $0x15,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <kill>:
SYSCALL(kill)
 2d5:	b8 06 00 00 00       	mov    $0x6,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exec>:
SYSCALL(exec)
 2dd:	b8 07 00 00 00       	mov    $0x7,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <open>:
SYSCALL(open)
 2e5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <mknod>:
SYSCALL(mknod)
 2ed:	b8 11 00 00 00       	mov    $0x11,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <unlink>:
SYSCALL(unlink)
 2f5:	b8 12 00 00 00       	mov    $0x12,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <fstat>:
SYSCALL(fstat)
 2fd:	b8 08 00 00 00       	mov    $0x8,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <link>:
SYSCALL(link)
 305:	b8 13 00 00 00       	mov    $0x13,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <mkdir>:
SYSCALL(mkdir)
 30d:	b8 14 00 00 00       	mov    $0x14,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <chdir>:
SYSCALL(chdir)
 315:	b8 09 00 00 00       	mov    $0x9,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <dup>:
SYSCALL(dup)
 31d:	b8 0a 00 00 00       	mov    $0xa,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <getpid>:
SYSCALL(getpid)
 325:	b8 0b 00 00 00       	mov    $0xb,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <sbrk>:
SYSCALL(sbrk)
 32d:	b8 0c 00 00 00       	mov    $0xc,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <sleep>:
SYSCALL(sleep)
 335:	b8 0d 00 00 00       	mov    $0xd,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <uptime>:
SYSCALL(uptime)
 33d:	b8 0e 00 00 00       	mov    $0xe,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <date>:
SYSCALL(date)
 345:	b8 16 00 00 00       	mov    $0x16,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <alarm>:
SYSCALL(alarm)
 34d:	b8 17 00 00 00       	mov    $0x17,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    
 355:	66 90                	xchg   %ax,%ax
 357:	66 90                	xchg   %ax,%ax
 359:	66 90                	xchg   %ax,%ax
 35b:	66 90                	xchg   %ax,%ax
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	89 cf                	mov    %ecx,%edi
 366:	56                   	push   %esi
 367:	89 c6                	mov    %eax,%esi
 369:	53                   	push   %ebx
 36a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 370:	85 c9                	test   %ecx,%ecx
 372:	74 04                	je     378 <printint+0x18>
 374:	85 d2                	test   %edx,%edx
 376:	78 70                	js     3e8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 378:	89 d0                	mov    %edx,%eax
 37a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 381:	31 c9                	xor    %ecx,%ecx
 383:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 386:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 388:	31 d2                	xor    %edx,%edx
 38a:	f7 f7                	div    %edi
 38c:	0f b6 92 a4 07 00 00 	movzbl 0x7a4(%edx),%edx
 393:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 396:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 399:	85 c0                	test   %eax,%eax
 39b:	75 eb                	jne    388 <printint+0x28>
  if(neg)
 39d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a0:	85 c0                	test   %eax,%eax
 3a2:	74 08                	je     3ac <printint+0x4c>
    buf[i++] = '-';
 3a4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 3a9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3ac:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3af:	01 fb                	add    %edi,%ebx
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b8:	0f b6 03             	movzbl (%ebx),%eax
 3bb:	83 ef 01             	sub    $0x1,%edi
 3be:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c8:	00 
 3c9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3cc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3cf:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d6:	e8 ea fe ff ff       	call   2c5 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3db:	83 ff ff             	cmp    $0xffffffff,%edi
 3de:	75 d8                	jne    3b8 <printint+0x58>
    putc(fd, buf[i]);
}
 3e0:	83 c4 4c             	add    $0x4c,%esp
 3e3:	5b                   	pop    %ebx
 3e4:	5e                   	pop    %esi
 3e5:	5f                   	pop    %edi
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3e8:	89 d0                	mov    %edx,%eax
 3ea:	f7 d8                	neg    %eax
 3ec:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3f3:	eb 8c                	jmp    381 <printint+0x21>
 3f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	0f b6 10             	movzbl (%eax),%edx
 40f:	84 d2                	test   %dl,%dl
 411:	0f 84 c9 00 00 00    	je     4e0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 4d 10             	lea    0x10(%ebp),%ecx
 41a:	31 ff                	xor    %edi,%edi
 41c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 41f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 421:	8d 75 e7             	lea    -0x19(%ebp),%esi
 424:	eb 1e                	jmp    444 <printf+0x44>
 426:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 428:	83 fa 25             	cmp    $0x25,%edx
 42b:	0f 85 b7 00 00 00    	jne    4e8 <printf+0xe8>
 431:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 435:	83 c3 01             	add    $0x1,%ebx
 438:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 43c:	84 d2                	test   %dl,%dl
 43e:	0f 84 9c 00 00 00    	je     4e0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 444:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 446:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 449:	74 dd                	je     428 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44b:	83 ff 25             	cmp    $0x25,%edi
 44e:	75 e5                	jne    435 <printf+0x35>
      if(c == 'd'){
 450:	83 fa 64             	cmp    $0x64,%edx
 453:	0f 84 47 01 00 00    	je     5a0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 459:	83 fa 70             	cmp    $0x70,%edx
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 460:	0f 84 aa 00 00 00    	je     510 <printf+0x110>
 466:	83 fa 78             	cmp    $0x78,%edx
 469:	0f 84 a1 00 00 00    	je     510 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46f:	83 fa 73             	cmp    $0x73,%edx
 472:	0f 84 c0 00 00 00    	je     538 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 478:	83 fa 63             	cmp    $0x63,%edx
 47b:	90                   	nop
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 480:	0f 84 42 01 00 00    	je     5c8 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 486:	83 fa 25             	cmp    $0x25,%edx
 489:	0f 84 01 01 00 00    	je     590 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 48f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 492:	89 55 cc             	mov    %edx,-0x34(%ebp)
 495:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 499:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a0:	00 
 4a1:	89 74 24 04          	mov    %esi,0x4(%esp)
 4a5:	89 0c 24             	mov    %ecx,(%esp)
 4a8:	e8 18 fe ff ff       	call   2c5 <write>
 4ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
 4b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b6:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b9:	31 ff                	xor    %edi,%edi
 4bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4c2:	00 
 4c3:	89 74 24 04          	mov    %esi,0x4(%esp)
 4c7:	89 04 24             	mov    %eax,(%esp)
 4ca:	e8 f6 fd ff ff       	call   2c5 <write>
 4cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4d6:	84 d2                	test   %dl,%dl
 4d8:	0f 85 66 ff ff ff    	jne    444 <printf+0x44>
 4de:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4e0:	83 c4 3c             	add    $0x3c,%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4eb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f5:	00 
 4f6:	89 74 24 04          	mov    %esi,0x4(%esp)
 4fa:	89 04 24             	mov    %eax,(%esp)
 4fd:	e8 c3 fd ff ff       	call   2c5 <write>
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	e9 2b ff ff ff       	jmp    435 <printf+0x35>
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 510:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 513:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 518:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 51a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 521:	8b 10                	mov    (%eax),%edx
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	e8 35 fe ff ff       	call   360 <printint>
 52b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 52e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 532:	e9 fe fe ff ff       	jmp    435 <printf+0x35>
 537:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 538:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 53b:	b9 9d 07 00 00       	mov    $0x79d,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 540:	8b 3a                	mov    (%edx),%edi
        ap++;
 542:	83 c2 04             	add    $0x4,%edx
 545:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 548:	85 ff                	test   %edi,%edi
 54a:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 54d:	0f b6 17             	movzbl (%edi),%edx
 550:	84 d2                	test   %dl,%dl
 552:	74 33                	je     587 <printf+0x187>
 554:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 557:	8b 5d 08             	mov    0x8(%ebp),%ebx
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 560:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 563:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 566:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 56d:	00 
 56e:	89 74 24 04          	mov    %esi,0x4(%esp)
 572:	89 1c 24             	mov    %ebx,(%esp)
 575:	e8 4b fd ff ff       	call   2c5 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 57a:	0f b6 17             	movzbl (%edi),%edx
 57d:	84 d2                	test   %dl,%dl
 57f:	75 df                	jne    560 <printf+0x160>
 581:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 584:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 587:	31 ff                	xor    %edi,%edi
 589:	e9 a7 fe ff ff       	jmp    435 <printf+0x35>
 58e:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 590:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 594:	e9 1a ff ff ff       	jmp    4b3 <printf+0xb3>
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5a8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5b2:	8b 10                	mov    (%eax),%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	e8 a4 fd ff ff       	call   360 <printint>
 5bc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5bf:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5c3:	e9 6d fe ff ff       	jmp    435 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 5cb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d0:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d9:	00 
 5da:	89 74 24 04          	mov    %esi,0x4(%esp)
 5de:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e1:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e4:	e8 dc fc ff ff       	call   2c5 <write>
 5e9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5ec:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5f0:	e9 40 fe ff ff       	jmp    435 <printf+0x35>
 5f5:	66 90                	xchg   %ax,%ax
 5f7:	66 90                	xchg   %ax,%ax
 5f9:	66 90                	xchg   %ax,%ax
 5fb:	66 90                	xchg   %ax,%ax
 5fd:	66 90                	xchg   %ax,%ax
 5ff:	90                   	nop

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 c0 07 00 00       	mov    0x7c0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	39 c8                	cmp    %ecx,%eax
 613:	73 1d                	jae    632 <free+0x32>
 615:	8d 76 00             	lea    0x0(%esi),%esi
 618:	8b 10                	mov    (%eax),%edx
 61a:	39 d1                	cmp    %edx,%ecx
 61c:	72 1a                	jb     638 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61e:	39 d0                	cmp    %edx,%eax
 620:	72 08                	jb     62a <free+0x2a>
 622:	39 c8                	cmp    %ecx,%eax
 624:	72 12                	jb     638 <free+0x38>
 626:	39 d1                	cmp    %edx,%ecx
 628:	72 0e                	jb     638 <free+0x38>
 62a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	39 c8                	cmp    %ecx,%eax
 62e:	66 90                	xchg   %ax,%ax
 630:	72 e6                	jb     618 <free+0x18>
 632:	8b 10                	mov    (%eax),%edx
 634:	eb e8                	jmp    61e <free+0x1e>
 636:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 71 04             	mov    0x4(%ecx),%esi
 63b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63e:	39 d7                	cmp    %edx,%edi
 640:	74 19                	je     65b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 642:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 645:	8b 50 04             	mov    0x4(%eax),%edx
 648:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64b:	39 ce                	cmp    %ecx,%esi
 64d:	74 23                	je     672 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 651:	a3 c0 07 00 00       	mov    %eax,0x7c0
}
 656:	5b                   	pop    %ebx
 657:	5e                   	pop    %esi
 658:	5f                   	pop    %edi
 659:	5d                   	pop    %ebp
 65a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 65b:	03 72 04             	add    0x4(%edx),%esi
 65e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 12                	mov    (%edx),%edx
 665:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 668:	8b 50 04             	mov    0x4(%eax),%edx
 66b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66e:	39 ce                	cmp    %ecx,%esi
 670:	75 dd                	jne    64f <free+0x4f>
    p->s.size += bp->s.size;
 672:	03 51 04             	add    0x4(%ecx),%edx
 675:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 678:	8b 53 f8             	mov    -0x8(%ebx),%edx
 67b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 67d:	a3 c0 07 00 00       	mov    %eax,0x7c0
}
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5f                   	pop    %edi
 685:	5d                   	pop    %ebp
 686:	c3                   	ret    
 687:	89 f6                	mov    %esi,%esi
 689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 69c:	8b 0d c0 07 00 00    	mov    0x7c0,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	83 c3 07             	add    $0x7,%ebx
 6a5:	c1 eb 03             	shr    $0x3,%ebx
 6a8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6ab:	85 c9                	test   %ecx,%ecx
 6ad:	0f 84 9b 00 00 00    	je     74e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	39 d3                	cmp    %edx,%ebx
 6ba:	76 27                	jbe    6e3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 6bc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6c3:	be 00 80 00 00       	mov    $0x8000,%esi
 6c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6cb:	90                   	nop
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d0:	3b 05 c0 07 00 00    	cmp    0x7c0,%eax
 6d6:	74 30                	je     708 <malloc+0x78>
 6d8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6da:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6dc:	8b 50 04             	mov    0x4(%eax),%edx
 6df:	39 d3                	cmp    %edx,%ebx
 6e1:	77 ed                	ja     6d0 <malloc+0x40>
      if(p->s.size == nunits)
 6e3:	39 d3                	cmp    %edx,%ebx
 6e5:	74 61                	je     748 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6e7:	29 da                	sub    %ebx,%edx
 6e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6ec:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6ef:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6f2:	89 0d c0 07 00 00    	mov    %ecx,0x7c0
      return (void*)(p + 1);
 6f8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6fb:	83 c4 2c             	add    $0x2c,%esp
 6fe:	5b                   	pop    %ebx
 6ff:	5e                   	pop    %esi
 700:	5f                   	pop    %edi
 701:	5d                   	pop    %ebp
 702:	c3                   	ret    
 703:	90                   	nop
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 711:	bf 00 10 00 00       	mov    $0x1000,%edi
 716:	0f 43 fb             	cmovae %ebx,%edi
 719:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 09 fc ff ff       	call   32d <sbrk>
  if(p == (char*)-1)
 724:	83 f8 ff             	cmp    $0xffffffff,%eax
 727:	74 18                	je     741 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 729:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 72c:	83 c0 08             	add    $0x8,%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 c9 fe ff ff       	call   600 <free>
  return freep;
 737:	8b 0d c0 07 00 00    	mov    0x7c0,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 73d:	85 c9                	test   %ecx,%ecx
 73f:	75 99                	jne    6da <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 741:	31 c0                	xor    %eax,%eax
 743:	eb b6                	jmp    6fb <malloc+0x6b>
 745:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 748:	8b 10                	mov    (%eax),%edx
 74a:	89 11                	mov    %edx,(%ecx)
 74c:	eb a4                	jmp    6f2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 74e:	c7 05 c0 07 00 00 b8 	movl   $0x7b8,0x7c0
 755:	07 00 00 
    base.s.size = 0;
 758:	b9 b8 07 00 00       	mov    $0x7b8,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 75d:	c7 05 b8 07 00 00 b8 	movl   $0x7b8,0x7b8
 764:	07 00 00 
    base.s.size = 0;
 767:	c7 05 bc 07 00 00 00 	movl   $0x0,0x7bc
 76e:	00 00 00 
 771:	e9 3d ff ff ff       	jmp    6b3 <malloc+0x23>
