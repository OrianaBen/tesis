library(RGPR)
myDir <- "C:\\Users\\Oriana\\Documents\\Uni\\Tesis\\tesis\\gpr_method"
setwd(myDir)

#leer y graficar data cruda
x <- readGPR(dsn = "rawGPR/4AusbPER.ZON/TF510001.dt", Vmax = NULL,
             method = c("spline", "spline", "spline"))

antfreq(x) <- 200

png("rawdata.png")
plot(x, col=palGPR("gray"))
dev.off()

#estimacion de primera llegada y t0, y grafica para cada traza
time0(x)

png('firstbreak.png')
tfb <- firstBreak(x, w = 0.05, method = "coppens")
plot(pos(x), tfb, ylab = "first wave break", xlab = "position (m)")
dev.off()

t0 <- firstBreakToTime0(tfb, x)
time0(x) <- mean(t0)

png("timezero_firstb.png")
plot(x[, 15], xlim = c(0, 50))
abline(v = tfb[15], col = "blue")
dev.off()

# plot(x[, 15])  # plot the 15th trace of the GPR-line
# # add a green horizontal line
# abline(h = mean(x[1:100, 15]), col = "green")

x1 <- dcshift(x, u = 1:120)
proc(x1)

png("timezerocorrec.png")
x2 <- time0Cor(x1, method = "spline")
plot(x2)
dev.off()

png("dewow.png")
x3 <- dewow(x2, type = c("runmed"), w = NULL)
plot(x3)
dev.off()

png("removedwow.png")
plot(x3 - x2)
dev.off()

png("comparisonbeforeafter.png")
plot(x2[,15], col = "blue")      # before dewowing
lines(x3[,15], col = "red")      # after dewowing
dev.off()

png("freqspec.png")
spec1D(x3)
dev.off()

png("lowpassspec.png")
x4 <- fFilter(x3, f = 1000,
              type = "low", plotSpec = TRUE)
dev.off()

png("withoutnoise.png")
plot(x4, col=palGPR("gray"))
dev.off()

# # compute the trace amplitude envelopes (with Hilbert transform)
x4_env <- envelope(x4)
# # plot all the trace amplitude envelopes as a function of time
# trPlot(x4_env, log = "y", col = rgb(0.2,0.2,0.2,7/100), xlim = c(0, 250))
# # plot the log average amplitude envelope
# lines(traceStat(x4_env), log = "y", col = "red", lwd = 2)

x5 <- gainSEC(
  x4,
  a = 0.01,
  b = 1,
  t0 = NULL,
  tend = 100,
  tcst = 5,
  track = TRUE
)

#trace amplitude envelopes (with Hilbert transform)
png("traceamplitudeenvs.png")
plot(traceStat(x4_env), log = "y", col = "red", lwd = 2)
lines(traceStat(envelope(x5)), log = "y", col = "green", lwd = 2)
dev.off()

png("gainapplied.png")
plot(x5, col = palGPR("gray"))
dev.off()

proc(x5)