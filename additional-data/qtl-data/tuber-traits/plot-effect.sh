#!/bin/bash

#module load R/3.5.3
#module load plink/1.90b6.16
#module load vcftools/0.1.16-16-g954e607

base=$(dirname $0)

pushd IITA-1419/DryWeightGrams
vcftools --012 --vcf $base/../vcf/IITA-1419.AFI.AG30e20.xFAIL.nr.hap.vcf --out IITA-1419.DryWeightGrams 2>/dev/null
$base/../plot-qtl-gxp.R IITA-1419.DryWeightGrams Chr18:25069928  # Chr18:25086284
$base/../plot-qtl-ld.R IITA-1419.DryWeightGrams.012 Chr18:25069928 IITA-1419.DryWeightGrams.Chr18_25069928.ld
popd

pushd IITA-1419/Oxy30Mins
# $base/../plot-qtl-gxp.R IITA-1419.Oxy30Mins Chr2:591342
vcftools --012 --vcf $base/../vcf/IITA-1419.AFI.AG30e20.xFAIL.nr.hap.vcf --out	IITA-1419.Oxy30Mins 2>/dev/null
$base/../plot-qtl-gxp.R IITA-1419.Oxy30Mins Chr18:26496992
$base/../plot-qtl-ld.R IITA-1419.Oxy30Mins.012 Chr18:26496992 IITA-1419.Oxy30Mins.Chr18_26496992.ld
popd

pushd IITA-1419/Oxy180Mins
# $base/../plot-qtl-gxp.R IITA-1419.Oxy180Mins Chr2:591342
vcftools --012 --vcf $base/../vcf/IITA-1419.AFI.AG30e20.xFAIL.nr.hap.vcf --out	IITA-1419.Oxy180Mins 2>/dev/null
$base/../plot-qtl-gxp.R IITA-1419.Oxy180Mins Chr18:26496992
$base/../plot-qtl-ld.R IITA-1419.Oxy180Mins.012 Chr18:26496992 IITA-1419.Oxy180Mins.Chr18_26496992.ld
popd

pushd IITA-1427/Oxy30Mins
vcftools --012 --vcf $base/../vcf/IITA-1427.AFI.AG30e20.xFAIL.nr.hap.vcf --out IITA-1427.Oxy30Mins 2>/dev/null
$base/../plot-qtl-gxp.R IITA-1427.Oxy30Mins Chr18:24495033
$base/../plot-qtl-ld.R IITA-1427.Oxy30Mins.012 Chr18:24495033 IITA-1427.Oxy30Mins.Chr18_24495033.ld
popd

pushd NRCRI-1401/TBRSZ
vcftools --012 --vcf $base/../vcf/NRCRI-1401.AFI.AG30e20.xFAIL.nr.hap.vcf --out NRCRI-1401.TBRSZ 2>/dev/null
$base/../plot-qtl-gxp.R NRCRI-1401.TBRSZ Chr12:310852
$base/../plot-qtl-ld.R NRCRI-1401.TBRSZ.012 Chr12:310852 NRCRI-1401.TBRSZ.Chr12_310852.ld
popd

# pushd NRCRI-1512/CORTYP
# $base/../plot-qtl-gxp.R NRCRI-1512.CORTYP Chr5:4405251
# popd

pushd NRCRI-1512/TBRS
vcftools --012 --vcf $base/../vcf/NRCRI-1512.AFI.AG30e20.xFAIL.nr.hap.vcf --out NRCRI-1512.TBRS 2>/dev/null
$base/../plot-qtl-gxp.R NRCRI-1512.TBRS Chr7:3115608
$base/../plot-qtl-ld.R NRCRI-1512.TBRS.012 Chr7:3115608 NRCRI-1512.TBRS.Chr7_3115608.ld
popd

