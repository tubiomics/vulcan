process CLUSTER_SIMILAR_PROTEINS {

  label 'process_medium'
  container 'tubiomics/vulcan-binning'
  
  input:
    path contigs
    val sample
    val max_sequences
  
  output:
    path "${sample}.dedup.${max_sequences}.contigs.fa", emit: clustered_contigs
  
  script:
  """
  cd-hit-est -i ${contigs} -o "${sample}.dedup.${max_sequences}.contigs.fa" -T 0 -M 0 -c 0.99 -aS 0.9 -d 100
  """
}