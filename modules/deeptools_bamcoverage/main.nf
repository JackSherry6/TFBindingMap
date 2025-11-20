#!/usr/bin/env nextflow

process BAMCOVERAGE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'

    input:
    tuple val(sample), path(bam), path(bai)

    output:
    tuple val(sample), path("${sample}.bw")

    script:
    """
    bamCoverage -b $bam -o ${sample}.bw
    """
    // may change -bs which is bin size (default is 50), and -p which is processor number (default is 1)

    stub:
    """
    touch ${sample_id}.bw
    """
}