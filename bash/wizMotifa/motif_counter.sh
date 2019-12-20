#!/bin/sh
#Here we will process a FASTA file of r.bifella in accordance
#with a text file of interesting motifs

#Task 1: Print out the number of occurences for each interesting motif
#in the genome and output to motif_count.txtg

#Set the input paths - I tried using position argument variables and invented a new
#language made entirely of curse words

MOTIF="./interesting_motifs.txt"
FASTA="./r_bifella.fasta"

if [ ! -d motifs ]; then
    mkdir motifs
fi

#Loop through lines of motif, trim the white space, pipe fasta to trimmed motif, put in file
echo "Counting motifs from $MOTIF...\n"
for MOT in $(cat $MOTIF);
do
    echo $MOT
    TRIM="$(echo $MOT | tr -d [:space:])"
    echo "$TRIM $(cat $FASTA | grep -o $TRIM | wc -l)" >> ./motif_count.txt
done

#Task 2: Create a FASTA file for each motif (n = 10), which contains all of the
#genes and corresponding sequences that have that motif. Each file should be named
#after the motif (i.e. ATG.txt) and outputted to a new directory called motifs

#Make list of gene names
GENES=$(cat $FASTA | grep -o -e 'gene[0-9]*')
#echo $GENES

#Use grep to loop through the genes
echo "\nBuilding motif-specific fastas:\n"

for GENE in $GENES;
do
    echo "Gene: $GENE\n"
    #Store current gene in temporary variable
    TMP=$(grep -w -A 1 $GENE $FASTA)
    #echo $TMP
    #Loop through Motifs asking if each one is in TMP using grep -c
    for MOT in $(cat $MOTIF);
    do
        TRIM="$(echo $MOT | tr -d [:space:])"
        ASK=$(echo $TMP | grep -c $TRIM)
        #If motif exists in this gene do stuff
        if [ $ASK -gt 0 ];
        then
            #If file does not exist, make it
            if [ ! -e "./motifs/""$TRIM"".txt" ];
            then
                touch "./motifs/""$TRIM"".txt"
            fi
        #Append $TMP to "$TRIM"".txt"
        echo $TMP | tr " " "\n" >> "./motifs/""$TRIM"".txt"
        fi
    done
done
echo "Done."
