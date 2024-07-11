Sys.setenv("LANGUAGE" = "Sp")
library(RGPR)
myDir <- "C:\\Users\\Oriana\\Uni\\Tesis\\tesis\\gpr_method"
setwd(myDir)
source("myplot.R")

#leer y graficar data cruda
x <- readGPR(dsn = "rawGPR/C1-C2.ZON/TF510001.dt", Vmax = NULL,
             method = c("spline", "spline", "spline"))

antfreq(x) <- 200

png("C1-C2-compar/rawdata.png", width = 900, height = 300, units = "px")
plot(x, col = palGPR("gray"), ylim = c(0, 80), barscale = FALSE, clab = "",
     addTime0 = FALSE, asp = 0.1, note = "", main = "", 
     cex.lab = 1.5, cex.axis = 1.2)
dev.off()

# #estimacion de primera llegada y t0, y grafica para cada traza
time0(x)

png("C1-C2-compar/firstbreak.png")
tfb <- firstBreak(x, w = 4, method = "MER")
plot(pos(x), tfb, ylab = "first wave break", xlab = "position (m)")
dev.off()

t0 <- firstBreakToTime0(tfb, x)
time0(x) <- mean(t0)

png("C1-C2-compar/timezero_firstb.png")
plot(x[, 15], xlim = c(0, 50))
abline(v = tfb[15], col = "blue")
dev.off()

x1 <- dcshift(x, u = 1:120)
proc(x1)

png("C1-C2-compar/timezerocorrec.png")
x2 <- time0Cor(x1, method = "spline")
plot(x2)
dev.off()

#dewow componente de baja frecuencia a partir de mediana
png("C1-C2-compar/dewow.png")
x3 <- dewow(x2, type = c("gaussian"), w = 1)
plot(x3)
dev.off()

png("C1-C2-compar/removedwow.png")
plot(x3 - x2)
dev.off()

#comparacion amplitud vs tiempo de viaje antes y despues dewow
png("C1-C2-compar/comparisonbeforeafter.png")
plot(x2[,15], col = "blue")  #antes    
lines(x3[,15], col = "red")  #después
dev.off()

png("C1-C2-compar/freqspec.png")
spec1D(x3)
dev.off()

png("C1-C2-compar/bandpassspec.png")
x4 <- fFilter(x3, f = c(100, 400), type = "bandpass", plotSpec = TRUE, L = 300)
dev.off()

png("C1-C2-compar/withoutnoise.png")
plot(x4, col=palGPR("gray"))
dev.off()

# calcular envolventes de trazas con transformada de Hilbert
x4_env <- envelope(x4)

png("C1-C2-compar/envelopes.png")
# plot all the trace amplitude envelopes as a function of time
trPlot(x4_env, log = "y", col = rgb(0.2,0.2,0.2,7/100))
# plot the log average amplitude envelope
lines(traceStat(x4_env), log = "y", col = "red", lwd = 2)
dev.off()

#aplicar ganancia
x5 <- gainSEC(
  x4,
  a = 0.01,
  b = 1,
  t0 = NULL,
  tcst = 5,
  track = TRUE
)

#guardar grafica de envolvente de trazas y perfil con ganancia
png("C1-C2-compar/traceamplitudeenvs.png")
plot(traceStat(x4_env), log = "y", col = "red", lwd = 2)
lines(traceStat(envelope(x5)), log = "y", col = "green", lwd = 2)
dev.off()

png("C1-C2-compar/result.png", width = 900, height = 300, units = "px")
plot(x5, col = palGPR("hcl-7"), ylim = c(0, 80), barscale = FALSE, clab = "",
     addTime0 = FALSE, asp = 0.1, note = "", main = "C1-C2-compar",
     cex.lab = 1.5, cex.axis = 1.2)
dev.off()

proc(x5)

writeGPR(x, fPath = "C1-C2-compar/raw_gpr", type = c("ASCII"), overwrite = TRUE)
writeGPR(x5, fPath = "C1-C2-compar/result_gpr", type = c("ASCII"), overwrite = TRUE)

#A tcst = 1 tend = 90 wow c = runmean w = 0.05
#B tcst = 5 tend = 40 c = runmean w = 0.05
#C tcst = 2 tend = 70 wow c("gaussian"), w = 1
#D tcst = 5 tend = 100 c = runmean w = 0.05
#E tcst = 12 tend = 90 c = runmean w = 5
#F tcst = 5 tend = 90 c = runmean w = 10
#G tcst = 2 tend = 100 c = runmean w = 5