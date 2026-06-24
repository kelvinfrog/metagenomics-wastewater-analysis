# Wastewater Metatranscriptomics: End-to-End Analysis

An end-to-end metatranscriptomic analysis of paired wastewater samples (enriched vs. unenriched) based on **Rothman et al. 2021** (*Applied and Environmental Microbiology*). Ten samples spanning five consecutive timepoints (Oct 5 – Nov 2, 2020) from the Encina Water Pollution Control Facility in Carlsbad, California were analysed.

## Analysis Overview

| Step | Script | Tool |
|------|--------|------|
| Download & downsample | `download_data.sh` | `fasterq-dump`, `seqtk` |
| Quality control | `run_qc.sh` | `fastp` |
| Host filtering | `run_host_filter.sh` | `bowtie2` vs GRCh38 |
| Taxonomy | `run_taxonomy.sh` | `kraken2`, `bracken` |
| Variant calling | `run_variant_calling.sh` | `bowtie2`, `bcftools` |
| Visualisation & report | `analysis.Rmd` | R (`ggplot2`, `plotly`) |

## Deliverables

- **`analysis.Rmd`** — Runnable R Markdown notebook with all analysis steps, plots, and multiple choice questions
- **`analysis.html`** — Static HTML report

## Requirements

### Command-line tools
- `fasterq-dump` (SRA Toolkit)
- `seqtk`
- `fastp`
- `bowtie2`
- `samtools`
- `kraken2`
- `bracken` (or use `./Bracken/bracken` if built from source)
- `bcftools`

### R packages
```r
install.packages(c("dplyr", "ggplot2", "tidyr", "jsonlite",
                   "knitr", "kableExtra", "plotly"))
```

## How to Reproduce

1. **Download and downsample raw data:**
```bash
bash download_data.sh
```

2. **Run QC:**
```bash
bash run_qc.sh
```

3. **Host filtering** (requires GRCh38 bowtie2 index):
```bash
bash run_host_filter.sh
```

4. **Taxonomy** (requires viral Kraken2 database in `kraken_viral_db/`):
```bash
bash run_taxonomy.sh
```

5. **Variant calling** (enriched samples only):
```bash
bash run_variant_calling.sh
```

6. **Render the notebook:**
```r
rmarkdown::render("analysis.Rmd")
```

## Data

Raw FASTQ files are not included due to size. Download using `download_data.sh` (requires SRA Toolkit).

Small output files needed to render the notebook without rerunning the full pipeline are included:
- `*_fastp.json` — QC metrics
- `*_kraken.report` — Kraken2 classification reports
- `*_bracken_species.out` — Bracken species-level abundance estimates
- `variant_summary.csv` — Filtered SARS-CoV-2 variant calls
- `SraRunTable.csv` — NCBI sample metadata

## Reference

Rothman, J.A., et al. (2021). Quantitative SARS-CoV-2 Alpha Variant B.1.1.7 Tracking in Wastewater by Allele-Specific RT-qPCR. *Applied and Environmental Microbiology*, 87(21). https://doi.org/10.1128/aem.01448-21
