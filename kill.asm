
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
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
  int i;

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
   9:	bb 01 00 00 00       	mov    $0x1,%ebx
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   e:	83 ec 14             	sub    $0x14,%esp
  11:	8b 75 08             	mov    0x8(%ebp),%esi
  14:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
  17:	83 fe 01             	cmp    $0x1,%esi
  1a:	7e 24                	jle    40 <main+0x40>
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    kill(atoi(argv[i]));
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 32 01 00 00       	call   160 <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 7f 02 00 00       	call   2b5 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	39 de                	cmp    %ebx,%esi
  38:	7f e6                	jg     20 <main+0x20>
    kill(atoi(argv[i]));
  exit();
  3a:	e8 46 02 00 00       	call   285 <exit>
  3f:	90                   	nop
main(int argc, char **argv)
{
  int i;

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
  40:	c7 44 24 04 56 07 00 	movl   $0x756,0x4(%esp)
  47:	00 
  48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4f:	e8 8c 03 00 00       	call   3e0 <printf>
    exit();
  54:	e8 2c 02 00 00       	call   285 <exit>
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	31 d2                	xor    %edx,%edx
  63:	89 e5                	mov    %esp,%ebp
  65:	8b 45 08             	mov    0x8(%ebp),%eax
  68:	53                   	push   %ebx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 c9                	test   %cl,%cl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	eb 0d                	jmp    90 <strcmp>
  83:	90                   	nop
  84:	90                   	nop
  85:	90                   	nop
  86:	90                   	nop
  87:	90                   	nop
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9a:	0f b6 01             	movzbl (%ecx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 14                	jne    b5 <strcmp+0x25>
  a1:	eb 25                	jmp    c8 <strcmp+0x38>
  a3:	90                   	nop
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 13                	je     c8 <strcmp+0x38>
  b5:	0f b6 1a             	movzbl (%edx),%ebx
  b8:	38 d8                	cmp    %bl,%al
  ba:	74 ec                	je     a8 <strcmp+0x18>
  bc:	0f b6 db             	movzbl %bl,%ebx
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	0f b6 1a             	movzbl (%edx),%ebx
  cb:	31 c0                	xor    %eax,%eax
  cd:	0f b6 db             	movzbl %bl,%ebx
  d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d2:	5b                   	pop    %ebx
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ea:	80 39 00             	cmpb   $0x0,(%ecx)
  ed:	74 0c                	je     fb <strlen+0x1b>
  ef:	90                   	nop
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
 106:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    
 117:	89 f6                	mov    %esi,%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	75 11                	jne    142 <strchr+0x22>
 131:	eb 15                	jmp    148 <strchr+0x28>
 133:	90                   	nop
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 10             	movzbl (%eax),%edx
 13e:	84 d2                	test   %dl,%dl
 140:	74 06                	je     148 <strchr+0x28>
    if(*s == c)
 142:	38 ca                	cmp    %cl,%dl
 144:	75 f2                	jne    138 <strchr+0x18>
      return (char*)s;
  return 0;
}
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 148:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 14a:	5d                   	pop    %ebp
 14b:	90                   	nop
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <atoi>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 160:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 161:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
 168:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 169:	0f b6 11             	movzbl (%ecx),%edx
 16c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 16f:	80 fb 09             	cmp    $0x9,%bl
 172:	77 1c                	ja     190 <atoi+0x30>
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 178:	0f be d2             	movsbl %dl,%edx
 17b:	83 c1 01             	add    $0x1,%ecx
 17e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 181:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 185:	0f b6 11             	movzbl (%ecx),%edx
 188:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18b:	80 fb 09             	cmp    $0x9,%bl
 18e:	76 e8                	jbe    178 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	53                   	push   %ebx
 1a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ae:	85 db                	test   %ebx,%ebx
 1b0:	7e 14                	jle    1c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1b2:	31 d2                	xor    %edx,%edx
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1c2:	39 da                	cmp    %ebx,%edx
 1c4:	75 f2                	jne    1b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1df:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1eb:	00 
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 d1 00 00 00       	call   2c5 <open>
  if(fd < 0)
 1f4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1f8:	78 19                	js     213 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 1c 24             	mov    %ebx,(%esp)
 200:	89 44 24 04          	mov    %eax,0x4(%esp)
 204:	e8 d4 00 00 00       	call   2dd <fstat>
  close(fd);
 209:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 20c:	89 c6                	mov    %eax,%esi
  close(fd);
 20e:	e8 9a 00 00 00       	call   2ad <close>
  return r;
}
 213:	89 f0                	mov    %esi,%eax
 215:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 218:	8b 75 fc             	mov    -0x4(%ebp),%esi
 21b:	89 ec                	mov    %ebp,%esp
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    
 21f:	90                   	nop

