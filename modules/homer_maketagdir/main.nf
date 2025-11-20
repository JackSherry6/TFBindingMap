#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("${sample}_tagDir")

    script:
    """
    mkdir ${sample}_tagDir
    makeTagDirectory ${sample}_tagDir ${bam} \
        -tbp 2
    """
    //mkdir just makes an empty dir and the script doesn't fill it
    // tbp is tags per base, 1 keeps only unique positions (I read that 1=sharper peaks, 2=broader peaks, anything else is no go)
    // another source said 1 for TF chipseq, 2 for histone chipseq

    stub:
    """
    mkdir ${sample_id}_tags
    """
}


