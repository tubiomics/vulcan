params.inputdir = "$projectDir/data/raw/contigs"
params.outdir = 'results'

process countReads {

  """
  seqkit --help
  """
}

process trimReads {

  """
  fastp --help
  """
}
/* 
 * prints user convenience 
 */
println "P R O J E C T    V U L C A N     "
println "                                 "
println "  Metagenome Assembly Pipeline   "
println "================================="
println "Input Path           : ${params.inputdir}"


workflow {
  countReads()
  trimReads()
}