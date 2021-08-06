
## updated 8/14/18


library(oro.nifti)
library(RNiftyReg)
library(jpeg)
library(png)
library(tiff)
library(mmand)
library(Thermimage)
library(here)

folder.path <- here("test")

## # Read images and convert to greyscale
source <- readJPEG(paste0(folder.path, "/", "DC_60904.jpg"))
target <- readTIFF(paste0(folder.path, "/", "IR_60903_scaled.tiff"))

## convert source to greyscale; target is already converted
source <- apply(source, 1:2, mean)

# Register images
result <- niftyreg(source, target, nLevels = 8) 

# Calculate morphological gradient
kernel <- shapeKernel(c(3,3), type="diamond")
gradient <- dilate(result$image,kernel) - erode(result$image,kernel)

# Display the results
mmand::display(target)
mmand::display(threshold(gradient,method="kmeans"), add=TRUE, col="red")

display(gradient)
display(kernel)

mmand::display(result$image)

#### try cropping visual images

install.packages("imager")	## this is super awesome package. See details here: https://dahtah.github.io/imager/imager.html#quick-start
library("imager")

im.target <- load.image(paste0(folder.path, "FLIR1757.jpg"))
plot(im.target)

im.target.c <- crop.borders(im.target, nx = 250, ny = 180)
plot(im.target.c)
im.target.c.g <- grayscale(im.target.c)
plot(im.target.c.g)

result <- niftyreg(source, t(as.matrix(im.target.c.g)), nLevels = 7) 
kernel <- shapeKernel(c(3,3), type="diamond")
gradient <- mmand::dilate(result$image,kernel) - mmand::erode(result$image,kernel)

mmand::display(t(as.matrix(im.target.c.g)))
mmand::display(mmand::threshold(gradient,method="kmeans"), add=TRUE, col="red")

mmand::display(result$image)


##################### next step is to do this on un-greyscaled IR images.

# split into different color channels?

z <- imsplit(im.target.c, "c")
plot(z[[3]])

