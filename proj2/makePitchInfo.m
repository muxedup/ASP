function [pitchinfo, zcrs, amps] = makePitchInfo(x, fs, wlen, noverlap)
% MAKEPITCHINFO Takes input audio signal and uses autocorrelation to detect pitch
%	PITCHINFO = MAKEPITCHINFO(X, FS, WLEN, NOVERLAP)
%
% x - input audio frequency signal
% fs - sampling frequency
% wlen - window length
% noverlap - overlap length in points
% Returns pitch information vector with -1 for silence, 0 for unvoiced, and a pitch value 
% in hertz for voiced sections.

stride = wlen - noverlap;

nwins = floor(length(x)/stride)+1;
pitchinfo = zeros(1,nwins);
zcrs = pitchinfo;
amps = pitchinfo;
for ii=0:nwins-1
    curridx = ii*stride + 1;
    if curridx+wlen-1 < length(x)
        currsamp = x(curridx:curridx+wlen-1);
    else
        currsamp = x(curridx:end);
    end
	
	amp = rms(currsamp);
    amp = amp/wlen; % normalize to rms energy per sample (window length invariant)
    amps(ii+1) = amp;
    if amp < 3e-5 % for this file this is noise threshold, but could change
        pitchinfo(ii+1) = -1; % silence
    else
        zcn = length(zerocross(currsamp));
        zcr = zcn/(wlen/fs);
        zcrs(ii+1) = zcr;
        if zcr > 4000 % Decide voiced/ unvoiced
            pitchinfo(ii+1) = 0;  % unvoiced
        else
            Cl = .6.*max(abs([currsamp(1:ceil(wlen/3)) currsamp(ceil(2*wlen/3):end)]));
            Cl = min(Cl);
			
            currsamp(Cl >= abs(currsamp)) = 0;
            currsamp(currsamp < -Cl) = -1;
            currsamp(currsamp > Cl) = 1;
            [y, lags] = xcorr(currsamp);
            [~, locs] = findpeaks(y,lags,'MinPeakProminence',2,'MinPeakDistance',50,'SortStr','descend','NPeaks',3);
            
            if length(locs) > 1 % successfully found zero and at least 1 pk
                pitchinfo(ii+1) = fs/abs(locs(2));
            elseif abs(locs) < 160  && locs ~=0 % pitch >100 Hz and not at lag 0
                pitchinfo(ii+1) = fs/abs(locs);
            end
        end
    end
end    
end % function
