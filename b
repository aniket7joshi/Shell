5a6,7
> #include <sys/utsname.h>
> #include<string.h>
10,56c12,26
< #include <dirent.h>
< #include <sys/stat.h>
< #include <sys/types.h>
< void lsDetails(struct dirent *dirp,int a)
< { if(a == 1)
<   {	  if(dirp->d_name[0] != '.')
< 	  {	struct stat fileStat;
< 		  stat(dirp->d_name,&fileStat);
< 		  printf( (S_ISDIR(fileStat.st_mode)) ? "d" : "-");
< 		  printf( (fileStat.st_mode & S_IRUSR) ? "r" : "-");
< 		  printf( (fileStat.st_mode & S_IWUSR) ? "w" : "-");
< 		  printf( (fileStat.st_mode & S_IXUSR) ? "x" : "-");
< 		  printf( (fileStat.st_mode & S_IRGRP) ? "r" : "-");
< 		  printf( (fileStat.st_mode & S_IWGRP) ? "w" : "-");
< 		  printf( (fileStat.st_mode & S_IXGRP) ? "x" : "-");
< 		  printf( (fileStat.st_mode & S_IROTH) ? "r" : "-");
< 		  printf( (fileStat.st_mode & S_IWOTH) ? "w" : "-");
< 		  printf( (fileStat.st_mode & S_IXOTH) ? "x" : "-");
< 		  printf(" %ld ",fileStat.st_size);
< 		  printf(" %ld ",fileStat.st_nlink);
< 		  printf(" %ld ",fileStat.st_ino);
< 		  printf(" %s ", dirp->d_name);
< 	  	  printf("\n");
< 	  }
<    }
<    else
<    {
< 	  struct stat fileStat;
< 	  stat(dirp->d_name,&fileStat);
< 	  printf( (S_ISDIR(fileStat.st_mode)) ? "d" : "-");
< 	  printf( (fileStat.st_mode & S_IRUSR) ? "r" : "-");
< 	  printf( (fileStat.st_mode & S_IWUSR) ? "w" : "-");
< 	  printf( (fileStat.st_mode & S_IXUSR) ? "x" : "-");
< 	  printf( (fileStat.st_mode & S_IRGRP) ? "r" : "-");
< 	  printf( (fileStat.st_mode & S_IWGRP) ? "w" : "-");
< 	  printf( (fileStat.st_mode & S_IXGRP) ? "x" : "-");
< 	  printf( (fileStat.st_mode & S_IROTH) ? "r" : "-");
< 	  printf( (fileStat.st_mode & S_IWOTH) ? "w" : "-");
< 	  printf( (fileStat.st_mode & S_IXOTH) ? "x" : "-");
< 	  printf(" %ld ",fileStat.st_size);
< 	  printf(" %ld ",fileStat.st_nlink);
< 	  printf(" %ld ",fileStat.st_ino);
< 	  printf(" %s ", dirp->d_name);
< 	  printf("\n");
<    }
< }
< int implementcd(char input_words[][20],char curpath[], char home[], int number_of_words)
---
> #include <pwd.h>
> void implementpinfo(char input_words[][20], char home[]);
> int implementcd(char input_words[][20],char curpath[], char home[],int number_of_words);
> int input(char input_commands[], char input_sentences[][1000], char copy[]);
> int split(char sentence[], char input_words[][20]);
> void implementpwd();
> char input_commands[10000];
> char input_sentences[1000][1000];
> char copy[10000];
> int implementEcho(char input_words[][20]);
> int implementLS(char input_words[][20]);
> void redirect(char input_words[][20], int number_of_words);
> int checkpipe(char input_words[][20], int number_of_words);
> int implementpipe(char *pip[], int count);
> int main()
58,60c28,46
< 	if(strcmp(input_words[number_of_words - 2],"&")!=0)
< 	{
< 		if (strcmp(input_words[1],"over") == 0)
---
> 	while(1)
> 	{	char *temp[20];
> 		char cwd[1024];
> 		cwd[1023]='\0';
> 		char *original=getcwd(cwd, sizeof(cwd));
> 		char string[1024];
> 		strcpy(string,original);
> 		char * home = (char *)malloc(1000*sizeof(char));
> 		char *relative = (char*)malloc(1000*sizeof(char));
> 		char hostname[1024];
> 		char curpath[1024];
> 		struct passwd * myname=NULL;
>   		myname = getpwuid(getuid());
> 		gethostname(hostname, 1023);
> 		hostname[1023] = '\0';
> 		strcpy(home, getenv("PWD"));
> 		getcwd(curpath, 1024);
> 		int ret = strncmp(home, curpath, strlen(home));
> 		if(ret == 0)
62,78c48,173
< 			//printf("yo\n");
< 	    	strcpy(input_words[1],home);
< 	  	}
< 	  	else
< 	  	{
< 
< 	  		if (strncmp(input_words[1],"~", 1)==0)
< 	  		{     //printf("yo found!\n" );
< 	        	strcpy(input_words[1],home);
< 	        //printf("args[1] is %s\n",args[1] );
< 	      	}
< 	    }
< 	    int out = chdir(input_words[1]);
< 	    if(out!=0)
< 	    {
< 	    	perror("Error: ");
< 	    }
---
> 			relative[0] = '~';
> 			int ptr = 1;
> 			int i;
> 			for(i = strlen(home);i<strlen(curpath);i++)
> 			{
> 				relative[ptr] = curpath[i];
> 				ptr++;
> 			}
> 			relative[strlen(curpath)] = '\0';
> 		}
> 		else
> 		{
> 			strcpy(relative,curpath);
> 		}
> 		printf("<%s@%s>:%s ",myname->pw_name,hostname,relative);
> 		int i, j = 0;
> 		char *pass;
> 		int background;
> 		int number_of_lines = input(input_commands,input_sentences,copy);
> 		for(i=0;i<number_of_lines;i++)
> 		{
> 			char input_words[20][20];
> 			int number_of_words = split(input_sentences[i],input_words);
> 			int count = checkpipe(input_words, number_of_words-1);
> 			if(count>1)
> 			{
> 				char *pip[20];
> 				int x = 0;
> 				for(int j=0;j<=number_of_words-2;j++)
> 				{
> 					if(strncmp(input_words[j],"|",1)!=0)
> 					{
> 						pip[x] = input_words[j];
> 						x++;
> 					}
> 				}
> 				implementpipe(pip, count);
> 				continue;
> 			}
> 			printf("%d\n",count);
> 			background=(strcmp(input_words[number_of_words-2],"&")==0);
> 			j = 0;
> 			while(strcmp(input_words[j],"over")!=0)
> 			{
> 				temp[j]=input_words[j];
> 				j++;
> 			}
> 			temp[j] = NULL;
> 			if(((strcmp(input_words[0],"cd")==0) || strcmp(input_words[0],"pinfo") == 0 || strcmp(input_words[0],"pwd")==0 || strcmp(input_words[0],"echo")==0 || strcmp(input_words[0],"ls")==0 || strcmp(input_words[0],"exit")==0) && (background==0))
> 			{
> 				if(strcmp(input_words[0],"cd") == 0)
> 				{
> 					implementcd(input_words,curpath,home,number_of_words);
> 				}
> 				else if (strcmp(input_words[0],"pwd") == 0)
> 				{
> 					implementpwd();
> 				}
> 				else if (strcmp(input_words[0],"echo") == 0)
> 				{
> 					implementEcho(input_words);
> 				}
> 				else if (strcmp(input_words[0],"exit") == 0)
> 				{
> 					exit(0);
> 				}
> 				else if(strcmp(input_words[0],"pinfo") == 0)
> 				{
> 					implementpinfo(input_words, home);
> 				}
> 				else if (strcmp(input_words[0],"ls") == 0)
> 				{
> 					implementLS(input_words);
> 				}
> 			}
> 			else
> 			{
> 				if(strcmp(input_words[0],"cd") == 0)
> 				{
> 					implementcd(input_words,curpath,home,number_of_words);
> 				}
> 				else
> 				{
> 					pid_t pid;
> 					int status;
> 					int j = 0;
> 					pid=fork();
> 					if(pid<0)
> 					{
> 						fprintf(stderr, "Fork failed");
> 					}
> 					else if(pid == 0)
> 					{
> 						redirect(input_words, number_of_words - 2);
> 						while(strcmp(input_words[j],"over")!=0)
> 						{
> 							if(strcmp(input_words[j],"redirection") == 0)
> 								temp[j] = NULL;
> 							else
> 								temp[j]=input_words[j];
> 							j++;
> 						}
> 						if(background == 1)
> 							temp[j-1] = NULL;
> 						else
> 							temp[j] = NULL;
> 						if(execvp(input_words[0],temp)<0)
> 						{
> 							perror("Error");
> 							exit(0);
> 						}
> 					}
> 					else
> 					{
> 						if(background == 0)
> 						{
> 							wait(&status);
> 						}
> 						else if(background == 1)
> 						{
> 							printf("Process Started: %s [%d]\n",input_words[0],pid);
> 						}
> 					}
> 				}
> 			}
> 		}
80,251c175
<   	return 1;
< }
< void implementpwd()
< {
< 	char my_cwd[1024];
< 	getcwd(my_cwd, 1024);
< 	printf("%s\n", my_cwd);
< }
< int implementEcho(char input_words[][20])
< {
<   if(strcmp(input_words[1],"over") == 0)
<   { //printf("Hello");
<     printf("\n" );
<     return 1;
<   }
<   else
<   { int i = 1;
<     do{
<       printf("%s ",input_words[i]);
<       i++;
<     }while(strcmp(input_words[i],"over")!=0);
<     printf("\n");
<   }
< }
< void implementpinfo(char input_words[][20], char home[])
< {
<   char filename[1000];
<   int flag = 0;
<   char s[100];
<   strcpy(filename,"/proc/");
<   if(strcmp(input_words[1],"over")!=0)
<   {
<     strcat(filename,input_words[1]);
<     flag = 1;
<   }
<   else
<   {
<     int i=0;
<     int pid = getpid();
<     int n = pid;
<     do
<     {
<       s[i++] = n % 10 + '0';
<     }while ((n /= 10) > 0);
<     s[i] = '\0';
<     int j = strlen(s)-1;
<     i = 0;
<     while(i<j)
<     {
<       char c = s[i];
<       s[i] = s[j];
<       s[j] = c;
<       i++;
<       j--;
<     }
<     strcat(filename,s);
<   }
<   char status[1000];
<   strcpy(status, filename);
<   strcat(status, "/status");
<   //printf("%s\n",status );
<   FILE *fp1 = fopen(status, "r");
<   if(!fp1)
<   {
<       fprintf(stderr,"Invalid Process\n");
<       return;
<   }
<   char l[1000];
<   while ( fgets ( l, sizeof l, fp1 ) != NULL )
<   {
<     char* field = strtok(l,":");
<     if(!strcmp(field,"Name"))
<     {
<       field=strtok(NULL,":");
<       printf("Name - %s",field);
< 
<     }
<     if(!strcmp(field,"State"))
<     {
<       field=strtok(NULL,":");
<       printf("State - %s",field);
< 
<     }
<     if(!strcmp(field,"Pid"))
<     {
<       field=strtok(NULL,":");
<       printf("Pid - %s",field);
< 
<     }
<     if(!strcmp(field,"VmSize"))
<     {
<       field=strtok(NULL,":");
<       printf("Virtual Memory - %s",field);
< 
<     }
< 
<   }
<   fclose(fp1);
<   if(flag == 0)
<     printf("Executable Path:%s/main",home);
<   printf("\n");
< }
< 
< int implementLS(char input_words[][20])
< { char my_cwd[1024];
<   getcwd(my_cwd, 1024);
<   DIR *dir;
<   struct dirent *dirp;
<   int i = 0;
<   int flag = 0;
< 
<   while(strcmp(input_words[i],"over")!=0)
<   {
<     if ((dir = opendir (my_cwd)) != NULL) {
<     /* print all the files and directories within directory */
<      //printf("1");
<      if(strcmp(input_words[i],"-l") == 0){
<      while ((dirp = readdir(dir)) != NULL){
<           lsDetails(dirp,1);
<           flag = 1;
<       }
<       break;
<      }
< 
<     else if(strcmp(input_words[i],"-al") == 0 || strcmp(input_words[i],"-la") == 0 || (strcmp(input_words[i],"-a") == 0 && strcmp(input_words[i+1],"-l") == 0) || (strcmp(input_words[i],"-l") == 0 && strcmp(input_words[i+1],"-a") == 0))
<     {
<     	while ((dirp = readdir(dir)) != NULL){
<           lsDetails(dirp,0);
<           flag = 1;
<       }
<       break;
<     }
<      else if(strcmp(input_words[i],"-a") == 0)
<     {
<     	while ((dirp = readdir(dir)) != NULL){
<           lsDetails(dirp,0);
<           flag = 1;
<       }
<      break;
<     }
< 
<     else if(strcmp(input_words[i+1],"over") == 0)
<     {
< 
<       while ((dirp = readdir(dir)) != NULL)
<       { if((strcmp(dirp->d_name,".")!=0) || (strcmp(dirp->d_name,"..")!=0))
<         if(dirp->d_name[0] != '.')
<         {
< 	        printf("%s ", dirp->d_name);
< 	        printf("\n");
< 	    }
<       }
<       break;
< 
<     }
<     else if(input_words[i+1][0] != '-')
<     {
<       printf("No such file or directory\n");
<       break;
<     }
<     }
< 
<     else {
<     /* could not open directory */
<     perror ("");
<     return EXIT_FAILURE;
<     }
< 
<     i++;
<     closedir (dir);
<     }
< 
---
> 	return 0;
