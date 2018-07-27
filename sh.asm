
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 14             	sub    $0x14,%esp
       7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	85 db                	test   %ebx,%ebx
       c:	74 05                	je     13 <nulterminate+0x13>
    return 0;

  switch(cmd->type){
       e:	83 3b 05             	cmpl   $0x5,(%ebx)
      11:	76 0d                	jbe    20 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      13:	89 d8                	mov    %ebx,%eax
      15:	83 c4 14             	add    $0x14,%esp
      18:	5b                   	pop    %ebx
      19:	5d                   	pop    %ebp
      1a:	c3                   	ret    
      1b:	90                   	nop
      1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
      20:	8b 03                	mov    (%ebx),%eax
      22:	ff 24 85 48 13 00 00 	jmp    *0x1348(,%eax,4)
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      30:	8b 43 04             	mov    0x4(%ebx),%eax
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 c5 ff ff ff       	call   0 <nulterminate>
    nulterminate(lcmd->right);
      3b:	8b 43 08             	mov    0x8(%ebx),%eax
      3e:	89 04 24             	mov    %eax,(%esp)
      41:	e8 ba ff ff ff       	call   0 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      46:	89 d8                	mov    %ebx,%eax
      48:	83 c4 14             	add    $0x14,%esp
      4b:	5b                   	pop    %ebx
      4c:	5d                   	pop    %ebp
      4d:	c3                   	ret    
      4e:	66 90                	xchg   %ax,%ax
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      50:	8b 43 04             	mov    0x4(%ebx),%eax
      53:	89 04 24             	mov    %eax,(%esp)
      56:	e8 a5 ff ff ff       	call   0 <nulterminate>
    break;
  }
  return cmd;
}
      5b:	89 d8                	mov    %ebx,%eax
      5d:	83 c4 14             	add    $0x14,%esp
      60:	5b                   	pop    %ebx
      61:	5d                   	pop    %ebp
      62:	c3                   	ret    
      63:	90                   	nop
      64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      68:	8b 43 04             	mov    0x4(%ebx),%eax
      6b:	89 04 24             	mov    %eax,(%esp)
      6e:	e8 8d ff ff ff       	call   0 <nulterminate>
    *rcmd->efile = 0;
      73:	8b 43 0c             	mov    0xc(%ebx),%eax
      76:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      79:	89 d8                	mov    %ebx,%eax
      7b:	83 c4 14             	add    $0x14,%esp
      7e:	5b                   	pop    %ebx
      7f:	5d                   	pop    %ebp
      80:	c3                   	ret    
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      88:	8b 43 04             	mov    0x4(%ebx),%eax
      8b:	85 c0                	test   %eax,%eax
      8d:	74 84                	je     13 <nulterminate+0x13>
      8f:	89 d8                	mov    %ebx,%eax
      91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
      98:	8b 50 2c             	mov    0x2c(%eax),%edx
      9b:	c6 02 00             	movb   $0x0,(%edx)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      9e:	8b 50 08             	mov    0x8(%eax),%edx
      a1:	83 c0 04             	add    $0x4,%eax
      a4:	85 d2                	test   %edx,%edx
      a6:	75 f0                	jne    98 <nulterminate+0x98>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      a8:	89 d8                	mov    %ebx,%eax
      aa:	83 c4 14             	add    $0x14,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	57                   	push   %edi
      b4:	56                   	push   %esi
      b5:	53                   	push   %ebx
      b6:	83 ec 1c             	sub    $0x1c,%esp
      b9:	8b 7d 08             	mov    0x8(%ebp),%edi
      bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
      bf:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
      c1:	39 f3                	cmp    %esi,%ebx
      c3:	72 0a                	jb     cf <peek+0x1f>
      c5:	eb 1f                	jmp    e6 <peek+0x36>
      c7:	90                   	nop
    s++;
      c8:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
      cb:	39 de                	cmp    %ebx,%esi
      cd:	76 17                	jbe    e6 <peek+0x36>
      cf:	0f be 03             	movsbl (%ebx),%eax
      d2:	c7 04 24 47 14 00 00 	movl   $0x1447,(%esp)
      d9:	89 44 24 04          	mov    %eax,0x4(%esp)
      dd:	e8 2e 0c 00 00       	call   d10 <strchr>
      e2:	85 c0                	test   %eax,%eax
      e4:	75 e2                	jne    c8 <peek+0x18>
    s++;
  *ps = s;
      e6:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
      e8:	0f b6 13             	movzbl (%ebx),%edx
      eb:	31 c0                	xor    %eax,%eax
      ed:	84 d2                	test   %dl,%dl
      ef:	75 0f                	jne    100 <peek+0x50>
}
      f1:	83 c4 1c             	add    $0x1c,%esp
      f4:	5b                   	pop    %ebx
      f5:	5e                   	pop    %esi
      f6:	5f                   	pop    %edi
      f7:	5d                   	pop    %ebp
      f8:	c3                   	ret    
      f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     100:	0f be d2             	movsbl %dl,%edx
     103:	89 54 24 04          	mov    %edx,0x4(%esp)
     107:	8b 45 10             	mov    0x10(%ebp),%eax
     10a:	89 04 24             	mov    %eax,(%esp)
     10d:	e8 fe 0b 00 00       	call   d10 <strchr>
     112:	85 c0                	test   %eax,%eax
     114:	0f 95 c0             	setne  %al
}
     117:	83 c4 1c             	add    $0x1c,%esp

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     11a:	0f b6 c0             	movzbl %al,%eax
}
     11d:	5b                   	pop    %ebx
     11e:	5e                   	pop    %esi
     11f:	5f                   	pop    %edi
     120:	5d                   	pop    %ebp
     121:	c3                   	ret    
     122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	57                   	push   %edi
     134:	56                   	push   %esi
     135:	53                   	push   %ebx
     136:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;

  s = *ps;
     139:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     13c:	8b 75 0c             	mov    0xc(%ebp),%esi
     13f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     142:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     144:	39 f3                	cmp    %esi,%ebx
     146:	72 0f                	jb     157 <gettoken+0x27>
     148:	eb 24                	jmp    16e <gettoken+0x3e>
     14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     150:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     153:	39 de                	cmp    %ebx,%esi
     155:	76 17                	jbe    16e <gettoken+0x3e>
     157:	0f be 03             	movsbl (%ebx),%eax
     15a:	c7 04 24 47 14 00 00 	movl   $0x1447,(%esp)
     161:	89 44 24 04          	mov    %eax,0x4(%esp)
     165:	e8 a6 0b 00 00       	call   d10 <strchr>
     16a:	85 c0                	test   %eax,%eax
     16c:	75 e2                	jne    150 <gettoken+0x20>
    s++;
  if(q)
     16e:	85 ff                	test   %edi,%edi
     170:	74 02                	je     174 <gettoken+0x44>
    *q = s;
     172:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     174:	0f b6 13             	movzbl (%ebx),%edx
     177:	0f be fa             	movsbl %dl,%edi
  switch(*s){
     17a:	80 fa 3c             	cmp    $0x3c,%dl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     17d:	89 f8                	mov    %edi,%eax
  switch(*s){
     17f:	7f 4f                	jg     1d0 <gettoken+0xa0>
     181:	80 fa 3b             	cmp    $0x3b,%dl
     184:	0f 8c a6 00 00 00    	jl     230 <gettoken+0x100>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     18a:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     18d:	8b 55 14             	mov    0x14(%ebp),%edx
     190:	85 d2                	test   %edx,%edx
     192:	74 05                	je     199 <gettoken+0x69>
    *eq = s;
     194:	8b 45 14             	mov    0x14(%ebp),%eax
     197:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
     199:	39 f3                	cmp    %esi,%ebx
     19b:	72 0a                	jb     1a7 <gettoken+0x77>
     19d:	eb 1f                	jmp    1be <gettoken+0x8e>
     19f:	90                   	nop
    s++;
     1a0:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     1a3:	39 de                	cmp    %ebx,%esi
     1a5:	76 17                	jbe    1be <gettoken+0x8e>
     1a7:	0f be 03             	movsbl (%ebx),%eax
     1aa:	c7 04 24 47 14 00 00 	movl   $0x1447,(%esp)
     1b1:	89 44 24 04          	mov    %eax,0x4(%esp)
     1b5:	e8 56 0b 00 00       	call   d10 <strchr>
     1ba:	85 c0                	test   %eax,%eax
     1bc:	75 e2                	jne    1a0 <gettoken+0x70>
    s++;
  *ps = s;
     1be:	8b 45 08             	mov    0x8(%ebp),%eax
     1c1:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     1c3:	83 c4 1c             	add    $0x1c,%esp
     1c6:	89 f8                	mov    %edi,%eax
     1c8:	5b                   	pop    %ebx
     1c9:	5e                   	pop    %esi
     1ca:	5f                   	pop    %edi
     1cb:	5d                   	pop    %ebp
     1cc:	c3                   	ret    
     1cd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     1d0:	80 fa 3e             	cmp    $0x3e,%dl
     1d3:	0f 84 7f 00 00 00    	je     258 <gettoken+0x128>
     1d9:	80 fa 7c             	cmp    $0x7c,%dl
     1dc:	74 ac                	je     18a <gettoken+0x5a>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     1de:	39 de                	cmp    %ebx,%esi
     1e0:	77 2f                	ja     211 <gettoken+0xe1>
     1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     1e8:	eb 3b                	jmp    225 <gettoken+0xf5>
     1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     1f0:	0f be 03             	movsbl (%ebx),%eax
     1f3:	c7 04 24 4d 14 00 00 	movl   $0x144d,(%esp)
     1fa:	89 44 24 04          	mov    %eax,0x4(%esp)
     1fe:	e8 0d 0b 00 00       	call   d10 <strchr>
     203:	85 c0                	test   %eax,%eax
     205:	75 1e                	jne    225 <gettoken+0xf5>
      s++;
     207:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     20a:	39 de                	cmp    %ebx,%esi
     20c:	76 17                	jbe    225 <gettoken+0xf5>
     20e:	0f be 03             	movsbl (%ebx),%eax
     211:	89 44 24 04          	mov    %eax,0x4(%esp)
     215:	c7 04 24 47 14 00 00 	movl   $0x1447,(%esp)
     21c:	e8 ef 0a 00 00       	call   d10 <strchr>
     221:	85 c0                	test   %eax,%eax
     223:	74 cb                	je     1f0 <gettoken+0xc0>
     225:	bf 61 00 00 00       	mov    $0x61,%edi
     22a:	e9 5e ff ff ff       	jmp    18d <gettoken+0x5d>
     22f:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     230:	80 fa 29             	cmp    $0x29,%dl
     233:	7f a9                	jg     1de <gettoken+0xae>
     235:	80 fa 28             	cmp    $0x28,%dl
     238:	0f 8d 4c ff ff ff    	jge    18a <gettoken+0x5a>
     23e:	84 d2                	test   %dl,%dl
     240:	0f 84 47 ff ff ff    	je     18d <gettoken+0x5d>
     246:	80 fa 26             	cmp    $0x26,%dl
     249:	75 93                	jne    1de <gettoken+0xae>
     24b:	90                   	nop
     24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     250:	e9 35 ff ff ff       	jmp    18a <gettoken+0x5a>
     255:	8d 76 00             	lea    0x0(%esi),%esi
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     258:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     25b:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     25e:	66 90                	xchg   %ax,%ax
     260:	0f 85 27 ff ff ff    	jne    18d <gettoken+0x5d>
      ret = '+';
      s++;
     266:	83 c3 01             	add    $0x1,%ebx
     269:	bf 2b 00 00 00       	mov    $0x2b,%edi
     26e:	66 90                	xchg   %ax,%ax
     270:	e9 18 ff ff ff       	jmp    18d <gettoken+0x5d>
     275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     280:	55                   	push   %ebp
     281:	89 e5                	mov    %esp,%ebp
     283:	53                   	push   %ebx
     284:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     287:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     28e:	e8 cd 0f 00 00       	call   1260 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     293:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     29a:	00 
     29b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2a2:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2a3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2a5:	89 04 24             	mov    %eax,(%esp)
     2a8:	e8 43 0a 00 00       	call   cf0 <memset>
  cmd->type = BACK;
     2ad:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     2b3:	8b 45 08             	mov    0x8(%ebp),%eax
     2b6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     2b9:	89 d8                	mov    %ebx,%eax
     2bb:	83 c4 14             	add    $0x14,%esp
     2be:	5b                   	pop    %ebx
     2bf:	5d                   	pop    %ebp
     2c0:	c3                   	ret    
     2c1:	eb 0d                	jmp    2d0 <listcmd>
     2c3:	90                   	nop
     2c4:	90                   	nop
     2c5:	90                   	nop
     2c6:	90                   	nop
     2c7:	90                   	nop
     2c8:	90                   	nop
     2c9:	90                   	nop
     2ca:	90                   	nop
     2cb:	90                   	nop
     2cc:	90                   	nop
     2cd:	90                   	nop
     2ce:	90                   	nop
     2cf:	90                   	nop

000002d0 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2d0:	55                   	push   %ebp
     2d1:	89 e5                	mov    %esp,%ebp
     2d3:	53                   	push   %ebx
     2d4:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2de:	e8 7d 0f 00 00       	call   1260 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2e3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     2ea:	00 
     2eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2f2:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2f5:	89 04 24             	mov    %eax,(%esp)
     2f8:	e8 f3 09 00 00       	call   cf0 <memset>
  cmd->type = LIST;
     2fd:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     303:	8b 45 08             	mov    0x8(%ebp),%eax
     306:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     309:	8b 45 0c             	mov    0xc(%ebp),%eax
     30c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     30f:	89 d8                	mov    %ebx,%eax
     311:	83 c4 14             	add    $0x14,%esp
     314:	5b                   	pop    %ebx
     315:	5d                   	pop    %ebp
     316:	c3                   	ret    
     317:	89 f6                	mov    %esi,%esi
     319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	53                   	push   %ebx
     324:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     327:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     32e:	e8 2d 0f 00 00       	call   1260 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     333:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     33a:	00 
     33b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     342:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     343:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     345:	89 04 24             	mov    %eax,(%esp)
     348:	e8 a3 09 00 00       	call   cf0 <memset>
  cmd->type = PIPE;
     34d:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     353:	8b 45 08             	mov    0x8(%ebp),%eax
     356:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     359:	8b 45 0c             	mov    0xc(%ebp),%eax
     35c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     35f:	89 d8                	mov    %ebx,%eax
     361:	83 c4 14             	add    $0x14,%esp
     364:	5b                   	pop    %ebx
     365:	5d                   	pop    %ebp
     366:	c3                   	ret    
     367:	89 f6                	mov    %esi,%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	53                   	push   %ebx
     374:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     377:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     37e:	e8 dd 0e 00 00       	call   1260 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     383:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     38a:	00 
     38b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     392:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	89 04 24             	mov    %eax,(%esp)
     398:	e8 53 09 00 00       	call   cf0 <memset>
  cmd->type = REDIR;
     39d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3a3:	8b 45 08             	mov    0x8(%ebp),%eax
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3af:	8b 45 10             	mov    0x10(%ebp),%eax
     3b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3b5:	8b 45 14             	mov    0x14(%ebp),%eax
     3b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3bb:	8b 45 18             	mov    0x18(%ebp),%eax
     3be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3c1:	89 d8                	mov    %ebx,%eax
     3c3:	83 c4 14             	add    $0x14,%esp
     3c6:	5b                   	pop    %ebx
     3c7:	5d                   	pop    %ebp
     3c8:	c3                   	ret    
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d7:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3de:	e8 7d 0e 00 00       	call   1260 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3e3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3ea:	00 
     3eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3f2:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3f5:	89 04 24             	mov    %eax,(%esp)
     3f8:	e8 f3 08 00 00       	call   cf0 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     3fd:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     3ff:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     405:	83 c4 14             	add    $0x14,%esp
     408:	5b                   	pop    %ebx
     409:	5d                   	pop    %ebp
     40a:	c3                   	ret    
     40b:	90                   	nop
     40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <panic>:
  exit();
}

void
panic(char *s)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     416:	8b 45 08             	mov    0x8(%ebp),%eax
     419:	c7 44 24 04 e1 13 00 	movl   $0x13e1,0x4(%esp)
     420:	00 
     421:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     428:	89 44 24 08          	mov    %eax,0x8(%esp)
     42c:	e8 9f 0b 00 00       	call   fd0 <printf>
  exit();
     431:	e8 3f 0a 00 00       	call   e75 <exit>
     436:	8d 76 00             	lea    0x0(%esi),%esi
     439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     440:	55                   	push   %ebp
     441:	89 e5                	mov    %esp,%ebp
     443:	57                   	push   %edi
     444:	56                   	push   %esi
     445:	53                   	push   %ebx
     446:	83 ec 3c             	sub    $0x3c,%esp
     449:	8b 7d 0c             	mov    0xc(%ebp),%edi
     44c:	8b 75 10             	mov    0x10(%ebp),%esi
     44f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     450:	c7 44 24 08 95 13 00 	movl   $0x1395,0x8(%esp)
     457:	00 
     458:	89 74 24 04          	mov    %esi,0x4(%esp)
     45c:	89 3c 24             	mov    %edi,(%esp)
     45f:	e8 4c fc ff ff       	call   b0 <peek>
     464:	85 c0                	test   %eax,%eax
     466:	0f 84 a4 00 00 00    	je     510 <parseredirs+0xd0>
    tok = gettoken(ps, es, 0, 0);
     46c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     473:	00 
     474:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     47b:	00 
     47c:	89 74 24 04          	mov    %esi,0x4(%esp)
     480:	89 3c 24             	mov    %edi,(%esp)
     483:	e8 a8 fc ff ff       	call   130 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     488:	89 74 24 04          	mov    %esi,0x4(%esp)
     48c:	89 3c 24             	mov    %edi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     48f:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     491:	8d 45 e0             	lea    -0x20(%ebp),%eax
     494:	89 44 24 0c          	mov    %eax,0xc(%esp)
     498:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     49b:	89 44 24 08          	mov    %eax,0x8(%esp)
     49f:	e8 8c fc ff ff       	call   130 <gettoken>
     4a4:	83 f8 61             	cmp    $0x61,%eax
     4a7:	74 0c                	je     4b5 <parseredirs+0x75>
      panic("missing file for redirection");
     4a9:	c7 04 24 78 13 00 00 	movl   $0x1378,(%esp)
     4b0:	e8 5b ff ff ff       	call   410 <panic>
    switch(tok){
     4b5:	83 fb 3c             	cmp    $0x3c,%ebx
     4b8:	74 3e                	je     4f8 <parseredirs+0xb8>
     4ba:	83 fb 3e             	cmp    $0x3e,%ebx
     4bd:	74 05                	je     4c4 <parseredirs+0x84>
     4bf:	83 fb 2b             	cmp    $0x2b,%ebx
     4c2:	75 8c                	jne    450 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     4c4:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     4cb:	00 
     4cc:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     4d3:	00 
     4d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     4d7:	89 44 24 08          	mov    %eax,0x8(%esp)
     4db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4de:	89 44 24 04          	mov    %eax,0x4(%esp)
     4e2:	8b 45 08             	mov    0x8(%ebp),%eax
     4e5:	89 04 24             	mov    %eax,(%esp)
     4e8:	e8 83 fe ff ff       	call   370 <redircmd>
     4ed:	89 45 08             	mov    %eax,0x8(%ebp)
     4f0:	e9 5b ff ff ff       	jmp    450 <parseredirs+0x10>
     4f5:	8d 76 00             	lea    0x0(%esi),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     4ff:	00 
     500:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     507:	00 
     508:	eb ca                	jmp    4d4 <parseredirs+0x94>
     50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     510:	8b 45 08             	mov    0x8(%ebp),%eax
     513:	83 c4 3c             	add    $0x3c,%esp
     516:	5b                   	pop    %ebx
     517:	5e                   	pop    %esi
     518:	5f                   	pop    %edi
     519:	5d                   	pop    %ebp
     51a:	c3                   	ret    
     51b:	90                   	nop
     51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     520:	55                   	push   %ebp
     521:	89 e5                	mov    %esp,%ebp
     523:	57                   	push   %edi
     524:	56                   	push   %esi
     525:	53                   	push   %ebx
     526:	83 ec 3c             	sub    $0x3c,%esp
     529:	8b 75 08             	mov    0x8(%ebp),%esi
     52c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     52f:	c7 44 24 08 98 13 00 	movl   $0x1398,0x8(%esp)
     536:	00 
     537:	89 34 24             	mov    %esi,(%esp)
     53a:	89 7c 24 04          	mov    %edi,0x4(%esp)
     53e:	e8 6d fb ff ff       	call   b0 <peek>
     543:	85 c0                	test   %eax,%eax
     545:	0f 85 cd 00 00 00    	jne    618 <parseexec+0xf8>
    return parseblock(ps, es);

  ret = execcmd();
     54b:	e8 80 fe ff ff       	call   3d0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     550:	31 db                	xor    %ebx,%ebx
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     555:	89 7c 24 08          	mov    %edi,0x8(%esp)
     559:	89 74 24 04          	mov    %esi,0x4(%esp)
     55d:	89 04 24             	mov    %eax,(%esp)
     560:	e8 db fe ff ff       	call   440 <parseredirs>
     565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
     568:	eb 1c                	jmp    586 <parseexec+0x66>
     56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     570:	89 7c 24 08          	mov    %edi,0x8(%esp)
     574:	89 74 24 04          	mov    %esi,0x4(%esp)
     578:	8b 45 d0             	mov    -0x30(%ebp),%eax
     57b:	89 04 24             	mov    %eax,(%esp)
     57e:	e8 bd fe ff ff       	call   440 <parseredirs>
     583:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     586:	c7 44 24 08 af 13 00 	movl   $0x13af,0x8(%esp)
     58d:	00 
     58e:	89 7c 24 04          	mov    %edi,0x4(%esp)
     592:	89 34 24             	mov    %esi,(%esp)
     595:	e8 16 fb ff ff       	call   b0 <peek>
     59a:	85 c0                	test   %eax,%eax
     59c:	75 5a                	jne    5f8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     59e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5a1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
     5a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     5a8:	89 54 24 08          	mov    %edx,0x8(%esp)
     5ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
     5b0:	89 34 24             	mov    %esi,(%esp)
     5b3:	e8 78 fb ff ff       	call   130 <gettoken>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 3c                	je     5f8 <parseexec+0xd8>
      break;
    if(tok != 'a')
     5bc:	83 f8 61             	cmp    $0x61,%eax
     5bf:	74 0c                	je     5cd <parseexec+0xad>
      panic("syntax");
     5c1:	c7 04 24 9a 13 00 00 	movl   $0x139a,(%esp)
     5c8:	e8 43 fe ff ff       	call   410 <panic>
    cmd->argv[argc] = q;
     5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5d3:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     5d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     5da:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     5de:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     5e1:	83 fb 09             	cmp    $0x9,%ebx
     5e4:	7e 8a                	jle    570 <parseexec+0x50>
      panic("too many args");
     5e6:	c7 04 24 a1 13 00 00 	movl   $0x13a1,(%esp)
     5ed:	e8 1e fe ff ff       	call   410 <panic>
     5f2:	e9 79 ff ff ff       	jmp    570 <parseexec+0x50>
     5f7:	90                   	nop
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     5f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5fb:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
     602:	00 
  cmd->eargv[argc] = 0;
     603:	c7 44 9a 2c 00 00 00 	movl   $0x0,0x2c(%edx,%ebx,4)
     60a:	00 
  return ret;
}
     60b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     60e:	83 c4 3c             	add    $0x3c,%esp
     611:	5b                   	pop    %ebx
     612:	5e                   	pop    %esi
     613:	5f                   	pop    %edi
     614:	5d                   	pop    %ebp
     615:	c3                   	ret    
     616:	66 90                	xchg   %ax,%ax
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);
     618:	89 7c 24 04          	mov    %edi,0x4(%esp)
     61c:	89 34 24             	mov    %esi,(%esp)
     61f:	e8 6c 01 00 00       	call   790 <parseblock>
     624:	89 45 d0             	mov    %eax,-0x30(%ebp)
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     627:	8b 45 d0             	mov    -0x30(%ebp),%eax
     62a:	83 c4 3c             	add    $0x3c,%esp
     62d:	5b                   	pop    %ebx
     62e:	5e                   	pop    %esi
     62f:	5f                   	pop    %edi
     630:	5d                   	pop    %ebp
     631:	c3                   	ret    
     632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	83 ec 28             	sub    $0x28,%esp
     646:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     649:	8b 5d 08             	mov    0x8(%ebp),%ebx
     64c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     64f:	8b 75 0c             	mov    0xc(%ebp),%esi
     652:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     655:	89 1c 24             	mov    %ebx,(%esp)
     658:	89 74 24 04          	mov    %esi,0x4(%esp)
     65c:	e8 bf fe ff ff       	call   520 <parseexec>
  if(peek(ps, es, "|")){
     661:	c7 44 24 08 b4 13 00 	movl   $0x13b4,0x8(%esp)
     668:	00 
     669:	89 74 24 04          	mov    %esi,0x4(%esp)
     66d:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     670:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     672:	e8 39 fa ff ff       	call   b0 <peek>
     677:	85 c0                	test   %eax,%eax
     679:	75 15                	jne    690 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     67b:	89 f8                	mov    %edi,%eax
     67d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     680:	8b 75 f8             	mov    -0x8(%ebp),%esi
     683:	8b 7d fc             	mov    -0x4(%ebp),%edi
     686:	89 ec                	mov    %ebp,%esp
     688:	5d                   	pop    %ebp
     689:	c3                   	ret    
     68a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     690:	89 74 24 04          	mov    %esi,0x4(%esp)
     694:	89 1c 24             	mov    %ebx,(%esp)
     697:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     69e:	00 
     69f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6a6:	00 
     6a7:	e8 84 fa ff ff       	call   130 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ac:	89 74 24 04          	mov    %esi,0x4(%esp)
     6b0:	89 1c 24             	mov    %ebx,(%esp)
     6b3:	e8 88 ff ff ff       	call   640 <parsepipe>
  }
  return cmd;
}
     6b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6bb:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     6be:	8b 75 f8             	mov    -0x8(%ebp),%esi
     6c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6c4:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     6c7:	89 ec                	mov    %ebp,%esp
     6c9:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	e9 51 fc ff ff       	jmp    320 <pipecmd>
     6cf:	90                   	nop

