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

library(gplots, quietly=T)
library(vegan, quietly=T)

options(digits=6)

#################################################################################
# Load species-specific information
#################################################################################
setwd("./chr-structure")
species.name = "Dalata-v2"
species.dir = "."
hic.dir = "KRdump100kb"
win.length = 1e5
comparator = 2  # vector index of reference comparator chromosome 

chr.length = read.table(sprintf("%s/%s.chrom.sizes",species.dir,species.name), stringsAsFactors=F)
chr.names  = chr.length[,1]
chr.length = chr.length[,2]
chr.count  = length(chr.names)
chr.index  = 1:chr.count
names(chr.length) = chr.names
names(chr.index) = chr.names

arm.length = read.table(sprintf("%s/%s.chrom.arm.sizes",species.dir,species.name), stringsAsFactors=F)
arm.names  = arm.length[,1]
arm.length = arm.length[,2]
arm.count  = length(arm.names)
arm.index  = 1:arm.count
names(arm.length) = arm.names
names(arm.index) = arm.names

# If species has dimorphic sex chromosomes, run the following to omit them:
# chr.names  = chr.names[grep('[XY]', chr.names, invert=T, perl=T)]
# chr.length = chr.length[chr.names]
# chr.index  = chr.index[chr.names]
# chr.count  = length(chr.names)
# arm.names  = arm.names[grep('[XY]', arm.names, invert=T, perl=T)]
# arm.length = arm.length[arm.names]
# arm.index  = arm.index[arm.names]
# arm.count  = length(arm.names)



#################################################################################
# Define useful functions
#################################################################################
# Define color palettes:
ryb.palette = colorRampPalette(c("red","yellow","blue"))
cwm.palette = colorRampPalette(c("darkcyan","cyan","white","magenta","red"))
wpr.palette = colorRampPalette(c("white","pink","red"))
bwr.palette = colorRampPalette(c("blue","white","red"))
bwy.palette = colorRampPalette(c("#4e98bb","white","#F6C34B"))
bky.palette = colorRampPalette(c("#4e98bb","black","#F6C34B"))
bkr.palette = colorRampPalette(c("blue","black","red"))
heat.palette = colorRampPalette(c("cyan","blue","black","red","yellow"))
cwy.palette = colorRampPalette(c("blue","#189dc9","#189dc9","white","#F6C34B","#F6C34B","yellow"))

# Define useful functions:
read.hicmatrix = function(filename, transform=function(x){x}) {
  input.matrix = as.matrix(read.table(filename, stringsAsFactors=F, row.names=NULL))
  colnames(input.matrix) = NULL
  rownames(input.matrix) = NULL
  return(transform(input.matrix))
}

plot.hicmatrix = function(M, pal=heat.palette, center=0, window.size=1, x.axis=1, y.axis=2) {
  axis.labels = "Window Index"
  if (window.size > 1) {
    window.size = window.size / 1e6
    axis.labels = "Position (Mb)"
  }
  #  color.step = 2 / n.colors
  image(M, col=adj.color.range(M, center, 100000, pal), axes=F, xlab='', ylab='')
  row.idx = seq(0, nrow(M)-1, 10)
  col.idx = seq(0, ncol(M)-1, 10)
  axis(x.axis, at=row.idx/nrow(M), labels=row.idx*window.size)  # Plot X-axis
  axis(y.axis, at=col.idx/ncol(M), labels=col.idx*window.size)  # Plot Y-axis
  x.adj = 3
  y.adj = 3
  if (x.axis == 3) {
    x.adj = -3
  }
  if (y.axis == 2) {
    y.adj = -3
  }
  mtext(axis.labels, x.axis, padj=x.adj, cex=1)
  mtext(axis.labels, y.axis, padj=y.adj, cex=1)
}

trim.matrix = function(M, q=6) {
  M.vec = na.omit(c(M))
  iqr.max = median(M.vec) + q * IQR(M.vec)
  iqr.min = median(M.vec) - q * IQR(M.vec)
  
  M[which(M > iqr.max)] = iqr.max
  M[which(M < iqr.min)] = iqr.min
  return(M)
}

resign.pc = function(pca, npc=function(x) {length(x$rotation[1,])}) {
  num.pc = NULL
  determine.pc.sign = function(y) {
    L = length(y)
    x = 1:L
    m = as.integer(L / 2)
    l.cor = cor(x[1:m], y[1:m], method="kendall")
    r.cor = cor(x[m:L], y[m:L], method="kendall")
  
    if ((l.cor > 0) & (r.cor > 0)) {
      return(-1)
    } else if ((l.cor < 0) & (r.cor > 0)) {
      return(-1)
    } else {
      return(1)
    }
  }
  if (class(npc) == "function") {
    num.pc = npc(pca)
  } else {
    num.pc = npc
  }
  for (i in 1:num.pc) {
    pc.sign = determine.pc.sign(pca$rotation[,i])
    pca$rotation[,i] = pc.sign * pca$rotation[,i]
  }
  return(pca)
}

