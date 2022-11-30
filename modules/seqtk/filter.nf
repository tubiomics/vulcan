process SEQTK_FILTER {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'

  input:
    path contigs
    val sample
    val max_sequences
  
  output:
    path "${sample}.${max_sequences}.contigs.fa", emit: filtered_contigs
  
  script:
  """
  seqtk seq -L ${max_sequences} ${contigs} > "${sample}.${max_sequences}.contigs.fa"
  """
}