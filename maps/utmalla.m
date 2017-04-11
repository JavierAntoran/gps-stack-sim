function [longdec,latgdec]=UTMaLLA(lon0gdec,x,y,a,e2);

%
%    UTMaLLA Conversión de x e y UTM a longitud y
% latitud elipsoidales.
%
% [longdec,latdec]=UTMaLLA(lon0gdec,x,y,a,e2);
%
% Parámetros de entrada:
%  lon0gdec: longitud (en grados decimales) del meridiano
%     central del huso de trabajo;
%	x: vector de easting UTM en metros;
%	y: vector de northing UTM en metros;
%	a: semieje mayor del elipsoide;
%	e2: cuadrado de la excentricidad del elipsoide;
%
% Parámetros de salida:
%	logdec: vector de longitudes en grados decimales;
%	latdec: vector de latitudes en grados decimales;
%
% NOTA: convendría introducir el huso en lugar de long0dec
% NOTA2: De momento sólo es válido para el hemisferio Norte.
%


x=x-500000;
lon0=lon0gdec*pi/180;
lat0=0;

k0=0.9996;

eprima2=e2/(1-e2);
e1=(1-sqrt(1-e2))/(1+sqrt(1-e2));
M0=a*((1-e2/4-3*e2^2/64-5*e2^3/256)*lat0-(3*e2/8+3*e2^2/32+...
  45*e2^3/1024)*sin(2*lat0)+(15*e2^2/256+45*e2^3/1024)*sin(4*lat0)-...
  (35*e2^3/3072)*sin(6*lat0));
M=M0+y/k0;
mu=M/a/(1-e2/4-3*e2^2/64-5*e2^3/256);

lat1=mu+(3*e1/2-27*e1^3/32)*sin(2*mu)+(21*e1^2/16-55*e1^4/32)*sin(4*mu)+...
   (151*e1^3/96)*sin(6*mu);

C1=eprima2*(cos(lat1)).^2;
T1=(tan(lat1)).^2;
N1=a./sqrt(1-e2*(sin(lat1)).^2);
R1=a*(1-e2)./((1-e2*(sin(lat1)).^2).^1.5);
D=x./(k0*N1);

lat=lat1-(N1.*tan(lat1)./R1).*(D.^2/2-(5+3*T1+10*C1-4*C1.^2-9*eprima2).*D.^4/24+...
   (61+90*T1+298*C1+45*T1.^2-252*eprima2-3*C1.^2).*D.^6/720);
lon=lon0+(D-(1+2*T1+C1).*D.^3/6+(5-2*C1+28*T1-3*C1.^2+...
   8*eprima2+24*T1.^2).*D.^5/120)./cos(lat1);

latgdec=lat*180/pi;
longdec=lon*180/pi;

