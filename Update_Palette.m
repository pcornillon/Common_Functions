function CAXIS = Update_Palette( FigNo, SST)
% Update_Palette - histogram data and pick a palette to best show data - PCC
%
% Histogram the input SST data between -3 and 33 C in steps of 0.125 C,
% find the bin with the maximum number of pixels in it, find the first and
% last bin with more than 1/10th of this maximum and set the color range to
% these values.
%
% INPUT
%   FigNo - the figure number with the SST field in it.
%   SST - the masked (for high quality pixels) SST field.
%
% OUTPUT
%   CAXIS - the vector with the minimum and maximum SST values to use in
%    the palette.

% Initialize thresholds and other variables.

Total_Number_Threshold = 100;

% histogram SST values between -3 and 33 C

figure(100)
% set(fig,'visible','off')
hh = histogram( SST, [-3:0.125:33]);
Values = hh.Values;

if sum(Values) < Total_Number_Threshold
%     disp(['Not enough good pixels in this image.'])
    CAXIS = [-2 32];
    return
end
    
MaxVal = max(hh.Values);
bb = find( hh.Values > MaxVal/10);

CAXIS(1) = hh.BinEdges(bb(1));
CAXIS(2) = hh.BinEdges(bb(end)+1);

figure(FigNo)

caxis(CAXIS)

end

