#!/usr/bin/python3
"""
Created on Wed Aug 28 08:33:13 2019

@author: excel.que

Story:
Dr. Harrington noticed a strange mold growing out of the ears on 50 of his patients. All of the mold looked identical except for the color, which ranged from black, orange, yellow and green. A swab test on all the patients showed they were infected with the same fungal species called D. gorgon.  

Dr. Harrington sent the samples to a new sequencing company, Hawkins Laboratory, that offered to sequence it for free. Within a week the lab finished the sequencing and hands over the data as a single fastq file.

Dr. Harrington hands the data to you, the trustworthy hardworking unpaid intern, to build a pipeline to analyze the data and identify the mutations that resulted in the different color molds.

"""
#Load libraries
import os
import subprocess
import re
import pickle
from collections import Counter

#Create a dictionary of names and barcodes from clinical data file
with open("../inputs/harrington_clinical_data.txt", 'r') as codeFile:
    codes = {}
    for line in codeFile:
        line = line.split()
        if not line:
            continue
        codes[line[2]] = line[0]
        
#Rebuild iterator - parseSnatcher()
class parseSnatcher:
    #Define initialization as the contents of path location and add codefile arg and self parameters
    def __init__(self, path, codes, headSym = ['@','+']):
        with open(path, 'r') as f:
            self.contents = f.readlines()
        self.maxLines = len(self.contents)    
        self.curLine = 0
        self.hdSym = headSym
        self.slice = [] #store chunks of 4 lines = 1 fastq entry, access line with list element indexing
        self.pullCode = ""
        self.subject = ""
        self.trimNum = 0
        self.seqDict = {}
                
    #Define class as an iterable
    def __iter__(self):
        return(self)
        
    #Define next function - parse every 4 lines
    def __next__(self):
        #create bad quality trimmer - rev str, checks for double consec, drops first until non D or F, counting num drops, rev again, use num drops to chop off ends for seq and qual
        def dropIt(x):
            tmp = x[::-1]
            if tmp[:2] in ["FF","DD","FD","DF"]:
                count = 0
                while tmp[0] == "F" or tmp[0] == "D":
                    count += 1 #count cuts
                    tmp = tmp[1:] #drop it like it's hot
                return(-count)#flip it and give it
            else:
                return(len(x))
            #Remove the 'none's that get printed in the loop
        while True: #removes stdout "none" print
        #Each time this iterates, save 4 lines to a list
            self.slice = []#clear self.slice per iter
            for i in range(4):
                line = self.contents[self.curLine]
                self.slice.append(line.strip('\n'))
                self.curLine += 1
            if self.curLine == self.maxLines:
                raise StopIteration
            #Output contains a list of our slice, which we can call with .slice        
            #Modify it for 1A and 1B asks
            #Pull the first 5 from index 1 = barcode
            self.pullCode = self.slice[1][0:5]
            #Then remove first 5 characters from slice
            self.slice[1] = self.slice[1][5:] 
            self.slice[3] = self.slice[3][5:] 
            #Look up the subject attached to the code in "codes" dict
            self.subject = codes[self.pullCode]
            #Trim slice according to dropIt()
            self.trimNum = dropIt(self.slice[3])
            self.slice[1] = self.slice[1][:self.trimNum]
            self.slice[3] = self.slice[3][:self.trimNum]
            
            #Stick all this stuff into a dictionary
            #If the subject is not in the key values, add
            if self.subject not in self.seqDict.keys():    
                self.seqDict[self.subject] = [self.slice]
            else:
                self.seqDict.setdefault(self.subject).append(self.slice)
#make iter object
parseObj = parseSnatcher("../inputs/hawkins_pooled_sequences.fastq", codes)

#Run through iterator
for i in parseObj:
    print(i)
print("\nWriting fastq files\n")
#Loop write fastqs to output
for sub in parseObj.seqDict.keys():
    filename = "../outputs/" + sub + "_trimmed.fastq"
    with open(filename,'w') as fastq:
        for value in parseObj.seqDict.get(sub):
            for element in value:
                fastq.write('{}\n'.format(element))

