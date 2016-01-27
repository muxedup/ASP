function fingerPrintDB = compute_fingerprints(musicDB,varargin)
% MAKEFINGERPRINTDB Take musicDB and make a fingerprint database
%	FINGERPRINTDB = MAKEFINGERPRINTDB(MUSICDB, VARARGIN)
%
% poop

optargs = {16e3, 3200,.5,512};
numvarargs = length(varargin);

if numvarargs > 1
	optargs(1:numvarargs) = varargin; % assign additional parameters if there are any
end

[fs, wlen, foverlap, fftnpts] = optargs{:}; % cleverly save new arguments into comprehensible variable names

nrecs = length(musicDB);

if nrecs < 1
	error('musicDB does not have any records!');
end
if ~isfield(musicDB,'signal')
	error('musicDB does not have a signal field!');
end

fingerPrintDB = cell(1,150); % pre-allocate

for ii=1:nrecs
	fingerPrintDB(ii) = {logical(fingerPrint2DSTFT(musicDB(ii).signal, fs, wlen, foverlap, fftnpts))};
end

fingerPrintDB = struct('fp',fingerPrintDB);

end % function
