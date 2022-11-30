process INDEX_ASSEMBLY {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'
  
  input:
    path fasta
    val sample
  
  output:
    
  
  script:
  """
  bwa-mem2 index -p ${sample} ${fasta}
  """
}