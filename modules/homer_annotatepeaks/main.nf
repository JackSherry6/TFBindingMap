#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(bed)
    path(ref)
    path(gtf)

    output:
    path("${sample}_annotated.txt")

    script:
    """
    annotatePeaks.pl $bed $ref > ${sample}_annotated.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}



