process SAMTOOLS_INDEX {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'
  
  input:
    path bam_file
    val sample
  
  output:
    path "${sample}.sorted.bam", emit: bam_file
    path "${sample}.sorted.bam.bai", emit: indexed_bam_file
  
  script:
  """
  samtools index -@ 10 ${bam_file}
  """
}