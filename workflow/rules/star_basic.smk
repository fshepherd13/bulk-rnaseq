rule star:
    input:
        fq1 = rules.trim.output.r1_paired,
        fq2 = rules.trim.output.r2_paired,
        index = rules.star_index.output
    params:
        outdir = '../results/star/{sample}'
    output:
        bam = '../results/star/{sample}/{sample}_Aligned.sortedByCoord.out.bam'
    log:
        "logs/star/{sample}.log"
    conda:
        "../envs/star.yaml"
    threads:
        16
    shell:
        """
        STAR --runThreadN {threads} \
            --genomeDir {input.index} \
            --readFilesIn {input.fq1} {input.fq2} \
            --outSAMtype BAM SortedByCoordinate \
            --outReadsUnmapped Fastx \
            --readFilesCommand zcat \
            --outFileNamePrefix {params.outdir}/{wildcards.sample}_ &> {log}
        
        rm -rf '../results/star/*/*_STARtmp'
        """