function [StructFun, StructDist, NumElements] = Fast_Structure_Function( ArrayIn, Dimension, ...
    Pixel_Spacing, MaxElements)
% Fast_Structure_Function calculate the structure function using matrix operations - PCC
%   
% This function will define a nan array equal in size to the input array.
% It will then loop over the number of distances for which the structure
% function will be determined simply loading the portion of the input array
% from the number of pixel for a given shift to the end of the array in
% that dimenion into the first elements of the new nan array in the
% direction of interest. Then difference the two and square. The number of
% elements contributing to the sum is the number of elements not equal to
% nan in the shifted array.
%
% INPUT
%   ArrayIn - array for which the structure function is to be calculated.
%   Dimension - Dimension over which to calculate the structure function.
%   Pixel_Spacing - spacing of pixels in the kilometers for the dimension
%    for which the structure function is to be calculated.
%   MaxElements - the maximum # of elements for which the structure function
%    is to be calculated.
%
% OUTPUT
%   StructFun - the structure function.
%   StructDist - the separation of points in the structure function.
%   NumElements - the number of elements contributing to the structure
%    function for each separaion.

for i=2:min(MaxElements,size(ArrayIn,Dimension))
    
    % Define a new nan array the same size as ArrayIn.
    
    csc = nan(size(ArrayIn));
    
    % Load elements of ArrayIn from i to the end of the desired dimension
    % into the nan array starting at the beginning of the given dimension.
    
    if Dimension == 1
        csc(1:end-i+1,:) = ArrayIn(i:end,:);
    else
        csc(:,1:end-i+1) = ArrayIn(:,i:end);
    end
    
    % Get the squared differences between to two arrays.
    
    Temp = (csc - ArrayIn).^2;
    
    % Sum the squared differences and determine how many values contributed
    % to this sum.
    
    StructFun(i-1) = single(sum(Temp,'all',"omitnan"));
    NumElements(i-1) = int32(length(find(isnan(Temp)==0)));
    
    %
    
    StructDist(i-1) = single((i - 1) * Pixel_Spacing);
end

end

