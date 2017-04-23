function [ delayVec ] = propagation_delay( head, eph, time, Rpos )

c = 2.99792458e8;

satp = eph2ecef(eph, time);

SVx = satp(2,:);
SVy = satp(3,:);
SVz = satp(4,:);

% SET receiver position
gx = Rpos(1);
gy = Rpos(2);
gz = Rpos(3);

% get exact distance from SAT to receiver
distVec = ECEFrange(SVx, SVy, SVz, gx, gy, gz);
delayVec = distVec ./ c; %get delay for said distances


end

