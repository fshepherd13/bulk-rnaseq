library('DESeq2')
library('dplyr')

#Read in directory where the htseq output files are located
directory <- snakemake@params[["indir"]]

#Read in model for deseq2, as designated in the config.yaml file
model <- snakemake@params[["model"]]

#Construct dataframe that connects the htseq count file name with the metadata in the config file
#Read in metadata from the config file
meta <- read.csv(snakemake@params[["metadata"]], header=TRUE) %>%
    mutate(filename=paste(sample_id,"_counts.tsv",sep="")) %>% #Add row that indicates what the corresponding htseq file is called
    select(filename, everything()) %>% #Next two lines reorder the dataframe so that the sample_id column is first, followed by the newly created filename variable, followed by all the other columns
    select(sample_id, everything())

dds <- DESeqDataSetFromHTSeqCount(sampleTable = meta,
                                       directory = directory,
                                       design=as.formula(model))

#Save DESEQ data set to an R file
saveRDS(dds, file = snakemake@output[[1]])