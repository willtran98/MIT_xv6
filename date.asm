
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "date.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 40             	sub    $0x40,%esp
    struct rtcdate r;

      if (date(&r)) {
   9:	8d 44 24 28          	lea    0x28(%esp),%eax
   d:	89 04 24             	mov    %eax,(%esp)
  10:	e8 40 03 00 00       	call   355 <date>
  15:	85 c0                	test   %eax,%eax
  17:	74 1f                	je     38 <main+0x38>
            printf(2, "date failed\n");
  19:	c7 44 24 04 88 07 00 	movl   $0x788,0x4(%esp)
  20:	00 
  21:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  28:	e8 e3 03 00 00       	call   410 <printf>
                exit();
  2d:	e8 83 02 00 00       	call   2b5 <exit>
  32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                  }

        // your code to print the time in any format you like...
      printf(1, "Current Date and Time: Day:%d Month:%d Year:%d,  %d:%d:%d\n", r.day, r.month, r.year, r.hour, r.minute, r.second);
  38:	8b 44 24 28          	mov    0x28(%esp),%eax
  3c:	c7 44 24 04 98 07 00 	movl   $0x798,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  4f:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  53:	89 44 24 18          	mov    %eax,0x18(%esp)
  57:	8b 44 24 30          	mov    0x30(%esp),%eax
  5b:	89 44 24 14          	mov    %eax,0x14(%esp)
  5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  63:	89 44 24 10          	mov    %eax,0x10(%esp)
  67:	8b 44 24 38          	mov    0x38(%esp),%eax
  6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  6f:	8b 44 24 34          	mov    0x34(%esp),%eax
  73:	89 44 24 08          	mov    %eax,0x8(%esp)
  77:	e8 94 03 00 00       	call   410 <printf>

        exit();
  7c:	e8 34 02 00 00       	call   2b5 <exit>
  81:	66 90                	xchg   %ax,%ax
  83:	66 90                	xchg   %ax,%ax
  85:	66 90                	xchg   %ax,%ax
  87:	66 90                	xchg   %ax,%ax
  89:	66 90                	xchg   %ax,%ax
  8b:	66 90                	xchg   %ax,%ax
  8d:	66 90                	xchg   %ax,%ax
  8f:	90                   	nop

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  90:	55                   	push   %ebp
  91:	31 d2                	xor    %edx,%edx
  93:	89 e5                	mov    %esp,%ebp
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	53                   	push   %ebx
  99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  a7:	83 c2 01             	add    $0x1,%edx
  aa:	84 c9                	test   %cl,%cl
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	5b                   	pop    %ebx
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    
  b1:	eb 0d                	jmp    c0 <strcmp>
  b3:	90                   	nop
  b4:	90                   	nop
  b5:	90                   	nop
  b6:	90                   	nop
  b7:	90                   	nop
  b8:	90                   	nop
  b9:	90                   	nop
  ba:	90                   	nop
  bb:	90                   	nop
  bc:	90                   	nop
  bd:	90                   	nop
  be:	90                   	nop
  bf:	90                   	nop

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ca:	0f b6 01             	movzbl (%ecx),%eax
  cd:	84 c0                	test   %al,%al
  cf:	75 14                	jne    e5 <strcmp+0x25>
  d1:	eb 25                	jmp    f8 <strcmp+0x38>
  d3:	90                   	nop
  d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  d8:	83 c1 01             	add    $0x1,%ecx
  db:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  de:	0f b6 01             	movzbl (%ecx),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 13                	je     f8 <strcmp+0x38>
  e5:	0f b6 1a             	movzbl (%edx),%ebx
  e8:	38 d8                	cmp    %bl,%al
  ea:	74 ec                	je     d8 <strcmp+0x18>
  ec:	0f b6 db             	movzbl %bl,%ebx
  ef:	0f b6 c0             	movzbl %al,%eax
  f2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f4:	5b                   	pop    %ebx
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f8:	0f b6 1a             	movzbl (%edx),%ebx
  fb:	31 c0                	xor    %eax,%eax
  fd:	0f b6 db             	movzbl %bl,%ebx
 100:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 102:	5b                   	pop    %ebx
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <strlen>:

