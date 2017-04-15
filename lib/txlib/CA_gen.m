function [sCA] = CA_gen(pulseLength, SV_vec)
%generates C/A codes for all SV

%space vehicles c/a codes differ by the tap on the second register
total_SV = 32;
if nargin == 1
    SV_vec = 1:total_SV;
end
% C/A CODE GENERATION
Lchip = 1023;
CA = zeros(length(SV_vec), Lchip);

for i = 1:length(SV_vec)
    CA(i,:) = CAsequence(SV_vec(i));
end

%base band signal generation
CA(CA==0) = -1;
pulso = ones(1, pulseLength);
p = pulso;%pulso/sqrt(sum(pulso .^ 2)); si trabajaramos con potencia y ruido
sCA = kron(CA, p);

end