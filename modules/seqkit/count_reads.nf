process COUNT_READS {
  label 'process_low'
  container 'tubiomics/vulcan-qc:latest'

  input:
    path read

  output:
    path 'original_fastq_counts.txt'

  script:
    """
    seqkit stats $read -T > original_fastq_counts.txt
    """
}