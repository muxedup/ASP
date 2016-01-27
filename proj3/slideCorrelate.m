function songDist = slideCorrelate(song,samp)
% XORSLIDECORRELATE Slide through and correlate sample against song
%	MAXSONGCORR = XORSLIDECORRELATE(SONG,SAMP)
%
% 

nwins = size(song,2);
splLen = size(samp,2);

ncorrs = nwins - splLen;

songDist = 0;

for ii=1:ncorrs
	%songCorr = dist2DCorrelate(song(:,ii:ii+splLen-1), samp);
    
    songCorr = nnz(song(:,ii:ii+splLen-1) & samp);
    
	if songCorr > songDist
		songDist = songCorr;
	end
end

end % function
