function fingerprint = fingerPrint2DSTFT(x, varargin)
% FINGERPRINT2DSTFT Generate a spectral fingerprint for a given input signal.
%	FINGERPRINT = FINGERPRINT2DSTFT(X, VARARGIN)
%
% Computes a windowed STFT for given input arguments and 
% uses FastPeakFind to generate local maxima which serves as a fingerprint.

optargs = {16e3, 3200,.5, 512};
numvarargs = length(varargin);
if numvarargs > 1
	optargs(1:numvarargs) = varargin; % assign additional parameters if there are any
end

[fs, wlen, foverlap, fftnpts] = optargs{:}; % cleverly save new arguments into comprehensible variable names

X = spectrogram(x, hamming(wlen),floor(wlen*foverlap),fftnpts,fs,'yaxis');

P = 20*log10(abs(X)); % compute the PSD the matlab one doesn't look too hot

[~, fingerprint] = FastPeakFind(P,0); % for now use the default parameters.

end % function
