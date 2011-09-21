#!/usr/bin/env bash


echo $0
echo "Current date: `date`"
usage="Usage: $0, uses two arguments: Name of Competition, Name of Project." 

if [ "$1" = "-h" ]
then
	echo $usage
	exit 0
elif [ $# -ne "2" ]
then
	echo "Incorrect number of parameters."
	echo $usage
	exit 1
fi

currdir=`pwd`
competition=$1
project=$2

for d in `ls results/$1/$2/`
do
cp process.sh results/$1/$2/$d/
done
for d in `ls results/$1/$2/`
do cp process.sh results/$1/$2/$d/
done
cd results/$1/$2
for d in `ls`; do pushd $d; process.sh; popd; done

