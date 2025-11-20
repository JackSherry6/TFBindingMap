#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path(bam), path("${bam}.bai")

    script:
    """
    samtools index ${bam}
    """

    stub:
    """
    touch ${sample_id}.stub.sorted.bam.bai
    """
}