params.reads = "$projectDir/data/raw/reads"
params.outdir = 'results'

process countReads {
  input:
    path read

  output:
    path 'original_fastq_counts.txt'

  script:
    """
    seqkit stats $read -T > original_fastq_counts.txt
    """
}

process trimReads {
  tag "$sample"

  input:
    tuple val(sample), file(reads)

  output:
    path "$sample.*.gz"

  script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} -o "${sample}.trim.R1.fq.gz" -O "${sample}.trim.R2.fq.gz" --length_required 50 -h "${sample}.html" -w 16
    """
}
/* 
 * prints user convenience 
 */
println "P R O J E C T    V U L C A N     "
println "                                 "
println "  Metagenome Assembly Pipeline   "
println "================================="
println "Input Path           : ${params.reads}"


workflow {
  stats_ch = Channel.fromPath("$params.reads/*fastq.gz", checkIfExists: true)
  trim_ch = Channel.fromFilePairs("$params.reads/*_{1,2}.fastq.gz", checkIfExists:true)
  countReads(stats_ch)
  trimReads(trim_ch)
}