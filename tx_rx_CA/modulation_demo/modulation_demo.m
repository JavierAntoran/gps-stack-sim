%% define parameters
clear all
close all
clc
Lchip = 2^10 -1;
base_clock = 10.23e6;
f_carrier = 154 .* base_clock / 100;
f_chip = base_clock / 10;
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
%% Correlation between 2 codes
x = (-Lchip+1 : Lchip-1) / f_chip;
figure
plot(x, xcorr(PRN(1,:), PRN(2,:)))
grid on
title('corr cruzada C/A SV1 SV2 ')
xlabel('t (s)')
xlim([-Lchip, Lchip] / f_chip)
%% Correlation in a delayed code
shiftCA = circshift(PRN(1,:), 327, 2);
x = (-Lchip+1 : Lchip-1) / f_chip;
figure
plot(x, xcorr(PRN(1,:), shiftCA))
grid on
title('corr C/A SV1 con SV1\_delay')
xlabel('t (s)')
xlim([-Lchip, Lchip] / f_chip)
%% 

delay = round(rand(1, size(PRN,1))*1023);
delay_CA  = cell2mat(arrayfun(@(k) circshift(PRN(k,:), delay(k) , 2)', 1:size(PRN,1),'uni',0))';
sats = [3 23];
sCA = sum(delay_CA(sats,:),1);

for i = 1:32
corrsearch(i,:) = xcorr(PRN(i,:), sCA);
end

h = surf(kron(corrsearch, ones(1,1)),'FaceColor','interp');
set(h,'LineStyle','none')
colormap jet
colorbar
caxis([0, 1023/2])
title('busqueda satelites')
zlabel('amplitud correlacion')
ylabel('N satelite')
xlabel('muestras')
%% modulation
base_clock = 10.23e6;
f_carrier = 154 .* base_clock / 100;
f_chip = base_clock / 10;
f_message = 50;

fm = 4 * f_carrier;
Tm = 1/fm;

dur = 1;
t = 0:Tm:dur;