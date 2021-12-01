#!/usr/bin/env Rscript

# Copyright (c)2013. The Regents of the University of California (Regents).
# All Rights Reserved. Permission to use, copy, modify, and distribute this
# software and its documentation for educational, research, and
# not-for-profit purposes, without fee and without a signed licensing
# agreement, is hereby granted, provided that the above copyright notice,
# this paragraph and the following two paragraphs appear in all copies,
# modifications, and distributions. Contact The Office of Technology
# Licensing, UC Berkeley, 2150 Shattuck Avenue, Suite 510, Berkeley, CA
# 94720-1620, (510) 643-7201, for commercial licensing opportunities.

# Created by Jessen V. Bredeson, Department of Molecular and Cell Biology, 
# University of California, Berkeley.

# IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
# SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
# ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
# REGENTS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

# REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
# HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
# MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

setwd("./chr-landscape")

num.rows = 3
max.y1 = 200
min.y1 = -max.y1 / 3
inc.y1 = 50
max.y2 = 30
min.y2 = 0
scale.y2 = max.y1/max.y2
inc.y2 = inc.y1 / scale.y2

cum.length = function(lengths, named=FALSE) {
  cumlengths = cumsum(lengths)
  if (named) {
    names(cumlengths) = names(lengths)
  }
  return(cumlengths)
}
cum.offset = function(lengths, named=FALSE) {
  cumoffsets = cumsum(lengths) - lengths
  if (named) {
    names(cumoffsets) = names(lengths)
  }
  return(cumoffsets)
}
as.named.vector = function(dataframe, name.col=1, data.col=2) {
  named.vector = dataframe[,data.col]
  names(named.vector) = dataframe[,name.col]
  return(named.vector)
}
select = function(data, data.subset, data.col=NULL) {
  if (is.null(data.col)) {
    return(data[which(data %in% data.subset)]);
  } else {
    return(data[which(data[,data.col] %in% data.subset),])
  }
}

# Chromosome sizes to layout the genome space:
chrom.sizes = read.table("Dalata-v2.chrom.sizes", stringsAsFactors=FALSE)
chrom.sizes = as.named.vector(chrom.sizes)
chrom.names = names(chrom.sizes)

# Protein-coding genes (count)
gene.density = read.table("Dalata-v2.w500kb.gene.bed", stringsAsFactors=FALSE)
gene.scale = 1e6 / max(gene.density[,3] - gene.density[,2])
gene.color = "#0036BC"

#gap.positions = read.table("Dalata-v2.gap.bed", stringsAsFactors=FALSE)
#gap.color = "black"

# Transposable Element Repeat Sequences (TERS):
ters.density = read.table("Dalata-v2.w500kb.te.bed",stringsAsFactors=FALSE)
ters.density[,4] = ters.density[,4] / (ters.density[,3] - ters.density[,2])
ters.color = "#D7B3A0"

# Low-Complexity Repeat Sequences (LCRS):
lcrs.density = read.table("Dalata-v2.w500kb.lc.bed",stringsAsFactors=FALSE)
lcrs.density[,4] = lcrs.density[,4] / (lcrs.density[,3] - lcrs.density[,2])
lcrs.color = "#774600"

# Recombination density:
recom.density = read.table("Dalata-v2.w500kb.rec.bed", stringsAsFactors=FALSE)
recom.scale = 1e6 / max(recom.density[,3] - recom.density[,2])
recom.color = "#33C8FF"

# Genetic linkage map marker positions:
map.positions = read.table("composite.5pop.map", stringsAsFactors=FALSE)
map.color = "black"

# A/B compartment domain blocks
ABdom.blocks = read.table("Dalata-v2.AB.ori.col.bedgraph", stringsAsFactors=FALSE)
ABdom.color = c("#EEAD0E","#009ACD")

panel.num = 0
panel.max = 0
panel.sum = Inf
panel.names = list()
panel.width = sum(chrom.sizes) / num.rows
for (i in 1:length(chrom.names)) {
  if ((panel.sum + 0.5*chrom.sizes[chrom.names[i]]) <= panel.width) {
    panel.names[[panel.num]] = append(panel.names[[panel.num]], chrom.names[i])
    panel.sum = panel.sum + chrom.sizes[chrom.names[i]]
    panel.max = max(panel.max, panel.sum)
  } else {
    panel.names[[panel.num + 1]] = c(chrom.names[i])
    panel.sum = chrom.sizes[chrom.names[i]]
    panel.num = panel.num + 1
  }
}
panel.sizes = lapply(panel.names, function(name) {chrom.sizes[name]})
panel.begs  = lapply(panel.sizes, function(lens) {cum.offset(lens, named=TRUE)})
panel.ends  = lapply(panel.sizes, function(lens) {cum.length(lens, named=TRUE)})

