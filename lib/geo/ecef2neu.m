function [ neu ] = ecef2neu( xyz, tmat )
%ECEF2NEU Summary of this function goes here
% Convert Earth-centered Earth-Fixed to ?
% [in] xyz Input position as vector in ECEF format
% [in] t Intermediate matrix computed by \ref ltcmat
% [out] neu Output position as North-East-Up format

    neu = zeros(size(xyz));
	neu(1,:) = tmat(1,1)*xyz(1,:) + tmat(1,2)*xyz(2,:) + tmat(1,3)*xyz(3,:);
	neu(2,:) = tmat(2,1)*xyz(1,:) + tmat(2,2)*xyz(2,:) + tmat(2,3)*xyz(3,:);
	neu(3,:) = tmat(3,1)*xyz(1,:) + tmat(3,2)*xyz(2,:) + tmat(3,3)*xyz(3,:);

end

