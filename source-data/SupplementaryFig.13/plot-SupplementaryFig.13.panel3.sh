#!/usr/bin/env Rscript

args = commandArgs(TRUE)

min.ld = 0.90

P = args[[1]]  # input file prefix
r = args[[2]]  # region str of focal locus
o = args[[3]]  # output file prefix

p = sub('.gz$', '', P, perl=TRUE)

L = read.table(sprintf("%s.pos", p), stringsAsFactors=F)
M = read.table(P)
M = t(as.matrix(M[,2:ncol(M)]))

l = strsplit(r, ':')[[1]]

M = M[which(L[,1] == l[1]),]
L = L[which(L[,1] == l[1]),]
N = nrow(L)

R = paste(L[,1], L[,2], sep=':')
I = 1:nrow(M)
names(I) = R

D = data.frame(CHR=rep(r[1], N), BEG=L[,2]-1, END=L[,2], r=cor(t(M), M[I[r],]), stringsAsFactors=FALSE)
d = range(which(D$r >= min.ld))
d[1] = max(1, d[1] - 1)
d[2] = min(N, d[2] + 1)

write.table(D, sep="\t", quote=FALSE, col.names=FALSE, row.names=FALSE, file=sprintf("%s.r.bed",o))
cat(sprintf("%s\t%d\t%d\n", l[1], D$BEG[d[1]], D$END[d[2]]), file=sprintf("%s.r.%d.bed",o,as.integer(100*min.ld)))

pdf(sprintf("%s.pdf",o))
par(mar=c(5.1,6.1,4.1,2.1))
plot(D$END/1e6, D$r, type='o', 
  pch=16, lwd=0.5, bty='n', col="black",
  cex=1.25, cex.lab=1.5, cex.axis=1.5,
  ylim=c(min(D$r), 1.0),
  xlab="Chromosome position (Mb)", ylab=bquote("Correlation coeff. (" ~ italic(r) ~ ")"), main=r
)
points(x=(as.numeric(l[2]) / 1e6), y=1.0, pch=18, cex=1.75, col="#009ACD")
invisible(dev.off())


