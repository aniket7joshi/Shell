#include<stdio.h>
#include<string.h>
#include<unistd.h>
#include<errno.h>
#include<sys/types.h>
#include <sys/wait.h>
#include<signal.h>
#include<fcntl.h>
#include <stdlib.h>
int implementcd(char input_words[][20],char curpath[], char home[]);
int input(char input_commands[], char input_sentences[][1000], char copy[]);
int split(char sentence[], char input_words[][20]);
void implementpwd();
void implementpinfo(char input_words[][20], char home[]);
int implementEcho(char input_words[][20]);
char input_commands[10000];
char input_sentences[1000][1000];
char copy[10000];

int main()
{	
	while(1)
	{
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
		int i, j;
		char *pass;
		int number_of_lines = input(input_commands,input_sentences,copy);
		for(i=0;i<number_of_lines;i++)
		{
			//strcpy(pass,input_sentences[i]);
			char input_words[20][20];
			//printf("%s\n",input_sentences[i]);
			int number_of_words = split(input_sentences[i],input_words);
			if(strcmp(input_words[0],"cd") == 0)
			{
				implementcd(input_words,curpath,home);
			}
			else if (strcmp(input_words[0],"pwd") == 0)
			{
				implementpwd();
			}
			else if(strcmp(input_words[0],"pinfo") == 0)
			{
				implementpinfo(input_words, home);
			}
			else if (strcmp(input_words[0],"echo") == 0)
			{	//printf("%d",(int)strlen(input_words));
				//int size =0;
				implementEcho(input_words);
			}
		}
	}	
	return 0;

}