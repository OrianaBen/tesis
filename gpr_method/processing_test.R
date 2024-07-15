Sys.setenv("LANGUAGE" = "Sp")
library(RGPR)
myDir <- "C:\\Users\\Oriana\\Uni\\Tesis\\tesis\\gpr_method"
setwd(myDir)
source("myplot.R")

#leer y graficar data cruda
x <- readGPR(dsn = "rawGPR/G1-F2.ZON/TF510001.dt", Vmax = NULL,
             method = c("spline", "spline", "spline"))

antfreq(x) <- 200

png("G1-F2/rawdata.png", width = 690, height = 290, units = "px")
plot(x, col = palGPR("gray"), ylim = c(0, 80), barscale = FALSE, clab = "",
     addTime0 = FALSE, asp = 0.1, note = "", main = "", 
     cex.lab = 1.5, cex.axis = 1.2)
dev.off()

# #estimacion de primera llegada y t0, y grafica para cada traza
time0(x)

png("G1-F2/firstbreak.png")
#w debe ser un periodo, en unidad de tiempo, de la onda de la primera llegada
tfb <- firstBreak(x, w = 4, method = "MER")
plot(pos(x), tfb, ylab = "first wave break", xlab = "position (m)")
dev.off()

t0 <- firstBreakToTime0(tfb, x)
time0(x) <- mean(t0)

png("G1-F2/timezero_firstb.png")
plot(x[, 15], xlim = c(0, 50))
abline(v = tfb[15], col = "blue")
dev.off()

x1 <- dcshift(x, u = 1:120, FUN = median)
proc(x1)

png("G1-F2/timezerocorrec.png")
x2 <- time0Cor(x1, method = "spline")
plot(x2)
dev.off()

#dewow componente de baja frecuencia a partir de mediana
#w es la desviación estándar en unidades de traza
png("G1-F2/dewow.png")
x3 <- dewow(x2, type = c("gaussian"), w = 10)
plot(x3)
dev.off()

png("G1-F2/removedwow.png")
plot(x3 - x2)
dev.off()

#comparacion amplitud vs tiempo de viaje antes y despues dewow
#rojo es después, la idea es que el dewow centra la gráfica
png("G1-F2/comparisonbeforeafter.png")
plot(x2[,15], col = "blue")  #antes    
lines(x3[,15], col = "red")  #después
dev.off()

png("G1-F2/freqspec.png")
spec1D(x3)
dev.off()

png("G1-F2/bandpassspec.png")
# L es el tamaño de la ventana de Hamming, f es la banda que pasa
x4 <- fFilter(x3, f = c(100, 400), type = "bandpass", plotSpec = TRUE, L = 300)
dev.off()

png("G1-F2/withoutnoise.png")
plot(x4, col=palGPR("gray"))
dev.off()

# calcular envolventes de trazas con transformada de Hilbert
x4_env <- envelope(x4)

png("G1-F2/envelopes.png")
# plot all the trace amplitude envelopes as a function of time
trPlot(x4_env, log = "y", col = rgb(0.2,0.2,0.2,7/100))
# plot the log average amplitude envelope
lines(traceStat(x4_env), log = "y", col = "red", lwd = 2)
dev.off()

x5 <- rmBackground(x4, w = 100)

#aplicar ganancia
#si b=1, la ganancia es lineal. En el plot de las envolventes podemos ver cuál es la
#máxima aplitud y hasta dónde aplicar la ganancia (cuando la amplitud se vuelva constante)
x6 <- gainSEC(
  x5,
  a = 0.01,
  b = 0.2,
  t0 = NULL,
  tcst = NULL,
  tend = 70,
  track = TRUE
)

#guardar grafica de envolvente de trazas y perfil con ganancia
png("G1-F2/traceamplitudeenvs.png")
plot(traceStat(x4_env), log = "y", col = "red", lwd = 2)
lines(traceStat(envelope(x6)), log = "y", col = "green", lwd = 2)
dev.off()

png("G1-F2/result.png", width = 690, height = 290, units = "px")
plot(x6, col = palGPR("GRAY"), ylim = c(0, 80), barscale = FALSE, clab = "",
     addTime0 = FALSE, asp = 0.1, note = "", main = "G1-F2",
     cex.lab = 1.5, cex.axis = 1.2)
dev.off()

proc(x6)

writeGPR(x, fPath = "G1-F2/raw_gpr", type = c("ASCII"), overwrite = TRUE)
writeGPR(x6, fPath = "G1-F2/result_gpr", type = c("ASCII"), overwrite = TRUE)