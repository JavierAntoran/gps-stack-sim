function [ vis_sv ] = visible_sv( satp, rcv_lla, e_mask )
% VISIBLE_SV Search for visible SV given an observation position and elevation
% satp: SV positions
% rcv_lla: receiver position in geodetic latitude, longitude, altitude (LLA) coordinates
% e_mask: Elevation angle in degrees
%

% Get just coordinates, first column is PRN
sat_xyz = satp(2:4,:);

WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;
[rcvxyz(1), rcvxyz(2), rcvxyz(3)] = lla2xyz(rcv_lla(1), rcv_lla(2), rcv_lla(3),WGS84.a,WGS84.e2);
[ elevation, azimuth ] = azel( rcvxyz', sat_xyz );

% Filtered SV, where Elevation needed is greater
vis_sv = satp(1,find(rad2deg(elevation)>e_mask));

end

