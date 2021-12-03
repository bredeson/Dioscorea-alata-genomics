#!/usr/bin/env Rscript

arguments = commandArgs(TRUE)

ibd.file = arguments[[1]]
lab.file = arguments[[2]]
out.file = arguments[[3]]

# Input ibddata table contains one triangle of the pairwise matrix. 
ibdata = read.table(ibd.file, stringsAsFactors=FALSE, header=TRUE)
labels = read.table(lab.file, stringsAsFactors=FALSE, header=FALSE)
labels = labels[,1]

indices = 1:length(labels)
names(indices) = labels

# Reflect data across the diagonal:
ibdata = rbind(ibdata, data.frame(ID1=ibdata$ID2, ID2=ibdata$ID1, IBD0=ibdata$IBD0, IBD1=ibdata$IBD1, IBD2=ibdata$IBD2))
# Fill the diagonal (comparisons against self are always IBD2=100%):
ibdata = rbind(ibdata, data.frame(ID1=labels, ID2=labels, IBD0=0, IBD1=0, IBD2=1))

ibdata$colors = hsv(240/360, ibdata$IBD2, 1-ibdata$IBD0)

pdf(out.file)
par(mar=c(8, 0.1, 0.1, 8))
plot(c(0,length(labels)), c(0,length(labels)), col=0, main="", xlab="", ylab="", axes=FALSE)
rect(indices[ibdata$ID1] - 1, length(labels) - indices[ibdata$ID2] + 1, indices[ibdata$ID1], length(labels) - indices[ibdata$ID2], border=FALSE, col=as.character(ibdata$colors))
axis(1, labels=labels, at=indices-0.5, las=2, line=0, tick=0)
axis(4, labels=labels, at=length(labels) - indices + 0.5, las=2, line=0, tick=0)
invisible(dev.off())