00000220 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	31 f6                	xor    %esi,%esi
 227:	53                   	push   %ebx
 228:	83 ec 2c             	sub    $0x2c,%esp
 22b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	eb 06                	jmp    236 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 230:	3c 0a                	cmp    $0xa,%al
 232:	74 39                	je     26d <gets+0x4d>
 234:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	8d 5e 01             	lea    0x1(%esi),%ebx
 239:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23c:	7d 31                	jge    26f <gets+0x4f>
    cc = read(0, &c, 1);
 23e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 241:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 248:	00 
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 44 00 00 00       	call   29d <read>
    if(cc < 1)
 259:	85 c0                	test   %eax,%eax
 25b:	7e 12                	jle    26f <gets+0x4f>
      break;
    buf[i++] = c;
 25d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 261:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 265:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 269:	3c 0d                	cmp    $0xd,%al
 26b:	75 c3                	jne    230 <gets+0x10>
 26d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 26f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 273:	89 f8                	mov    %edi,%eax
 275:	83 c4 2c             	add    $0x2c,%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
 27a:	5f                   	pop    %edi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    

0000027d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27d:	b8 01 00 00 00       	mov    $0x1,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <exit>:
SYSCALL(exit)
 285:	b8 02 00 00 00       	mov    $0x2,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <wait>:
SYSCALL(wait)
 28d:	b8 03 00 00 00       	mov    $0x3,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <pipe>:
SYSCALL(pipe)
 295:	b8 04 00 00 00       	mov    $0x4,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <read>:
SYSCALL(read)
 29d:	b8 05 00 00 00       	mov    $0x5,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <write>:
SYSCALL(write)
 2a5:	b8 10 00 00 00       	mov    $0x10,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <close>:
SYSCALL(close)
 2ad:	b8 15 00 00 00       	mov    $0x15,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <kill>:
SYSCALL(kill)
 2b5:	b8 06 00 00 00       	mov    $0x6,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <exec>:
SYSCALL(exec)
 2bd:	b8 07 00 00 00       	mov    $0x7,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <open>:
SYSCALL(open)
 2c5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <mknod>:
SYSCALL(mknod)
 2cd:	b8 11 00 00 00       	mov    $0x11,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <unlink>:
SYSCALL(unlink)
 2d5:	b8 12 00 00 00       	mov    $0x12,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <fstat>:
SYSCALL(fstat)
 2dd:	b8 08 00 00 00       	mov    $0x8,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <link>:
SYSCALL(link)
 2e5:	b8 13 00 00 00       	mov    $0x13,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <mkdir>:
SYSCALL(mkdir)
 2ed:	b8 14 00 00 00       	mov    $0x14,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <chdir>:
SYSCALL(chdir)
 2f5:	b8 09 00 00 00       	mov    $0x9,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <dup>:
SYSCALL(dup)
 2fd:	b8 0a 00 00 00       	mov    $0xa,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <getpid>:
SYSCALL(getpid)
 305:	b8 0b 00 00 00       	mov    $0xb,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <sbrk>:
SYSCALL(sbrk)
 30d:	b8 0c 00 00 00       	mov    $0xc,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <sleep>:
SYSCALL(sleep)
 315:	b8 0d 00 00 00       	mov    $0xd,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <uptime>:
SYSCALL(uptime)
 31d:	b8 0e 00 00 00       	mov    $0xe,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <date>:
SYSCALL(date)
 325:	b8 16 00 00 00       	mov    $0x16,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <alarm>:
