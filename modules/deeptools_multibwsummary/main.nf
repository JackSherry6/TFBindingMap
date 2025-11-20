#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'

    input:
    path(bws)

    output:
    path("bw_all.npz"), emit: npz
    path("bw_all.tab"), emit: tab

    script:
    """
    multiBigwigSummary bins \
        --bwfiles ${bws.join(' ')} \
        --outFileName bw_all.npz \
        --outRawCounts bw_all.tab
    """
    //bin size is 10,000 by default, could change it to 1000 potentially


    stub:
    """
    touch bw_all.npz
    """
}