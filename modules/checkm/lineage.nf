process CHECKM_LINEAGE {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'

  input:
    path vamb_text
    path bins

  output:
  
  script:
  """
  checkm lineage_wf -f ${vamb_text} -t 40 -x fna ${bins} checkm_folder
  """
}