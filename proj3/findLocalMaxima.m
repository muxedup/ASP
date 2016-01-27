function fpeaks = findLocalMaxima(I, thresh, dy, dx)
% FINDLOCALMAXIMA Find local maxima with a minimum peak spacing requirement
%	FPEAKS = FINDLOCALMAXIMA(I, THRESH, DY, DX)
%
% 

dims = size(I);

nblocks = ceil(dims./[dx dy]);

for ii = 0:nblocks(1)-1
	for ij = 0:nblocks(2)-1
		currBlock = I( (ii*dx + 1):ii*dx + dx, (ij*dy + 1):ij*dy + dy);
		
	end
end

end % function
