pipeline.py is run out of the scripts folder
Reference fa, clinical data, and pooled sequences fastq must be in the input folder
Must have ./pickleJar to hold intermediates
All outputs appear in the outputs folder

To Run:
./pipeline.py

Function:
-Demultiplexes pooled fastq, removes barcode, trims poor quality reads
-Subprocess to terminal
    - bwa and samtools
        -index reference
        -align trimmed fastqs to reference -> sam
        -convert sam to bam
        -sort bam and index
        -.fastq and .sorted.bam + indicies to own folders
-Discover variants with pysam in python2 - pickle out dictionaries for python3 processing
-Create report of mold and sample
