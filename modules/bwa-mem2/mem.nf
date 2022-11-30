process INDEX_ASSEMBLY {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'
  
  input:
    tuple( val(sample), path(reads) )
    path index_folder
  
  output:
    
  
  script:
  """
  bwa-mem2 mem -t 40 -o "${sample}.sam" "index/${sample}" ${reads[0]} ${reads[1]}
  """
}