function [sCA] = CA_gen(pulseLength)
%generates C/A codes for all SV

%space vehicles c/a codes differ by the tap on the second register
total_SV = 32;

% C/A CODE GENERATION
Lchip = 1023;
CA = zeros(total_SV, Lchip);
for i = 1:total_SV
    CA(i,:) = CAsequence(i);
end

%base band signal generation
CA(CA==0) = -1;
pulso = ones(1, pulseLength);
p = pulso;%pulso/sqrt(sum(pulso .^ 2)); si trabajaramos con potencia y ruido
sCA = kron(CA, p);

end