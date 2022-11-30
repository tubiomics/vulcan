process MINIMUS {

  label 'process_medium'
  container 'tubiomics/vulcan-amos'
  
  input:
    path contigs
    val sample
  
  output:
    path "${sample}.singletons.seq", emit: singletons
    path "${sample}.fasta", emit: fasta

  script:
  """
  minimus2 ${sample} -D OVERLAP=100 -D MINID=95 -D THREADS=40
  """
}