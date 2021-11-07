#!/bin/bash

if [[ $# -ne 4 ]]; then
    printf "Usage: %s <in.vcf> <in.fam> <in.map> <out.prefix>\n" $(basename $0) >>/dev/fd/2
    exit 1;
fi

vcf=$1
fam=$2
map=$3
out=$4
pop=$(tail -n 1 $fam | cut -f1);

zcat $vcf | awk 'OFS="\t" {if ($1 !~ /^#/) { print $3,$1":"$2 }}' >$out.name.txt
awk 'OFS="\t" {if (($6 ~ /^-?[0-9.]+$/) && ($6 != -9)) {print $1,$2} else if ($3 == 0 && $4 == 0) {print $1,$2}}' $fam >$out.keep.txt
awk 'OFS="\t" {print $1,$2,$5}' $fam >$out.sex.txt
awk 'OFS="\t" {print $1,$2,$6}' $fam >$out.pheno.txt
awk 'OFS="\t" {print $2,$3}' $map >$out.cm.txt
awk 'OFS="\t" {print $2}' $map >$out.snp.txt


plink --make-bed --vcf   $vcf --out $out --const-fid $pop
plink --make-bed --bfile $out --out $out --update-name $out.name.txt
plink --make-bed --bfile $out --out $out --update-cm $out.cm.txt
plink --make-bed --bfile $out --out $out --update-parents $fam
plink --make-bed --bfile $out --out $out --update-sex $out.sex.txt
plink --make-bed --bfile $out --out $out --pheno $out.pheno.txt
plink --make-bed --bfile $out --out $out --extract $out.snp.txt
plink --make-bed --bfile $out --out $out --keep $out.keep.txt

#plink --bfile $out --recode --out t  # for debugging

# rm $out.name.txt $out.sex.txt $out.pheno.txt $out.cm.txt $out.keep.txt $out.snp.txt
