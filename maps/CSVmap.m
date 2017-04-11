clc
clear all
close all
R = worldfileread('mtn50_epsg25830_0354.tfw');
[ortho, cmap] = imread('mtn50_epsg25830_0354.tif');
%mapshow(ortho, cmap, R);
extra_inf = geotiffinfo('mtn50_epsg25830_0354.tif');
%%
data = csvread('tr.csv');
Pos = data(:,2:end);
%
for i = 1:length(Pos(:,1))
    P(i,:) = ECEF2GPS([Pos(i,1), Pos(i,2), Pos(i,3)]);
end

wgs_a = 6378137;
wgs_e2 = 0.00669437999014;

wgs_lambda = P(:,2);
wgs_fi = P(:,1);
wgs_h = P(:,3);

% Pasamos a XYZ
[x, y, z] = LLAtoXYZ( wgs_fi, wgs_lambda, wgs_h, wgs_a, wgs_e2 );

%pasamos a ETRS89

etrs_a = 6378137;
etrs_f = 1/298.257222101;

etrs_e2 = FtoE2(etrs_f);

[ etrs_fi, etrs_lambda, etrs_height ] = XYZtoLLA( x, y, z, etrs_a, etrs_e2 );

%Pasamos a UTM X Y
pos = -3;
[utm_x, utm_y] = llaautm(pos, etrs_fi*180/pi, etrs_lambda*180/pi, etrs_a, etrs_e2);

%% Ploteamos
mapshow(ortho, cmap, R);
pause(5);
hold on
for (i = 1:length(utm_x))
    pause(0.01);
    scatter(utm_x(i), utm_y(i));
end
%%
hold on
scatter(utm_x, utm_y);
%%
steps = length(utm_x);
PH = utm_x;
PV = utm_y;

T = 1:steps;
incH = PH(2:end) - PH(1:end-1);
incV = PV(2:end) - PV(1:end-1);
incD = ( incH.^2 + incV.^2 ).^(1/2);
incT = T(2:end) - T(1:end-1); % porque no mide con frecuencia constante??


miV = (incD ./ incT');
figure
plot(T(1:end-1), miV)
%%
%medidas de calidad
t = T-T(1);

figure 
plot(t,Vxy)
hold on
plot(t,A)