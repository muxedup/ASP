function [deltas, gtrain] = genAlignedGlottalSamps(wlen,noverlap,nwins,pitchinfo,fs)
% GENALIGNEDDELTAS Generate pitch aligned delta functions for glottal reconstruction
%	DELTAS = GENALIGNEDDELTAS(WLEN,NOFFSET,NWINS,PITCHINFO)
%
% buttmunch

stride = wlen - noverlap;

alen = nwins*stride + noverlap;
deltas = zeros(1,alen);
gtrain = deltas;

previdx = 0;
for ii=0:nwins-1
	pitch = pitchinfo(ii+1);
	windowpos = ii*stride+1;
	
	if pitch > 0
		gwave = rosenberg(.7,.4,pitch,fs);
        
		pitchS = round(fs/pitch); % pitch spacing in samples
		
		if (windowpos - previdx) > pitchS || previdx == 0 % we have already moved one pitch period || start case
			curridx = windowpos;
        else
            curridx = previdx;
        end
		
		for ij=curridx:pitchS:curridx+stride-1
			deltas(ij) = 1;
            gtrain(ij:ij+length(gwave)-1) = gwave;
		end
		previdx = ij + pitchS;
		
	end
end


end % function
