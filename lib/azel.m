function [ azel ] = azel( rcvpos, satpos )
%AZEL Summary of this function goes here
%   Detailed explanation goes here

%VISIBLE_SV Summary of this function goes here
%   Detailed explanation goes here
sat_xyz = satp(2:4,:);

WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;
rcv_xyz = [ 0 0 0 ];
[rcv_xyz(1) rcv_xyz(2) rcv_xyz(3)]= LLAtoXYZ(rcv_lla(1), rcv_lla(2), rcv_lla(3),WGS84.a,WGS84.e2);

los = (sat_xyz - kron(rcv_xyz', ones(1,size(sat_xyz,2))));

lla2enu_tm = ltcmat(rcv_lla);

los_enu = lla2enu_tm*los;

azimuth = atan2(los_enu(1,:),los_enu(2,:));
azimuth(azimuth<0) = azimuth(azimuth<0)+2*pi;

ne = (los_enu(2,:).^2 + los_enu(1,:).^2).^(1/2);
elevation = atan2(los_enu(3,:), ne);
    
vis_sv = satp(1,find(rad2deg(elevation)>e_mask));


end

