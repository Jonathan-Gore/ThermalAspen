# Oh god please don't let this be a thing

# First attempt at simply cropping the image...
# https://stackoverflow.com/questions/46944107/how-to-crop-an-image-from-the-center-with-certain-dimensions

# https://theailearner.com/tag/cv2-warpperspective/

from PIL import Image
import cv2
import numpy as np
import matplotlib.pyplot as plt

#img = Image.open("C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60904.jpg")

# img.show()

# h, w = img.size

# print("Image height is : ", h)
# print("Image width is: ", w)

# cw, ch = 464, 348

# box = w//2 - cw//2, h//2 - ch//2, w//2 + cw//2, h//2 + ch//2

# cropped_img = img.crop(box)

# cropped_img.show()

def crop_resize_image(file_name,new_height,new_width):

    im = Image.open(file_name)
    width, height = im.size   

    left = (width - new_width)/2
    top = (height - new_height)/2
    right = (width + new_width)/2
    bottom = (height + new_height)/2

    crop_im = im.crop((left, top, right, bottom)) #Cropping Image 

    crop_resize_im = crop_im.resize((464, 348)) #
    crop_resize_im.save("cropped.jpg")  #Saving Images 

#new_width = 753     #Enter the crop image width
#new_height = 565    #Enter the crop image height
#file_name = ["C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60904.jpg"] #Enter File Names

#for i in file_name:
#    crop_image(i,new_height,new_width)

im1 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60902.jpg')
im2 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60901_scaled.tiff')

#points1 = np.float32([[359,685],[360,241],[901,249],[904,680],[905,696]])
#points2 = np.float32([[67,323],[70,56],[393,61],[397,320],[398,328]])

##With only the four corners of the screen -- Monitoring Image Pair
#points1 = np.float32([[359,685],[360,241],[901,249],[904,680]])
#points2 = np.float32([[67,323],[70,56],[393,61],[397,320]])

## Find homography
#h, mask = cv2.findHomography(points1, points2, cv2.RANSAC)

# Compute the perspective transform M
#M = cv2.getPerspectiveTransform(points1,points2)

# Apply the perspective transformation to the image
#out = cv2.warpPerspective(im1,M,(im1.shape[1], im1.shape[0]),flags=cv2.INTER_LINEAR)
#out = cv2.warpPerspective(im1,M,(im1.shape[1], im1.shape[0])) 
# Display the transformed image
#plt.imshow(out)
#plt.show()

#cv2.imwrite("RegisteredOutput.jpg", out)



## Use homography
#height, width, channels = im2.shape
#im1Reg = cv2.warpPerspective(im1, h, (width, height))

#im1Reg.save("NEWFILE.jpg")

if __name__ == '__main__':
    
    im1 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/cropped.jpg')
    #im2 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60901_scaled.tiff')
    
    ##crop_image(i,new_height,new_width)
    #crop_resize_image('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60902.jpg',
    #600,800)

    im1Gray = cv2.cvtColor(im1, cv2.COLOR_BGR2GRAY)

    cv2.imshow('Window', im1Gray)
    cv2.waitKey(0)

    cv.imshow('Window2', im1Gray_PsuedoTherm)
