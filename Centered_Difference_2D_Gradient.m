function Gradient = Centered_Difference_Gradient( VarIn, Lon, Lat, Mer_Zon, mkm)
% Centered_Difference_2D_Gradient - calculates gradient of VarIn of LatLon - PCC
%
% This function will shift VarIn, Lat and Lon down one grid elment and up one grid
% element in the requested Mer_Zon direction and then calculate the centered
% difference gradient. It will do this for two dimension fields rectangular
% in latitude and longitude at this point. Gradient is in variable units
% per meter.
%
% The assumption is that the zonal direction is the first dimension and the
% meridional direction is the second dimension.
%
% INPUT
%   VarIn - the variable for which we will obtain the gradient.
%   Lat - The lat array corresponding to the variable to be differentiated.
%   Lon - the lon array corresponding to the variable to be differentiated.
%   Mer_Zon - Merdional gradient if 'Mer' otherwise zonal gradient.
%   mkm - 'm' if degrees to meters and 'km' if degrees to km.
%
% OUTPUT
%   Gradient - the center-differenced gradient of VarIn

%   Error - 0 if no error,
%           1 if the number Mer_Zons of VarIn and LatLon do not match
%           2 if the number of elements in each Mer_Zon do not match
%           3 if more than 2 Mer_Zons in the input variables.

% Check that we agree on which dimension is zonal and which is meridional.

global iFig Sub_area dim_SF_dir dim_dir

if strcmp(lower(dim_dir(1)), 'meridional')
    disp(['Expecting that the first dimension is in the zonal direction ' ...
        'but it appears to be in the meridional direction.'])
    keyboard
end

% Set return variables to default values

Gradient = nan;
Error = 0;

% Determine the Mer_Zonality of the input arrays.

Dims = size(VarIn);
NumDims = size(Dims, 2);

% Make sure that there are at most 3 Mer_Zons.

if size(Dims, 2) ~= 2
    disp(['Can only handle 2d fields, you entered ' num2str(NumDims)])
    Error = 3;
    return
end

% Make sure that the Lat array is the same size as VarIn

rr = size(Lat);
if abs(rr - Dims) > 0
    disp(['Number of dimenstions of VarIn and Lat do not match'])
    Error = 1;
    return
else
    if sum(rr-Dims) > 0
        disp(['Number of elements in VarIn and Lat dimensions do not match'])
        Error = 2;
        return
    end
end

% Make sure that the Lon array is the same size as VarIn

rr = size(Lon);
if abs(rr - Dims) > 0
    disp(['Number of dimenstions of VarIn and Lon do not match'])
    Error = 1;
    return
else
    if sum(rr-Dims) > 0
        disp(['Number of elements in VarIn and Lon dimensions do not match'])
        Error = 2;
        return
    end
end

% First shift VarIn

switch mkm
    case 'km'
        deg2xx = 111;
        
    case 'm'
        deg2xx = 111000;
        
    otherwise
        disp(['mkm must be entered either as ''m'' or ''km''.'])
        keyboard
end

if strcmp('Zon', Mer_Zon) == 1
    % Zonal
    VarIn_minus_1 = [nan(1,Dims(2)); VarIn(1:end-2,:); nan(1,Dims(2))];
    VarIn_plus_1  = [nan(1,Dims(2)); VarIn(3:end,:);   nan(1,Dims(2))];
    
    LatLon_minus_1 = [nan(1,Dims(2)); Lon(1:end-2,:); nan(1,Dims(2))] .* cosd(Lat) * deg2xx;
    LatLon_plus_1  = [nan(1,Dims(2)); Lon(3:end,:);   nan(1,Dims(2))] .* cosd(Lat) * deg2xx;
else
    % Meridional
    VarIn_minus_1 = [nan(Dims(1),1), VarIn(:,1:end-2), nan(Dims(1),1)];
    VarIn_plus_1 =  [nan(Dims(1),1), VarIn(:,3:end),   nan(Dims(1),1)];
    
    LatLon_minus_1 = [nan(Dims(1),1), Lat(:,1:end-2), nan(Dims(1),1)] * deg2xx;
    LatLon_plus_1 =  [nan(Dims(1),1), Lat(:,3:end),   nan(Dims(1),1)] * deg2xx;
end

Gradient = (VarIn_plus_1 - VarIn_minus_1) ./ (LatLon_plus_1 - LatLon_minus_1);



