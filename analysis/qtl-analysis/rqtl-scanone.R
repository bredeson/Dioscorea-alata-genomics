#!/usr/bin/env Rscript

require(qtl)

arguments = unlist(commandArgs(TRUE))

cross = read.cross("csvr",,arguments[1])
cross = jittermap(cross)

cross.prb = calc.genoprob(cross, step=1, error.prob=0.001)
cross.em  = scanone(cross.prb, method="em")
cross.em.perm = scanone(cross.prb, n.perm=1000, method="em")

min.lod.em = summary(cross.em.perm, alpha=0.05)[1]

cross.sim = sim.geno(cross, n.draws=256, step=1, error.prob=0.001)
cross.imp = scanone(cross.sim, method="imp")
cross.imp.perm = scanone(cross.sim, n.perm=1000, method="imp")

min.lod.imp = summary(cross.imp.perm, alpha=0.05)[1]

max.y = 1.5 * max(min.lod.imp, min.lod.em)

pdf(sprintf("%s.scan.pdf",arguments[2]), width=14)
plot(cross.em, cross.imp, col=c("red","blue"), ylim=c(0,max.y))
abline(h=c(min.lod.em, min.lod.imp), col=c("red","blue"), lty=3)
legend("topright",c("SIM","MIMP"), fill=c("red","blue"))
invisible(dev.off())

pdf(sprintf("%s.lod.pdf",arguments[2]), width=14)
par(mfrow=c(1,2))
plot(cross.em.perm)
abline(v=min.lod.em, col="red", lty=3)

plot(cross.imp.perm)
abline(v=min.lod.imp, col="blue", lty=3)
invisible(dev.off())

savehistory(paste(arguments[2], 'Rhistory', sep='.'))
save.image(paste(arguments[2], 'Rdata', sep='.'))

quit("no",0)


