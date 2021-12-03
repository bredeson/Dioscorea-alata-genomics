#!/usr/bin/env Rscript

argv = commandArgs(TRUE);

if ((length(argv) != 3) & (length(argv) != 4)) {
    cat("Usage: plot-IBD.R <in.config> <genome.len> [genome.alias] <out.pdf>\n");
    q(status=1);
}

read.bed = function(f) {
   return(read.table(as.character(f), stringsAsFactors=FALSE, header=TRUE));
}

cat.chrs  = function(bed,fai) {
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


config  = read.table(argv[1]);
chr.fai = read.table(argv[2]);
out.pdf = argv[length(argv)];
chr.map = data.frame(CHROM=chr.fai[,1],ALIAS=chr.fai[,1]);

if (length(argv) == 4) {
    chr.map = read.table(argv[3]);
    colnames(chr.map) = c("CHROM","ALIAS");
}


# set some constants;
chr.lwd    =        21;
ibd0.color = '#000000';
ibd1.color = '#CCCCCC';
ibd2.color = '#0000FF';
none.color = '#FFFFFF';

num.indv = length(config[,1]);
num.chr  = length(chr.fai[,1]);
chr.pos  = cat.chrs(data.frame(CHROM = chr.fai[,1], START = chr.fai[,2], END = chr.fai[,2]), chr.fai);
max.pos  = max(chr.pos$END);

# begin plotting the data:
pdf(out.pdf, height=2.2+round(0.25 * num.indv, 1), width=20);
par(mar=c(5.1, 8.1, 4.1, 2.1), las=1);
plot(max.pos/1e6, 0.5*num.indv, axes=F, type='n', xlim=c(0,max.pos/1e6), ylim=c(0,0.5*num.indv+0.5), main='', sub='Genomic position (Mb)', xlab='Chromosome', ylab='', xaxs='i');

for(i in 1:num.indv) {
   segments(0, 0.5*(num.indv-i+1), max.pos/1e6, 0.5*(num.indv-i+1), col=none.color, lwd=chr.lwd, lend=1); 
   chr.seg = try(read.bed(config[i,2]), TRUE);
   
   if (class(chr.seg) == "try-error") {
       cat(sprintf("[WARN] Could not read '%s'. Skipping\n", config[i,2]), file=stderr())
       next;
   }
   for(chrom in chr.pos$CHROM) {
       chr = chr.pos[which(chr.pos$CHROM == chrom),];
       seg = chr.seg[which(chr.seg$CHROM == chrom),];

       seg$COLOR = none.color
       seg$COLOR[which(seg$IBD == 0)] = ibd0.color
       seg$COLOR[which(seg$IBD == 1)] = ibd1.color
       seg$COLOR[which(seg$IBD == 2)] = ibd2.color

       if (nrow(seg) < 1) { next }
       
       segments((chr$START[1]+seg$START)/1e6, 0.5*(num.indv-i+1), (chr$START[1]+seg$END)/1e6, 0.5*(num.indv-i+1), col=seg$COLOR, lwd=chr.lwd, lend=1);
   }
}

abline(v=chr.pos$END[1:(num.chr-1)]/1e6, col="white", lwd=1);

axis(1, cex.axis=0.75, labels=c(0,as.integer(chr.pos$END/1e6)), at=c(0,chr.pos$END/1e6));
axis(1, cex.axis=2,    labels=chr.map$ALIAS, tick=FALSE, at=(0.5*(chr.pos$START+chr.pos$END))/1e6, padj=1);
axis(2, at=0.5*c(1:num.indv), labels=rev(config[,1]), tick=F);

invisible(dev.off());
