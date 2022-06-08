function [min_val, max_val] = min_max_array( input_array, print_vals)
% min_max_array - obtains the min and max values of entire arrays excluding nan - PCC
%   
% INPUT 
%   input_array - the array from which to extract the min and max values.
%   print_vals - print the minimum and maximum values if this flag is set.
%
% OUTPUT
%   minval - the minimum value in the entire array excluing nans
%   maxval - the maximum value in the entire array excluing nans
%

min_val = min(input_array, [], 'All', 'omitnan');
max_val = max(input_array, [], 'All', 'omitnan');

if exist('print_vals')
    fprintf('Minimum and maximum values for this array are %f, %f \n', min_val, max_val)
end


