rule trim:
    input:
        r1 = get_r1,
        r2 = get_r2
    output:
        r1_paired = temp("../results/trimmed/{sample}_R1_trimmed_paired.fq.gz"),
        r1_unpaired = temp("../results/trimmed/{sample}_R1_trimmed_un.fq.gz"),
        r2_paired = temp("../results/trimmed/{sample}_R2_trimmed_paired.fq.gz"),
        r2_unpaired = temp("../results/trimmed/{sample}_R2_trimmed_un.fq.gz")
    log:
        "logs/trim/{sample}.log"
    conda:
        "../envs/trim.yaml"
    params:
        threads = config["trimmomatic"]["threads"],
        other = config["trimmomatic"]["other"]
    shell:
        '''
        trimmomatic PE -threads {params.threads} \
        {input.r1} {input.r2} \
        {output.r1_paired} {output.r1_unpaired} {output.r2_paired} {output.r2_unpaired} \
        {params.other}
        '''