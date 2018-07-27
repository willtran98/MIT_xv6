
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   b:	eb 1f                	jmp    2c <cat+0x2c>
   d:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  10:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  14:	c7 44 24 04 a0 08 00 	movl   $0x8a0,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 4d 03 00 00       	call   375 <write>
  28:	39 c3                	cmp    %eax,%ebx
  2a:	75 28                	jne    54 <cat+0x54>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  2c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  33:	00 
  34:	c7 44 24 04 a0 08 00 	movl   $0x8a0,0x4(%esp)
  3b:	00 
  3c:	89 34 24             	mov    %esi,(%esp)
  3f:	e8 29 03 00 00       	call   36d <read>
  44:	83 f8 00             	cmp    $0x0,%eax
  47:	89 c3                	mov    %eax,%ebx
  49:	7f c5                	jg     10 <cat+0x10>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  4b:	75 20                	jne    6d <cat+0x6d>
    printf(1, "cat: read error\n");
    exit();
  }
}
  4d:	83 c4 10             	add    $0x10,%esp
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
  54:	c7 44 24 04 26 08 00 	movl   $0x826,0x4(%esp)
  5b:	00 
  5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  63:	e8 48 04 00 00       	call   4b0 <printf>
      exit();
  68:	e8 e8 02 00 00       	call   355 <exit>
    }
  }
  if(n < 0){
    printf(1, "cat: read error\n");
  6d:	c7 44 24 04 38 08 00 	movl   $0x838,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	e8 2f 04 00 00       	call   4b0 <printf>
    exit();
  81:	e8 cf 02 00 00       	call   355 <exit>
  86:	8d 76 00             	lea    0x0(%esi),%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000090 <main>:
  }
}

int
main(int argc, char *argv[])
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	83 e4 f0             	and    $0xfffffff0,%esp
  96:	57                   	push   %edi
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  99:	83 ec 24             	sub    $0x24,%esp
  9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
  9f:	83 ff 01             	cmp    $0x1,%edi
  a2:	7e 6c                	jle    110 <main+0x80>
    cat(0);
    exit();
  a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  a7:	be 01 00 00 00       	mov    $0x1,%esi
  ac:	83 c3 04             	add    $0x4,%ebx
  af:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b7:	00 
  b8:	8b 03                	mov    (%ebx),%eax
  ba:	89 04 24             	mov    %eax,(%esp)
  bd:	e8 d3 02 00 00       	call   395 <open>
  c2:	85 c0                	test   %eax,%eax
  c4:	78 2a                	js     f0 <main+0x60>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  c6:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  c9:	83 c6 01             	add    $0x1,%esi
  cc:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  cf:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  d3:	e8 28 ff ff ff       	call   0 <cat>
    close(fd);
  d8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  dc:	89 04 24             	mov    %eax,(%esp)
  df:	e8 99 02 00 00       	call   37d <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  e4:	39 f7                	cmp    %esi,%edi
  e6:	7f c8                	jg     b0 <main+0x20>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  e8:	e8 68 02 00 00       	call   355 <exit>
  ed:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  f0:	8b 03                	mov    (%ebx),%eax
  f2:	c7 44 24 04 49 08 00 	movl   $0x849,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	89 44 24 08          	mov    %eax,0x8(%esp)
 105:	e8 a6 03 00 00       	call   4b0 <printf>
      exit();
 10a:	e8 46 02 00 00       	call   355 <exit>
 10f:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
 110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 117:	e8 e4 fe ff ff       	call   0 <cat>
    exit();
 11c:	e8 34 02 00 00       	call   355 <exit>
 121:	66 90                	xchg   %ax,%ax
 123:	66 90                	xchg   %ax,%ax
 125:	66 90                	xchg   %ax,%ax
 127:	66 90                	xchg   %ax,%ax
 129:	66 90                	xchg   %ax,%ax
 12b:	66 90                	xchg   %ax,%ax
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 130:	55                   	push   %ebp
 131:	31 d2                	xor    %edx,%edx
 133:	89 e5                	mov    %esp,%ebp
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	53                   	push   %ebx
 139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 144:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 147:	83 c2 01             	add    $0x1,%edx
 14a:	84 c9                	test   %cl,%cl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	5b                   	pop    %ebx
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <strcmp>
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

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 4d 08             	mov    0x8(%ebp),%ecx
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16a:	0f b6 01             	movzbl (%ecx),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 14                	jne    185 <strcmp+0x25>
 171:	eb 25                	jmp    198 <strcmp+0x38>
 173:	90                   	nop
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 178:	83 c1 01             	add    $0x1,%ecx
 17b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17e:	0f b6 01             	movzbl (%ecx),%eax
 181:	84 c0                	test   %al,%al
 183:	74 13                	je     198 <strcmp+0x38>
 185:	0f b6 1a             	movzbl (%edx),%ebx
 188:	38 d8                	cmp    %bl,%al
 18a:	74 ec                	je     178 <strcmp+0x18>
 18c:	0f b6 db             	movzbl %bl,%ebx
 18f:	0f b6 c0             	movzbl %al,%eax
 192:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 194:	5b                   	pop    %ebx
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 198:	0f b6 1a             	movzbl (%edx),%ebx
 19b:	31 c0                	xor    %eax,%eax
 19d:	0f b6 db             	movzbl %bl,%ebx
 1a0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 1a2:	5b                   	pop    %ebx
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strlen>:

