library('DESeq2')
library('dplyr')

#Read in directory where the htseq output files are located
directory <- snakemake@params[["indir"]]

#Read in model for deseq2, as designated in the config.yaml file
model <- snakemake@params[["model"]]

#Construct dataframe that connects the htseq count file name with the metadata in the config file
#Read in metadata from the config file
meta <- read.csv(snakemake@params[["metadata"]], header=TRUE) %>%
    mutate(filename=paste(sample_id,"_counts.tsv",sep="")) #Add row that indicates what the corresponding htseq file is called

meta <- meta[, c("sample_id", "filename", "cell_type", "species", "ifn_treatment", "timepoint")]

dds <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                                       directory = directory,
                                       design=as.formula(model))

#Remove columns with low feature counts (i.e uninformative columns)
dds <- dds[ rowSums(counts(dds)) >= 10, ]

#Perform normalization and differential expression analysis
dds <- DESeq(dds)

#Write RDS object
saveRDS(dds, file=snakemake@output[[1]])
# Write normalized counts
norm_counts = counts(dds, normalized=T)
write.table(data.frame("gene"=rownames(norm_counts), norm_counts), file=snakemake@output[[2]], sep='\t', row.names=F)