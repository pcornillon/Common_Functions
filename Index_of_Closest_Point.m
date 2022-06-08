function [ Indices ] = Index_of_Closest_Point( Vector, Points )
% Index_of_Closest_Point - find the point on a line closest to a given point - PCC
%
% INPUT
%   Vector - to search.
%   Points - values to search for.
%
% OUTPUT
%   Indices - of the closest points.
%

for iPoint=1:length(Points)
    TempIndex = find(min(abs(Vector-Points(iPoint))) == abs(Vector-Points(iPoint)));
    Indices(iPoint) = TempIndex(1);
end

end

