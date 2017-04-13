function [ f ] = plot_orbits( orbit_parameters, earth_surface_image )
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



space_color = 'k';
npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible
%GMST0 = []; % Don't set up rotatable globe (ECEF)
GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0


[m,n]=size(orbit_parameters.svid);

E=orbit_parameters.E;
A=orbit_parameters.A;
ec=orbit_parameters.e;
Inc=orbit_parameters.I;
Omega=orbit_parameters.Omega;
v=orbit_parameters.v;

%f = figure('Color', space_color);
f = figure

% hold on;

% Turn off the normal axes
% 
% set(gca, 'NextPlot','add', 'Visible','off');
% 
% axis equal;
% axis auto;
% 
% % Set initial view
% 
% view(0,30);
% 
% axis vis3d;

for i=1:n
    ii=num2str(i);
    Name_SV=strcat('SV-',num2str(orbit_parameters.svid(i)));
     
    Nu=0:2*pi/100:2*pi;
    r=A(i)*(1-ec(i)^2)./(1+ec(i).*cos(Nu));
    x = r.*cos(Nu);
    y = r.*sin(Nu);

    xs=x.*cos(Omega(i))-y.*cos(Inc(i)).*sin(Omega(i));
    ys=x.*sin(Omega(i))+y.*cos(Inc(i)).*cos(Omega(i));
    zs=y.*sin(Inc(i));
    plot3(xs,ys,zs,'Linestyle','-')

    hold on
    xlabel('Xaxis')
    ylabel('Yaxis')
    zlabel('Zaxis')



    r0=A(i)*(1-ec(i)^2)/(1+ec(i)*cos(v(i)));
    x0 = r0*cos(v(i));
    y0 = r0*sin(v(i));

    xp=x0*cos(Omega(i))-y0*cos(Inc(i))*sin(Omega(i));
    yp=x0*sin(Omega(i))+y0*cos(Inc(i))*cos(Omega(i));
    zp=y0*sin(Inc(i));

    plot3(xp,yp,zp,'wo','Linewidth',2); % plot true anomaly
    text(xp+.1*xp,yp+.1*yp,zp+.1*zp,Name_SV);


    axis_data = get(gca);
    xmin = axis_data.XLim(1);
    xmax = axis_data.XLim(2);
    ymin = axis_data.YLim(1);
    ymax = axis_data.YLim(2);
    zmin = axis_data.ZLim(1);
    zmax = axis_data.ZLim(2);



    % right ascending node line plot
    xomega_max = xmax*cos(Omega(i)*pi/180);
    xomega_min = xmin*cos(Omega(i)*pi/180);
    yomega_max = ymax*sin(Omega(i)*pi/180);
    yomega_min = ymin*sin(Omega(i)*pi/180);


 
end
% I, J ,K vectors
R=6399592;

plot3([0,2*R],[0 0],[0 0],'black','Linewidth',2); plot3(2*R,0,0,'black>','Linewidth',2.5);
plot3([0 0],[0,2*R],[0 0],'black','Linewidth',2); plot3(0,2*R,0,'black>','Linewidth',2.5);
plot3([0 0],[0 0],[0,2*R],'black','Linewidth',2); plot3(0,0,2*R,'black^','Linewidth',2.5);

xlabel('I');
ylabel('J');
zlabel('K');

% Create a 3D meshgrid of the sphere points using the ellipsoid function
% Mean spherical earth

erad    = 6371008.7714; % equatorial radius (meters)
prad    = 6371008.7714; % polar radius (meters)
erot    = 7.2921158553e-5; % earth rotation rate (radians/sec)

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

hold on
az = 120;
el = 30;
view(az, el);
ylim([-3e7 3e7])
xlim([-3e7 3e7])
zlim([-3e7 3e7])
ax = gca;
ax.Clipping = 'off';

end