jitter.invariant = function(M, amount=0.0001) {
  invariants = which(is.na(apply(M, 2, var)))
  if (any(invariants)) {
    warning(sprintf("Zero-variance columns detected (n=%s), minimum map resolution exceeded", length(invariants)), call.=F,immediate.=T)
    r = runif(nrow(M), 0, amount)
    M[,invariants] = r
  }
  invariants = which(is.na(apply(M, 1, var)))
  if (any(invariants)) {
    warning(sprintf("Zero-variance rows detected (n=%s), minimum map resolution exceeded", length(invariants)), call.=F,immediate.=T)
    r = runif(ncol(M), 0, amount)
    M[invariants,] = r
  }
  return(M)
}

replace.inf = function(M, amount=0.0) {
  has.inf = which(is.infinite(M))
  if (any(has.inf)) {
    warning(paste("Infinite values detected (n=",length(has.inf),")", sep=''), call.=F,immediate.=T)
    M[which(is.infinite(M))] = amount
  }
  return(M)
}

calc.expected = function(observed, mask=NULL, counts=FALSE) {
  if (! is.null(mask)) {
    observed = observed * mask
  }
  row.margin = apply(observed, 1, sum)
  col.margin = apply(observed, 2, sum)
  row.margin = row.margin / sum(row.margin)
  col.margin = col.margin / sum(col.margin)
  expected = row.margin %*% t(col.margin)
  if (! is.null(mask)) {
    expected = expected * mask
  }
  expected = expected / sum(expected)  # Adjust for mask
  
  if (counts){
    expected = expected * sum(observed)
  }
  return(expected)
}

adj.color.range = function(M, center=1, n=10000, pal=heat.colors) {
  M.rng = range(na.omit(c(M)));
  r.max = max(abs(M.rng - center));
  r.min = center - r.max;
  c.rng = (M.rng - r.min) / (2 * r.max);
  c.adj = as.integer(n / diff(c.rng));
  c.pal = pal(c.adj);
  return(c.pal[ as.integer(c.adj * c.rng[1]) : as.integer(c.adj * c.rng[2]) ])
}

balance.hicmatrix = function(observed) {
  expected = calc.expected(observed, counts=T)
  log.observed = log10(observed)
  log.expected = log10(expected)
  log.oe = log.observed / log.expected 
  log.oe[is.infinite(log.oe)] = NA
  log.oe[is.nan(log.oe)] = NA
  log.oe = trim.matrix(log.oe, q=3)
  log.oe[is.na(log.oe)] = 1.0
  return(log.oe)
}

inter.prcomp = function(inter.matrix) {
  inter.pca = prcomp(inter.matrix, center=T, scale=T)
  inter.pca = resign.pc(inter.pca)
  inter.pca$importance = summary(inter.pca)$importance
  return(inter.pca)
}

