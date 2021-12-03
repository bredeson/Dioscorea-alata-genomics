#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../../software/artisanal/src/plot-collinearity-index.R \
	Fig.2b/Fig.2b.fg.txt \
	Fig.2b/Fig.2b.bg.txt \
	Fig.2b/Fig.2b.loc.bed \
	Fig.2b/Fig.2b.loc.bed \
	'D. alata' \
	'D. alata' \
	Fig.2b \
    && mv Fig.2b.synt.pdf Fig.2b.pdf

