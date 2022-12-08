include { SEQKIT_REPLACE } from '../modules/seqkit/replace.nf'
include { SEQTK_FILTER } from '../modules/seqtk/filter.nf'
include { CLUSTER_SIMILAR_PROTEINS } from '../modules/cdhit/cluster_similar_proteins.nf'
include { AMOS } from '../modules/amos/amos.nf'
include { MINIMUS } from '../modules/amos/minimus.nf'
include { CONCATENTATE_MINIMUS_FILES } from '../modules/amos/concatenate.nf'
include { COUNT_READS } from '../modules/seqkit/count_reads_single.nf'
include { INDEX_ASSEMBLY } from '../modules/bwa-mem2/index.nf'

workflow POST_ASSEMBLY_PROCESSING {

  take:
    contigs          // channel: /path/to/contigs.fa
    sample           // channel: val(sample)
    max_sequences    // string : integer drop sequences with length shorter than INT

  main:
    SEQKIT_REPLACE(sample, contigs)
    SEQTK_FILTER(SEQKIT_REPLACE.out.contigs_replaced, sample, max_sequences)
    CLUSTER_SIMILAR_PROTEINS(SEQTK_FILTER.out.filtered_contigs, sample, max_sequences)
    AMOS(CLUSTER_SIMILAR_PROTEINS.out.clustered_contigs, sample)
    MINIMUS(AMOS.out.amos_contigs, sample)
    CONCATENTATE_MINIMUS_FILES(MINIMUS.out.fasta, MINIMUS.out.singletons, sample)
    COUNT_READS(CONCATENTATE_MINIMUS_FILES.out.fasta, sample)
    INDEX_ASSEMBLY(CONCATENTATE_MINIMUS_FILES.out.fasta, sample)
    
  emit:
    stats = COUNT_READS.out.stats                              //channel: /path/to/seqkit/count/reads.txt
    index_directory = INDEX_ASSEMBLY.out.index_directory       //channel: /path/to/index/directory
    contigs = CONCATENTATE_MINIMUS_FILES.out.fasta             //channel: /path/to/concat/fasta/singletons/file
}