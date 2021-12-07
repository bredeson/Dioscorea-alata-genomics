#!/usr/bin/env Rscript

arguments = commandArgs(TRUE)  # <bfile> <chr:pos> <out-prefix>

missing.allele = c(-9, NA)
missing.phenotype = c(-9, NA, 0)
genotype.colors = c(
  rgb(237/255,173/255, 31/255,0.7),  # "goldenrod1",
  rgb(133/255,133/255,143/255,0.7),  # "grey50",
  rgb(  0/255, 70/255,224/255,0.7)   # "blue"
)

bfile = arguments[[1]]
locus = arguments[[2]]
prefx = arguments[[3]]
tfile = tempfile("plink-list-", tmpdir=tempdir())

cat(sprintf("[INFO] Staging with prefix: %s\n", tfile), file=stderr())

list.mean = function(l) {
  lapply(l, function(g) {mean(g, na.rm=T)})
}

list.rss = function(l) {
  lapply(l, function(g) {(na.omit(g) - mean(g, na.rm=T))^2})
}

se = function(X) {
  X = na.omit(X)
  sd(X) / sqrt(length(X))
}

ci = function(X, Z=1.96) {
  X = na.omit(X)
  mean(X) + c(-Z, Z) * se(X)
}

#system(sprintf("plink --bfile '%s' --out '%s' --make-just-fam", bfile, tfile), ignore.stdout=TRUE, ignore.stderr=TRUE)
system(sprintf("plink --bfile '%s' --out '%s' --make-just-fam --snp '%s' --recode lgen --allow-no-sex", bfile, tfile, locus), ignore.stdout=TRUE, ignore.stderr=TRUE)

fam = read.table(sprintf("%s.fam", tfile), header=FALSE, stringsAsFactors=FALSE)
fam = fam[order(fam[,2]),]
colnames(fam) = c("FamilyID","ProbandID","PaternalID","MaternalID","Sex","Phenotype")

snp = read.table(sprintf("%s.lgen",tfile), header=FALSE, stringsAsFactors=FALSE, colClasses="character")
snp = snp[order(snp[,2]),]
colnames(snp) = c("FamilyID","ProbandID","Locus", "Allele1","Allele2")

if (nrow(fam) != nrow(snp)) {
  stop(sprintf("Unequal number of individuals in .fam and .lgen files: %d != %d",
               nrow(fam), nrow(snp)))
}

# TODO: remove missing phenotypes (NA, -9, "-") and genotypes (-9)

snp$Phenotype  = fam$Phenotype
snp$PaternalID = fam$PaternalID
snp$MaternalID = fam$MaternalID



snp = snp[which(!(snp$Allele1 %in% missing.allele | 
                  snp$Allele2 %in% missing.allele)),]

allele.list = c(snp$Allele1, snp$Allele2)
allele.char = unique(sort(allele.list))
allele.dose = 1:length(allele.char) - 1
if (length(which(allele.list == allele.char[1])) < length(which(allele.list == allele.char[2]))) {
  allele.char = rev(allele.char)
}
names(allele.dose) = allele.char

progeny = snp[which((snp$PaternalID != 0) & 
                    (snp$MaternalID != 0) & 
                    (!(snp$Phenotype %in% missing.phenotype))),]
progeny$AlleleDose = apply(progeny, 1, function(l){allele.dose[l[4]]+allele.dose[l[5]]})

paternal.id = unique(progeny$PaternalID)
maternal.id = unique(progeny$MaternalID)
if ((length(paternal.id) > 1) | (length(maternal.id) > 1)) {
  stop("Multiple pedigrees detected in bfile, expected only one")
}

paternal.index = which(snp$ProbandID == paternal.id)
maternal.index = which(snp$ProbandID == maternal.id)
paternal.dose = sort(c(allele.dose[snp$Allele1[paternal.index]],
                       allele.dose[snp$Allele2[paternal.index]]))
maternal.dose = sort(c(allele.dose[snp$Allele1[maternal.index]],
                       allele.dose[snp$Allele2[maternal.index]]))
progeny.dose = log2(unique(c((paternal.dose+1) %*% t(maternal.dose+1))))
genotype.group = list()
genotype.stats = list()
h2 = -1

