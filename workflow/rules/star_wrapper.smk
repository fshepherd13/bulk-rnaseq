
rule star_pe_multi:
    input:
        fq1 = get_r1,
        # paired end reads needs to be ordered so each item in the two lists match
        fq2 = get_r2
    output:
        # see STAR manual for additional output files
        '../results/star/{sample}/{sample}_Aligned.sortedByCoord.out.bam'
    log:
        "logs/star/pe/{sample}.log"
    params:
        # path to STAR reference genome index
        index=directory(config["genome"]["outdir"]+"/"+config["genome"]["species"]),
        # optional parameters
        extra="--outSAMtype BAM --outReadsUnmapped Fastx"
    threads: 8
    wrapper:
        "0.84.0/bio/star/align"