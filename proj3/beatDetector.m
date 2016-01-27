function tempo = beatDetector(x,fs)
% BEATDETECTOR From audio signal estimate temo (bpm) by looking at beat onset information
%	TEMPO = BEATDETECTOR(X,fs)
%
% 

wlen = .02*fs;
noverlap = wlen/2;

stride = wlen - noverlap;

erms = windowedEnergyQuantizer(x,wlen,noverlap);

d_erms = diff(erms);
d_erms(d_erms<0) = 0; % zero out terms with decreasing energy

pulseSpacing = diff(find(d_erms>0));

tempo = stride.*pulseSpacing./fs; % spacing in seconds

tempo = 60./tempo;

end % function
