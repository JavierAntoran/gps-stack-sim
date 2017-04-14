%% 
clear all 
close all
clc
ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

visible_SV = [1 4 6 23 2 5];
[eph, head] = read_rinex_nav('brdc0920.17n', visible_SV);
visible_SV = eph.PRN;
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
time = gps_sec + head.leapSeconds;

c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP


L = 50; %samples per CA bit. fm = fchip * L. More renults ib better precision

%define receiver pos
Rpos = [ 3.894192036606761e+06 3.189618244369670e+05 5.024275884645306e+06]; % north france
% generate GPS signals

sCA = CA_gen(L, visible_SV);
%
% modulation demo goes here
%

% pass signal through channel: distance + iono + tropo + clock

[delay_CA, cicles] = gps_channel(head, eph, time, Rpos, sCA, L);
srx = sum(delay_CA, 1);

% receiver. cicles are obtained as nav message
%%
%obtain SV postions 

c = 2.99792458e8;
base_clock = 10.23e6; %reloj atomico super DEP

L = 50; %samples per CA bit. 
f_chip = base_clock / 10;
fm = f_chip * L; %More results in better precision
Tm = 1/fm;
Lchip = 1023;
Tchip = Lchip/f_chip;
samples_chip = Lchip * L;

[ index, pr_delay_abs_samples ] = SV_finder( srx, L );

ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

[eph, head] = read_rinex_nav('brdc0920.17n', index);

satp = rinex2ecef(head, eph, time);
SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);
pSV = [SVx; SVy; SVz]';
%
pr_delay_samples = mod(pr_delay_abs_samples, samples_chip);
pr_delay = pr_delay_samples * Tm;

pseudo_range0 = (pr_delay +  cicles * Tchip)' * c;

%We will apply the following formula:
%pr0 = real_range + clock_drift + relativistic + iono + tropo

%variables for drift (iterative)
af = [eph.af0; eph.af1; eph.af2]';%bias, drift, drift rate
Toc = eph.toc; %time of clock of specific satellite relative to deltaT
% TOC IS UPDATED BY NAV MESSAGE i believe



% SAT CLOCK RELATIVISTIC TIME CORRECTION non iterative
A = eph.sqrtA.^2;
meanAnomaly  = eph.M0;
GM = 3.986005e14; %Grav constant * Earth mass
F = -2 * sqrt(GM) / c.^2;
tgd = eph.TGD; %group delay
T_amb=20; %degrees celsius
P_amb=101; %kilo pascal
P_vap=.86;
%delay because time in space is not the same as on earth
clock_relativistic=Error_Satellite_Clock_Relavastic(F,eph.e,A,meanAnomaly,tgd); %sec 
R_rel_offset = clock_relativistic * c; 

pseudo_range0 = (pseudo_range0 - R_rel_offset);

% iterative decoding
rec_pos = [0 0 0];
[G0, delta_x, N_rec_pos(1, :) ,B0]=Gen_G_DX_XYZ_B(pSV, rec_pos, pseudo_range0);
i = 1;

pseudo_range(1,:) = pseudo_range0;
rec_pos = N_rec_pos(1, :);

while (norm(delta_x(1:3)) > 5)
   
    %clock drift
    Ttr = time - pseudo_range(i,:) ./ c;%gps time seconds
    clock_drift=Error_Satellite_Clock_Offset(af,Ttr,Toc); %sec
    R_c_offset(i, :) = clock_drift * c;
    
    %ionospheric delay
    Alpha = [head.A0 head.A1 head.A2 head.A3];
    Beta = [head.B0 head.B1 head.B2 head.B3];
    iono_T = Error_Ionospheric_Klobuchar(rec_pos, pSV ,Alpha, Beta, time);%(Sec)
    R_iono(i, :)=iono_T * c;   
    
    %tropospheric
    
    R_trop(i, :) = Error_Tropospheric_Hopfield(T_amb,P_amb,P_vap, rec_pos, pSV);
    
    % real range aprox
    
    pseudo_range(i + 1, :) = pseudo_range0 -  R_c_offset(i, :) - R_iono(i, :) - R_trop(i, :);
    
    i = i + 1;
    [G0, delta_x, N_rec_pos(i, :) ,B0]=Gen_G_DX_XYZ_B(pSV, rec_pos, pseudo_range(i, :));
    rec_pos = N_rec_pos(i, :);
end

(Rpos - rec_pos)