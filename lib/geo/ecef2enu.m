function [ enu ] = ecef2enu( xyz, tmat )
%ECEF2NEU Summary of this function goes here
% Convert Earth-centered Earth-Fixed to ?
% [in] xyz Input position as vector in ECEF format
% [in] t Intermediate matrix computed by \ref ltcmat
% [out] neu Output position as East-North-Up format

    enu = tmat*xyz';

end

