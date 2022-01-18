#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition=amdsmall
#SBATCH --ntasks=32
#SBATCH --time=0:45:00
#SBATCH --mail-type=ALL
#SBATCH --mem=50g
#SBATCH --mail-user= #User UMN email address


source activate snakemake
snakemake --cores 1 --unlock
snakemake --cores 32 --use-conda --rerun-incomplete