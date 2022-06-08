function [Disk] = pcc_disk(Radius)
% pcc_disk - make a 2d array of 0s and 1s, the latter forming a circle in the array.

N = 2*Radius + 1;

M = zeros(N);
ii = ceil(N/2);
M(ii,ii) = 1;
Disk = bwdist(M) <= Radius;

end

