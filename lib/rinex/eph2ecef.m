function [sat_xyz, orbit_parameters, orbits_xyz] = eph2ecef(eph ,tsv) 

%EPH2ECEF Summary of this function goes here
%   Detailed explanation goes here

sv_no = numel(eph.PRN);


% Constant Parameter of this function
GM = 3.986005e14;             % earth's universal gravitational [m^3/s^2]
c = 2.99792458e8;             % speed of light (m/s)
omegae_dot = 7.2921151467e-5; % earth's rotation rate (rad/sec)


A = eph.sqrtA.^2;

%************************************************************************** 
%************************************************************************** 
%Compute Time From Ephemeris Refernce Epoch
%Input:
    %t(sec):GPS Sys. Time
    %toe(sec):Reference Time Ephemeris
%Output:
    %tk(sec):Time from ephemeris reference epoch
t=tsv-eph.toe;

%************************************************************************** 
%************************************************************************** 
%Compute corrected mean motion
%Input:
    %A(meter): Semi-major axis
    %Mu(meter^3/sec^2): value of Earth's universal gravitational parameters
    %tk(sec):Time from Ephemeris Reference Epoch
    %Delta_n(semi-circle/sec):Mean Motion Diference From Computed Value
    %M0(semi-circles):
%Output:
    %n0(Rad/sec):Computed mean motion 
    %n(semi-circle/sec):Corrected mean motion
    %Mk(semi-circle):Mean anomaly
n0=(GM./(A.^3)).^(1/2);
n=(n0)+eph.delta_n;
M=eph.M0+n.*t;

% compute the eccentric anomaly from mean anomaly using
% Newton-Raphson method to solve for 'E' in:  
%		f(E) = M - E + ecc * sin(E) = 0
% E = M; 
% for i = 1:10
%   f = M - E + (eph.e).* sin(E);
%   dfdE = -1+(eph.e).*cos(E); 
%   dE = -f./dfdE; 
%   E = E + dE;
% end

%
% Perform Newton-Raphson solution for Eccentric anomaly estimate (rad)
NRnext = 0;
for i=1:10
    NR=NRnext;
    f=NR-eph.e.*sin(NR)-M;
    f1=1-eph.e.*cos(NR);
    f2=eph.e.*sin(NR);
    NRnext=NR-(f./(f1-(f2.*f./2.*f1)));
end
E=NRnext; % Eccentric anomaly estimate for computing delta_tr (rad)

% Time correction
F = -2*sqrt(GM)/c^2; % (s/m^1/2)
delta_tr = F.*(eph.e).*(A.^(1/2)).*sin(E);
delta_tsv = (eph.af0)+(eph.af1).*(tsv-(eph.toe))+delta_tr;
t = tsv-delta_tsv;

t=t-(eph.toe);  		 % Time from eph ref epoch (s)
M=eph.M0+n.*t;	     % Mean anomaly (rad/s)

%Perform Newton-Raphson solution for Eccentric anomaly (rad)
NRnext=0;
for i=1:10
    NR=NRnext;
    f=NR-eph.e.*sin(NR)-M;
    f1=1-eph.e.*cos(NR);
    f2=eph.e.*sin(NR);
    NRnext=NR-(f./(f1-(f2.*f./2.*f1)));
end
E=NRnext; % Eccentric anomaly (rad)

%**************************************************************************
%************************************************************************** 
%Compute True Anomaly as a Function of Eccentric Anomaly
%Input:
    %Ek(Rad):  Eccentric Anomaly
    %e      :  Eccentricity
%Output:
    %nuk(Rad): True Anomaly
sin_nu=((1-(eph.e).^2).^(1/2)).*sin(E)./(1-(eph.e).*cos(E));
cos_nu=(cos(E)-(eph.e))./(1-(eph.e).*cos(E));
v=atan2(sin_nu,cos_nu);

v(v<0) = v(v<0) + 2*pi;

%**************************************************************************
%************************************************************************** 
%Compute Argumet of Lattitude and Correction
%Input:
    %nuk(Rad): True Anomaly
    %omega(semicircle):  Argument of perigee
%Output:
    %Phik(Rad):  Argument of lattitude
phi= v + eph.omega;

%**************************************************************************
%************************************************************************** 
%Compute Argumet of Lattitude,Radious and Inclination Correction
%SEcond Harmonic Perturbation
%Input:
    %Phik(Rad):  Argument of lattitude
    %C_us:Amplitude of the cosine harmonic correction term to the argument
    %     of lattitude(Rad)
    %C_uc:Amplitude of the sine harmonic correction term to the argument
    %     of lattitude(Rad)
    %C_rs:Amplitude of the cosine harmonic correction term to orbit
    %radius(meter)
    %C_rc:Amplitude of the sine harmonic correction term to orbit
    %radius(meter)
    %C_is:Amplitude of the cosine harmonic correction term to the angle of
    %     inclination(Rad)
    %C_ic:Amplitude of the sine harmonic correction term to the angle of
    %     inclination(Rad)
%Output:
    % Delta_uk(Rad):Argument of lattitude correction
    % Delta_rk(meter):Argument of radius correction
    % Delta_ik(Rad):Argument of inclination correction
delta_u =eph.Cus.*sin(2*phi)+eph.Cuc.*cos(2*phi);
delta_r =eph.Crs.*sin(2*phi)+eph.Crc.*cos(2*phi);
delta_i =eph.Cis.*sin(2*phi)+eph.Cic.*cos(2*phi);


%**************************************************************************
%************************************************************************** 
%Compute Corrected Value of Lattitude,Radious,Inclination and Ascendong
%node
%Input:
    % Phik(Rad):  Argument of lattitude
    % A(meter): Semi-major axis
    % Ek(Rad):  Eccentric Anomaly
    % e:  Eccentricity    
    % i0(semi-circle): inlination angle at reference time
    % Omega0(semi-circle): Refernce Longitude of Ascending Node
    % Omegadot(semi-circle/sec): rate of right ascension
    % Omega_dote(rad/sec):WGS 84 value of the earth's rotation rate
    % IDOT(semi-circle/sec): rate of inlination angle
    % Delta_uk(Rad):Argument of lattitude correction
    % Delta_rk(meter):Argument of radius correction
    % Delta_ik(Rad):Argument of inclination correction
%Output:
    % uk(Rad):Corrcted argument of lattitude
    % rk(meter): corrected radius
    % ik(Rad):corrected inclination
    % Omegak(Rad):Corrected longitude of ascending node.
u = phi + delta_u;              %Latitude
r = A.*(1-(eph.e).*cos(E))+ delta_r;   %Radious
i = (eph.i0)+delta_i+(eph.i_dot).*t;  %Inclination

Omega= eph.OMEGA + (eph.OMEGA_dot-omegae_dot).*t-omegae_dot.*eph.toe;

%**************************************************************************
%************************************************************************** 
%Compute satellite vehicle position
%Satellite position in orbital plane
x_pop = r.*cos(u);
y_pop = r.*sin(u);

%Satellite Position in ECEF
x = x_pop.*cos(Omega)-y_pop.*cos(i).*sin(Omega);
y = x_pop.*sin(Omega)+y_pop.*cos(i).*cos(Omega);
z = y_pop.*sin(i);

sat_xyz = [ eph.PRN; x; y; z ];

orbit_parameters.svid = eph.PRN;
orbit_parameters.E = E;
orbit_parameters.A = A;
orbit_parameters.I = i;
orbit_parameters.Omega = Omega;
orbit_parameters.c = v;
orbit_parameters.e = eph.e;
orbit_parameters.r = r;
orbit_parameters.u = u;
