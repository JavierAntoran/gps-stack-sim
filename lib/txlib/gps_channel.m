function [delay_CA, cicles, prop_delay, sat_clock_offset, sat_clock_rel, iono_T, trop_T_equiv] = gps_channel(head, eph, time, Rpos, sCA, L)

% includes tropo, iono, clock error and relativistic clock
% although the clock errors are not strictly caused by the channel

[sat_clock_offset, sat_clock_rel, iono_T, trop_T_equiv] = gen_error( head, eph, time, Rpos );
[ prop_delay ] = propagation_delay( head, eph, time, Rpos );

external_delay = sat_clock_offset + sat_clock_rel + iono_T + trop_T_equiv;


[delay_CA, cicles] = apply_delay(sCA, prop_delay, external_delay, L);

end