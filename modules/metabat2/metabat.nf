process METABAT_BINNING {

  label 'process_medium'
  container 'tubiomics/vulcan-metabat2'
  
  input:
    path contigs
    path depth
    val sample
  
  output:
    path "${sample}-depth.txt", emit: depth_file
    
  
  script:
  """
  metabat -i ${contigs} -a ${depth} --seed 4821 -o "${sample}.mbat"
  """
}