000006d0 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	57                   	push   %edi
     6d4:	56                   	push   %esi
     6d5:	53                   	push   %ebx
     6d6:	83 ec 1c             	sub    $0x1c,%esp
     6d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     6df:	89 1c 24             	mov    %ebx,(%esp)
     6e2:	89 74 24 04          	mov    %esi,0x4(%esp)
     6e6:	e8 55 ff ff ff       	call   640 <parsepipe>
     6eb:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6ed:	eb 27                	jmp    716 <parseline+0x46>
     6ef:	90                   	nop
    gettoken(ps, es, 0, 0);
     6f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6f7:	00 
     6f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6ff:	00 
     700:	89 74 24 04          	mov    %esi,0x4(%esp)
     704:	89 1c 24             	mov    %ebx,(%esp)
     707:	e8 24 fa ff ff       	call   130 <gettoken>
    cmd = backcmd(cmd);
     70c:	89 3c 24             	mov    %edi,(%esp)
     70f:	e8 6c fb ff ff       	call   280 <backcmd>
     714:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     716:	c7 44 24 08 b6 13 00 	movl   $0x13b6,0x8(%esp)
     71d:	00 
     71e:	89 74 24 04          	mov    %esi,0x4(%esp)
     722:	89 1c 24             	mov    %ebx,(%esp)
     725:	e8 86 f9 ff ff       	call   b0 <peek>
     72a:	85 c0                	test   %eax,%eax
     72c:	75 c2                	jne    6f0 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     72e:	c7 44 24 08 b2 13 00 	movl   $0x13b2,0x8(%esp)
     735:	00 
     736:	89 74 24 04          	mov    %esi,0x4(%esp)
     73a:	89 1c 24             	mov    %ebx,(%esp)
     73d:	e8 6e f9 ff ff       	call   b0 <peek>
     742:	85 c0                	test   %eax,%eax
     744:	75 0a                	jne    750 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     746:	83 c4 1c             	add    $0x1c,%esp
     749:	89 f8                	mov    %edi,%eax
     74b:	5b                   	pop    %ebx
     74c:	5e                   	pop    %esi
     74d:	5f                   	pop    %edi
     74e:	5d                   	pop    %ebp
     74f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     750:	89 74 24 04          	mov    %esi,0x4(%esp)
     754:	89 1c 24             	mov    %ebx,(%esp)
     757:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     75e:	00 
     75f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     766:	00 
     767:	e8 c4 f9 ff ff       	call   130 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     76c:	89 74 24 04          	mov    %esi,0x4(%esp)
     770:	89 1c 24             	mov    %ebx,(%esp)
     773:	e8 58 ff ff ff       	call   6d0 <parseline>
     778:	89 7d 08             	mov    %edi,0x8(%ebp)
     77b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     77e:	83 c4 1c             	add    $0x1c,%esp
     781:	5b                   	pop    %ebx
     782:	5e                   	pop    %esi
     783:	5f                   	pop    %edi
     784:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     785:	e9 46 fb ff ff       	jmp    2d0 <listcmd>
     78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000790 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
     796:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     799:	8b 5d 08             	mov    0x8(%ebp),%ebx
     79c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     79f:	8b 75 0c             	mov    0xc(%ebp),%esi
     7a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     7a5:	c7 44 24 08 98 13 00 	movl   $0x1398,0x8(%esp)
     7ac:	00 
     7ad:	89 1c 24             	mov    %ebx,(%esp)
     7b0:	89 74 24 04          	mov    %esi,0x4(%esp)
     7b4:	e8 f7 f8 ff ff       	call   b0 <peek>
     7b9:	85 c0                	test   %eax,%eax
     7bb:	0f 84 87 00 00 00    	je     848 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     7c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7c8:	00 
     7c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7d0:	00 
     7d1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7d5:	89 1c 24             	mov    %ebx,(%esp)
     7d8:	e8 53 f9 ff ff       	call   130 <gettoken>
  cmd = parseline(ps, es);
     7dd:	89 74 24 04          	mov    %esi,0x4(%esp)
     7e1:	89 1c 24             	mov    %ebx,(%esp)
     7e4:	e8 e7 fe ff ff       	call   6d0 <parseline>
  if(!peek(ps, es, ")"))
     7e9:	c7 44 24 08 d4 13 00 	movl   $0x13d4,0x8(%esp)
     7f0:	00 
     7f1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7f5:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     7f8:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7fa:	e8 b1 f8 ff ff       	call   b0 <peek>
     7ff:	85 c0                	test   %eax,%eax
     801:	75 0c                	jne    80f <parseblock+0x7f>
    panic("syntax - missing )");
     803:	c7 04 24 c3 13 00 00 	movl   $0x13c3,(%esp)
     80a:	e8 01 fc ff ff       	call   410 <panic>
  gettoken(ps, es, 0, 0);
     80f:	89 74 24 04          	mov    %esi,0x4(%esp)
     813:	89 1c 24             	mov    %ebx,(%esp)
     816:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     81d:	00 
     81e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     825:	00 
     826:	e8 05 f9 ff ff       	call   130 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     82b:	89 74 24 08          	mov    %esi,0x8(%esp)
     82f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     833:	89 3c 24             	mov    %edi,(%esp)
     836:	e8 05 fc ff ff       	call   440 <parseredirs>
  return cmd;
}
     83b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     83e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     841:	8b 7d fc             	mov    -0x4(%ebp),%edi
     844:	89 ec                	mov    %ebp,%esp
     846:	5d                   	pop    %ebp
     847:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     848:	c7 04 24 b8 13 00 00 	movl   $0x13b8,(%esp)
     84f:	e8 bc fb ff ff       	call   410 <panic>
     854:	e9 68 ff ff ff       	jmp    7c1 <parseblock+0x31>
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000860 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	56                   	push   %esi
     864:	53                   	push   %ebx
     865:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     868:	8b 5d 08             	mov    0x8(%ebp),%ebx
     86b:	89 1c 24             	mov    %ebx,(%esp)
     86e:	e8 5d 04 00 00       	call   cd0 <strlen>
     873:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     875:	8d 45 08             	lea    0x8(%ebp),%eax
     878:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     87c:	89 04 24             	mov    %eax,(%esp)
     87f:	e8 4c fe ff ff       	call   6d0 <parseline>
  peek(&s, es, "");
     884:	c7 44 24 08 03 14 00 	movl   $0x1403,0x8(%esp)
     88b:	00 
     88c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
     890:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     892:	8d 45 08             	lea    0x8(%ebp),%eax
     895:	89 04 24             	mov    %eax,(%esp)
     898:	e8 13 f8 ff ff       	call   b0 <peek>
  if(s != es){
     89d:	8b 45 08             	mov    0x8(%ebp),%eax
     8a0:	39 d8                	cmp    %ebx,%eax
     8a2:	74 24                	je     8c8 <parsecmd+0x68>
    printf(2, "leftovers: %s\n", s);
     8a4:	89 44 24 08          	mov    %eax,0x8(%esp)
     8a8:	c7 44 24 04 d6 13 00 	movl   $0x13d6,0x4(%esp)
     8af:	00 
     8b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8b7:	e8 14 07 00 00       	call   fd0 <printf>
    panic("syntax");
     8bc:	c7 04 24 9a 13 00 00 	movl   $0x139a,(%esp)
     8c3:	e8 48 fb ff ff       	call   410 <panic>
  }
  nulterminate(cmd);
     8c8:	89 34 24             	mov    %esi,(%esp)
     8cb:	e8 30 f7 ff ff       	call   0 <nulterminate>
  return cmd;
}
     8d0:	83 c4 10             	add    $0x10,%esp
     8d3:	89 f0                	mov    %esi,%eax
     8d5:	5b                   	pop    %ebx
     8d6:	5e                   	pop    %esi
     8d7:	5d                   	pop    %ebp
     8d8:	c3                   	ret    
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <fork1>:
  exit();
}

