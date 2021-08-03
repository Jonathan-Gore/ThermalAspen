library("Thermimage")
library("fields")
library("tiff")

### Testing for source() ###
test <- 12
test <- 1

#setting up workspace and directory addresses
dir <- "C:/Users/Jonathan/Documents/GitHub/ThermalAspen/data/"
setwd("C:/Users/Jonathan/Documents/GitHub/ThermalAspen/data/")
f <- paste0(dir, "FLIR1756.jpg")

##reading image via the ThermImage readflirJPG() command
##exiftool.exe had to be installed in the main "Windows" path
image <- readflirJPG("FLIR1756.jpg", exiftoolpath = "installed")

##checking the dimensions of the image
dim(image)

##assigning metadata of image
cams <- flirsettings(f, exiftoolpath="installed", camvals="")

##printing out top 20 tags to make sure everything looks good
head(cbind(cams$Info), 20)


#
##Assigning important metadata to variables for the calculation of temperatures
###

#Image Saved Emissivity - should be ~0.95 or 0.96
ObjectEmissivity <- cams$Info$Emissivity

#Original date/time extracted from file
dateOriginal <- cams$Dates$DateTimeOriginal

#Modification date/time extracted from file
dateModif <- cams$Dates$FileModificationDateTime

#Planck R1 constant for camera
PlanckR1 <- cams$Info$PlanckR1 

#Planck B constant for camera
PlanckB <- cams$Info$PlanckB

#Planck F constant for camera
PlanckF <- cams$Info$PlanckF

#Planck O constant for camera
PlanckO <- cams$Info$PlanckO

#Planck R2 constant for camera
PlanckR2 <- cams$Info$PlanckR2

#Atmospheric Transmittance Alpha 1
ATA1 <- cams$Info$AtmosphericTransAlpha1

#Atmospheric Transmittance Alpha 2
ATA2 <- cams$Info$AtmosphericTransAlpha2

#Atmospheric Transmittance Beta 1
ATB1 <- cams$Info$AtmosphericTransBeta1

#Atmospheric Transmittance Beta 2
ATB2 <- cams$Info$AtmosphericTransBeta2

#Atmospheric Transmittance X
ATX <- cams$Info$AtmosphericTransX

#object distance in metres
OD <- cams$Info$ObjectDistance

#focus distance in metres
FD <- cams$Info$FocusDistance

#Reflected apparent temperature
ReflT <- cams$Info$ReflectedApparentTemperature

#Atmospheric temperature
AtmosT <- cams$Info$AtmosphericTemperature

#IR Window Temperature
IRWinT <- cams$Info$IRWindowTemperature

#IR Window transparency
IRWinTran <- cams$Info$IRWindowTransmission

#Relative Humidity
RH <- cams$Info$RelativeHumidit

#sensor height (i.e. image height)
h <- cams$Info$RawThermalImageHeight

#sensor width (i.e. image width)
w <- cams$Info$RawThermalImageWidth

###
##
#

#Show raw data
str(image)

#Create image with calculated temperature per pixel
temperature <- raw2temp(image, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                        PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2,
                        ATA1, ATA2, ATB1, ATB2, ATX)
#Show temperate image data
str(temperature)      

#Find min and max temperature values for visualization
min(temperature)
max(temperature)

#Plotting
plotTherm(temperature, h=h, w=w, minrangeset=5, maxrangeset=12, trans="rotate270.matrix")

##Creating a converted output
#scaling all values for an individual image to between 0-1
inverse <- 1/max(temperature)

#scaling temperature matrix
temperature_scaleconverted <- temperature*inverse

#confirming scale conversion
min(temperature_scaleconverted)
max(temperature_scaleconverted)

#writing uncompressed tiff for export
writeTIFF(temperature_scaleconverted, "output.tiff", bits.per.sample = 8L,
          compression = "none", reduce = TRUE)

out_dir <- paste0(dir, "output/")

testlist <- list.files(dir)

#loop function
loop_img <- function(inputfolder, outputfolder = inputfolder){
  inputlist <- list.files(inputfolder)
  print(paste0("Initial outside of for loop ", inputlist))
  dir.create(paste0(outputfolder, "output"))
  outputfolder <- paste0(outputfolder, "output/")
  
  for (i in 1:length(inputlist)){
    setwd(inputfolder)
    print(paste0("Inside for loop for iteration (i): ", i, " | the inputlist index is: ",
                 inputlist[i]))
    
    print(paste0("Writing image for: ", inputlist[i], " | of i iteration: ", i))
    
    #If image is NOT FLIR jpg, then skips it instead of ending for loop on error
    RGBerror <- tryCatch(
      image1 <- readflirJPG(inputlist[i], exiftoolpath = "installed"),
      error=function(e) e
      )
      
      if(inherits(RGBerror, "error")) next
    
    #print(paste0("input for image1 writing: ", inputlist[i]))
    #image1 <- readflirJPG(inputlist[i], exiftoolpath = "installed")
    
    print(paste0("Writing metadata for: ", inputlist[i], " | of i iteration: ", i))
    cams <- flirsettings(inputlist[i], exiftoolpath="installed", camvals="")
    
    print(paste0("Assigning individual metadata for: ", inputlist[i], " | of i iteration: ", i))
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
    
    print(paste0("Writing temperature for: ", inputlist[i], " | of i iteration: ", i))
    temperature <- raw2temp(image1, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                            PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2,
                            ATA1, ATA2, ATB1, ATB2, ATX)
    
    print(paste0("Creating inverse temperature scale parameter for: ", inputlist[i], " | of i iteration: ", i))
    inverse <- 1/max(temperature)
    
    print(paste0("Converting temperature to scaled_temperature for: ", inputlist[i], " | of i iteration: ", i))
    temperature_scaleconverted <- temperature*(1/max(temperature))
    
    setwd(outputfolder)
    
    print(paste0("Writing scaled_temperature to TIFF for: ", inputlist[i], " | of i iteration: ", i))
    writeTIFF(temperature_scaleconverted, paste0(outputfolder, "scaled", inputlist[i]),
                                                 bits.per.sample = 8L,
                                                 compression = "none", 
                                                 reduce = TRUE)
    
    #print(paste0("Moving i iteration forward one: ", i))
    #i <- i+1
    
    print(paste0("Current i iteration before restarting for loop: ", i))
  }
  file.remove(paste0(outputfolder, "tempfile"))
  file.remove(paste0(inputfolder, "tempfile"))
  return(print("completed loop"))  
}