#!/bin/bash

REF=inputs/GRCm38_68.fa
GTF=inputs/Mus_musculus.GRCm38.68.gtf
INDELS=inputs/mgp.v3.indels.rsIDdbSNPv137.vcf.gz
SNPS=inputs/mgp.v3.snps.rsIDdbSNPv137.vcf.gz

STRAINS="AJ 129S1 NODShiLtJ NZOHlLtJ C57BL6NJ CASTEiJ PWKPhJ WSBEiJ"

for STRAIN in $STRAINS
do
    #Make strain directory if non-existant
    echo -e "Founder Strain: $STRAIN\n"
    if [ ! -d $STRAIN ]; then
        mkdir $STRAIN
    fi    
 
    #Do we need to convert to VCI first? 
    #g2gtools vcf2vci -o ${STRAIN}.vci -s ${STRAIN} --diploid -p 8 -i ${SNPS}

    echo -e "Creating chain file...\n"

    #1. Use g2gtools to create chain files for each strain in appropriate folder
    #g2gtools vcf2chain -f ${REF} -i ${INDELS} -s ${STRAIN} -o ${STRAIN}/REF-to-${STRAIN}.chain 
    
    echo -e "Patching SNPs into reference genome...\n"

    #2. Patch SNPs into the reference genome
    g2gtools patch -i ${REF} -s ${STRAIN} -v ${SNPS} -o ${STRAIN}/${STRAIN}.patched.fa

    #echo -e "Incorporating indels onto snp-patched genome...\n"

    #3. Incorporate indels onto snp-patched genome
    #g2gtools transform -i ${STRAIN}/${STRAIN}.patched.fa -c ${STRAIN}/REF-to-${STRAIN}.chain -o ${STRAIN}/${STRAIN}.fa

    #echo -e "Create custom gene annotation...\n"

    #4. Create custom gene annotation 
    #g2gtools convert -c ${STRAIN}/REF-to-${STRAIN}.chain -i ${GTF} -f gtf -o ${STRAIN}/${STRAIN}.gtf
    
    #echo -e "Build database from custom annotation...\n"

    #5. Build database from custom gene annotation
    #g2gtools gtf2db -i ${STRAIN}/${STRAIN}.gtf -o ${STRAIN}/${STRAIN}.gtf.db

    #echo -e "Extract strain-specific transcriptome from database...\n"

    #6. Extract strain-specific transcriptome
    #g2gtools extract --transcripts -i ${STRAIN}/${STRAIN}.fa -db ${STRAIN}/${STRAIN}.gtf.db > ${STRAIN}/${STRAIN}.transcripts.fa

done

