process INDEX_ASSEMBLY {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'
  
  input:
    tuple( val(sample), path(reads) )
    path index_folder
  
  output:
    path "${sample}.sam", emit: sam_file
    val sample
    
  
  script:
  """
  bwa-mem2 mem -t 40 -o "${sample}.sam" ${sample} ${reads[0]} ${reads[1]}
  """
}