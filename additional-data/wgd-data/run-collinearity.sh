#!/bin/bash

if [[ -z "$2" ]]; then
    printf "\n" >>/dev/fd/2;
    printf "Usage: %s <species1> <species2>\n" $(basename $0) >>/dev/fd/2;
    printf "\n" >>/dev/fd/2;
    printf "Notes:\n" >>/dev/fd/2;
    printf "  Expects blast+, dialign-tx, samtools, python3, R,\n" >>/dev/fd/2;
    printf "  and the artisanal repo to be accessible via \$PATH\n" >>/dev/fd/2;
    printf "\n" >>/dev/fd/2;
    printf "\n" >>/dev/fd/2;
    exit 1;
fi

# assumes the current run directory has been populated with files called:
#   prefix.pep.fasta  (protein sequence fasta, multiple isoforms allowed)
#   prefix.cds.fasta  (coding sequence fasta, multiple isoforms allowed)
#   prefix.bed        (BED representing genomic positions of coding sequences)
#   prefix.loc.bed    (BED representing genomic positions of genes)
# where 'prefix' is designated by species1 and species2 inputs above.
# The above files can be generated with gff3-to-prot available from
# https://bitbucket.org/bredeson/artisanal using options:
#   gff3-to-prot -L also -g -t -S -P 'species1.' annotation.gff3 genome.fasta species1

sp1=$1;  # species 1 file prefix
sp2=$2;  # species 2 file prefix

PROGRAM=$(basename $0 .sh);

if [[ -n "$NERSC_HOST" ]]; then
    module load blast+/2.10.0;
    module load dialign-tx/1.0.2;
    module load samtools/1.9-93-g0ca96a4;
    module load python/3.7-anaconda-2019.10;
    module load R/3.6.3;
fi

printf "INFO: Starting: $PROGRAM.$$\n" >>/dev/fd/2;

for sp in $sp1 $sp2; do
    for suffix in cds.fasta pep.fasta bed loc.bed; do 
	printf "INFO: Checking input exists: $sp.$suffix\n" >>/dev/fd/2;
	if [[ ! -s $sp.$suffix ]]; then
	    printf "ERROR: File not found: $sp.$suffix\n" >>/dev/fd/2;
	    exit 1;
	fi
    done
    
    for suffix in cds.fasta pep.fasta; do
	if [[ ! -s $sp.$suffix.fai ]]; then
	    printf "INFO: Indexing FASTA: $sp.$suffix\n" >>/dev/fd/2;
	    samtools faidx \
	        $sp.$suffix \
	    1>&2 \
	    2>> $PROGRAM.$$.log \
	    || cat $PROGRAM.$$.log >>/dev/fd/2;
	fi
    done
done

if [[ -s $sp1.pep.fasta && ! -s $sp1.pep.fasta.psq ]]; then
    printf "INFO: Building BLAST DB: $sp1.pep.fasta\n" >>/dev/fd/2;
    makeblastdb \
	-dbtype prot \
	-in $sp1.pep.fasta \
    1>&2 \
    2>> $PROGRAM.$$.log \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1.pep.fasta && -s $sp2.pep.fasta && ! -s $sp1-$sp2.B45.E1e-5.anchors ]]; then
    printf "INFO: Running BLASTP: $sp1-$sp2.B45.E1e-5.anchors\n" >>/dev/fd/2;
    blastp \
	-seg yes \
	-soft_masking true \
	-lcase_masking \
	-matrix BLOSUM45 \
	-evalue 1e-5 \
	-num_threads 8 \
	-outfmt '6 sseqid qseqid bitscore evalue' \
	-query $sp2.pep.fasta \
	-db $sp1.pep.fasta \
	-out $sp1-$sp2.B45.E1e-5.anchors.tmp \
   1>&2 \
   2>> $PROGRAM.$$.log \
   && mv $sp1-$sp2.B45.E1e-5.anchors.tmp \
         $sp1-$sp2.B45.E1e-5.anchors \
   || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

selfself_options='';
if [[ $sp1 == $sp2 ]]; then
    selfself_options='-X -d1000000';
fi

if [[ -s $sp1-$sp2.B45.E1e-5.anchors && ! -s $sp1-$sp2.B45.E1e-5.c1.anchors ]]; then
    printf "INFO: Running filters: $sp1-$sp2.B45.E1e-5.c1.anchors\n" >>/dev/fd/2;
    filter-hits \
        -t1 -q2 -a3 -AIu -c1 \
	-T '\.\d+$' -Q '\.\d+$' \
	$selfself_options \
	$sp1-$sp2.B45.E1e-5.anchors \
	$sp1.bed \
	$sp2.bed \
    1>  $sp1-$sp2.B45.E1e-5.c1.anchors.tmp \
    2>> $PROGRAM.$$.log \
    && mv $sp1-$sp2.B45.E1e-5.c1.anchors.tmp \
	  $sp1-$sp2.B45.E1e-5.c1.anchors \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi
