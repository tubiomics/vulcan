include { VARIATIONAL_AUTOENCODE } from '../modules/vamb/variational_autoencode.nf'

workflow METAGENOMIC_BINNING {

  take:
    contigs
    depth

  main:

  VARIATIONAL_AUTOENCODE(contigs, depth)


}