#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(bed)
    path(blacklist)

    output:
    tuple val(sample), path("${sample}_removed.bed")

    script:
    """
    bedtools intersect -a $bed -b $blacklist -v > ${sample}_removed.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}