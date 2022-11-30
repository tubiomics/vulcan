process COUNT_READS {
  label 'process_low'
  container 'tubiomics/vulcan-qc:latest'

  input:
    path fasta
    val sample

  output:
    path "${sample}.txt", emit: stats

  script:
    """
    seqkit stats ${fasta} -T > "${sample}.txt"
    """
}