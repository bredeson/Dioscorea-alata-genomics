# *Dioscorea alata* genomics data and scripts
This repository contains the scripts and data from the Bredeson, Lyons, et al.
Dioscorea alata cv. TDa95/00328 v2 genome and population genetic analyses.

- Bredeson, Lyons, et al. Chromosome evolution and the genetic basis of agronomically important traits in greater yam. *Nat Comm*. (in review)


## Abstract

The nutrient-rich tubers of the greater yam, *Dioscorea alata* L., provide food and income security for millions of people around the world. Despite its global importance, however, greater yam remains an ‘orphan crop.’ Here we address this resource gap by presenting a highly contiguous chromosome-scale genome assembly of *D. alata* combined with a dense genetic map derived from African breeding populations. The genome sequence reveals an ancient allotetraploidization in the Dioscorea lineage, followed by extensive genome-wide reorganization. Using our new genomic tools we find quantitative trait loci for resistance to anthracnose, a damaging fungal pathogen of yam, and several tuber quality traits. Genomic analysis of breeding lines reveals both extensive inbreeding as well as regions of extensive heterozygosity that may represent interspecific introgression during domestication. These tools and insights will enable yam breeders to unlock the potential of this staple crop and take full advantage of its adaptability to varied environments.

## Install
This repo is easily obtained using Git's `clone` function:
```bash
git clone --recursive https://github.com/bredeson/Dioscorea-alata-genomics.git

```
The `--recursive` flag above is important for also pulling down the 
software dependencies used in the analyses.

- artisanal: https://bitbucket.org/bredeson/artisanal
- gbs-analysis: https://bitbucket.org/rokhsar-lab/gbs-analysis
- map4cns: https://bitbucket.org/rokhsar-lab/map4cns
- wgs-analysis: https://bitbucket.org/rokhsar-lab/wgs-analysis

To configure and install the software dependencies, do:
```bash
cd software && make
```
**NOTE**: running `make` above makes some assumptions about the user's
operating system and environment. Please read the individual documenation
pages for each if an error is incurred.


## File Structure

The files within this repo are organized broadly into two subdirectories: `software` and `analysis`: 

- `software/`: This subdirectory contains submodules for software repositories first used in previous publications but are also used/added to in this work. Not all analysis scripts unique to this work will be contained within, but may instead be found within the most relevant `analysis` subdirectory.

- `analysis/`: This subdirectory contains the data files and scripts used to produce figures presented in the manuscript:
  - `chr-analysis/`: Files related to the chromosome landscape and Rabl structure analyses, including Knight-Ruiz normalized HiC contact density matrices at MapQ30; an A/B compartment BEDgraph file; gene, repeat, and recombination density BEDgraph files; and scaffolding gap BED file. 
  - `cp-analysis/`: Chloroplast genome, CDS, and peptide FASTA files newly assembled for *D. alata* var. TDa95/00328, *D. rotundata* var. TDr96_F1, and *D. dumetorum* var. IboSweet3 used this work.
  - `qtl-analysis/`: Data and scripts for replicating the QTL analyses presented in the manuscript. This includes imputed VCF files, genetic linkage MAP files, and phenotype FAM files for each population.
  - `wgd-analysis/`: The indexed gene CDS and peptide sequences and locus BED files for species used in the whole-genome duplication and comparative genomics analyses. Precomputed homologous gene-pairs with Ks values are provided as BEDPE and anchor files.


