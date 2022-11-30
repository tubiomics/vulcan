process SAMTOOLS_FLAGSTAT {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'
  
  input:
    path bam_file
    val sample
  
  output:
    path "${sample}_mapped_reads.txt", emit: mapped_reads
    
  
  script:
  """
  samtools flagstat -@ 10 ${bam_file} > "${sample}_mapped_reads.txt"
  """
}