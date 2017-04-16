clc
clear all

ROOTDIR = fileparts(get_lib_path);

almFile = strcat(ROOTDIR,'/files/Almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

[r_eph, r_head] = read_rinex_nav(ephFile, 1:32);

[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
gps_sec = gps_sec+r_head.leapSeconds;

[ satp,orbit_parameters, orbits_xyz ] = eph2ecef(r_eph, gps_sec);

image_file = fullfile(ROOTDIR,'/sv/land_ocean_ice_2048.png');


%%
rcv_lla = [ deg2rad(41.6835944) deg2rad(-0.8885864) 201];

% rcv_lla = [ deg2rad(-36.848461) deg2rad(174.763336) 21];


E_angle = 20;
vis_sv = visible_sv(satp, rcv_lla, E_angle)

%%

plot_orbits(satp, orbits_xyz, image_file, vis_sv)

WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;
rcv_xyz = [ 0 0 0 ];
[rcv_xyz(1) rcv_xyz(2) rcv_xyz(3)]= LLAtoXYZ(rcv_lla(1), rcv_lla(2), rcv_lla(3),WGS84.a,WGS84.e2);

scatter3(rcv_xyz(1), rcv_xyz(2), rcv_xyz(3), 'yo')


% point = rcv_xyz;
% normal = lla2enu_tm(3,:);
% 
% %# a plane is a*x+b*y+c*z+d=0
% %# [a,b,c] is the normal. Thus, we have to calculate
% %# d and we're set
% d = -point*normal'; %'# dot product for less typing
% 
% %# create x,y
% [xx,yy]=meshgrid(linspace(-3e7,3e7,20),linspace(-3e7,3e7,20));
% 
% %# calculate corresponding z
% zz = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
% 
% hold on
% surf(xx,yy,zz)


%% Plot visibilization cone
h = 1;
r = h/cosd(90-E_angle);
m = h/r;
[R,A] = meshgrid(linspace(0,2.5e7,10),linspace(0,2*pi,25));

X = (R .* cos(A));
Y = R .* sin(A);
Z = (m*R);

A=eye(3);
B = ltcmat(rcv_lla);
tmp = B(1,:);
B(1,:)= B(2,:);
B(2,:) = tmp;
C = inv(B')*A'

XP = zeros(size(X));
YP = zeros(size(Y));
ZP = zeros(size(Z));

for i=1:size(X,1)
    for j=1:size(X,2)
        tmp = C*[X(i,j) Y(i,j) Z(i,j)]';
        XP(i,j) = tmp(1);
        YP(i,j) = tmp(2);
        ZP(i,j) = tmp(3);
    end
end

hSurface = surf(XP+rcv_xyz(1),YP+ rcv_xyz(2),ZP+ rcv_xyz(3),'FaceColor','g','FaceAlpha',.4,'EdgeAlpha',.4)