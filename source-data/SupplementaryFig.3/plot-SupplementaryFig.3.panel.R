#!/usr/bin/env Rscript

arguments = commandArgs(TRUE)

if (length(arguments) != 3) {
   cat("Usage: plot-SupplementaryFig.3.R <med.depth> <bin-width> <out-pdf>\n", file=stderr());
   quit(status=1);
}

mdp.file = arguments[[1]]
bin.width = as.numeric(arguments[[2]])
out.file = arguments[[3]]

data = read.table(mdp.file, stringsAsFactors=FALSE, header=TRUE)

depths = unique(sort(as.integer(data$MedianDepth / bin.width)))
weights = rep(0, length(depths))
names(weights) = as.character(depths)

total = sum(data$ContigLength)

for (i in 1:nrow(data)) {
    k = as.character(as.integer(data$MedianDepth[i] / bin.width));
    weights[k] = weights[k] + data$ContigLength[i]
}

pdf(out.file, width=14)
par(mfrow=c(1,2))
plot(
    log10(data$ContigLength),
    data$MedianDepth,
    pch=16,
    cex=0.75,
    col=rgb(0,0,1,0.1),
    ylim=c(0,200),
    ylab="Median contig depth",
    xlab=bquote("log"[10] ~ "contig length"),
    main="",
    cex.lab=1.5
)
plot(
    weights[as.character(depths)] / total,
    bin.width * depths,
    type='l',
    lwd=1.5,
    col="blue",
    ylim=c(0,200),
    ylab="Median contig depth",
    xlab="Contig length-weighted density",
    cex.lab=1.5
)

invisible(dev.off())
