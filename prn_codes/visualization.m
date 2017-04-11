clear all;
% pn secuence generation

set1 = [3,10];
tap1 = [10];

set2 = [2,3,6,8,9,10];
tap2 = [2,6]; %configuracion satelite 1

sec_ = gold_secuence(set1, set2, tap1, tap2);
sec1 = 2*(sec_-0.5);

subplot(2,1,1)
plot(xcorr(sec1))
title('xcorr')
%hold on
subplot(2,1,2)
plot(10*log10(abs(fftshift(fft(xcorr(sec1))))))
title('DEP')

%% Generacion de senal sin datos (no anda con las graficas sin cambiar alguna cosa)
f = 1e9;%154.*10.23e6; %frecuencia portadora
f_pn = 5e8;%10.23e6/10; %frecuencia pn
T_m = 1e-12; %T muestreo
muestras = 1e6; %para no agotar memoria

t = (1:muestras)*T_m;
x = sin(2*pi*f*t);
d = floor(mod((f_pn*t),1023))+1; %esto igual esta mal he truncado y sumado 1

s = x.*sec1(d);

%% Generacion senal con datos

rb = 1e3; %tasa bits datos
f = 1e5;%154.*10.23e6; %frecuencia portadora
f_pn = 5e4;%10.23e6/10; %frecuencia pn
T_m = 1e-7; %T muestreo
muestras = 1e6; %para no agotar memoria

t = (1:muestras)*T_m;
x = sin(2*pi*f*t);
d = floor(mod((f_pn*t),1023))+1; %esto igual esta mal he truncado y sumado 1
d2 = floor(rb*t)+1;

dat = (2*round(rand(1,1e4))-1);

m = x.*dat(d2); %senal modulada con datos 
s = m.*sec1(d); % senal spread


%%
figure
fn = linspace(-1/(2*T_m), 1/(2*T_m), length(xcorr(x)));
plot(fn, 10*log10(abs(fftshift(fft(xcorr(x))))))
hold on
plot(fn, 10*log10(abs(fftshift(fft(xcorr(s))))))
plot(fn, 10*log10(abs(fftshift(fft(xcorr(m))))))
xlim([-5*f,5*f]);
title('DEPs')
xlabel('hercios');
legend('carrier', 'spread','data non spread');
%%
figure
hold on
plot(t,s)
plot(t,sec1(d))
plot(t,dat(d2))
legend('senal enviada','secuencia pn', 'data');
xlabel('time (s)')