include { NORMALIZE } from '../modules/bbtools/normalize.nf'
include { ERROR_CORRECT  } from '../modules/bbtools/error_correct.nf'

workflow NORMALIZE_ERROR_CORRECT {

  take:
    reads         // channel: [ val(sample), [ reads ] ]
    target        // channel: value: integer
    min           // channel: value: integer

  main:
  
  NORMALIZE(reads, target, min)
  ERROR_CORRECT(NORMALIZE.out.normalized_reads, target, min)

  emit:
    error_corrected_reads   = ERROR_CORRECT.out.error_corrected_reads  // channel: [ val(sample), [ reads ] ]
}