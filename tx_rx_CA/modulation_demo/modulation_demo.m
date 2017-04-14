%% define parameters
clear all
close all
clc

base_clock = 10.23e6;
f_carrier = 154 .* base_clock / 100;
f_chip = base_clock / 10;
f_message = 50;
Lchip = 2^10 - 1;

fm = 4 * f_carrier;
Tm = 1/fm;

dur = 1;
t = 0:Tm:dur;
%% c/a code
PRN = CA_gen(1);
x = (-Lchip+1 : Lchip-1) / f_chip;
f = linspace(-f_chip, f_chip, 2*length(PRN(1,:))-1);
figure
subplot(2,1,1)
plot(x, xcorr(PRN(1,:)))
grid on
title('xcorr C/A SV 1')
xlabel('t (s)')
xlim([-Lchip, Lchip] / f_chip)
subplot(2,1,2)
plot(f, 10*log10(abs(fftshift(fft(xcorr(PRN(1,:)))))))
title('DEP C/A SV 1')
xlim([-f_chip, f_chip])
ylabel('dB')
grid on
xlabel('hz')
%% 