int
fork1(void)
{
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     8e6:	e8 82 05 00 00       	call   e6d <fork>
  if(pid == -1)
     8eb:	83 f8 ff             	cmp    $0xffffffff,%eax
     8ee:	74 08                	je     8f8 <fork1+0x18>
    panic("fork");
  return pid;
}
     8f0:	c9                   	leave  
     8f1:	c3                   	ret    
     8f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
     8f8:	c7 04 24 e5 13 00 00 	movl   $0x13e5,(%esp)
     8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     902:	e8 09 fb ff ff       	call   410 <panic>
     907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     90a:	c9                   	leave  
     90b:	c3                   	ret    
     90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 18             	sub    $0x18,%esp
     916:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     919:	8b 5d 08             	mov    0x8(%ebp),%ebx
     91c:	89 75 fc             	mov    %esi,-0x4(%ebp)
     91f:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     922:	c7 44 24 04 ea 13 00 	movl   $0x13ea,0x4(%esp)
     929:	00 
     92a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     931:	e8 9a 06 00 00       	call   fd0 <printf>
  memset(buf, 0, nbuf);
     936:	89 74 24 08          	mov    %esi,0x8(%esp)
     93a:	89 1c 24             	mov    %ebx,(%esp)
     93d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     944:	00 
     945:	e8 a6 03 00 00       	call   cf0 <memset>
  gets(buf, nbuf);
     94a:	89 74 24 04          	mov    %esi,0x4(%esp)
     94e:	89 1c 24             	mov    %ebx,(%esp)
     951:	e8 ba 04 00 00       	call   e10 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     956:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     959:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     95c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     95f:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     961:	89 ec                	mov    %ebp,%esp
     963:	5d                   	pop    %ebp
     964:	c3                   	ret    
     965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	53                   	push   %ebx
     974:	83 ec 24             	sub    $0x24,%esp
     977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     97a:	85 db                	test   %ebx,%ebx
     97c:	74 42                	je     9c0 <runcmd+0x50>
    exit();

  switch(cmd->type){
     97e:	83 3b 05             	cmpl   $0x5,(%ebx)
     981:	76 45                	jbe    9c8 <runcmd+0x58>
  default:
    panic("runcmd");
     983:	c7 04 24 ed 13 00 00 	movl   $0x13ed,(%esp)
     98a:	e8 81 fa ff ff       	call   410 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     98f:	8b 43 04             	mov    0x4(%ebx),%eax
     992:	85 c0                	test   %eax,%eax
     994:	74 2a                	je     9c0 <runcmd+0x50>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
     996:	8d 53 04             	lea    0x4(%ebx),%edx
     999:	89 54 24 04          	mov    %edx,0x4(%esp)
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 08 05 00 00       	call   ead <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     9a5:	8b 43 04             	mov    0x4(%ebx),%eax
     9a8:	c7 44 24 04 f4 13 00 	movl   $0x13f4,0x4(%esp)
     9af:	00 
     9b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9b7:	89 44 24 08          	mov    %eax,0x8(%esp)
     9bb:	e8 10 06 00 00       	call   fd0 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9c0:	e8 b0 04 00 00       	call   e75 <exit>
     9c5:	8d 76 00             	lea    0x0(%esi),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();

  switch(cmd->type){
     9c8:	8b 03                	mov    (%ebx),%eax
     9ca:	ff 24 85 60 13 00 00 	jmp    *0x1360(,%eax,4)
     9d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     9d8:	e8 03 ff ff ff       	call   8e0 <fork1>
     9dd:	85 c0                	test   %eax,%eax
     9df:	90                   	nop
     9e0:	0f 84 a7 00 00 00    	je     a8d <runcmd+0x11d>
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     9e6:	e8 8a 04 00 00       	call   e75 <exit>
     9eb:	90                   	nop
     9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     9f0:	e8 eb fe ff ff       	call   8e0 <fork1>
     9f5:	85 c0                	test   %eax,%eax
     9f7:	0f 84 a3 00 00 00    	je     aa0 <runcmd+0x130>
     9fd:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(lcmd->left);
    wait();
     a00:	e8 78 04 00 00       	call   e7d <wait>
    runcmd(lcmd->right);
     a05:	8b 43 08             	mov    0x8(%ebx),%eax
     a08:	89 04 24             	mov    %eax,(%esp)
     a0b:	e8 60 ff ff ff       	call   970 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a10:	e8 60 04 00 00       	call   e75 <exit>
     a15:	8d 76 00             	lea    0x0(%esi),%esi
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     a18:	8d 45 f0             	lea    -0x10(%ebp),%eax
     a1b:	89 04 24             	mov    %eax,(%esp)
     a1e:	e8 62 04 00 00       	call   e85 <pipe>
     a23:	85 c0                	test   %eax,%eax
     a25:	0f 88 25 01 00 00    	js     b50 <runcmd+0x1e0>
      panic("pipe");
    if(fork1() == 0){
     a2b:	e8 b0 fe ff ff       	call   8e0 <fork1>
     a30:	85 c0                	test   %eax,%eax
     a32:	0f 84 b8 00 00 00    	je     af0 <runcmd+0x180>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
     a38:	e8 a3 fe ff ff       	call   8e0 <fork1>
     a3d:	85 c0                	test   %eax,%eax
     a3f:	90                   	nop
     a40:	74 6e                	je     ab0 <runcmd+0x140>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
     a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a45:	89 04 24             	mov    %eax,(%esp)
     a48:	e8 50 04 00 00       	call   e9d <close>
    close(p[1]);
     a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a50:	89 04 24             	mov    %eax,(%esp)
     a53:	e8 45 04 00 00       	call   e9d <close>
    wait();
     a58:	e8 20 04 00 00       	call   e7d <wait>
    wait();
     a5d:	e8 1b 04 00 00       	call   e7d <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a62:	e8 0e 04 00 00       	call   e75 <exit>
     a67:	90                   	nop
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     a68:	8b 43 14             	mov    0x14(%ebx),%eax
     a6b:	89 04 24             	mov    %eax,(%esp)
     a6e:	e8 2a 04 00 00       	call   e9d <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     a73:	8b 43 10             	mov    0x10(%ebx),%eax
     a76:	89 44 24 04          	mov    %eax,0x4(%esp)
     a7a:	8b 43 08             	mov    0x8(%ebx),%eax
     a7d:	89 04 24             	mov    %eax,(%esp)
     a80:	e8 30 04 00 00       	call   eb5 <open>
     a85:	85 c0                	test   %eax,%eax
     a87:	0f 88 a3 00 00 00    	js     b30 <runcmd+0x1c0>
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
     a8d:	8b 43 04             	mov    0x4(%ebx),%eax
     a90:	89 04 24             	mov    %eax,(%esp)
     a93:	e8 d8 fe ff ff       	call   970 <runcmd>
    break;
  }
  exit();
     a98:	e8 d8 03 00 00       	call   e75 <exit>
     a9d:	8d 76 00             	lea    0x0(%esi),%esi
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
     aa0:	8b 43 04             	mov    0x4(%ebx),%eax
     aa3:	89 04 24             	mov    %eax,(%esp)
     aa6:	e8 c5 fe ff ff       	call   970 <runcmd>
     aab:	e9 4d ff ff ff       	jmp    9fd <runcmd+0x8d>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
     ab0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ab7:	e8 e1 03 00 00       	call   e9d <close>
      dup(p[0]);
     abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     abf:	89 04 24             	mov    %eax,(%esp)
     ac2:	e8 26 04 00 00       	call   eed <dup>
      close(p[0]);
     ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aca:	89 04 24             	mov    %eax,(%esp)
     acd:	e8 cb 03 00 00       	call   e9d <close>
      close(p[1]);
     ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad5:	89 04 24             	mov    %eax,(%esp)
     ad8:	e8 c0 03 00 00       	call   e9d <close>
      runcmd(pcmd->right);
     add:	8b 43 08             	mov    0x8(%ebx),%eax
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 88 fe ff ff       	call   970 <runcmd>
     ae8:	e9 55 ff ff ff       	jmp    a42 <runcmd+0xd2>
     aed:	8d 76 00             	lea    0x0(%esi),%esi
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     af0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     af7:	e8 a1 03 00 00       	call   e9d <close>
      dup(p[1]);
     afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aff:	89 04 24             	mov    %eax,(%esp)
     b02:	e8 e6 03 00 00       	call   eed <dup>
      close(p[0]);
     b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b0a:	89 04 24             	mov    %eax,(%esp)
     b0d:	e8 8b 03 00 00       	call   e9d <close>
      close(p[1]);
     b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b15:	89 04 24             	mov    %eax,(%esp)
     b18:	e8 80 03 00 00       	call   e9d <close>
      runcmd(pcmd->left);
     b1d:	8b 43 04             	mov    0x4(%ebx),%eax
     b20:	89 04 24             	mov    %eax,(%esp)
     b23:	e8 48 fe ff ff       	call   970 <runcmd>
     b28:	e9 0b ff ff ff       	jmp    a38 <runcmd+0xc8>
     b2d:	8d 76 00             	lea    0x0(%esi),%esi

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     b30:	8b 43 08             	mov    0x8(%ebx),%eax
     b33:	c7 44 24 04 04 14 00 	movl   $0x1404,0x4(%esp)
     b3a:	00 
     b3b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     b42:	89 44 24 08          	mov    %eax,0x8(%esp)
     b46:	e8 85 04 00 00       	call   fd0 <printf>
      exit();
     b4b:	e8 25 03 00 00       	call   e75 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     b50:	c7 04 24 14 14 00 00 	movl   $0x1414,(%esp)
     b57:	e8 b4 f8 ff ff       	call   410 <panic>
     b5c:	e9 ca fe ff ff       	jmp    a2b <runcmd+0xbb>
     b61:	eb 0d                	jmp    b70 <main>
     b63:	90                   	nop
     b64:	90                   	nop
     b65:	90                   	nop
     b66:	90                   	nop
     b67:	90                   	nop
     b68:	90                   	nop
     b69:	90                   	nop
     b6a:	90                   	nop
     b6b:	90                   	nop
     b6c:	90                   	nop
     b6d:	90                   	nop
     b6e:	90                   	nop
     b6f:	90                   	nop

00000b70 <main>:
  return 0;
}

int
main(void)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	83 e4 f0             	and    $0xfffffff0,%esp
     b76:	83 ec 10             	sub    $0x10,%esp
     b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     b80:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     b87:	00 
     b88:	c7 04 24 19 14 00 00 	movl   $0x1419,(%esp)
     b8f:	e8 21 03 00 00       	call   eb5 <open>
     b94:	85 c0                	test   %eax,%eax
     b96:	78 28                	js     bc0 <main+0x50>
    if(fd >= 3){
     b98:	83 f8 02             	cmp    $0x2,%eax
     b9b:	7e e3                	jle    b80 <main+0x10>
      close(fd);
     b9d:	89 04 24             	mov    %eax,(%esp)
     ba0:	e8 f8 02 00 00       	call   e9d <close>
      break;
     ba5:	eb 19                	jmp    bc0 <main+0x50>
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
     ba7:	c7 04 24 60 14 00 00 	movl   $0x1460,(%esp)
     bae:	e8 ad fc ff ff       	call   860 <parsecmd>
     bb3:	89 04 24             	mov    %eax,(%esp)
     bb6:	e8 b5 fd ff ff       	call   970 <runcmd>
    wait();
     bbb:	e8 bd 02 00 00       	call   e7d <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     bc0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     bc7:	00 
     bc8:	c7 04 24 60 14 00 00 	movl   $0x1460,(%esp)
     bcf:	e8 3c fd ff ff       	call   910 <getcmd>
     bd4:	85 c0                	test   %eax,%eax
     bd6:	78 70                	js     c48 <main+0xd8>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     bd8:	80 3d 60 14 00 00 63 	cmpb   $0x63,0x1460
     bdf:	75 09                	jne    bea <main+0x7a>
     be1:	80 3d 61 14 00 00 64 	cmpb   $0x64,0x1461
     be8:	74 0e                	je     bf8 <main+0x88>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
     bea:	e8 f1 fc ff ff       	call   8e0 <fork1>
     bef:	85 c0                	test   %eax,%eax
     bf1:	75 c8                	jne    bbb <main+0x4b>
     bf3:	eb b2                	jmp    ba7 <main+0x37>
     bf5:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     bf8:	80 3d 62 14 00 00 20 	cmpb   $0x20,0x1462
     bff:	90                   	nop
     c00:	75 e8                	jne    bea <main+0x7a>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     c02:	c7 04 24 60 14 00 00 	movl   $0x1460,(%esp)
     c09:	e8 c2 00 00 00       	call   cd0 <strlen>
      if(chdir(buf+3) < 0)
     c0e:	c7 04 24 63 14 00 00 	movl   $0x1463,(%esp)

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     c15:	c6 80 5f 14 00 00 00 	movb   $0x0,0x145f(%eax)
      if(chdir(buf+3) < 0)
     c1c:	e8 c4 02 00 00       	call   ee5 <chdir>
     c21:	85 c0                	test   %eax,%eax
     c23:	79 9b                	jns    bc0 <main+0x50>
        printf(2, "cannot cd %s\n", buf+3);
     c25:	c7 44 24 08 63 14 00 	movl   $0x1463,0x8(%esp)
     c2c:	00 
     c2d:	c7 44 24 04 21 14 00 	movl   $0x1421,0x4(%esp)
     c34:	00 
     c35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c3c:	e8 8f 03 00 00       	call   fd0 <printf>
     c41:	e9 7a ff ff ff       	jmp    bc0 <main+0x50>
     c46:	66 90                	xchg   %ax,%ax
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     c48:	e8 28 02 00 00       	call   e75 <exit>
     c4d:	66 90                	xchg   %ax,%ax
     c4f:	90                   	nop

00000c50 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c50:	55                   	push   %ebp
     c51:	31 d2                	xor    %edx,%edx
     c53:	89 e5                	mov    %esp,%ebp
     c55:	8b 45 08             	mov    0x8(%ebp),%eax
     c58:	53                   	push   %ebx
     c59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     c64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     c67:	83 c2 01             	add    $0x1,%edx
     c6a:	84 c9                	test   %cl,%cl
     c6c:	75 f2                	jne    c60 <strcpy+0x10>
    ;
  return os;
}
     c6e:	5b                   	pop    %ebx
     c6f:	5d                   	pop    %ebp
     c70:	c3                   	ret    
     c71:	eb 0d                	jmp    c80 <strcmp>
     c73:	90                   	nop
     c74:	90                   	nop
     c75:	90                   	nop
     c76:	90                   	nop
     c77:	90                   	nop
     c78:	90                   	nop
     c79:	90                   	nop
     c7a:	90                   	nop
     c7b:	90                   	nop
     c7c:	90                   	nop
     c7d:	90                   	nop
     c7e:	90                   	nop
     c7f:	90                   	nop

00000c80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c80:	55                   	push   %ebp
     c81:	89 e5                	mov    %esp,%ebp
     c83:	53                   	push   %ebx
     c84:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     c8a:	0f b6 01             	movzbl (%ecx),%eax
     c8d:	84 c0                	test   %al,%al
     c8f:	75 14                	jne    ca5 <strcmp+0x25>
     c91:	eb 25                	jmp    cb8 <strcmp+0x38>
     c93:	90                   	nop
     c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
     c98:	83 c1 01             	add    $0x1,%ecx
     c9b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     c9e:	0f b6 01             	movzbl (%ecx),%eax
     ca1:	84 c0                	test   %al,%al
     ca3:	74 13                	je     cb8 <strcmp+0x38>
     ca5:	0f b6 1a             	movzbl (%edx),%ebx
     ca8:	38 d8                	cmp    %bl,%al
     caa:	74 ec                	je     c98 <strcmp+0x18>
     cac:	0f b6 db             	movzbl %bl,%ebx
     caf:	0f b6 c0             	movzbl %al,%eax
     cb2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     cb4:	5b                   	pop    %ebx
     cb5:	5d                   	pop    %ebp
     cb6:	c3                   	ret    
     cb7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     cb8:	0f b6 1a             	movzbl (%edx),%ebx
     cbb:	31 c0                	xor    %eax,%eax
     cbd:	0f b6 db             	movzbl %bl,%ebx
     cc0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     cc2:	5b                   	pop    %ebx
     cc3:	5d                   	pop    %ebp
     cc4:	c3                   	ret    
     cc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cd0 <strlen>:

uint
strlen(char *s)
{
     cd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     cd1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     cd3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
     cd5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     cd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     cda:	80 39 00             	cmpb   $0x0,(%ecx)
     cdd:	74 0c                	je     ceb <strlen+0x1b>
     cdf:	90                   	nop
     ce0:	83 c2 01             	add    $0x1,%edx
     ce3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     ce7:	89 d0                	mov    %edx,%eax
     ce9:	75 f5                	jne    ce0 <strlen+0x10>
    ;
  return n;
}
     ceb:	5d                   	pop    %ebp
     cec:	c3                   	ret    
     ced:	8d 76 00             	lea    0x0(%esi),%esi

00000cf0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	8b 55 08             	mov    0x8(%ebp),%edx
     cf6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
     cfd:	89 d7                	mov    %edx,%edi
     cff:	fc                   	cld    
     d00:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     d02:	89 d0                	mov    %edx,%eax
     d04:	5f                   	pop    %edi
     d05:	5d                   	pop    %ebp
     d06:	c3                   	ret    
     d07:	89 f6                	mov    %esi,%esi
     d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d10 <strchr>:

char*
strchr(const char *s, char c)
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	8b 45 08             	mov    0x8(%ebp),%eax
     d16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     d1a:	0f b6 10             	movzbl (%eax),%edx
     d1d:	84 d2                	test   %dl,%dl
     d1f:	75 11                	jne    d32 <strchr+0x22>
     d21:	eb 15                	jmp    d38 <strchr+0x28>
     d23:	90                   	nop
     d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d28:	83 c0 01             	add    $0x1,%eax
     d2b:	0f b6 10             	movzbl (%eax),%edx
     d2e:	84 d2                	test   %dl,%dl
     d30:	74 06                	je     d38 <strchr+0x28>
    if(*s == c)
     d32:	38 ca                	cmp    %cl,%dl
     d34:	75 f2                	jne    d28 <strchr+0x18>
      return (char*)s;
  return 0;
}
     d36:	5d                   	pop    %ebp
     d37:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d38:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*)s;
  return 0;
}
     d3a:	5d                   	pop    %ebp
     d3b:	90                   	nop
     d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d40:	c3                   	ret    
     d41:	eb 0d                	jmp    d50 <atoi>
     d43:	90                   	nop
     d44:	90                   	nop
     d45:	90                   	nop
     d46:	90                   	nop
     d47:	90                   	nop
     d48:	90                   	nop
     d49:	90                   	nop
     d4a:	90                   	nop
     d4b:	90                   	nop
     d4c:	90                   	nop
     d4d:	90                   	nop
     d4e:	90                   	nop
     d4f:	90                   	nop

