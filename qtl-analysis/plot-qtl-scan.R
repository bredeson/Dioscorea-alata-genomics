#!/usr/bin/env Rscript

args = commandArgs(TRUE)

if (length(args) != 3) {
  cat("Usage: plot-qtl-scan.R <bfile> <chrom.sizes> <sig.thresh>\n", file=stderr())
  quit("no",1)
}

assoc.file = sprintf('%s.qassoc.mperm',args[[1]])
mperm.file = sprintf('%s.mperm.dump.best',args[[1]])
chrom.file = args[[2]]
sig.thresh = as.numeric(args[[3]])

ref.len = read.table(chrom.file, header=F, stringsAsFactors=F)
ref.chr = as.character(ref.len[,1])
ref.len = as.numeric(ref.len[,2])
ref.cum = cumsum(ref.len)
ref.off = ref.cum - ref.len
tot.len = sum(ref.len)
names(ref.len) = ref.chr
names(ref.off) = ref.chr
names(ref.cum) = ref.chr

odd  = seq(1,length(ref.chr),2)
even = seq(2,length(ref.chr),2)

assoc.genome = read.table(assoc.file, header=T, stringsAsFactors=F)  # with SNP field in "chr:pos" format
assoc.genome$CHR = unlist(lapply(strsplit(assoc.genome$SNP, ":"), function(x){x[1]}))
assoc.genome$SNP = unlist(lapply(strsplit(assoc.genome$SNP, ":"), function(x){x[2]}))
assoc.genome$SNP = as.integer(assoc.genome$SNP)
assoc.genome$EMP1 = -log10(assoc.genome$EMP1)
assoc.genome$EMP2 = -log10(assoc.genome$EMP2)
assoc.genome = assoc.genome[which(assoc.genome$CHR %in% ref.chr),]

#assoc.genome = cbind(as.data.frame(matrix(unlist(strsplit(assoc.genome$SNP, ':')), ncol=2, byrow=T), stringsAsFactors=F), assoc.genome)
## Mutliple testing (for multiple loci and a single phenotype) is accounted
## for by permutation testing. No additional correction necessary
# assoc.genome$ADJP = p.adjust(assoc.genome$EMP1, method='BY')  # Benjamini-Yekutieli adjustment
# assoc.genome$EMP2 = -log10(assoc.genome$ADJP)
# write.table(assoc.genome, file=sprintf("%s.adjust", assoc.file), col.names=T, row.names=F, quote=F, sep="\t")

max.y = ceiling(max(c(-log10(sig.thresh), assoc.genome$EMP1, assoc.genome$EMP2)))
tic.y = sort(c(-log10(0.05), seq(0, max.y, 1)))
lab.y = 10^(-tic.y)

pdf(sprintf("%s.pdf", assoc.file), width=21)
par(mar=c(6.1, 6.1, 0.6, 0.6))  # las=2
plot(c(0, tot.len), c(0, max.y), col=0, axes=F, xlim=c(0,tot.len), ylim=c(0,max.y), xlab="",ylab="P-value", main="", cex.lab=1.4)
rect(ref.off[ odd], 0, ref.cum[ odd], max.y, border=F, col="grey85")
rect(ref.off[even], 0, ref.cum[even], max.y, border=F, col="white")
for (ref.name in ref.chr) {
    assoc.chrom = assoc.genome[which(assoc.genome$CHR == ref.name),]
    lines(assoc.chrom$SNP+ref.off[assoc.chrom$CHR], assoc.chrom$EMP1, lwd=1.5, col="grey75")
}
segments(0, -log10(sig.thresh), tot.len, -log10(sig.thresh), col="deepskyblue2", lwd=1.5)
for (ref.name in ref.chr) {
    assoc.chrom = assoc.genome[which(assoc.genome$CHR == ref.name),]
    lines(assoc.chrom$SNP+ref.off[assoc.chrom$CHR], assoc.chrom$EMP2, lwd=3.0, col="black")
}
legend("topright", c(paste("alpha","=",sig.thresh,sep=" "), "Observed","Adjusted"), col=c("deepskyblue2", "grey75", "black"), lwd=3, bty='n', cex=1.25)
rug(assoc.genome$SNP+ref.off[assoc.genome$CHR], lwd=0.25)
axis(1, at=(ref.cum + ref.off)/2, labels=sub('Chr','',ref.chr, ignore.case=T), cex.axis=2, col=0, col.ticks=0)  # col="white", col.ticks="white")
axis(2, at=tic.y, labels=lab.y, cex.axis=1.5)
dev.off()

