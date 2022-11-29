process NORMALIZE {

  label 'process_medium'
  container 'tubiomics/vulcan-ec'

  input:
    tuple val(sample), file(reads)
    val target
    val min

  output:
    tuple val(sample), path("${sample}.norm.${target}.${min}.R{1,2}.fq.gz"), emit: normalized_reads

  script:
    """
    bbnorm.sh \
    in1=${reads[0]} \
    in2=${reads[1]} \
    out1="${sample}.norm.${target}.${min}.R1.fq.gz" \
    out2=c"${sample}.norm.${target}.${min}.R2.fq.gz" \
    target=${target} \
    min=${min} \
    prefilter=t \
    khist=khist_before.txt \
    khistout=khist_after.txt
    """
}