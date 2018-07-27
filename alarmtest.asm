
_alarmtest:     file format elf32-i386


Disassembly of section .text:

00000000 <periodic>:
            exit();
}

void
periodic()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    printf(1, "alarm!\n");
   6:	c7 44 24 04 c6 07 00 	movl   $0x7c6,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 36 04 00 00       	call   450 <printf>
}
  1a:	c9                   	leave  
  1b:	c3                   	ret    
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000020 <main>:

void periodic();

int
main(int argc, char *argv[])
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	83 e4 f0             	and    $0xfffffff0,%esp
  26:	53                   	push   %ebx
  27:	83 ec 2c             	sub    $0x2c,%esp
    volatile int i;
      printf(1, "alarmtest starting\n");
  2a:	c7 44 24 04 ce 07 00 	movl   $0x7ce,0x4(%esp)
  31:	00 
  32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  39:	e8 12 04 00 00       	call   450 <printf>
        alarm(10, periodic);
  3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  45:	00 
  46:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  4d:	e8 4b 03 00 00       	call   39d <alarm>
          for(i = 0; i < 25*500000; i++){
  52:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  59:	00 
  5a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5e:	3d 1f bc be 00       	cmp    $0xbebc1f,%eax
  63:	7f 5b                	jg     c0 <main+0xa0>
                if((i % 250000) == 0)
  65:	bb 83 de 1b 43       	mov    $0x431bde83,%ebx
  6a:	eb 1a                	jmp    86 <main+0x66>
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
main(int argc, char *argv[])
{
    volatile int i;
      printf(1, "alarmtest starting\n");
        alarm(10, periodic);
          for(i = 0; i < 25*500000; i++){
  70:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  74:	83 c0 01             	add    $0x1,%eax
  77:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  7b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  7f:	3d 1f bc be 00       	cmp    $0xbebc1f,%eax
  84:	7f 3a                	jg     c0 <main+0xa0>
                if((i % 250000) == 0)
  86:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  8a:	89 c8                	mov    %ecx,%eax
  8c:	f7 eb                	imul   %ebx
  8e:	89 c8                	mov    %ecx,%eax
  90:	c1 f8 1f             	sar    $0x1f,%eax
  93:	c1 fa 10             	sar    $0x10,%edx
  96:	29 c2                	sub    %eax,%edx
  98:	69 d2 90 d0 03 00    	imul   $0x3d090,%edx,%edx
  9e:	39 d1                	cmp    %edx,%ecx
  a0:	75 ce                	jne    70 <main+0x50>
                        write(2, ".", 1);
  a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  a9:	00 
  aa:	c7 44 24 04 e2 07 00 	movl   $0x7e2,0x4(%esp)
  b1:	00 
  b2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  b9:	e8 57 02 00 00       	call   315 <write>
  be:	eb b0                	jmp    70 <main+0x50>
                  }
            exit();
  c0:	e8 30 02 00 00       	call   2f5 <exit>
  c5:	66 90                	xchg   %ax,%ax
  c7:	66 90                	xchg   %ax,%ax
  c9:	66 90                	xchg   %ax,%ax
  cb:	66 90                	xchg   %ax,%ax
  cd:	66 90                	xchg   %ax,%ax
  cf:	90                   	nop

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d0:	55                   	push   %ebp
  d1:	31 d2                	xor    %edx,%edx
  d3:	89 e5                	mov    %esp,%ebp
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	53                   	push   %ebx
  d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  e7:	83 c2 01             	add    $0x1,%edx
  ea:	84 c9                	test   %cl,%cl
  ec:	75 f2                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ee:	5b                   	pop    %ebx
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    
  f1:	eb 0d                	jmp    100 <strcmp>
  f3:	90                   	nop
  f4:	90                   	nop
  f5:	90                   	nop
  f6:	90                   	nop
  f7:	90                   	nop
  f8:	90                   	nop
  f9:	90                   	nop
  fa:	90                   	nop
  fb:	90                   	nop
  fc:	90                   	nop
  fd:	90                   	nop
  fe:	90                   	nop
  ff:	90                   	nop

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10a:	0f b6 01             	movzbl (%ecx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	75 14                	jne    125 <strcmp+0x25>
 111:	eb 25                	jmp    138 <strcmp+0x38>
 113:	90                   	nop
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 118:	83 c1 01             	add    $0x1,%ecx
 11b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11e:	0f b6 01             	movzbl (%ecx),%eax
 121:	84 c0                	test   %al,%al
 123:	74 13                	je     138 <strcmp+0x38>
 125:	0f b6 1a             	movzbl (%edx),%ebx
 128:	38 d8                	cmp    %bl,%al
 12a:	74 ec                	je     118 <strcmp+0x18>
 12c:	0f b6 db             	movzbl %bl,%ebx
 12f:	0f b6 c0             	movzbl %al,%eax
 132:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 134:	5b                   	pop    %ebx
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 138:	0f b6 1a             	movzbl (%edx),%ebx
 13b:	31 c0                	xor    %eax,%eax
 13d:	0f b6 db             	movzbl %bl,%ebx
 140:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 142:	5b                   	pop    %ebx
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strlen>:

uint
strlen(char *s)
{
 150:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 151:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 153:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 155:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 15a:	80 39 00             	cmpb   $0x0,(%ecx)
 15d:	74 0c                	je     16b <strlen+0x1b>
 15f:	90                   	nop
 160:	83 c2 01             	add    $0x1,%edx
 163:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 167:	89 d0                	mov    %edx,%eax
 169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
 16d:	8d 76 00             	lea    0x0(%esi),%esi

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
 176:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	75 11                	jne    1b2 <strchr+0x22>
 1a1:	eb 15                	jmp    1b8 <strchr+0x28>
 1a3:	90                   	nop
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a8:	83 c0 01             	add    $0x1,%eax
 1ab:	0f b6 10             	movzbl (%eax),%edx
 1ae:	84 d2                	test   %dl,%dl
 1b0:	74 06                	je     1b8 <strchr+0x28>
    if(*s == c)
 1b2:	38 ca                	cmp    %cl,%dl
 1b4:	75 f2                	jne    1a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1b6:	5d                   	pop    %ebp
 1b7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 1ba:	5d                   	pop    %ebp
 1bb:	90                   	nop
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c0:	c3                   	ret    
 1c1:	eb 0d                	jmp    1d0 <atoi>
 1c3:	90                   	nop
 1c4:	90                   	nop
 1c5:	90                   	nop
 1c6:	90                   	nop
 1c7:	90                   	nop
 1c8:	90                   	nop
 1c9:	90                   	nop
 1ca:	90                   	nop
 1cb:	90                   	nop
 1cc:	90                   	nop
 1cd:	90                   	nop
 1ce:	90                   	nop
 1cf:	90                   	nop

000001d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1d0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d9:	0f b6 11             	movzbl (%ecx),%edx
 1dc:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1df:	80 fb 09             	cmp    $0x9,%bl
 1e2:	77 1c                	ja     200 <atoi+0x30>
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 1e8:	0f be d2             	movsbl %dl,%edx
 1eb:	83 c1 01             	add    $0x1,%ecx
 1ee:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1f1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f5:	0f b6 11             	movzbl (%ecx),%edx
 1f8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1fb:	80 fb 09             	cmp    $0x9,%bl
 1fe:	76 e8                	jbe    1e8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 200:	5b                   	pop    %ebx
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
 203:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	53                   	push   %ebx
 218:	8b 5d 10             	mov    0x10(%ebp),%ebx
 21b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	85 db                	test   %ebx,%ebx
 220:	7e 14                	jle    236 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 222:	31 d2                	xor    %edx,%edx
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 228:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 22c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 22f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 232:	39 da                	cmp    %ebx,%edx
 234:	75 f2                	jne    228 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 236:	5b                   	pop    %ebx
 237:	5e                   	pop    %esi
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 249:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 24c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 24f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25b:	00 
 25c:	89 04 24             	mov    %eax,(%esp)
 25f:	e8 d1 00 00 00       	call   335 <open>
  if(fd < 0)
 264:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 268:	78 19                	js     283 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 1c 24             	mov    %ebx,(%esp)
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	e8 d4 00 00 00       	call   34d <fstat>
  close(fd);
 279:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 27c:	89 c6                	mov    %eax,%esi
  close(fd);
 27e:	e8 9a 00 00 00       	call   31d <close>
  return r;
}
 283:	89 f0                	mov    %esi,%eax
 285:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 288:	8b 75 fc             	mov    -0x4(%ebp),%esi
 28b:	89 ec                	mov    %ebp,%esp
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop

00000290 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
 295:	31 f6                	xor    %esi,%esi
 297:	53                   	push   %ebx
 298:	83 ec 2c             	sub    $0x2c,%esp
 29b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	eb 06                	jmp    2a6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 39                	je     2dd <gets+0x4d>
 2a4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2a9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ac:	7d 31                	jge    2df <gets+0x4f>
    cc = read(0, &c, 1);
 2ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2b8:	00 
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2c4:	e8 44 00 00 00       	call   30d <read>
    if(cc < 1)
 2c9:	85 c0                	test   %eax,%eax
 2cb:	7e 12                	jle    2df <gets+0x4f>
      break;
    buf[i++] = c;
 2cd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 2d5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d9:	3c 0d                	cmp    $0xd,%al
 2db:	75 c3                	jne    2a0 <gets+0x10>
 2dd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2df:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2e3:	89 f8                	mov    %edi,%eax
 2e5:	83 c4 2c             	add    $0x2c,%esp
 2e8:	5b                   	pop    %ebx
 2e9:	5e                   	pop    %esi
 2ea:	5f                   	pop    %edi
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ed:	b8 01 00 00 00       	mov    $0x1,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <exit>:
SYSCALL(exit)
 2f5:	b8 02 00 00 00       	mov    $0x2,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <wait>:
SYSCALL(wait)
 2fd:	b8 03 00 00 00       	mov    $0x3,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <pipe>:
SYSCALL(pipe)
 305:	b8 04 00 00 00       	mov    $0x4,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <read>:
SYSCALL(read)
 30d:	b8 05 00 00 00       	mov    $0x5,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <write>:
SYSCALL(write)
 315:	b8 10 00 00 00       	mov    $0x10,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <close>:
SYSCALL(close)
 31d:	b8 15 00 00 00       	mov    $0x15,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <kill>:
SYSCALL(kill)
 325:	b8 06 00 00 00       	mov    $0x6,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <exec>:
SYSCALL(exec)
 32d:	b8 07 00 00 00       	mov    $0x7,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <open>:
SYSCALL(open)
 335:	b8 0f 00 00 00       	mov    $0xf,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <mknod>:
SYSCALL(mknod)
 33d:	b8 11 00 00 00       	mov    $0x11,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <unlink>:
SYSCALL(unlink)
 345:	b8 12 00 00 00       	mov    $0x12,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <fstat>:
SYSCALL(fstat)
 34d:	b8 08 00 00 00       	mov    $0x8,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <link>:
SYSCALL(link)
 355:	b8 13 00 00 00       	mov    $0x13,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mkdir>:
SYSCALL(mkdir)
 35d:	b8 14 00 00 00       	mov    $0x14,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <chdir>:
SYSCALL(chdir)
 365:	b8 09 00 00 00       	mov    $0x9,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <dup>:
SYSCALL(dup)
 36d:	b8 0a 00 00 00       	mov    $0xa,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <getpid>:
SYSCALL(getpid)
 375:	b8 0b 00 00 00       	mov    $0xb,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <sbrk>:
SYSCALL(sbrk)
 37d:	b8 0c 00 00 00       	mov    $0xc,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <sleep>:
SYSCALL(sleep)
 385:	b8 0d 00 00 00       	mov    $0xd,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <uptime>:
SYSCALL(uptime)
 38d:	b8 0e 00 00 00       	mov    $0xe,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <date>:
SYSCALL(date)
 395:	b8 16 00 00 00       	mov    $0x16,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <alarm>:
SYSCALL(alarm)
 39d:	b8 17 00 00 00       	mov    $0x17,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    
 3a5:	66 90                	xchg   %ax,%ax
 3a7:	66 90                	xchg   %ax,%ax
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	66 90                	xchg   %ax,%ax
 3ad:	66 90                	xchg   %ax,%ax
 3af:	90                   	nop

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	89 cf                	mov    %ecx,%edi
 3b6:	56                   	push   %esi
 3b7:	89 c6                	mov    %eax,%esi
 3b9:	53                   	push   %ebx
 3ba:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3c0:	85 c9                	test   %ecx,%ecx
 3c2:	74 04                	je     3c8 <printint+0x18>
 3c4:	85 d2                	test   %edx,%edx
 3c6:	78 70                	js     438 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3d1:	31 c9                	xor    %ecx,%ecx
 3d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3d6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3d8:	31 d2                	xor    %edx,%edx
 3da:	f7 f7                	div    %edi
 3dc:	0f b6 92 eb 07 00 00 	movzbl 0x7eb(%edx),%edx
 3e3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3e6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3e9:	85 c0                	test   %eax,%eax
 3eb:	75 eb                	jne    3d8 <printint+0x28>
  if(neg)
 3ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3f0:	85 c0                	test   %eax,%eax
 3f2:	74 08                	je     3fc <printint+0x4c>
    buf[i++] = '-';
 3f4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 3f9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3fc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3ff:	01 fb                	add    %edi,%ebx
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	0f b6 03             	movzbl (%ebx),%eax
 40b:	83 ef 01             	sub    $0x1,%edi
 40e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 411:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 418:	00 
 419:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 41f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	e8 ea fe ff ff       	call   315 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42b:	83 ff ff             	cmp    $0xffffffff,%edi
 42e:	75 d8                	jne    408 <printint+0x58>
    putc(fd, buf[i]);
}
 430:	83 c4 4c             	add    $0x4c,%esp
 433:	5b                   	pop    %ebx
 434:	5e                   	pop    %esi
 435:	5f                   	pop    %edi
 436:	5d                   	pop    %ebp
 437:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 438:	89 d0                	mov    %edx,%eax
 43a:	f7 d8                	neg    %eax
 43c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 443:	eb 8c                	jmp    3d1 <printint+0x21>
 445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 45 0c             	mov    0xc(%ebp),%eax
 45c:	0f b6 10             	movzbl (%eax),%edx
 45f:	84 d2                	test   %dl,%dl
 461:	0f 84 c9 00 00 00    	je     530 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 4d 10             	lea    0x10(%ebp),%ecx
 46a:	31 ff                	xor    %edi,%edi
 46c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 46f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 471:	8d 75 e7             	lea    -0x19(%ebp),%esi
 474:	eb 1e                	jmp    494 <printf+0x44>
 476:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 478:	83 fa 25             	cmp    $0x25,%edx
 47b:	0f 85 b7 00 00 00    	jne    538 <printf+0xe8>
 481:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 485:	83 c3 01             	add    $0x1,%ebx
 488:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 48c:	84 d2                	test   %dl,%dl
 48e:	0f 84 9c 00 00 00    	je     530 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 494:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 496:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 499:	74 dd                	je     478 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49b:	83 ff 25             	cmp    $0x25,%edi
 49e:	75 e5                	jne    485 <printf+0x35>
      if(c == 'd'){
 4a0:	83 fa 64             	cmp    $0x64,%edx
 4a3:	0f 84 47 01 00 00    	je     5f0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4a9:	83 fa 70             	cmp    $0x70,%edx
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b0:	0f 84 aa 00 00 00    	je     560 <printf+0x110>
 4b6:	83 fa 78             	cmp    $0x78,%edx
 4b9:	0f 84 a1 00 00 00    	je     560 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4bf:	83 fa 73             	cmp    $0x73,%edx
 4c2:	0f 84 c0 00 00 00    	je     588 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c8:	83 fa 63             	cmp    $0x63,%edx
 4cb:	90                   	nop
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4d0:	0f 84 42 01 00 00    	je     618 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d6:	83 fa 25             	cmp    $0x25,%edx
 4d9:	0f 84 01 01 00 00    	je     5e0 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4df:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4e2:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4e5:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f0:	00 
 4f1:	89 74 24 04          	mov    %esi,0x4(%esp)
 4f5:	89 0c 24             	mov    %ecx,(%esp)
 4f8:	e8 18 fe ff ff       	call   315 <write>
 4fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
 500:	88 55 e7             	mov    %dl,-0x19(%ebp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 506:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 509:	31 ff                	xor    %edi,%edi
 50b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 512:	00 
 513:	89 74 24 04          	mov    %esi,0x4(%esp)
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 f6 fd ff ff       	call   315 <write>
 51f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 522:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 526:	84 d2                	test   %dl,%dl
 528:	0f 85 66 ff ff ff    	jne    494 <printf+0x44>
 52e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 530:	83 c4 3c             	add    $0x3c,%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 538:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 53b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 545:	00 
 546:	89 74 24 04          	mov    %esi,0x4(%esp)
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 c3 fd ff ff       	call   315 <write>
 552:	8b 45 0c             	mov    0xc(%ebp),%eax
 555:	e9 2b ff ff ff       	jmp    485 <printf+0x35>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 563:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 568:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 56a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 571:	8b 10                	mov    (%eax),%edx
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	e8 35 fe ff ff       	call   3b0 <printint>
 57b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 57e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 582:	e9 fe fe ff ff       	jmp    485 <printf+0x35>
 587:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 588:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 58b:	b9 e4 07 00 00       	mov    $0x7e4,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 590:	8b 3a                	mov    (%edx),%edi
        ap++;
 592:	83 c2 04             	add    $0x4,%edx
 595:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 598:	85 ff                	test   %edi,%edi
 59a:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 59d:	0f b6 17             	movzbl (%edi),%edx
 5a0:	84 d2                	test   %dl,%dl
 5a2:	74 33                	je     5d7 <printf+0x187>
 5a4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 5b0:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b3:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bd:	00 
 5be:	89 74 24 04          	mov    %esi,0x4(%esp)
 5c2:	89 1c 24             	mov    %ebx,(%esp)
 5c5:	e8 4b fd ff ff       	call   315 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ca:	0f b6 17             	movzbl (%edi),%edx
 5cd:	84 d2                	test   %dl,%dl
 5cf:	75 df                	jne    5b0 <printf+0x160>
 5d1:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5d4:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d7:	31 ff                	xor    %edi,%edi
 5d9:	e9 a7 fe ff ff       	jmp    485 <printf+0x35>
 5de:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5e0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5e4:	e9 1a ff ff ff       	jmp    503 <printf+0xb3>
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5f8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 602:	8b 10                	mov    (%eax),%edx
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	e8 a4 fd ff ff       	call   3b0 <printint>
 60c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 60f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 613:	e9 6d fe ff ff       	jmp    485 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 618:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 61b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61d:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 620:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 622:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 629:	00 
 62a:	89 74 24 04          	mov    %esi,0x4(%esp)
 62e:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 631:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 634:	e8 dc fc ff ff       	call   315 <write>
 639:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 63c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 640:	e9 40 fe ff ff       	jmp    485 <printf+0x35>
 645:	66 90                	xchg   %ax,%ax
 647:	66 90                	xchg   %ax,%ax
 649:	66 90                	xchg   %ax,%ax
 64b:	66 90                	xchg   %ax,%ax
 64d:	66 90                	xchg   %ax,%ax
 64f:	90                   	nop

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 04 08 00 00       	mov    0x804,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	39 c8                	cmp    %ecx,%eax
 663:	73 1d                	jae    682 <free+0x32>
 665:	8d 76 00             	lea    0x0(%esi),%esi
 668:	8b 10                	mov    (%eax),%edx
 66a:	39 d1                	cmp    %edx,%ecx
 66c:	72 1a                	jb     688 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66e:	39 d0                	cmp    %edx,%eax
 670:	72 08                	jb     67a <free+0x2a>
 672:	39 c8                	cmp    %ecx,%eax
 674:	72 12                	jb     688 <free+0x38>
 676:	39 d1                	cmp    %edx,%ecx
 678:	72 0e                	jb     688 <free+0x38>
 67a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67c:	39 c8                	cmp    %ecx,%eax
 67e:	66 90                	xchg   %ax,%ax
 680:	72 e6                	jb     668 <free+0x18>
 682:	8b 10                	mov    (%eax),%edx
 684:	eb e8                	jmp    66e <free+0x1e>
 686:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 71 04             	mov    0x4(%ecx),%esi
 68b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68e:	39 d7                	cmp    %edx,%edi
 690:	74 19                	je     6ab <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 692:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 69b:	39 ce                	cmp    %ecx,%esi
 69d:	74 23                	je     6c2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 69f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6a1:	a3 04 08 00 00       	mov    %eax,0x804
}
 6a6:	5b                   	pop    %ebx
 6a7:	5e                   	pop    %esi
 6a8:	5f                   	pop    %edi
 6a9:	5d                   	pop    %ebp
 6aa:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ab:	03 72 04             	add    0x4(%edx),%esi
 6ae:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 12                	mov    (%edx),%edx
 6b5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b8:	8b 50 04             	mov    0x4(%eax),%edx
 6bb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6be:	39 ce                	cmp    %ecx,%esi
 6c0:	75 dd                	jne    69f <free+0x4f>
    p->s.size += bp->s.size;
 6c2:	03 51 04             	add    0x4(%ecx),%edx
 6c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6cb:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6cd:	a3 04 08 00 00       	mov    %eax,0x804
}
 6d2:	5b                   	pop    %ebx
 6d3:	5e                   	pop    %esi
 6d4:	5f                   	pop    %edi
 6d5:	5d                   	pop    %ebp
 6d6:	c3                   	ret    
 6d7:	89 f6                	mov    %esi,%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6ec:	8b 0d 04 08 00 00    	mov    0x804,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	83 c3 07             	add    $0x7,%ebx
 6f5:	c1 eb 03             	shr    $0x3,%ebx
 6f8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6fb:	85 c9                	test   %ecx,%ecx
 6fd:	0f 84 9b 00 00 00    	je     79e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 703:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	39 d3                	cmp    %edx,%ebx
 70a:	76 27                	jbe    733 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 70c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	be 00 80 00 00       	mov    $0x8000,%esi
 718:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 71b:	90                   	nop
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 720:	3b 05 04 08 00 00    	cmp    0x804,%eax
 726:	74 30                	je     758 <malloc+0x78>
 728:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 72c:	8b 50 04             	mov    0x4(%eax),%edx
 72f:	39 d3                	cmp    %edx,%ebx
 731:	77 ed                	ja     720 <malloc+0x40>
      if(p->s.size == nunits)
 733:	39 d3                	cmp    %edx,%ebx
 735:	74 61                	je     798 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 737:	29 da                	sub    %ebx,%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 73c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 73f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 742:	89 0d 04 08 00 00    	mov    %ecx,0x804
      return (void*)(p + 1);
 748:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 74b:	83 c4 2c             	add    $0x2c,%esp
 74e:	5b                   	pop    %ebx
 74f:	5e                   	pop    %esi
 750:	5f                   	pop    %edi
 751:	5d                   	pop    %ebp
 752:	c3                   	ret    
 753:	90                   	nop
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 761:	bf 00 10 00 00       	mov    $0x1000,%edi
 766:	0f 43 fb             	cmovae %ebx,%edi
 769:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 09 fc ff ff       	call   37d <sbrk>
  if(p == (char*)-1)
 774:	83 f8 ff             	cmp    $0xffffffff,%eax
 777:	74 18                	je     791 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 779:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	89 04 24             	mov    %eax,(%esp)
 782:	e8 c9 fe ff ff       	call   650 <free>
  return freep;
 787:	8b 0d 04 08 00 00    	mov    0x804,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 78d:	85 c9                	test   %ecx,%ecx
 78f:	75 99                	jne    72a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 791:	31 c0                	xor    %eax,%eax
 793:	eb b6                	jmp    74b <malloc+0x6b>
 795:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 798:	8b 10                	mov    (%eax),%edx
 79a:	89 11                	mov    %edx,(%ecx)
 79c:	eb a4                	jmp    742 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 79e:	c7 05 04 08 00 00 fc 	movl   $0x7fc,0x804
 7a5:	07 00 00 
    base.s.size = 0;
 7a8:	b9 fc 07 00 00       	mov    $0x7fc,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ad:	c7 05 fc 07 00 00 fc 	movl   $0x7fc,0x7fc
 7b4:	07 00 00 
    base.s.size = 0;
 7b7:	c7 05 00 08 00 00 00 	movl   $0x0,0x800
 7be:	00 00 00 
 7c1:	e9 3d ff ff ff       	jmp    703 <malloc+0x23>
