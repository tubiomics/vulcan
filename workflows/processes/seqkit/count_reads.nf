process countReads {
  input:
    path read

  output:
    path 'original_fastq_counts.txt'

  script:
    """
    seqkit stats $read -T > original_fastq_counts.txt
    """
}