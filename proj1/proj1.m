%
%  proj1.m
%  proj1
%
%  Created by Munan Xu on 2015-10-13.
%  Copyright 2015 Munan Xu. All rights reserved.
%

%% Part 1 FFT and Windowing

filename = 'vowel.wav';

[y, fs] = audioread(filename);
[p, l] = findpeaks(y,'NPeaks',4,'minpeakheight',.6,'minpeakprominence',.6);
t = 0:1/fs:(length(y)-1)/fs;
dl = diff(t(l));
y_pitch = 1/mean(dl);
fprintf('Estimated pitch from waveform is %.2f\n',y_pitch)
win_len = fs*10e-3;

win = hamming(win_len,'periodic');
win_pad = padarray(win,512-length(win)/2);

y_pad = padarray(y,512-length(y)/2);

y_win = y_pad.*win_pad;

Y_f = fft(y_win);
L = length(Y_f);
P2 = abs(Y_f);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
P1 = 20*log10(P1);
f = fs*(0:(L/2))/L;
figure(1)
plot(f,P1)
[p, l] = findpeaks(P1,'minpeakdistance',15,'minpeakprominence',2);
fprintf('Base pitch is: %.2fHz for 10 ms window.\n',f(l(1)));
hold on
plot(f(l),p,'*')
win_len = fs*25e-3;

win = hamming(win_len,'periodic');
win_pad = padarray(win,512-length(win)/2);

y_pad = padarray(y,512-length(y)/2);

y_win = y_pad.*win_pad;

Y_f = fft(y_win);
L = length(Y_f);
P2 = abs(Y_f);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
P1 = 20*log10(P1);
f = fs*(0:(L/2))/L;
figure(2)
plot(f,P1)
[p, l] = findpeaks(P1,'minpeakprominence',2);
fprintf('Base pitch is: %.2fHz\n',f(l(1)));
hold on
plot(f(l),p,'*')
%% Part 2 Vowel Synthesis

pitch = 220;
vowelDict = {'ee', 'i', 'e', 'ae', 'ah', 'aw', 'U', 'oo', 'uh', 'er'};
makesubplots = 0;
for vowelNum = 1:10
    vowel = genVowel(pitch, .5, fs, vowelNum, 1, 0, 1, 0);
    if makesubplots
        figure(4)
        ht = subplot(2,5,vowelNum);
        figure(5)
        hf = subplot(2,5,vowelNum);
	
        plot(ht,0:1/fs:5/pitch-1/fs,vowel(:,1:floor(5/pitch*fs)))
        set(ht,'xlim',[0 5/pitch-1/fs])
        xlabel(ht,'Time (S)')
        ylabel(ht,'Amplitude')
        title(ht,char(vowelDict(vowelNum)))
        win_len = 10e-3*fs;
        win = zeros(1,length(vowel));
        win(1:win_len) = hamming(win_len,'periodic');
        for i = 1:size(vowel,1)
            win_vowel(i,:) = win.*vowel(i,:);
        end
        V = fft(win_vowel,[],2);
        N = length(V);
        V1 = V(:,1:round(N/2));
        Vdb = 20*log10(abs(V1));
        fseq = fs*(0:(N/2))/N;
        plot(hf,fseq,Vdb)
        set(hf,'ylim',[1.1*min(min(Vdb)) 1.1*max(max(Vdb))],'xlim',[0 fs/2])
        xlabel(hf,'Frequency (Hz)')
        ylabel(hf,'Magnitude (dB)')
        title(hf,char(vowelDict(vowelNum)))
    end
end