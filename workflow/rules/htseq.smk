rule htseq:
    input:
        rules.star.output
    params:
        gtf=rules.get_gtf.output
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
        