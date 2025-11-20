#!/usr/bin/env nextflow

process POS2BED {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'

    input:
    tuple val(sample), path(peaks)

    output:
    tuple val(sample), path("${sample}.bed")

    script:
    """
    pos2bed.pl $peaks > ${sample}.bed
    """

    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
}


