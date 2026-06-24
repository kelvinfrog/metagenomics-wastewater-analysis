#!/bin/bash

# Your 10 SRR numbers
SRR_LIST=("SRR18341039" "SRR19607228" "SRR18341028" "SRR19607206" "SRR18341017" "SRR19606954" "SRR18340978" "SRR19606932" "SRR18341080" "SRR19606889") 

DB_PATH="kraken_viral_db"

for SRR in "${SRR_LIST[@]}"; do
    echo "Processing taxonomy for $SRR..."
    
    # 1. Run Kraken2 to classify reads
    # We use --paired, point to the viral database, and generate a report file.
    kraken2 --db $DB_PATH --paired --threads 4 \
            --output ${SRR}_kraken.out \
            --report ${SRR}_kraken.report \
            ${SRR}_host_removed_1.fastq ${SRR}_host_removed_2.fastq
            
    echo "Running Bracken re-estimation for $SRR..."
    
    # 2. Run Bracken to get accurate species-level relative abundance
    # -l S specifies estimation at the Species level
    # -r 100 matches post-QC mean read length (~90 bp; closest available kmer distrib is 100)
    ./Bracken/bracken -d $DB_PATH \
            -i ${SRR}_kraken.report \
            -o ${SRR}_bracken_species.out \
            -l S -r 100
            
    echo "Finished taxonomy for $SRR!"
done

echo "Taxonomy profiling complete. Abundance tables generated."
