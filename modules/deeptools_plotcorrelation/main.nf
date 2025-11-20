#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_single'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: "copy"

    input:
    path(npz)
    val(corrtype)

    output:
    path("corr_heatmap.png")

    script:
    """
    plotCorrelation \
        -in $npz \
        --corMethod $corrtype \
        --whatToPlot heatmap \
        --plotTitle "Correlation of all samples" \
        -o corr_heatmap.png
    """
    // not using --removeOutliers \ --plotNumbers \ --skipZeros \ --outFileCorMatrix correlation_matrix.tab \

    stub:
    """
    touch correlation_plot.png
    """
}






