function Erms = windowedEnergyQuantizer(x, wlen, noverlap)
% WINDOWEDENERGYQUANTIZER Windowed RMS energy of a signal
%	ERMS = WINDOWEDENERGYQUANTIZER(X, WIN, NOVERLAP)
%
% windowedEnergyQuantizer returns the time varying RMS energy
% of an input signal.
%
%  windowedEnergyQuantizer.m
%  proj3
%
%  Created by Munan Xu on 2015-11-22.
%  Copyright 2015 Munan Xu. All rights reserved.
%



stride = wlen - noverlap;
alen = length(x);

nsamps = floor((alen-wlen)/stride);
Erms = zeros(1,nsamps);

for ii = 0:nsamps-1
	idx = ii*stride + 1;
	xsamp = x(idx:idx+wlen-1);
	
	Erms(ii+1) = rms(xsamp);
	
end
end % function
