clc
clear all

ROOTDIR = fileparts(get_lib_path);

almFile = strcat(ROOTDIR,'/files/Almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

[r_eph, r_head] = read_rinex_nav(ephFile, 32);

[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
gps_sec = gps_sec+r_head.leapSeconds;

[ satp, orbit_parameters ] = rinex2ecef(r_head, r_eph, 86400);

image_file = fullfile(ROOTDIR,'/sv/land_ocean_ice_2048.png');

%%
plot_orbits(orbit_parameters, image_file)