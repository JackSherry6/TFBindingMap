#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'

    input:
    tuple val(sample), path(bam)

    output:
    path("${sample}.flagstat.txt")

    script:
    """
    samtools flagstat $bam > ${sample}.flagstat.txt
    """

    stub:
    """
    touch ${sample_id}_flagstat.txt
    """
}