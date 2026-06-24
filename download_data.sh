#!/bin/bash

# 1. Your selected SRR numbers for the 10 runs
SRR_LIST=("SRR18341039" "SRR19607228" "SRR18341028" "SRR19607206" "SRR18341017" "SRR19606954" "SRR18340978" "SRR19606932" "SRR18341080" "SRR19606889") 

# 2. Loop through each accession number
for SRR in "${SRR_LIST[@]}"; do
    echo "Downloading $SRR..."
    
    # Download the raw paired-end fastq files
    fasterq-dump --split-files $SRR
    
    echo "Downsampling $SRR to ~10M base pairs..."
    
    # Randomly sample 33,333 reads to hit the ~10M bps target
    seqtk sample -s100 ${SRR}_1.fastq 33333 > ${SRR}_1_sub.fastq
    seqtk sample -s100 ${SRR}_2.fastq 33333 > ${SRR}_2_sub.fastq
    
    echo "Cleaning up original massive files for $SRR..."
    rm ${SRR}_1.fastq ${SRR}_2.fastq
    
    echo "Finished $SRR!"
done

echo "All samples downloaded and downsampled successfully."