SYSCALL(alarm)
 32d:	b8 17 00 00 00       	mov    $0x17,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    
 335:	66 90                	xchg   %ax,%ax
 337:	66 90                	xchg   %ax,%ax
 339:	66 90                	xchg   %ax,%ax
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	89 cf                	mov    %ecx,%edi
 346:	56                   	push   %esi
 347:	89 c6                	mov    %eax,%esi
 349:	53                   	push   %ebx
 34a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 34d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 350:	85 c9                	test   %ecx,%ecx
 352:	74 04                	je     358 <printint+0x18>
 354:	85 d2                	test   %edx,%edx
 356:	78 70                	js     3c8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 358:	89 d0                	mov    %edx,%eax
 35a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 361:	31 c9                	xor    %ecx,%ecx
 363:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 366:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 368:	31 d2                	xor    %edx,%edx
 36a:	f7 f7                	div    %edi
 36c:	0f b6 92 71 07 00 00 	movzbl 0x771(%edx),%edx
 373:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 376:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 379:	85 c0                	test   %eax,%eax
 37b:	75 eb                	jne    368 <printint+0x28>
  if(neg)
 37d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 380:	85 c0                	test   %eax,%eax
 382:	74 08                	je     38c <printint+0x4c>
    buf[i++] = '-';
 384:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 389:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 38c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 38f:	01 fb                	add    %edi,%ebx
 391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 398:	0f b6 03             	movzbl (%ebx),%eax
 39b:	83 ef 01             	sub    $0x1,%edi
 39e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a8:	00 
 3a9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ac:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3af:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b6:	e8 ea fe ff ff       	call   2a5 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3bb:	83 ff ff             	cmp    $0xffffffff,%edi
 3be:	75 d8                	jne    398 <printint+0x58>
    putc(fd, buf[i]);
}
 3c0:	83 c4 4c             	add    $0x4c,%esp
 3c3:	5b                   	pop    %ebx
 3c4:	5e                   	pop    %esi
 3c5:	5f                   	pop    %edi
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	f7 d8                	neg    %eax
 3cc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3d3:	eb 8c                	jmp    361 <printint+0x21>
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	0f b6 10             	movzbl (%eax),%edx
 3ef:	84 d2                	test   %dl,%dl
 3f1:	0f 84 c9 00 00 00    	je     4c0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3fa:	31 ff                	xor    %edi,%edi
 3fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 3ff:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 401:	8d 75 e7             	lea    -0x19(%ebp),%esi
 404:	eb 1e                	jmp    424 <printf+0x44>
 406:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 408:	83 fa 25             	cmp    $0x25,%edx
 40b:	0f 85 b7 00 00 00    	jne    4c8 <printf+0xe8>
 411:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 415:	83 c3 01             	add    $0x1,%ebx
 418:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 41c:	84 d2                	test   %dl,%dl
 41e:	0f 84 9c 00 00 00    	je     4c0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 424:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 426:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 429:	74 dd                	je     408 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 42b:	83 ff 25             	cmp    $0x25,%edi
 42e:	75 e5                	jne    415 <printf+0x35>
      if(c == 'd'){
 430:	83 fa 64             	cmp    $0x64,%edx
 433:	0f 84 47 01 00 00    	je     580 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 439:	83 fa 70             	cmp    $0x70,%edx
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 440:	0f 84 aa 00 00 00    	je     4f0 <printf+0x110>
 446:	83 fa 78             	cmp    $0x78,%edx
 449:	0f 84 a1 00 00 00    	je     4f0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 44f:	83 fa 73             	cmp    $0x73,%edx
 452:	0f 84 c0 00 00 00    	je     518 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 458:	83 fa 63             	cmp    $0x63,%edx
 45b:	90                   	nop
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 460:	0f 84 42 01 00 00    	je     5a8 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 466:	83 fa 25             	cmp    $0x25,%edx
 469:	0f 84 01 01 00 00    	je     570 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 472:	89 55 cc             	mov    %edx,-0x34(%ebp)
 475:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 480:	00 
 481:	89 74 24 04          	mov    %esi,0x4(%esp)
 485:	89 0c 24             	mov    %ecx,(%esp)
 488:	e8 18 fe ff ff       	call   2a5 <write>
 48d:	8b 55 cc             	mov    -0x34(%ebp),%edx
 490:	88 55 e7             	mov    %dl,-0x19(%ebp)
 493:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 496:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 499:	31 ff                	xor    %edi,%edi
 49b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a2:	00 
 4a3:	89 74 24 04          	mov    %esi,0x4(%esp)
 4a7:	89 04 24             	mov    %eax,(%esp)
 4aa:	e8 f6 fd ff ff       	call   2a5 <write>
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4b6:	84 d2                	test   %dl,%dl
 4b8:	0f 85 66 ff ff ff    	jne    424 <printf+0x44>
 4be:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c0:	83 c4 3c             	add    $0x3c,%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4cb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d5:	00 
 4d6:	89 74 24 04          	mov    %esi,0x4(%esp)
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 c3 fd ff ff       	call   2a5 <write>
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	e9 2b ff ff ff       	jmp    415 <printf+0x35>
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4f8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 501:	8b 10                	mov    (%eax),%edx
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	e8 35 fe ff ff       	call   340 <printint>
 50b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 50e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 512:	e9 fe fe ff ff       	jmp    415 <printf+0x35>
 517:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 518:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 51b:	b9 6a 07 00 00       	mov    $0x76a,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 520:	8b 3a                	mov    (%edx),%edi
        ap++;
 522:	83 c2 04             	add    $0x4,%edx
 525:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 528:	85 ff                	test   %edi,%edi
 52a:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 52d:	0f b6 17             	movzbl (%edi),%edx
 530:	84 d2                	test   %dl,%dl
 532:	74 33                	je     567 <printf+0x187>
 534:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 537:	8b 5d 08             	mov    0x8(%ebp),%ebx
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 540:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 543:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 546:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 54d:	00 
 54e:	89 74 24 04          	mov    %esi,0x4(%esp)
 552:	89 1c 24             	mov    %ebx,(%esp)
 555:	e8 4b fd ff ff       	call   2a5 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55a:	0f b6 17             	movzbl (%edi),%edx
 55d:	84 d2                	test   %dl,%dl
 55f:	75 df                	jne    540 <printf+0x160>
 561:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 564:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 567:	31 ff                	xor    %edi,%edi
 569:	e9 a7 fe ff ff       	jmp    415 <printf+0x35>
 56e:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 570:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 574:	e9 1a ff ff ff       	jmp    493 <printf+0xb3>
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 583:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 588:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 58b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 592:	8b 10                	mov    (%eax),%edx
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	e8 a4 fd ff ff       	call   340 <printint>
 59c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 59f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5a3:	e9 6d fe ff ff       	jmp    415 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 5ab:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b0:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b9:	00 
 5ba:	89 74 24 04          	mov    %esi,0x4(%esp)
 5be:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c1:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c4:	e8 dc fc ff ff       	call   2a5 <write>
 5c9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5cc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5d0:	e9 40 fe ff ff       	jmp    415 <printf+0x35>
 5d5:	66 90                	xchg   %ax,%ax
 5d7:	66 90                	xchg   %ax,%ax
 5d9:	66 90                	xchg   %ax,%ax
 5db:	66 90                	xchg   %ax,%ax
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 8c 07 00 00       	mov    0x78c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	39 c8                	cmp    %ecx,%eax
 5f3:	73 1d                	jae    612 <free+0x32>
 5f5:	8d 76 00             	lea    0x0(%esi),%esi
 5f8:	8b 10                	mov    (%eax),%edx
 5fa:	39 d1                	cmp    %edx,%ecx
 5fc:	72 1a                	jb     618 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fe:	39 d0                	cmp    %edx,%eax
 600:	72 08                	jb     60a <free+0x2a>
 602:	39 c8                	cmp    %ecx,%eax
 604:	72 12                	jb     618 <free+0x38>
 606:	39 d1                	cmp    %edx,%ecx
 608:	72 0e                	jb     618 <free+0x38>
 60a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	66 90                	xchg   %ax,%ax
 610:	72 e6                	jb     5f8 <free+0x18>
 612:	8b 10                	mov    (%eax),%edx
 614:	eb e8                	jmp    5fe <free+0x1e>
 616:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 618:	8b 71 04             	mov    0x4(%ecx),%esi
 61b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61e:	39 d7                	cmp    %edx,%edi
 620:	74 19                	je     63b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 622:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62b:	39 ce                	cmp    %ecx,%esi
 62d:	74 23                	je     652 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 62f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 631:	a3 8c 07 00 00       	mov    %eax,0x78c
}
 636:	5b                   	pop    %ebx
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 63b:	03 72 04             	add    0x4(%edx),%esi
 63e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 641:	8b 10                	mov    (%eax),%edx
 643:	8b 12                	mov    (%edx),%edx
 645:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 648:	8b 50 04             	mov    0x4(%eax),%edx
 64b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64e:	39 ce                	cmp    %ecx,%esi
 650:	75 dd                	jne    62f <free+0x4f>
    p->s.size += bp->s.size;
 652:	03 51 04             	add    0x4(%ecx),%edx
 655:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 658:	8b 53 f8             	mov    -0x8(%ebx),%edx
 65b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 65d:	a3 8c 07 00 00       	mov    %eax,0x78c
}
 662:	5b                   	pop    %ebx
 663:	5e                   	pop    %esi
 664:	5f                   	pop    %edi
 665:	5d                   	pop    %ebp
 666:	c3                   	ret    
 667:	89 f6                	mov    %esi,%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 67c:	8b 0d 8c 07 00 00    	mov    0x78c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	83 c3 07             	add    $0x7,%ebx
 685:	c1 eb 03             	shr    $0x3,%ebx
 688:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 68b:	85 c9                	test   %ecx,%ecx
 68d:	0f 84 9b 00 00 00    	je     72e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	39 d3                	cmp    %edx,%ebx
 69a:	76 27                	jbe    6c3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 69c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6a3:	be 00 80 00 00       	mov    $0x8000,%esi
 6a8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6ab:	90                   	nop
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b0:	3b 05 8c 07 00 00    	cmp    0x78c,%eax
 6b6:	74 30                	je     6e8 <malloc+0x78>
 6b8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ba:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6bc:	8b 50 04             	mov    0x4(%eax),%edx
 6bf:	39 d3                	cmp    %edx,%ebx
 6c1:	77 ed                	ja     6b0 <malloc+0x40>
      if(p->s.size == nunits)
 6c3:	39 d3                	cmp    %edx,%ebx
 6c5:	74 61                	je     728 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6c7:	29 da                	sub    %ebx,%edx
 6c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6cc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6cf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6d2:	89 0d 8c 07 00 00    	mov    %ecx,0x78c
      return (void*)(p + 1);
 6d8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6db:	83 c4 2c             	add    $0x2c,%esp
 6de:	5b                   	pop    %ebx
 6df:	5e                   	pop    %esi
 6e0:	5f                   	pop    %edi
 6e1:	5d                   	pop    %ebp
 6e2:	c3                   	ret    
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6eb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6f1:	bf 00 10 00 00       	mov    $0x1000,%edi
 6f6:	0f 43 fb             	cmovae %ebx,%edi
 6f9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6fc:	89 04 24             	mov    %eax,(%esp)
 6ff:	e8 09 fc ff ff       	call   30d <sbrk>
  if(p == (char*)-1)
 704:	83 f8 ff             	cmp    $0xffffffff,%eax
 707:	74 18                	je     721 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 709:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 70c:	83 c0 08             	add    $0x8,%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 c9 fe ff ff       	call   5e0 <free>
  return freep;
 717:	8b 0d 8c 07 00 00    	mov    0x78c,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 71d:	85 c9                	test   %ecx,%ecx
 71f:	75 99                	jne    6ba <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 721:	31 c0                	xor    %eax,%eax
 723:	eb b6                	jmp    6db <malloc+0x6b>
 725:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 728:	8b 10                	mov    (%eax),%edx
 72a:	89 11                	mov    %edx,(%ecx)
 72c:	eb a4                	jmp    6d2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 72e:	c7 05 8c 07 00 00 84 	movl   $0x784,0x78c
 735:	07 00 00 
    base.s.size = 0;
 738:	b9 84 07 00 00       	mov    $0x784,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 73d:	c7 05 84 07 00 00 84 	movl   $0x784,0x784
 744:	07 00 00 
    base.s.size = 0;
 747:	c7 05 88 07 00 00 00 	movl   $0x0,0x788
 74e:	00 00 00 
 751:	e9 3d ff ff ff       	jmp    693 <malloc+0x23>
