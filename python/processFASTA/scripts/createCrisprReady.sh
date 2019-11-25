#!/bin/bash
#TESTING_PLAYGROUND--------------------------
#Test single motif method
#MOTIF1=TACATCTCTCTC #Single Motif
#EXOME1=$(cat exomes/lamb.fasta)

#echo "$MOTIF1" | wc -l
#COUNT=$(echo "$EXOME1" | grep -o $MOTIF1 | wc -l)
#echo "$COUNT"

#Make counts.txt, throw motif tab counts into it
#if [ ! -e counts.txt ];then
#    touch counts.txt
#fi

#echo -e "$MOTIF1\t$COUNT" >> counts.txt 


#Motif loop version
#while read MOTIF; do 
#    COUNT=$(echo "$EXOME1" | grep -o $MOTIF | wc -l)
#    if [ ! -e counts.txt ];then
#        touch counts.txt
#    fi
#    echo -e "$MOTIF\t$COUNT" >> counts.txt
#done < motif_list.txt
#Cool, works. Now make it a function that accepts exome filenames

#wizMotifa() generates crispr-ready fasta files based on the top 3 most frequently occuring motifs from a motif list.It takes the path to an exome file as input, generates a motif count file, which it references to filter the exome for sequences that contain at least one of the top motif.
#THE WIZ-------------------------------------
function wizMotifa {
    #Dynamically name count files - keep anything between last / and .fasta
    DESIG="$( basename "$1" | sed 's/\.[^.]*$//' )""_counts.txt"
    if [ ! -e ../motif_counts/$DESIG ];then
        touch ../motif_counts/$DESIG
    fi
    #Store exome
    EXOME=$(cat $1)
    #Run through motifs, grepping the OCCURRENCES - Lesson learned, Tim - and count them
    while read MOTIF; do
    COUNT=$(echo "$EXOME" | grep -o $MOTIF | wc -l)
    echo -e "$MOTIF\t$COUNT" >> ../motif_counts/$DESIG  #Build a tab-delim table
    done < ../inputs/motif_list.txt
    echo "Creating Motif Count File: $DESIG..."
    #----------------------------------------
    #There will now be a file $DESIG, sort and take [1:3,1] as the top motifs
    TOP=$(sort -k2 -nr ../motif_counts/$DESIG | head -n 3 | cut -f1 )
    echo "Pulling top 3 Motifs from motif_list.txt"
    #echo $TOP
    FILT=$(echo $TOP | sed 's/ /|/g') #Make the top mitf list into a pattern for OR grepping
    #echo $FILT

    #Dynamically name topmotifs files
    DESIG2="$( basename "$1" | sed 's/\.[^.]*$//' )""_topmotifs.fasta"
    #echo $DESIG2
    if [ ! -e ../topMOTIFS/$DESIG2 ];then
        touch ../topMOTIFS/$DESIG2
    fi
    #----------------------------------------
    #Pull gene headers for awking the sequence on the next line   
    echo -e "Filtering $1 for motifs: \n$TOP..."
    GENES=$(cat $1 | grep -o -e 'gene[0-9]*')
    #Make the for loop
    for GENE in $GENES; #For each sequence in an exome
    do
        TMP=$(awk 'f{print;f=0} /'$GENE'$/{f=1}' "$1") #tmp out sequence
        #echo $TMP
        #Ask if there are zero occurances of $TOPGREP - if None then SHUN
        if [ $(echo $TMP | grep -E -c $FILT) == 0 ];then
            #echo -e "\nSkipping sequence \n$TMP\n"
            continue
        fi
        #List the occurrences of tops
        OCCUR=$(echo $TMP | grep -E -o $FILT)
        #echo "$OCCUR"
        #echo "$OCCUR" | wc -l
        #Build header from scratch - label and count tops, then push to file on same line
        echo -n '>'$GENE" " >> ../topMOTIFS/$DESIG2
        for n in $TOP;do
            #Label and count
            NEWHEAD=$(echo $n"_"$(echo "$OCCUR" | grep -o $n | wc -l))
            echo -n $NEWHEAD" " >> ../topMOTIFS/$DESIG2
        done
        echo -en "\n"$TMP >> ../topMOTIFS/$DESIG2 #Add sequence
        echo -en "\n" >> ../topMOTIFS/$DESIG2 #Pretty formatting
    done
    echo "Generating CRISPR-ready file: $DESIG2..."
    echo -e  "Done.""\n"
}
#Single Tests
#wizMotifa "../exomes/chicken.fasta"
#wizMotifa "../exomes/fox.fasta"
#wizMotifa "../exomes/gopher.fasta"
#wizMotifa "../exomes/lamb.fasta"
#wizMotifa "../exomes/dromedary.fasta"
#wizMotifa "../exomes/goat.fasta"
#wizMotifa "../exomes/gorilla.fasta"
#Cool

#We're off to see the wizard!
for input in $(ls ../exomes);
do
    wizMotifa "../exomes/$input"
done





