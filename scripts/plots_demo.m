%% define parameters
clear all
close all
clc
Lchip = 2^10 -1;
base_clock = 10.23e6;
f_carrier = 154 .* base_clock;
f_chip = base_clock / 10;

ROOTDIR = fileparts(get_lib_path);
almFile = strcat(ROOTDIR,'/files/almanac/W918.alm');
ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');

%% plot vissible SV from postion on earth

ROOTDIR = fileparts(get_lib_path);

ephFile = strcat(ROOTDIR,'/files/ephemeris/brdc0920.17n');
image_file = fullfile(ROOTDIR,'/sv/land_ocean_ice_2048.png');

% Read rinex navigation file
[r_eph, r_head] = read_rinex_nav(ephFile, 1:32);

% Get GPS time
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
% Add leap seconds from ephemerides
gps_sec = gps_sec+r_head.leapSeconds;

% Convert ephemerides to ECEF and get orbit parameters
[ satp, orbit_parameters ] = eph2ecef(r_eph, gps_sec);

% Receiver position in LLA
rcv_lla = [ deg2rad(41.6835944) deg2rad(-0.8885864) 201];
%rcv_lla = [ deg2rad(-36.848461) deg2rad(174.763336) 21];

% Elevatoin angle
E_angle = 30;

% Get visible space vehicles from rcv_lla
vis_sv = visible_sv(satp, rcv_lla, E_angle);

% SV orbit and visibility plot

plot_orbits(satp, orbit_parameters, image_file, vis_sv);

% Ellipsoid parameters
WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;

% Receiver ECEF position
rcv_xyz = [ 0 0 0 ];
[rcv_xyz(1) rcv_xyz(2) rcv_xyz(3)]= lla2xyz(rcv_lla(1), rcv_lla(2), rcv_lla(3),WGS84.a,WGS84.e2);


% Plot receiver position
scatter3(rcv_xyz(1), rcv_xyz(2), rcv_xyz(3), 'yo')

% Plot visibility cone
h = 1;
r = h/cosd(90-E_angle);
m = h/r;
[R,A] = meshgrid(linspace(0,2.5e7,10),linspace(0,2*pi,25));

X = (R .* cos(A));
Y = R .* sin(A);
Z = (m*R);


