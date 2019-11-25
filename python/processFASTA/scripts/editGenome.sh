#!/bin/bash

for FILE in $(ls ../preCRISPR | grep precrispr.fasta);do
    INPUT="../preCRISPR/$FILE"
    GENES=$(cat $INPUT | grep -o -e 'gene[0-9]*')
    #echo $GENES

    #Pull desig from INPUT
    DESIG="$( basename "$INPUT" | sed 's/_.*$//' )""_postcrispr.fasta"
        if [ ! -e ../postCRISPR/$DESIG ];then
            touch ../postCRISPR/$DESIG
        fi
    echo Creating post-CRISPR file: $DESIG...

    #Make the for loop
    for GENE in $GENES; #For each sequence in an exome
    do
        #echo -e GENE "\n" $GENE "\n"
        TMP=$(awk 'f{print;f=0} /'$GENE' /{f=1}' "$INPUT") #tmp out sequence
        #echo -e TMP "\n" $TMP "\n"
        #Save first 21 characters
        TMP21=${TMP:0:21}
        #echo -e TMP21 "\n" $TMP21 "\n"
        #Remove the first 21 characters
        MINUS21=${TMP:21}        
        #echo -e MINUS21 "\n" $MINUS21 "\n"
        #sed sub all GGs to AGGs
        SUB=$(echo $MINUS21 | sed 's/GG/AGG/g')
        #echo -e SUB "\n" $SUB "\n"
        #Re-append the first 21 characters
        TACKBACK="$TMP21""$SUB" 
        #echo -e TACKBACK "\n" $TACKBACK "\n"
        echo '>'$GENE" " >> ../postCRISPR/$DESIG
        echo $TACKBACK >> ../postCRISPR/$DESIG
    done
done
echo Done.

