%% Fuse live video from a webcam and a FLIR camera 
% This example shows how to fuse live images from the webcam and IR camera by applying the transform 
% calculated with the control point process
%
% 1. Find the IP address for your specific camera using the with the gigecam() command 
%
% 2. Edit the static IP address before running the code to connect to the camera
% 
% 3. Capture and align webcam and FLIR camera in a loop 
%
% Copyright 2014 - 2015 The MathWorks, Inc. 


%% Connect to FLIR camera
vid = gigecam('169.254.76.3', 'PixelFormat', 'Mono16');

% Setup Webcam
cam = webcam;

%% Loop for acquisition and processing
FRAMES = 2000;
for(i = 1:FRAMES);
% Acquire webcam image
rgbImage = snapshot(cam);

% Acquire IR image
IR = snapshot(vid);

% Adjust contrast of IR image
I = imadjust(IR,stretchlim(IR),[]);

% Roriginal = imref2d(size(I));
recovered = imwarp(rgbImage,tform,'OutputView',Roriginal);
imshowpair(I, recovered,'blend')

end

%% Shutdown and cleanup
% Stop and delete FLIR camera objects
clear vid;
% Delete webcam object
clear cam;