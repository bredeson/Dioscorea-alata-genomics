#!/usr/bin/env Rscript
# Assumes PLINK-formatted linkage maps, one population and chromosome (of 1:1 correspondence) per file
# Input config has one population per line:
# <pop.name> <pop.size> <pop.map.filepath>

interval.range = 1:10

arguments = commandArgs(TRUE)
arguments = unlist(arguments)
if (length(arguments) != 2) {
    cat("Usage: lpmerge-maps.R <lpmerge.map> <out-prefix>\n", file=stderr())
    quit("no",1)
}

merged.maps = read.table(arguments[1], stringsAsFactors=F, header=T, na.strings="-")
prefix = arguments[2]


for (chrom.name in unique(merged.maps$Chr)) {
   merged.map = merged.maps[which(merged.maps[,1] == chrom.name),]
   colors = rainbow(ncol(merged.map)-4)

   scale = c(0,0,0,1)
   shift = c(0,0,0,0)
   for (j in 5:ncol(merged.map)) {
       fit = lm(merged.map[,3] ~ merged.map[,j])
       shift = append(shift, fit$coeff[1])
       scale = append(scale, fit$coeff[2])
   }
   max.x = max(merged.map[,4])
   max.y = max(merged.map[,3], na.rm=T) + max(shift)

   pdf(sprintf("%s.%s.pdf",prefix, chrom.name))
   plot(c(0,max.x/1e6), c(0,max.y), col=0, xlab="Genomic Position (Mb)", ylab="Genetic Position (cM)", main=chrom.name, cex.axis=1.4, cex.lab=1.4, bty='n', axes=F)
   rect(-0.04*max.x,-0.04*max.y,1.04*max.x,1.05*max.y, col="grey85", border=F)
   axis(1)
   axis(2)
   for (j in 5:ncol(merged.map)) {
       points(merged.map[,4]/1e6, scale[j]*merged.map[,j]+shift[j], col=colors[j-4], pch=19, cex=0.5)
   }
   points(merged.map[,4]/1e6, merged.map[,3], col="black", pch=19, cex=0.5)
   legend("topleft",c("Composite",names(merged.map)[5:ncol(merged.map)]), fill=c("black",colors), bty='n')
   invisible(dev.off())
}
