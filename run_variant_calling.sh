#!/bin/bash

# Array of your 5 enriched sample SRR IDs (replace with your actual SRR strings)
# e.g., SAMPLES=("SRR1234567" "SRR1234568" ...)
SAMPLES=("SRR19606889" "SRR19606932" "SRR19606954" "SRR19607206" "SRR19607228")

for SRR in "${SAMPLES[@]}"; do
    echo "Processing sample: ${SRR}"

    # 1. Align host-removed reads to the SARS-CoV-2 index
    bowtie2 -x sars_cov2_index \
            -1 ${SRR}_host_removed_1.fastq \
            -2 ${SRR}_host_removed_2.fastq \
            -S ${SRR}_sars2.sam \
            --local --very-sensitive-local --no-unal

    # 2. Convert SAM to sorted BAM, then index it
    samtools view -bS ${SRR}_sars2.sam | samtools sort -o ${SRR}_sars2_sorted.bam
    samtools index ${SRR}_sars2_sorted.bam

    # 3. Clean up the massive raw SAM file to save disk space
    rm ${SRR}_sars2.sam

    # 4. Generate genotype likelihoods (mpileup) and call variants (call)
    # -m: multi-allelic caller
    # -v: output variant sites only
    # --quantitative-specifiers: includes depth info (AD, DP) needed for proportions
    bcftools mpileup -f sars_cov2_ref.fasta ${SRR}_sars2_sorted.bam \
        -a FORMAT/AD,FORMAT/DP | \
    bcftools call -mv -Ob -o ${SRR}_variants.bcf

    # 5. Convert the compressed BCF to a human-readable VCF file
    bcftools view ${SRR}_variants.bcf > ${SRR}_variants.vcf

    echo "Finished variant calling for ${SRR} -> ${SRR}_variants.vcf"
done