if [[ -s $sp1-$sp2.B45.E1e-5.c1.anchors && ! -s $sp1-$sp2.B45.E1e-5.c1.rR1.anchors ]]; then
    printf "INFO: Running filters: $sp1-$sp2.B45.E1e-5.c1.rR1.anchors\n" >>/dev/fd/2;
    filter-hits \
        -t1 -q2 -a3 -Au -c1 -r -R1:1 \
	-T '\.\d+$' -Q '\.\d+$' \
	$selfself_options \
	$sp1-$sp2.B45.E1e-5.c1.anchors \
	$sp1.bed \
	$sp2.bed \
    1>  $sp1-$sp2.B45.E1e-5.c1.rR1.anchors.tmp \
    2>> $PROGRAM.$$.log \
    && mv $sp1-$sp2.B45.E1e-5.c1.rR1.anchors.tmp \
	  $sp1-$sp2.B45.E1e-5.c1.rR1.anchors \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1-$sp2.B45.E1e-5.c1.anchors && ! -s $sp1-$sp2.anchors ]]; then
    printf "INFO: Preparing for Ka/Ks: $sp1-$sp2.anchors\n" >>/dev/fd/2;
    cut -f1,2 $sp1-$sp2.B45.E1e-5.c1.anchors | uniq >$sp1-$sp2.anchors
fi

if [[ -s $sp1-$sp2.anchors && ! -s $sp1-$sp2.synt.pdf ]]; then
    printf "INFO: Plotting: $sp1-$sp2.synt.pdf\n" >>/dev/fd/2;
    awk 'OFS="\t" {gsub(".[0-9]+$","",$1); gsub(".[0-9]+$","",$2); print $1,$2}' \
	 $sp1-$sp2.anchors >$sp1-$sp2.anchors.tmp \
    && plot-collinearity-index \
	 $sp1-$sp2.anchors.tmp \
	 $sp1.loc.bed \
	 $sp2.loc.bed \
	 $sp1-$sp2 \
    1>&2 \
    2>>$PROGRAM.$$.log \
    && rm $sp1-$sp2.anchors.tmp
fi


if [[ -s $sp1-$sp2.anchors && ! -s $sp1-$sp2.kaks.fofn ]]; then
    N=$(cat $sp1-$sp2.anchors | wc -l);

    mkdir -p extract align trim;

    printf "INFO: Running Ka/Ks: extract\n" >>/dev/fd/2;
    nl -w1 $sp1-$sp2.anchors | while read i seq1 seq2; do
	cat \
	    <(samtools faidx $sp1.cds.fasta $seq1) \
	    <(samtools faidx $sp2.cds.fasta $seq2) \
	    1> extract/$i.fa \
	    2> extract/$i.log || printf "WARN: Extraction failed: $i\n" >>/dev/fd/2;    
    done

    printf "INFO: Running Ka/Ks: align\n" >>/dev/fd/2;
    for i in $(seq 1 $N); do
	if [[ -s extract/$i.fa ]]; then
	    dialign-tx \
		-O -l2 \
		extract/$i.fa \
		align/$i.fa \
	      &>align/$i.log \
	    || printf "WARN: Alignment failed: $i\n" >>/dev/fd/2;
	fi
    done

    printf "INFO: Running Ka/Ks: trim\n" >>/dev/fd/2;
    for i in $(seq 1 $N); do
	# dialign-tx alignments can fail if one or 
	# more sequences contains non-ATCG chars
	if [[ -s align/$i.fa ]]; then
	    extract-aligned-codons \
	        align/$i.fa \
	      1>trim/$i.fa \
	      2>trim/$i.log \
	    || printf "WARN: Trimming failed: $i\n" >>/dev/fd/2;
	fi
    done

    for i in $(seq 1 $N); do
	if [[ -s trim/$i.fa ]]; then
	    printf "trim/$i.fa\n";
	fi
    done >$sp1-$sp2.kaks.fofn.tmp \
	&& mv $sp1-$sp2.kaks.fofn.tmp \
	      $sp1-$sp2.kaks.fofn
fi

if [[ -s $sp1-$sp2.kaks.fofn && ! -s $sp1-$sp2.kaks.tsv ]]; then
    printf "INFO: Running Ka/Ks: $sp1-$sp2.kaks.tsv\n" >>/dev/fd/2;
    calculate-kaks \
        $sp1-$sp2.kaks.fofn \
	1> $sp1-$sp2.kaks.tsv.tmp \
	2> $PROGRAM.$$.log \
    && mv $sp1-$sp2.kaks.tsv.tmp \
	  $sp1-$sp2.kaks.tsv \
    && tar -czf $sp1-$sp2.kaks.tar.gz \
	extract align trim \
        $sp1-$sp2.kaks.fofn \
	$sp1-$sp2.kaks.tsv \
    && rm -rf extract align trim \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1-$sp2.kaks.tsv && ! -s $sp1-$sp2.ks.bedpe ]]; then
    printf "INFO: Running filters: $sp1-$sp2.ks.bedpe\n" >>/dev/fd/2;
    filter-hits \
	-t2 -q3 -a5 -s0 -S9 -Bu \
	$selfself_options \
	$sp1-$sp2.kaks.tsv \
	$sp1.bed \
	$sp2.bed \
    1> $sp1-$sp2.ks.bedpe.tmp \
    2>>$PROGRAM.$$.log \
    && mv $sp1-$sp2.ks.bedpe.tmp \
	  $sp1-$sp2.ks.bedpe \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi
