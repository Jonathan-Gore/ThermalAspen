%% Acquire from FLIR Camera
% This example shows how to acquire a series of images from a FLIR camera supporting GigE Vision
%
% 1. Find the IP address for your specific camera using the with the gigecam() command 
%
% 2. Edit the static IP address before running the code to connect to the
% camera

% Copyright 2014 - 2015 The MathWorks, Inc. 

%% Connect to FLIR camera
vid = gigecam('169.254.40.3', 'PixelFormat', 'Mono16');

img = snapshot(vid);
I = imadjust(img,stretchlim(img),[]);
imshow(I);

%% Loop for acquisition and processing
FRAMES = 2000;
for(i = 1:FRAMES);

% Acquire IR image
IR = snapshot(vid);

% Adjust contrast of IR image
I = imadjust(IR,stretchlim(IR),[]);

imshow(I);
end

%% Shutdown and cleanup
clear vid;