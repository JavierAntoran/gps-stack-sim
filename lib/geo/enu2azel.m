function [ azel ] = enu2azel( enu )
% Convert Eeast-North-Up to Azimuth + Elevation
% [in] neu Input position in Eeast-North-Up format
% [out] azel Output array of azimuth + elevation as double

azel = zeros(2,size(enu,1));
azel(1,:) = atan2(enu(1,:),enu(2,:));
azel(find(azel<0)) = azel(find(azel<0))+(2*pi);

ne = sqrt(enu(2,:).^2 + enu(1,:).^2);
azel(2,:) = atan2(enu(3,:), ne);

end

