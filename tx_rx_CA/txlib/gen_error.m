function [ sat_clock_offset, sat_clock_rel, iono_T, trop_T_equiv ] = gen_error( head, eph, time, Rpos )
% includes tropo, iono, clock error and relativistic clock
% although the clock errors are not strictly caused by the channel
if nargin == 2
    time = head.deltaT;
end
CURRENT_TIME = time;
c = 2.99792458e8;
GM = 3.986005e14; %Grav constant * Earth mass
F = -2 * sqrt(GM) / c.^2;
T_amb=20; %degrees celsius
P_amb=101; %kilo pascal
P_vap=.86;
% satellite position ecef (I think)

satp = rinex2ecef(head, eph, time);
SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);
pSV = [SVx; SVy; SVz]';
% (earth postion ECEF I think)

gx = Rpos(1);
gy = Rpos(2);
gz = Rpos(3);

real_pr = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
rec_pos=[gx gy gz];

% CLOCK OFFSET NON ITERATIVE
Toc = eph.toc; %time of clock of specific satellite relative to deltaT
% TOC IS UPDATED BY NAV MESSAGE i believe
Ttr = CURRENT_TIME - real_pr ./ c;%gps time seconds
%since week start(rinex) - (minus) transmision time
% deltaT - txt - toc = current time minus tx time minus reference moment (frame emission time)
%delta.t and toc count time starting at the begining of current week
af = [eph.af0; eph.af1; eph.af2]';%bias, drift, drift rate
sat_clock_offset=Error_Satellite_Clock_Offset(af,Ttr,Toc); %sec
%R_c_offset = sat_clock_offset * c;

% SAT CLOCK RELATIVISTIC TIME CORRECTION non iterative
A = eph.sqrtA.^2;
meanAnomaly  = eph.M0;
tgd = eph.TGD; %group delay
%delay because time in space is not the same as on earth
sat_clock_rel=Error_Satellite_Clock_Relavastic(F,eph.e,A,meanAnomaly,tgd); %sec     
%R_rel_offset=sat_clock_rel * c; 
    
%  ionospheric error non iterative
Alpha = [head.A0 head.A1 head.A2 head.A3];
Beta = [head.B0 head.B1 head.B2 head.B3];
iono_T = Error_Ionospheric_Klobuchar(rec_pos, pSV ,Alpha, Beta, CURRENT_TIME);%(Sec)
%R_iono=iono_T * c;   

% tropospheric time
trop_T_equiv = Error_Tropospheric_Hopfield(T_amb,P_amb,P_vap, rec_pos, pSV) ./ c;
%R_trop = trop_T_equiv * c;
end

