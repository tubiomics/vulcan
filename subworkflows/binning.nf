include { INDEX_ASSEMBLY } from '../modules/bwa-mem2/mem.nf'
include { SAMTOOLS_VIEW } from '../modules/samtools/view.nf'
include { SAMTOOLS_SORT } from '../modules/samtools/sort.nf'
include { SAMTOOLS_INDEX } from '../modules/samtools/index.nf'
include { SAMTOOLS_FLAGSTAT } from '../modules/samtools/flagstat.nf'

workflow SAM_BINNING {
  take:
    reads        // channel: [ val(sample), [ trimmed reads ] ]
    index_folder
    sample

  main:
    INDEX_ASSEMBLY(reads, index_folder)
    SAMTOOLS_VIEW( INDEX_ASSEMBLY.out.sam_file, sample)
    SAMTOOLS_SORT( SAMTOOLS_VIEW.out.bam_file, sample)
    SAMTOOLS_INDEX ( SAMTOOLS_SORT.out.sorted_bam_file, sample )
    SAMTOOLS_FLAGSTAT( SAMTOOLS_INDEX.out.bam_file, sample)
}