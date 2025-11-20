#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'

    input:
    tuple val(sample), path(bw)
    path genes_bedfile
    val window

    output:
    tuple val(sample), path("${sample}_matrix.gz")

    script:
    """
    computeMatrix scale-regions \
        -S ${bw} \
        -R ${genes_bedfile} \
        --beforeRegionStartLength ${window} \
        --afterRegionStartLength ${window} \
        --skipZeros \
        --missingDataAsZero \
        -o ${sample}_matrix.gz
    """
    //--missingDataAsZero fills gaps with zeros (so all bins have numeric values)
    //--skipZeros then drops regions that are entirely zero (meaning truly no signal anywhere)
    // I thought these two were counterintuitive at first

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}