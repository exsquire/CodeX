#!/bin/bash
#Pull the sample code names from the rows matching the selection criteria

PULL=$(awk 'BEGIN {FS = "[\t]+"} {if (($3 >= 20)&&($3 <= 30)&&($5 == "Sequenced")) {print $6}}' ../inputs/clinical_data.txt)

#Add filename extension 
GET_FILES=$(printf '%s.fasta\n' $PULL)

#check
#echo $GET_FILES

#Copy files from GET_FILES into 'exomes' directory
cd ../test_exomes
cp $GET_FILES ../exomes

echo -e Moving the following files from /test_exomes to /exomes:"\n"$GET_FILES
echo Done.
