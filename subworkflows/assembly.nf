include { NORMALIZE } from '../modules/bbtools/normalize.nf'
include { ERROR_CORRECT  } from '../modules/bbtools/error_correct.nf'
include { MEGAHIT_ASSEMBLY } from '../modules/megahit/assemble.nf'

workflow ASSEMBLY_WITH_ERROR_CORRECT {

  take:
    reads         // channel: [ val(sample), [ reads ] ]
    target        // channel: value: integer
    min           // channel: value: integer

  main:

  NORMALIZE(reads, target, min)
  ERROR_CORRECT(NORMALIZE.out.normalized_reads, target, min)
  MEGAHIT_ASSEMBLY(reads)

  emit:
    error_corrected_reads   = ERROR_CORRECT.out.error_corrected_reads  // channel: [ val(sample), [ reads ] ]
    sample = MEGAHIT_ASSEMBLY.out.sample                               // channel: val(sample)
    megahit_logs = MEGAHIT_ASSEMBLY.out.log                            // channel: path/to/assembly/logs
    contigs = MEGAHIT_ASSEMBLY.out.contigs                             // channel: path/to/assembly/contigs.fa
}