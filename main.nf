#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// General inputs
params.outdir = 'results'
params.help = ""

// TAXANOMIC_ANALYSIS inputs
params.reads = "$projectDir/data/raw/reads/*_{1,2}.fastq.gz"
params.kaiju_db = "$projectDir/data/kaijudb/viruses/kaiju_db_viruses.fmi"
params.kaiju_names = "$projectDir/data/kaijudb/viruses/names.dmp"
params.kaiju_nodes = "$projectDir/data/kaijudb/viruses/nodes.dmp"

// NORMALIZE_ERROR_CORRECT inputs
params.target = 100
params.min = 5

// Post Assembly Processing Phase
params.max_sequences = 2500
params.contigs = "$projectDir/data/raw/assemblies/USDA_soil_C35.combined.contigs.fa"
params.sample = "USDA_soil_C35"
// METAGENOMIC_BINNING inputs
params.contigs = "$projectDir/data/assemblies/C.final.merged.fasta"
params.depth = "$projectDir/data/assemblies/depth.txt"

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
include { METAGENOMIC_BINNING } from './subworkflows/metagenomic_binning.nf'
// include { NORMALIZE_ERROR_CORRECT } from './subworkflows/error_correct.nf'
include { ASSEMBLY_WITH_ERROR_CORRECT } from './subworkflows/assembly.nf'
include { POST_ASSEMBLY_PROCESSING } from './subworkflows/index_assemblies.nf'
include { SAM_BINNING } from './subworkflows/sam_binning.nf'
include { METAGENOMIC_BINNING } from './subworkflows/metagenomic_binning.nf'

workflow {

  ch_reads = Channel.fromFilePairs("$params.reads", checkIfExists:true)
  ch_target = Channel.value(params.target)
  ch_min = Channel.value(params.min)
  ch_max_sequences = Channel.value(params.max_sequences)

  ch_sample = Channel.value(params.sample)
  ch_contigs = Channel.fromPath(params.contigs, checkIfExists:true)

  if (params.all_workflows ||  params.taxanomic_analysis) {

    ch_kaiju_db = Channel.fromPath("$params.kaiju_db", checkIfExists: true)
    ch_kaiju_nodes = Channel.fromPath("$params.kaiju_nodes", checkIfExists: true)
    ch_kaiju_names = Channel.fromPath("$params.kaiju_names", checkIfExists: true)
    

    TAXANOMIC_ANALYSIS(
      ch_reads,
      ch_kaiju_db,
      ch_kaiju_nodes,
      ch_kaiju_names
    )
  }

  if ( !params.skip_assembly ) {
    ASSEMBLY_WITH_ERROR_CORRECT(ch_reads, ch_target, ch_min)
  }

  if ( params.all_workflows || params.process_assembly ) {
    POST_ASSEMBLY_PROCESSING(ch_contigs, ch_sample, ch_max_sequences)
  }

  SAM_BINNING(TAXANOMIC_ANALYSIS.out.trimmed_reads, POST_ASSEMBLY_PROCESSING.out.index_directory, ch_sample)

  if ( params.all_workflows || params.metagenomic_binning ) {
    METAGENOMIC_BINNING(SAM_BINNING.out.sorted_bam_file, SAM_BINNING.out.sample, ASSEMBLY.out.contigs)

  }
}