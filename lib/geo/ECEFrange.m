function [ dist ] = ECEFrange( SVx, SVy, SVz, gx, gy, gz )
% ECEFrange Calculates distance between observer and SV

dist = sqrt((SVx - gx).^2 + (SVy - gy).^2 + (SVz - gz).^2)';

end