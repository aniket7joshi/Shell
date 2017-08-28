#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/types.h>
#include <sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include <stdlib.h>
int implementcd(char input_words[][20],char curpath[], char home[])
{
	//printf("%s\n",input_words[1]);
	if (strcmp(input_words[1],"over") == 0) 
	{
		//printf("yo\n");
    	strcpy(input_words[1],home);
  	} 
  	else 
  	{

  		if (strncmp(input_words[1],"~", 1)==0)
  		{     //printf("yo found!\n" );
        	strcpy(input_words[1],home);
        		printf("hi\n");
        //printf("args[1] is %s\n",args[1] );
      	}
    }
    int out = chdir(input_words[1]);
    if(out!=0)
    {
    	perror("Error: ");	
    }
  	return 1;	
}
void implementpwd()
{
	char my_cwd[1024];
	getcwd(my_cwd, 1024);
	printf("%s\n", my_cwd);
}