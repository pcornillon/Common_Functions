function [ImageOutX ImageOutY] = Step_8x8( ImageIn)
%
% At each loaction get the step based on an 8x8 region
%
% INPUT
%
%  ImageIn - the image to which the Sobel operator is to be applied.
%
% OUTPUT
% 
%  ImageOutX - the gradient in the x direction.
%  ImageOutY - ...
%

SX = [1 1 1 1 1 1 1 1 1; ...
      1 1 1 1 1 1 1 1 1; ...
      0 0 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 0 0; ...
     -1 -1 -1 -1 -1 -1 -1 -1 -1; ...
     -1 -1 -1 -1 -1 -1 -1 -1 -1];

SY = [-1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1; ...
      -1 -1 0 0 0 0 0 1 1];

if ~strcmp(class(ImageIn),'uint16')
    ImageIn = single(ImageIn);
end

ImageOutX = conv2( ImageIn, SX) / 36;
ImageOutY = conv2( ImageIn, SY) / 36;

return