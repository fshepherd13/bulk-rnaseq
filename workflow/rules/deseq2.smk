rule deseq2:
    input:
        expand("../results/htseq/{sample}_counts.tsv", sample=SAMPLES)
    output:
        "../results/deseq2/dds.rds"
    params:
        indir="../results/htseq",
        metadata=config["sample_file"],
        model=config["deseq"]["model"]
    conda:
        "../envs/deseq2.yaml"
    script:
        "../scripts/deseq2.R"