function [ out ] = pn_sec_gen( poli, tap )

%generates Pn secuence of a given polinomial

L = length(poli);
Lt = 2.^L-1;

if (nargin == 1)
    tap = L;
end;

hay = (poli == 1);

regist = zeros(1,L);
regist(1) = 1; % puede ser que todos deban ser 1

out = zeros(1,Lt);

for k = 1:Lt %generacion de secuencia
    
    out(k) = mod(sum(regist(tap)),2);
    
    bit = mod(sum(regist(hay)), 2);
    
    regist(2:end) = regist(1:end-1);
    
    regist(1) = bit;
    
end



end

