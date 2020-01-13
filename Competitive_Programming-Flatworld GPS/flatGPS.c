#include <stdio.h>
#include <stdlib.h>
#include <math.h>
/*Problem being created for my Competitive Programming class, Spring 2019. The gist of the problem is that the user is given a few lines containing | & -, and have to find any/all possible paths through the 2d maze.

Example input:
5   (number of layers in maze)
|--------|
|--||||--|
||-----|||
|||--||--|
|---|||-||

Example output:
'no path' if no path, or
'22234' (one of the possible paths)
*/
int map1[5][10] = {
{0,0,0,0,0,0,0,0,0,0},
{1,1,1,1,1,1,1,1,0,1},
{0,0,0,0,0,0,0,0,1,0},
{0,0,0,0,0,0,0,1,1,1},
{0,0,0,0,0,0,1,1,1,1}
};
int map1length = 5;
int expectedmap1solution[] = {8,8,7,6,5};


int * solutionattempt();
int solutionchecker();


int main(void){
	printf("\nThis is the first attempt of the flat-GPS problem for the Competitive Programming competition\n");
	printf("The first map is: \n");
	for(int i = 0; i<map1length; i++){
		for(int c = 0; c<10; c++){
			printf("%d",map1[i][c]);
		}
		printf("\n");
	}
	

	printf("Does the solution checking work?\n");
	int result = solutionchecker(&map1,&expectedmap1solution,&map1length);
	if(result == 1){
		printf("Yes\n");
	}else{
		printf("No\n");
	}
	
	return 0;
}






int solutionchecker(int map[][10], int solution[], int length){
	int isvalid = 0;
	int correct = 0;	
	for(int i=0; i<length; i++){
		if(map[i][solution[i]] == 0){
			isvalid++;
	//check to make sure the positions are valid		
		}
		if(i>0){
			int diff = solution[i] - solution[i-1];
			if(abs(diff)>1){
				isvalid--;
			}	
		//check to see if they make an invalid jump
			
		}
	}
	if(isvalid == length){
		correct = 1;
	}
	//if the answer is correct, a value of 1 is returned, otherwise return 0
	return correct;
}



int* solutionattempt(int** map, int length){
	int solution[length];

	return solution;
}





