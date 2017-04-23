function [x, y, z] = lla2xyz( fi, lambda, h, a, e2 )

z = (a.*(1-e2)./sqrt(1 - e2 .* sin(fi).^2) + h) .* sin(fi);
y = (a ./ sqrt(1 - e2 .* sin(fi).^2) + h) .* cos(fi) .* sin(lambda);
x = (a ./ sqrt(1 - e2 .* sin(fi).^2) + h) .* cos(fi) .* cos(lambda);

end