#package subprocess into command, add loc arg to control starting dir
def subprocess_cmd(command, loc):
    process = subprocess.Popen(command,stdout=subprocess.PIPE, shell=True, cwd = loc)
    proc_stdout = process.communicate()[0].strip()
    print(proc_stdout)

print("\nIndexing reference file\n")
#index the reference file
subprocess_cmd("bwa index dgorgon_reference.fa", "../inputs")

#Several things. 1. go to outputs folder, take sampIDs from fastq filenames, use var $NAMES for names of  2. bwa mem fastqs to sam 3. sam to bam 4. bam to sorted 5. index sorted
print("\nWriting sam files\nWriting bam files\nSorting and Indexing bam files\n")
subprocess_cmd('NAMES=$(ls | sed "s/_trimmed.fastq//g"); for i in $NAMES;do bwa mem ../inputs/dgorgon_reference.fa "${i}""_trimmed.fastq" > "${i}"".sam";done; for i in $NAMES;do samtools view -bS "${i}"".sam" > "${i}"".bam";done; for i in $NAMES;do samtools sort "${i}"".bam" "${i}"".sorted";done;for i in $NAMES;do samtools index "${i}"".sorted.bam";done',"../outputs")
#Move fastas to own folder, remove non-bams
print("\nCleaning up...\n")
subprocess_cmd('mkdir fastqs bams; mv *.fastq ./fastqs; mv *sorted* ./bams; rm -f *.sam; rm -f *.bam',"../outputs")

#Pileup and pickle - runs python 2 script, pickles the dictionary outputs to /pickleJar
print("\nPython Presently Piping Pileups to Pickles, Procedure Pending...\n")
subprocess_cmd('./pysam_test.py','.')

#Report - builds report from pickJar contents
print ("\n\nWriting Report...\n")
#Code file dict links samp to mold color
with open("../inputs/harrington_clinical_data.txt", 'r') as codeFile:
    sumCodes = {}
    for line in codeFile:
        line = line.split()
        if not line:
            continue
        sumCodes[line[0]] = line[1]

#Store ref to pull wild type by sequence
with open('../inputs/dgorgon_reference.fa', 'r') as file:
    ref = file.read().replace('>Dgorgon', '').strip('\n')

#For looping through pickles
picks = os.listdir("../pickleJar")
#Holds report outputs for mold and samps
moldList = []
sampList = []

#Keep track of person from pickle file name, sequence location by pickle dict key i
for pick in picks:
    pickPerson = re.sub('_.*$', '', pick)
    dict = pickle.load( open( "../pickleJar/"+pick, "rb" ) )
    for i in list(dict.keys()):
        curRef = ref[i] #base at seq in ref
        counts = Counter(dict[i]) #Pull counts of unique list elements
        if(len(counts.keys()) > 1): #if not 100%
            bases = list(counts.keys())
            mutBase = ''.join([x for x in bases if x not in curRef]) #Remove the wild type
            #append summary lines to lists
            moldList.append("The {} mold was caused by a mutation in position {}. The wild type base was {} and the mutation was {}\n\n".format(sumCodes[pickPerson].lower(),i,curRef,mutBase))
            sampList.append("Sample {} had a {} mold, {} reads, and {}% of the reads at position {} had the mutation {}\n\n".format(pickPerson, sumCodes[pickPerson].lower(), len(dict[i]), round(counts[mutBase]/len(dict[i]) * 100), i, mutBase))

#Format and write report
f = open('../outputs/report.txt', 'w')   
f.write("#####Mold Summary###################\n\n")        
for line1 in list(set(moldList)):
    f.write(line1)
f.write("#####Sample Summary###################\n\n")
for line2 in sampList:
    f.write(line2)
f.close()            
            
print("\n\nDone\n")

