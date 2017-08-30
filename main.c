#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/types.h>
#include<string.h>
#include <sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include <stdlib.h>
void implementpinfo(char input_words[][20], char home[]);
int implementcd(char input_words[][20],char curpath[], char home[],int number_of_words);
int input(char input_commands[], char input_sentences[][1000], char copy[]);
int split(char sentence[], char input_words[][20]);
void implementpwd();
char input_commands[10000];
char input_sentences[1000][1000];
char copy[10000];
int implementEcho(char input_words[][20]);
int implementLS(char input_words[][20]);

int main()
{	
	while(1)
	{	char *temp[20];
		char cwd[1024];
		cwd[1023]='\0';
		char *original=getcwd(cwd, sizeof(cwd));
		char string[1024];
		strcpy(string,original);
		char *username = (char*)malloc(1000*sizeof(char));
		char * home = (char *)malloc(1000*sizeof(char));
		char *relative = (char*)malloc(1000*sizeof(char));
		char hostname[1024];
		char curpath[1024];
		
		username = getlogin();
		gethostname(hostname, 1023);
		hostname[1023] = '\0';
		//printf("%s\n",hostname );
		strcpy(home, getenv("PWD"));
		//printf("home is %s\n",home);
		getcwd(curpath, 1024);
		//printf("current path is %s\n",curpath);
		int ret = strncmp(home, curpath, strlen(home));
		if(ret == 0)
		{
			relative[0] = '~';
			int ptr = 1;
			int i;
			for(i = strlen(home);i<strlen(curpath);i++)
			{
				relative[ptr] = curpath[i];
				ptr++;
			}
			relative[strlen(curpath)] = '\0';
		}
		else
		{
			strcpy(relative,curpath);
		}
		//printf("%s\n",relative);
		printf("<%s@%s>:%s ",username,hostname,relative);
		int i, j = 0;
		char *pass;
		int background;
		int number_of_lines = input(input_commands,input_sentences,copy);
		for(i=0;i<number_of_lines;i++)
		{
			//strcpy(pass,input_sentences[i]);
			char input_words[20][20];
			//printf("%s\n",input_sentences[i]);
			int number_of_words = split(input_sentences[i],input_words);
			background=(strcmp(input_words[number_of_words-2],"&")==0);
			//printf("%d\n",background );
			j = 0;
			while(strcmp(input_words[j],"over")!=0)
			{
				temp[j]=input_words[j];
				j++;
			}
			temp[j] = NULL;
			if(((strcmp(input_words[0],"cd")==0) || strcmp(input_words[0],"pinfo") == 0 || strcmp(input_words[0],"pwd")==0 || strcmp(input_words[0],"echo")==0 || strcmp(input_words[0],"ls")==0 || strcmp(input_words[0],"exit")==0) && (background==0))
			{
				if(strcmp(input_words[0],"cd") == 0)
				{

					implementcd(input_words,curpath,home,number_of_words);
				}
				else if (strcmp(input_words[0],"pwd") == 0)
				{
					implementpwd();
				}
				else if (strcmp(input_words[0],"echo") == 0)
				{	//printf("%d",(int)strlen(input_words));
					//int size =0;
					implementEcho(input_words);
				}
				else if (strcmp(input_words[0],"exit") == 0)
				{
					exit(0);
				}
				else if(strcmp(input_words[0],"pinfo") == 0)
				{
					implementpinfo(input_words, home);
				}
				else if (strcmp(input_words[0],"ls") == 0)
				{
					implementLS(input_words);
				}
			}
			else
			{
				if(strcmp(input_words[0],"cd") == 0)
				{

					implementcd(input_words,curpath,home,number_of_words);
				}
				else
				{
					if(background == 1)
					{
						while(strcmp(input_words[j],"over")!=0)
						{
							temp[j]=input_words[j];
							j++;
						}
						
						temp[j-1] = NULL;
					}	
					pid_t pid;
					int status	;
					int j = 0;
					pid=fork();
					if(pid<0)
					{
						fprintf(stderr, "Fork failed");
					}
					else if(pid == 0)
					{
						if(execvp(input_words[0],temp)<0)
						{
							perror("Error");
							exit(0);
						}
					}
					else
					{
						if(background == 0)
						{
							wait(&status);
						}
						else if(background == 1)
						{
							printf("Process Started: %s [%d]\n",input_words[0],pid);
						}
					}
				}
			}
		}	
	}
	return 0;

}