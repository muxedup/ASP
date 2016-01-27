%% ------ Load and Set Sample Variables -----------------------------------
if ~exist('musicDB','var')
	load 'musicDB.mat'
end

fs = 16e3;
wlen = 0.2*fs;
foverlap = 0.5;
fftnpts = 512;

snr = 20;
noised = 0;

%% ------ Generate fingerprint database -----------------------------------

fingerPrintDB = compute_fingerprints(musicDB,fs,wlen,foverlap,fftnpts);

%% ------ Set up test vectors ---------------------------------------------
spl = 3; % sound sample time is 3 seconds
ntests = 100;
tVecLen = spl*fs;

nrecs = length(musicDB);
nsamps = length(musicDB(1).signal);

testSongIDX = randi(nrecs,1,ntests); % generate random sequence of songs
songStartT = randi(nsamps - tVecLen,1,ntests); % generate random start pts

testMat = zeros(ntests,tVecLen);

for ii = 1:ntests
    testSamp = musicDB(testSongIDX(ii)).signal(songStartT(ii):songStartT(ii)+tVecLen-1);
    if noised
        testMat(ii,:) = awgn(testSamp,snr);
    else
        testMat(ii,:) = testSamp;
    end
end

%testMat = struct('signal',testMat);
%testMatFingerPrintDB = makeFingerPrintDB(testMat, fs, wlen, foverlap, nfftpts);
%% ------ Run Music ID Function -------------------------------------------

IDs = runIDTest(testMat,fingerPrintDB,fs, wlen, foverlap, fftnpts);

numRight = nnz(IDs==testSongIDX);
fprintf('%.2f%% right\n',numRight/ntests*100);

%% Parameter sweep test

res = zeros(3,2,4);
twin = [0.1 0.15 0.2];
fmat = [0 0.5];
fftmat = [2048 1024 512 256];
for ii = 1:3
    for ij = 1:2
        for ik = 1:4
            fftnpts = fftmat(ik);
            wlen = twin(ii)*fs;
            foverlap = fmat(ij);
            
            fingerPrintDB = compute_fingerprints(musicDB,fs,wlen,foverlap,fftnpts);
            
            IDs = runIDTest(testMat,fingerPrintDB,fs, wlen, foverlap, fftnpts);

            numRight = nnz(IDs==testSongIDX);
            res(ii,ij,ik) = numRight/ntests * 100;
           
        end
    end
end
