%% doppler 
L = 50;
max_doppler_shift = 1e4;

c = 2.99792458e8;
base_clock = 10.23e6;
out_freq = doppler_shift(1000, 0, c, base_clock * 154);

d_shift = out_freq - base_clock * 154

f_chip = base_clock / 10;
Lchip = 2 ^ 10 - 1;
Tchip = Lchip / f_chip;
fm = f_chip * L;
Tm = 1/fm;
t = 0:Tm:Tchip;
modulator = exp(1i * 2* pi * d_shift * t);



