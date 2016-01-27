function songIdx = identify_song(x,fingerPrintDB,varargin)
% FINGERPRINTDBSEARCH Searches the database for a given sample
%	SONGIDX = FINGERPRINTDBSEARCH(X,FINGERPRINTDB)
%
% 

optargs = {16e3, 3200,.5,512};
numvarargs = length(varargin);
if numvarargs > 1
	optargs(1:numvarargs) = varargin; % assign additional parameters if there are any
end

[fs, wlen, foverlap, fftnpts] = optargs{:}; % cleverly save new arguments into comprehensible variable names

nrecs = length(fingerPrintDB);

sampleFingerPrint = fingerPrint2DSTFT(x,fs,wlen,foverlap,fftnpts);

maxCorrScore = 0;

for ii=1:nrecs
	songCorrScore = slideCorrelate(fingerPrintDB(ii).fp, sampleFingerPrint);
	if songCorrScore > maxCorrScore
		maxCorrScore = songCorrScore;
        songIdx = ii;
	end
end

end % function
