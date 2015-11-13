%
%  vocodeSynth.m
%  proj2
%
%  Created by Munan Xu on 2015-11-09.
%  Copyright 2015 Munan Xu. All rights reserved.
%

%% Load Values
if exist('vocoderParams','var') == 0
	error('No vocoder parameters! Run gen_lpc_coeffs first!');
end

fs = vocoderParams.fs;
pitchinfo = vocoderParams.pitchinfo;
lpcmat = vocoderParams.lpcmat;
wlen = vocoderParams.wlen;
noverlap = vocoderParams.noverlap;
stride = wlen - noverlap;
hwin = hamming(wlen);
nwin = length(pitchinfo);
alen = nwin*stride+noverlap;
awin_rcv = zeros(nwins,wlen);

%% Assemble each window
for ii=0:nwin-1
	
	pitch = pitchinfo(ii+1);
	if pitch ~= 0
		t = 0:1/fs:(wlen-1)/fs;
		d = 0:1/pitch:(wlen-1)/fs;
		gwave = rosenberg(0.7,0.4,pitch,fs);
		gpulseTrain = pulstran(t,d,gwave,fs);
	
		audwin = filter(lpcmat(ii+1,:),1,gpulseTrain);
        audwin = audwin./max(audwin);
	else
		noise = randn(1,wlen);
		audwin = filter(lpcmat(ii+1,:),1,noise);
        %audwin = audwin./max(audwin);
	end
	awin_rcv(ii+1,:) = audwin(1:wlen);

end	

%% Recombine windows

aud_rcv = zeros(1,alen);

for ii=1:stride:alen-stride
    if ii + wlen-1 < alen
        aud_rcv(ii:ii+wlen-1) = aud_rcv(ii:ii+wlen-1)+awin_rcv(floor(ii/stride)+1,:);
    else
        aud_rcv(ii:end) = aud_rcv(ii:end)+awin_rcv(floor(ii/stride)+1,1:alen-ii+1);
    end
end
