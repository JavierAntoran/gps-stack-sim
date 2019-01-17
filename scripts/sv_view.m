clc
clear all

ROOTDIR = fileparts(get_lib_path);

ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');
image_file = fullfile(ROOTDIR,'/files/land_ocean_ice_2048.png');

% Read rinex navigation file
[r_eph, r_head] = read_rinex_nav(ephFile, 1:32);

% Get GPS time
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
% Add leap seconds from ephemerides
gps_sec = gps_sec+r_head.leapSeconds;

% Convert ephemerides to ECEF and get orbit parameters
[ satp, orbit_parameters ] = eph2ecef(r_eph, gps_sec);

% Receiver position in LLA
rcv_lla = [ deg2rad(41.6835944) deg2rad(-0.8885864) 201];
rcv_lla = [ deg2rad(-36.848461) deg2rad(174.763336) 21];

% Elevatoin angle
E_angle = 30;

% Get visible space vehicles from rcv_lla
vis_sv = visible_sv(satp, rcv_lla, E_angle);

% SV orbit and visibility plot

plot_orbits(satp, orbit_parameters, image_file, vis_sv);

% Ellipsoid parameters
WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;

% Receiver ECEF position
rcv_xyz = [ 0 0 0 ];
[rcv_xyz(1) rcv_xyz(2) rcv_xyz(3)]= lla2xyz(rcv_lla(1), rcv_lla(2), rcv_lla(3),WGS84.a,WGS84.e2);


% Plot receiver position
scatter3(rcv_xyz(1), rcv_xyz(2), rcv_xyz(3), 'yo')

%% Plot visibility cone
r = linspace(0,2.5e7,10) ; % Distance from earth to above SV (10 segments) 
th = linspace(0,2*pi); % Circunference points
[R,T] = meshgrid(r,th) ; % Mesh in pola coordinates
P = deg2rad(90-E_angle); % Constant PHI angle

% Get cartesian coordinates from polar
X = R.*cos(T)*sin(P);
Y = R.*sin(T)*sin(P) ;
Z = R*cos(P);

% Translation matrix
A=eye(3);
B = ltcmat(rcv_lla);
C = A/B;

XP = zeros(size(X));
YP = zeros(size(Y));
ZP = zeros(size(Z));

% Apply translation for each cone point
for i=1:size(X,1)
    for j=1:size(X,2)
        tmp = C*[X(i,j) Y(i,j) Z(i,j)]';
        XP(i,j) = tmp(1);
        YP(i,j) = tmp(2);
        ZP(i,j) = tmp(3);
    end
end

hSurface = surf(XP+rcv_xyz(1),YP+ rcv_xyz(2),ZP+ rcv_xyz(3),'FaceColor','g','FaceAlpha',.4,'EdgeAlpha',.4);