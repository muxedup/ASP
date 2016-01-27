function IDs = runIDTest(testMat, fingerPrintDB, varargin)
% RUNIDTEST Manage test execution
%	IDS = RUNIDTEST(TESTMAT, VARARGIN)
%
% Blah

optargs = {16e3, 3200,.5,512};
numvarargs = length(varargin);
if numvarargs > 1
	optargs(1:numvarargs) = varargin; % assign additional parameters if there are any
end

[fs, wlen, foverlap, fftnpts] = optargs{:}; % cleverly save new arguments into comprehensible variable names

ntests = size(testMat,1);
IDs = zeros(1,ntests);
for ii=1:ntests
	IDs(ii) = identify_song(testMat(ii,:),fingerPrintDB,fs,wlen,foverlap,fftnpts);
end

end % function
