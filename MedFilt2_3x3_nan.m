function [ Array_Out ] = MedFilt2_3x3_nan( Array_In, rDisk, Counts_Threshold )
% MedFilt_nan - 3x3 median filter array with nan.
%
% Replaces central value with median if more than Counts_Threshold good values, otherwise nan.

% Erode the input array if rDisk > 0. Start by defining the struture element to use.

if rDisk > 0
    Disk = strel('disk', rDisk, 0);
    MaskT = zeros(size(Array_In));
    MaskT(isnan(Array_In)==0) = 1;
    Mask = imerode( MaskT, Disk);
    Array_In = Array_In .* Mask;
end

% Get the dimensions of the input image.

[iSize jSize] = size(Array_In);


% zz{1,1} = [Array_In(2:iSize,2:jSize), nan(iSize-1,1); nan(1,jSize)];
% zz{1,2} = [Array_In(1:iSize,2:jSize), nan(iSize,1)];
% zz{1,3} = [nan(1,jSize); Array_In(1:iSize-1,2:jSize), nan(iSize-1,1)];
% 
% zz{2,1} = [Array_In(2:iSize,1:jSize); nan(1,jSize)];
% zz{2,2} = Array_In;
% zz{2,3} = [nan(1,jSize); Array_In(1:iSize-1,1:jSize)];
% 
% zz{3,1} = [nan(iSize-1,1), Array_In(2:iSize,1:jSize-1); nan(1,jSize)];
% zz{3,2} = [nan(iSize-1,1), Array_In(2:iSize,1:jSize)];
% zz{3,3} = [nan(1,jSize); nan(iSize-1,1), Array_In(2:iSize,1:jSize-1)];

zz = zeros(9,size(Array_In,1), size(Array_In,2));

zz(1,:,:) = [Array_In(2:iSize,2:jSize), nan(iSize-1,1); nan(1,jSize)];
zz(2,:,:) = [Array_In(1:iSize,2:jSize), nan(iSize,1)];
zz(3,:,:) = [nan(1,jSize); Array_In(1:iSize-1,2:jSize), nan(iSize-1,1)];

zz(4,:,:) = [Array_In(2:iSize,1:jSize); nan(1,jSize)];
zz(5,:,:) = Array_In;
zz(6,:,:) = [nan(1,jSize); Array_In(1:iSize-1,1:jSize)];

zz(7,:,:) = [nan(iSize-1,1), Array_In(2:iSize,1:jSize-1); nan(1,jSize)];
zz(8,:,:) = [nan(iSize,1), Array_In(1:iSize,1:jSize-1)];
zz(9,:,:) = [nan(1,jSize); nan(iSize-1,1), Array_In(1:iSize-1,1:jSize-1)];

Array_Out = median(zz, 1, 'omitnan');
%zzMednan = median(zz, 1);

Counts = 9 - sum(isnan(zz),1);

Array_Out(Counts < Counts_Threshold) = nan;

end

