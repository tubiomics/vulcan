include { MEGAHIT_ASSEMBLY } from '../modules/megahit/assemble.nf'
include { SEQKIT_REPLACE } from '../modules/seqkit/replace.nf'
include { SEQTK_FILTER } from '../modules/seqtk/filter.nf'
include { CLUSTER_SIMILAR_PROTEINS } from '../modules/cdhit/cluster_similar_proteins.nf'
include { AMOS } from '../modules/amos/amos.nf'

workflow ASSEMBLY {

  take:
    reads   // channel: [ val(sample), [ reads ] ]
    max_sequences  // string : integer drop sequences with length shorter than INT

  main:
    MEGAHIT_ASSEMBLY(reads)
    ch_sample = MEGAHIT_ASSEMBLY.out.sample
    SEQKIT_REPLACE(ch_sample, MEGAHIT_ASSEMBLY.out.contigs_fa)
    SEQTK_FILTER(SEQKIT_REPLACE.out.contigs_replaced, ch_sample, max_sequences)
    CLUSTER_SIMILAR_PROTEINS(SEQTK_FILTER.out.filtered_contigs, ch_sample, max_sequences)
    AMOS(CLUSTER_SIMILAR_PROTEINS.out.clustered_contigs, ch_sample)

  emit:
    sample = MEGAHIT_ASSEMBLY.out.sample
    megahit_logs = MEGAHIT_ASSEMBLY.out.log

}