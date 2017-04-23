function [ lat, lon, alt ] = xyz2lla( x, y, z, a, e2 )
% ECEF2LLA - convert earth-centered earth-fixed (ECEF)
%            cartesian coordinates to latitude, longitude,
%            and altitude
%
% USAGE:
% [lat,lon,alt] = ECEF2GPS(x,y,z)
%
% lat(phi) = geodetic latitude (radians)
% lon(lambda) = longitude (radians)
% alt = height above WGS84 ellipsoid (m)
% x = ECEF X-coordinate (m)
% y = ECEF Y-coordinate (m)
% z = ECEF Z-coordinate (m)
%
% Notes: (1) This function assumes the WGS84 model.
%        (2) Latitude is customary geodetic (not geocentric).
%        (3) Inputs may be scalars, vectors, or matrices of the same
%            size and shape. Outputs will have that same size and shape.
%        (4) Tested but no warranty; use at your own risk.
%        (5) Michael Kleder, April 2006


% calculations:
b   = sqrt(a^2*(1-e2));
ep  = sqrt((a^2-b^2)/b^2);
p   = sqrt(x^2+y^2);
th  = atan2(a*z,b*p);
lon = atan2(y,x);
lat = atan((z+ep^2*b*(sin(th))^3)/(p-e2*a*(cos(th))^3));
N   = a/sqrt(1-e2*(sin(lat))^2);
alt = p/cos(lat)-N;

% correct for numerical instability in altitude near exact poles:
% (after this correction, error is about 2 millimeters, which is about
% the same as the numerical precision of the overall function)

k=abs(x)<1 & abs(y)<1;
alt(k) = abs(z(k))-b;

end

