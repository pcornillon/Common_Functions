function [x_Out, Values_Out] = Regrid_Nearest_Neigbor(Starting_Point, Point_Separation, ...
    Number_of_Points, x_In, Values_In)
% Regrid_Nearest_Neigbor - regrid data using nearest neighbor to a new line. PCC
%
% INPUT
%   Starting_Point - of new line.
%   Point_Separation - separation of points on the new line.
%   Number_of_Points - on the new line.
%   x_In - the x values of the points on the input line.
%   Values_In - the values of data at the X_Input points.
%
% OUTPUT
%   x_Out - the x values of the points on the output line.
%   Values_Out - the new values.

% Generate the x values of the output line and the get output values.

for iPt=1:Number_of_Points
    x_Out(iPt) = Starting_Point + (iPt-1) * Point_Separation;
    nn = find( min(abs(x_Out(iPt)-x_In)) == abs(x_Out(iPt)-x_In));
    Values_Out(iPt) = Values_In(iPt);
end

end

