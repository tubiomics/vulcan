process TRIM_READS {
  label 'process_medium'
  container 'tubiomics/vulcan-qc:latest'

  tag "$sample"

  input:
    tuple val(sample), file(reads)

  output:
    tuple val(sample), path("$sample.*.gz")

  script:
    """
    fastp \
    -i ${reads[0]} \
    -I ${reads[1]} \
    -o "${sample}.trim.R1.fq.gz" \
    -O "${sample}.trim.R2.fq.gz" \
    --length_required 50 \
    -h "${sample}.html" \
    -w 16
    """
}