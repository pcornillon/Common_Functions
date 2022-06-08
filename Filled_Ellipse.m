function Array = Filled_Ellipse( x, y, x0, y0, a, b)
% Filled_Ellipse - generate an ellipse of 1s in an x, y grid PCC
%
% INPUT 
%   x - values of x coordinate
%   y - values of y coordinate
%   x0 - x-value for the center of elllipse
%   y0 - y-value for the center of elllipse
%   a - semimajor axis
%   b - semiminor axis
%
% OUTPUT
%   Array - an array of 1s inside the ellipse and 0s outside

Array = zeros( length(x), length(y));

for ix=1:length(x)
    for jy=1:length(y)
        Val = ((x(ix)-x0) / a)^2 + ((y(jy)-y0) / b)^2;
        
        if Val <= 1
            Array(ix,jy) = 1;
        end
    end
end


end

