#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/types.h>
#include <sys/utsname.h>
#include<string.h>
#include <sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include <stdlib.h>
#include <pwd.h>
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
void redirect(char input_words[][20], int number_of_words);
int main()
{
	while(1)
	{	char *temp[20];
		char cwd[1024];
		cwd[1023]='\0';
		char *original=getcwd(cwd, sizeof(cwd));
		char string[1024];
		strcpy(string,original);
		char * home = (char *)malloc(1000*sizeof(char));
		char *relative = (char*)malloc(1000*sizeof(char));
		char hostname[1024];
		char curpath[1024];
		struct passwd * myname=NULL;
  		myname = getpwuid(getuid());
		gethostname(hostname, 1023);
		hostname[1023] = '\0';
		strcpy(home, getenv("PWD"));
		getcwd(curpath, 1024);
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
		printf("<%s@%s>:%s ",myname->pw_name,hostname,relative);
		int i, j = 0;
		char *pass;
		int background;
		int number_of_lines = input(input_commands,input_sentences,copy);
		for(i=0;i<number_of_lines;i++)
		{
			char input_words[20][20];
			int number_of_words = split(input_sentences[i],input_words);
			background=(strcmp(input_words[number_of_words-2],"&")==0);
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
				{
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
					pid_t pid;
					int status;
					int j = 0;
					pid=fork();
					if(pid<0)
					{
						fprintf(stderr, "Fork failed");
					}
					else if(pid == 0)
					{
						redirect(input_words, number_of_words - 2);
						while(strcmp(input_words[j],"over")!=0)
						{
							if(strcmp(input_words[j],"redirection") == 0)
								temp[j] = NULL;
							else
								temp[j]=input_words[j];
							j++;
						}
						if(background == 1)
							temp[j-1] = NULL;
						else
							temp[j] = NULL;
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
