process CONCATENTATE_MINIMUS_FILES {
  input:
    path fasta
    path singletons
    val sample

  output:
    path "${sample}.final.contigs.fa", emit: fasta
  
  script:
  """
  cat ${fasta} ${singletons} > ${sample}.final.contigs.fa 
  """
}