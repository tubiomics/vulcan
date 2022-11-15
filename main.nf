#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = "$projectDir/data/raw/reads"
params.kaiju_db = "$projectDir/data/kaijudb/viruses/kaiju_db_viruses.fmi"
params.kaiju_names = "$projectDir/data/kaijudb/viruses/names.dmp"
params.kaiju_nodes = "$projectDir/data/kaijudb/viruses/nodes.dmp"
params.outdir = 'results'
params.help = ""

ANSI_GREEN = "\033[1;32m"
ANSI_RED = "\033[1;31m"
ANSI_RESET = "\033[0m"

if (params.help) {
    helpMessage()
    exit(0)
}

log.info """
        ===========================================
         P R O J E C T    V U L C A N
         
         Metagenome Assembly Pipeline


         Used parameters:
        -------------------------------------------
         --reads            : ${params.reads}
         --kaiju_db         : ${params.kaiju_db}
         --kaiju_names      : ${params.kaiju_names}
         --kaiju_nodes      : ${params.kaiju_nodes}


         Runtime data:
        -------------------------------------------
         Running with profile:   ${ANSI_GREEN}${workflow.profile}${ANSI_RESET}
         Run container:          ${ANSI_GREEN}${workflow.container}${ANSI_RESET}
         Running as user:        ${ANSI_GREEN}${workflow.userName}${ANSI_RESET}
         Launch dir:             ${ANSI_GREEN}${workflow.launchDir}${ANSI_RESET}
         Base dir:               ${ANSI_GREEN}${baseDir}${ANSI_RESET}
         """
         .stripIndent()

def helpMessage() {
log.info """
        ===========================================
         P R O J E C T    V U L C A N
         
         Metagenome Assembly Pipeline

         Usage:
        -------------------------------------------
         --reads            : directory with fastq files, default is "fastq"
         --kaiju_db         : full path (or S3 bucket) to the kaiju database (.fmi file extension)
         --kaiju_names      : full path (or S3 bucket) to the kaiju names.dmp file
         --kaiju_nodes      : full path (or S3 bucket) to the kaiju nodes.dmp file
        ===========================================
         """
         .stripIndent()

}

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

process taxanomic_classification {
  tag "$sample"

  input:
    tuple val(sample), file(trimmed_reads)
    path nodes
    path db

  output:
    path "${sample}.kaiju.out"

  script:
    """
    kaiju -t $nodes -f $db -i ${trimmed_reads[0]} -j ${trimmed_reads[1]} -o "${sample}.kaiju.out" -z 6 -v
    """
}


workflow {
  kaiju_db_ch = Channel.fromPath("$params.kaiju_db", checkIfExists: true)
  kaiju_nodes_ch = Channel.fromPath("$params.kaiju_nodes", checkIfExists: true)
  kaiju_names_ch = Channel.fromPath("$params.kaiju_names", checkIfExists: true)
  stats_ch = Channel.fromPath("$params.reads/*fastq.gz", checkIfExists: true)
  trim_ch = Channel.fromFilePairs("$params.reads/*_{1,2}.fastq.gz", checkIfExists:true)
  countReads(stats_ch)
  trimReads(trim_ch)
  taxanomic_classification(trimReads.out, kaiju_db_ch, kaiju_nodes_ch)
}