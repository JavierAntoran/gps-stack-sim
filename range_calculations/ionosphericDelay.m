%% Obtain ionospheric delay
clear all
close all
clc
[EPH, IONO] = MOD_read_rinex_nav('brdc0920.17n');
%% lets go
A = EPH.sqrtA;
Delta_n = EPH.delta_n;
M0 = EPH.M0;
e = EPH.e;
toe = EPH.toe;
i0 = EPH.i0;
Omega0 = EPH.OMEGA;
omega = EPH.omega;
Omegadot = EPH.OMEGA_dot;
IDOT = EPH.i_dot;
C_us = EPH.Cus;
C_uc = EPH.Cuc;
C_rs = EPH.Crs;
C_rc = EPH.Crc;
C_is = EPH.Cis;
C_ic = EPH.Cic; 

%% ionospheric parameters
WEEK_s = IONO.deltaT;
Alpha = [IONO.A0 IONO.A1 IONO.A2 IONO.A4];
Beta = [IONO.B0 IONO.B1 IONO.B2 IONO.B4];
