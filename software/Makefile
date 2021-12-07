
.PHONY: artisanal gbs-analysis wgs-analysis map4cns

all: artisanal/activate gbs-analysis/install.sh wgs-analysis/activate map4cns/activate

%/Makefile:
	git submodule update --init

%/install.sh:
	git submodule update --init

artisanal/activate: artisanal/Makefile
	cd $(<D) && make install PREFIX=$(PWD)/$(<D)

gbs-analysis/activate.sh: gbs-analysis/install.sh
	cd $(<D) && ./install.sh

wgs-analysis/activate: wgs-analysis/Makefile
	cd $(<D) && make install PRJ_DIR=$(PWD)/$(<D)

map4cns/activate: map4cns/Makefile
	cd $(<D) && make install PREFIX=$(PWD)/$(<D)

artisanal: artisanal/activate

gbs-analysis: gbs-analysis/activate.sh

wgs-analysis: wgs-analysis/activate

map4cns: map4cns/activate
