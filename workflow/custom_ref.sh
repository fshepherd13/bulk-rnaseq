#!/bin/bash

#Shown for creating a hybrid chicken genome
#I will run this code from the same directory as the Snakefile is in (in this pipeline, imagine we are standing in the workflow directory), so file paths are given relative to that directory.
#Create directory for custom index and cd into it
mkdir ../resources/chicken_iav_star_genome/
cd ../resources/chicken_iav_star_genome/

#Download host species genome and gtf annotation files from ensembl
wget http://ftp.ensembl.org/pub/release-105/fasta/gallus_gallus/dna/Gallus_gallus.GRCg6a.dna.toplevel.fa.gz 
wget http://ftp.ensembl.org/pub/release-105/gtf/gallus_gallus/Gallus_gallus.GRCg6a.105.gtf.gz

# uncompress files
gzip -d Gallus_gallus.GRCg6a.dna.toplevel.fa.gz
gzip -d Gallus_gallus.GRCg6a.105.gtf.gz

#Create a fasta file containing additional sequences you want to append to the reference genome. Also create files in gtf format of the annotations for the additional sequences. Upload these to the same directory. Directory now contains something like the following:
# Gallus_gallus.GRCg6a.dna.toplevel.fa
# Gallus_gallus.GRCg6a.105.gtf
# IAV.fa
# IAV.gtf

#Next, concatenate the fasta files together:
cat *.fa > ./gallus_iav_hybrid.fasta

#Concatenate the gtf annotation files together:
cat *.gtf > ./gallus_iav_hybrid.gtf

#And finally use star to index the genome:
STAR --runThreadN 16 \
--runMode genomeGenerate \
--genomeDir ./ \
--genomeFastaFiles ./gallus_iav_hybrid.fasta \
--sjdbGTFfile ./gallus_iav_hybrid.gtf \
--sjdbOverhang 149

#Now you have your indexed hybrid genome. Add the file path that points to this index into your config.yaml file. For this example, I would add the relative path "../resources/chicken_iav_star_genome/" to the config.yaml file in the "Parameters for custom index" section, under "index:".