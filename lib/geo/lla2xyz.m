function [x, y, z] = lla2xyz( fi, lambda, h, a, e2 )
% lla2xyz Convert geodetic latitude, longitude, altitude (LLA) coordinates
% to XYZ
%
% lat(phi) = geodetic latitude (radians)
% lon(lambda) = longitude (radians)
% h = height above WGS84 ellipsoid (m)
% a Semi-major axis
% e2 First eccentricity squared


z = (a.*(1-e2)./sqrt(1 - e2 .* sin(fi).^2) + h) .* sin(fi);
y = (a ./ sqrt(1 - e2 .* sin(fi).^2) + h) .* cos(fi) .* sin(lambda);
x = (a ./ sqrt(1 - e2 .* sin(fi).^2) + h) .* cos(fi) .* cos(lambda);

end