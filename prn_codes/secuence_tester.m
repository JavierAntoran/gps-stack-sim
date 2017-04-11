clear all
%comprueba que senal recuperada tras spreading es igual a original.
polinomio = [0 0 0 1 0 0 0 0 0 0 1]; %polinomio generador

muestras =1e5;
n = 1:muestras;

L = length(polinomio);
Lt = 2^L-1;


%iteraciones = floor(muestras / Lt);

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
red = [11];
pol_alt = pn_sec_gen(polinomio,red);
max(pol_alt-out)
%%
out(out == 0 ) = -1;

x = sin(n(1:Lt));
x_spread = x.*out;
x_recovered = x_spread.*out;

X = abs(fft(x));
X_spread = abs(fft(x_spread));
X_recovered = abs(fft(x_recovered));

DEP_X = 10*log10(abs(fft(xcorr(x))));
DEP_X_spread = 10*log10(abs(fft(xcorr(x_spread))));

stem(X,'g')
hold on
stem(X_spread)
stem(X_recovered,'--')
title('FFT');
legend(' portadora original', 'portadora spread', 'senal recuperada');

figure
plot(DEP_X,'g')
hold on
plot(DEP_X_spread)
title('DEP')
legend('DEP X', 'DEP X spread');