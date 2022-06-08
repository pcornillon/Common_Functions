function FilteredFieldOut = nanMedFilt2( FieldIn, ValueToExclude, MedFiltSize)
% nanMedFilt2 - 2-d median filter a field excluding a given value - PCC
%
% This function will replace all values in the input field equal to 
% ValueToExclude with either -infinity or infinity, the sign being chosen 
% at random. It will then perform a 2-d median filter of the input field.
% The idea is that the infinite values will be relatively random so as
% many, on average will be +infinity as -infinity so it is the remainder
% that will determine the median. If more than half of the values are
% either +infinity or -infinity, it will return +/- infinity for that
% pixel. These are then replaced with nan in the resulting field. This
% means that an area with all nans will return nan, assuming that the
% filter size is odd.
%
% INPUT
%   FieldIn - 2d field to be median filtered
%   ValueToExclude - pixels with this value will be replaced with +/-
%    infinity, the sign being selected at random.
%   MedFiltSize - a 2-element vector with the i and j filter size to use.
%
% OUTPUT
%   FilteredFieldOut - output field.
%
% EXAMPLE
%   To apply a 5x5 median filter to the field called SST excluding nans:
%       STOut5x5 = nanMedFilt2( SST, nan, [5 5]);
%

% Get location of pixesl to be replaced

if isnan(ValueToExclude)
    nn = find(isnan(FieldIn) == 1);
else
    nn = find(FieldIn == ValueToExclude);
end

% Replace these values with +infinity or -infinity, the sign being chosen at random.

FieldIn(nn) = (rand(length(nn),1) - 0.5) * inf;

% Median filter the modified input field.

FilteredFieldOut = medfilt2(FieldIn, MedFiltSize);

% Replace pixels with +/- infinity with nan

FilteredFieldOut((FilteredFieldOut) > 10^8) = nan;
