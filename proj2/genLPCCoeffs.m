function vocoderParams = genLPCCoeffs(varargin)
%% Load in data

[audiosamp, fs] = audioread('female_speech.wav');
alen = length(audiosamp);
load('pitches.mat');

if exist('pitch') == 0
	error('Pitch information not properly loaded!');
end

%% Set windowing and overlap parameters

wlen = 20e-3 * fs;
hwin = hamming(wlen);

hwin_pad = padarray(hwin,wlen/4);

noverlap = 160; %overlap in pts
stride = wlen - noverlap;
nwins = floor(alen/stride)+1;
audiosamp = padarray(audiosamp,wlen,'post');

%% LPC settings

ncoeff = 15;

lpcmat = zeros(nwins,ncoeff+1);
gmat = zeros(1,nwins);

makepitches = 1;
%% Do LPC

pitch_samp_idx = 1:ceil(alen/length(pitch)):alen;

if makepitches == 1
    pitchinfo = makePitchInfo(audiosamp(1:alen),fs,wlen,noverlap);
else
    pitchinfo = interp1(pitch_samp_idx,pitch, 1:stride:nwins*stride);
end

for ii=0:nwins-1
	startsamp = ii*stride + 1;
    
	currsamp = audiosamp(startsamp:startsamp + wlen-1);
	currsamp = padarray(currsamp,wlen/4);
	currsamp = currsamp.*hwin_pad;
	
	if pitchinfo(ii+1) > 0 % pitch information exists
		samp = filter([1 -.95], 1, currsamp);
	else
		samp = currsamp;
	end
	
	[lpcmat(ii+1,:), gmat(ii+1)] = lpc(samp, ncoeff);
end

vocoderParams = struct('lpcmat',lpcmat,'gmat',gmat, 'pitchinfo', pitchinfo,'fs',fs,'wlen',wlen,'noverlap',noverlap);
end
