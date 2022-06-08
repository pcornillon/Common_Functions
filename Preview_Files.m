function Comments = Preview_Files(iFig, DirString, QualityThreshold)
% Preview_Files - 
%
% Get a list of files based on the wildcard specification.
%
% INPUT 
%   iFig - figure number in which to display the image.
%   DirString - a wildcard specification for the dir function.
%   QualityThreshold - quality flag values greater than this value will be
%    set to nan in a second plot IF this parameter is present.
% OUTPUT
%   Comments - any comments on the files in the list.
%
% Example:
% DirString = '~/Dropbox/Data/l2_modis_goddard/Original/2005/04/A20051*';
% Comments = Preview_Files(1, DirString);

Comments = '';

% Plotting parameters

AxisFontSize = 26;
TitleFontSize = 30;

% Get the list of files in this directory.

FilenameList = dir(DirString);

if isempty(FilenameList)
    disp(['No files matching ' DirString])
    return
end

% Loop over files


for iFile=1:length(FilenameList)
    
    % Build the filename
    
    FI = [FilenameList(iFile).folder '/' FilenameList(iFile).name];
    
    % Get the SST data

    SST = ncread(FI, '/geophysical_data/sst');
    
    % Plot the raw SST
    
    figure(iFig)
    if exist('QualityThreshold')
        subplot(2,1,2)
    end
    
    imagesc(SST)
    colorbar
    set(gca, 'fontsize', AxisFontSize)
    title( strrep(FilenameList(iFile).name, '_', '\_'), 'fontsize', TitleFontSize)
    
    % If QualityThreshold is present plot the SST after setting values
    % above QualityThreshold to nan.
    
    if exist('QualityThreshold')
        Qual = ncread(FI,'/geophysical_data/qual_sst');
        GoodSST = SST;
        GoodSST(Qual > QualityThreshold) = nan;
        
        subplot(2,1,1)
        imagesc(GoodSST)
        colorbar
        set(gca, 'fontsize', AxisFontSize)
%         title( [strrep(FilenameList(iFile).name, '_', '\_') 'for Quality > ' num2str(QualityThreshold)], ...
%                 'fontsize', TitleFontSize)
        title( ['Quality > ' num2str(QualityThreshold)], 'fontsize', TitleFontSize)
    end
    
    Answer = input('k - keyboard, q - quit, c - comment, <cr> - next: ', 's');
    switch Answer
        case ''
            
        case 'k'
            keyboard
            
        case 'q'
            return
            
        case 'c'
    end
end

