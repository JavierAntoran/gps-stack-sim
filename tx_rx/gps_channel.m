function [] = gps_channel(file, time, Rpos, sCA, L)

[ R_c_offset, R_rel_offset, R_iono, R_trop ] = gen_channel( head, eph, time, Rpos );
[ delayVec ] = propagation_delay( head, eph, time, Rpos );

t_delay = delayVec + R_c_offset + R_rel_offset + R_iono + R_trop;

end