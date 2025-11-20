#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("${bam.baseName}.sorted.bam")

    script:
    """
    samtools sort -@ $task.cpus $bam > ${bam.baseName}.sorted.bam
    """

    stub:
    """
    touch ${sample_id}.stub.sorted.bam
    """
}