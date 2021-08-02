%% Fuse live images from webcam and FLIR camera and apply edge detection
% This example shows how to fuse live images from the webcam and IR camera by applying the transform 
% calculated with the control point process
%
% 1. Find the IP address for your specific camera using the with the gigecam() command 
%
% 2. Edit the static IP address before running the code to connect to the camera
%
% 3. Capture and align webcam and FLIR camera in a loop and apply edge detection
%
% Copyright 2014 - 2015 The MathWorks, Inc. 

%% Read a webcam and IR image into the workspace.

vid = gigecam('169.254.40.3','PixelFormat', 'Mono16');

% Setup Webcam
cam = webcam;

%% Loop for acquisition and processing
FRAMES = 200;
for(i = 1:FRAMES);
% Acquire webcam image
webcam_image = snapshot(cam);
% Acquire IR image
IR = snapshot(vid);
    
% Adjust contrast of IR image
I = imadjust(IR,stretchlim(IR),[]);
I = edge(I,'sobel', 0.05);

recovered = imwarp(webcam_image,tform,'OutputView',Roriginal);
imshowpair(recovered, I,'blend')
end

%% Shutdown and cleanup
% Stop and delete FLIR camera objects
stop(vid)
delete(vid)


% Delete webcam object
clear('cam');