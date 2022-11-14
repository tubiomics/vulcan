#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = "$projectDir/data/raw/reads"
params.kaijudb = "$projectDir/data/kaijudb/kaiju_db_fungi_2022-03-29/kaiju_db_fungi.fmi"
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
    path "$sample.*.gz"

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


workflow {
  stats_ch = Channel.fromPath("$params.reads/*fastq.gz", checkIfExists: true)
  trim_ch = Channel.fromFilePairs("$params.reads/*_{1,2}.fastq.gz", checkIfExists:true)
  countReads(stats_ch)
  trimReads(trim_ch)
}