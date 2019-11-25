#!/bin/bash

for FILE in $(ls ../topMOTIFS | grep topmotifs.fasta);do
    INPUT="../topMOTIFS/$FILE"
    GENES=$(cat $INPUT | grep -o -e 'gene[0-9]*')
    #echo $GENES

    #Pull desig from INPUT
    DESIG="$( basename "$INPUT" | sed 's/_.*$//' )""_precrispr.fasta"
        if [ ! -e ../preCRISPR/$DESIG ];then
            touch ../preCRISPR/$DESIG
        fi
    echo Creating pre-CRISPR file: $DESIG...

    #Make the for loop
    for GENE in $GENES; #For each sequence in an exome
    do
        TMP=$(awk 'f{print;f=0} /'$GENE' /{f=1}' "$INPUT") #tmp out sequence 
        CHECK=$(echo $TMP | grep -Ec '[[:alpha:]]{21,}GG')
        #echo $CHECK
        if [ $CHECK != 0 ];then
            echo '>'$GENE" " >> ../preCRISPR/$DESIG
            echo $TMP           >> ../preCRISPR/$DESIG
        fi     
    done
done
echo Done.
