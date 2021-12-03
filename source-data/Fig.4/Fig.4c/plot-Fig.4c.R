#!/usr/bin/env Rscript

argv = commandArgs(TRUE);

if ((length(argv) != 4) & (length(argv) != 5)) {
    cat("Usage: plot-roh.R <roh.config> <hety.config> <genome.len> [genome.alias] <out.pdf>\n");
    q(status=1);
}

read.roh = function(f) {
   return(read.table(as.character(f), stringsAsFactors=F));
}

cat.chrs  = function(bed, fai) {
    if (length(bed[,1]) != length(fai[,1])) {
        stop("Genome BED and FAI unequal lengths");
    }
    len = 0;
    for(i in 1:length(bed[,1])) {
        bed$START[i] = len;
        bed$END[i]   = len + bed$END[i]
        len          = bed$END[i];
    }
    return(bed);
}


roh.conf = read.table(argv[1]);
var.conf = read.table(argv[2]);
chr.fai = read.table(argv[3]);
out.pdf = argv[length(argv)];
chr.map = data.frame(CHROM=chr.fai[,1],ALIAS=chr.fai[,1]);

if (length(argv) == 5) {
    chr.map = read.table(argv[4]);
    colnames(chr.map) = c("CHROM","ALIAS");
}


# set some constants;
chr.lwd =          21;
seg.roh = "#00688B";
seg.het = "#69DFFF";
seg.var = "#FFC125";

num.indv = length(roh.conf[,1]);
num.chr  = length(chr.fai[,1]);
chr.pos  = cat.chrs(data.frame(CHROM = chr.fai[,1], START = chr.fai[,2], END = chr.fai[,2]), chr.fai);
max.pos  = max(chr.pos$END);

# begin plotting the data:
pdf(out.pdf, height=2.2+round(0.25 * num.indv, 1), width=20);
par(mar=c(5.1, 8.1, 4.1, 2.1), las=1);
plot(max.pos/1e6, 0.5*num.indv, axes=F, type='n', xlim=c(0,max.pos/1e6), ylim=c(0,0.5*num.indv+0.5), main='', sub='Genomic position (Mb)', xlab='Chromosome', ylab='', yaxs='i');

for(i in 1:num.indv) {
   segments(0, 0.5*(num.indv-i+1), max.pos/1e6, 0.5*(num.indv-i+1), col=seg.het, lwd=chr.lwd, lend=1); 
   roh.seg = try(read.roh(roh.conf[i,2]), TRUE);
   var.seg = try(read.roh(var.conf[i,2]), TRUE);

   if (class(roh.seg) == "try-error") {
       roh.seg = data.frame()
   }
   if (class(var.seg) == "try-error") {
       var.seg = data.frame()
   }
   for(chrom in chr.pos$CHROM) {
       chr = chr.pos[which(chr.pos$CHROM == chrom),];
       if (nrow(roh.seg) > 0) {
           roh = roh.seg[which(roh.seg[,1]   == chrom),];
	   if (nrow(roh) > 0) {
               segments((chr$START[1]+roh[,2])/1e6, 0.5*(num.indv-i+1), (chr$START[1]+roh[,3])/1e6, 0.5*(num.indv-i+1), col=seg.roh, lwd=chr.lwd, lend=1);
	   }
       }
       if (nrow(var.seg) > 0) {
           var = var.seg[which(var.seg[,1]   == chrom),];
           if (nrow(var) > 0) {
               segments((chr$START[1]+var[,2])/1e6, 0.5*(num.indv-i+1), (chr$START[1]+var[,3])/1e6, 0.5*(num.indv-i+1), col=seg.var, lwd=chr.lwd, lend=1);
           }
       }
   }
}

abline(v=chr.pos$END[1:(num.chr-1)]/1e6, col="white", lwd=1);

axis(1, cex.axis=0.75, labels=c(0,as.integer(chr.pos$END/1e6)), at=c(0,chr.pos$END/1e6));
axis(1, cex.axis=2,    labels=chr.map$ALIAS, tick=FALSE, at=(0.5*(chr.pos$START+chr.pos$END))/1e6, padj=1);
axis(2, at=0.5*c(1:num.indv), labels=rev(roh.conf[,1]), tick=F);

invisible(dev.off());
