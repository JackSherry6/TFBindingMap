#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    tuple val(sample), path(bed)
    path(ref)

    output:
    path("${sample}_motifs")

    script:
    """
    findMotifsGenome.pl $bed $ref ${sample}_motifs -size 200
    """
    //size 200 is just what I saw on an example on nf-core

    stub:
    """
    mkdir motifs
    """
}


