#!/usr/bin/env bash

#Shebang line to default into the Bash Shell
#By Chris Carpio, S/N 994954518


echo "-===== $0 =====-"
echo "Current date: `date`"
usage="Usage: $0, uses no arguments, but accepts -h for a usage explanation." 

#Handling parametres
if [ "$1" = "-h" ]
then
	echo $usage
	exit 0
elif [ $# -ne 0 ]
then
	echo "Incorrect number of parameters."
	echo $usage
	exit 1
fi

#Declarations and Initilizations
alias javac="nice javac"	#Settinng the java command to be nice :D
alias java="nice java"		#Re above. So that it doesn't get killed.
path=`pwd`			#Keeping the pushed directory as a var.
currdir=`basename $path`	#Abbreviated name of directory.
outfile="$currdir.out"		#Output file, [usr].out, stdout, str go here.
main="none"			#main flag, set if main method is found.
declare -a noncomp		#array for list/files that failed to compile.
foundname="none"		#flag for if "* Name:" was found.

exec >$outfile 2>&1		#redirecting stdout, stdin to output file.

#checking what project name it is currently...
cd ..
projpath=`pwd`
project=`basename $projpath`
cd $currdir

echo "Processing files in $currdir..."
echo ""

#Goes through every file in the directory ending with .java
for files in `ls *.java`
do
	echo "-=Searching header for * Name:"
	echo
	#Gets the first line of file, then searches for "* Name:"
	head -1 $files | grep "\* Name:" > /dev/null 2>&1
	exit_code=$?
	if [ $exit_code -eq 0 ]		#if successful, flag foundname
	then
		echo "-==Found * Name: in $files"
		foundname="found"
		echo 
	else				#did not find * Name:
		echo "-==Did not find * Name: in $files"
		echo 
	fi
	
	echo "-=Compiling $files..."
	echo 
	javac $files			#compiles source file
	exit_code=$?
	if [ $exit_code -eq 1 ]		#exit code 1 means failed to compile
	then
		noncomp[${#noncomp[@]}]=$files	#adding file to array.
	fi
	echo 
	echo "-==javac exit code: $exit_code"
	echo 
	echo "-=Checking if $files is a main.."
	echo 
	
	#looks for the main method in classes
	grep  "main\(.*\)" $files > /dev/null 2>&1
	exit_code=$?
	if [ $exit_code -eq 0 ]		#main method found in source file
	then
		echo "-==grep exit code: $?"
		echo 
		echo "-==Found main, checking file name for project consistency"
		echo 
		#checking if file w. main method has same name as project.
		if [ `basename $files .java` = "$project" ]
		then
			main=$files
			echo "-===$files has correct file name!"
			echo ""
		else
		echo "-===$files has incorrect file name! Must match $project"
		echo 
		fi
	elif [ $exit_code -eq 1 ]	#main method not found in source file
	then
		echo "-==$files not main."
		echo 
	elif [ $exit_code -eq 2 ]	#couldn't even read file.
	then
		echo "-==$file could not be read!"
		echo 
	else				#???
		echo "-==Unusual error!"
		echo 
	fi
done


echo

#checking if the pattern "* Name:" was ever found
if [ $foundname = "none" ]
then
	echo "For all files, * Name: was never located."
fi

echo "List of java files that did not compile:"
for i in "${noncomp[@]}"	#Listing every file that couldn't be compiled.
do
	echo "$i"
done

echo 
echo "All files processe, attempting to execute main..."
echo
#checking to see if main method was found at all
if [ $main = "none" ]
then
	echo "No Main method found in any method!"
else
	java $main
	echo "java exit status: $?"
fi

echo
echo 
echo "End of Report."


exit 0
