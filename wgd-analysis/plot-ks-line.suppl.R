#!/usr/bin/env Rscript

x.range = c(0.0, 3.0)
y.range = c(0.0, 12.0)

species.labels = c(
  expression(italic("D. alata")*" (dela)"),  # [1]
  expression(italic("D. rotundata")),        # [2]
  expression(italic("D. dumetorum")),        # [3]
  expression(italic("D. zingiberensis")),    # [4]
  expression(italic("A. comosus")),          # [5]
  expression(italic("E. guineensis")),       # [6]
  expression(italic("S. polyrhiza"))         # [7]
)
names(species.labels) = c("DD","DR","DU","DZ","DA","DE","DS")

species.colors = c(
  "#000000",  # [1]
  "#EEAD0E",  # [2]
  "#00688B",  # [3]
  "#8B6507",  # [4]
  "#878787",  # [5]
  "#33C8FF",  # [6]
  "#0000FF"   # [7]
)
names(species.colors) = c("DD","DR","DU","DZ","DA","DE","DS")

DD = read.table("suppl/Dalata-Dalata.ks.m5d20DsSON.clust.primary.anchors", stringsAsFactors=FALSE, header=FALSE);
DR = read.table("suppl/Dalata-Drotundata.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);
DU = read.table("suppl/Dalata-Ddumetorum.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);
DZ = read.table("suppl/Dalata-Dzingiberensis.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);
DA = read.table("suppl/Dalata-Acomosus.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);
DE = read.table("suppl/Dalata-Eguineensis.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);
DS = read.table("suppl/Dalata-Spolyrhiza.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);


DD = DD[which(DD$V3 >= 0 & DD$V3 < 9.9),]
DR = DR[which(DR$V3 >= 0 & DR$V3 < 9.9),]
DU = DU[which(DU$V3 >= 0 & DU$V3 < 9.9),]
DZ = DZ[which(DZ$V3 >= 0 & DZ$V3 < 9.9),]
DA = DA[which(DA$V3 >= 0 & DA$V3 < 9.9),]
DE = DE[which(DE$V3 >= 0 & DE$V3 < 9.9),]
DS = DS[which(DS$V3 >= 0 & DS$V3 < 9.9),]

cat(sprintf("Species             N   med.Ks mean.Ks\n"))
cat(sprintf("D. alata (delta)   %d  %.04f  %.04f\n", nrow(DD), median(DD$V3), mean(DD$V3)))
cat(sprintf("D. rotundata       %d  %.04f  %.04f\n", nrow(DR), median(DR$V3), mean(DR$V3)))
cat(sprintf("D. dumetorum       %d  %.04f  %.04f\n", nrow(DU), median(DU$V3), mean(DU$V3)))
cat(sprintf("D. zingiberensis   %d  %.04f  %.04f\n", nrow(DZ), median(DZ$V3), mean(DZ$V3)))
cat(sprintf("A. comosus         %d  %.04f  %.04f\n", nrow(DA), median(DA$V3), mean(DA$V3)))
cat(sprintf("E. guineensis      %d  %.04f  %.04f\n", nrow(DE), median(DE$V3), mean(DE$V3)))
cat(sprintf("S. polyrhiza       %d  %.04f  %.04f\n", nrow(DS), median(DS$V3), mean(DS$V3)))

DD.hist = hist(DD$V3, breaks=seq(0,max(DD$V3)+0.05,0.05), plot=F)
DR.hist = hist(DR$V3, breaks=seq(0,max(DR$V3)+0.05,0.05), plot=F)
DU.hist = hist(DU$V3, breaks=seq(0,max(DU$V3)+0.05,0.05), plot=F)
DZ.hist = hist(DZ$V3, breaks=seq(0,max(DZ$V3)+0.05,0.05), plot=F)
DA.hist = hist(DA$V3, breaks=seq(0,max(DA$V3)+0.05,0.05), plot=F)
DE.hist = hist(DE$V3, breaks=seq(0,max(DE$V3)+0.05,0.05), plot=F)
DS.hist = hist(DS$V3, breaks=seq(0,max(DS$V3)+0.05,0.05), plot=F)


pdf("ks-line.suppl.pdf")
plot(DR.hist$mids, DR.hist$density, col=species.colors["DR"], lwd=3, type='l',
     axes=FALSE, xlab="Ks", ylab="Density", cex.lab=1.5, xlim=c(0,3), ylim=c(0,12))
lines(DU.hist$mids, DU.hist$density, col=species.colors["DU"], lwd=3)
lines(DZ.hist$mids, DZ.hist$density, col=species.colors["DZ"], lwd=3)
lines(DS.hist$mids, DS.hist$density, col=species.colors["DS"], lwd=3)
lines(DA.hist$mids, DA.hist$density, col=species.colors["DA"], lwd=3)
lines(DE.hist$mids, DE.hist$density, col=species.colors["DE"], lwd=3)
lines(DD.hist$mids, DD.hist$density, col=species.colors["DD"], lwd=3, lty=1)
axis(1, cex.axis=1.5)
axis(2, cex.axis=1.5)
legend("topright", species.labels, fill=species.colors, bty='n')
invisible(dev.off())

