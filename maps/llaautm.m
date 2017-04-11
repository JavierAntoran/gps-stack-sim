function [x,y]=llaautm(lon0gdec,latgdec,longdec,a,e2)

%
%    LLAaUTM Conversión de longitud y latitud elipsoidales
% a coordenadas UTM.
%
% [x,y]=LLAaUTM(lon0gdec,latgdec,longdec,a,e2);
%
% Parámetros de entrada:
% 	long0dec: longitud del meridiano central (en grados
%	     decimales) del huso de trabajo;
%	latgdec: vector de latitudes en grados decimales;
%	longdec: vector de longitudes en grados decimales;
%	a: semieje mayor del elipsoide;
%	e2: cuadrado de la excentricidad del elipsoide;
%
% Parámetros de salida:
%	x: vector de easting UTM;
%	y: vector de northing UTM.
%
% NOTA: convendría automatizar el cálculo de long0dec del huso
%   de trabajo en función de las coordenadas de los puntos introducidos.
%

lat=latgdec*pi/180;
lon=longdec*pi/180;
lon0=lon0gdec*pi/180;
lat0=0;

k0=0.9996;
eprima2=e2/(1-e2);
N=a./sqrt(1-e2*(sin(lat)).^2);
T=(tan(lat)).^2;
C=eprima2*(cos(lat)).^2;
A=cos(lat).*(lon-lon0);    
M=a*((1-e2/4-3*e2^2/64-5*e2^3/256)*lat-(3*e2/8+3*e2^2/32+...
  45*e2^3/1024)*sin(2*lat)+(15*e2^2/256+45*e2^3/1024)*sin(4*lat)-...
  (35*e2^3/3072)*sin(6*lat));

M0=a*((1-e2/4-3*e2^2/64-5*e2^3/256)*lat0-(3*e2/8+3*e2^2/32+...
  45*e2^3/1024)*sin(2*lat0)+(15*e2^2/256+45*e2^3/1024)*sin(4*lat0)-...
  (35*e2^3/3072)*sin(6*lat0));

x=k0*N.*(A+(1-T+C).*A.^3/6+(5-18*T+T.^2+72*C-58*eprima2).*A.^5/120);

x=x+500000;

y=k0*(M-M0+N.*tan(lat).*(A.^2/2+(5-T+9*C+4*C.^2).*A.^4/24+...
  (61-58*T+T.^2+600*C-330*eprima2).*A.^6/720));

if(y<0)
  y=y+10000000;
end

