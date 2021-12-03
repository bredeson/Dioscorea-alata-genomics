#!/bin/bash

CWD=$(dirname $0);

Rscript $CWD/../../software/artisanal/src/plot-collinearity-index.R \
	Fig.2b/Fig.2b.1.fg.txt \
	Fig.2b/Fig.2b.2.bg.txt \
	Fig.2b/Fig.2b.3.loc.txt \
	Fig.2b/Fig.2b.3.loc.txt \
	'D. alata' \
	'D. alata' \
	Fig.2b \
    && mv Fig.2b.synt.pdf Fig.2b.pdf

