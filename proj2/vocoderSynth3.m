function [aud_rcv, lpcstim_rcv] = vocoderSynth3(vocoderParams)
% VOCODERSYNTH2 Non-overlap case for a vocoder synthesizer
%	AUD_RCV = VOCODERSYNTH2(VOCODERPARAMS)
%
% poopballs

%% Load in variables
fs = vocoderParams.fs;
pitchinfo = vocoderParams.pitchinfo;
lpcmat = vocoderParams.lpcmat;
wlen = vocoderParams.wlen;
noverlap = vocoderParams.noverlap;
gmat = vocoderParams.gmat;
stride = wlen - noverlap;
nwin = length(pitchinfo);
alen = nwin*stride+noverlap;


awin_rcv = zeros(nwin,wlen);
lpcstim_mat = awin_rcv;

hwin = hanning(wlen);

hwin_pad = padarray(hwin,wlen/4);
windowing = 1;

[~, gtrain] = genAlignedGlottalSamps(wlen,noverlap,nwin,pitchinfo,fs);

for ii=0:nwin-1
	
	pitch = pitchinfo(ii+1);
	
	% Develp stimulus based on pitch
	if pitch > 0
        
		a = ii*stride+1;
		b = a + wlen;
		
		lpcstim = gtrain(a:b);
    elseif pitch == 0 % use noise source
		lpcstim = randn(1,wlen);
        lpcstim = .4.*lpcstim./max(abs(lpcstim));
    else
        lpcstim = zeros(1,wlen);
    end
    
	audwin = filter(sqrt(gmat(ii+1)),lpcmat(ii+1,:),lpcstim);
    
    if pitchinfo(ii+1) > 0
        audwin = filter([1 .95],1,audwin);
    end
    
    if windowing == 1
        audwin = audwin(1:wlen);
        audwin = padarray(audwin',wlen/4);
        audwin = audwin.*hwin_pad;
        audwin = audwin(wlen/4:wlen/4+wlen-1);
    end
    
	awin_rcv(ii+1,:) = audwin(1:wlen); % this is because the gpulse may run over. Filter with whole thing and then cut off instead of just cutting off
	lpcstim_mat(ii+1,:) = lpcstim(1:wlen);
end

aud_rcv = zeros(1,alen);
lpcstim_rcv = aud_rcv;
for ii=0:nwin-1
	if ii + wlen-1 < alen
        a = ii*stride+1;
        b = ii*stride+wlen;
		aud_rcv(a:b) = aud_rcv(a:b)+awin_rcv(ii+1,:);
        lpcstim_rcv(a:b) = lpcstim_rcv(a:b)+lpcstim_mat(ii+1,:);
    else
        a = ii*stride+1;
		aud_rcv(a:end) = aud_rcv(a:end)+awin_rcv(ii+1,1:alen-a);
        lpcstim_rcv(a:end) = lpcstim_rcv(a:end)+lpcstim_mat(ii+1,1:alen-a);
	end
end
aud_rcv = aud_rcv./max(abs(aud_rcv));
end % function
