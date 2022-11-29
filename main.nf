#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = "$projectDir/data/raw/reads/*_{1,2}.fastq.gz"
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
         --max_memory       : ${params.max_memory}


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

include { TAXANOMIC_ANALYSIS } from './subworkflows/taxonomic_analysis.nf'


workflow {
  ch_kaiju_db = Channel.fromPath("$params.kaiju_db", checkIfExists: true)
  ch_kaiju_nodes = Channel.fromPath("$params.kaiju_nodes", checkIfExists: true)
  ch_kaiju_names = Channel.fromPath("$params.kaiju_names", checkIfExists: true)
  ch_reads = Channel.fromFilePairs("$params.reads", checkIfExists:true)

  TAXANOMIC_ANALYSIS(
    ch_reads,
    ch_kaiju_db,
    ch_kaiju_nodes,
    ch_kaiju_names
  )
}