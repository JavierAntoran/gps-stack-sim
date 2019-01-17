function [ enu ] = ecef2enu( xyz, tmat )
%ECEF2NEU Convert Earth-centered Earth-Fixed to Local east, north, up (ENU)
% [in] xyz Input position as vector in ECEF format
% [in] t Intermediate matrix computed by \ref ltcmat
% [out] neu Output position as East-North-Up format

    enu = tmat*xyz';

end

