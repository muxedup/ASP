function [aud_rcv, lpcstim_rcv] = vocoderSynth2(vocoderParams)
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
noffset = 0;
hwin = hamming(wlen);

hwin_pad = padarray(hwin,wlen/4);
windowing = 0;
for ii=0:nwin-1
	
	pitch = pitchinfo(ii+1);
	
	% Develp stimulus based on pitch
	if pitch > 0
		gwave = rosenberg(0.7,0.4,pitch,fs);
        gwavelen = length(gwave);
		pitchT = 1/pitch;
		if 1+noffset < wlen
			delta_idx = 1+noffset:round(pitchT*fs):wlen-0.4*gwavelen;
		else
			noffset = noffset - wlen; % since we're skipping by a window length skip to next
			continue; % if the offset from the next pitch is too big just skip to next window
		end
		
		if ii~= nwin-1 % if not at the end
			pitch2 = pitchinfo(ii+2);
            if pitch2 > 0
                pitch2T = 1/pitch2;
                pitch2S = round(pitch2T*fs);
                if delta_idx(end) + pitch2S + .4*floor(gwavelen) < wlen % check to see if you can sneak in an extra one
                	delta_idx = [delta_idx delta_idx(end) + pitch2S];
                end
			
                noffset = delta_idx(end) + pitch2S + round(0.4*gwavelen) - wlen;
            end
		end
		deltas = zeros(1,wlen);
        %disp(delta_idx);
		deltas(delta_idx) = 1; % fill in deltas where needed.
		
		lpcstim = conv(gwave,deltas);
    elseif pitch == 0 % use noise source
		lpcstim = randn(1,wlen);
        lpcstim = .4.*lpcstim./max(abs(lpcstim));
    else
        lpcstim = zeros(1,wlen);
	end
	
	audwin = filter(sqrt(gmat(ii+1)),lpcmat(ii+1,:),lpcstim);
    if pitchinfo(ii+1) > 0
        audwin = filter(1,[1 -.95],audwin);
    end
    
    if windowing == 1
        audwin = audwin(1:wlen);
        audwin = padarray(audwin',wlen/4);
        audwin = audwin.*hwin_pad;
        audwin = audwin(wlen/4:wlen/4+wlen-1);
    end
	%audwin = audwin./max(abs(audwin)); % normalize
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
		aud_rcv(ii:end) = aud_rcv(ii:end)+awin_rcv(ii+1,1:alen-ii*stride+1);
        %lpcstim_rcv(ii:end) = lpcstim_rcv(ii:end)+lpcstim_mat(floor(ii/stride)+1,1:alen-ii+1);
	end
end
aud_rcv = aud_rcv./max(abs(aud_rcv));
end % function
