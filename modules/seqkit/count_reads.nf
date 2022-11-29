process COUNT_READS {
  label 'process_low'
  container 'tubiomics/vulcan-qc:latest'

  input:
    tuple val(sample), file(reads)

  output:
    path "${sample}.txt"

  script:
    """
    seqkit stats ${reads[0]} -T > "${sample}.txt"
    """
}