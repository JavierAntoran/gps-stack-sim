%% 
clear all 
close all
clc
ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/Almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

total_SV = 32;
[eph, head] = read_rinex_nav('brdc0920.17n', 1:total_SV);
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
time = gps_sec;

c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP


L = 50; %samples per CA bit. fm = fchip * L. More renults ib better precision

%define receiver pos
Rpos = [ 3.894192036606761e+06 3.189618244369670e+05 5.024275884645306e+06]; % north france
% generate GPS signals

sCA = CA_gen(L);

%pass signal through channel: distance + iono + tropo + clock

[delay_CA, cicles] = gps_channel(head, eph, time, Rpos, sCA, L);

% receiver
