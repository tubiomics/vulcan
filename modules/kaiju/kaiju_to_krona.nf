process KAIJU_TO_KRONA {
  label 'process_low'
  container 'tubiomics/vulcan-ta:latest'

  input:
    path kaiju
    path nodes
    path names

  output:
    path "${kaiju.baseName}.kaiju.out.krona"
  
  script:
  """
  kaiju2krona -t ${nodes} -n ${names} -i ${kaiju} -o "${kaiju.baseName}.kaiju.out.krona"
  """
}