uint
strlen(char *s)
{
 1b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1b5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 39 00             	cmpb   $0x0,(%ecx)
 1bd:	74 0c                	je     1cb <strlen+0x1b>
 1bf:	90                   	nop
 1c0:	83 c2 01             	add    $0x1,%edx
 1c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1c7:	89 d0                	mov    %edx,%eax
 1c9:	75 f5                	jne    1c0 <strlen+0x10>
    ;
  return n;
}
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e2:	89 d0                	mov    %edx,%eax
 1e4:	5f                   	pop    %edi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 11                	jne    212 <strchr+0x22>
 201:	eb 15                	jmp    218 <strchr+0x28>
 203:	90                   	nop
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 06                	je     218 <strchr+0x28>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	75 f2                	jne    208 <strchr+0x18>
      return (char*)s;
  return 0;
}
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
 21a:	5d                   	pop    %ebp
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	c3                   	ret    
 221:	eb 0d                	jmp    230 <atoi>
 223:	90                   	nop
 224:	90                   	nop
 225:	90                   	nop
 226:	90                   	nop
 227:	90                   	nop
 228:	90                   	nop
 229:	90                   	nop
 22a:	90                   	nop
 22b:	90                   	nop
 22c:	90                   	nop
 22d:	90                   	nop
 22e:	90                   	nop
 22f:	90                   	nop

00000230 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 231:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 233:	89 e5                	mov    %esp,%ebp
 235:	8b 4d 08             	mov    0x8(%ebp),%ecx
 238:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 239:	0f b6 11             	movzbl (%ecx),%edx
 23c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23f:	80 fb 09             	cmp    $0x9,%bl
 242:	77 1c                	ja     260 <atoi+0x30>
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 248:	0f be d2             	movsbl %dl,%edx
 24b:	83 c1 01             	add    $0x1,%ecx
 24e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 251:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 255:	0f b6 11             	movzbl (%ecx),%edx
 258:	8d 5a d0             	lea    -0x30(%edx),%ebx
 25b:	80 fb 09             	cmp    $0x9,%bl
 25e:	76 e8                	jbe    248 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	53                   	push   %ebx
 278:	8b 5d 10             	mov    0x10(%ebp),%ebx
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 14                	jle    296 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 282:	31 d2                	xor    %edx,%edx
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 288:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 28c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 292:	39 da                	cmp    %ebx,%edx
 294:	75 f2                	jne    288 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002a0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2af:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2bb:	00 
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 d1 00 00 00       	call   395 <open>
  if(fd < 0)
 2c4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2c8:	78 19                	js     2e3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 1c 24             	mov    %ebx,(%esp)
 2d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d4:	e8 d4 00 00 00       	call   3ad <fstat>
  close(fd);
 2d9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2dc:	89 c6                	mov    %eax,%esi
  close(fd);
 2de:	e8 9a 00 00 00       	call   37d <close>
  return r;
}
 2e3:	89 f0                	mov    %esi,%eax
 2e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2eb:	89 ec                	mov    %ebp,%esp
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
 2ef:	90                   	nop

