include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIQC} from './modules/multiqc'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'

workflow {
    
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)

    BOWTIE2_BUILD(params.genome)

    TRIM(read_ch, params.adapter_fa) 

    BOWTIE2_ALIGN(TRIM.out.fq, BOWTIE2_BUILD.out.index, BOWTIE2_BUILD.out.name)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)

    SAMTOOLS_IDX(SAMTOOLS_SORT.out)

    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out)

    BAMCOVERAGE(SAMTOOLS_IDX.out)

    multiqc_ch = FASTQC.out.zip
        .mix(TRIM.out.log)
        .map {it[1]}
        .mix(SAMTOOLS_FLAGSTAT.out)
        .collect()

    MULTIQC(multiqc_ch)

    all_bws_ch = BAMCOVERAGE.out
        .map {it[1]}
        .collect()

    MULTIBWSUMMARY(all_bws_ch)

    bw_matrix_ch = BAMCOVERAGE.out
        .filter { sample_id, file_path -> sample_id.startsWith('IP_rep') }

    COMPUTEMATRIX(bw_matrix_ch, params.ucsc_genes, params.window)

    PLOTCORRELATION(MULTIBWSUMMARY.out.npz, params.corrtype)

    PLOTPROFILE(COMPUTEMATRIX.out)

    TAGDIR(BOWTIE2_ALIGN.out)

    FINDPEAKS(TAGDIR.out)

    POS2BED(FINDPEAKS.out)

    intersect_ch = POS2BED.out
        .map { name, path -> tuple(name.replaceAll(/_rep\d+$/, ''), path) }
        .groupTuple(by: 0)
    

    BEDTOOLS_INTERSECT(intersect_ch)

    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out, params.blacklist)

    ANNOTATE(BEDTOOLS_REMOVE.out, params.genome, params.gtf)

    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out, params.genome)

}

