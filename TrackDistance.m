function Distance = TrackDistance( Lon, Lat)
% TrackDistance - determine the along track distance of a set of waypoints - PCC
% 
% INPUT
%   Lon - longitude of points.
%   Lat - latitude of points.
%
% OUTPUT
%   Distance - the along track distance.
%

DiffLon = diff(Lon);
DiffLat = diff(Lat);

Dist = sqrt((DiffLon * cosd(Lat(floor(end/2)))).^2 + DiffLat.^2) * 111;

Distance = sum(Dist);

end

