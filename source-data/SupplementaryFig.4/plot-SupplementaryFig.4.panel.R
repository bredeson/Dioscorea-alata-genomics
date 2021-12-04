#!/usr/bin/env Rscript

args = commandArgs(TRUE);

if (as.logical(length(args) < 3)) {
   cat("Usage: plotSnvRateHist.R <accname> <snv.rate> <binwidth> [Xmax] [Ymax]\n");
   q(status=1);
}

accname = args[1];
datfile = args[2];
binwidth = as.numeric(args[3]);
xmax = args[4];
ymax = args[5];

data = read.table(datfile, header=T);
rt1  = data[which(data$HET != -1), ];
rt2  = data[which(data$HOM != -1), ];
mx1  = max(rt1$HET);
mx2  = max(rt2$HOM);

if (as.logical(length(args) < 4)) {
    xmax = 0.99 * max(mx1,mx2);
} else {
    xmax = as.numeric(xmax);
}

break_min = min(min(rt1$HET), min(rt2$HOM))
break_max = max(max(rt1$HET), max(rt2$HOM))


hist1 = hist(rt1$HET, breaks=seq(break_min, break_max+binwidth, binwidth), plot=F);
hist2 = hist(rt2$HOM, breaks=seq(break_min, break_max+binwidth, binwidth), plot=F);
pdf(paste(accname,'hist','pdf',sep='.'));

hist1$freq = hist1$counts/sum(hist1$counts)
hist2$freq = hist2$counts/sum(hist2$counts)

if (as.logical(length(args) < 5)) {
    ymax = max(hist1$freq, hist2$freq);
} else {
    ymax = as.numeric(ymax);
    if (ymax < 0) {
       ymax = max(hist1$freq, hist2$freq);
    }
}


plot(hist1$mids,hist1$freq, col=0, type='l', xlim=c(0,xmax), ylim=c(0,ymax), main=paste(accname), xlab="Rate", ylab="Density", cex.lab=1.5);
rect(-0.05*xmax, -0.05*ymax, 0.0002, 1.05*ymax, col="#00688BBF", border=FALSE)
rect(0.0002, -0.05*ymax, 0.0175, 1.05*ymax, col="#69DFFF66", border=FALSE)
rect(0.0175, -0.05*ymax, 1.05*xmax, 1.05*ymax, col="#FFC12566", border=FALSE)
lines(hist2$mids,hist2$freq, col="grey50",lwd=3)
lines(hist1$mids,hist1$freq, col="black", lwd=3)
legend("topright", c("Heterozygous","Homozygous"), col=c("black","grey50"), lwd=2, bty='n')

invisible(dev.off());