00000d50 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     d50:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d51:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
     d53:	89 e5                	mov    %esp,%ebp
     d55:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d58:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d59:	0f b6 11             	movzbl (%ecx),%edx
     d5c:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d5f:	80 fb 09             	cmp    $0x9,%bl
     d62:	77 1c                	ja     d80 <atoi+0x30>
     d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
     d68:	0f be d2             	movsbl %dl,%edx
     d6b:	83 c1 01             	add    $0x1,%ecx
     d6e:	8d 04 80             	lea    (%eax,%eax,4),%eax
     d71:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d75:	0f b6 11             	movzbl (%ecx),%edx
     d78:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d7b:	80 fb 09             	cmp    $0x9,%bl
     d7e:	76 e8                	jbe    d68 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
     d80:	5b                   	pop    %ebx
     d81:	5d                   	pop    %ebp
     d82:	c3                   	ret    
     d83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d90 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	56                   	push   %esi
     d94:	8b 45 08             	mov    0x8(%ebp),%eax
     d97:	53                   	push   %ebx
     d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
     d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d9e:	85 db                	test   %ebx,%ebx
     da0:	7e 14                	jle    db6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
     da2:	31 d2                	xor    %edx,%edx
     da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
     da8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     dac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     daf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     db2:	39 da                	cmp    %ebx,%edx
     db4:	75 f2                	jne    da8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
     db6:	5b                   	pop    %ebx
     db7:	5e                   	pop    %esi
     db8:	5d                   	pop    %ebp
     db9:	c3                   	ret    
     dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000dc0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
     dc9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     dcc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
     dcf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dd4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     ddb:	00 
     ddc:	89 04 24             	mov    %eax,(%esp)
     ddf:	e8 d1 00 00 00       	call   eb5 <open>
  if(fd < 0)
     de4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     de6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
     de8:	78 19                	js     e03 <stat+0x43>
    return -1;
  r = fstat(fd, st);
     dea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ded:	89 1c 24             	mov    %ebx,(%esp)
     df0:	89 44 24 04          	mov    %eax,0x4(%esp)
     df4:	e8 d4 00 00 00       	call   ecd <fstat>
  close(fd);
     df9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
     dfc:	89 c6                	mov    %eax,%esi
  close(fd);
     dfe:	e8 9a 00 00 00       	call   e9d <close>
  return r;
}
     e03:	89 f0                	mov    %esi,%eax
     e05:	8b 5d f8             	mov    -0x8(%ebp),%ebx
     e08:	8b 75 fc             	mov    -0x4(%ebp),%esi
     e0b:	89 ec                	mov    %ebp,%esp
     e0d:	5d                   	pop    %ebp
     e0e:	c3                   	ret    
     e0f:	90                   	nop

