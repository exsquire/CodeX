# -*- coding: utf-8 -*-
"""
Created on Mon Jan 20 07:21:04 2020

@author: excel.que
Implementing a simple DNA to protein in silico translator. 
"""


import re
import random
import pprint
#Generate random 200bp DNA sequence
def genDNA(size = 200, chars = 'ATGC'):
    return ''.join(random.choice(chars) for x in range(size))

random.seed(1337)
genDNA()

#Turn DNA to RNA by replacing 'T' with 'U'
def DNAtoRNA(DNA):
    return re.sub("T","U",DNA)


#Build codon dictionary - use a many to one style conversion
codons = {
        ("UUU", "UUC"):"F",
        ("UCU", "UCC", "UCA", "UCG", "AGU","AGC"):"S",
        ("UAU", "UAC"):"Y",
        ("UGU", "UGC"):"C",
        ("AUG",):"M",
        ("UGG",):"W",
        ("UUA","UUG","CUU","CUC","CUA","CUG"):"L",
        ("AUU","AUC","AUA"):"I",
        ("GUU","GUC","GUA","GUG"):"V",
        ("CCU","CCC","CCA","CCG"):"P",
        ("ACU","ACC","ACA","ACG"):"T",
        ("GCU","GCC","GCA","GCG"):"A",
        ("UAA","UAG","UGA"):"STOP",
        ("CAU","CAC"):"H",
        ("CAA","CAG"):"Q",
        ("AAU","AAC"):"N",
        ("AAA","AAG"):"K",
        ("CGU","CGC","CGA","CGG","AGA","AGG"):"R",
        ("GGU","GGC","GGA","GGG"):"G",
        ("GAU","GAC"):"D",
        ("GAA","GAG"):"E"
        }

codeDict = {}
for k, v in codons.items():
    for key in k:
        codeDict[key] = v

#Check it out        
pprint.pprint(codeDict)
        
#Unit test function
#Generate one random DNA sequence, 200.bp
seq=genDNA()
RNA=DNAtoRNA(seq)
#Locate and cut everything up til the first start codon AUG
def getStart(seq, quiet = True):
    tmp=re.search("AUG", seq)
    if tmp is None:
        if quiet == False:
            print("No start codon detected.")
            print(seq)
        return False 
    #From the start codon, trim to runs of 3 bases  
    else:
        frameStart = seq[tmp.span(0)[0]:]
        if len(frameStart) % 3 != 0:
            return frameStart[:-(len(frameStart) % 3)]
        else:
            return frameStart

#Locate the first stop codon and trim from the end
def cutStop(seq, stops = ("UAA","UAG","UGA"), quiet = True):
    #Make multimatch pattern
    stopCodes=re.compile('|'.join(stops))
    #Search sequence for first match, exclude start codon
    match=stopCodes.search(seq[3:])    
    #Return sequence from start to first match's end
    if match is None:
        if quiet == False:
            print("No stop codon detected.")
            print(seq)
        return None
    else:
        if (match.span(0)[1]+3) % 3 == 0:
            return seq[:match.span(0)[1]+3]
        else:
            if quiet == False:
                print("No stop codon detected.")
                print(seq)
            return None
    
#Get the open reading frame
def findFrame(seq):
    RNA = DNAtoRNA(seq)
    if getStart(RNA):
        return cutStop(getStart(RNA))
    else:
        return None
    
frame=findFrame(genDNA())    

#Compile list of patent reading frames
patentORF = []
while len(patentORF) != 10:
    frame = findFrame(genDNA(size = 200))
    if frame != None:
        patentORF.append(frame)

#List comprehend sequence and match to codon dictionary
def translate(orf):
    indCodon = [(orf[i:i+3]) for i in range(0, len(orf), 3)] 
    amino = [codeDict[indCodon[i]] for i in range(0, len(indCodon))]
    return "".join(amino[:-1])


results = [translate(patentORF[i]) for i in range(0,len(patentORF))]









