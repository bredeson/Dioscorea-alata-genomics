#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	SupplementaryFig.9e/SupplementaryFig.9e.fg.txt \
	SupplementaryFig.9e/SupplementaryFig.9e.bg.txt \
	SupplementaryFig.9e/SupplementaryFig.9e.1.loc.bed \
	SupplementaryFig.9e/SupplementaryFig.9e.2.loc.bed \
	'D. alata' \
	'A. comosus' \
	SupplementaryFig.9e \
    && mv SupplementaryFig.9e.synt.pdf SupplementaryFig.9e.pdf

