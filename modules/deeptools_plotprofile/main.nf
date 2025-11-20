#!/usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_single'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(matrix)

    output:
    path("${sample}_plotProfile.png")

    script:
    """
    plotProfile -m $matrix \
        -out ${sample}_plotProfile.png \
        --plotTitle "${sample} plot"
    """

    stub:
    """
    touch ${sample_id}_signal_coverage.png
    """
}