function [ su, secuencial ] = corrSec( canal )

polinomio = [0 0 0 1 0 0 0 0 0 0 1]; %polinomio generador

muestras =1e5;

L = length(polinomio);
Lt = 2^L-1;

%seclength = floor(Lt)/2;

iteraciones = floor(muestras / Lt);

hay = (polinomio == 1);

regist = zeros(1,L);
regist(1) = 1;

out = zeros(1,Lt);

for k = 1:Lt %generacion de secuencia
    
    out(k) = regist(end);
    
    bit = mod(sum(regist(hay)), 2);
    
    regist(2:end) = regist(1:end-1);
    
    regist(1) = bit;
    
    
end

secuencial = out;

%binario to bipolar
out(out==0) = -1;
out = out;

s = repmat(out, 1, iteraciones);
s = vertcat(s(:), zeros(1,muestras-length(s))')';


r = canal(s);


r = r(1:end-(muestras-length(s)));

c = conv(r, out(end:-1:1));

pad = round((length(c)-length(r))/2); 

c = c(pad:end-pad);

su = zeros(1, Lt);

for i2 = 1:iteraciones %promediado
    su = su + (c((i2*Lt-Lt+1):i2*Lt) );
end

su = su./iteraciones;
su = su/max(su);%normalizacion

pos = find(su == max(su));%encontramos maximo

su = su(pos-50:pos+50); % centramos en la delta

su(abs(su) < 0.05) = 0; %filtrado de ruido


end

