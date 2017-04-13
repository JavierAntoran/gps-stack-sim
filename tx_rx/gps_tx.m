function [s_bb, cicles, nSV] = gps_tx(file, time, Rpos, pulseLength, channel)

if nargin == 2
    channel = true;
end

c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP
%space vehicles c/a codes differ by the tap on the second register
total_SV = 4;

% C/A CODE GENERATION
Lchip = 1023;
CA = zeros(total_SV, Lchip);
for i = 1:total_SV
    CA(i,:) = CAsequence(i);
end
f_chip = base_clock / 10;
Tchip = Lchip / f_chip;

% GET SAT POSITIONS ECEF
[eph, head] = read_rinex_nav(file,total_SV);

satp = rinex2ecef(head, eph, time);

SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);

% SET receiver position
gx = Rpos(1);
gy = Rpos(2);
gz = Rpos(2);

% get exact distance from SAT to receiver
distVec = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
delayVec = distVec ./ c; %get delay for said distances

% set sample freq
fm = f_chip * pulseLength;
Tm = 1 / fm;
samples_chip = Lchip * pulseLength;

%base band signal generation
CA(CA==0) = -1;
pulso = ones(1, pulseLength);
p = pulso;%pulso/sqrt(sum(pulso .^ 2)); si trabajaramos con potencia y ruido
sCA = kron(CA, p);
round_delay = mod(round(delayVec .* fm), samples_chip); %precision loss with round augment fm
delayCA  = cell2mat(arrayfun(@(k) circshift(sCA(k,:),round_delay(k) , 2)', 1:size(sCA,1),'uni',0))';

% calculate overlap cicles
% send as nav message (time info)
cicles = floor(delayVec ./ Tchip);

if channel
    s_bb = delayCA;
else
    s_bb = sCA;
end
nSV = total_SV;
end