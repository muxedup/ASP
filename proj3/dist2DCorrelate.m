function corrScore = dist2DCorrelate(a,b)
% DIST2DCORRELATE Using logical matrices, compute distance of each point to its closest neighbor.
%	CORRSCORE = DIST2DCORRELATE(A,B)
%
% bleh

if ~islogical(a)
	a = logical(a);
elseif ~islogical(b)
	b = logical(b);
end

[bitsa_i, bitsa_j] = find(a);
[bitsb_i, bitsb_j] = find(b);

ldiff = length(bitsa_i) - length(bitsb_i);
if ldiff > 0
	bitsa_i = bitsa_i(1:end-ldiff);
    bitsa_j = bitsa_j(1:end-ldiff);
elseif ldiff < 0
    bitsb_i = bitsb_i(1:end+ldiff);
    bitsb_j = bitsb_j(1:end+ldiff);
end

dists = abs(bitsa_i - bitsb_i) + abs(bitsa_j - bitsb_j);

corrScore = sum(dists)/length(bitsa_i);
end % function
