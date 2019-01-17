function [ elevation, azimuth ] = azel( rcvpos, satpos )
%AZEL Summary of this function goes here
%   Detailed explanation goes here

%VISIBLE_SV Summary of this function goes here
%   Detailed explanation goes here

WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;

rcv_lla = [ 0 0 0 ];
% Convert to ECEF
[rcv_lla(1), rcv_lla(2), rcv_lla(3)] = xyz2lla(rcvpos(1),rcvpos(2), rcvpos(3), WGS84.a, WGS84.e2);

% Difference between SV position and receiver (Line Of Sight)
los = (satpos - kron(rcvpos, ones(1,size(satpos,2))));

% Transformation matrix for ECEF
lla2enu_tm = ltcmat(rcv_lla);

los_enu = lla2enu_tm*los;

% Azimuth from los
azimuth = atan2(los_enu(1,:),los_enu(2,:));
azimuth(azimuth<0) = azimuth(azimuth<0)+2*pi;

% Extract elevation for each SV from receiver
ne = (los_enu(2,:).^2 + los_enu(1,:).^2).^(1/2);
elevation = atan2(los_enu(3,:), ne);

end

