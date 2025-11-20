#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    
    input:
    tuple val(sample), path(tagDir)

    output:
    tuple val(sample), path("${sample}_peaks.txt")
    
    script:
    """
    echo "Listing contents of ${tagDir}"
    ls -lh ${tagDir}
    findPeaks ${tagDir} \
        -style factor \
        -o ${sample}_peaks.txt
    """

    stub:
    """
    touch ${rep}_peaks.txt
    """
}


