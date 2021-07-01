library("Thermimage")
library("fields")


dir <- "C:/Users/Jonathan/Documents/GitHub/ThermalAspen/data/"
setwd("C:/Users/Jonathan/Documents/GitHub/ThermalAspen/data/")

f <- paste0(dir, "FLIR1756.jpg")

image <- convertflirJPG("FLIR1756.jpg", exiftoolpath = "installed")

image <- readflirJPG("FLIR1756.jpg", exiftoolpath = "installed")


dim(image)


cams<-flirsettings(f, exiftoolpath="installed", camvals="")

head(cbind(cams$Info), 20) # Large amount of Info, show just the first 20 tages for readme


ObjectEmissivity <- cams$Info$Emissivity              # Image Saved Emissivity - should be ~0.95 or 0.96
dateOriginal <- cams$Dates$DateTimeOriginal             # Original date/time extracted from file
dateModif <- cams$Dates$FileModificationDateTime     # Modification date/time extracted from file
PlanckR1 <- cams$Info$PlanckR1                      # Planck R1 constant for camera  
PlanckB <- cams$Info$PlanckB                       # Planck B constant for camera  
PlanckF <- cams$Info$PlanckF                       # Planck F constant for camera
PlanckO <- cams$Info$PlanckO                       # Planck O constant for camera
PlanckR2 <- cams$Info$PlanckR2                      # Planck R2 constant for camera
ATA1 <- cams$Info$AtmosphericTransAlpha1        # Atmospheric Transmittance Alpha 1
ATA2 <- cams$Info$AtmosphericTransAlpha2        # Atmospheric Transmittance Alpha 2
ATB1 <- cams$Info$AtmosphericTransBeta1         # Atmospheric Transmittance Beta 1
ATB2 <- cams$Info$AtmosphericTransBeta2         # Atmospheric Transmittance Beta 2
ATX <- cams$Info$AtmosphericTransX             # Atmospheric Transmittance X
OD <- cams$Info$ObjectDistance                # object distance in metres
FD <- cams$Info$FocusDistance                 # focus distance in metres
ReflT <- cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
AtmosT <- cams$Info$AtmosphericTemperature        # Atmospheric temperature
IRWinT <- cams$Info$IRWindowTemperature           # IR Window Temperature
IRWinTran <- cams$Info$IRWindowTransmission          # IR Window transparency
RH <- cams$Info$RelativeHumidity              # Relative Humidity
h <- cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
w <- cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

str(image)

temperature<-raw2temp(image, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                      PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2, 
                      ATA1, ATA2, ATB1, ATB2, ATX)
str(temperature)      

min(temperature)
max(temperature)

plotTherm(temperature, h=h, w=w, minrangeset=5, maxrangeset=12, trans="rotate270.matrix")

plotTherm(temperature, h=h, w=w)
