function [ aquired, pr_delay ] = SV_CAsearch( srx, L )
% correlation search for satellites

rec_sCA = CA_gen(L); % generamos codigos CA de todos los satelites
%check vissible SV xcorr search
max_SV = 32;
checkSV = 1:max_SV; %checks all possible SV
corrsearch = zeros(max_SV, 2 * L * 1023 - 1);
for i = checkSV
    corrsearch(i,:) = xcorr(srx, rec_sCA(i, :));
end


detect_lim = L * 1023 * 2 / 5 - 1; % lowered threshold because of noise;
[peak, rdelay_samples] = max(corrsearch, [], 2);

aquired = checkSV(peak >= detect_lim);%detected SV index
pr_delay = rdelay_samples(peak >= detect_lim);

% TODO: surf(corrsearch)
end

