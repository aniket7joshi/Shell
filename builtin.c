#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/types.h>
#include <sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include <stdlib.h>
int implementcd(char input_words[][20],char curpath[])
{

	if (input_words[1] == "over") 
	{

    	chdir(curpath);
  	} 
  	else 
  	{

  		if (strncmp(input_words[1],"~", 1)==0)
  		{     //printf("yo found!\n" );
        	strcpy(input_words[1],curpath);
        		printf("hi\n");
        //printf("args[1] is %s\n",args[1] );
      	}
		int dir = chdir(input_words[1]);
      	/*if (dir!=0) 
      	{
      		perror("cant change the directory");
    	}*/
    }
  	return 1;	
}
void implementpwd()
{
	char my_cwd[1024];
	getcwd(my_cwd, 1024);
	printf("%s\n", my_cwd);
}