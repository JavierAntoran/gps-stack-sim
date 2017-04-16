function [ f ] = plot_orbits( sat_xyz, orbits_xyz, earth_surface_image, varargin)
%PLOT_ORBITS Summary of this function goes here
%   Detailed explanation goes here
% Based on:
% Textured 3D Earth example
%
% Ryan Gray
% 8 Sep 2004
% Revised 9 March 2006, 31 Jan 2006, 16 Oct 2013
%
% Based on:
% CopyRight By Moein Mehrtash
% **************************************************************************
% Written by Moein Mehrtash, Concordia University, 3/28/2008              
% Email: moeinmehrtash@yahoo.com       


vis_sv = [];

if (nargin > 2) 
    vis_sv = varargin{1}
end

npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
GMST0 = []; % Don't set up rotatable globe (ECEF)
% GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0

f = figure

axis equal;
axis auto;
axis vis3d;

hold on;

sv_no=size(sat_xyz,2);

for i=1:sv_no
    
     if(~any(vis_sv == sat_xyz(1,i)))         
         color = 'k';
     else
         color = 'b';
     end
    
    Name_SV=strcat('SV-',num2str(sat_xyz(1,i)));
     
    plot3(orbits_xyz(:,i,1),orbits_xyz(:,i,2),orbits_xyz(:,i,3),'Linestyle','-')
    
    xlabel('Xaxis')
    ylabel('Yaxis')
    zlabel('Zaxis')

    sv_x = sat_xyz(2,i);
    sv_y = sat_xyz(3,i);
    sv_z = sat_xyz(4,i);
    
    plot3(sv_x,sv_y,sv_z,strcat(color,'o'),'Linewidth',2); % plot true anomaly
    text(sv_x+.1*sv_x,sv_y+.1*sv_y,sv_z+.1*sv_z,Name_SV);
end


% Create a 3D meshgrid of the sphere points using the ellipsoid function
% Mean spherical earth

erad    = 6371008.7714; % equatorial radius (meters)
prad    = 6371008.7714; % polar radius (meters)
erot    = 7.2921158553e-5; % earth rotation rate (radians/sec)


% I, J ,K, Vectors
plot3([0,2*erad],[0 0],[0 0],'black','Linewidth',2); plot3(2*erad,0,0,'black>','Linewidth',2.5);
plot3([0 0],[0,2*erad],[0 0],'black','Linewidth',2); plot3(0,2*erad,0,'black>','Linewidth',2.5);
plot3([0 0],[0 0],[0,2*erad],'black','Linewidth',2); plot3(0,0,2*erad,'black^','Linewidth',2.5);

xlabel('I');
ylabel('J');
zlabel('K');


[x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

globe = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

if ~isempty(GMST0)
    hgx = hgtransform;
    set(hgx,'Matrix', makehgtform('zrotate',GMST0));
    set(globe,'Parent',hgx);
end

% Texturemap the globe

% Load Earth image for texture map

cdata = imread(earth_surface_image);

% Set image as color data (cdata) property, and set face color to indicate
% a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.

set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');

az = 120;
el = 30;
view(az, el);
ylim([-3e7 3e7])
xlim([-3e7 3e7])
zlim([-3e7 3e7])
ax = gca;
ax.Clipping = 'off';

end

