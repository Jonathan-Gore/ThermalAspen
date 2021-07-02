library("Thermimage")
library("tiff")

#setting up workspace and directory addresses
dir <- "C:/Users/Jonathan/Documents/GitHub/ThermalAspen/data/"

#loop function
loop_img <- function(inputfolder, outputfolder = inputfolder){
  inputlist <- list.files(inputfolder)
  dir.create(paste0(outputfolder, "output"))
  outputfolder <- paste0(outputfolder, "output/")
  
  for (i in 1:length(inputlist)){
    setwd(inputfolder)
    
    #If image is NOT FLIR jpg, then skips it instead of ending for loop on error
    RGBerror <- tryCatch(
      image1 <- readflirJPG(inputlist[i], exiftoolpath = "installed"),
      error=function(e) e
    )
    
    if(inherits(RGBerror, "error")) next
  
    cams <- flirsettings(inputlist[i], exiftoolpath="installed", camvals="")
    
    ObjectEmissivity <- cams$Info$Emissivity
    dateOriginal <- cams$Dates$DateTimeOriginal
    dateModif <- cams$Dates$FileModificationDateTime
    PlanckR1 <- cams$Info$PlanckR1 
    PlanckB <- cams$Info$PlanckB
    PlanckF <- cams$Info$PlanckF
    PlanckO <- cams$Info$PlanckO
    PlanckR2 <- cams$Info$PlanckR2
    ATA1 <- cams$Info$AtmosphericTransAlpha1
    ATA2 <- cams$Info$AtmosphericTransAlpha2
    ATB1 <- cams$Info$AtmosphericTransBeta1
    ATB2 <- cams$Info$AtmosphericTransBeta2
    ATX <- cams$Info$AtmosphericTransX
    OD <- cams$Info$ObjectDistance
    FD <- cams$Info$FocusDistance
    ReflT <- cams$Info$ReflectedApparentTemperature
    AtmosT <- cams$Info$AtmosphericTemperature
    IRWinT <- cams$Info$IRWindowTemperature
    IRWinTran <- cams$Info$IRWindowTransmission
    RH <- cams$Info$RelativeHumidit
    h <- cams$Info$RawThermalImageHeight
    w <- cams$Info$RawThermalImageWidth
    
    temperature <- raw2temp(image1, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                            PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2,
                            ATA1, ATA2, ATB1, ATB2, ATX)
    
    inverse <- 1/max(temperature)
    temperature_scaleconverted <- temperature*(1/max(temperature))
    setwd(outputfolder)
    
    writeTIFF(temperature_scaleconverted, paste0(outputfolder, "scaled", inputlist[i]),
              bits.per.sample = 8L,
              compression = "none", 
              reduce = TRUE)
  }
  file.remove(paste0(outputfolder, "tempfile"))
  file.remove(paste0(inputfolder, "tempfile"))
  return(print("completed loop"))  
}