00000e10 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	57                   	push   %edi
     e14:	56                   	push   %esi
     e15:	31 f6                	xor    %esi,%esi
     e17:	53                   	push   %ebx
     e18:	83 ec 2c             	sub    $0x2c,%esp
     e1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e1e:	eb 06                	jmp    e26 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     e20:	3c 0a                	cmp    $0xa,%al
     e22:	74 39                	je     e5d <gets+0x4d>
     e24:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e26:	8d 5e 01             	lea    0x1(%esi),%ebx
     e29:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     e2c:	7d 31                	jge    e5f <gets+0x4f>
    cc = read(0, &c, 1);
     e2e:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e31:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e38:	00 
     e39:	89 44 24 04          	mov    %eax,0x4(%esp)
     e3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e44:	e8 44 00 00 00       	call   e8d <read>
    if(cc < 1)
     e49:	85 c0                	test   %eax,%eax
     e4b:	7e 12                	jle    e5f <gets+0x4f>
      break;
    buf[i++] = c;
     e4d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e51:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
     e55:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e59:	3c 0d                	cmp    $0xd,%al
     e5b:	75 c3                	jne    e20 <gets+0x10>
     e5d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     e5f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     e63:	89 f8                	mov    %edi,%eax
     e65:	83 c4 2c             	add    $0x2c,%esp
     e68:	5b                   	pop    %ebx
     e69:	5e                   	pop    %esi
     e6a:	5f                   	pop    %edi
     e6b:	5d                   	pop    %ebp
     e6c:	c3                   	ret    

