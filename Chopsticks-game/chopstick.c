#include <stdio.h>
#include <string.h>
#include <stdlib.h> 
#include<time.h> 


#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"


/*
Description of game:
Each player starts with one chopstick in each hand. When it is a player's turn,
they can tap an opponents left or right hand, increasing the number of chopsticks
they hold in that hand by the number you currently hold in the hand that you just moved.
When a hand reaches five chopsticks, it is closed and considered "dead." To win the game,
you have to eliminate both of your opponents hands without being eliminated yourself.
*/
int playeraction();
int computeraction();
int computeraction2();
void recallplayeraction();
void recallcomputeraction();
int handcheck();
int countcheck();
int gamecheck();

/*0 & 1 = player L & player R*/
/*2 & 3 = computer L & computer R*/
static int hmrk[4];
static int count[4];
static int turnorder = 1;
static int isover = 0;




int main(int argc, char *argv[]){
count[0] = 1;
count[1] = 1;
count[2] = 1;
count[3] = 1;
system("clear");
printf(ANSI_COLOR_GREEN "\n    ~Welcome to Chopsticks!~ \nA freeware game by Ben Pfeiffer 11/18\n(How To Play:\ntype in a move like 'LR', corresponding to your Left hand hitting their Right\nTo quit, type 'quit'\nTo split one hand into two, type 'split)\n####################\n"ANSI_COLOR_RESET);

while (isover==0) {
/*Print gamestate, declare who's turn it is*/
printf(ANSI_COLOR_YELLOW "Current Boardstate:\n\n\n     L   R\n     %i   %i\n     -----\n     %i   %i" ANSI_COLOR_RESET ,count[2],count[3],count[0],count[1]);

	if(turnorder%2==1){
		playeraction();
	}else{
		printf("\nThe computer thinks... \n");
		int t = time(0);
		computeraction(t);
	}
	handcheck();
	countcheck();
	gamecheck();
	turnorder = turnorder+1;
	if(hmrk[2]==1&&hmrk[3]==1){
	printf(ANSI_COLOR_CYAN "\n*~~You win!~~*\n"ANSI_COLOR_RESET);
	printf(ANSI_COLOR_RED "Want to play again? (yes/no)  "ANSI_COLOR_RESET);	
	char input[3];
	scanf("%s",input);
	if(strncmp(input,"yes",3)==0){
		count[0]=1;
		count[1]=1;
		count[2]=1;
		count[3]=1;
		hmrk[0]=0;
		hmrk[1]=0;
		hmrk[2]=0;
		hmrk[3]=0;
		turnorder=0;
		isover=0;
	}
	}else if(hmrk[0]==1&&hmrk[1]==1){
	printf(ANSI_COLOR_RED"\n___The Computer wins :( ___\n Restart? (yes/no): "ANSI_COLOR_RESET);
	char input[3];
	scanf("%s",input);
	if(strncmp(input,"yes",3)==0){
		count[0]=1;
		count[1]=1;
		count[2]=1;
		count[3]=1;
		hmrk[0]=0;
		hmrk[1]=0;
		hmrk[2]=0;
		hmrk[3]=0;
		turnorder=0;
		isover=0;
	}
	}
	if(turnorder%2==0){
	   system("clear");
	}
}
return 0;
}




/*Here lie the functions*/
int gamecheck() {
/*check to see if game is over*/
 if(hmrk[0]==1 && hmrk[1]==1 || hmrk[2]==1 && hmrk[3]==1){
	isover = 1;
 }
 return isover;
}

int countcheck() {
 int i;
 for(i=0;i<4;i++){
	if(count[i]==5){
		count[i] = 0;
		return count[i];
	}else if(count[i]>5){
		count[i] = count[i] - 5;
		return count[i];
	}
 }
}

int handcheck() {
 int i;
 for(i=0;i<4;i++){
	if(count[i]==5){
		hmrk[i] = 1;
		return hmrk[i];
	}
 }
}

int playeraction() {
char input[10];
printf("\nIt is your turn: ");
scanf("%s",input);
 if(strncmp(input,"LL",2)==0){
	if(hmrk[0]==1 || hmrk[2]==1){
		recallplayeraction();
		return 0;
	}
	return count[2] = count[2] + count[0];
 }else if(strncmp(input,"LR",2)==0) {
	if(hmrk[0]==1 || hmrk[3]==1){
		recallplayeraction();
		return 0;
	}
	return count[3] = count[3] + count[0];
 }else if(strncmp(input,"RL",2)==0) {
	if(hmrk[1]==1 || hmrk[2]==1){
		recallplayeraction();
		return 0;
	}
	return count[2] = count[2] + count[1];
 }else if(strncmp(input,"RR",2)==0) {
	if(hmrk[1]==1 || hmrk[3]==1){
		recallplayeraction();
		return 0;
	}
	return count[3] = count[3] + count[1];
 }else if(strncmp(input,"quit",4)==0) {
	printf("\nQuitting game, thanks for playing!\n");
	return isover=1;
 }else if(strncmp(input,"restart",7)==0) {
	printf("\nRestarting...\n");
	count[0]=1;
	count[1]=1;
	count[2]=1;
	count[3]=1;
	hmrk[0]=0;
	hmrk[1]=0;
	hmrk[2]=0;
	hmrk[3]=0;
	turnorder=0;
	return isover=0;
 }else if(strncmp(input,"split",5)==0) {
	if (hmrk[0]==1 || hmrk[1]==1) {
		if (count[0]==2 || count[1]==2) {
			count[0] = 1;
			count[1] = 1;
			hmrk[0] = 0;
			hmrk[1] = 0;
			return 0;
		}else if (count[0]==4 || count[1]==4){
			count[0] = 2;
			count[1] = 2;
			hmrk[0] = 0;
			hmrk[1] = 0;
			return 0;
		}else {
			recallplayeraction();
		}
	}else {
		recallplayeraction();
	}
 }else {
	recallplayeraction();
	return 0;
 }
}

void recallplayeraction() {
char input[2];
 printf("\nSorry, that's not a valid action. Please input something else\n");
 scanf("%c",input);
 playeraction(input);
 return;
}

int computeraction(int t) {
 int hand;
 int target;
 srand(t);
 hand = rand()%2 + 2;
 target = rand()%2;
 if(hmrk[hand]==1||hmrk[target]==1){
    /*this way even if the computer can split its hand, it wont always*/
	if (count[2]==2 || count[3]==2) {
		if (rand()%2==1) {
			count[2] = 1;
			count[3] = 1;
			hmrk[2] = 0;
			hmrk[3] = 0;
			return 0;
		}
	}else if (count[3]==4 || count[2]==4) {
		if (rand()%2==1) {
			count[2] = 2;
			count[3] = 2;
			hmrk[2] = 0;
			hmrk[3] = 0;
			return 0;
		}
	}
 	recallcomputeraction();
 }else{
 count[target] = count[target] + count[hand];
 return count[target];
 }
}

int computeraction2(int t) {
//attempt to make a smarter computer
	int hand;
	int target;
}


void recallcomputeraction(){
 int t = rand();
 computeraction(t);
 return;
}
