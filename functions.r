library("Thermimage")
library("tiff")
library("here")

#updated on 8/3/2021

## In future need to make this script much more versatile for converting images whereever they are
## Instead of only in the "calibration" folder

#setting up workspace and directory addresses
## Don't think I need this if these are all just functions being called
### imagedir <- here("calibration")

#loop function
## May need to actually make more modular so it can be called from anywhere
loop_img <- function(inputfolder, outputfolder = inputfolder) {
  print(paste0("Printing inputfolder: ", inputfolder))
  #print(paste0("Printing inputlist: ", inputlist))
  inputlist <- list.files(inputfolder)
  
  if (dir.exists(here("calibration", "output")) == FALSE) {
    print("Creating output directory")
    dir.create(here("calibration", "output"))
  } else {
    print ("output directory already exists")
  }
  
  print("setting output folder")
  outputfolder <- here("calibration" , "output")
  
  print("setting working directory as inputfolder")
  setwd(inputfolder)
  
  print("starting for loop")
  for (i in 1:length(inputlist)) {
    
    #If image is NOT FLIR jpg, then skips it instead of ending for loop on error
    RGBerror <- tryCatch(
      image1 <- readflirJPG(paste0(inputfolder, "/", inputlist[i]), exiftoolpath = "installed"),
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
    
    print(paste0("raw2tewp processing for: ", inputlist[i]))
    temperature <- raw2temp(image1, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                            PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2,
                            ATA1, ATA2, ATB1, ATB2, ATX)
    
    #inverse <- 1/max(temperature)
    print(paste0("Scaling temperature for: ", inputlist[i]))
    
    #temperature_scaleconverted <- temperature*(1/max(temperature))
    temperature_scaleconverted <- (temperature-min(temperature))/(max(temperature)-min(temperature))
    
    #print("setting output folder")
    #setwd(outputfolder)
    
    #add paste0() -- running first for troubleshooting
    print(paste0("writing TIFF for: ", inputlist[i]))
    writeTIFF(temperature_scaleconverted, paste0(outputfolder,"/", gsub('.jpg', '', basename(inputlist[i])), "_","scaled",".tiff"),
              bits.per.sample = 8L,
              compression = "none", 
              reduce = TRUE)
  }
  
  if (file.exists(paste0(outputfolder, "/tempfile")) == TRUE) {
    print("removing tempfile from output folder")
    file.remove(file.remove(paste0(outputfolder, "/tempfile")))
  } else if (file.exists(paste0(inputfolder, "/tempfile")) == TRUE) {
    print("removing tempfile from input folder")
    file.remove(paste0(inputfolder, "/tempfile"))
  } else {
    return(print("completed loop"))
  }
}

#This works if called via the command prompt, but does not seem to work in R.
#Also, it would seem that this has to resize the imagery to the actual thermal resolution
#anyway, so you've actually done must of the leg work already!!!
### convertflirJPG("IR_60901.jpg", exiftoolpath="installed", res.in="464x348", endian="lsb", outputfolder=, verbose=TRUE)
