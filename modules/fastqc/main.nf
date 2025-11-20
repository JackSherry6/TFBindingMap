#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir "${params.outdir}/fastqc_results", mode: 'copy'

    input: 
    tuple val(sample), path(fastq)

    output:
    tuple val(sample), path("*_fastqc.zip"), emit: zip
    tuple val(sample), path("*_fastqc.html"), emit: html
    //Not sure if I'll need both downstream but better to be safe

    script:
    """
    fastqc -t $task.cpus $fastq
    """

    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """
}