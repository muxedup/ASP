function [vowel] = genVowel(pitch, t, fs, vowelNum, nvowels, writefile, makeplots, playback)
	% t = time in seconds
    % nvowels = number of variants of each vowel
    
    vowelDict = {'ee', 'i', 'e', 'ae', 'ah', 'aw', 'U', 'oo', 'uh', 'er'};
	gwave = rosenberg(.6,.45,pitch,fs);
	pulseTrain = zeros(1,floor(fs*t));
	nreps = floor(length(pulseTrain)/fs * pitch);
	impulses = ones(1,nreps);
	pulseTrain(1:ceil(fs/pitch):end) = impulses;
	gwavetrain = conv(gwave,pulseTrain);
	formantFreqs = genFormantFreqs(vowelNum, nvowels)./fs;
	
    vowels = zeros(nvowels,length(gwavetrain));
    
	ck_conj = 0.9.*exp(-2.*1i.*pi.*formantFreqs);
	ck = 0.9.*exp(2.*1i.*pi.*formantFreqs);
	
    for freqidx = 1:nvowels
		ak = poly([ck(:,freqidx)' ck_conj(:,freqidx)']);
		
		vowel = filtfilt(1,ak,gwavetrain);
        vowel = vowel - mean(vowel); % Remove DC Component
		vowel = vowel./max(vowel);
		
		vowels(freqidx,:) = vowel;
		vowelDir = sprintf('vowel_%s',char(vowelDict(vowelNum)));
		vowelFname = sprintf('%s_f1-%.1f_f2-%.1f',char(vowelDict(vowelNum)),formantFreqs(1,freqidx)*fs,formantFreqs(2,freqidx)*fs);
		if writefile
			if exist(vowelDir,'dir') == 0
				mkdir(vowelDir);
			end
			audiowrite(strcat(vowelDir,'/',vowelFname,'.wav'),vowel,fs);
		end
		if playback
			soundsc(vowel,fs);
		end
		if makeplots
			%figure(4)
			%plot(0:1/fs:10/pitch-1/fs,vowel(1:floor(10/pitch*fs)))
			figure(5)
            hz = subplot(2,5,vowelNum);
			[H, ~] = freqz(1,ak,200,fs);
            plot(hz,0:fs/400:fs/2 -1,20*log10(abs(H)));
            xlabel(hz,'Frequency (Hz)')
            ylabel(hz,'Response (dB)')
            title(char(vowelDict(vowelNum)))
            set(hz,'xlim',[0 8000])
        end
    end
    vowel = vowels;
	
end