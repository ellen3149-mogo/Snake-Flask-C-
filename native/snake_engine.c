/* Snake: linked list malloc/free JSON IO */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define GW 20
#define GH 20
#define JSON_BUF 65536
typedef enum { DU=0, DD, DL, DR, DN } Dir;
typedef struct Node { int x,y; struct Node *next; } Node;
typedef struct { Node *head; int len,score,over,fx,fy,gw,gh; Dir cur,nxt; } Game;
static unsigned lcg(unsigned *s){*s=*s*1103515245u+12345u;return (*s>>16)&0x7fffu;}
static unsigned fseed;
static Node *mk(int x,int y){Node*n=malloc(sizeof(Node));if(!n)return 0;n->x=x;n->y=y;n->next=0;return n;}
static void fn(Node*n){if(n)free(n);}
static void fs(Node*h){while(h){Node*t=h->next;free(h);h=t;}}
static Node *tail(Node*h){if(!h)return 0;while(h->next)h=h->next;return h;}
static int has(Node*h,int x,int y){for(;h;h=h->next)if(h->x==x&&h->y==y)return 1;return 0;}
static void dd(Dir d,int *dx,int *dy){*dx=*dy=0;if(d==DU)*dy=-1;else if(d==DD)*dy=1;else if(d==DL)*dx=-1;else if(d==DR)*dx=1;}
static Dir pk(char c){if(c=='W'||c=='w')return DU;if(c=='S'||c=='s')return DD;if(c=='A'||c=='a')return DL;if(c=='D'||c=='d')return DR;return DN;}
static const char* ds(Dir d){if(d==DU)return "U";if(d==DD)return "D";if(d==DL)return "L";if(d==DR)return "R";return "N";}
static int wall(const Game*g,int x,int y){return x<0||y<0||x>=g->gw||y>=g->gh;}
static int hit(const Game*g,int x,int y){return wall(g,x,y)||has(g->head,x,y);}
static void food(Game*g){if(!fseed)fseed=(unsigned)time(0);int t=0;do{g->fx=(int)(lcg(&fseed)%g->gw);g->fy=(int)(lcg(&fseed)%g->gh);t++;}while(has(g->head,g->fx,g->fy)&&t<500);}
static int init_snake(Game*g,int sx,int sy,int n){fs(g->head);g->head=0;g->len=0;Node*h=mk(sx,sy);if(!h)return 0;g->head=h;g->len=1;Node*t=h;for(int i=1;i<n;i++){Node*s=mk(sx,sy+i);if(!s){fs(g->head);g->head=0;g->len=0;return 0;}t->next=s;t=s;g->len++;}g->cur=g->nxt=DU;return 1;}
static int move(Game*g){if(!g->head||g->over)return 0;if(g->nxt!=DN){if(!(g->cur==DU&&g->nxt==DD)&&!(g->cur==DD&&g->nxt==DU)&&!(g->cur==DL&&g->nxt==DR)&&!(g->cur==DR&&g->nxt==DL))g->cur=g->nxt;}int dx=0,dy=0;dd(g->cur,&dx,&dy);int nx=g->head->x+dx,ny=g->head->y+dy;if(hit(g,nx,ny)){g->over=1;return 0;}int ate=(nx==g->fx&&ny==g->fy);Node*nh=mk(nx,ny);if(!nh){g->over=1;return 0;}nh->next=g->head;g->head=nh;g->len++;if(ate){g->score+=10;food(g);}else{Node*tl=tail(g->head);if(tl){Node*pv=g->head;while(pv&&pv->next!=tl)pv=pv->next;if(pv==tl){fn(tl);g->head=0;g->len=0;}else if(pv){pv->next=0;fn(tl);g->len--;}}}return 1;}
static void new_game(Game*g){g->gw=GW;g->gh=GH;g->score=0;g->over=0;init_snake(g,g->gw/2,g->gh/2+2,3);food(g);}
static int pint(const char*b,const char*k,int d){char pt[64];snprintf(pt,64,"\"%s\"",k);const char*p=strstr(b,pt);if(!p)return d;p=strchr(p,':');if(!p)return d;return (int)strtol(p+1,0,10);}
static Dir pdir(const char*b){const char*p=strstr(b,"\"dir\"");if(!p)return DU;p=strchr(p,':');if(!p)return DU;while(*p&&(*p==':'||*p==' '||*p=='"'))p++;if(*p=='U')return DU;if(*p=='D')return DD;if(*p=='L')return DL;if(*p=='R')return DR;return DU;}
static int load_snake(Game*g,const char*b){const char*p=strstr(b,"\"snake\"");if(!p)return 0;fs(g->head);g->head=0;g->len=0;Node*t=0;while((p=strchr(p,'['))){if(p[1]==']')break;if(p[1]=='['){p++;continue;}char*end=0;int x=(int)strtol(p+1,&end,10);if(end==p+1){p++;continue;}if(*end!=','){p++;continue;}int y=(int)strtol(end+1,&end,10);Node*n=mk(x,y);if(!n){fs(g->head);g->head=0;g->len=0;return 0;}if(!g->head)g->head=n;else t->next=n;t=n;g->len++;p=end;}return g->head!=0;}
static int load(Game*g,const char*b){memset(g,0,sizeof*g);g->gw=pint(b,"width",GW);g->gh=pint(b,"height",GH);g->score=pint(b,"score",0);g->over=pint(b,"game_over",0);g->fx=pint(b,"food_x",0);g->fy=pint(b,"food_y",0);g->cur=pdir(b);g->nxt=g->cur;return load_snake(g,b)?0:-1;}
static void err(const char*m){printf("{\"ok\":false,\"error\":\"%s\"}\n",m?m:"unknown");fflush(stdout);}
static void out(const Game*g){printf("{\"ok\":true,\"width\":%d,\"height\":%d,\"score\":%d,\"game_over\":%d,\"food_x\":%d,\"food_y\":%d,\"dir\":\"%s\",\"snake\":[",g->gw,g->gh,g->score,g->over,g->fx,g->fy,ds(g->cur));int f=1;for(Node*c=g->head;c;c=c->next){if(!f)printf(",");printf("[%d,%d]",c->x,c->y);f=0;}printf("]}\n");fflush(stdout);}
static int rd(char*b,size_t c){if(!fgets(b,(int)c,stdin))return 0;size_t n=strlen(b);while(n>0&&(b[n-1]=='\n'||b[n-1]=='\r'))b[--n]=0;return (int)n;}
int main(void){char buf[JSON_BUF];if(rd(buf,sizeof buf)<=0){err("empty stdin");return 1;}Game g;memset(&g,0,sizeof g);if(strstr(buf,"new")){new_game(&g);out(&g);fs(g.head);return 0;}if(load(&g,buf)!=0){err("bad game state");return 1;}if(g.over){err("game already over");fs(g.head);return 1;}const char*k=strstr(buf,"\"key\"");if(k){k=strchr(k,':');if(k){while(*k&&(*k==':'||*k==' '||*k=='"'))k++;g.nxt=pk(*k);}}move(&g);out(&g);fs(g.head);return 0;}
