function [ satp, orbit_parameters ] = rinex2ecef( r_head, r_eph )
%RINEX2ECEF Summary of this function goes here
%   Detailed explanation goes here

% Copyright (c) 2016, Meysam Mahooti
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

GM = 3.986005e14;             % earth's universal gravitational [m^3/s^2]
c = 2.99792458e8;             % speed of light (m/s)
omegae_dot = 7.2921151467e-5; % earth's rotation rate (rad/sec)

tsv=r_head.deltaT;

a = (r_eph.sqrtA).^2;

% for tsv = 1:100:24*3600
nn = size(r_eph.PRN,2);
for ii = 1:nn
    % Procedure for coordinate calculation
    n0 = sqrt(GM/a(ii)^3); % (rad/s)    
    tk = tsv-r_eph.toe(ii);      % Time from eph ref epoch (s)
    n = n0+r_eph.delta_n(ii);    % Corrected mean motion (rad/s)
    M = r_eph.M0(ii)+n*tk;       % Mean anomaly (rad/s)

    % Perform Newton-Raphson solution for Eccentric anomaly estimate (rad)
    NRnext = 0;
    NR = 1;
    m = 1;
    for i=1:10
        NR=NRnext;
        f=NR-r_eph.e(ii)*sin(NR)-M;
        f1=1-r_eph.e(ii)*cos(NR);
        f2=r_eph.e(ii)*sin(NR);
        NRnext=NR-(f/(f1-(f2*f/2*f1)));
        m=m+1;
    end
    E=NRnext; % Eccentric anomaly estimate for computing delta_tr (rad)

    % Time correction
    F = -2*sqrt(GM)/c^2; % (s/m^1/2)
    delta_tr = F*r_eph.e(ii)*sqrt(a(ii))*sin(E);
    delta_tsv = r_eph.af0(ii)+r_eph.af1(ii)*(tsv-r_eph.toe(ii))+delta_tr;
    t = tsv-delta_tsv;

    tk=t-r_eph.toe(ii);  		 % Time from eph ref epoch (s)
    M=r_eph.M0(ii)+n*tk;	     % Mean anomaly (rad/s)

    %Perform Newton-Raphson solution for Eccentric anomaly (rad)
    NRnext=0;
    NR=1;
    m=1;
    for i=1:10
        NR=NRnext;
        f=NR-r_eph.e(ii)*sin(NR)-M;
        f1=1-r_eph.e(ii)*cos(NR);
        f2=r_eph.e(ii)*sin(NR);
        NRnext=NR-(f/(f1-(f2*f/2*f1)));
        m=m+1;
    end;
    E=NRnext; % Eccentric anomaly (rad)

    v = atan2(sqrt(1-r_eph.e(ii)^2)*sin(E), cos(E)-r_eph.e(ii)); % True anomaly
    phi = v+r_eph.omega(ii);
    u = phi                    + r_eph.Cuc(ii)*cos(2*phi)+r_eph.Cus(ii)*sin(2*phi);
    r = a(ii)*(1-r_eph.e(ii)*cos(E)) + r_eph.Crc(ii)*cos(2*phi)+r_eph.Crs(ii)*sin(2*phi);
    i = r_eph.i0(ii)+r_eph.i_dot(ii)*tk     + r_eph.Cic(ii)*cos(2*phi)+r_eph.Cis(ii)*sin(2*phi);
    Omega = r_eph.OMEGA(ii)+(r_eph.OMEGA_dot(ii)-omegae_dot)*tk-omegae_dot*r_eph.toe(ii);
    x1 = cos(u)*r;
    y1 = sin(u)*r;

    % ECEF coordinates    
    satp(1,ii) = r_eph.PRN(ii);
    satp(2,ii) = x1*cos(Omega)-y1*cos(i)*sin(Omega);
    satp(3,ii) = x1*sin(Omega)+y1*cos(i)*cos(Omega);
    satp(4,ii) = y1*sin(i);  
    
    orbit_parameters.svid(ii) = r_eph.PRN(ii);
    orbit_parameters.E(ii) = E;
    orbit_parameters.A(ii) = a(ii);
    orbit_parameters.I(ii) = i;
    orbit_parameters.Omega(ii) = Omega;
    orbit_parameters.v(ii) = v;
    orbit_parameters.e = r_eph.e;
    
end

end

