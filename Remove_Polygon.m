function [MaskOut] = Remove_Polygon( FigSST, FigIn, FigOut, SST, MaskIn)
% Remove_Polygon - sets values of user defined polygon to 0 - PCC
%
% User to define polygon with ginput. The function will then create a mask
%  for this polygon and set all values in the input image to 0 within this
%  mask.
%
% INPUT 
%   FigSST - figure number for the SST image
%   FigIn - figure number for the input Mask image.
%   FigOut - figure number for the output image.
%   SST - input SST image
%   MaskIn - input mask.
% 
% OUTPUT
%   MaskOut - output mask.
%

figure(FigSST)
clf
imagesc(SST')
colorbar
caxis([10 31])

title('SST', 'fontsize', 30)

figure(FigIn)
clf
imagesc(MaskIn')
colorbar
title('Input Image', 'fontsize', 30)

% First zoom into the area of interest.

ANS = input('Zoom to area of interest and then <cr>');

Map_Axis_Range('a', FigIn, FigSST)
figure(FigIn)

% Ask the user to create the polygon

disp(['Define the polygon'])
disp('')

[x,y] = ginput;

% Connect the last point to the first point.

x(end+1) = x(1); 
y(end+1) = y(1);

% Plot the polygon

hold on
plot(x,y,'w')

% Create the mask

xx = poly2mask(x, y, size(SST,2), size(SST,1));

Mask = xx;
Mask(xx==1) = 0;
Mask(xx==0) = 1;

MaskOut = MaskIn .* Mask';

% Plot the output image

figure(FigOut)
clf
imagesc(MaskOut')
colorbar
title('Output Mask', 'fontsize', 30)
Map_Axis_Range('a',FigIn,FigOut)

end