000002f0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	31 f6                	xor    %esi,%esi
 2f7:	53                   	push   %ebx
 2f8:	83 ec 2c             	sub    $0x2c,%esp
 2fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fe:	eb 06                	jmp    306 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 300:	3c 0a                	cmp    $0xa,%al
 302:	74 39                	je     33d <gets+0x4d>
 304:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	8d 5e 01             	lea    0x1(%esi),%ebx
 309:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30c:	7d 31                	jge    33f <gets+0x4f>
    cc = read(0, &c, 1);
 30e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 311:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 318:	00 
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 324:	e8 44 00 00 00       	call   36d <read>
    if(cc < 1)
 329:	85 c0                	test   %eax,%eax
 32b:	7e 12                	jle    33f <gets+0x4f>
      break;
    buf[i++] = c;
 32d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 331:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 335:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 339:	3c 0d                	cmp    $0xd,%al
 33b:	75 c3                	jne    300 <gets+0x10>
 33d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 33f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 343:	89 f8                	mov    %edi,%eax
 345:	83 c4 2c             	add    $0x2c,%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    

0000034d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34d:	b8 01 00 00 00       	mov    $0x1,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <exit>:
SYSCALL(exit)
 355:	b8 02 00 00 00       	mov    $0x2,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <wait>:
SYSCALL(wait)
 35d:	b8 03 00 00 00       	mov    $0x3,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <pipe>:
SYSCALL(pipe)
 365:	b8 04 00 00 00       	mov    $0x4,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <read>:
SYSCALL(read)
 36d:	b8 05 00 00 00       	mov    $0x5,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <write>:
SYSCALL(write)
 375:	b8 10 00 00 00       	mov    $0x10,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <close>:
SYSCALL(close)
 37d:	b8 15 00 00 00       	mov    $0x15,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <kill>:
SYSCALL(kill)
 385:	b8 06 00 00 00       	mov    $0x6,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <exec>:
SYSCALL(exec)
 38d:	b8 07 00 00 00       	mov    $0x7,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <open>:
SYSCALL(open)
 395:	b8 0f 00 00 00       	mov    $0xf,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <mknod>:
SYSCALL(mknod)
 39d:	b8 11 00 00 00       	mov    $0x11,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <unlink>:
SYSCALL(unlink)
 3a5:	b8 12 00 00 00       	mov    $0x12,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <fstat>:
SYSCALL(fstat)
 3ad:	b8 08 00 00 00       	mov    $0x8,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <link>:
SYSCALL(link)
 3b5:	b8 13 00 00 00       	mov    $0x13,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <mkdir>:
SYSCALL(mkdir)
 3bd:	b8 14 00 00 00       	mov    $0x14,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <chdir>:
SYSCALL(chdir)
 3c5:	b8 09 00 00 00       	mov    $0x9,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <dup>:
SYSCALL(dup)
 3cd:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <getpid>:
SYSCALL(getpid)
 3d5:	b8 0b 00 00 00       	mov    $0xb,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <sbrk>:
SYSCALL(sbrk)
 3dd:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sleep>:
SYSCALL(sleep)
 3e5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <uptime>:
SYSCALL(uptime)
 3ed:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <date>:
SYSCALL(date)
 3f5:	b8 16 00 00 00       	mov    $0x16,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <alarm>:
SYSCALL(alarm)
 3fd:	b8 17 00 00 00       	mov    $0x17,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    
 405:	66 90                	xchg   %ax,%ax
 407:	66 90                	xchg   %ax,%ax
 409:	66 90                	xchg   %ax,%ax
 40b:	66 90                	xchg   %ax,%ax
 40d:	66 90                	xchg   %ax,%ax
 40f:	90                   	nop

