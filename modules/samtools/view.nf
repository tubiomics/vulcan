process SAMTOOLS_VIEW {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'
  
  input:
    path sam_file
    val sample
  
  output:
    path "${sample}.bam", emit: bam_file
    
  
  script:
  """
  samtools view -b -@ 10 ${sam_file} > "${sample}.bam"
  """
}