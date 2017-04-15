function [ delay_CA, cicles ] = apply_delay( sCA, prop_delay, other_delay, L)

Lchip = 1023;
base_clock = 10.23e6;
f_chip = base_clock / 10;
Tchip = Lchip / f_chip;
fm = f_chip * L;
Tm = 1 / fm;
samples_chip = Lchip * L;

round_delay = mod(round((prop_delay + other_delay') .* fm), samples_chip); %precision loss with round augment fm
delay_CA  = cell2mat(arrayfun(@(k) circshift(sCA(k,:),round_delay(k) , 2)', 1:size(sCA,1),'uni',0))';

% calculate overlap cicles from propagation with nav message time
% send as nav message (time info)
cicles = floor((prop_delay + other_delay') ./ Tchip);

end

