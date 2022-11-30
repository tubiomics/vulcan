include { MEGAHIT_ASSEMBLY } from '../modules/megahit/assemble.nf'
include { SEQKIT_REPLACE } from '../modules/seqkit/replace.nf'
include { SEQTK_FILTER } from '../modules/seqtk/filter.nf'

workflow ASSEMBLY {

  take:
    reads   // channel: [ val(sample), [ reads ] ]
    max_sequences  // string : integer drop sequences with length shorter than INT

  main:
    MEGAHIT_ASSEMBLY(reads)
    ch_sample = MEGAHIT_ASSEMBLY.out.sample
    SEQKIT_REPLACE(ch_sample, MEGAHIT_ASSEMBLY.out.contigs_fa)
    SEQTK_FILTER(SEQKIT_REPLACE.out.contigs_replaced, ch_sample, max_sequences)

  emit:
    sample = MEGAHIT_ASSEMBLY.out.sample
    megahit_logs = MEGAHIT_ASSEMBLY.out.log

}