function Toggle_Mask( Fig1, Fig2, FI, Bit_Number, CAXIS, Cloud_Val)
% Toggle_Images - toggles from one image to another on user clicks - PCC
%
% INPUT
%   Fig1 - image plane with the sst in it.
%   Fig2 - image plane with the sst and mask in it.
%   FI - file name with MODIS data in it.
%   Bit_Number - bit number in Flags to use.
%   CAXIS - a 2-element vector for palette range.
%   Cloud_Val - if present, the value to assign to the pixels with a 1 in 
%    Bit_Number. Otherwise will use CAXIS(2)
%
% OUTPUT - none
%
% SAMPLE CALL
% FI = '~/Desktop/AQUA_MODIS.20100619T062008.L2.SST.nc';
% Toggle_Mask( 1, 2, FI, 16, [10 31])

% Read the sst and flags

FI = '~/Desktop/AQUA_MODIS.20100619T062008.L2.SST.nc';
SST = ncread( FI, '/geophysical_data/sst');
flags_sst = ncread( FI, '/geophysical_data/flags_sst');

% Build flag meanings cell array.

flag_meanings = {'ISMASKED' 'BTBAD' 'BTRANGE' 'BTDIFF' 'SSTRANGE' ...
    'SSTREFDIFF' 'SST4DIFF' 'SST4VDIFF' 'BTNONUNIF' 'BTVNONUNIF' ...
    'BT4REFDIFF' 'REDNONUNIF' 'HISENZ' 'VHISENZ' 'SSTREFVDIFF' ...
    'CLOUD'};

% Make the bit mask for this bit number.

SST_to_Plot = SST;

if Bit_Number <16
    nn = find(flags_sst == 2^(Bit_Number-1));
else
    nn = find(flags_sst == -32768);
end

SST_to_Plot(nn) = 0;

% Now plot the two fields.

if exist('Cloud_Val')
    SST_to_Plot(nn) = Cloud_Val;
else
    SST_to_Plot(nn) = CAXIS(2);
end

figure(Fig1)
% PCC = colormap(jet);
% PCC(255,:) = [1 1 1];
imagesc(SST')
colorbar
% colormap(PCC)
caxis(CAXIS)

figure(Fig2)
imagesc(SST_to_Plot')
colorbar
% colormap(PCC)
caxis(CAXIS)
title(['Bit ' num2str(Bit_Number) ': ' flag_meanings{Bit_Number}],'fontsize',20)

Toggle = '';
Counter = 1;

figure(Fig1)
while isempty(Toggle)
    Counter = Counter + 1;
    Toggle = input('<cr> or ''q'' or ''k'' for the keyboard: ', 's');
    
    if mod(Counter,2) == 0
        figure(Fig2)
    else
        figure(Fig1)
    end
end

if strcmp(Toggle,'k')
    keyboard
end

end

