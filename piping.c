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
int checkpipe(char input_words[][20], int number_of_words)
{
    int i=0;
    int count = 0;
    for(int i=0;i<number_of_words;i++)
    {
        if(strncmp(input_words[i],"|",1) == 0)
        {
            count++;
        }
    }
    return count + 1;
}
int spawn(int in, int out, char *temp[], int i,char first[][1000])
{
    printf("first is %s\n",first[i]);
    printf("temp is %s\n",temp[0]);
    pid_t pid;
    if ((pid = fork ()) == 0)
    {
        if (in!=0)
        {
            dup2 (in, 0);
            close (in);
        }
        if (out!=1)
        {
            dup2 (out, 1);
            close (out);
        }
        printf("before execvp\n");
        return execvp(first[i], temp);
    }
    return pid;
}
int implementpipe(char pip[][1000], int count)
{
    for(int i=0;i<count;i++)
    {
        printf("%s\n",pip[i]);
    }
    //printf("count is %d\n",count );
    char *temp[1000];
    char first[1000][1000];
    for(int i=0;i<count;i++)
    {
        //printf("hi\n" );
        int x = strlen(pip[i]);
        temp[i] = pip[i];
        temp[i][x-1] = '\0';
        int len = strlen(pip[i]);
        for(int j=0;j<len;j++)
        {
            if(pip[i][j] == ' ')
                break;
            first[i][j] = pip[i][j];
        }
        printf("%s\n",temp[i]);
    }

    int i=0, in=0, fd[2];
    pid_t pid;
    while(i<count-1)
    {
        printf("while\n" );
        pipe(fd);
        printf("pipe\n");
        spawn(in, fd[1], temp+i, i, first);
        printf("spawn\n");
        close(fd[1]);
        printf("close\n");
        in = fd[0];
        printf("in is %d\n",0);
        i++;
    }
    if(in!=0)
    {
        dup2(in, 0);
    }
    int len = strlen(temp[i]);
    printf("len is %d\n",len );
    printf("%s\n",temp[i]);
    return execvp(first[i], temp + i);
}
