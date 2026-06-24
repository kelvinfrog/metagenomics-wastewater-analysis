#!/bin/bash

# Your 10 downloaded SRR numbers
SRR_LIST=("SRR18341039" "SRR19607228" "SRR18341028" "SRR19607206" "SRR18341017" "SRR19606954" "SRR18340978" "SRR19606932" "SRR18341080" "SRR19606889") 

for SRR in "${SRR_LIST[@]}"; do
    echo "Running QC on $SRR..."
    
    fastp -i ${SRR}_1_sub.fastq -I ${SRR}_2_sub.fastq \
          -o ${SRR}_1_clean.fastq -O ${SRR}_2_clean.fastq \
          -h ${SRR}_fastp.html -j ${SRR}_fastp.json
          
    echo "Finished QC for $SRR!"
done

echo "All 10 samples cleaned and ready for host filtering."
