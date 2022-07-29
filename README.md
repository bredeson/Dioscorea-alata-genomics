# *Dioscorea alata* genomics data and scripts

## Description
This repository contains scripts and data from the *Dioscorea alata* var. TDa95/00328 genome assembly v2 and population genetic analysis manuscript:

- Bredeson JV, Lyons JB, Oniyinde IO, Okereke NR, Kolade O, Nnabue I, Nwadili CO, Hribova E, Parker M, Nwogha J, Shu S, Carlson J, Kariba R, Muthemba S, Knop K, Barton GJ, Sherwood AV, Lopez-Montes A, Asiedu R, Jamnadass R, Muchugi A, Goodstein D, Egesi CN, Featherston J, Asfaw A, Simpson GG, Dolezel J, Hendre PS, Van Deynze A, Kumar PL, Obidiegwu JE, Bhattacharjee R, Rokhsar DS. Chromosome evolution and the genetic basis of agronomically important traits in greater yam. *Nat Commun*. 2022 Apr 14;13(1):2001. doi:10.1038/s41467-022-29114-w. PMID:35422045; PMCID:PMC9010478.


### Abstract
The nutrient-rich tubers of the greater yam, *Dioscorea alata* L., provide food and income security for millions of people around the world. Despite its global importance, however, greater yam remains an ‘orphan crop.’ Here we address this resource gap by presenting a highly contiguous chromosome-scale genome assembly of *D. alata* combined with a dense genetic map derived from African breeding populations. The genome sequence reveals an ancient allotetraploidization in the *Dioscorea* lineage, followed by extensive genome-wide reorganization. Using our new genomic tools we find quantitative trait loci for resistance to anthracnose, a damaging fungal pathogen of yam, and several tuber quality traits. Genomic analysis of breeding lines reveals both extensive inbreeding as well as regions of extensive heterozygosity that may represent interspecific introgression during domestication. These tools and insights will enable yam breeders to unlock the potential of this staple crop and take full advantage of its adaptability to varied environments.


### File Structure

The files within this repo are organized broadly into three subdirectories: `software`, `source-data`, and `additional-data`: 

- `software/`: This subdirectory contains submodules for software repositories first used in previous publications but are also used/added to in this work. Not all analysis scripts unique to this work will be contained within, but may instead be found within the relevant `source-data` or `additional-data` subdirectories.
  > **NOTE**: See the **Installation** section below for how to properly install submodules.


- `source-data/`: This subdirectory contains data files and scripts used to generate the figures presented in the manuscript and Supplementary Information (where feasible). Each figure subdirectory is further organized by figure panel. The primary script for regenerating each figure is named with a `plot-<FigName>.sh` convention; for example, the following will regenerate the plots presented in Fig. 1 (See the contents of these individual scripts for execution details): 
  ```bash
  cd source-data/Fig.1 && plot-Fig.1.sh
  ```
  > **NOTE**: Regenerating figures with these scripts requires a properly-configured Anaconda or Miniconda installation. See the **Installation** section below for additional dependencies.
  

- `additional-data/`: This subdirectory contains the data files and scripts to replicate some additional analyses:
  > **NOTE**: Regenerating figures with these scripts requires a properly-configured Anaconda or Miniconda installation. See the **Installation** section below for additional dependencies.
  - `chr-data/`: Chromosome landscape and Rabl structure analyses. Knight-Ruiz normalized HiC contact density matrices at MapQ30 for all pairs of chromosomes; a BEDgraph file containing loading values representing A/B compartment assignments; gene, repeat, and recombination density BEDgraph files; and scaffolding gap BED file. Also included is a FASTA file containing the putative *D. alata* centromeric tandem repeat.
  - `cp-data/`: Complete chloroplast genome sequence, CDS, and peptide FASTA files and annotation tables newly assembled for *D. alata* var. TDa95/00328, *D. rotundata* var. TDr96_F1, and *D. dumetorum* var. IboSweet3 used this work.
  - `mt-data/`: Partial mitochondrial genome sequence and annotation table for *D. alata* var. TDa95/00328.
  - `qtl-data/`: Quantitative Trait Loci data. Data and scripts for replicating the QTL analyses for all populations and traits examined in this work. This includes imputed and phased VCF files, genetic linkage MAP files, and phenotype FAM files for each population.
  - `wgd-data/`: Whole-Genome Duplication data. The indexed gene CDS and peptide sequences and locus BED files for each species used in the whole-genome duplication and comparative genomics analyses. Precomputed mutual best-hit BLASTP gene-pairs with Ks values are also provided.


## Installation
This repo and its dependencies are easily downloaded using Git's `clone` function:
```bash
git clone --recursive https://github.com/bredeson/Dioscorea-alata-genomics.git

```
**NOTE**: The `--recursive` flag above is important for also pulling down the software dependencies required for analyses. If the `--recursive` flag was not initially called when `git clone` was invoked, you can do:
```bash
pushd software && git submodule update --init && popd
```

This should then recursively clone the following dependency repositories:
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
pages for each, if an error occurs.



