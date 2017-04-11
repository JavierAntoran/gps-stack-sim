function [ x, y, z ] = WGStoED50( x0, y0, z0 )
dex = -84;
dey = -107;
dez = -120;

x = x0 - dex;
y = y0 - dey;
z = z0 - dez;

end

