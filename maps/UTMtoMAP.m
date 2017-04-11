function [ PH, PV ] = UTMtoMAP( utm_x, utm_y, ctrlp_x, ctrlp_y, ctrlc_x, ctrlc_y, mapfile, debug )

u = utm_x;
v = utm_y;
P = [ctrlp_x ctrlp_y];

C = [ones( length(ctrlc_x), 1) ctrlc_x ctrlc_y];

Cm = inv(C' * C) * C';

A = Cm * P;

a = A(:,1);
b = A(:,2);

PH = (a(1) + a(2) * u + a(3) * v);
PV = (b(1) + b(2) * u + b(3) * v);


if debug == 1
    
    [zgz, map] = imread(mapfile);
    trainP = C * A;
    figure
    image(zgz)
    colormap(map)
    hold on
    scatter(trainP(:,1), trainP(:,2), 'Xb','LineWidth',15)
    title('puntos de calibracion')
    
end
end

