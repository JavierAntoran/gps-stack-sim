%% lets go
clear all
close all
get_lib_path();
c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP
%space vehicles c/a codes differ by the tap on the second register
% lets get some codes
total_SV = 20;
Lchip = 1023;
CA = zeros(total_SV, Lchip);
for i = 1:total_SV
    CA(i,:) = CAsequence(i);
    
end
%CA = 2.*(CA-0.5);
f_chip = base_clock / 10;
Tchip = Lchip/f_chip;
% GET SAT POSITIONS ECEF

[eph, head] = read_rinex_nav('brdc0920.17n',total_SV);
satp = rinex2ecef(head, eph);
SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);

gx = 3.8941e6;
gy = 3.189e5;
gz = 5.0242e5;

distVec = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
delayVec = distVec ./ c;

%
pulseLength = 50; % fixed pulseLength// samples per C/A bit

fm = f_chip * pulseLength;
Tm = 1 / fm;

samples_chip = Lchip * pulseLength;

M = 2;
pulso = ones(pulseLength, 1);
p = pulso;%pulso/sqrt(sum(pulso .^ 2));
%
sCA = zeros(total_SV, Lchip * pulseLength);
delayCA = zeros(total_SV, Lchip * pulseLength);
corrsearch = zeros(total_SV, Lchip * pulseLength * 2 -1);
for i = 1:total_SV
    [a , d_k] = transmisor_MPAM(M, CA(i,:), pulseLength, p);
    sCA(i, :) = a(1:end-pulseLength+1);
    round_delay = round(delayVec(i) .* fm); %precision loss with round augment fm
    delayCA(i, :) = circshift(sCA(i, :), round_delay, 2);
    corrsearch(i, :) = xcorr(delayCA(i,: ), sCA(i, :));
end


[peak, rdelay_samples] = max(corrsearch, [], 2);
rdelay_samples = mod(rdelay_samples, samples_chip);
rdelay = rdelay_samples * Tm;
% calculate overlap cicles

cicles = floor(delayVec ./ Tchip); %obtain extra cicles from delay vec (unrealisic)

bad_pr = (cicles * Tchip + rdelay) * c;

error = mean(distVec - bad_pr)
%%
figure
t = 0:Tm:Tchip-Tm; %muestras de senal recibida
plot(t, delayCA(1,:));
%
figure
corrt = -Tchip+Tm:Tm:Tchip-Tm;
plot(corrt, corrsearch(4,:));