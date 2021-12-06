#!/usr/bin/env Rscript

x.range = c(0.0, 2.5)
y.range = c(0.0, 3.0)

species.labels = c(
  expression(italic("D. alata")*" (delta)"), # [1]
  expression(italic("D. alata")*" (tau)"),   # [2]
  expression(italic("D. rotundata")),        # [3]
  expression(italic("T. zeylanicus")),       # [4]
  expression(italic("A. comosus")),          # [5]
  expression(italic("S. polyrhiza"))         # [6]
)

names(species.labels) = c("DD","Dd","DR","DT","DA")

species.colors = c(
  "#000000",  # [1] black
  "#0000FF",  # [2] blue
  "#E0A624",  # [3] gold
  "#D7B3A0",  # [4] tan
  "#774600",  # [5] brown
  "#7F7F7F"   # [6] grey
)
names(species.colors) = c("DD","Dd","DR","DT","DA","DS")

DD = read.table("main/Dalata-Dalata.ks.m5d20DsSON.clust.primary.anchors", stringsAsFactors=FALSE, header=FALSE)
Dd = read.table("main/Dalata-Dalata.ks.m5d20DsSON.clust.secondary.anchors", stringsAsFactors=FALSE, header=FALSE)
DR = read.table("main/Dalata-Drotundata.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE)
DT = read.table("main/Dalata-Tzeylanicus.kaks.m10d20s0.25O0.25.clust.anchors", stringsAsFactors=FALSE, header=FALSE)
DA = read.table("main/Dalata-Acomosus.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE)
DS = read.table("main/Dalata-Spolyrhiza.ks.m5d20sSON.clust.anchors", stringsAsFactors=FALSE, header=FALSE);


cat(sprintf("Species                N   med.Ks mean.Ks\n"))
cat(sprintf("D. alata (delta)      %d  %.04f  %.04f\n", nrow(DD), median(DD$V3), mean(DD$V3)))
cat(sprintf("D. alata (tau)        %d  %.04f  %.04f\n", nrow(Dd), median(Dd$V3), mean(Dd$V3)))
cat(sprintf("D. rotundata          %d  %.04f  %.04f\n", nrow(DR), median(DR$V3), mean(DR$V3)))
cat(sprintf("T. zeylanicus         %d  %.04f  %.04f\n", nrow(DT), median(DT$V3), mean(DT$V3)))
cat(sprintf("A. comosus            %d  %.04f  %.04f\n", nrow(DA), median(DA$V3), mean(DA$V3)))
cat(sprintf("S. polyrhiza          %d  %.04f  %.04f\n", nrow(DS), median(DS$V3), mean(DS$V3)))

DA.hist = hist(DA$V3, breaks=seq(0,max(DA$V3)+1,0.05), plot=F)
DD.hist = hist(DD$V3, breaks=seq(0,max(DD$V3)+1,0.05), plot=F)
Dd.hist = hist(Dd$V3, breaks=seq(0,max(Dd$V3)+1,0.05), plot=F)
DR.hist = hist(DR$V3, breaks=seq(0,max(DR$V3)+1,0.05), plot=F)
DT.hist = hist(DT$V3, breaks=seq(0,max(DT$V3)+1,0.05), plot=F)
DS.hist = hist(DS$V3, breaks=seq(0,max(DS$V3)+1,0.05), plot=F)

# rescale Dalata-Drotundata down to 25% of its height, so as to emphasize the other comparisons:
DR.hist$density = 0.25 * DR.hist$density

DD.smooth = ksmooth(DD.hist$mids, DD.hist$density, bandwidth=0.25, n.points=length(DD.hist$mids))
Dd.smooth = ksmooth(Dd.hist$mids, Dd.hist$density, bandwidth=0.25, n.points=length(Dd.hist$mids))

pdf("ks-line.pdf")
plot(DR.hist$mids, DR.hist$density, lwd=3, lty=1, col=species.colors["DR"], type='l',
     axes=F, xlab="Ks", ylab="Relative density", cex.lab=1.4, xlim=x.range, ylim=y.range)
lines(DS.hist$mids, DS.hist$density, lwd=3, lty=1, col=species.colors["DS"])
lines(DA.hist$mids, DA.hist$density, lwd=3, lty=1, col=species.colors["DA"])
lines(DT.hist$mids, DT.hist$density, lwd=3, lty=1, col=species.colors["DT"])
lines(Dd.smooth$x, Dd.smooth$y, lwd=4, lty=2, col=species.colors["Dd"])
lines(DD.hist$mids, DD.hist$density, lwd=4, lty=2, col=species.colors["DD"])

axis(1)
axis(2)
legend("topright", species.labels, fill=species.colors, bty='n')
invisible(dev.off())

