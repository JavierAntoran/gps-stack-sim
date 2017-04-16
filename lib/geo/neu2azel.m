function [ azel ] = neu2azel( neu )
% Convert North-Eeast-Up to Azimuth + Elevation
% [in] neu Input position in North-East-Up format
% [out] azel Output array of azimuth + elevation as double

azel = zeros(2,size(neu,2));
azel(1,:) = atan2(neu(2,:),neu(1,:));
azel(find(azel<0)) = azel(find(azel<0))+(2*pi);

ne = sqrt(neu(1,:).^2 + neu(2,:).^2);
azel(2,:) = atan2(neu(3,:), ne);

end

