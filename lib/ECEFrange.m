function [ dist ] = ECEFrange( SVx, SVy, SVz, gx, gy, gz )

dist = sqrt((SVx - gx).^2 + (SVy - gy).^2 + (SVz - gz).^2)';

end