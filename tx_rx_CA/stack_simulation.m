%% 
celar all 
close all
clc
ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/Almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');
c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP
total_SV = 32;
% generate GPS signals
