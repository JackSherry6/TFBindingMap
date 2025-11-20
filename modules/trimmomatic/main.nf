#!/usr/bin/env nextflow

process TRIM {
    label 'process_medium'
    container 'ghcr.io/bf528/trimmomatic:latest'

    input:
    tuple val(sample), path(read)
    path adapters

    output:
    tuple val(sample), path("${sample}_trim_out.log"), emit: log
    tuple val(sample), path("${sample}_trimmed.fastq.gz"), emit: fq

    script:
    """
    trimmomatic SE \
    -threads ${task.cpus} \
    ${read} \
    ${sample}_trimmed.fastq.gz \
    ILLUMINACLIP:${adapters}:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
    2> ${sample}_trim_out.log
    """

    stub:
    """
    touch ${sample_id}_stub_trim.log
    touch ${sample_id}_stub_trimmed.fastq.gz
    """
}
