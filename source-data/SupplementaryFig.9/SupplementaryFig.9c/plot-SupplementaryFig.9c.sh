#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	SupplementaryFig.9c/SupplementaryFig.9c.fg.txt \
	SupplementaryFig.9c/SupplementaryFig.9c.bg.txt \
	SupplementaryFig.9c/SupplementaryFig.9c.1.loc.bed \
	SupplementaryFig.9c/SupplementaryFig.9c.2.loc.bed \
	'D. alata' \
	'D. zingiberensis' \
	SupplementaryFig.9c \
    && mv SupplementaryFig.9c.synt.pdf SupplementaryFig.9c.pdf

