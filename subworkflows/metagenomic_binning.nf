include { SUMMARIZE_BAM_CONTIG_DEPTH } from '../modules/metabat2/summarize_bam_contig_depth.nf'
include { METABAT_BINNING } from '../modules/metabat2/metabat.nf'
include { VARIATIONAL_AUTOENCODE } from '../modules/vamb/variational_autoencode.nf'

workflow METAGENOMIC_BINNING {

  take:
    bam_file              // channel: /path/to/sorted/bam/file
    sample                // channel: val(sample)
    contigs               // channel: /path/to/contigs.fa

  main:
  SUMMARIZE_BAM_CONTIG_DEPTH(bam_file, sample)
  METABAT_BINNING(contigs, SUMMARIZE_BAM_CONTIG_DEPTH.out.depth_file, sample)
  VARIATIONAL_AUTOENCODE(contigs, SUMMARIZE_BAM_CONTIG_DEPTH.out.depth_file)
}