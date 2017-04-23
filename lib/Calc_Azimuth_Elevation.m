%This Function Compute Azimuth and Elevation of satellite from reciever 
%CopyRight By Moein Mehrtash
%************************************************************************
% Written by Moein Mehrtash, Concordia University, 3/21/2008            *
% Email: moeinmehrtash@yahoo.com                                        *
%************************************************************************           
%    ==================================================================
%    Input :                                                            *
%        Pos_Rcv       : XYZ position of reciever               (Meter) *
%        Pos_SV        : XYZ matrix position of GPS satellites  (Meter) *
%    Output:                                                            *
%        E             :Elevation (Rad)                                 *
%        A             :Azimuth   (Rad)                                 *
%************************************************************************           


function [E,A]=Calc_Azimuth_Elevation(Pos_Rcv,Pos_SV)

R=Pos_SV-Pos_Rcv;               %vector from Reciever to Satellite

GPS_Rcv = [ 0 0 0 ];
[GPS_Rcv(1) GPS_Rcv(2) GPS_Rcv(3)] = xyz2lla(Pos_Rcv(1), Pos_Rcv(2), Pos_Rcv(3), WGS84.a, WGS84.e2);
%Lattitude and Longitude of Reciever
Lat=GPS(1);Lon=GPS(2);

lla2enu_tm = ltcmat(GPS_Rcv);
ENU=ecef2enu(R,lla2enu_tm);
Elevation=asin(ENU(3)/norm(ENU));
Azimuth=atan2(ENU(1)/norm(ENU),ENU(2)/norm(ENU));
E=Elevation;
A=Azimuth;
