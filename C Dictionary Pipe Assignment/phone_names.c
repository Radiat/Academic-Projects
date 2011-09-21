/* Assignment 3
 * Chris Carpio
 * 994954518
 * phone_names.c , pipe and fork file
 */


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/wait.h>

#define DICTDEF "dict.dct"
#define EXT ".dic"
#define UEXT ".DIC"
#define MAX_WORD 50

//Borrowed from example program. Function that prints how to use program.
void usage(char *prog)
{
  fprintf(stderr, "usage: %s [-d dictionary] string\n", prog);
  fprintf(stderr, "string must contain only letters and numbers\n");
  exit(2);
}

/* remove terminating newline from string s */
int chomp(char *s)
{
  int len = strlen(s);
  if (s[len-1] == '\n') {
    s[len-1] = '\0';
    return 1;
  }
  return 0;
}

//Another 'borrowed' function, matching numbers to phone combinations.
int phonemmatch (char *word, char *string)
{
//printf("matching '%s' and '%s'\n", word, string);
  while (*word && *string) {
    if (isalpha(*string) && toupper(*word) != toupper(*string)) {
      return 0;
    } else if (*string == '2') {
      if (!(toupper(*word)=='A' ||
	    toupper(*word)=='B' ||
	    toupper(*word)=='C')) {
	return 0;
      }
    } else if (*string == '3') {
      if (!(toupper(*word)=='D' ||
	    toupper(*word)=='E' ||
	    toupper(*word)=='F')) {
	return 0;
      }
    } else if (*string == '4') {
      if (!(toupper(*word)=='G' ||
	    toupper(*word)=='H' ||
	    toupper(*word)=='I')) {
	return 0;
      }
    } else if (*string == '5') {
      if (!(toupper(*word)=='J' ||
	    toupper(*word)=='K' ||
	    toupper(*word)=='L')) {
	return 0;
      }
    } else if (*string == '6') {
      if (!(toupper(*word)=='M' ||
	    toupper(*word)=='N' ||
	    toupper(*word)=='O')) {
	return 0;
      }
    } else if (*string == '7') {
      if (!(toupper(*word)=='P' ||
	    toupper(*word)=='Q' ||
	    toupper(*word)=='R' ||
	    toupper(*word)=='S')) {
	return 0;
      }
    } else if (*string == '8') {
      if (!(toupper(*word)=='T' ||
	    toupper(*word)=='U' ||
	    toupper(*word)=='V')) {
	return 0;
      }
    } else if (*string == '9') {
      if (!(toupper(*word)=='W' ||
	    toupper(*word)=='X' ||
	    toupper(*word)=='Y' ||
	    toupper(*word)=='Z')) {
    return 0;
      }
    } else {
      return 0;
    }
    word++;
    string++;
  }
  return (*word == *string);
}

/* Function that accepts a dictionary file name, 
 * phone number string, and a file description. Calls upon
 * the necessary functions to search for a sutable match
 * for the number combination, and outputs it unto the 
 * stream with the file descriptor. Returns status.
 */
int search (char *dictionaryname, char *phoneNum, int file) {

  
  char word[MAX_WORD];
  FILE *dict;
  FILE *pp;

  if( (dict = fopen(dictionaryname, "r")) == NULL) {
    perror("fopen:");
    exit(2);
  }
  
  pp = fdopen (file, "w");

  fprintf(pp, dictionaryname);
  fprintf(pp, "\n");

  while (fgets(word, sizeof(word), dict)) {
    chomp(word);
    //printf("Word: %s\n", word);
    if (phonemmatch(word, phoneNum))
    {
      fprintf(pp, word);
      fprintf(pp, "\n");
    }
  }
  
  fprintf(pp, "\n");
  fclose(dict);
  fclose (pp);
  exit(0);
}

/*Main method of program*/
int main (int argc, char *argv[])
{
	
	char prompt[100];	//For storage of the user prompt.
	char *args[argc];	//To be used as a copy for the current arguments.
	int a;				//File index.
	
	//Copy the contents of the original arguments.
	for (a = 0; a < argc; a++) {
		args[a] = argv[a];
	}
	
	//Copying the original argc.
	int run = argc;
	char check[100];
	
	//While the user has not entered 'done'...
	while (strcmp(check, "done") != 0) {
		
	char *fileList[100];	//For all the dictionaries
	int i, j, status; 		
	int arrayPos = 0;		//Index for how many -valid- dictionaries
	char *phoneNum;			//Storing the string to be matched.
	
	/*Handling the user dictionary files and filtering bad files*/
		if (run == 0) {	//No arguments at all
			perror("No arguments specified. Usage: [dictFile] string\n");
			return 1;
		}
		if (run == 1) {	//No dictionaries chosen, or at worse no string
			perror("No Dictionaries/phone number specified!\
			 Usage: [dictFile] string\n");
			return 1;
		}
		else {	//Success, at least one dictionary and number.
			phoneNum = args[run - 1];
			//Checking dictionary extensions, ignore if no extension.
			for (i = 1; i < run - 1; i++) {	
				if ((strstr(args[i], EXT) == NULL) && strstr(args[i], UEXT) == NULL) {
					printf("Dictionary file %s does not end in %s\n", args[i], EXT);
				}
				else {
					fileList[arrayPos] = args[i];
					arrayPos++;
				}			
			}
		}
		
		
		int fd[arrayPos - 1][2];	//File descriptors, as many as dic files.
		
		//Create dic amount of pipes and fork that amount as well.
		for (i = 0; i < arrayPos; i++) {
			 pipe(fd[i]);
			 if (fork() == 0) {
	      	for (j = 0; j < i; j++) {    //Closing all past children
	       		close(fd[j][0]);
	        	close(fd[j][1]);
	        	}
	      	close(fd[i][0]);                  
	        search(fileList[i], phoneNum, fd[i][1]);	//Send data to method
	      	}        
		}
	
	    //Closing up all children
	    for(i = 0; i < arrayPos; i++) {                    
	      close(fd[i][1]);
	    }
	    
	    /* Wait for all Children, then print off the contents of the pipe */
	    for (i = 0; i < arrayPos; i++) {                   
	        int pid;
	        if ((pid = wait(&status)) == -1) {
	          perror("wait");
	        } else {
	          if (WIFEXITED(status)) {
	      		FILE *stream;
		  		int c;
		  		stream = fdopen (fd[i][0], "r");
		  		while ((c = fgetc (stream)) != EOF)
		  			putchar (c);
	
		  		fclose (stream);
	          }
	        }
	      }
	      
	      //User input handling
	      printf("\n");
	      printf("Please enter in more information, or enter 'done' to exit.\n");
	      printf("Remember to enter information the same \
	      format as initializing this program.\n");
	      fflush(stdout);					//Bug squish!
	      gets(prompt);
	      char *result = NULL;
	      run = 1;							//To reset amount of parametres
		  result = strtok( prompt, " " );	//Token the string.
		  strcpy(check, result);			//Copy first argument for detection
		  check[4] = '\0';		//Ridiculous, but chomp didnt get the job done
		  while( result != NULL ) {			//Fill in args with parametres
	    	args[run] = result;
	    	run++;
	    	result = strtok( NULL, " " );
			}
		}
		return 0;
		
}

