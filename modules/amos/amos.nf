process AMOS {

  label 'process_medium'
  container 'tubiomics/vulcan-amos'
  
  input:
    path contigs
    val sample
  
  output:
    path "${sample}.afg", emit: amos_contigs
  
  script:
  """
  toAmos -s ${contigs} -o "${sample}.afg"
  """
}