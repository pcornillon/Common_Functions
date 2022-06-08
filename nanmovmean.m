function y = nanmovmean( x, num)
% nanmovmean - moving average of time series treating nans the way it treats end points - pcc
%
% The y(1) = sum_(i=1)^(ceil(num/2)) / ceil(num/2)
%     y(2) = sum_(i=1)^(ceil(1+num/2)) / ceil(1+num/2)
%     y(3) = sum_(i=1)^(ceil(2+num/2)) / ceil(2+num/2) until ceil(2+num/2) > num
%
% INPUT
%   x - time series on which to perform the moving average.
%   num - number of values to use in moving average.
%
% OUTPUT
%   y - moving average of x.

if mod(num,2) == 0
    disp(['You are averaging an even number of values. Results may be odd.'])
end

numov2 = floor(num / 2);

for i=1:length(x)
    if isnan(x(i)) == 1
        y(i) = nan;
    else
        xp = x(max(1,i-numov2):min(length(x),i+numov2));
        xpp = xp(isnan(xp)==0);
        y(i) = nanmean(xpp);
    end
end

