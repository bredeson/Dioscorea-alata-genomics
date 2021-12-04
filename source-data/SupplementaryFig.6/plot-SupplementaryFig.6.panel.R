#!/usr/bin/env Rscript

chr.boundary.color = "grey50"

args = commandArgs(TRUE)

map = read.table(args[[1]], stringsAsFactors=F, header=T)  # consensus map file

chr.sizes = read.table(args[[2]], stringsAsFactors=F, header=F)
chr.names = chr.sizes[,1]
chr.sizes = chr.sizes[,2]
names(chr.sizes) = chr.names

chr.off = cumsum(chr.sizes) - chr.sizes
chr.sum = sum(chr.sizes)

map.sizes = c();
map.names = unique(map[,1])
for (chr in map.names) {
  lg = map[which(chr == map[,1]),];
  map.sizes = append(map.sizes, max(lg[,3]))
}
names(map.sizes) = map.names
map.off = cumsum(map.sizes) - map.sizes
map.sum = sum(map.sizes)


pdf(args[[3]])
par(mar=c(5.1,5.1,0.1,0.1), xaxs='i', yaxs='i')
plot((map[,4]+chr.off[map[,1]])/1e6, map[,3]+map.off[map[,1]], pch=16, cex=0.5, xlab="Genome Position (Mb)", ylab="Genetic Position (cM)", main="", cex.lab=1.4, type='n', axes=F)
segments(chr.off/1e6,0,chr.off/1e6,map.sum, lwd=1, col=chr.boundary.color)
segments(0,map.off,chr.sum/1e6,map.off, lwd=1, col=chr.boundary.color)
segments(chr.sum, 0, chr.sum, map.sum, lwd=1, col=chr.boundary.color)
segments(chr.sum/1e6, 0, chr.sum/1e6, map.sum, lwd=1, col=chr.boundary.color)
segments(0,map.sum,chr.sum/1e6,map.sum, lwd=1, col=chr.boundary.color)
points((map[,4]+chr.off[map[,1]])/1e6, map[,3]+map.off[map[,1]], pch=16, cex=0.375, col="blue")
axis(1, at=(0.5*(cumsum(chr.sizes)+chr.off)/1e6), labels=chr.names, las=2, tick=F, hadj=1)
axis(1, at=seq(0,chr.sum/1e6,10), labels=seq(0,chr.sum/1e6,10), cex.axis=0.5, tick=F, line=F, las=2, hadj=0)
axis(2, at=(0.5*(cumsum(map.sizes)+map.off)), labels=map.names, las=2, tick=F, hadj=1)
axis(2, at=seq(0,map.sum,25), labels=seq(0,map.sum,25), cex.axis=0.5, tick=F, line=F, las=2, hadj=0)
dev.off()

