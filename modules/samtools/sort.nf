process SAMTOOLS_SORT {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'
  
  input:
    path bam_file
    val sample
  
  output:
    path "${sample}.sorted.bam", emit: sorted_bam_file
    
  
  script:
  """
  samtools sort -@ 10 ${bam_file} > "${sample}.sorted.bam"
  """
}