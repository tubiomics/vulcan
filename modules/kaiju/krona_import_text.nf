process KRONA_IMPORT_TEXT {
  label 'process_low'
  container 'tubiomics/vulcan-ta:latest'

  input:
    path krona

  output:
    path "${krona.baseName}.kaiju.out.krona.html"
    
  script:
  """
  ktImportText -o "${krona.baseName}.kaiju.out.krona.html" ${krona}
  """
}