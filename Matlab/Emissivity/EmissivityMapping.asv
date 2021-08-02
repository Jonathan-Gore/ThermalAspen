%% Emmisivity Mapping
% This example of performing 2 point emmisivity mapping 
% 
% Copyright 2014 - 2015 The MathWorks, Inc. 

%% Calculate Emissivity Map and  Load images at T1 
load('15 degree C.mat');
Board_T1 = im2double(Frame, 'indexed');

% RT1 is the radiance values for that object
RT1 = 15;

%% Load images at T2 
load('25 degree C.mat');
Board_T2 = im2double(Frame, 'indexed');

% RT2 is the ending temperature of object
RT2 = 25;

%% Emissivity Mapping Calculation
EmissivityMap = (Board_T2 - Board_T1) / (RT2 - RT1);

%% Radiance Mapping
RadianceMap2 = (Board_T2 - EmissivityMap*RT2) ./ (1-EmissivityMap);

%%  Apply Emissivity Map and RadianceMap to get true temperature
load('WarmedUp.mat');
WarmBoard = im2double(Frame, 'indexed');

CorrectedTemp = (WarmBoard - (1 - EmissivityMap).* RadianceMap)./ EmissivityMap;

