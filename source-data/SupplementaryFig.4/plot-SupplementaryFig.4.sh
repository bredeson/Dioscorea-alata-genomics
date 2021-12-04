#!/bin/bash

# Assumes a correctly-installed distro of Anaconda/Miniconda and the
# shell has been properly initialized with `conda init bash`

conda create \
     --yes \
     --channel conda-forge \
     --channel bioconda \
     --name r \
     r-base=3.5.3

conda activate r

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa95-00328 \
	SupplementaryFig.4a/SupplementaryFig.4a.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa95-00328.hist.pdf SupplementaryFig.4a.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa95-310 \
	SupplementaryFig.4b/SupplementaryFig.4b.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa95-310.hist.pdf SupplementaryFig.4b.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa99-00048 \
	SupplementaryFig.4c/SupplementaryFig.4c.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa99-00048.hist.pdf SupplementaryFig.4c.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa99-00240 \
	SupplementaryFig.4d/SupplementaryFig.4d.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa99-00240.hist.pdf SupplementaryFig.4d.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa00-00005 \
	SupplementaryFig.4e/SupplementaryFig.4e.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa00-00005.hist.pdf SupplementaryFig.4e.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa01-00039 \
	SupplementaryFig.4f/SupplementaryFig.4f.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa01-00039.hist.pdf SupplementaryFig.4f.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa02-00012 \
	SupplementaryFig.4g/SupplementaryFig.4g.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa02-00012.hist.pdf SupplementaryFig.4g.pdf

Rscript ./plot-SupplementaryFig.4.panel.R \
	TDa05-00015 \
	SupplementaryFig.4h/SupplementaryFig.4h.txt \
	0.0001 \
	0.03 \
	0.04 \
    && mv TDa05-00015.hist.pdf SupplementaryFig.4h.pdf
