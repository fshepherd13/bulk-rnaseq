rule get_genome:
    output:
        config["genome"]["outdir"]+"/"+config["genome"]["species"]+"/genome.fasta"
    params:
        species=config["genome"]["species"],
        build=config["genome"]["build"],
        release=config["genome"]["release"],
        datatype=config["genome"]["datatype"]
    log:
        "logs/get_genome.log"
    cache: True  # save space and time with between workflow caching (see docs)
    wrapper:
        "0.84.0/bio/reference/ensembl-sequence"

rule get_gtf:
    output:
        config["genome"]["outdir"]+"/"+config["genome"]["species"]+"/genome.gtf"
    params:
        species=config["genome"]["species"],
        build=config["genome"]["build"],
        release=config["genome"]["release"],
        fmt="gtf",
        flavor=""
    log:
        "logs/get_gtf.log"
    cache: True  # save space and time with between workflow caching (see docs)
    wrapper:
        "0.84.0/bio/reference/ensembl-annotation"

rule star_index:
    input:
        fasta = config["genome"]["outdir"]+"/"+config["genome"]["species"]+"/genome.fasta",
        gtf = config["genome"]["outdir"]+"/"+config["genome"]["species"]+"/genome.gtf"
    output:
        directory(config["genome"]["outdir"]+"/"+config["genome"]["species"]+"/index")
    message:
        "Testing STAR index"
    threads: 16
    conda:
        "../envs/star.yaml"
    log:
        "logs/star_index.log"
    shell:
        """
        STAR \
            --runMode genomeGenerate \
            --runThreadN {threads} \
            --genomeDir {output} \
            --genomeFastaFiles {input.fasta} \
            --sjdbGTFfile {input.gtf} \
            --sjdbOverhang 150
        """
