# bulk-rnaseq

Pipeline for analyzing short-read bulk RNAseq data from Illumina sequencing runs.

## Overview
Bulk RNAseq reads are analyzed in the following steps:
1. Reads are trimmed of adapter sequences and low-quality reads using [Trimmomatic](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf).
2. Trimmed reads are mapped to a reference genome using [STAR](https://github.com/alexdobin/STAR).
3. Reads per feature are quantified using [HTSeq](https://htseq.readthedocs.io/en/master/). 
4. Differential expression is performed using [DESeq2](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html).

## How to run
Pipeline runs using snakemake. First, install snakemake. I use a standalone snakemake environment installed using mamba in the following way:
```
module load mamba #on MSI
mamba create -c conda-forge -c bioconda -n snakemake snakemake
```

To run the pipeline, first run the command `conda activate snakemake`. This will activate the snakemake software. All other software dependencies are loaded within the snakemake pipeline as standalone environments. See the yaml files under `workflow/envs`.

Next, update the files under `config/` to match your experiment. The config.yaml file should be updated to specify file paths to the raw reads. There are other parameters that can be adjusted for the trimming step and for STAR, to choose the reference species of choice. 

To run the full pipeline from your command line, run `snakemake --cores 32 --use-conda`. 

If you have multiple reference species to map to, right now the best way to approach is to run the pipeline twice. The first run, only specify the samples in the sample.csv file that should be mapped to the given species. Make sure your `config.yaml` file contains the correct species under the references section. Then, re-write your samples.csv file to specify only the remaining files that should be mapped to the 2nd reference species. Update the `config.yaml` file to contain the correct reference specices and run the pipeline again.