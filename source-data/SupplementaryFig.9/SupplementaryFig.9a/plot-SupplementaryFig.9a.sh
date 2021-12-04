#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	SupplementaryFig.9a/SupplementaryFig.9a.fg.txt \
	SupplementaryFig.9a/SupplementaryFig.9a.bg.txt \
	SupplementaryFig.9a/SupplementaryFig.9a.1.loc.bed \
	SupplementaryFig.9a/SupplementaryFig.9a.2.loc.bed \
	'D. alata' \
	'D. rotundata' \
	SupplementaryFig.9a \
    && mv SupplementaryFig.9a.synt.pdf SupplementaryFig.9a.pdf

