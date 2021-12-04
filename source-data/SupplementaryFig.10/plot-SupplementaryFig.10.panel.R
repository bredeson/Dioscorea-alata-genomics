#!/usr/bin/env Rscript

argv = commandArgs(TRUE)

table.file = argv[[1]]
pdf.file = argv[[2]]

data = read.table(table.file, stringsAsFactors=FALSE, header=TRUE)

x = rbind(
    data.frame(
        state=rep("A", nrow(data)),
        retention=data$A.retention
    ),
    data.frame(
        state=rep("B", nrow(data)),
        retention=data$B.retention
    )
);

pdf(pdf.file, width=10)
require(ggplot2)
ggplot(x, aes(retention, fill=state, color=state)) + geom_density(aes(y=15/512*..count..), alpha=0.3, adjust=1, n=512) + scale_fill_manual(values=c("#EEAD0E","#00B2EE")) + scale_color_manual(values=c("#EEAD0E","#00B2EE")) + geom_histogram(aes(y=..count..), alpha=0.5, binwidth=0.025) + xlim(0.3, 0.8) + geom_vline(xintercept=median(x$retention), linetype='dashed') + ylab("Frequency") + xlab("Retention")

invisible(dev.off())
