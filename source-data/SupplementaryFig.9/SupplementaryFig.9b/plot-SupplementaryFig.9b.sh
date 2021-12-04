#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	SupplementaryFig.9b/SupplementaryFig.9b.fg.txt \
	SupplementaryFig.9b/SupplementaryFig.9b.bg.txt \
	SupplementaryFig.9b/SupplementaryFig.9b.1.loc.bed \
	SupplementaryFig.9b/SupplementaryFig.9b.2.loc.bed \
	'D. alata' \
	'D. dumetorum' \
	SupplementaryFig.9b \
    && mv SupplementaryFig.9b.synt.pdf SupplementaryFig.9b.pdf

