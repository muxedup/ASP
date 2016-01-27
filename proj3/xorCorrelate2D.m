function corrScore = xorCorrelate2D(a,b)
% XORCORRELATE2D Use xor function to do a correlation on binary data. 
% If data is not binary, we give it scalar value
%	CORRSCOR = XORCORRELATE2D(A,B)
%
% 

%bitsa = length(find(a));
%bitsb = length(find(b));

%bitsa = nnz(a);
%bitsb = nnz(b);
%if bitsa > bitsb
%    maxscore = bitsa;
%else
%    maxscore = bitsb; % if equal we don't care if we take bitsa or bitsb
%end

pro = a&b;
corrScore = nnz(pro);

end % function
