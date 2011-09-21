#!/usr/bin/env bash
#Shebang line for setting default for bash
#By Chris Carpio, S/N 994954518
#ubuntu needs /bin/bash here

echo $0
echo "Current date: `date`"

#setting usage message
usage="Usage: $0, uses two arguments: Name of Competition, Name of Project." 

#checking arguments
if [ $1 = "-h" ]	#if -h was used as an argument
then
	echo $usage
	exit 0
elif [ $# -ne 2 ]	#if less or more than 2 arguments were used
then
	echo "Incorrect number of parameters."
	echo $usage
	exit 1
fi

#setting variables
currdir=`pwd`	#remembering where the base directory is
competition=$1	#initializing first argument as competition name
project=$2	#initializing second argument as project name

#pre-creating directories
mkdir results
cd ./results
mkdir $competition
cd ./$competition
mkdir $project
cd $currdir/submit	#changing to submit directory

#for every competition directory
for dirs in `ls`
do
if [ $dirs = $competition ]	#if directory name matches competition name
then
	cd $dirs		#change to directory
	for users in `ls`	#looks through all users
	do
		cd $users	#changes into user dir
		for projects in `ls`	#for every project in user
		do
			#if project folder found
			if [ $projects = $project ]
			then
			#copy contents of folder into results hiearchy
			cp -r *  $currdir/results/$competition/$project/$users
			fi
			done
		cd ..	#change back to project category
		done
	fi
done

exit 0
