function [ dop_f ] = doppler_shift( vs, vr, c, fo )
%DOPPLER_SHIFT calculates output frecuency for doppler effect system
%c: wave speed
%vr: receiver speed
%vs: source speed
%fo: original wave 
%
%dop_f: new frequency

dop_f = (c + vr) .* fo ./ (c + vs);

end

