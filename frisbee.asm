
_frisbee:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void pass_next(void *arg);
int lookup();



int main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 58             	sub    $0x58,%esp
  14:	89 cb                	mov    %ecx,%ebx

    int i;
    struct thread *t;
//    void * sp;

    if(argc != 3){
  16:	83 3b 03             	cmpl   $0x3,(%ebx)
  19:	74 19                	je     34 <main+0x34>
        printf(1,"argc is not match !\n");
  1b:	c7 44 24 04 80 0e 00 	movl   $0xe80,0x4(%esp)
  22:	00 
  23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2a:	e8 36 08 00 00       	call   865 <printf>
        exit();
  2f:	e8 98 06 00 00       	call   6cc <exit>
    }
    numthreads = atoi(argv[1]);
  34:	8b 43 04             	mov    0x4(%ebx),%eax
  37:	83 c0 04             	add    $0x4,%eax
  3a:	8b 00                	mov    (%eax),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 f6 05 00 00       	call   63a <atoi>
  44:	a3 c0 0f 00 00       	mov    %eax,0xfc0
    numpass = atoi(argv[2]);
  49:	8b 43 04             	mov    0x4(%ebx),%eax
  4c:	83 c0 08             	add    $0x8,%eax
  4f:	8b 00                	mov    (%eax),%eax
  51:	89 04 24             	mov    %eax,(%esp)
  54:	e8 e1 05 00 00       	call   63a <atoi>
  59:	a3 c4 0f 00 00       	mov    %eax,0xfc4

    void * slist[numthreads];
  5e:	8b 0d c0 0f 00 00    	mov    0xfc0,%ecx
  64:	8d 41 ff             	lea    -0x1(%ecx),%eax
  67:	89 45 d0             	mov    %eax,-0x30(%ebp)
  6a:	89 c8                	mov    %ecx,%eax
  6c:	ba 00 00 00 00       	mov    $0x0,%edx
  71:	89 c6                	mov    %eax,%esi
  73:	83 e6 ff             	and    $0xffffffff,%esi
  76:	89 d7                	mov    %edx,%edi
  78:	83 e7 0f             	and    $0xf,%edi
  7b:	89 f0                	mov    %esi,%eax
  7d:	89 fa                	mov    %edi,%edx
  7f:	0f a4 c2 05          	shld   $0x5,%eax,%edx
  83:	c1 e0 05             	shl    $0x5,%eax
  86:	89 c3                	mov    %eax,%ebx
  88:	80 e7 ff             	and    $0xff,%bh
  8b:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8e:	89 d3                	mov    %edx,%ebx
  90:	83 e3 0f             	and    $0xf,%ebx
  93:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  99:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  9c:	89 c8                	mov    %ecx,%eax
  9e:	ba 00 00 00 00       	mov    $0x0,%edx
  a3:	89 c3                	mov    %eax,%ebx
  a5:	80 e7 ff             	and    $0xff,%bh
  a8:	89 5d b8             	mov    %ebx,-0x48(%ebp)
  ab:	89 d3                	mov    %edx,%ebx
  ad:	83 e3 0f             	and    $0xf,%ebx
  b0:	89 5d bc             	mov    %ebx,-0x44(%ebp)
  b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  b6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  b9:	0f a4 c2 05          	shld   $0x5,%eax,%edx
  bd:	c1 e0 05             	shl    $0x5,%eax
  c0:	89 c3                	mov    %eax,%ebx
  c2:	80 e7 ff             	and    $0xff,%bh
  c5:	89 5d b0             	mov    %ebx,-0x50(%ebp)
  c8:	89 d3                	mov    %edx,%ebx
  ca:	83 e3 0f             	and    $0xf,%ebx
  cd:	89 5d b4             	mov    %ebx,-0x4c(%ebp)
  d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  d3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  d6:	89 c8                	mov    %ecx,%eax
  d8:	c1 e0 02             	shl    $0x2,%eax
  db:	83 c0 0f             	add    $0xf,%eax
  de:	83 c0 0f             	add    $0xf,%eax
  e1:	c1 e8 04             	shr    $0x4,%eax
  e4:	c1 e0 04             	shl    $0x4,%eax
  e7:	29 c4                	sub    %eax,%esp
  e9:	8d 44 24 0c          	lea    0xc(%esp),%eax
  ed:	83 c0 0f             	add    $0xf,%eax
  f0:	c1 e8 04             	shr    $0x4,%eax
  f3:	c1 e0 04             	shl    $0x4,%eax
  f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    //init ttable;
    lock_init(&ttable.lock);
  f9:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 100:	e8 41 0b 00 00       	call   c46 <lock_init>
    ttable.total = 0;
 105:	c7 05 e4 11 00 00 00 	movl   $0x0,0x11e4
 10c:	00 00 00 
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 10f:	c7 45 dc e4 0f 00 00 	movl   $0xfe4,-0x24(%ebp)
 116:	eb 0d                	jmp    125 <main+0x125>
        t->tid = 0;
 118:	8b 45 dc             	mov    -0x24(%ebp),%eax
 11b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    void * slist[numthreads];

    //init ttable;
    lock_init(&ttable.lock);
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 121:	83 45 dc 08          	addl   $0x8,-0x24(%ebp)
 125:	b8 e4 11 00 00       	mov    $0x11e4,%eax
 12a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
 12d:	72 e9                	jb     118 <main+0x118>
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
 12f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 136:	eb 11                	jmp    149 <main+0x149>
        slist[i]=0;
 138:	8b 55 d8             	mov    -0x28(%ebp),%edx
 13b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 13e:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
    ttable.total = 0;
    for(t=ttable.thread;t < &ttable.thread[64];t++){
        t->tid = 0;
    }
    //init stack list
    for(i = 0; i < 64;i++){
 145:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 149:	83 7d d8 3f          	cmpl   $0x3f,-0x28(%ebp)
 14d:	7e e9                	jle    138 <main+0x138>
        slist[i]=0;
    }
    //init frisbee
    lock_init(&frisbee.lock);
 14f:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 156:	e8 eb 0a 00 00       	call   c46 <lock_init>
    frisbee.pass = 0;
 15b:	c7 05 ec 11 00 00 00 	movl   $0x0,0x11ec
 162:	00 00 00 
    frisbee.holding_thread = 0;
 165:	c7 05 f0 11 00 00 00 	movl   $0x0,0x11f0
 16c:	00 00 00 

    printf(1,"\nnum of threads %d \n",numthreads);
 16f:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 174:	89 44 24 08          	mov    %eax,0x8(%esp)
 178:	c7 44 24 04 95 0e 00 	movl   $0xe95,0x4(%esp)
 17f:	00 
 180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 187:	e8 d9 06 00 00       	call   865 <printf>
    printf(1,"num of passes %d \n\n",numpass);
 18c:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 191:	89 44 24 08          	mov    %eax,0x8(%esp)
 195:	c7 44 24 04 aa 0e 00 	movl   $0xeaa,0x4(%esp)
 19c:	00 
 19d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a4:	e8 bc 06 00 00       	call   865 <printf>


    for(i=0; i<numthreads;i++){
 1a9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 1b0:	eb 43                	jmp    1f5 <main+0x1f5>
        void *stack = thread_create(pass_next,(void *)0);      
 1b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b9:	00 
 1ba:	c7 04 24 a0 02 00 00 	movl   $0x2a0,(%esp)
 1c1:	e8 c8 0a 00 00       	call   c8e <thread_create>
 1c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(stack == 0)
 1c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 1cd:	75 16                	jne    1e5 <main+0x1e5>
            printf(1,"thread_create fail\n");
 1cf:	c7 44 24 04 be 0e 00 	movl   $0xebe,0x4(%esp)
 1d6:	00 
 1d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1de:	e8 82 06 00 00       	call   865 <printf>
 1e3:	eb 0c                	jmp    1f1 <main+0x1f1>
        else{
            slist[i] = stack;
 1e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
 1e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 1ee:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    printf(1,"\nnum of threads %d \n",numthreads);
    printf(1,"num of passes %d \n\n",numpass);


    for(i=0; i<numthreads;i++){
 1f1:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 1f5:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 1fa:	39 45 d8             	cmp    %eax,-0x28(%ebp)
 1fd:	7c b3                	jl     1b2 <main+0x1b2>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
 1ff:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 206:	eb 0e                	jmp    216 <main+0x216>
        if(wait() == -1)
 208:	e8 c7 04 00 00       	call   6d4 <wait>
 20d:	83 f8 ff             	cmp    $0xffffffff,%eax
 210:	74 10                	je     222 <main+0x222>
        else{
            slist[i] = stack;
        }
    }
//    sleep(5);
    for(i=0;i<numthreads;i++){
 212:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 216:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 21b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
 21e:	7c e8                	jl     208 <main+0x208>
 220:	eb 01                	jmp    223 <main+0x223>
        if(wait() == -1)
            break;
 222:	90                   	nop
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 223:	c7 45 dc e4 0f 00 00 	movl   $0xfe4,-0x24(%ebp)
 22a:	eb 2a                	jmp    256 <main+0x256>
        if(t->tid != 0)
 22c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 22f:	8b 00                	mov    (%eax),%eax
 231:	85 c0                	test   %eax,%eax
 233:	74 1d                	je     252 <main+0x252>
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
 235:	8b 45 dc             	mov    -0x24(%ebp),%eax
 238:	8b 00                	mov    (%eax),%eax
 23a:	89 44 24 08          	mov    %eax,0x8(%esp)
 23e:	c7 44 24 04 d4 0e 00 	movl   $0xed4,0x4(%esp)
 245:	00 
 246:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24d:	e8 13 06 00 00       	call   865 <printf>
    for(i=0;i<numthreads;i++){
        if(wait() == -1)
            break;
    }
   // add printf for tid look up.  
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 252:	83 45 dc 08          	addl   $0x8,-0x24(%ebp)
 256:	b8 e4 11 00 00       	mov    $0x11e4,%eax
 25b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
 25e:	72 cc                	jb     22c <main+0x22c>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
 260:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 267:	eb 28                	jmp    291 <main+0x291>
        if(slist[i] != 0){
 269:	8b 55 d8             	mov    -0x28(%ebp),%edx
 26c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 26f:	8b 04 90             	mov    (%eax,%edx,4),%eax
 272:	85 c0                	test   %eax,%eax
 274:	74 17                	je     28d <main+0x28d>
            void * f = slist[i];
 276:	8b 55 d8             	mov    -0x28(%ebp),%edx
 279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 27c:	8b 04 90             	mov    (%eax,%edx,4),%eax
 27f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            free(f);
 282:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 8f 07 00 00       	call   a1c <free>
        if(t->tid != 0)
            printf(1,"thread %d was killed! stack was freed.\n",t->tid);
    }

    //free stacks
    for(i=0;i<numthreads;i++){
 28d:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 291:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 296:	39 45 d8             	cmp    %eax,-0x28(%ebp)
 299:	7c ce                	jl     269 <main+0x269>
        if(slist[i] != 0){
            void * f = slist[i];
            free(f);
        }
    }
    exit();
 29b:	e8 2c 04 00 00       	call   6cc <exit>

000002a0 <pass_next>:
}

void pass_next(void *arg){
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 28             	sub    $0x28,%esp
    struct thread *t;
    int tid;

    tid = getpid();
 2a6:	e8 a1 04 00 00       	call   74c <getpid>
 2ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

    lock_acquire(&ttable.lock);
 2ae:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 2b5:	e8 9a 09 00 00       	call   c54 <lock_acquire>
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 2ba:	c7 45 f0 e4 0f 00 00 	movl   $0xfe4,-0x10(%ebp)
 2c1:	eb 17                	jmp    2da <pass_next+0x3a>
        if(t->tid == 0){
 2c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c6:	8b 00                	mov    (%eax),%eax
 2c8:	85 c0                	test   %eax,%eax
 2ca:	75 0a                	jne    2d6 <pass_next+0x36>
            t->tid = tid;
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2d2:	89 10                	mov    %edx,(%eax)
            break;
 2d4:	eb 0e                	jmp    2e4 <pass_next+0x44>
    int tid;

    tid = getpid();

    lock_acquire(&ttable.lock);
    for(t=ttable.thread;t < &ttable.thread[64];t++){
 2d6:	83 45 f0 08          	addl   $0x8,-0x10(%ebp)
 2da:	b8 e4 11 00 00       	mov    $0x11e4,%eax
 2df:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 2e2:	72 df                	jb     2c3 <pass_next+0x23>
        if(t->tid == 0){
            t->tid = tid;
            break;
        } 
    }
    ttable.total++;
 2e4:	a1 e4 11 00 00       	mov    0x11e4,%eax
 2e9:	83 c0 01             	add    $0x1,%eax
 2ec:	a3 e4 11 00 00       	mov    %eax,0x11e4
    lock_release(&ttable.lock);
 2f1:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 2f8:	e8 76 09 00 00       	call   c73 <lock_release>

   for(;;){
        lock_acquire(&ttable.lock);
 2fd:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 304:	e8 4b 09 00 00       	call   c54 <lock_acquire>
        if(ttable.total == numthreads){
 309:	8b 15 e4 11 00 00    	mov    0x11e4,%edx
 30f:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 314:	39 c2                	cmp    %eax,%edx
 316:	75 39                	jne    351 <pass_next+0xb1>
            printf(1," tid %d ready to go\n",t->tid);
 318:	8b 45 f0             	mov    -0x10(%ebp),%eax
 31b:	8b 00                	mov    (%eax),%eax
 31d:	89 44 24 08          	mov    %eax,0x8(%esp)
 321:	c7 44 24 04 fc 0e 00 	movl   $0xefc,0x4(%esp)
 328:	00 
 329:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 330:	e8 30 05 00 00       	call   865 <printf>
            barrier++;
 335:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	a3 c8 0f 00 00       	mov    %eax,0xfc8
            goto start;
 342:	90                   	nop
        lock_release(&ttable.lock);
    }
    
//barriar above
start:
     lock_release(&ttable.lock);
 343:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 34a:	e8 24 09 00 00       	call   c73 <lock_release>
 34f:	eb 0e                	jmp    35f <pass_next+0xbf>
        if(ttable.total == numthreads){
            printf(1," tid %d ready to go\n",t->tid);
            barrier++;
            goto start;
        }
        lock_release(&ttable.lock);
 351:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
 358:	e8 16 09 00 00       	call   c73 <lock_release>
    }
 35d:	eb 9e                	jmp    2fd <pass_next+0x5d>
    
//barriar above
start:
     lock_release(&ttable.lock);
     while(barrier != numthreads);
 35f:	8b 15 c8 0f 00 00    	mov    0xfc8,%edx
 365:	a1 c0 0f 00 00       	mov    0xfc0,%eax
 36a:	39 c2                	cmp    %eax,%edx
 36c:	75 f1                	jne    35f <pass_next+0xbf>
    //throw frisbee
    do{
        lock_acquire(&frisbee.lock);
 36e:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 375:	e8 da 08 00 00       	call   c54 <lock_acquire>
        if(frisbee.pass > numpass){
 37a:	8b 15 ec 11 00 00    	mov    0x11ec,%edx
 380:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 385:	39 c2                	cmp    %eax,%edx
 387:	7e 39                	jle    3c2 <pass_next+0x122>
            lock_release(&frisbee.lock);
 389:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 390:	e8 de 08 00 00       	call   c73 <lock_release>
            goto leaving;
 395:	90                   	nop
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);

leaving: 
    lock_release(&frisbee.lock);
 396:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 39d:	e8 d1 08 00 00       	call   c73 <lock_release>
    printf(1,"thread %d out of game\n",tid);
 3a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a5:	89 44 24 08          	mov    %eax,0x8(%esp)
 3a9:	c7 44 24 04 48 0f 00 	movl   $0xf48,0x4(%esp)
 3b0:	00 
 3b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3b8:	e8 a8 04 00 00       	call   865 <printf>
    texit();
 3bd:	e8 b2 03 00 00       	call   774 <texit>
        lock_acquire(&frisbee.lock);
        if(frisbee.pass > numpass){
            lock_release(&frisbee.lock);
            goto leaving;
        }
        if(frisbee.holding_thread == tid){
 3c2:	a1 f0 11 00 00       	mov    0x11f0,%eax
 3c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 3ca:	75 1b                	jne    3e7 <pass_next+0x147>
            lock_release(&frisbee.lock);
 3cc:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 3d3:	e8 9b 08 00 00       	call   c73 <lock_release>
            sleep(5);
 3d8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3df:	e8 78 03 00 00       	call   75c <sleep>
            continue;
 3e4:	90                   	nop
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
                frisbee.pass, tid);
        frisbee.pass++;
        frisbee.holding_thread = tid;
        lock_release(&frisbee.lock);
    }while(1);
 3e5:	eb 87                	jmp    36e <pass_next+0xce>
        if(frisbee.holding_thread == tid){
            lock_release(&frisbee.lock);
            sleep(5);
            continue;
        }
        printf(1,"pass: %d, thread %d catch the frisbee. throwing...\n",
 3e7:	a1 ec 11 00 00       	mov    0x11ec,%eax
 3ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ef:	89 54 24 0c          	mov    %edx,0xc(%esp)
 3f3:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f7:	c7 44 24 04 14 0f 00 	movl   $0xf14,0x4(%esp)
 3fe:	00 
 3ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 406:	e8 5a 04 00 00       	call   865 <printf>
                frisbee.pass, tid);
        frisbee.pass++;
 40b:	a1 ec 11 00 00       	mov    0x11ec,%eax
 410:	83 c0 01             	add    $0x1,%eax
 413:	a3 ec 11 00 00       	mov    %eax,0x11ec
        frisbee.holding_thread = tid;
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	a3 f0 11 00 00       	mov    %eax,0x11f0
        lock_release(&frisbee.lock);
 420:	c7 04 24 e8 11 00 00 	movl   $0x11e8,(%esp)
 427:	e8 47 08 00 00       	call   c73 <lock_release>
    }while(1);
 42c:	e9 3d ff ff ff       	jmp    36e <pass_next+0xce>

00000431 <lookup>:
    lock_release(&frisbee.lock);
    printf(1,"thread %d out of game\n",tid);
    texit();
}

int lookup(int num_threads){
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 10             	sub    $0x10,%esp
    int i;
    struct thread *t;
    i = 0;
 437:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(t=ttable.thread;t<&ttable.thread[64];t++){
 43e:	c7 45 fc e4 0f 00 00 	movl   $0xfe4,-0x4(%ebp)
 445:	eb 11                	jmp    458 <lookup+0x27>
        if(t->tid != 0){
 447:	8b 45 fc             	mov    -0x4(%ebp),%eax
 44a:	8b 00                	mov    (%eax),%eax
 44c:	85 c0                	test   %eax,%eax
 44e:	74 04                	je     454 <lookup+0x23>
            i++;
 450:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)

int lookup(int num_threads){
    int i;
    struct thread *t;
    i = 0;
    for(t=ttable.thread;t<&ttable.thread[64];t++){
 454:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
 458:	b8 e4 11 00 00       	mov    $0x11e4,%eax
 45d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 460:	72 e5                	jb     447 <lookup+0x16>
        if(t->tid != 0){
            i++;
        }
    }
    return i;
 462:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 465:	c9                   	leave  
 466:	c3                   	ret    
 467:	90                   	nop

00000468 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 468:	55                   	push   %ebp
 469:	89 e5                	mov    %esp,%ebp
 46b:	57                   	push   %edi
 46c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 46d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 470:	8b 55 10             	mov    0x10(%ebp),%edx
 473:	8b 45 0c             	mov    0xc(%ebp),%eax
 476:	89 cb                	mov    %ecx,%ebx
 478:	89 df                	mov    %ebx,%edi
 47a:	89 d1                	mov    %edx,%ecx
 47c:	fc                   	cld    
 47d:	f3 aa                	rep stos %al,%es:(%edi)
 47f:	89 ca                	mov    %ecx,%edx
 481:	89 fb                	mov    %edi,%ebx
 483:	89 5d 08             	mov    %ebx,0x8(%ebp)
 486:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 489:	5b                   	pop    %ebx
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    

0000048d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	0f b6 10             	movzbl (%eax),%edx
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	88 10                	mov    %dl,(%eax)
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	0f b6 00             	movzbl (%eax),%eax
 4aa:	84 c0                	test   %al,%al
 4ac:	0f 95 c0             	setne  %al
 4af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 4b7:	84 c0                	test   %al,%al
 4b9:	75 de                	jne    499 <strcpy+0xc>
    ;
  return os;
 4bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4be:	c9                   	leave  
 4bf:	c3                   	ret    

000004c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4c3:	eb 08                	jmp    4cd <strcmp+0xd>
    p++, q++;
 4c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	0f b6 00             	movzbl (%eax),%eax
 4d3:	84 c0                	test   %al,%al
 4d5:	74 10                	je     4e7 <strcmp+0x27>
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	0f b6 10             	movzbl (%eax),%edx
 4dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e0:	0f b6 00             	movzbl (%eax),%eax
 4e3:	38 c2                	cmp    %al,%dl
 4e5:	74 de                	je     4c5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	0f b6 00             	movzbl (%eax),%eax
 4ed:	0f b6 d0             	movzbl %al,%edx
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f b6 c0             	movzbl %al,%eax
 4f9:	89 d1                	mov    %edx,%ecx
 4fb:	29 c1                	sub    %eax,%ecx
 4fd:	89 c8                	mov    %ecx,%eax
}
 4ff:	5d                   	pop    %ebp
 500:	c3                   	ret    

00000501 <strlen>:

uint
strlen(char *s)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 50e:	eb 04                	jmp    514 <strlen+0x13>
 510:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 514:	8b 45 fc             	mov    -0x4(%ebp),%eax
 517:	03 45 08             	add    0x8(%ebp),%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	84 c0                	test   %al,%al
 51f:	75 ef                	jne    510 <strlen+0xf>
    ;
  return n;
 521:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 524:	c9                   	leave  
 525:	c3                   	ret    

00000526 <memset>:

void*
memset(void *dst, int c, uint n)
{
 526:	55                   	push   %ebp
 527:	89 e5                	mov    %esp,%ebp
 529:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 52c:	8b 45 10             	mov    0x10(%ebp),%eax
 52f:	89 44 24 08          	mov    %eax,0x8(%esp)
 533:	8b 45 0c             	mov    0xc(%ebp),%eax
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 23 ff ff ff       	call   468 <stosb>
  return dst;
 545:	8b 45 08             	mov    0x8(%ebp),%eax
}
 548:	c9                   	leave  
 549:	c3                   	ret    

0000054a <strchr>:

char*
strchr(const char *s, char c)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	83 ec 04             	sub    $0x4,%esp
 550:	8b 45 0c             	mov    0xc(%ebp),%eax
 553:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 556:	eb 14                	jmp    56c <strchr+0x22>
    if(*s == c)
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 561:	75 05                	jne    568 <strchr+0x1e>
      return (char*)s;
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	eb 13                	jmp    57b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 568:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	84 c0                	test   %al,%al
 574:	75 e2                	jne    558 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 576:	b8 00 00 00 00       	mov    $0x0,%eax
}
 57b:	c9                   	leave  
 57c:	c3                   	ret    

0000057d <gets>:

char*
gets(char *buf, int max)
{
 57d:	55                   	push   %ebp
 57e:	89 e5                	mov    %esp,%ebp
 580:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 583:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 58a:	eb 44                	jmp    5d0 <gets+0x53>
    cc = read(0, &c, 1);
 58c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 593:	00 
 594:	8d 45 ef             	lea    -0x11(%ebp),%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5a2:	e8 3d 01 00 00       	call   6e4 <read>
 5a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 5aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ae:	7e 2d                	jle    5dd <gets+0x60>
      break;
    buf[i++] = c;
 5b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b3:	03 45 08             	add    0x8(%ebp),%eax
 5b6:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 5ba:	88 10                	mov    %dl,(%eax)
 5bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 5c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c4:	3c 0a                	cmp    $0xa,%al
 5c6:	74 16                	je     5de <gets+0x61>
 5c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5cc:	3c 0d                	cmp    $0xd,%al
 5ce:	74 0e                	je     5de <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d3:	83 c0 01             	add    $0x1,%eax
 5d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5d9:	7c b1                	jl     58c <gets+0xf>
 5db:	eb 01                	jmp    5de <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 5dd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e1:	03 45 08             	add    0x8(%ebp),%eax
 5e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ea:	c9                   	leave  
 5eb:	c3                   	ret    

000005ec <stat>:

int
stat(char *n, struct stat *st)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5f9:	00 
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 07 01 00 00       	call   70c <open>
 605:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 608:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 60c:	79 07                	jns    615 <stat+0x29>
    return -1;
 60e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 613:	eb 23                	jmp    638 <stat+0x4c>
  r = fstat(fd, st);
 615:	8b 45 0c             	mov    0xc(%ebp),%eax
 618:	89 44 24 04          	mov    %eax,0x4(%esp)
 61c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61f:	89 04 24             	mov    %eax,(%esp)
 622:	e8 fd 00 00 00       	call   724 <fstat>
 627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 62a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62d:	89 04 24             	mov    %eax,(%esp)
 630:	e8 bf 00 00 00       	call   6f4 <close>
  return r;
 635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 638:	c9                   	leave  
 639:	c3                   	ret    

0000063a <atoi>:

int
atoi(const char *s)
{
 63a:	55                   	push   %ebp
 63b:	89 e5                	mov    %esp,%ebp
 63d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 647:	eb 24                	jmp    66d <atoi+0x33>
    n = n*10 + *s++ - '0';
 649:	8b 55 fc             	mov    -0x4(%ebp),%edx
 64c:	89 d0                	mov    %edx,%eax
 64e:	c1 e0 02             	shl    $0x2,%eax
 651:	01 d0                	add    %edx,%eax
 653:	01 c0                	add    %eax,%eax
 655:	89 c2                	mov    %eax,%edx
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	8d 04 02             	lea    (%edx,%eax,1),%eax
 663:	83 e8 30             	sub    $0x30,%eax
 666:	89 45 fc             	mov    %eax,-0x4(%ebp)
 669:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	0f b6 00             	movzbl (%eax),%eax
 673:	3c 2f                	cmp    $0x2f,%al
 675:	7e 0a                	jle    681 <atoi+0x47>
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	3c 39                	cmp    $0x39,%al
 67f:	7e c8                	jle    649 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 686:	55                   	push   %ebp
 687:	89 e5                	mov    %esp,%ebp
 689:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 692:	8b 45 0c             	mov    0xc(%ebp),%eax
 695:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 698:	eb 13                	jmp    6ad <memmove+0x27>
    *dst++ = *src++;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	0f b6 10             	movzbl (%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	88 10                	mov    %dl,(%eax)
 6a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 6a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 6b1:	0f 9f c0             	setg   %al
 6b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 6b8:	84 c0                	test   %al,%al
 6ba:	75 de                	jne    69a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6bf:	c9                   	leave  
 6c0:	c3                   	ret    
 6c1:	90                   	nop
 6c2:	90                   	nop
 6c3:	90                   	nop

000006c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6c4:	b8 01 00 00 00       	mov    $0x1,%eax
 6c9:	cd 40                	int    $0x40
 6cb:	c3                   	ret    

000006cc <exit>:
SYSCALL(exit)
 6cc:	b8 02 00 00 00       	mov    $0x2,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <wait>:
SYSCALL(wait)
 6d4:	b8 03 00 00 00       	mov    $0x3,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <pipe>:
SYSCALL(pipe)
 6dc:	b8 04 00 00 00       	mov    $0x4,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <read>:
SYSCALL(read)
 6e4:	b8 05 00 00 00       	mov    $0x5,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <write>:
SYSCALL(write)
 6ec:	b8 10 00 00 00       	mov    $0x10,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <close>:
SYSCALL(close)
 6f4:	b8 15 00 00 00       	mov    $0x15,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <kill>:
SYSCALL(kill)
 6fc:	b8 06 00 00 00       	mov    $0x6,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <exec>:
SYSCALL(exec)
 704:	b8 07 00 00 00       	mov    $0x7,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <open>:
SYSCALL(open)
 70c:	b8 0f 00 00 00       	mov    $0xf,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <mknod>:
SYSCALL(mknod)
 714:	b8 11 00 00 00       	mov    $0x11,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <unlink>:
SYSCALL(unlink)
 71c:	b8 12 00 00 00       	mov    $0x12,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <fstat>:
SYSCALL(fstat)
 724:	b8 08 00 00 00       	mov    $0x8,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <link>:
SYSCALL(link)
 72c:	b8 13 00 00 00       	mov    $0x13,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <mkdir>:
SYSCALL(mkdir)
 734:	b8 14 00 00 00       	mov    $0x14,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <chdir>:
SYSCALL(chdir)
 73c:	b8 09 00 00 00       	mov    $0x9,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <dup>:
SYSCALL(dup)
 744:	b8 0a 00 00 00       	mov    $0xa,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <getpid>:
SYSCALL(getpid)
 74c:	b8 0b 00 00 00       	mov    $0xb,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <sbrk>:
SYSCALL(sbrk)
 754:	b8 0c 00 00 00       	mov    $0xc,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <sleep>:
SYSCALL(sleep)
 75c:	b8 0d 00 00 00       	mov    $0xd,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <uptime>:
SYSCALL(uptime)
 764:	b8 0e 00 00 00       	mov    $0xe,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <clone>:
SYSCALL(clone)
 76c:	b8 16 00 00 00       	mov    $0x16,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <texit>:
SYSCALL(texit)
 774:	b8 17 00 00 00       	mov    $0x17,%eax
 779:	cd 40                	int    $0x40
 77b:	c3                   	ret    

0000077c <tsleep>:
SYSCALL(tsleep)
 77c:	b8 18 00 00 00       	mov    $0x18,%eax
 781:	cd 40                	int    $0x40
 783:	c3                   	ret    

00000784 <twakeup>:
SYSCALL(twakeup)
 784:	b8 19 00 00 00       	mov    $0x19,%eax
 789:	cd 40                	int    $0x40
 78b:	c3                   	ret    

0000078c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 28             	sub    $0x28,%esp
 792:	8b 45 0c             	mov    0xc(%ebp),%eax
 795:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 798:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 79f:	00 
 7a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	89 04 24             	mov    %eax,(%esp)
 7ad:	e8 3a ff ff ff       	call   6ec <write>
}
 7b2:	c9                   	leave  
 7b3:	c3                   	ret    

000007b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b4:	55                   	push   %ebp
 7b5:	89 e5                	mov    %esp,%ebp
 7b7:	53                   	push   %ebx
 7b8:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7c2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7c6:	74 17                	je     7df <printint+0x2b>
 7c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7cc:	79 11                	jns    7df <printint+0x2b>
    neg = 1;
 7ce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d8:	f7 d8                	neg    %eax
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7dd:	eb 06                	jmp    7e5 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7df:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 7e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 7ec:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 7ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	ba 00 00 00 00       	mov    $0x0,%edx
 7fa:	f7 f3                	div    %ebx
 7fc:	89 d0                	mov    %edx,%eax
 7fe:	0f b6 80 94 0f 00 00 	movzbl 0xf94(%eax),%eax
 805:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 809:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 80d:	8b 45 10             	mov    0x10(%ebp),%eax
 810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	ba 00 00 00 00       	mov    $0x0,%edx
 81b:	f7 75 d4             	divl   -0x2c(%ebp)
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 825:	75 c5                	jne    7ec <printint+0x38>
  if(neg)
 827:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82b:	74 28                	je     855 <printint+0xa1>
    buf[i++] = '-';
 82d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 830:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 835:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 839:	eb 1a                	jmp    855 <printint+0xa1>
    putc(fd, buf[i]);
 83b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 843:	0f be c0             	movsbl %al,%eax
 846:	89 44 24 04          	mov    %eax,0x4(%esp)
 84a:	8b 45 08             	mov    0x8(%ebp),%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 37 ff ff ff       	call   78c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 855:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 859:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 85d:	79 dc                	jns    83b <printint+0x87>
    putc(fd, buf[i]);
}
 85f:	83 c4 44             	add    $0x44,%esp
 862:	5b                   	pop    %ebx
 863:	5d                   	pop    %ebp
 864:	c3                   	ret    

00000865 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 865:	55                   	push   %ebp
 866:	89 e5                	mov    %esp,%ebp
 868:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 86b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 872:	8d 45 0c             	lea    0xc(%ebp),%eax
 875:	83 c0 04             	add    $0x4,%eax
 878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 87b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 882:	e9 7e 01 00 00       	jmp    a05 <printf+0x1a0>
    c = fmt[i] & 0xff;
 887:	8b 55 0c             	mov    0xc(%ebp),%edx
 88a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88d:	8d 04 02             	lea    (%edx,%eax,1),%eax
 890:	0f b6 00             	movzbl (%eax),%eax
 893:	0f be c0             	movsbl %al,%eax
 896:	25 ff 00 00 00       	and    $0xff,%eax
 89b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 89e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a2:	75 2c                	jne    8d0 <printf+0x6b>
      if(c == '%'){
 8a4:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 8a8:	75 0c                	jne    8b6 <printf+0x51>
        state = '%';
 8aa:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 8b1:	e9 4b 01 00 00       	jmp    a01 <printf+0x19c>
      } else {
        putc(fd, c);
 8b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b9:	0f be c0             	movsbl %al,%eax
 8bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c0:	8b 45 08             	mov    0x8(%ebp),%eax
 8c3:	89 04 24             	mov    %eax,(%esp)
 8c6:	e8 c1 fe ff ff       	call   78c <putc>
 8cb:	e9 31 01 00 00       	jmp    a01 <printf+0x19c>
      }
    } else if(state == '%'){
 8d0:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 8d4:	0f 85 27 01 00 00    	jne    a01 <printf+0x19c>
      if(c == 'd'){
 8da:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 8de:	75 2d                	jne    90d <printf+0xa8>
        printint(fd, *ap, 10, 1);
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8ec:	00 
 8ed:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8f4:	00 
 8f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 b0 fe ff ff       	call   7b4 <printint>
        ap++;
 904:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 908:	e9 ed 00 00 00       	jmp    9fa <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 90d:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 911:	74 06                	je     919 <printf+0xb4>
 913:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 917:	75 2d                	jne    946 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 925:	00 
 926:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 92d:	00 
 92e:	89 44 24 04          	mov    %eax,0x4(%esp)
 932:	8b 45 08             	mov    0x8(%ebp),%eax
 935:	89 04 24             	mov    %eax,(%esp)
 938:	e8 77 fe ff ff       	call   7b4 <printint>
        ap++;
 93d:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 941:	e9 b4 00 00 00       	jmp    9fa <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 946:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 94a:	75 46                	jne    992 <printf+0x12d>
        s = (char*)*ap;
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 954:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 95c:	75 27                	jne    985 <printf+0x120>
          s = "(null)";
 95e:	c7 45 e4 5f 0f 00 00 	movl   $0xf5f,-0x1c(%ebp)
        while(*s != 0){
 965:	eb 1f                	jmp    986 <printf+0x121>
          putc(fd, *s);
 967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96a:	0f b6 00             	movzbl (%eax),%eax
 96d:	0f be c0             	movsbl %al,%eax
 970:	89 44 24 04          	mov    %eax,0x4(%esp)
 974:	8b 45 08             	mov    0x8(%ebp),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 0d fe ff ff       	call   78c <putc>
          s++;
 97f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 983:	eb 01                	jmp    986 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 985:	90                   	nop
 986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 989:	0f b6 00             	movzbl (%eax),%eax
 98c:	84 c0                	test   %al,%al
 98e:	75 d7                	jne    967 <printf+0x102>
 990:	eb 68                	jmp    9fa <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 992:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 996:	75 1d                	jne    9b5 <printf+0x150>
        putc(fd, *ap);
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	8b 00                	mov    (%eax),%eax
 99d:	0f be c0             	movsbl %al,%eax
 9a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a4:	8b 45 08             	mov    0x8(%ebp),%eax
 9a7:	89 04 24             	mov    %eax,(%esp)
 9aa:	e8 dd fd ff ff       	call   78c <putc>
        ap++;
 9af:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 9b3:	eb 45                	jmp    9fa <printf+0x195>
      } else if(c == '%'){
 9b5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 9b9:	75 17                	jne    9d2 <printf+0x16d>
        putc(fd, c);
 9bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9be:	0f be c0             	movsbl %al,%eax
 9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c5:	8b 45 08             	mov    0x8(%ebp),%eax
 9c8:	89 04 24             	mov    %eax,(%esp)
 9cb:	e8 bc fd ff ff       	call   78c <putc>
 9d0:	eb 28                	jmp    9fa <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9d2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9d9:	00 
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	89 04 24             	mov    %eax,(%esp)
 9e0:	e8 a7 fd ff ff       	call   78c <putc>
        putc(fd, c);
 9e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e8:	0f be c0             	movsbl %al,%eax
 9eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ef:	8b 45 08             	mov    0x8(%ebp),%eax
 9f2:	89 04 24             	mov    %eax,(%esp)
 9f5:	e8 92 fd ff ff       	call   78c <putc>
      }
      state = 0;
 9fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a01:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 a05:	8b 55 0c             	mov    0xc(%ebp),%edx
 a08:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a0b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 a0e:	0f b6 00             	movzbl (%eax),%eax
 a11:	84 c0                	test   %al,%al
 a13:	0f 85 6e fe ff ff    	jne    887 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a19:	c9                   	leave  
 a1a:	c3                   	ret    
 a1b:	90                   	nop

00000a1c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a1c:	55                   	push   %ebp
 a1d:	89 e5                	mov    %esp,%ebp
 a1f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a22:	8b 45 08             	mov    0x8(%ebp),%eax
 a25:	83 e8 08             	sub    $0x8,%eax
 a28:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2b:	a1 d4 0f 00 00       	mov    0xfd4,%eax
 a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a33:	eb 24                	jmp    a59 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a3d:	77 12                	ja     a51 <free+0x35>
 a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a45:	77 24                	ja     a6b <free+0x4f>
 a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4a:	8b 00                	mov    (%eax),%eax
 a4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4f:	77 1a                	ja     a6b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a54:	8b 00                	mov    (%eax),%eax
 a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a5f:	76 d4                	jbe    a35 <free+0x19>
 a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a64:	8b 00                	mov    (%eax),%eax
 a66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a69:	76 ca                	jbe    a35 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6e:	8b 40 04             	mov    0x4(%eax),%eax
 a71:	c1 e0 03             	shl    $0x3,%eax
 a74:	89 c2                	mov    %eax,%edx
 a76:	03 55 f8             	add    -0x8(%ebp),%edx
 a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7c:	8b 00                	mov    (%eax),%eax
 a7e:	39 c2                	cmp    %eax,%edx
 a80:	75 24                	jne    aa6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a85:	8b 50 04             	mov    0x4(%eax),%edx
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	8b 00                	mov    (%eax),%eax
 a8d:	8b 40 04             	mov    0x4(%eax),%eax
 a90:	01 c2                	add    %eax,%edx
 a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a95:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9b:	8b 00                	mov    (%eax),%eax
 a9d:	8b 10                	mov    (%eax),%edx
 a9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa2:	89 10                	mov    %edx,(%eax)
 aa4:	eb 0a                	jmp    ab0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa9:	8b 10                	mov    (%eax),%edx
 aab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ab0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab3:	8b 40 04             	mov    0x4(%eax),%eax
 ab6:	c1 e0 03             	shl    $0x3,%eax
 ab9:	03 45 fc             	add    -0x4(%ebp),%eax
 abc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 abf:	75 20                	jne    ae1 <free+0xc5>
    p->s.size += bp->s.size;
 ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac4:	8b 50 04             	mov    0x4(%eax),%edx
 ac7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aca:	8b 40 04             	mov    0x4(%eax),%eax
 acd:	01 c2                	add    %eax,%edx
 acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ad5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad8:	8b 10                	mov    (%eax),%edx
 ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
 add:	89 10                	mov    %edx,(%eax)
 adf:	eb 08                	jmp    ae9 <free+0xcd>
  } else
    p->s.ptr = bp;
 ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ae7:	89 10                	mov    %edx,(%eax)
  freep = p;
 ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aec:	a3 d4 0f 00 00       	mov    %eax,0xfd4
}
 af1:	c9                   	leave  
 af2:	c3                   	ret    

00000af3 <morecore>:

static Header*
morecore(uint nu)
{
 af3:	55                   	push   %ebp
 af4:	89 e5                	mov    %esp,%ebp
 af6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 af9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b00:	77 07                	ja     b09 <morecore+0x16>
    nu = 4096;
 b02:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b09:	8b 45 08             	mov    0x8(%ebp),%eax
 b0c:	c1 e0 03             	shl    $0x3,%eax
 b0f:	89 04 24             	mov    %eax,(%esp)
 b12:	e8 3d fc ff ff       	call   754 <sbrk>
 b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 b1a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 b1e:	75 07                	jne    b27 <morecore+0x34>
    return 0;
 b20:	b8 00 00 00 00       	mov    $0x0,%eax
 b25:	eb 22                	jmp    b49 <morecore+0x56>
  hp = (Header*)p;
 b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	8b 55 08             	mov    0x8(%ebp),%edx
 b33:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b39:	83 c0 08             	add    $0x8,%eax
 b3c:	89 04 24             	mov    %eax,(%esp)
 b3f:	e8 d8 fe ff ff       	call   a1c <free>
  return freep;
 b44:	a1 d4 0f 00 00       	mov    0xfd4,%eax
}
 b49:	c9                   	leave  
 b4a:	c3                   	ret    

00000b4b <malloc>:

void*
malloc(uint nbytes)
{
 b4b:	55                   	push   %ebp
 b4c:	89 e5                	mov    %esp,%ebp
 b4e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b51:	8b 45 08             	mov    0x8(%ebp),%eax
 b54:	83 c0 07             	add    $0x7,%eax
 b57:	c1 e8 03             	shr    $0x3,%eax
 b5a:	83 c0 01             	add    $0x1,%eax
 b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 b60:	a1 d4 0f 00 00       	mov    0xfd4,%eax
 b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b6c:	75 23                	jne    b91 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b6e:	c7 45 f0 cc 0f 00 00 	movl   $0xfcc,-0x10(%ebp)
 b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b78:	a3 d4 0f 00 00       	mov    %eax,0xfd4
 b7d:	a1 d4 0f 00 00       	mov    0xfd4,%eax
 b82:	a3 cc 0f 00 00       	mov    %eax,0xfcc
    base.s.size = 0;
 b87:	c7 05 d0 0f 00 00 00 	movl   $0x0,0xfd0
 b8e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b94:	8b 00                	mov    (%eax),%eax
 b96:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b9c:	8b 40 04             	mov    0x4(%eax),%eax
 b9f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 ba2:	72 4d                	jb     bf1 <malloc+0xa6>
      if(p->s.size == nunits)
 ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ba7:	8b 40 04             	mov    0x4(%eax),%eax
 baa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 bad:	75 0c                	jne    bbb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bb2:	8b 10                	mov    (%eax),%edx
 bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb7:	89 10                	mov    %edx,(%eax)
 bb9:	eb 26                	jmp    be1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bbe:	8b 40 04             	mov    0x4(%eax),%eax
 bc1:	89 c2                	mov    %eax,%edx
 bc3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bc9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bcf:	8b 40 04             	mov    0x4(%eax),%eax
 bd2:	c1 e0 03             	shl    $0x3,%eax
 bd5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 bde:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be4:	a3 d4 0f 00 00       	mov    %eax,0xfd4
      return (void*)(p + 1);
 be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bec:	83 c0 08             	add    $0x8,%eax
 bef:	eb 38                	jmp    c29 <malloc+0xde>
    }
    if(p == freep)
 bf1:	a1 d4 0f 00 00       	mov    0xfd4,%eax
 bf6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 bf9:	75 1b                	jne    c16 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfe:	89 04 24             	mov    %eax,(%esp)
 c01:	e8 ed fe ff ff       	call   af3 <morecore>
 c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
 c09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 c0d:	75 07                	jne    c16 <malloc+0xcb>
        return 0;
 c0f:	b8 00 00 00 00       	mov    $0x0,%eax
 c14:	eb 13                	jmp    c29 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c1f:	8b 00                	mov    (%eax),%eax
 c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c24:	e9 70 ff ff ff       	jmp    b99 <malloc+0x4e>
}
 c29:	c9                   	leave  
 c2a:	c3                   	ret    
 c2b:	90                   	nop

00000c2c <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
 c2c:	55                   	push   %ebp
 c2d:	89 e5                	mov    %esp,%ebp
 c2f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 c32:	8b 55 08             	mov    0x8(%ebp),%edx
 c35:	8b 45 0c             	mov    0xc(%ebp),%eax
 c38:	8b 4d 08             	mov    0x8(%ebp),%ecx
 c3b:	f0 87 02             	lock xchg %eax,(%edx)
 c3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
 c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 c44:	c9                   	leave  
 c45:	c3                   	ret    

00000c46 <lock_init>:
#include "mmu.h"
#include "spinlock.h"
#include "x86.h"
#include "proc.h"

void lock_init(lock_t *lock){
 c46:	55                   	push   %ebp
 c47:	89 e5                	mov    %esp,%ebp
    lock->locked = 0;
 c49:	8b 45 08             	mov    0x8(%ebp),%eax
 c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 c52:	5d                   	pop    %ebp
 c53:	c3                   	ret    

00000c54 <lock_acquire>:
void lock_acquire(lock_t *lock){
 c54:	55                   	push   %ebp
 c55:	89 e5                	mov    %esp,%ebp
 c57:	83 ec 08             	sub    $0x8,%esp
    while(xchg(&lock->locked,1) != 0);
 c5a:	8b 45 08             	mov    0x8(%ebp),%eax
 c5d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 c64:	00 
 c65:	89 04 24             	mov    %eax,(%esp)
 c68:	e8 bf ff ff ff       	call   c2c <xchg>
 c6d:	85 c0                	test   %eax,%eax
 c6f:	75 e9                	jne    c5a <lock_acquire+0x6>
}
 c71:	c9                   	leave  
 c72:	c3                   	ret    

00000c73 <lock_release>:
void lock_release(lock_t *lock){
 c73:	55                   	push   %ebp
 c74:	89 e5                	mov    %esp,%ebp
 c76:	83 ec 08             	sub    $0x8,%esp
    xchg(&lock->locked,0);
 c79:	8b 45 08             	mov    0x8(%ebp),%eax
 c7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 c83:	00 
 c84:	89 04 24             	mov    %eax,(%esp)
 c87:	e8 a0 ff ff ff       	call   c2c <xchg>
}
 c8c:	c9                   	leave  
 c8d:	c3                   	ret    

00000c8e <thread_create>:


void *thread_create(void(*start_routine)(void*), void *arg){
 c8e:	55                   	push   %ebp
 c8f:	89 e5                	mov    %esp,%ebp
 c91:	83 ec 28             	sub    $0x28,%esp
    int tid;
    void * stack = malloc(2 * 4096);
 c94:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 c9b:	e8 ab fe ff ff       	call   b4b <malloc>
 ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    void *garbage_stack = stack; 
 ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   // printf(1,"start routine addr : %d\n",(uint)start_routine);


    if((uint)stack % 4096){
 ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cac:	25 ff 0f 00 00       	and    $0xfff,%eax
 cb1:	85 c0                	test   %eax,%eax
 cb3:	74 15                	je     cca <thread_create+0x3c>
        stack = stack + (4096 - (uint)stack % 4096);
 cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb8:	89 c2                	mov    %eax,%edx
 cba:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 cc0:	b8 00 10 00 00       	mov    $0x1000,%eax
 cc5:	29 d0                	sub    %edx,%eax
 cc7:	01 45 f0             	add    %eax,-0x10(%ebp)
    }
    if (stack == 0){
 cca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cce:	75 1b                	jne    ceb <thread_create+0x5d>

        printf(1,"malloc fail \n");
 cd0:	c7 44 24 04 66 0f 00 	movl   $0xf66,0x4(%esp)
 cd7:	00 
 cd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 cdf:	e8 81 fb ff ff       	call   865 <printf>
        return 0;
 ce4:	b8 00 00 00 00       	mov    $0x0,%eax
 ce9:	eb 6f                	jmp    d5a <thread_create+0xcc>
    }

    tid = clone((uint)stack,PSIZE,(uint)start_routine,(int)arg);
 ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 cee:	8b 55 08             	mov    0x8(%ebp),%edx
 cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 cf8:	89 54 24 08          	mov    %edx,0x8(%esp)
 cfc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
 d03:	00 
 d04:	89 04 24             	mov    %eax,(%esp)
 d07:	e8 60 fa ff ff       	call   76c <clone>
 d0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(tid < 0){
 d0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d13:	79 1b                	jns    d30 <thread_create+0xa2>
        printf(1,"clone fails\n");
 d15:	c7 44 24 04 74 0f 00 	movl   $0xf74,0x4(%esp)
 d1c:	00 
 d1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d24:	e8 3c fb ff ff       	call   865 <printf>
        return 0;
 d29:	b8 00 00 00 00       	mov    $0x0,%eax
 d2e:	eb 2a                	jmp    d5a <thread_create+0xcc>
    }
    if(tid > 0){
 d30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d34:	7e 05                	jle    d3b <thread_create+0xad>
        //store threads on thread table
        return garbage_stack;
 d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d39:	eb 1f                	jmp    d5a <thread_create+0xcc>
    }
    if(tid == 0){
 d3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 d3f:	75 14                	jne    d55 <thread_create+0xc7>
        printf(1,"tid = 0 return \n");
 d41:	c7 44 24 04 81 0f 00 	movl   $0xf81,0x4(%esp)
 d48:	00 
 d49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d50:	e8 10 fb ff ff       	call   865 <printf>
    }
//    wait();
//    free(garbage_stack);

    return 0;
 d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
 d5a:	c9                   	leave  
 d5b:	c3                   	ret    

00000d5c <init_q>:
#include "queue.h"
#include "types.h"
#include "user.h"

void init_q(struct queue *q){
 d5c:	55                   	push   %ebp
 d5d:	89 e5                	mov    %esp,%ebp
    q->size = 0;
 d5f:	8b 45 08             	mov    0x8(%ebp),%eax
 d62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    q->head = 0;
 d68:	8b 45 08             	mov    0x8(%ebp),%eax
 d6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    q->tail = 0;
 d72:	8b 45 08             	mov    0x8(%ebp),%eax
 d75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
 d7c:	5d                   	pop    %ebp
 d7d:	c3                   	ret    

00000d7e <add_q>:

void add_q(struct queue *q, int v){
 d7e:	55                   	push   %ebp
 d7f:	89 e5                	mov    %esp,%ebp
 d81:	83 ec 28             	sub    $0x28,%esp
    struct node * n = malloc(sizeof(struct node));
 d84:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 d8b:	e8 bb fd ff ff       	call   b4b <malloc>
 d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n->next = 0;
 d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    n->value = v;
 d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da0:	8b 55 0c             	mov    0xc(%ebp),%edx
 da3:	89 10                	mov    %edx,(%eax)
    if(q->head == 0){
 da5:	8b 45 08             	mov    0x8(%ebp),%eax
 da8:	8b 40 04             	mov    0x4(%eax),%eax
 dab:	85 c0                	test   %eax,%eax
 dad:	75 0b                	jne    dba <add_q+0x3c>
        q->head = n;
 daf:	8b 45 08             	mov    0x8(%ebp),%eax
 db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 db5:	89 50 04             	mov    %edx,0x4(%eax)
 db8:	eb 0c                	jmp    dc6 <add_q+0x48>
    }else{
        q->tail->next = n;
 dba:	8b 45 08             	mov    0x8(%ebp),%eax
 dbd:	8b 40 08             	mov    0x8(%eax),%eax
 dc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 dc3:	89 50 04             	mov    %edx,0x4(%eax)
    }
    q->tail = n;
 dc6:	8b 45 08             	mov    0x8(%ebp),%eax
 dc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 dcc:	89 50 08             	mov    %edx,0x8(%eax)
    q->size++;
 dcf:	8b 45 08             	mov    0x8(%ebp),%eax
 dd2:	8b 00                	mov    (%eax),%eax
 dd4:	8d 50 01             	lea    0x1(%eax),%edx
 dd7:	8b 45 08             	mov    0x8(%ebp),%eax
 dda:	89 10                	mov    %edx,(%eax)
}
 ddc:	c9                   	leave  
 ddd:	c3                   	ret    

00000dde <empty_q>:

int empty_q(struct queue *q){
 dde:	55                   	push   %ebp
 ddf:	89 e5                	mov    %esp,%ebp
    if(q->size == 0)
 de1:	8b 45 08             	mov    0x8(%ebp),%eax
 de4:	8b 00                	mov    (%eax),%eax
 de6:	85 c0                	test   %eax,%eax
 de8:	75 07                	jne    df1 <empty_q+0x13>
        return 1;
 dea:	b8 01 00 00 00       	mov    $0x1,%eax
 def:	eb 05                	jmp    df6 <empty_q+0x18>
    else
        return 0;
 df1:	b8 00 00 00 00       	mov    $0x0,%eax
} 
 df6:	5d                   	pop    %ebp
 df7:	c3                   	ret    

00000df8 <pop_q>:
int pop_q(struct queue *q){
 df8:	55                   	push   %ebp
 df9:	89 e5                	mov    %esp,%ebp
 dfb:	83 ec 28             	sub    $0x28,%esp
    int val;
    struct node *destroy;
    if(!empty_q(q)){
 dfe:	8b 45 08             	mov    0x8(%ebp),%eax
 e01:	89 04 24             	mov    %eax,(%esp)
 e04:	e8 d5 ff ff ff       	call   dde <empty_q>
 e09:	85 c0                	test   %eax,%eax
 e0b:	75 5d                	jne    e6a <pop_q+0x72>
       val = q->head->value; 
 e0d:	8b 45 08             	mov    0x8(%ebp),%eax
 e10:	8b 40 04             	mov    0x4(%eax),%eax
 e13:	8b 00                	mov    (%eax),%eax
 e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
       destroy = q->head;
 e18:	8b 45 08             	mov    0x8(%ebp),%eax
 e1b:	8b 40 04             	mov    0x4(%eax),%eax
 e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
       q->head = q->head->next;
 e21:	8b 45 08             	mov    0x8(%ebp),%eax
 e24:	8b 40 04             	mov    0x4(%eax),%eax
 e27:	8b 50 04             	mov    0x4(%eax),%edx
 e2a:	8b 45 08             	mov    0x8(%ebp),%eax
 e2d:	89 50 04             	mov    %edx,0x4(%eax)
       free(destroy);
 e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e33:	89 04 24             	mov    %eax,(%esp)
 e36:	e8 e1 fb ff ff       	call   a1c <free>
       q->size--;
 e3b:	8b 45 08             	mov    0x8(%ebp),%eax
 e3e:	8b 00                	mov    (%eax),%eax
 e40:	8d 50 ff             	lea    -0x1(%eax),%edx
 e43:	8b 45 08             	mov    0x8(%ebp),%eax
 e46:	89 10                	mov    %edx,(%eax)
       if(q->size == 0){
 e48:	8b 45 08             	mov    0x8(%ebp),%eax
 e4b:	8b 00                	mov    (%eax),%eax
 e4d:	85 c0                	test   %eax,%eax
 e4f:	75 14                	jne    e65 <pop_q+0x6d>
            q->head = 0;
 e51:	8b 45 08             	mov    0x8(%ebp),%eax
 e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            q->tail = 0;
 e5b:	8b 45 08             	mov    0x8(%ebp),%eax
 e5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
       }
       return val;
 e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e68:	eb 05                	jmp    e6f <pop_q+0x77>
    }
    return -1;
 e6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 e6f:	c9                   	leave  
 e70:	c3                   	ret    

00000e71 <front>:

int front(struct queue *q)
{
 e71:	55                   	push   %ebp
 e72:	89 e5                	mov    %esp,%ebp
   return q->head->value;
 e74:	8b 45 08             	mov    0x8(%ebp),%eax
 e77:	8b 40 04             	mov    0x4(%eax),%eax
 e7a:	8b 00                	mov    (%eax),%eax
}
 e7c:	5d                   	pop    %ebp
 e7d:	c3                   	ret    
