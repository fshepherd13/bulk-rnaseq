# bulk-rnaseq

Pipeline for analyzing short-read bulk RNAseq data from Illumina sequencing runs.

## Overview
Bulk RNAseq reads are analyzed in the following steps:
1. Reads are trimmed of adapter sequences and low-quality reads using [Trimmomatic](http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf).
2. Trimmed reads are mapped to a reference genome using [STAR](https://github.com/alexdobin/STAR).
3. Reads per feature are quantified using [HTSeq](https://htseq.readthedocs.io/en/master/). 
4. Differential expression is performed using [DESeq2](http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html).

## How to run
### Setup
Pipeline runs using snakemake. First, install snakemake. I use a standalone snakemake environment installed using mamba in the following way:
```
module load mamba #on MSI
mamba create -c conda-forge -c bioconda -n snakemake snakemake
```

To run the pipeline on MSI, first run the command `source activate snakemake`. This will activate the snakemake software. All other software dependencies are loaded within the snakemake pipeline as standalone environments. See the yaml files under `workflow/envs`.

Next, update the files under `config/` to match your experiment. The config.yaml file should be updated to specify file paths to the raw reads. There are other parameters that can be adjusted for the trimming step and for STAR, to choose the reference species of choice. 

Also update the .csv file under `config/` to list your samples. Each column represents metadata related to your experiment and can be modified as needed. The one column name that must be in the .csv file is "sample_id". The name of this column should not be changed. The sample_id will contain the names you gave to the sequencing core, not the full fastq.gz file names that are returned after sequencing is complete. All other variables can be named whatever match your experimental design, but include variables that you want to use in your differential expression analysis. 

### A note on reference genomes
STAR requires an indexed reference genome to run correctly. If your analysis requires a standard reference genome from Ensembl, this pipeline can create it for you by automatically downloading the fasta and gtf files for the species of interest and creating a STAR index from those files. To do this, un-hash the lines in the config.yaml file under the "parameters for 'normal' genome indices" section and edit the file to contain the information on species name and genome build of choice.  

If your analysis requires a more complex genome (such as a host genome + virus hybrid genome, applicable in experiments where a viral infection is being used), this will need to be manually created. First, follow the script within custom_ref.sh to create the index. Then go to the config.yaml file and un-hash the lines under the "Parameters for custom genome indices". Finally, update the `index` file path in the config.yaml file to point to the index you created. 


### Running the pipeline
To run the full pipeline from your command line, run `snakemake --cores 32 --use-conda`. Or, submit the `pipeline.sh` bash script to the MSI slurm scheduler by entering the workflow directory and running `sbatch pipeline.sh` from the terminal. The #SBATCH commands in the pipeline.sh script are suggested options and should be edited to fit the needs of your analysis (large datasets could require more memory or time, etc.). 

If you have multiple reference species to map to, right now the best way to approach is to run the pipeline twice. The first run, only specify the samples in the sample.csv file that should be mapped to the given species. Make sure your `config.yaml` file contains the correct species under the references section. Then, re-write your samples.csv file to specify only the remaining files that should be mapped to the 2nd reference species. Update the `config.yaml` file to contain the correct reference specices and run the pipeline again.