process SEQKIT_REPLACE {
  label 'process_low'
  container 'tubiomics/vulcan-qc:latest'

  input:
    val sample
    path contigs

  output:
    path "${sample}.fasta", emit: contigs_replaced

  script:
    """
    seqkit replace ${contigs} -p .+ -r "${sample}_{nr}" > "${sample}.fasta"  --nr-width 8
    """
}