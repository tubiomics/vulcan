include { COUNT_READS } from '../modules/seqkit/count_reads.nf'
include { TRIM_READS  } from '../modules/fastp/trim_reads.nf'
include { TAXANOMIC_CLASSIFICATION}  from '../modules/kaiju/taxanomic_classification.nf'
include { KAIJU_TO_KRONA } from '../modules/kaiju/kaiju_to_krona.nf'
include { KRONA_IMPORT_TEXT } from '../modules/kaiju/krona_import_text.nf'
include { KAIJU_TO_TABLE } from '../modules/kaiju/kaiju_to_table.nf'


workflow TAXANOMIC_ANALYSIS {

  take:
    reads         // channel: [ val(sample), [ reads ] ]
    db            // channel: /path/to/kaiju/db.fmi
    nodes         // channel: /path/to/kaiju/nodes/file
    names         // channel: /path/to/kaiju/names/file


  main:

  COUNT_READS(reads)
  TRIM_READS(reads)
  TAXANOMIC_CLASSIFICATION(TRIM_READS.out, nodes, db)
  KAIJU_TO_KRONA(TAXANOMIC_CLASSIFICATION.out, nodes, names)
  KRONA_IMPORT_TEXT(KAIJU_TO_KRONA.out)
  KAIJU_TO_TABLE(TAXANOMIC_CLASSIFICATION.out, nodes, names)
}