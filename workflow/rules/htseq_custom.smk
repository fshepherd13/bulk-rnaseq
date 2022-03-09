rule htseq_custom:
    input:
        '../results/star/{sample}/{sample}_Aligned.sortedByCoord.out.bam'
    params:
        gtf=config["gtf"]
    output:
        "../results/htseq/{sample}_counts.tsv"
    log:
        "logs/htseq/{sample}.log"
    conda:
        "../envs/htseq.yaml"
    shell:
        '''
        htseq-count {input} {params.gtf} -f bam -r pos -c {output} &> {log}
        '''
        