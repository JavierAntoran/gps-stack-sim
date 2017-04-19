function [ modulator ] = generate_doppler( f_vec, L )
%GENERATE_DOPPLER generates a matrix to shift CA codes in frequency
%  INPUT:
% f_vec = frequency to shift each PRN
% L = samples per C/A code bit
%   OUTPUT:
% modulator = matrix which modulates CA code signal when multiplied (.*)
%
base_clock = 10.23e6;
Lchip = 2 ^ 10 - 1;
f_chip = base_clock/10;
Tchip = Lchip / f_chip;
fm = L * f_chip;
Tm = 1/fm;
t = Tm:Tm:Tchip;

if any(abs(f_vec) > 10000)
    frpintf('WARNING: frequency drift over 10Khz detected, receiver may fail')
end

modulator = real(exp(1i * 2* pi * f_vec' * t));

end