00000e6d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e6d:	b8 01 00 00 00       	mov    $0x1,%eax
     e72:	cd 40                	int    $0x40
     e74:	c3                   	ret    

00000e75 <exit>:
SYSCALL(exit)
     e75:	b8 02 00 00 00       	mov    $0x2,%eax
     e7a:	cd 40                	int    $0x40
     e7c:	c3                   	ret    

00000e7d <wait>:
SYSCALL(wait)
     e7d:	b8 03 00 00 00       	mov    $0x3,%eax
     e82:	cd 40                	int    $0x40
     e84:	c3                   	ret    

00000e85 <pipe>:
SYSCALL(pipe)
     e85:	b8 04 00 00 00       	mov    $0x4,%eax
     e8a:	cd 40                	int    $0x40
     e8c:	c3                   	ret    

00000e8d <read>:
SYSCALL(read)
     e8d:	b8 05 00 00 00       	mov    $0x5,%eax
     e92:	cd 40                	int    $0x40
     e94:	c3                   	ret    

00000e95 <write>:
SYSCALL(write)
     e95:	b8 10 00 00 00       	mov    $0x10,%eax
     e9a:	cd 40                	int    $0x40
     e9c:	c3                   	ret    

00000e9d <close>:
SYSCALL(close)
     e9d:	b8 15 00 00 00       	mov    $0x15,%eax
     ea2:	cd 40                	int    $0x40
     ea4:	c3                   	ret    

