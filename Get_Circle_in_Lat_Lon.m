function [x,y] = Get_Circle_in_Lat_Lon( Lon_Center, Lat_Center, Radius)
% Get_Circle_in_Lat_Lon - just that - PCC
%  
% This function will plot a true circle in lat, lon; i.e., it will scale
% longitude based on latitude so that the radius is independent of the
% angle.
%
% INPUT 
%   Lon_Center - the longitude of the center of the circle.
%   Lat_Center - the latitude of the center of the circle
%   Radius - the radius of the circle in degrees latitude.
%
% OUTPUT
%   x - the longitude values on the circle.
%   y - the latitude values on the circle.


for iAngle=1:360
    x(iAngle) = Lon_Center + Radius / cosd(Lat_Center) * cosd(iAngle);
    y(iAngle) = Lat_Center + Radius * sind(iAngle);
end

end

