%% 
clear all
close all
ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/Almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');
c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP
%space vehicles c/a codes differ by the tap on the second register
% lets get some codes
total_SV = 4;
Lchip = 1023;
CA = zeros(total_SV, Lchip);
for i = 1:total_SV
    CA(i,:) = CAsequence(i);
    
end
%CA = 2.*(CA-0.5);
f_chip = base_clock / 10;
Tchip = Lchip/f_chip;
% GET SAT POSITIONS ECEF

[eph, head] = read_rinex_nav('brdc0920.17n',1:total_SV);
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
gps_sec = gps_sec + head.leapSeconds; %current time
satp = rinex2ecef(head, eph, gps_sec);
SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);

Rpos = [ 3.894192036606761e+06 3.189618244369670e+05 5.024275884645306e+06];
gx = Rpos(1);
gy = Rpos(2);
gz = Rpos(3);

distVec = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
delayVec = distVec ./ c;

%
pulseLength = 50; % fixed pulseLength// samples per C/A bit

fm = f_chip * pulseLength;
Tm = 1 / fm;

samples_chip = Lchip * pulseLength;

CA(CA==0) = -1;
pulso = ones(1, pulseLength);
p = pulso;%pulso/sqrt(sum(pulso .^ 2));
%
corrsearch = zeros(total_SV, Lchip * pulseLength * 2 -1);

sCA = kron(CA, p);
round_delay = mod(round(delayVec .* fm), samples_chip); %precision loss with round augment fm
delayCA  = cell2mat(arrayfun(@(k) circshift(sCA(k,:),round_delay(k) , 2)', 1:size(sCA,1),'uni',0))';

for i = 1:total_SV
    corrsearch(i, :) = xcorr(delayCA(i,: ), sCA(i, :));
end


[peak, rdelay_samples] = max(corrsearch, [], 2);
rdelay_samples = mod(rdelay_samples, samples_chip);
rdelay = rdelay_samples * Tm;
%rdelay * c
% calculate overlap cicles

cicles = floor(delayVec ./ Tchip); %obtain extra cicles from delay vec (unrealisic)

bad_pr = (cicles * Tchip + rdelay) * c
%error = mean(abs(distVec - bad_pr))
%%
figure
t = 0:Tm:Tchip-Tm; %muestras de senal recibida
plot(t, delayCA(1,:));
%%
figure
corrt = -Tchip+Tm:Tm:Tchip-Tm;
plot(corrt, xcorr(sCA(1,:)));
%%
plot(corrt, corrsearch(4,:));