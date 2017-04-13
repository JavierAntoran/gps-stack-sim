function [ dt ] = gpst2utc( week_number, reference_time, leap_seconds )
%GPST2UTC Summary of this function goes here
%   Detailed explanation goes here
gps_offset = posixtime(datetime(1980,01,06,0,0,0));

utime = gps_offset + (week_number*7*24*3600) + reference_time + leap_seconds;

dt = datetime(utime,'ConvertFrom','posixtime','TimeZone','UTC')

end

