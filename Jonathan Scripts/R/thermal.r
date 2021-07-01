library("Thermimage")

dir <- "C:/Users/Jonathan/Documents/Projects/Art Thermal/FLIR Imagery/100_FLIR"

setwd("C:/Users/Jonathan/Documents/Projects/Art Thermal/FLIR Imagery/100_FLIR")

image <- convertflirJPG("IR_60896.jpg", exiftoolpath = "installed")

print(paste0(dir, "/hello"))
