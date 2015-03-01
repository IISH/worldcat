#!/bin/bash

clear
echo "Time:" `date +"%T"`


echo
echo "Source: $2"
cat $2 | grep $1


#if [[ -n "$3" ]]
#then
#	echo
#	echo "Source 2: $3"
#	cat $3 | grep $1
#fi

#echo
#echo "Target: out/test.xml"
cat out/test.xml | grep $1


echo
echo
