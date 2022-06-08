function [ Wavenumber, Temperature, FFT, PSD, Phase ] = GetSpectrum( SampleSpacing, ...
    Temperature, Preprocessing)
% GetSpectrum - get the power spectrum for the given temperature sections. PCC
%
% INPUT
%   SampleSpacing - the distance (in meters) between samples of the input
%    temperature section. From Wikipedia: 'The interval at which the DTFT is
%    sampled is the reciprocal of the duration of the input sequence.' In
%    our case the duration of the input sequence is (N - 1) * SampleSpacing
%    so the separation of wavenumbers in the power spectrum will  be
%    1/((N - 1) * SampleSpacing).
%   Temperaure - the temperature of the sample.
%   Preprocessing - flags for preprocessing [Normalize Detrend Blackman Demean Average Averaging_Interval]
%       Normalize - to normalize the spectra.
%       Detrend - 1 to remove trend from simulated temperature sections.
%       Windowing of temperature section - 0 for none
%           1 to apply a Blackman windw to temperature sections.
%           2 to apply a Blackman_Nuttall windw to temperature sections.
%           3 to apply a Plank_taper window to temperature sections.
%           4 to apply a Hanning window to temperature sections.
%       Demean - 1 remove the mean of the temperature section after applying
%        other requested operations.
%       Average - 1 to average elements of input temperature sections,
%        otherwise will subsample. If Averaging_Interval is 1, no averaging
%        or subsectioning will be done.
%       Averaging_Interval - number of input temperature values to average
%        or subsample. If 1, no averaging or subsectioning will be done.
%
% OUTPUT
%   Wavenumber - the wavenumber.
%   Temperature - the temperature section after preprocessing.
%   FFT - fft of input temperature section.
%   PSD - the power spectral density.
%   Phase - phase of PSD components
%
% OLD
%   Distance - the distance of the given sample from the first point.

% Get the number of points in the section.

N = length(Temperature);

% Temperature should be a 1xN vector. If an Nx1 vector, transpose.

if size(Temperature,1) > 1
    Temperature = Temperature';
end

% Make sure that N is even.

% if rem(N,2) == 1
%     disp(['The number of samples on the input temperature section is odd'])
%     keyboard
% end

% Generate the wavenumber vector for this section.

% Get the Blackman filter weights.

if rem(N,2) == 1
    M = (N + 1) / 2;
else
    M = N / 2;
end

switch Preprocessing(3)
    case 0
    case 1        
        w_Blackman = 0.42659 - 0.49656 * cos(2*pi*[0:M-1]/(N-1)) + 0.076849 * cos(4*pi*[0:M-1]/(N-1));
        W_Blackman = [w_Blackman fliplr(w_Blackman)];
        
    case 2
        w_Blackman_Nuttall = 0.365819 - 0.4891775 * cos(2*pi*[0:M-1]/(N-1)) + 0.1365995 * cos(4*pi*[0:M-1]/(N-1)) - 0.0106411 * cos(6*pi*[0:M-1]/(N-1));
        W_Blackman_Nuttall = [w_Blackman_Nuttall fliplr(w_Blackman_Nuttall)];
        
    case 3
        Epsilon = 0.2;
        ZPlus = 2 * Epsilon * (1 ./ (1 + (2 * [0:N-1] / (N - 1)) - 1) + 1 ./ (1 - 2 * Epsilon + (2 * [0:N-1] / (N - 1)) - 1));
        ZMinus = 2 * Epsilon * (1 ./ (1 - (2 * [0:N-1] / (N - 1)) - 1) + 1 ./ (1 - 2 * Epsilon - (2 * [0:N-1] / (N - 1)) - 1));
        
        N1 = floor( Epsilon * N);
        N2 = floor( (1 - Epsilon) * N);
        
        W_Plank_taper(1:N1) = 1 ./ (exp(ZPlus(1:N1)) + 1);
        W_Plank_taper(N1+1:N2) = 1;
        W_Plank_taper(N-N1+1:N) = fliplr(W_Plank_taper(1:N1));
        
    case 4
        Hanning = hann(N)';
        
    otherwise
        disp('Unknow windowing')
        keyboard
        
end

% Determine the normalization factor if to be normalized.

if Preprocessing(1) == 1
    NormFactor = sqrt(N / 2);
else
    NormFactor = 1;
end

% Detrend the input temperature series if to be detrended.

if Preprocessing(2) == 1
    x = [1:length(Temperature)];
    pp = polyfit( x, Temperature, 1);
    %     pp = polyfit([1 length(Temperature)], [Temperature(1) Temperature(end)], 1);
    
    Temperature = Temperature - (x * pp(1) + pp(2));
end

% Demean.

if Preprocessing(4) == 1
    Temperature = Temperature - mean(Temperature);
end

% Apply a Blackman filter to the input time series if requested.

switch Preprocessing(3)
    case 0
        
    case 1
        Temperature = Temperature .* W_Blackman;

    case 2
        Temperature = Temperature .* W_Blackman_Nuttall;
    
    case 3
        Temperature = Temperature .* W_Plank_taper;
    
    case 4
        Temperature = Temperature .* Hanning;
    
    otherwise
        disp(['Unacceptable windowing case: ' num2str(Preprocessing(3)) ...
            '. Must be an integer between 0 and 2.'])
        keyboard
end

% Get the spectrum

FFT = fft(Temperature) / NormFactor;

if rem(N,2) == 1
    L = (N-1)/2 + 1;
else
    L = N/2 + 1;
end

PSD = abs(FFT(1:L).^2);

Phase = angle(FFT);

% Get the wavenumbers for this FFT.

Fundamental = 1 / (N * SampleSpacing);
Wavenumber = [0:Fundamental:Fundamental*(L-1)];

end
