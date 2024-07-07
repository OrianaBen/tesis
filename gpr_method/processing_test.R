library(RGPR)
myDir <- "C:\\Users\\Oriana\\Uni\\Tesis\\tesis\\gpr_method"
setwd(myDir)

#leer y graficar data cruda
x <- readGPR(dsn = "rawGPR/7usbPER.ZON/TF510001.dt", Vmax = NULL,
             method = c("spline", "spline", "spline"))

antfreq(x) <- 200

png("test/rawdata.png")
plot(x, col=palGPR("gray"))
dev.off()

#estimacion de primera llegada y t0, y grafica para cada traza
time0(x)

png("test/firstbreak.png")
tfb <- firstBreak(x, w = 0.5, method = "MER")
plot(pos(x), tfb, ylab = "first wave break", xlab = "position (m)")
dev.off()

t0 <- firstBreakToTime0(tfb, x)
time0(x) <- mean(t0)

png("test/timezero_firstb.png")
plot(x[, 15], xlim = c(0, 50))
abline(v = tfb[15], col = "blue")
dev.off()

x1 <- dcshift(x, u = 1:120)
proc(x1)

png("test/timezerocorrec.png")
x2 <- time0Cor(x1, method = "spline")
plot(x2)
dev.off()

#dewow componente de baja frecuencia a partir de mediana
png("test/dewow.png")
x3 <- dewow(x2, type = c("runmean"), w = 5)
plot(x3)
dev.off()

png("test/removedwow.png")
plot(x3 - x2)
dev.off()

#comparacion amplitud vs tiempo de viaje antes y despues dewow
png("test/comparisonbeforeafter.png")
plot(x2[,15], col = "blue")      
lines(x3[,15], col = "red")
dev.off()

png("test/freqspec.png")
spec1D(x3)
dev.off()

png("test/lowpassspec.png")
x4 <- fFilter(x3, f =1000,
              type = "low", plotSpec = TRUE)
dev.off()

png("test/withoutnoise.png")
plot(x4, col=palGPR("gray"))
dev.off()

# calcular envolventes de trazas con transformada de Hilbert
x4_env <- envelope(x4)

#aplicar ganancia
x5 <- gainSEC(
  x4,
  a = 0.01,
  b = 1,
  t0 = NULL,
  tend = 100,
  tcst = 2,
  track = TRUE
)

#guardar grafica de envolvente de trazas y perfil con ganancia
png("test/traceamplitudeenvs.png")
plot(traceStat(x4_env), log = "y", col = "red", lwd = 2)
lines(traceStat(envelope(x5)), log = "y", col = "green", lwd = 2)
dev.off()

png("test/result.png", width = 1500, height = 500, units = "px")
plot(x5, col = palGPR("hcl-7"), ylim = c(1, 80), asp = 0.1)
dev.off()

proc(x5)

writeGPR(x, fPath = "test_crudo", type = c("ASCII"))
writeGPR(x5, fPath = "test_procesada", type = c("ASCII"))

#1usb tcst = 1 tend = 90 wow c = runmean w = 0.05
#2usb tcst = 5 tend = 40 c = runmean w = 0.05
#3usb tcst = 2 tend = 70 wow c("gaussian"), w = 1
#4usb tcst = 5 tend = 100 c = runmean w = 0.05
#5usb tcst = 12 tend = 90 c = runmean w = 5
#6usb tcst = 5 tend = 90 c = runmean w = 10
#7usb tcst = 2 tend = 100 c = runmean w = 5