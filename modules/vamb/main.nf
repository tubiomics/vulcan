process VARIATIONAL_AUTOENCODE {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'

  input:
    path contigs
    path depth

  output:
    path 

  script:
    """
    vamb --outdir vamb_folder --fasta ${contigs} --jgi ${depth} --minfasta 200000
    """
}

