#!/usr/bin/python
import pysam
import pickle
import re
import os,fnmatch

#Problem - I use Python3 and only have access to Windows computers - Could not get Pysam to run in IDE and check outputs within pipe
#Solution - subprocess the python 2 script from python 3 script - pickle outputs and build pickle manipulator in python 3

#Add path argument for loop call
def pileup(path):
    samfile = pysam.AlignmentFile(path, "rb")
    #file name for pickling
    desig = "../pickleJar/"+re.sub("^.*/|\..*$","",path)+"_dict.p"
    ntdict = {} #build dict to hold pileup data
    for pileupcolumn in samfile.pileup():
        pos = pileupcolumn.pos
        ntdict[pos] = []#pos is key for list
        for pileupread in pileupcolumn.pileups:
            if not pileupread.is_del and not pileupread.is_refskip:
                base = pileupread.alignment.query_sequence[pileupread.query_position]
                ntdict.setdefault(pos,[]).append(base)#append bases to list
    pickle.dump( ntdict, open (desig, "wb") ) #pickle it
    samfile.close()
#Loop through contents of bams folder - if sorted.bam file, run pileup on path to file
files = os.listdir("../outputs/bams")
pattern = "*sorted.bam"
for entry in files:
    if fnmatch.fnmatch(entry, pattern):
        run = "../outputs/bams/"+entry
        pileup(run)



















