%% lets go
clear all
close all
c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP
%space vehicles c/a codes differ by the tap on the second register
% lets get some codes
total_SV = 32;
Lchip = 1023;
CA = zeros(total_SV, Lchip);
for i = 1:total_SV
    CA(i,:) = CAsequence(i);
    
end
%CA = 2.*(CA-0.5);
f_chip = base_clock / 10;
Tchip = Lchip/f_chip;
% GET SAT POSITIONS ECEF
SVx = [1 2];
SVy = [1 2];
SVz = [1 2];

gx = 1;
gy = 1;
gz = 1;

distVec = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
delayVec = distVec ./ c;

%
pulseLength = 40; % fixed pulseLength// samples per C/A bit

fm = f_chip * pulseLength;
Tm = 1 / fm;

M = 2;
pulso = ones(pulseLength, 1);
p = pulso/sqrt(sum(pulso .^ 2));

sCA = zeros(total_SV, Lchip * pulseLength);
for i = 1:2
    [a , d_k] = transmisor_MPAM(M, CA(i,:), pulseLength, p);
    sCA(i, :) = a(pulseLength:end);
    round_delay = round(delayVec(i) .* fm);
    delayCA = circshift(sCA(i, :), round_delay);
end

t = 0:Tm:Tchip-Tm; %muestras de senal recibida
plot(t, sCA(1,:));