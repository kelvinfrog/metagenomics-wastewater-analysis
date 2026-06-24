#!/bin/bash

# Your 10 SRR numbers
SRR_LIST=("SRR18341039" "SRR19607228" "SRR18341028" "SRR19607206" "SRR18341017" "SRR19606954" "SRR18340978" "SRR19606932" "SRR18341080" "SRR19606889") 

# 2. Loop through each clean file and filter out human reads
for SRR in "${SRR_LIST[@]}"; do
    echo "Filtering human reads from $SRR..."
    
    # Notice the -x flag is now just GRCh38_noalt_as (no folder slash)
    bowtie2 -p 4 -x GRCh38_noalt_as \
            -1 ${SRR}_1_clean.fastq -2 ${SRR}_2_clean.fastq \
            --un-conc ${SRR}_host_removed_%.fastq \
            > /dev/null
            
    echo "Finished host filtering for $SRR!"
done

echo "All samples successfully host-filtered. Ready for taxonomy profiling."
