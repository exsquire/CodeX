#!/usr/bin/python3
"""
6. Create a python script called exomeReport.py
Create a single report that summarizes the findings. 
It should be a text file that lists the name of the 
discoverer of the organism, the diameter, 
the code name and the environment it came from. 

-Additionally, include how many genes the organism 
has in common with all of the other organisms, and 
which genes are unique to that organism.

Note: You are only comparing that organism against 
the other organisms of the same cohort 
(20-30mm in diameter). 

ie You are summarizing the motif-containing exomes 
with just the CRISPR-ready genes, in otherwords using 
the exomenames_precrispr.fasta 
(or exomenames_postcrispr.fasta since the headers 
should be identical between those two files)
There may not be any genes in common in that entire 
cohort. 

Example:
Organism FOX, discovered by DISCOVERER, has a 
diameter of DIAMETER, and has the NUMBER of genes 
in common with the cohort, and the following genes 
unique to only itself: gene1, gene4, gene823
"""
#Must be run from the scripts folder
import os
import re

files = os.listdir("../preCRISPR")

#Generate Inputs -
allGenes = [] #All sequences from all exomes
cohort = [] # exome names for calling and parsing
dict = {} #exome-specific sequences
for file in files:
    desig = re.sub('_.*$', '', file) #keep exome name only
    file = "../preCRISPR/" + file #file path
    cohort.append(desig)
    tmp = open(file)
    curGenes=[] #current genes
    for line in tmp:
        clean = line.rstrip("\n")
        if "gene" not in clean:
            allGenes.append(clean) #doesn't get loop cleared
            curGenes.append(clean) #does get cleared
    tmp.close()
    #print("%s has %d genes" % (desig ,len(curGenes)))
    dict[desig] = curGenes #build dictionary
    
outfile = open("../summary.txt", "a+")     
for org in cohort:
    #Find common genes 
    common = 0
    oneLess = list(cohort)
    oneLess.remove(org)
    them = []
    for orgB in oneLess:
        #print("OrgA: " + org + " genes in OrgB: " + orgB)
        them.extend(dict[orgB])
        #Use set operations to find intersect and count
        common +=len(set(dict[org]) & set(dict[orgB]))
    #print(common)
    #Make list of unique genes
    us = dict[org]
    justUs = [i for i in us if i not in them]
    #Parse the clinical data by exome name
    dat = open("../inputs/clinical_data.txt")
    for row in dat:
        cleanRow = row.rstrip("\n").split("\t")
        if org in cleanRow:
            outfile.write("Organism %s, discovered by %s, has a diameter of %smm, and has %d genes in common with the cohort, and the following genes unique to only itself:\n\n" 
                  % (cleanRow[5],
                     cleanRow[0],
                     cleanRow[2],
                     common))
            outfile.write('\n\n'.join(justUs))
            outfile.write('\n-------------------------\n')
            
    dat.close()  
outfile.close()    