uint
strlen(char *s)
{
 110:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 111:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 113:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 115:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 11a:	80 39 00             	cmpb   $0x0,(%ecx)
 11d:	74 0c                	je     12b <strlen+0x1b>
 11f:	90                   	nop
 120:	83 c2 01             	add    $0x1,%edx
 123:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 127:	89 d0                	mov    %edx,%eax
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 55 08             	mov    0x8(%ebp),%edx
 136:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	89 d0                	mov    %edx,%eax
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    
 147:	89 f6                	mov    %esi,%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 11                	jne    172 <strchr+0x22>
 161:	eb 15                	jmp    178 <strchr+0x28>
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 168:	83 c0 01             	add    $0x1,%eax
 16b:	0f b6 10             	movzbl (%eax),%edx
 16e:	84 d2                	test   %dl,%dl
 170:	74 06                	je     178 <strchr+0x28>
    if(*s == c)
 172:	38 ca                	cmp    %cl,%dl
 174:	75 f2                	jne    168 <strchr+0x18>
      return (char*)s;
  return 0;
}
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 178:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 17a:	5d                   	pop    %ebp
 17b:	90                   	nop
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <atoi>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 190:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 191:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 193:	89 e5                	mov    %esp,%ebp
 195:	8b 4d 08             	mov    0x8(%ebp),%ecx
 198:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 199:	0f b6 11             	movzbl (%ecx),%edx
 19c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 19f:	80 fb 09             	cmp    $0x9,%bl
 1a2:	77 1c                	ja     1c0 <atoi+0x30>
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 1a8:	0f be d2             	movsbl %dl,%edx
 1ab:	83 c1 01             	add    $0x1,%ecx
 1ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1b1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 11             	movzbl (%ecx),%edx
 1b8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1bb:	80 fb 09             	cmp    $0x9,%bl
 1be:	76 e8                	jbe    1a8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	53                   	push   %ebx
 1d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1de:	85 db                	test   %ebx,%ebx
 1e0:	7e 14                	jle    1f6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1e2:	31 d2                	xor    %edx,%edx
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	39 da                	cmp    %ebx,%edx
 1f4:	75 f2                	jne    1e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1f6:	5b                   	pop    %ebx
 1f7:	5e                   	pop    %esi
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 209:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 20c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 20f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21b:	00 
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 d1 00 00 00       	call   2f5 <open>
  if(fd < 0)
 224:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 228:	78 19                	js     243 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 1c 24             	mov    %ebx,(%esp)
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	e8 d4 00 00 00       	call   30d <fstat>
  close(fd);
 239:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 23c:	89 c6                	mov    %eax,%esi
  close(fd);
 23e:	e8 9a 00 00 00       	call   2dd <close>
  return r;
}
 243:	89 f0                	mov    %esi,%eax
 245:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 248:	8b 75 fc             	mov    -0x4(%ebp),%esi
 24b:	89 ec                	mov    %ebp,%esp
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    
 24f:	90                   	nop

00000250 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	31 f6                	xor    %esi,%esi
 257:	53                   	push   %ebx
 258:	83 ec 2c             	sub    $0x2c,%esp
 25b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	eb 06                	jmp    266 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	3c 0a                	cmp    $0xa,%al
 262:	74 39                	je     29d <gets+0x4d>
 264:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	8d 5e 01             	lea    0x1(%esi),%ebx
 269:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 26c:	7d 31                	jge    29f <gets+0x4f>
    cc = read(0, &c, 1);
 26e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 271:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 278:	00 
 279:	89 44 24 04          	mov    %eax,0x4(%esp)
 27d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 284:	e8 44 00 00 00       	call   2cd <read>
    if(cc < 1)
 289:	85 c0                	test   %eax,%eax
 28b:	7e 12                	jle    29f <gets+0x4f>
      break;
    buf[i++] = c;
 28d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 291:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 299:	3c 0d                	cmp    $0xd,%al
 29b:	75 c3                	jne    260 <gets+0x10>
 29d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 29f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2a3:	89 f8                	mov    %edi,%eax
 2a5:	83 c4 2c             	add    $0x2c,%esp
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    

