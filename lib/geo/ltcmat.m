function [ t ] = ltcmat( llh )
% Compute the intermediate matrix for LLH to ECEF
% llh Input position in Longitude-Latitude-Height format
% out t Three-by-Three output matrix

    slon = sin(llh(1));
	clon = cos(llh(1));
	slat = sin(llh(2));
	clat = cos(llh(2));
	
    t = zeros(3,3);
      
    t(1,:) = [-slat      clat       0.0 ];
	t(2,:) = [-slon*clat -slon*slat clon];
	t(3,:) = [clon*clat  clon*slat  slon];
    

end

