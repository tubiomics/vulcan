process TAXANOMIC_CLASSIFICATION {
  label 'process_medium'
  tag "$sample"
  container 'tubiomics/vulcan-ta:latest'

  input:
    tuple val(sample), file(trimmed_reads)
    path nodes
    path db

  output:
    path "${sample}.kaiju.out"

  script:
    """
    kaiju -t $nodes -f $db -i ${trimmed_reads[0]} -j ${trimmed_reads[1]} -o "${sample}.kaiju.out" -v
    """
}