#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'

    input:
    tuple val(sample), path(bed_reps)

    output:
    tuple val(sample), path("${sample}_intersected.bed")

    script:
    """
    bedtools intersect -a ${bed_reps[0]} -b ${bed_reps[1]} > ${sample}_intersected.bed
    """
    //does it matter which file is and a and which is b? -> if you just want regions common between files it shouldn't matter
    
    stub:
    """
    touch repr_peaks.bed
    """
}