00000ea5 <kill>:
SYSCALL(kill)
     ea5:	b8 06 00 00 00       	mov    $0x6,%eax
     eaa:	cd 40                	int    $0x40
     eac:	c3                   	ret    

00000ead <exec>:
SYSCALL(exec)
     ead:	b8 07 00 00 00       	mov    $0x7,%eax
     eb2:	cd 40                	int    $0x40
     eb4:	c3                   	ret    

00000eb5 <open>:
SYSCALL(open)
     eb5:	b8 0f 00 00 00       	mov    $0xf,%eax
     eba:	cd 40                	int    $0x40
     ebc:	c3                   	ret    

00000ebd <mknod>:
SYSCALL(mknod)
     ebd:	b8 11 00 00 00       	mov    $0x11,%eax
     ec2:	cd 40                	int    $0x40
     ec4:	c3                   	ret    

00000ec5 <unlink>:
SYSCALL(unlink)
     ec5:	b8 12 00 00 00       	mov    $0x12,%eax
     eca:	cd 40                	int    $0x40
     ecc:	c3                   	ret    

00000ecd <fstat>:
SYSCALL(fstat)
     ecd:	b8 08 00 00 00       	mov    $0x8,%eax
     ed2:	cd 40                	int    $0x40
     ed4:	c3                   	ret    

00000ed5 <link>:
SYSCALL(link)
     ed5:	b8 13 00 00 00       	mov    $0x13,%eax
     eda:	cd 40                	int    $0x40
     edc:	c3                   	ret    

00000edd <mkdir>:
SYSCALL(mkdir)
     edd:	b8 14 00 00 00       	mov    $0x14,%eax
     ee2:	cd 40                	int    $0x40
     ee4:	c3                   	ret    

00000ee5 <chdir>:
SYSCALL(chdir)
     ee5:	b8 09 00 00 00       	mov    $0x9,%eax
     eea:	cd 40                	int    $0x40
     eec:	c3                   	ret    

00000eed <dup>:
SYSCALL(dup)
     eed:	b8 0a 00 00 00       	mov    $0xa,%eax
     ef2:	cd 40                	int    $0x40
     ef4:	c3                   	ret    

00000ef5 <getpid>:
SYSCALL(getpid)
     ef5:	b8 0b 00 00 00       	mov    $0xb,%eax
     efa:	cd 40                	int    $0x40
     efc:	c3                   	ret    

00000efd <sbrk>:
SYSCALL(sbrk)
     efd:	b8 0c 00 00 00       	mov    $0xc,%eax
     f02:	cd 40                	int    $0x40
     f04:	c3                   	ret    

00000f05 <sleep>:
SYSCALL(sleep)
     f05:	b8 0d 00 00 00       	mov    $0xd,%eax
     f0a:	cd 40                	int    $0x40
     f0c:	c3                   	ret    

00000f0d <uptime>:
SYSCALL(uptime)
     f0d:	b8 0e 00 00 00       	mov    $0xe,%eax
     f12:	cd 40                	int    $0x40
     f14:	c3                   	ret    

00000f15 <date>:
SYSCALL(date)
     f15:	b8 16 00 00 00       	mov    $0x16,%eax
     f1a:	cd 40                	int    $0x40
     f1c:	c3                   	ret    

00000f1d <alarm>:
SYSCALL(alarm)
     f1d:	b8 17 00 00 00       	mov    $0x17,%eax
     f22:	cd 40                	int    $0x40
     f24:	c3                   	ret    
     f25:	66 90                	xchg   %ax,%ax
     f27:	66 90                	xchg   %ax,%ax
     f29:	66 90                	xchg   %ax,%ax
     f2b:	66 90                	xchg   %ax,%ax
     f2d:	66 90                	xchg   %ax,%ax
     f2f:	90                   	nop

