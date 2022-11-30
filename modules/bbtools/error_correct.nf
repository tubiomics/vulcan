process ERROR_CORRECT {

  label 'process_medium'
  container 'tubiomics/vulcan-ec'

  input:
    tuple val(sample), file(reads)
    val target
    val min

  output:
    tuple val(sample), path("${sample}.ecc.${target}.${min}.R{1,2}.fq.gz"), emit: error_corrected_reads

  script:
    """
    tadpole.sh \
    in1=${reads[0]} \
    in2=${reads[1]} \
    out1="${sample}.ecc.${target}.${min}.R1.fq.gz" \
    out2="${sample}.ecc.${target}.${min}.R2.fq.gz" \
    mode=correct \
    k=50 \
    minprob=0.5 \
    prefilter=2
    """
}