00000410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	89 cf                	mov    %ecx,%edi
 416:	56                   	push   %esi
 417:	89 c6                	mov    %eax,%esi
 419:	53                   	push   %ebx
 41a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 420:	85 c9                	test   %ecx,%ecx
 422:	74 04                	je     428 <printint+0x18>
 424:	85 d2                	test   %edx,%edx
 426:	78 70                	js     498 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 428:	89 d0                	mov    %edx,%eax
 42a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 431:	31 c9                	xor    %ecx,%ecx
 433:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 436:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 438:	31 d2                	xor    %edx,%edx
 43a:	f7 f7                	div    %edi
 43c:	0f b6 92 65 08 00 00 	movzbl 0x865(%edx),%edx
 443:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 446:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 449:	85 c0                	test   %eax,%eax
 44b:	75 eb                	jne    438 <printint+0x28>
  if(neg)
 44d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 450:	85 c0                	test   %eax,%eax
 452:	74 08                	je     45c <printint+0x4c>
    buf[i++] = '-';
 454:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 459:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 45c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 45f:	01 fb                	add    %edi,%ebx
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 468:	0f b6 03             	movzbl (%ebx),%eax
 46b:	83 ef 01             	sub    $0x1,%edi
 46e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 471:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 478:	00 
 479:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 47f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	e8 ea fe ff ff       	call   375 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48b:	83 ff ff             	cmp    $0xffffffff,%edi
 48e:	75 d8                	jne    468 <printint+0x58>
    putc(fd, buf[i]);
}
 490:	83 c4 4c             	add    $0x4c,%esp
 493:	5b                   	pop    %ebx
 494:	5e                   	pop    %esi
 495:	5f                   	pop    %edi
 496:	5d                   	pop    %ebp
 497:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 498:	89 d0                	mov    %edx,%eax
 49a:	f7 d8                	neg    %eax
 49c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4a3:	eb 8c                	jmp    431 <printint+0x21>
 4a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	0f b6 10             	movzbl (%eax),%edx
 4bf:	84 d2                	test   %dl,%dl
 4c1:	0f 84 c9 00 00 00    	je     590 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4c7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ca:	31 ff                	xor    %edi,%edi
 4cc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 4cf:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4d4:	eb 1e                	jmp    4f4 <printf+0x44>
 4d6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4d8:	83 fa 25             	cmp    $0x25,%edx
 4db:	0f 85 b7 00 00 00    	jne    598 <printf+0xe8>
 4e1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e5:	83 c3 01             	add    $0x1,%ebx
 4e8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4ec:	84 d2                	test   %dl,%dl
 4ee:	0f 84 9c 00 00 00    	je     590 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 4f4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4f6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 4f9:	74 dd                	je     4d8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fb:	83 ff 25             	cmp    $0x25,%edi
 4fe:	75 e5                	jne    4e5 <printf+0x35>
      if(c == 'd'){
 500:	83 fa 64             	cmp    $0x64,%edx
 503:	0f 84 47 01 00 00    	je     650 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 509:	83 fa 70             	cmp    $0x70,%edx
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 510:	0f 84 aa 00 00 00    	je     5c0 <printf+0x110>
 516:	83 fa 78             	cmp    $0x78,%edx
 519:	0f 84 a1 00 00 00    	je     5c0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 51f:	83 fa 73             	cmp    $0x73,%edx
 522:	0f 84 c0 00 00 00    	je     5e8 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 528:	83 fa 63             	cmp    $0x63,%edx
 52b:	90                   	nop
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 530:	0f 84 42 01 00 00    	je     678 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 536:	83 fa 25             	cmp    $0x25,%edx
 539:	0f 84 01 01 00 00    	je     640 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 542:	89 55 cc             	mov    %edx,-0x34(%ebp)
 545:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 549:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 550:	00 
 551:	89 74 24 04          	mov    %esi,0x4(%esp)
 555:	89 0c 24             	mov    %ecx,(%esp)
 558:	e8 18 fe ff ff       	call   375 <write>
 55d:	8b 55 cc             	mov    -0x34(%ebp),%edx
 560:	88 55 e7             	mov    %dl,-0x19(%ebp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 566:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 569:	31 ff                	xor    %edi,%edi
 56b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 572:	00 
 573:	89 74 24 04          	mov    %esi,0x4(%esp)
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 f6 fd ff ff       	call   375 <write>
 57f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 582:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 586:	84 d2                	test   %dl,%dl
 588:	0f 85 66 ff ff ff    	jne    4f4 <printf+0x44>
 58e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 590:	83 c4 3c             	add    $0x3c,%esp
 593:	5b                   	pop    %ebx
 594:	5e                   	pop    %esi
 595:	5f                   	pop    %edi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 598:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 59b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a5:	00 
 5a6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 c3 fd ff ff       	call   375 <write>
 5b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b5:	e9 2b ff ff ff       	jmp    4e5 <printf+0x35>
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5c8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5d1:	8b 10                	mov    (%eax),%edx
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	e8 35 fe ff ff       	call   410 <printint>
 5db:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5de:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5e2:	e9 fe fe ff ff       	jmp    4e5 <printf+0x35>
 5e7:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 5e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
 5eb:	b9 5e 08 00 00       	mov    $0x85e,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5f0:	8b 3a                	mov    (%edx),%edi
        ap++;
 5f2:	83 c2 04             	add    $0x4,%edx
 5f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 5f8:	85 ff                	test   %edi,%edi
 5fa:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
 5fd:	0f b6 17             	movzbl (%edi),%edx
 600:	84 d2                	test   %dl,%dl
 602:	74 33                	je     637 <printf+0x187>
 604:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 607:	8b 5d 08             	mov    0x8(%ebp),%ebx
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
 610:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 613:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 616:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 61d:	00 
 61e:	89 74 24 04          	mov    %esi,0x4(%esp)
 622:	89 1c 24             	mov    %ebx,(%esp)
 625:	e8 4b fd ff ff       	call   375 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62a:	0f b6 17             	movzbl (%edi),%edx
 62d:	84 d2                	test   %dl,%dl
 62f:	75 df                	jne    610 <printf+0x160>
 631:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 634:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 637:	31 ff                	xor    %edi,%edi
 639:	e9 a7 fe ff ff       	jmp    4e5 <printf+0x35>
 63e:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 640:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 644:	e9 1a ff ff ff       	jmp    563 <printf+0xb3>
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 650:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 653:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 658:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 65b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 662:	8b 10                	mov    (%eax),%edx
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	e8 a4 fd ff ff       	call   410 <printint>
 66c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 66f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 673:	e9 6d fe ff ff       	jmp    4e5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 678:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
 67b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 67d:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 680:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 682:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 689:	00 
 68a:	89 74 24 04          	mov    %esi,0x4(%esp)
 68e:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 691:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 694:	e8 dc fc ff ff       	call   375 <write>
 699:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 69c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6a0:	e9 40 fe ff ff       	jmp    4e5 <printf+0x35>
 6a5:	66 90                	xchg   %ax,%ax
 6a7:	66 90                	xchg   %ax,%ax
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	a1 88 08 00 00       	mov    0x888,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	57                   	push   %edi
 6b9:	56                   	push   %esi
 6ba:	53                   	push   %ebx
 6bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	39 c8                	cmp    %ecx,%eax
 6c3:	73 1d                	jae    6e2 <free+0x32>
 6c5:	8d 76 00             	lea    0x0(%esi),%esi
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	39 d1                	cmp    %edx,%ecx
 6cc:	72 1a                	jb     6e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	39 d0                	cmp    %edx,%eax
 6d0:	72 08                	jb     6da <free+0x2a>
 6d2:	39 c8                	cmp    %ecx,%eax
 6d4:	72 12                	jb     6e8 <free+0x38>
 6d6:	39 d1                	cmp    %edx,%ecx
 6d8:	72 0e                	jb     6e8 <free+0x38>
 6da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	39 c8                	cmp    %ecx,%eax
 6de:	66 90                	xchg   %ax,%ax
 6e0:	72 e6                	jb     6c8 <free+0x18>
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	eb e8                	jmp    6ce <free+0x1e>
 6e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 71 04             	mov    0x4(%ecx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 d7                	cmp    %edx,%edi
 6f0:	74 19                	je     70b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6fb:	39 ce                	cmp    %ecx,%esi
 6fd:	74 23                	je     722 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 701:	a3 88 08 00 00       	mov    %eax,0x888
}
 706:	5b                   	pop    %ebx
 707:	5e                   	pop    %esi
 708:	5f                   	pop    %edi
 709:	5d                   	pop    %ebp
 70a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70b:	03 72 04             	add    0x4(%edx),%esi
 70e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 711:	8b 10                	mov    (%eax),%edx
 713:	8b 12                	mov    (%edx),%edx
 715:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 71e:	39 ce                	cmp    %ecx,%esi
 720:	75 dd                	jne    6ff <free+0x4f>
    p->s.size += bp->s.size;
 722:	03 51 04             	add    0x4(%ecx),%edx
 725:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 728:	8b 53 f8             	mov    -0x8(%ebx),%edx
 72b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 72d:	a3 88 08 00 00       	mov    %eax,0x888
}
 732:	5b                   	pop    %ebx
 733:	5e                   	pop    %esi
 734:	5f                   	pop    %edi
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	57                   	push   %edi
 744:	56                   	push   %esi
 745:	53                   	push   %ebx
 746:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 749:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 74c:	8b 0d 88 08 00 00    	mov    0x888,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	83 c3 07             	add    $0x7,%ebx
 755:	c1 eb 03             	shr    $0x3,%ebx
 758:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 75b:	85 c9                	test   %ecx,%ecx
 75d:	0f 84 9b 00 00 00    	je     7fe <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 763:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	39 d3                	cmp    %edx,%ebx
 76a:	76 27                	jbe    793 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
 76c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 773:	be 00 80 00 00       	mov    $0x8000,%esi
 778:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 77b:	90                   	nop
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 780:	3b 05 88 08 00 00    	cmp    0x888,%eax
 786:	74 30                	je     7b8 <malloc+0x78>
 788:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 78c:	8b 50 04             	mov    0x4(%eax),%edx
 78f:	39 d3                	cmp    %edx,%ebx
 791:	77 ed                	ja     780 <malloc+0x40>
      if(p->s.size == nunits)
 793:	39 d3                	cmp    %edx,%ebx
 795:	74 61                	je     7f8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 797:	29 da                	sub    %ebx,%edx
 799:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 79f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7a2:	89 0d 88 08 00 00    	mov    %ecx,0x888
      return (void*)(p + 1);
 7a8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ab:	83 c4 2c             	add    $0x2c,%esp
 7ae:	5b                   	pop    %ebx
 7af:	5e                   	pop    %esi
 7b0:	5f                   	pop    %edi
 7b1:	5d                   	pop    %ebp
 7b2:	c3                   	ret    
 7b3:	90                   	nop
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bb:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 7c1:	bf 00 10 00 00       	mov    $0x1000,%edi
 7c6:	0f 43 fb             	cmovae %ebx,%edi
 7c9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 09 fc ff ff       	call   3dd <sbrk>
  if(p == (char*)-1)
 7d4:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d7:	74 18                	je     7f1 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7d9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 c9 fe ff ff       	call   6b0 <free>
  return freep;
 7e7:	8b 0d 88 08 00 00    	mov    0x888,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7ed:	85 c9                	test   %ecx,%ecx
 7ef:	75 99                	jne    78a <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7f1:	31 c0                	xor    %eax,%eax
 7f3:	eb b6                	jmp    7ab <malloc+0x6b>
 7f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	89 11                	mov    %edx,(%ecx)
 7fc:	eb a4                	jmp    7a2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7fe:	c7 05 88 08 00 00 80 	movl   $0x880,0x888
 805:	08 00 00 
    base.s.size = 0;
 808:	b9 80 08 00 00       	mov    $0x880,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 80d:	c7 05 80 08 00 00 80 	movl   $0x880,0x880
 814:	08 00 00 
    base.s.size = 0;
 817:	c7 05 84 08 00 00 00 	movl   $0x0,0x884
 81e:	00 00 00 
 821:	e9 3d ff ff ff       	jmp    763 <malloc+0x23>