A=eye(3);
B = ltcmat(rcv_lla);
C = inv(B')*A'

XP = zeros(size(X));
YP = zeros(size(Y));
ZP = zeros(size(Z));

for i=1:size(X,1)
    for j=1:size(X,2)
        tmp = C*[X(i,j) Y(i,j) Z(i,j)]';
        XP(i,j) = tmp(1);
        YP(i,j) = tmp(2);
        ZP(i,j) = tmp(3);
    end
end

hSurface = surf(XP+rcv_xyz(1),YP+ rcv_xyz(2),ZP+ rcv_xyz(3),'FaceColor','g','FaceAlpha',.4,'EdgeAlpha',.4);
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
title('PSD C/A SV 1')
xlim([-f_chip, f_chip])
ylabel('dB')
grid on
xlabel('hz')
%% signal at receiver (after all error + doppler)

[eph, head] = read_rinex_nav(ephFile, 1:32);
[~, gps_sec] = cal2gpstime([2017 04 04 16 51 30]);
time = gps_sec + head.leapSeconds;
satp = eph2ecef(eph, time);

Rpos = [ 3.894192036606761e+06 3.189618244369670e+05 5.024275884645306e+06]; % ECEF

WGS84.a = 6378137;
WGS84.e2 = (8.1819190842622e-2).^2;

rcv_lla = [ 0 0 0 ];
[rcv_lla(1), rcv_lla(2), rcv_lla(3)] = xyz2lla(Rpos(1), Rpos(2), Rpos(3), WGS84.a, WGS84.e2);
e_mask = 30; %smallest angle between receiver and satellites for these to be visible 
visible_SV = visible_sv( satp, rcv_lla, e_mask );
[eph, head] = read_rinex_nav(ephFile, visible_SV);
vis_sv = visible_SV;
L = 1;
sCA = CA_gen(L, vis_sv);
Nsv = length(vis_sv);

%doppler
shift_vals = (-1e4:50:1e4);
f_vec = randi(length(shift_vals), 1, Nsv);
doppler_carrier = generate_doppler( shift_vals(f_vec), L );
sCA_dop = sCA .* doppler_carrier; %add doppler shift

[delay_CA, cicles, prop_delay_0, sat_clock_offset_0, sat_clock_rel_0, iono_T_0, trop_T_equiv_0] = gps_channel(head, eph, time, Rpos, sCA_dop, L);
srx = sum(delay_CA, 1);

%% base band signal in time
figure
t = 1/f_chip:1/f_chip:1e-3;
subplot(2,1,1)
plot(t, sCA(1, :));
grid on
axis tight
title('C/A code SV1')
ylabel('V')
xlabel('t (s)')
xlim([0 3e-4])
subplot(2,1,2)
plot(t, srx)
grid on
axis tight
xlabel('t (s)')
ylabel('V')
title('signal + error, delay and shift')
xlim([0 3e-4])

%%  equivalent spectral density (base band for better performance)

noise_power = 1;
noise_floor = noise_power * randn(1, length(delay_CA(1,:)));

t = 1/f_chip:1/f_chip:1e-3;
res = 5;
f = f_carrier + (linspace(-1023/2, 1023/2, res * 1023));

rb_message = 2000; % switched for plotting pruposes, in real scenario is 50

message_index = floor(rb_message*t)+1;
message_dat = (2*round(rand(1,length(t)))-1);
message_samples = message_dat(message_index);

PSD_carrier = 1 * 10*log10(abs(fftshift(fft(cos(0 * t), res * 1023))));
PSD_message = 10*log10(abs(fftshift(fft(message_samples, res * 1023))));
PSD_SV = 10*log10(abs(fftshift(fft(srx, res * 1023))));


figure
hold on 
grid on
axis tight
plot(f, PSD_message - max(PSD_carrier));
plot(f, PSD_carrier - max(PSD_carrier));
plot(f, PSD_SV - max(PSD_carrier))
legend( 'PSD\_nav\_message', 'PSD\_carrier', 'received signal')
xlabel('Hz')
title('spectral density at receiver')
ylabel('dB')
ylim([-30 0])

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
%% C/A code search for all SV

delay = round(rand(1, size(PRN,1))*1023);
delay_CA  = cell2mat(arrayfun(@(k) circshift(PRN(k,:), delay(k) , 2)', 1:size(PRN,1),'uni',0))';
sats = vis_sv;
sCA = sum(delay_CA(sats,:),1);

for i = 1:32
corrsearch(i,:) = xcorr(PRN(i,:), sCA);
end

h = surf(kron(corrsearch, ones(1,1)),'FaceColor','interp');
set(h,'LineStyle','none')
colormap jet
colorbar
caxis([0, 1023/2])
title('Search for all SV in code space. No Doppler shift.')
zlabel('correlation amplitude')
ylabel('N SV')
xlabel('samples')
%% code + phase search

%% modulated signal generation (carrier frequency/100 for better performance)
base_clock = 10.23e6;
f_carrier = 154 .* base_clock / 100;
f_chip = base_clock / 10;
rb_message = 50;

fm = 4 * f_carrier;
Tm = 1/fm;

dur = 0.1;
t = 0:Tm:dur;

carrier = sin(2*pi*f_carrier*t);

CA = CA_gen(1);
CA = CA(1,:);
ca_index = floor(mod((f_chip*t),1023))+1;
ca_samples = CA(ca_index);

message_index = floor(rb_message*t)+1;
message_dat = (2*round(rand(1,length(t)))-1);
message_samples = message_dat(message_index);

s_dat = carrier .* message_samples;
s_CA = s_dat .* ca_samples;
%% plotting spectral density at real frequency / 100
figure 
fn = linspace(-1/(2*Tm), 1/(2*Tm), length(xcorr(carrier)));
PSD_carrier = 10*log10(abs(fftshift(fft(xcorr(carrier)))));
ref = max(PSD_carrier);
a = plot(fn, PSD_carrier-ref);
hold on
PSD_mod_nav = 10*log10(abs(fftshift(fft(xcorr(s_dat)))));
PSD_mod_CA = 10*log10(abs(fftshift(fft(xcorr(s_CA)))));
b = plot(fn, PSD_mod_nav-ref);
c = plot(fn, PSD_mod_CA-ref);
xlim([f_carrier - 1.5*f_chip, f_carrier + 1.5*f_chip]);
title('PSD')
xlabel('hz');
ylabel('dB')
grid on
legend('carrier', 'nav message', 'CA');
%% time domain plotting
figure
hold on
plot(t,s_CA)
plot(t,ca_samples)
plot(t,message_samples)
title('SV1 signal in time')
legend('modulated signal','pn sequence', 'data');
xlabel('time (s)')