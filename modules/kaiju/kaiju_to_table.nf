process KAIJU_TO_TABLE {
  label 'process_low'
  container 'tubiomics/vulcan-ta:latest'
  
  input:
    path kaiju
    path nodes
    path names
  
  output:
    path "${kaiju.baseName}.kaiju.summary.tsv"

  script:
  """
  kaiju2table -t ${nodes} -n ${names} -r species -l superkingdom,phylum,class,order,family,genus,species -o "${kaiju.baseName}.kaiju.summary.tsv" ${kaiju}
  """
}