#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	SupplementaryFig.9d/SupplementaryFig.9d.fg.txt \
	SupplementaryFig.9d/SupplementaryFig.9d.bg.txt \
	SupplementaryFig.9d/SupplementaryFig.9d.1.loc.bed \
	SupplementaryFig.9d/SupplementaryFig.9d.2.loc.bed \
	'D. alata' \
	'E. guineensis' \
	SupplementaryFig.9d \
    && mv SupplementaryFig.9d.synt.pdf SupplementaryFig.9d.pdf