000002ad <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <exit>:
SYSCALL(exit)
 2b5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <wait>:
SYSCALL(wait)
 2bd:	b8 03 00 00 00       	mov    $0x3,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <pipe>:
SYSCALL(pipe)
 2c5:	b8 04 00 00 00       	mov    $0x4,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <read>:
SYSCALL(read)
 2cd:	b8 05 00 00 00       	mov    $0x5,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <write>:
SYSCALL(write)
 2d5:	b8 10 00 00 00       	mov    $0x10,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <close>:
SYSCALL(close)
 2dd:	b8 15 00 00 00       	mov    $0x15,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <kill>:
SYSCALL(kill)
 2e5:	b8 06 00 00 00       	mov    $0x6,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <exec>:
SYSCALL(exec)
 2ed:	b8 07 00 00 00       	mov    $0x7,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <open>:
SYSCALL(open)
 2f5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <mknod>:
SYSCALL(mknod)
 2fd:	b8 11 00 00 00       	mov    $0x11,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <unlink>:
SYSCALL(unlink)
 305:	b8 12 00 00 00       	mov    $0x12,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <fstat>:
SYSCALL(fstat)
 30d:	b8 08 00 00 00       	mov    $0x8,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <link>:
SYSCALL(link)
 315:	b8 13 00 00 00       	mov    $0x13,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <mkdir>:
SYSCALL(mkdir)
 31d:	b8 14 00 00 00       	mov    $0x14,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <chdir>:
SYSCALL(chdir)
 325:	b8 09 00 00 00       	mov    $0x9,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <dup>:
SYSCALL(dup)
 32d:	b8 0a 00 00 00       	mov    $0xa,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <getpid>:
SYSCALL(getpid)
 335:	b8 0b 00 00 00       	mov    $0xb,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <sbrk>:
SYSCALL(sbrk)
 33d:	b8 0c 00 00 00       	mov    $0xc,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <sleep>:
SYSCALL(sleep)
 345:	b8 0d 00 00 00       	mov    $0xd,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <uptime>:
SYSCALL(uptime)
 34d:	b8 0e 00 00 00       	mov    $0xe,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <date>:
SYSCALL(date)
 355:	b8 16 00 00 00       	mov    $0x16,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <alarm>:
SYSCALL(alarm)
 35d:	b8 17 00 00 00       	mov    $0x17,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    
 365:	66 90                	xchg   %ax,%ax
 367:	66 90                	xchg   %ax,%ax
 369:	66 90                	xchg   %ax,%ax
 36b:	66 90                	xchg   %ax,%ax
 36d:	66 90                	xchg   %ax,%ax
 36f:	90                   	nop

