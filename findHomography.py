from __future__ import print_function
import cv2
import numpy as np
import matplotlib.pyplot as plt

MAX_FEATURES = 500
GOOD_MATCH_PERCENT = 0.15

def alignImages(im1, im2):

  # Convert images to grayscale
  im1Gray = cv2.cvtColor(im1, cv2.COLOR_BGR2GRAY)
  im2Gray = cv2.cvtColor(im2, cv2.COLOR_BGR2GRAY)

  # Detect ORB features and compute descriptors.
  orb = cv2.ORB_create(MAX_FEATURES)
  keypoints1, descriptors1 = orb.detectAndCompute(im1Gray, None)
  keypoints2, descriptors2 = orb.detectAndCompute(im2Gray, None)

  print("Printing keypoints1: ", keypoints1)
  print("Printing keypoints2: ", keypoints2)

  # Match features.
  matcher = cv2.DescriptorMatcher_create(cv2.DESCRIPTOR_MATCHER_BRUTEFORCE_HAMMING)
  matches = matcher.match(descriptors1, descriptors2, None)

  # Sort matches by score
  matches.sort(key=lambda x: x.distance, reverse=False)

  # Remove not so good matches
  numGoodMatches = int(len(matches) * GOOD_MATCH_PERCENT)
  matches = matches[:numGoodMatches]

  # Draw top matches
  imMatches = cv2.drawMatches(im1, keypoints1, im2, keypoints2, matches, None)
  cv2.imwrite("matches.jpg", imMatches)

  # Extract location of good matches
  points1 = np.zeros((len(matches), 2), dtype=np.float32)
  points2 = np.zeros((len(matches), 2), dtype=np.float32)

  for i, match in enumerate(matches):
    points1[i, :] = keypoints1[match.queryIdx].pt
    points2[i, :] = keypoints2[match.trainIdx].pt

  print("Printing points1 post-keypoint matching: ", points1)
  print("Printing points2 post-keypoint matching: ", points2)
  
  # Find homography
  h, mask = cv2.findHomography(points1, points2, cv2.RANSAC)

  # Use homography
  height, width, channels = im2.shape
  im1Reg = cv2.warpPerspective(im1, h, (width, height))

  return im1Reg, h

def alignimage_v2(im1, im2, points1, points2):
  
  
  #Find homography
  h, mask = cv2.findHomography(points1, points2)
  
  # Apply panorama correction
  width = im1.shape[1] + im2.shape[1]
  height = im1.shape[0] + im1.shape[0]

  out = cv2.warpPerspective(im1, h, (width, height))
  out[0:im2.shape[0], 0:im2.shape[1]] = im2

  plt.figure(figsize=(20,10))
  plt.imshow(out)

  plt.axis('off')
  plt.show()

  cv2.imwrite("RegisteredOutput.jpg", out)

if __name__ == '__main__':

  ## Read reference image
  #refFilename = 'C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60901_scaled.jpg'
  #print("Reading reference image : ", refFilename)
  #imReference = cv2.imread(refFilename, cv2.IMREAD_COLOR)

  ## Read image to be aligned
  #imFilename = "C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/cropped.jpg"
  #print("Reading image to align : ", imFilename);
  #im = cv2.imread(imFilename, cv2.IMREAD_COLOR)

  #print("Aligning images ...")
  ## Registered image will be resotred in imReg.
  ## The estimated homography will be stored in h.
  #imReg, h = alignImages(im, imReference)

  ## Write aligned image to disk.
  #outFilename = "aligned.jpg"
  #print("Saving aligned image : ", outFilename);
  #cv2.imwrite(outFilename, imReg)

  ## Print estimated homography
  #print("Estimated homography : \n",  h)

  im1 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/IR_60901_scaled.jpg')
  im2 = cv2.imread('C:/Users/Jonathan/Documents/GitHub/ThermalAspen/test/cropped.jpg')
  
  im1_points1 = np.float32([[400,224],[184,239],[114,78],[74,189],[182,137]])
  im2_points2 = np.float32([[386,201], [180,216], [115,60], [74,167], [178,116]])
  alignimage_v2(im1, im2, im1_points1, im2_points2)