function [ secuence ] = gold_secuence(set1, set2, tap1, tap2 )
%GOLD_SECUENCE used by GPS

%sets are the positions that sum in the shift register. taps are the
%positions that are read.

%sup binary
L_pol = 10; %posiblemente dado
L_t = 2.^L_pol-1;

%obtencion de polinomios
polinomio1 = zeros(1,L_pol);
polinomio2 = zeros(1,L_pol);

polinomio1(set1) = 1;
polinomio2(set2) = 1;

sec1 = pn_sec_gen(polinomio1, tap1);
sec2 = pn_sec_gen(polinomio2, tap2);

secuence = xor(sec1,sec2);


end

