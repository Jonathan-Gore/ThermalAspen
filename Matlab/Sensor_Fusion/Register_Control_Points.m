%% Register control points for video from webcam and FLIR Camera
% This example shows how to acquire a series of images from a FLIR camera supporting GigE Vision
%
% 1. Find the IP address for your specific camera using the with the gigecam() command 
%
% 2. Edit the static IP address before running the code to connect to the
% camera
% 3. Fix cameras and capture images from both the webcam and IR camera
%
% 4. Launch cpselect to select the control points and register the images
%
% Copyright 2014 - 2015 The MathWorks, Inc. 



%% Read an IR image into the workspace.
vid = gigecam('169.254.76.3', 'PixelFormat', 'Mono16');

%% Acquire IR image
IR = snapshot(vid);
IR_image = imadjust(IR,stretchlim(IR),[]);
imshow(IR_image);   

%% Acquire Webcam Image
% Setup Webcam and capture image
cam = webcam;
webcam_image= snapshot(cam);
figure, imshow(webcam_image);


%% Import Two Images %% added in by Jonathan
%webcam_image = imread('C:\Users\Jonathan\Documents\Projects\Art Thermal\FLIR1757.jpg')
%IR_image = imread('C:\Users\Jonathan\Documents\Projects\Art Thermal\FLIR1756.jpg')

%% Select control points in two related images
% Moving is the image that needs to be warped to bring it into 
% the coordinate system of the fixed image.

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

