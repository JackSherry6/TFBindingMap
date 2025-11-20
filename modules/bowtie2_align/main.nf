#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'

    input:
    tuple val(sample), path(read)
    path bt2
    val name

    output:
    tuple val(sample), path('*bam')

    script:
    """
    bowtie2 -x ${bt2}/${name} -U ${read} | samtools view -bS - > ${sample}.bam
    """

    stub:
    """
    touch ${sample_id}.bam
    """
}