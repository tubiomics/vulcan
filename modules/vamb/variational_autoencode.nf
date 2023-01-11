process VARIATIONAL_AUTOENCODE {

  label 'process_medium'
  container 'tubiomics/vulcan-mbpy3'

  input:
    path contigs
    path depth

  output:
    path "vamb_folder", emit: vamb_folder
    path "vamb_folder/log*.txt", emit: logs

  script:
    """
    vamb --outdir vamb_folder --fasta ${contigs} --jgi ${depth} --minfasta 100 -e 15 -q 7
    """
}

