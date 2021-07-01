%Copyright 2014 - 2015 The MathWorks, Inc.
h = size(rir_filter_input, 1);
w = size(rir_filter_input, 2);

if rir_filter_reset
	rir_filter_output = zeros(h, w, class(rir_filter_input));
    load('cameraParams');
end

imOrig = rir_filter_input;

im = undistortImage(imOrig, cameraParameters);

rir_filter_output = im;