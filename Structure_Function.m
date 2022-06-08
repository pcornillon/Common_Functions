function [StructFun, StructDist, NumElements] = Structure_Function( VarIn, Dist, MaxDist, StepSize, ...
    StructFun, StructDist, NumElements)
% Structure_Function - calcuate the structure function for the given inputs - PCC
%
% The order of the structure function will be determined by the number of
% input parameters.
%
% INPUT
%   VarIn - cell array with each cell containing one of the variables used to
%    determine the structure function. If 2 elements, will do a 2nd or
%    function, if 3, a 3rd order. Must have at least 2.
%   Dist - the distance in kilometers from the origin of the coordinate 
%    system to each point of the input sections. 
%  MaxDist - the maximum separation for which the structure function is
%   calculated
%
% OUTPUT
%   StructFun - the structure function.
%   StructDist - the separation of elements
%   NumElements - the number of elements contributing to the structure
%    function for each separaion.

% Determine the order of the function to determine.

if exist('StructFun') == 0
    disp(['This function will increment the structure function for ',...
        'one line of data '])
    disp(['so it expects StructFun to be defined. If the first time ',...
        'it is being called ' ])
    disp(['for this image segment the vector should be set to zero, ', ...
        'otherwise it should '])
    disp(['it should contain the results of a previous call.'])
    keyboard
end

ElThreshold = 10;

% Do some checking on the input variables.
if iscell(VarIn) == 0
    disp(['The input variable is not a cell array.'])
    keyboard
end

nOrder = size(VarIn,2);

if nOrder <= 1
    disp(['You have only passed in ' num2str(nOrder) ' variable. Must past in at least 2.'])
    keyboard
end

% Make sure the dimensionality is right.

if size(Dist,1) == 1
    Dist = Dist';
end


for iOrder=1:nOrder
    
    % Now do the variables.
    
    Var_Temp = VarIn{iOrder};
    nElements(iOrder) = length(Var_Temp);
    
    % Makes sure that there are at least ElThreshold elements in vector 1
    % and that all other vectors are the same length as vector 1.
    
    if iOrder == 1
        if nElements(iOrder) < ElThreshold
            disp(['The first variable only has ' num2str(nElements(iOrder)) ' elements; must have at least ' num2str(ElThreshold)])
            keyboard
        end
    elseif nElements(iOrder) ~= nElements(1)
        disp(['The #' num2str(iOrder) ' variable is ' num2str(nElements(iOrder)) 'elements while the first variable is ' ...
            num2str(nElements(1)) ' elements. They should be the same length'])
        keyboard
    end
    
    % OK, things are all setup, let's do the calculation. First make sure the
    % dimensionality is right.
    
    if size(Var_Temp,1) == 1
        Var_Temp = Var_Temp';
    end
    
    % Finally load them into variables Var1, Var2, ...
    
    eval(['Var' num2str(iOrder) ' = Var_Temp;'])
end

% Took the real part of the next line. The function was failing on
% ocassion because it said that D was complex but that seemed to be
% because it was very, very close to zero but negative; i.e., it was zero
% at the level of machine noise.

D = real(pdist2_PCC( Dist, Dist, 'Euclidean')); % create distance matrix

% Get the interval into which the separations are to be quantized if not
% passed in.

if exist('StepSize') == 0
    
    IntervalFactor = 5;
    
    [hVal, hNum] = hist(D(:),[0:0.1:30]);
    hVal(1) = 0;
    hVal(end) = 0;
    nn = find(max(hVal) == hVal);
    minD = hNum(nn(1));
    
    nn = find(D == 0);
    D(nn) = nan;
    %
    % minD = nanmin(D(:));
    step = minD;
    factor = 1;
    while step < 1
        step = step * 10;
        factor = factor * 10;
    end
    StepSize = round(step) / (factor * IntervalFactor);
    
    D = minD + round((D - minD)/step) * StepSize;
    D(nn) = 0;
end

% Now get the structure function.

for ii=1:length(Var1)-1
    for jj=ii+1:length(Var2)
        
        Sep = abs(Dist(ii) - Dist(jj)) + StepSize/2;
        
        if Sep <= MaxDist & Sep > 0
            
            iSeparation = floor(Sep / StepSize);
            StructDist(iSeparation) = StepSize * iSeparation;
            
            % Make sure that none of the numbers for this part of the
            % calculation are nan; if so, skip to the next calculation.
            
            TempVarSum = Var1(ii) + Var1(jj) + Var2(ii) + Var2(jj);
            
            if nOrder == 3
                TempVarSum = TempVarSum + Var3(ii) + Var3(jj);
            end
            
            if isnan(TempVarSum) == 0
                if nOrder == 2
                    StructFun(iSeparation) = StructFun(iSeparation) + (Var1(jj) - Var1(ii)) .* (Var2(jj) - Var2(ii));
                elseif nOrder == 3
                    StructFun(iSeparation) = StructFun(iSeparation) + (Var1(jj) - Var1(ii)) .* (Var2(jj) - Var2(ii)) .* (Var3(jj) - Var3(ii));
                end
                
                NumElements(iSeparation) = NumElements(iSeparation) + 1;
            end
        end
    end
end

% % % StructDist(length(Var1)) = MaxDist;
