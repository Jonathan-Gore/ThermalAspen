import numpy as np
import cv2
from matplotlib import pyplot as plt

img = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/DC_60904.jpg')
thermal_img = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60903_scaled.tiff')

rows,cols, ch = img.shape
therm_rows, therm_cols = thermal_img.shape

#Three pairs of points
#example ([[50,50],[200,50],[50,200]])
pt1 = np.float32([[906,696],[358,685],[361,241]])

#example ([[10,100],[200,50],[100,250]])
#Three pairs of points
pt2 = np.float32([[398,330],[67,323],[69,55]])

matrix = cv2.getAffineTransform(pt1,pt2)
new_img = cv2.warpAffine(img,matrix,(cols,rows))

plt.subplot(121),plt.imshow(img),plt.title('Input')
plt.subplot(122),plt.imshow(new_img),plt.title('Output')

plt.show()

#added_image = cv2.addWeighted(new_img,0.4,thermal_img,0.1,0)
cropped_image = thermal_img[therm_rows, therm_cols]
cv2.imshow("cropped", cropped_image)

#cv2.imwrite('combined.png', added_image)