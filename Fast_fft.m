function [ PSD_Mean, Wavenumber, Num_Good_Ensemble_Members, Slope, Intercept ] = Fast_fft( ArrayIn, Detrend_Demean, Dimension, SampleSpacing, Wavelength_Range)
% Fast_Structure_Function calculate the structure function using matrix operations - PCC
%   
% This function will determine the fft along the specified dimension and
% then ensemble average the resulting spectra over the other dimension. The
% average will omit nans. Prior to performing the fft, the function will
% window the input data along each line to be ffted. If no window is
% specified, it will detrend the line and then demean it.
%
% The function will also calculate the slope over the specified wavenumber
% range.
%
% INPUT
%   ArrayIn - array for which the structure function is to be calculated.
%   Detrend_Demean - if 1 will detrend and then demean each row (or column)
%    to be ffted. Otherwise it will simply fft; i.e., windowing functions
%    will have to be applied to the array before being passed in.
%   Dimension - Dimension over which to calculate the fft.
%   SampleSpacing - spacing of samples in the kilometers for the dimension
%    for which the structure function is to be calculated.
%   Get_Phase - 1 if the phase of the fft is to be determined. It will
%    ensemble average the phase over ffts. This will result in a loop over
%    all members of the fft hence will be slower then skipping the phase.
%   Wavelength_Range - wavenlength range to use when calculating slopes.
%    Two element vector with lowest and highest values to use in km.
%
% OUTPUT
%   PSD_Mean - the mean power spectral density determined by averaging over 
%    rows (or columns), excluding ffts with nans.
%   Wavenumber - the wavenumber vector.
%   SampleSpacing - the distance (in meters) between samples of the input
%    temperature section. From Wikipedia: 'The interval at which the DTFT is
%    sampled is the reciprocal of the duration of the input sequence.' In
%    our case the duration of the input sequence is (N - 1) * SampleSpacing
%    so the separation of wavenumbers in the power spectrum will  be
%    1/((N - 1) * SampleSpacing).
%   Num_Good_Ensemble_Members - the number of rows (or columns) contributing 
%    to the ensemble average of the spectra.
%   Slope - of best fit straight line in loglog space.
%   Intercept - of best fit straight line in loglog space.
%

% Get the number of points on each line to fft and the dimension of the
% PSDs to be returned.

N = size(ArrayIn,Dimension);

if rem(N,2) == 1
    L = (N-1)/2 + 1;
else
    L = N/2 + 1;
end

% Initialize variables to be returned in case there are no values.

PSD_Mean = zeros(1,L);
% Phase = zeros(size(ArrayIn));
% Phase_Mean = zeros(1,L);

% If Detrend_Demean=1, detrend and remove the mean for each
% row/column to be FFTed. Note that the dimensions seem to be inverted
% here; i.e., were looping over the 2nd dimension when the fft is to be
% done on the 1st dimension and vice-versa. This is correct because we
% want to remove the trend and demean over the dimention which is to be
% ffted, the first dimension, so we have to demean each column --> loop
% over columns if the dimension to  be ffted are rows, the 1st
% dimension.

if Detrend_Demean
    if Dimension == 1
        for iCol=1:N
            y = ArrayIn(:,iCol)';
            x = 1:length(y);
            pp = polyfit( x, y, 1);
            Temp = y - polyval(pp, x);
            ArrayIn_Window_ed(:,iCol) = Temp - mean(Temp,'omitnan');
        end
    else
        for iRow=1:N
            y = ArrayIn(iRow,:);
            x = 1:length(y);
            pp = polyfit( x, y, 1);
            Temp = y - polyval(pp, x);
            ArrayIn_Window_ed(iRow,:) = Temp - mean(Temp,'omitnan');
        end
    end
else    
    ArrayIn_Window_ed = ArrayIn;
end

% Get the spectrum

FFT = fft(ArrayIn_Window_ed, [], Dimension);

% Now get the PSD and ensemble average. Not that if the fft was determined
% along dimension 1, the ensemble average should be performed along
% dimension 2 and vice versa.

if Dimension == 1
    PSD_Temp = abs(FFT(1:L,:).^2);
    PSD_Mean = single(mean(PSD_Temp,2,'omitnan'));
    Num_Good_Ensemble_Members = int32(length(find(isnan(PSD_Temp(10,:)) == 0)));
    
%     if Get_Phase
%         PhaseTemp = zeros(N,1);
%         for iCol=1:N
%             Phase(:,iCol) = angle(FFT(:,iCol));
%             Phase_Temp = Phase_Temp + angle(FFT(:,iCol));
%         end
%         Phase_Mean = Phase_Temp / N;
%     end
else
    PSD_Temp = abs(FFT(:,1:L).^2);
    PSD_Mean = single(mean(PSD_Temp,1,'omitnan'));
    Num_Good_Ensemble_Members = int32(length(find(isnan(PSD_Temp(:,10)) == 0)));

%     if Get_Phase
%         PhaseTemp = zeros(1,N);
%         for iRow=1:N
%             Phase(iRow,:) = angle(FFT(iRow,:));
%             Phase_Temp = Phase_Temp + angle(FFT(iRow,:));
%         end
%         Phase_Mean = Phase_Temp / N;
%     end
end

% Get the wavenumbers for this FFT.

Fundamental = 1 / (N * SampleSpacing);
Wavenumber = single([0:Fundamental:Fundamental*(L-1)]);

if size(Wavenumber,1) ~= size(PSD_Mean,1)
    Wavenumber = Wavenumber';
end

% Finally calculate the slope if a wavelength range has been specified.

if isempty(Wavelength_Range)
    Slope = nan;
    Intercept = nan;
    
else
    % Median filter the spectrum before calculating the slope. 
    
    if size(PSD_Mean,1) == 1
        PSD_Median = medfilt2(PSD_Mean, [1 3]);
    else
        PSD_Median = medfilt2(PSD_Mean, [3 1]);
    end
    
    % Now determine the best fit to the specified range.
    
    ww = find( Wavenumber>(1/Wavelength_Range(2)) & Wavenumber<(1/Wavelength_Range(1)));
    pp = polyfit( log10(Wavenumber(ww)), log10(PSD_Median(ww)),1);
    Slope = single(pp(1));
    Intercept = single(pp(2));
end

end

