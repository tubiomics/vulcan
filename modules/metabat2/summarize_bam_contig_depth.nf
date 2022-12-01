process SUMMARIZE_BAM_CONTIG_DEPTH {

  label 'process_medium'
  container 'tubiomics/vulcan-metabat2'
  
  input:
    path bam_file
    val sample
  
  output:
    path "${sample}-depth.txt", emit: depth_file
    
  
  script:
  """
  jgi_summarize_bam_contig_depths --outputDepth "${sample}-depth.txt" ${bam_file}
  """
}