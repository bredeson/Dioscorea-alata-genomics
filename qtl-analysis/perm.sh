#!/bin/bash

script=$(basename $0 .sh);
bfile=$1;
afile=$2;
mperm=$3;
tfile=$afile.$mperm.mperm/$(basename $1);

mkdir -p $afile.$mperm.mperm


plink --bfile $bfile --make-just-fam --out $tfile
plink --fam $tfile.fam --make-perm-pheno $mperm --out $tfile --allow-no-sex

printf "[$script] Performing $mperm permutations\n" >>/dev/fd/2;
for i in $(seq 1 $mperm); do
    if [[ $(( $i % 100 )) == 0 ]]; then
	printf "[$script] Permutations: $i\n" >>/dev/fd/2;
    fi
    ifile=$tfile.$(printf %06d $i);
    plink --bfile $bfile --mpheno $i --pheno $tfile.pphe --allow-no-sex --assoc --threads 1 --out $ifile &>$ifile.log
done
printf "[$script] Permutations: done\n" >>/dev/fd/2;


printf "[$script] Adjusting P-values\n" >>/dev/fd/2;

# Per Browning 2008 BMC Bioinfo. doi:10.1186/1471-2105-9-309
# let:
#  l = locus
#  t = observed test statistic (here, Wald's p-value)
#  P = count(total permutations)
#  k = count(P > t)
#  a = adjusted p-value = (k+1) / (P+1)
awk '
FILENAME==ARGV[1] {if ($2 != "SNP") {t[$2]  =  $9}}
FILENAME!=ARGV[1] {if ($2 != "SNP") {k[$2] += ($9 <= t[$2]); P[$2]++}}
END{ for (l in t) {print l,t[l],P[l],k[l],(k[l]+1)/(P[l]+1) }}' $afile $tfile.*.qassoc \
    | sort -k1,1V \
    | cat <(echo "SNP EMP1 P k EMP2") - >$afile.mperm$mperm.qassoc

printf "[$script] cleaning up\n" >>/dev/fd/2;
#rm -r $afile.$mperm.mperm

printf "[$script] Finished\n" >>/dev/fd/2;

