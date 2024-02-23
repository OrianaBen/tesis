library(RGPR)
myDir <- "C:\\Users\\Oriana\\Documents\\Uni\\Tesis\\tesis\\gpr_method"
setwd(myDir)

#leer y graficar data cruda
x <- readGPR(dsn = "rawGPR/4AusbPER.ZON/TF510001.dt")
png('rawdata.png')
plot(x, col=palGPR("hcl-8"))
dev.off()

#estimacion de primera llegada y t0, y grafica para cada traza
time0(x)

png('firstbreak.png')
tfb <- firstBreak(x, method = "threshold", thr = 0.2)
plot(pos(x), tfb, ylab = "first wave break", xlab = "position (m)")
dev.off()

t0 <- firstBreakToTime0(tfb, x)
time0(x) <- mean(t0)

png('timezero_firstb.png')
plot(x[, 30], xlim = c(0, 20))
abline(v = tfb[30], col = "blue")
dev.off()

plot(x[,15])