plot.prcomp = function(pca, centromere=0, window.size=0) {
  n.bins = length(pca$rotation[,1])
  pc1 = pca$rotation[,1]
  pc2 = pca$rotation[,2]
  idx = seq(0, n.bins - 1)
  tic = seq(0, n.bins, 10)
  pos = idx
  pos.lab = "Window Index"
  if (window.size > 0) {
    pos = window.size * pos / 1e6
    tic = window.size * tic / 1e6
    pos.lab = "Position (Mb)"
  }
  
  pc1.smooth = ksmooth(pos, pc1, n.points=n.bins, bandwidth=as.integer(0.1*n.bins*(window.size/1e6)))$y
  pc2.smooth = ksmooth(pos, pc2, n.points=n.bins, bandwidth=as.integer(0.1*n.bins*(window.size/1e6)))$y
  
  is.na(pc1.smooth)
  is.na(pc2.smooth)
  
  bk = colorRampPalette(c("#4e98bbff","#4e98bbff","#4e98bbff","black"))
  ky = colorRampPalette(c("black","#F6C34B","#F6C34B","#F6C34B"))
  
  arm.p = bk(centromere)
  arm.q = ky(n.bins-centromere)
  
  par.mfrow = par("mfrow")
  par.mar = par("mar")
  par(mfrow=c(2,2), cex.axis=1, cex.lab=1.5)
  
  par(mar=c(0.5,4.5,4.5,0.5), cex.lab=1.5)
  plot.hicmatrix(pca$M, pal=cwy.palette, center=median(na.omit(c(pca$M))), window.size=window.size, x.axis=3, y.axis=2)
  
  par(mar=c(0.5,0.5,4.5,4.5))
  plot(pc1, pos, bty='n', col="grey80", pch=20, cex=1, main='', xlab='', ylab='', axes=F)
  points(pc1.smooth, pos, col=c(arm.p, arm.q), pch=20, cex=1)
  mtext("PC 1", 3, padj=-2.5, cex=1.5)
  mtext(pos.lab, 4, padj=2.5, cex=1.5)
  axis(3)
  axis(4, at=tic, labels=tic)
  
  par(mar=c(4.5,4.5,0.5,0.5))
  plot(pos, pc2, bty='n', col="grey80", pch=20, cex=1, main='', xlab='', ylab='', axes=F)
  points(pos, pc2.smooth, col=c(arm.p, arm.q), pch=20, cex=1)
  mtext(pos.lab, 1, padj=2.5, cex=1.5)
  mtext("PC 2", 2, padj=-2.5, cex=1.5)
  axis(1, at=tic, labels=tic)
  axis(2)
  
  par(mar=c(4.5,0.5,0.5,4.5))
  plot(pc1, pc2, bty='n', col="grey80", pch=20, cex=1, main='', xlab='', ylab='', axes=F)
  points(pc1.smooth, pc2.smooth, col=c(arm.p, arm.q), pch=20, cex=1)
  mtext("PC 1", 1, padj=2.5, cex=1.5)
  mtext("PC 2", 4, padj=2.5, cex=1.5)
  axis(1)
  axis(4)
  
  par(mfrow=par.mfrow)
  par(mar=par.mar)
}

hist.prcomp = function(pca, pc=1, window.size=1) {
  axis.labels = "Window Index"
  if (window.size > 1) {
    window.size = window.size / 1e6
    axis.labels = "Position (Mb)"
  }
  fig.dim = par("fin")
  bin.width = 2 * fig.dim / 7 * (250 / length(pca$rotation[,pc]))
  plot(pca$rotation[,pc], type='h', axes=F, lend=1, lwd=bin.width, col="black", xlab=axis.labels, ylab=pc, xaxs='i')
  row.idx = seq(0, length(pca$rotation[,pc])-1, 10)
  axis(1, at=row.idx, labels=window.size*row.idx)
  axis(2)
}


#################################################################################
# Inter-chromosomal PCA of log10("observed") matrix to call Rabl structure
#################################################################################

# We want to plot the inter-chromosomal contact patterns between two chromosomes;
# when the comparator chromosome (Chr[i]) is the chromosome of interest (Chr[j])
# we must transpose the matrix, as juicer_tools dumps the lower triangle.
dir.create("rabl", showWarnings=FALSE)
for (Q in c(30)) {  # c(0, 30)) {
  transform = function(x){x}
  for (i in 1:chr.count) {
    cmp.name = chr.names[comparator]
    chr.name = chr.names[i]
    in1.name = cmp.name
    in2.name = chr.name
    if (chr.index[in1.name] == chr.index[in2.name]) {
      if (comparator < chr.count) {
        in1.name = chr.names[comparator + 1]
      } else {
        in1.name = chr.names[comparator - 1]
      }
    }
    if (chr.index[in1.name] > chr.index[in2.name]) {
      tmp.name = in1.name
      in1.name = in2.name
      in2.name = tmp.name
      transform = t
    }
    inter.matrix = read.hicmatrix(sprintf("%s/%s/%s-%s.MQ%s.obs.matrix.gz", species.dir, hic.dir, in1.name, in2.name, Q), transform)
    inter.matrix = replace.inf(inter.matrix)
    inter.matrix = jitter.invariant(inter.matrix)
    inter.pca = inter.prcomp(inter.matrix)
    warn.pc1 = all(inter.pca$rotation[,1] > 0.0) | all(inter.pca$rotation[,1] < 0.0)
    warn.pc2 = all(inter.pca$rotation[,2] > 0.0) | all(inter.pca$rotation[,2] < 0.0)
    if (warn.pc1 | warn.pc2) {
      warning(sprintf("Signficant missing data: %s, %s",species.name, chr.name))
    }
    inter.pca$M = balance.hicmatrix(inter.matrix)
    pdf(sprintf("%s/rabl/%s-%s.MQ%s.obs.rabl.pdf", species.dir, cmp.name, chr.name, Q), height=7, width=7)
    plot.prcomp(inter.pca, as.integer(round(arm.length[2*i-1] / win.length, 0)), window.size=win.length)
    invisible(dev.off())
    transform = function(x){x}
  }
}