00000370 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	89 cf                	mov    %ecx,%edi
 376:	56                   	push   %esi
 377:	89 c6                	mov    %eax,%esi
 379:	53                   	push   %ebx
 37a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 380:	85 c9                	test   %ecx,%ecx
 382:	74 04                	je     388 <printint+0x18>
 384:	85 d2                	test   %edx,%edx
 386:	78 70                	js     3f8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 388:	89 d0                	mov    %edx,%eax
 38a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 391:	31 c9                	xor    %ecx,%ecx
 393:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 396:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 398:	31 d2                	xor    %edx,%edx
 39a:	f7 f7                	div    %edi
 39c:	0f b6 92 db 07 00 00 	movzbl 0x7db(%edx),%edx
 3a3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3a6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3a9:	85 c0                	test   %eax,%eax
 3ab:	75 eb                	jne    398 <printint+0x28>
  if(neg)
 3ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b0:	85 c0                	test   %eax,%eax
 3b2:	74 08                	je     3bc <printint+0x4c>
    buf[i++] = '-';
 3b4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 3b9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3bc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3bf:	01 fb                	add    %edi,%ebx
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3c8:	0f b6 03             	movzbl (%ebx),%eax
 3cb:	83 ef 01             	sub    $0x1,%edi
 3ce:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d8:	00 
 3d9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3df:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e6:	e8 ea fe ff ff       	call   2d5 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3eb:	83 ff ff             	cmp    $0xffffffff,%edi
 3ee:	75 d8                	jne    3c8 <printint+0x58>
    putc(fd, buf[i]);
}
 3f0:	83 c4 4c             	add    $0x4c,%esp
 3f3:	5b                   	pop    %ebx
 3f4:	5e                   	pop    %esi
 3f5:	5f                   	pop    %edi
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	f7 d8                	neg    %eax
 3fc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 403:	eb 8c                	jmp    391 <printint+0x21>
 405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	0f b6 10             	movzbl (%eax),%edx
 41f:	84 d2                	test   %dl,%dl
 421:	0f 84 c9 00 00 00    	je     4f0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 4d 10             	lea    0x10(%ebp),%ecx
 42a:	31 ff                	xor    %edi,%edi
 42c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 42f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 431:	8d 75 e7             	lea    -0x19(%ebp),%esi
 434:	eb 1e                	jmp    454 <printf+0x44>
 436:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 438:	83 fa 25             	cmp    $0x25,%edx
 43b:	0f 85 b7 00 00 00    	jne    4f8 <printf+0xe8>
 441:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 445:	83 c3 01             	add    $0x1,%ebx
 448:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 44c:	84 d2                	test   %dl,%dl
 44e:	0f 84 9c 00 00 00    	je     4f0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 454:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 456:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 459:	74 dd                	je     438 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45b:	83 ff 25             	cmp    $0x25,%edi
 45e:	75 e5                	jne    445 <printf+0x35>
      if(c == 'd'){
 460:	83 fa 64             	cmp    $0x64,%edx
 463:	0f 84 47 01 00 00    	je     5b0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 469:	83 fa 70             	cmp    $0x70,%edx
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 470:	0f 84 aa 00 00 00    	je     520 <printf+0x110>
 476:	83 fa 78             	cmp    $0x78,%edx
 479:	0f 84 a1 00 00 00    	je     520 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 47f:	83 fa 73             	cmp    $0x73,%edx
 482:	0f 84 c0 00 00 00    	je     548 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 488:	83 fa 63             	cmp    $0x63,%edx
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	0f 84 42 01 00 00    	je     5d8 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 496:	83 fa 25             	cmp    $0x25,%edx
 499:	0f 84 01 01 00 00    	je     5a0 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a2:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4a5:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4a9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b0:	00 
 4b1:	89 74 24 04          	mov    %esi,0x4(%esp)
 4b5:	89 0c 24             	mov    %ecx,(%esp)
 4b8:	e8 18 fe ff ff       	call   2d5 <write>
 4bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
 4c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c6:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c9:	31 ff                	xor    %edi,%edi
 4cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d2:	00 
 4d3:	89 74 24 04          	mov    %esi,0x4(%esp)
 4d7:	89 04 24             	mov    %eax,(%esp)
 4da:	e8 f6 fd ff ff       	call   2d5 <write>
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4e6:	84 d2                	test   %dl,%dl
 4e8:	0f 85 66 ff ff ff    	jne    454 <printf+0x44>
 4ee:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4f0:	83 c4 3c             	add    $0x3c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
 506:	89 74 24 04          	mov    %esi,0x4(%esp)
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 c3 fd ff ff       	call   2d5 <write>
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	e9 2b ff ff ff       	jmp    445 <printf+0x35>
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 528:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 52a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 531:	8b 10                	mov    (%eax),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 35 fe ff ff       	call   370 <printint>
 53b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 53e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 542:	e9 fe fe ff ff       	jmp    445 <printf+0x35>
 547:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 548:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 54b:	b9 d4 07 00 00       	mov    $0x7d4,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 550:	8b 3a                	mov    (%edx),%edi
        ap++;
 552:	83 c2 04             	add    $0x4,%edx
 555:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 558:	85 ff                	test   %edi,%edi
 55a:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 55d:	0f b6 17             	movzbl (%edi),%edx
 560:	84 d2                	test   %dl,%dl
 562:	74 33                	je     597 <printf+0x187>
 564:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 567:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 570:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 573:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 576:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 57d:	00 
 57e:	89 74 24 04          	mov    %esi,0x4(%esp)
 582:	89 1c 24             	mov    %ebx,(%esp)
 585:	e8 4b fd ff ff       	call   2d5 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58a:	0f b6 17             	movzbl (%edi),%edx
 58d:	84 d2                	test   %dl,%dl
 58f:	75 df                	jne    570 <printf+0x160>
 591:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 597:	31 ff                	xor    %edi,%edi
 599:	e9 a7 fe ff ff       	jmp    445 <printf+0x35>
 59e:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5a0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5a4:	e9 1a ff ff ff       	jmp    4c3 <printf+0xb3>
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5b8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5c2:	8b 10                	mov    (%eax),%edx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	e8 a4 fd ff ff       	call   370 <printint>
 5cc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5cf:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5d3:	e9 6d fe ff ff       	jmp    445 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 5db:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e0:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e9:	00 
 5ea:	89 74 24 04          	mov    %esi,0x4(%esp)
 5ee:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f1:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f4:	e8 dc fc ff ff       	call   2d5 <write>
 5f9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5fc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 600:	e9 40 fe ff ff       	jmp    445 <printf+0x35>
 605:	66 90                	xchg   %ax,%ax
 607:	66 90                	xchg   %ax,%ax
 609:	66 90                	xchg   %ax,%ax
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 f4 07 00 00       	mov    0x7f4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	39 c8                	cmp    %ecx,%eax
 623:	73 1d                	jae    642 <free+0x32>
 625:	8d 76 00             	lea    0x0(%esi),%esi
 628:	8b 10                	mov    (%eax),%edx
 62a:	39 d1                	cmp    %edx,%ecx
 62c:	72 1a                	jb     648 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	39 d0                	cmp    %edx,%eax
 630:	72 08                	jb     63a <free+0x2a>
 632:	39 c8                	cmp    %ecx,%eax
 634:	72 12                	jb     648 <free+0x38>
 636:	39 d1                	cmp    %edx,%ecx
 638:	72 0e                	jb     648 <free+0x38>
 63a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	39 c8                	cmp    %ecx,%eax
 63e:	66 90                	xchg   %ax,%ax
 640:	72 e6                	jb     628 <free+0x18>
 642:	8b 10                	mov    (%eax),%edx
 644:	eb e8                	jmp    62e <free+0x1e>
 646:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 71 04             	mov    0x4(%ecx),%esi
 64b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64e:	39 d7                	cmp    %edx,%edi
 650:	74 19                	je     66b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 652:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 65b:	39 ce                	cmp    %ecx,%esi
 65d:	74 23                	je     682 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 65f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 661:	a3 f4 07 00 00       	mov    %eax,0x7f4
}
 666:	5b                   	pop    %ebx
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 66b:	03 72 04             	add    0x4(%edx),%esi
 66e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 671:	8b 10                	mov    (%eax),%edx
 673:	8b 12                	mov    (%edx),%edx
 675:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 678:	8b 50 04             	mov    0x4(%eax),%edx
 67b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 67e:	39 ce                	cmp    %ecx,%esi
 680:	75 dd                	jne    65f <free+0x4f>
    p->s.size += bp->s.size;
 682:	03 51 04             	add    0x4(%ecx),%edx
 685:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 688:	8b 53 f8             	mov    -0x8(%ebx),%edx
 68b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 68d:	a3 f4 07 00 00       	mov    %eax,0x7f4
}
 692:	5b                   	pop    %ebx
 693:	5e                   	pop    %esi
 694:	5f                   	pop    %edi
 695:	5d                   	pop    %ebp
 696:	c3                   	ret    
 697:	89 f6                	mov    %esi,%esi
 699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6ac:	8b 0d f4 07 00 00    	mov    0x7f4,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	83 c3 07             	add    $0x7,%ebx
 6b5:	c1 eb 03             	shr    $0x3,%ebx
 6b8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6bb:	85 c9                	test   %ecx,%ecx
 6bd:	0f 84 9b 00 00 00    	je     75e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	39 d3                	cmp    %edx,%ebx
 6ca:	76 27                	jbe    6f3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 6cc:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6d3:	be 00 80 00 00       	mov    $0x8000,%esi
 6d8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6db:	90                   	nop
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e0:	3b 05 f4 07 00 00    	cmp    0x7f4,%eax
 6e6:	74 30                	je     718 <malloc+0x78>
 6e8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ea:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6ec:	8b 50 04             	mov    0x4(%eax),%edx
 6ef:	39 d3                	cmp    %edx,%ebx
 6f1:	77 ed                	ja     6e0 <malloc+0x40>
      if(p->s.size == nunits)
 6f3:	39 d3                	cmp    %edx,%ebx
 6f5:	74 61                	je     758 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6f7:	29 da                	sub    %ebx,%edx
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6fc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6ff:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 702:	89 0d f4 07 00 00    	mov    %ecx,0x7f4
      return (void*)(p + 1);
 708:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 70b:	83 c4 2c             	add    $0x2c,%esp
 70e:	5b                   	pop    %ebx
 70f:	5e                   	pop    %esi
 710:	5f                   	pop    %edi
 711:	5d                   	pop    %ebp
 712:	c3                   	ret    
 713:	90                   	nop
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 721:	bf 00 10 00 00       	mov    $0x1000,%edi
 726:	0f 43 fb             	cmovae %ebx,%edi
 729:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 72c:	89 04 24             	mov    %eax,(%esp)
 72f:	e8 09 fc ff ff       	call   33d <sbrk>
  if(p == (char*)-1)
 734:	83 f8 ff             	cmp    $0xffffffff,%eax
 737:	74 18                	je     751 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 739:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 73c:	83 c0 08             	add    $0x8,%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 c9 fe ff ff       	call   610 <free>
  return freep;
 747:	8b 0d f4 07 00 00    	mov    0x7f4,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 74d:	85 c9                	test   %ecx,%ecx
 74f:	75 99                	jne    6ea <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 751:	31 c0                	xor    %eax,%eax
 753:	eb b6                	jmp    70b <malloc+0x6b>
 755:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 758:	8b 10                	mov    (%eax),%edx
 75a:	89 11                	mov    %edx,(%ecx)
 75c:	eb a4                	jmp    702 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 75e:	c7 05 f4 07 00 00 ec 	movl   $0x7ec,0x7f4
 765:	07 00 00 
    base.s.size = 0;
 768:	b9 ec 07 00 00       	mov    $0x7ec,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 76d:	c7 05 ec 07 00 00 ec 	movl   $0x7ec,0x7ec
 774:	07 00 00 
    base.s.size = 0;
 777:	c7 05 f0 07 00 00 00 	movl   $0x0,0x7f0
 77e:	00 00 00 
 781:	e9 3d ff ff ff       	jmp    6c3 <malloc+0x23>