if [[ -s $sp1-$sp2.kaks.tsv && ! -s $sp1-$sp2.ks.anchors ]]; then
    printf "INFO: Running filters: $sp1-$sp2.ks.anchors\n" >>/dev/fd/2;
    filter-hits \
	-t2 -q3 -a5 -s0 -S9 -Au -L \
	-T '\.\d+$' -Q '\.\d+$' \
	$selfself_options \
	$sp1-$sp2.kaks.tsv \
	$sp1.bed \
	$sp2.bed \
    1> $sp1-$sp2.ks.anchors.tmp \
    2>>$PROGRAM.$$.log \
    && mv $sp1-$sp2.ks.anchors.tmp \
	  $sp1-$sp2.ks.anchors \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1-$sp2.ks.anchors && ! -s $sp1-$sp2.ks.synt.pdf ]]; then
    printf "INFO: Plotting: $sp1-$sp2.ks.synt.pdf\n" >>/dev/fd/2;
    plot-collinearity-index \
	$sp1-$sp2.ks.anchors \
	$sp1.loc.bed \
	$sp2.loc.bed \
	$sp1-$sp2.ks \
    1>&2 \
    2>>$PROGRAM.$$.log \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

selfself_options='';
if [[ $sp1 == $sp2 ]]; then
    selfself_options='-X -O0.25,0.25';
fi


if [[ -s $sp1-$sp2.ks.bedpe && ! -s $sp1-$sp2.ks.m2d20.clust.c.bedpe ]]; then
    printf "INFO: Clustering: $sp1-$sp2.ks.m2d20.clust.c.bedpe\n" >>/dev/fd/2;
    cluster-collinear-bedpe \
	-m2 -d20 -c \
	$selfself_options \
	$sp1-$sp2.ks.bedpe \
    1> $sp1-$sp2.ks.m2d20.clust.c.bedpe.tmp \
    2>>$PROGRAM.$$.log \
    && mv $sp1-$sp2.ks.m2d20.clust.c.bedpe.tmp \
	  $sp1-$sp2.ks.m2d20.clust.c.bedpe \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi


if [[ -s $sp1-$sp2.ks.bedpe && ! -s $sp1-$sp2.ks.m5d20.clust.bedpe ]]; then
    printf "INFO: Clustering: $sp1-$sp2.ks.m5d20.clust.bedpe\n" >>/dev/fd/2;
    cluster-collinear-bedpe \
	-m5 -d20 \
	$selfself_options \
	$sp1-$sp2.ks.bedpe \
    1> $sp1-$sp2.ks.m5d20.clust.bedpe.tmp \
    2>>$PROGRAM.$$.log \
    && mv $sp1-$sp2.ks.m5d20.clust.bedpe.tmp \
	  $sp1-$sp2.ks.m5d20.clust.bedpe \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1-$sp2.ks.m5d20.clust.bedpe && ! -s $sp1-$sp2.ks.m5d20.clust.anchors ]]; then
    printf "INFO: Running filters: $sp1-$sp2.ks.m5d20.clust.anchors\n" >>/dev/fd/2;
    cut -f7,8 $sp1-$sp2.ks.m5d20.clust.bedpe \
	| tr ':' '\t' \
	| awk 'OFS="\t" {gsub(".[0-9]+$","",$1); gsub(".[0-9]+$","",$2); print $0}' \
        1> $sp1-$sp2.ks.m5d20.clust.anchors.tmp \
	2>>$PROGRAM.$$.log \
	&& mv $sp1-$sp2.ks.m5d20.clust.anchors.tmp \
	      $sp1-$sp2.ks.m5d20.clust.anchors \
	|| cat $PROGRAM.$$.log >>/dev/fd/2;
fi

if [[ -s $sp1-$sp2.ks.m5d20.clust.anchors && ! -s $sp1-$sp2.ks.m5d20.clust.synt.pdf ]]; then
    printf "INFO: Plotting: $sp1-$sp2.ks.m5d20.clust.synt.pdf\n" >>/dev/fd/2;
    plot-collinearity-index \
	$sp1-$sp2.ks.m5d20.clust.anchors \
	$sp1.loc.bed \
	$sp2.loc.bed \
	$sp1-$sp2.ks.m5d20.clust \
    1>&2 \
    2>>$PROGRAM.$$.log \
    || cat $PROGRAM.$$.log >>/dev/fd/2;
fi

