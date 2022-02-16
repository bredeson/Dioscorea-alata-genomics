
.PHONY: artisanal gbs-analysis wgs-analysis map4cns

all: artisanal/activate gbs-analysis/install.sh wgs-analysis/activate map4cns/activate

%/Makefile:
	git submodule update --init

%/install.sh:
	git submodule update --init

# Other repos were added as submodules after updates had been pushed to those repos
# make sure we checkout the correct versions:

artisanal/activate: artisanal/Makefile
	cd $(<D) && git checkout v0.1.2-67-g18fff4a && make install PREFIX=$(PWD)/$(<D)

gbs-analysis/activate.sh: gbs-analysis/install.sh
	cd $(<D) && git checkout v1.4.1-11-g19a5f3a && ./install.sh

wgs-analysis/activate: wgs-analysis/Makefile
	cd $(<D) && git checkout v1.0-26-g4cf73ab && make install PRJ_DIR=$(PWD)/$(<D)

map4cns/activate: map4cns/Makefile
	cd $(<D) && git checkout v0.1.3 && make install PREFIX=$(PWD)/$(<D)

artisanal: artisanal/activate

gbs-analysis: gbs-analysis/activate.sh

wgs-analysis: wgs-analysis/activate

map4cns: map4cns/activate
