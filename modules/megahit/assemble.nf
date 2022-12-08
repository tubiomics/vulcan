process MEGAHIT_ASSEMBLY {

  label 'process_high'
  container 'tubiomics/vulcan-binning'

  input:
    tuple val(sample), file(reads)

  output:
    path "./megahit_out/${sample}.contigs.fa", emit: contigs
    path "./megahit_out/${sample}.log", emit: log
    val sample, emit: sample

  script:
    """
    megahit \
    -1 ${reads[0]} \
    -2 ${reads[1]} \
    --out-prefix ${sample} \
    --presets meta-large
    """
}