00000f30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	57                   	push   %edi
     f34:	89 cf                	mov    %ecx,%edi
     f36:	56                   	push   %esi
     f37:	89 c6                	mov    %eax,%esi
     f39:	53                   	push   %ebx
     f3a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f40:	85 c9                	test   %ecx,%ecx
     f42:	74 04                	je     f48 <printint+0x18>
     f44:	85 d2                	test   %edx,%edx
     f46:	78 70                	js     fb8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f48:	89 d0                	mov    %edx,%eax
     f4a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     f51:	31 c9                	xor    %ecx,%ecx
     f53:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     f56:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
     f58:	31 d2                	xor    %edx,%edx
     f5a:	f7 f7                	div    %edi
     f5c:	0f b6 92 36 14 00 00 	movzbl 0x1436(%edx),%edx
     f63:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
     f66:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
     f69:	85 c0                	test   %eax,%eax
     f6b:	75 eb                	jne    f58 <printint+0x28>
  if(neg)
     f6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     f70:	85 c0                	test   %eax,%eax
     f72:	74 08                	je     f7c <printint+0x4c>
    buf[i++] = '-';
     f74:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
     f79:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
     f7c:	8d 79 ff             	lea    -0x1(%ecx),%edi
     f7f:	01 fb                	add    %edi,%ebx
     f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f88:	0f b6 03             	movzbl (%ebx),%eax
     f8b:	83 ef 01             	sub    $0x1,%edi
     f8e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f91:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     f98:	00 
     f99:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f9c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     f9f:	8d 45 e7             	lea    -0x19(%ebp),%eax
     fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     fa6:	e8 ea fe ff ff       	call   e95 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     fab:	83 ff ff             	cmp    $0xffffffff,%edi
     fae:	75 d8                	jne    f88 <printint+0x58>
    putc(fd, buf[i]);
}
     fb0:	83 c4 4c             	add    $0x4c,%esp
     fb3:	5b                   	pop    %ebx
     fb4:	5e                   	pop    %esi
     fb5:	5f                   	pop    %edi
     fb6:	5d                   	pop    %ebp
     fb7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     fb8:	89 d0                	mov    %edx,%eax
     fba:	f7 d8                	neg    %eax
     fbc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
     fc3:	eb 8c                	jmp    f51 <printint+0x21>
     fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000fd0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     fd0:	55                   	push   %ebp
     fd1:	89 e5                	mov    %esp,%ebp
     fd3:	57                   	push   %edi
     fd4:	56                   	push   %esi
     fd5:	53                   	push   %ebx
     fd6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fdc:	0f b6 10             	movzbl (%eax),%edx
     fdf:	84 d2                	test   %dl,%dl
     fe1:	0f 84 c9 00 00 00    	je     10b0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     fe7:	8d 4d 10             	lea    0x10(%ebp),%ecx
     fea:	31 ff                	xor    %edi,%edi
     fec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
     fef:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
     ff1:	8d 75 e7             	lea    -0x19(%ebp),%esi
     ff4:	eb 1e                	jmp    1014 <printf+0x44>
     ff6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     ff8:	83 fa 25             	cmp    $0x25,%edx
     ffb:	0f 85 b7 00 00 00    	jne    10b8 <printf+0xe8>
    1001:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1005:	83 c3 01             	add    $0x1,%ebx
    1008:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    100c:	84 d2                	test   %dl,%dl
    100e:	0f 84 9c 00 00 00    	je     10b0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
    1014:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1016:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
    1019:	74 dd                	je     ff8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    101b:	83 ff 25             	cmp    $0x25,%edi
    101e:	75 e5                	jne    1005 <printf+0x35>
      if(c == 'd'){
    1020:	83 fa 64             	cmp    $0x64,%edx
    1023:	0f 84 47 01 00 00    	je     1170 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1029:	83 fa 70             	cmp    $0x70,%edx
    102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1030:	0f 84 aa 00 00 00    	je     10e0 <printf+0x110>
    1036:	83 fa 78             	cmp    $0x78,%edx
    1039:	0f 84 a1 00 00 00    	je     10e0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    103f:	83 fa 73             	cmp    $0x73,%edx
    1042:	0f 84 c0 00 00 00    	je     1108 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1048:	83 fa 63             	cmp    $0x63,%edx
    104b:	90                   	nop
    104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1050:	0f 84 42 01 00 00    	je     1198 <printf+0x1c8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1056:	83 fa 25             	cmp    $0x25,%edx
    1059:	0f 84 01 01 00 00    	je     1160 <printf+0x190>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    105f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1062:	89 55 cc             	mov    %edx,-0x34(%ebp)
    1065:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1069:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1070:	00 
    1071:	89 74 24 04          	mov    %esi,0x4(%esp)
    1075:	89 0c 24             	mov    %ecx,(%esp)
    1078:	e8 18 fe ff ff       	call   e95 <write>
    107d:	8b 55 cc             	mov    -0x34(%ebp),%edx
    1080:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1083:	8b 45 08             	mov    0x8(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1086:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1089:	31 ff                	xor    %edi,%edi
    108b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1092:	00 
    1093:	89 74 24 04          	mov    %esi,0x4(%esp)
    1097:	89 04 24             	mov    %eax,(%esp)
    109a:	e8 f6 fd ff ff       	call   e95 <write>
    109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    10a2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    10a6:	84 d2                	test   %dl,%dl
    10a8:	0f 85 66 ff ff ff    	jne    1014 <printf+0x44>
    10ae:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10b0:	83 c4 3c             	add    $0x3c,%esp
    10b3:	5b                   	pop    %ebx
    10b4:	5e                   	pop    %esi
    10b5:	5f                   	pop    %edi
    10b6:	5d                   	pop    %ebp
    10b7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    10b8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    10bb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    10be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10c5:	00 
    10c6:	89 74 24 04          	mov    %esi,0x4(%esp)
    10ca:	89 04 24             	mov    %eax,(%esp)
    10cd:	e8 c3 fd ff ff       	call   e95 <write>
    10d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d5:	e9 2b ff ff ff       	jmp    1005 <printf+0x35>
    10da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    10e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    10e3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    10e8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    10ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10f1:	8b 10                	mov    (%eax),%edx
    10f3:	8b 45 08             	mov    0x8(%ebp),%eax
    10f6:	e8 35 fe ff ff       	call   f30 <printint>
    10fb:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    10fe:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1102:	e9 fe fe ff ff       	jmp    1005 <printf+0x35>
    1107:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    1108:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        ap++;
        if(s == 0)
    110b:	b9 2f 14 00 00       	mov    $0x142f,%ecx
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    1110:	8b 3a                	mov    (%edx),%edi
        ap++;
    1112:	83 c2 04             	add    $0x4,%edx
    1115:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    1118:	85 ff                	test   %edi,%edi
    111a:	0f 44 f9             	cmove  %ecx,%edi
          s = "(null)";
        while(*s != 0){
    111d:	0f b6 17             	movzbl (%edi),%edx
    1120:	84 d2                	test   %dl,%dl
    1122:	74 33                	je     1157 <printf+0x187>
    1124:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1127:	8b 5d 08             	mov    0x8(%ebp),%ebx
    112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
          s++;
    1130:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1133:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1136:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    113d:	00 
    113e:	89 74 24 04          	mov    %esi,0x4(%esp)
    1142:	89 1c 24             	mov    %ebx,(%esp)
    1145:	e8 4b fd ff ff       	call   e95 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    114a:	0f b6 17             	movzbl (%edi),%edx
    114d:	84 d2                	test   %dl,%dl
    114f:	75 df                	jne    1130 <printf+0x160>
    1151:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1154:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1157:	31 ff                	xor    %edi,%edi
    1159:	e9 a7 fe ff ff       	jmp    1005 <printf+0x35>
    115e:	66 90                	xchg   %ax,%ax
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1160:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1164:	e9 1a ff ff ff       	jmp    1083 <printf+0xb3>
    1169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1170:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1173:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    1178:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    117b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1182:	8b 10                	mov    (%eax),%edx
    1184:	8b 45 08             	mov    0x8(%ebp),%eax
    1187:	e8 a4 fd ff ff       	call   f30 <printint>
    118c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    118f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1193:	e9 6d fe ff ff       	jmp    1005 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1198:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        putc(fd, *ap);
        ap++;
    119b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    11a0:	8b 02                	mov    (%edx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    11a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11a9:	00 
    11aa:	89 74 24 04          	mov    %esi,0x4(%esp)
    11ae:	89 0c 24             	mov    %ecx,(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    11b1:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    11b4:	e8 dc fc ff ff       	call   e95 <write>
    11b9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    11bc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    11c0:	e9 40 fe ff ff       	jmp    1005 <printf+0x35>
    11c5:	66 90                	xchg   %ax,%ax
    11c7:	66 90                	xchg   %ax,%ax
    11c9:	66 90                	xchg   %ax,%ax
    11cb:	66 90                	xchg   %ax,%ax
    11cd:	66 90                	xchg   %ax,%ax
    11cf:	90                   	nop

000011d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d1:	a1 cc 14 00 00       	mov    0x14cc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    11d6:	89 e5                	mov    %esp,%ebp
    11d8:	57                   	push   %edi
    11d9:	56                   	push   %esi
    11da:	53                   	push   %ebx
    11db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e1:	39 c8                	cmp    %ecx,%eax
    11e3:	73 1d                	jae    1202 <free+0x32>
    11e5:	8d 76 00             	lea    0x0(%esi),%esi
    11e8:	8b 10                	mov    (%eax),%edx
    11ea:	39 d1                	cmp    %edx,%ecx
    11ec:	72 1a                	jb     1208 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ee:	39 d0                	cmp    %edx,%eax
    11f0:	72 08                	jb     11fa <free+0x2a>
    11f2:	39 c8                	cmp    %ecx,%eax
    11f4:	72 12                	jb     1208 <free+0x38>
    11f6:	39 d1                	cmp    %edx,%ecx
    11f8:	72 0e                	jb     1208 <free+0x38>
    11fa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11fc:	39 c8                	cmp    %ecx,%eax
    11fe:	66 90                	xchg   %ax,%ax
    1200:	72 e6                	jb     11e8 <free+0x18>
    1202:	8b 10                	mov    (%eax),%edx
    1204:	eb e8                	jmp    11ee <free+0x1e>
    1206:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1208:	8b 71 04             	mov    0x4(%ecx),%esi
    120b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    120e:	39 d7                	cmp    %edx,%edi
    1210:	74 19                	je     122b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1212:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1215:	8b 50 04             	mov    0x4(%eax),%edx
    1218:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    121b:	39 ce                	cmp    %ecx,%esi
    121d:	74 23                	je     1242 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    121f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1221:	a3 cc 14 00 00       	mov    %eax,0x14cc
}
    1226:	5b                   	pop    %ebx
    1227:	5e                   	pop    %esi
    1228:	5f                   	pop    %edi
    1229:	5d                   	pop    %ebp
    122a:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    122b:	03 72 04             	add    0x4(%edx),%esi
    122e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1231:	8b 10                	mov    (%eax),%edx
    1233:	8b 12                	mov    (%edx),%edx
    1235:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1238:	8b 50 04             	mov    0x4(%eax),%edx
    123b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    123e:	39 ce                	cmp    %ecx,%esi
    1240:	75 dd                	jne    121f <free+0x4f>
    p->s.size += bp->s.size;
    1242:	03 51 04             	add    0x4(%ecx),%edx
    1245:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1248:	8b 53 f8             	mov    -0x8(%ebx),%edx
    124b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    124d:	a3 cc 14 00 00       	mov    %eax,0x14cc
}
    1252:	5b                   	pop    %ebx
    1253:	5e                   	pop    %esi
    1254:	5f                   	pop    %edi
    1255:	5d                   	pop    %ebp
    1256:	c3                   	ret    
    1257:	89 f6                	mov    %esi,%esi
    1259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001260 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1260:	55                   	push   %ebp
    1261:	89 e5                	mov    %esp,%ebp
    1263:	57                   	push   %edi
    1264:	56                   	push   %esi
    1265:	53                   	push   %ebx
    1266:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1269:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    126c:	8b 0d cc 14 00 00    	mov    0x14cc,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1272:	83 c3 07             	add    $0x7,%ebx
    1275:	c1 eb 03             	shr    $0x3,%ebx
    1278:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    127b:	85 c9                	test   %ecx,%ecx
    127d:	0f 84 9b 00 00 00    	je     131e <malloc+0xbe>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1283:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    1285:	8b 50 04             	mov    0x4(%eax),%edx
    1288:	39 d3                	cmp    %edx,%ebx
    128a:	76 27                	jbe    12b3 <malloc+0x53>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    128c:	8d 3c dd 00 00 00 00 	lea    0x0(,%ebx,8),%edi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1293:	be 00 80 00 00       	mov    $0x8000,%esi
    1298:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    129b:	90                   	nop
    129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12a0:	3b 05 cc 14 00 00    	cmp    0x14cc,%eax
    12a6:	74 30                	je     12d8 <malloc+0x78>
    12a8:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12aa:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    12ac:	8b 50 04             	mov    0x4(%eax),%edx
    12af:	39 d3                	cmp    %edx,%ebx
    12b1:	77 ed                	ja     12a0 <malloc+0x40>
      if(p->s.size == nunits)
    12b3:	39 d3                	cmp    %edx,%ebx
    12b5:	74 61                	je     1318 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    12b7:	29 da                	sub    %ebx,%edx
    12b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12bc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    12bf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    12c2:	89 0d cc 14 00 00    	mov    %ecx,0x14cc
      return (void*)(p + 1);
    12c8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12cb:	83 c4 2c             	add    $0x2c,%esp
    12ce:	5b                   	pop    %ebx
    12cf:	5e                   	pop    %esi
    12d0:	5f                   	pop    %edi
    12d1:	5d                   	pop    %ebp
    12d2:	c3                   	ret    
    12d3:	90                   	nop
    12d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    12d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12db:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    12e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    12e6:	0f 43 fb             	cmovae %ebx,%edi
    12e9:	0f 42 c6             	cmovb  %esi,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    12ec:	89 04 24             	mov    %eax,(%esp)
    12ef:	e8 09 fc ff ff       	call   efd <sbrk>
  if(p == (char*)-1)
    12f4:	83 f8 ff             	cmp    $0xffffffff,%eax
    12f7:	74 18                	je     1311 <malloc+0xb1>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    12f9:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    12fc:	83 c0 08             	add    $0x8,%eax
    12ff:	89 04 24             	mov    %eax,(%esp)
    1302:	e8 c9 fe ff ff       	call   11d0 <free>
  return freep;
    1307:	8b 0d cc 14 00 00    	mov    0x14cc,%ecx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    130d:	85 c9                	test   %ecx,%ecx
    130f:	75 99                	jne    12aa <malloc+0x4a>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1311:	31 c0                	xor    %eax,%eax
    1313:	eb b6                	jmp    12cb <malloc+0x6b>
    1315:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1318:	8b 10                	mov    (%eax),%edx
    131a:	89 11                	mov    %edx,(%ecx)
    131c:	eb a4                	jmp    12c2 <malloc+0x62>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    131e:	c7 05 cc 14 00 00 c4 	movl   $0x14c4,0x14cc
    1325:	14 00 00 
    base.s.size = 0;
    1328:	b9 c4 14 00 00       	mov    $0x14c4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    132d:	c7 05 c4 14 00 00 c4 	movl   $0x14c4,0x14c4
    1334:	14 00 00 
    base.s.size = 0;
    1337:	c7 05 c8 14 00 00 00 	movl   $0x0,0x14c8
    133e:	00 00 00 
    1341:	e9 3d ff ff ff       	jmp    1283 <malloc+0x23>
