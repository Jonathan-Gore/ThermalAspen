%%Registering Art Woods FLIR Thermal Camera Imagery
% Created by Jonathan Gore on 6/22/2021
% version 1.0

% Currently the sample images provided by email are overly complex to get a
% really tight fix for the affine transformations.

% Best to get some calibration imagery once and then be done with it,
% instead of having to mess around tweaking field imagery for the base
% affine calculation!

%% Import Two Images
webcam_image = imread('C:\Users\Jonathan\Documents\Projects\Art Thermal\FLIR1757.jpg');
IR_image = imread('C:\Users\Jonathan\Documents\Projects\Art Thermal\FLIR1756.jpg');

%% Show image 1
imshow(webcam_image);

%% Show image 2
imshow(IR_image);

%% Select control points in two related images
% 'Moving' is the image that needs to be warped to
% bring it into the coordinate system of the fixed image.

cpselect(webcam_image,IR_image);

%% Step 4: Estimate Transformation
% Fit a nonreflective similarity transformation to your control points.

tform = fitgeotrans(movingPoints, fixedPoints,'affine');

save('movingPoints.mat', 'movingPoints');
save('fixedPoints.mat', 'fixedPoints');
save('tform.mat', 'tform');

%% Register images and compare |recovered| to |original| by looking at them side-by-side in a montage.
Roriginal = imref2d(size(IR_image));
save('Roriginal.mat', 'Roriginal');
recovered = imwarp(webcam_image,tform,'OutputView',Roriginal);
imshowpair(IR_image,recovered,'blend')

