process INDEX_ASSEMBLY {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'
  
  input:
    path fasta
    val sample
  
  output:
    path "index/${sample}.*", emit: index_directory
    
  
  script:
  """
  mkdir index
  bwa-mem2 index -p "index/${sample}" ${fasta}
  """
}