for (dose in progeny.dose) {
  genotype.group[[as.character(dose)]] = progeny$Phenotype[
    which((allele.dose[progeny$Allele1] + allele.dose[progeny$Allele2]) == dose)
  ]
}

# Calculate PVE/h^2 as per:
# Broman, KW and Sen, S. 2009. A Guide to QTL Mapping with R/qtl. 
#   New York: Springer. Vol. 46. pg 122
if ((sum(paternal.dose) == 1) & (sum(maternal.dose) == 1)) {
  # POs: 0/1 x 0/1 => Progeny 0/0, 0/1, 1/1
  # PVE = h^2 = (2*a^2 + d^2) / (2a^2 + d^2 + 4r^2)
  #    where a = additive = (m[1/1] - m[0/0])/2
  #          d = dominant =  m[0/1] - (m[1/1] + m[0/0])/2
  #          s = residual sd
  progeny.genotypes = c(
    sprintf("%s/%s",allele.char[1], allele.char[1]),
    sprintf("%s/%s",allele.char[1], allele.char[2]),
    sprintf("%s/%s",allele.char[2], allele.char[2])
  )
  m  = list.mean(genotype.group)
  r  = list.rss(genotype.group)
  s  = sqrt(sum(unlist(r)) / (nrow(progeny) - 1))  # 3 means
  a  = (m[["2"]] - m[["0"]])/2
  d  = (m[["1"]] - (m[["2"]] + m[["0"]])/2)
  h2 = (2*a^2 + d^2) / (2*a^2 + d^2 + 4*s^2)
  
} else if (((sum(paternal.dose) == 1) & (sum(maternal.dose) == 0)) | 
           ((sum(paternal.dose) == 0) & (sum(maternal.dose) == 1))) {
  # 0/0 x 0/1 -or- 0/1 x 0/0 => 0/0, 0/1
  # PVE = h^2 = a^2 / (a^2 + 4s^2)
  #    where a = additive = (m[0/1] - m[0/0])
  #          s = residual 
  progeny.genotypes = c(
    sprintf("%s/%s",allele.char[1], allele.char[1]),
    sprintf("%s/%s",allele.char[1], allele.char[2])
  )
  m  = list.mean(genotype.group)
  r  = list.rss(genotype.group)
  s  = sqrt(sum(unlist(r)) / (nrow(progeny) - 1))  # 2 means
  a  = (m[["1"]] - m[["0"]])
  h2 = a^2 / (a^2 + 4*s^2)
  
} else {
  stop(sprintf("Unsupported parental configuration: %s x %s", 
               snp$Genotype[snp$ProbandID == paternal.id], 
               snp$Genotype[snp$ProbandID == maternal.id]))
}

pdf(sprintf("%s.%s.effect.pdf", prefx, sub(":","_",locus)))
plot(
  jitter(progeny$AlleleDose, amount=0.125), progeny$Phenotype, 
  col=genotype.colors[progeny$AlleleDose+1], pch=16, cex=1.25, 
  axes=F, 
  xlim=range(progeny$AlleleDose) + c(-0.375, +0.375), 
  ylim=range(progeny$Phenotype) * c(0.7, +1.1),
  main=locus,
  xlab="",
  ylab="Phenotypic value",
  sub=bquote(italic(h)^2 == .(sprintf("%.04f",h2))),
  cex.lab=1.5,
  cex.sub=1.75
)
axis(2, cex=2, cex.axis=1.5)
axis(1, at=progeny.dose, labels=progeny.genotypes, cex.axis=2.25)


for (dose in progeny.dose) {
  genotype.mu = mean(genotype.group[[as.character(dose)]])
  genotype.ci = ci(genotype.group[[as.character(dose)]])
  
  segments(dose-0.20, genotype.mu,    dose+0.20, genotype.mu,    lwd=2.5) # middle bar
  segments(dose+0.00, genotype.ci[1], dose+0.00, genotype.ci[2], lty=2)   # whisker
  segments(dose-0.10, genotype.ci,    dose+0.10, genotype.ci)             # outer bars

  mtext(bquote(.(sprintf("%.02f",genotype.mu)) %+-% .(sprintf("%.02f",diff(genotype.ci)/2))), side=1, adj=0.5, padj=2.5, at=dose, cex=1.5)
}

invisible(dev.off())