for (i in 1:num.rows) {
  panel.gene.density = select(gene.density, panel.names[[i]], data.col=1)
  panel.gene.density[,2] = (panel.begs[[i]][panel.gene.density[,1]] + panel.gene.density[,2]) / 1e6
  panel.gene.density[,3] = (panel.begs[[i]][panel.gene.density[,1]] + panel.gene.density[,3]) / 1e6

  panel.ters.density = select(ters.density, panel.names[[i]], data.col=1)
  panel.ters.density[,2] = (panel.begs[[i]][panel.ters.density[,1]] + panel.ters.density[,2]) / 1e6
  panel.ters.density[,3] = (panel.begs[[i]][panel.ters.density[,1]] + panel.ters.density[,3]) / 1e6

  panel.lcrs.density = select(lcrs.density, panel.names[[i]], data.col=1)
  panel.lcrs.density[,2] = (panel.begs[[i]][panel.lcrs.density[,1]] + panel.lcrs.density[,2]) / 1e6
  panel.lcrs.density[,3] = (panel.begs[[i]][panel.lcrs.density[,1]] + panel.lcrs.density[,3]) / 1e6

#  panel.gap.positions = select(gap.positions, panel.names[[i]], data.col=1)
#  panel.gap.positions[,2] = (panel.begs[[i]][panel.gap.positions[,1]] + panel.gap.positions[,2]) / 1e6
#  panel.gap.positions[,3] = (panel.begs[[i]][panel.gap.positions[,1]] + panel.gap.positions[,3]) / 1e6

  panel.recom.density = select(recom.density, panel.names[[i]], data.col=1)
  panel.recom.density[,2] = (panel.begs[[i]][panel.recom.density[,1]] + panel.recom.density[,2]) / 1e6
  panel.recom.density[,3] = (panel.begs[[i]][panel.recom.density[,1]] + panel.recom.density[,3]) / 1e6

  panel.map.positions = select(map.positions, panel.names[[i]], data.col=1)
  panel.map.positions[,4] = (panel.begs[[i]][panel.map.positions[,1]] + panel.map.positions[,4]) / 1e6

  panel.ABdom.blocks = select(ABdom.blocks, panel.names[[i]], data.col=1)
  panel.ABdom.blocks[,2] = (panel.begs[[i]][panel.ABdom.blocks[,1]] + panel.ABdom.blocks[,2]) / 1e6
  panel.ABdom.blocks[,3] = (panel.begs[[i]][panel.ABdom.blocks[,1]] + panel.ABdom.blocks[,3]) / 1e6

  pdf(sprintf("genome-structure.panel-%d.pdf", i), height=3, width=10)
  par(mar=c(4.1,6.1,1.1,2.1))
  plot(c(0, sum(panel.sizes[[i]])) / 1e6, c(0, 0),
       xlim=c(0, panel.max/1e6),
       ylim=c(min.y1, max.y1+10),
       xlab="Chromosome",
       ylab="Genes / Mb\n% TEs / Mb",
       cex.lab=1.5,
       col="black",
       type='l',
       lwd=4,
       bty='n',
       axes=FALSE
  )
  # mtext("% LC sequences / Mb\ncM / Mb", 4, outer=TRUE, cex.lab=1.5)
  segments(panel.map.positions[,4], 0, panel.map.positions[,4], min.y1/4, lwd=0.001)

  panel.ABdom.blocks.A = panel.ABdom.blocks[which(panel.ABdom.blocks[,4] > 0),]
  panel.ABdom.blocks.B = panel.ABdom.blocks[which(panel.ABdom.blocks[,4] < 0),]
  rect(panel.ABdom.blocks.A[,2], 0.75*min.y1, panel.ABdom.blocks.A[,3], 0.75*min.y1-min.y1/4, border=FALSE, col=ABdom.color[1])
  rect(panel.ABdom.blocks.B[,2], 0.75*min.y1, panel.ABdom.blocks.B[,3], 0.75*min.y1+min.y1/4, border=FALSE, col=ABdom.color[2])

  abline(v=panel.begs[[i]][2:length(panel.begs[[i]])]/1e6, lwd=0.2, col="white")

  rect(panel.begs[[i]]/1e6, 0, panel.ends[[i]]/1e6, 1.1*max.y1, col=c("#E5E5E5","white"), border=FALSE)

  lines(0.5*(panel.ters.density[,2]+panel.ters.density[,3]), 100.0*panel.ters.density[,4],
       col=ters.color,
       lwd=2.75
  )  
  lines(0.5*(panel.gene.density[,2]+panel.gene.density[,3]), panel.gene.density[,4] * gene.scale,
       col=gene.color,
       lwd=2.75
  )
  lines(0.5*(panel.recom.density[,2]+panel.recom.density[,3]), panel.recom.density[,4] * recom.scale * scale.y2,
       col=recom.color,
       lwd=2.75
  )
  lines(0.5*(panel.lcrs.density[,2]+panel.lcrs.density[,3]), 100.0*panel.lcrs.density[,4] * scale.y2,
       col=lcrs.color,
       lwd=2.0
  )
  
  axis(1, at=0.5*(panel.begs[[i]]+panel.ends[[i]]) / 1e6, labels=sub('Chr','',panel.names[[i]]), cex.axis=1.5, tick=FALSE, line=FALSE)
  axis(2, at=seq(0,max.y1,inc.y1))
  axis(4, at=seq(0,max.y1,inc.y1), labels=seq(0,max.y2,inc.y2))

  invisible(dev.off())
}
quit("no",1)
