function eb_ticklength(hERROR, width)
%EB_TICKLENGTH Adjust the width of errorbars for both linear and log plots
%   EB_TICKLENGTH(hERROR) adjust the width of error bars with handle hERROR.
%      Default value of 0.01 fraction of x axis width
%   EB_TICKLENGTH(H,W) adjust the width of error bars with handle hERROR.
%      The width of the error bar W is given as a fraction of x axis length. 
%
% This function combines and adapts errorbar_tick and errorbarlogx, to allow 
% for error bar tick length of both linear and x log scale to be adjusted 
% using the same function. It will also homogonise the length of horizontal
% segments in the same way as errorbarlogx.
%
% Author: T. Millard
% DATE: Aug 23rd 2013 
%
%
% ERRORBARLOGX by F. Moisy
% DATE: Jan 20th 2006
% 
% ERRORBAR_TICK by Arnaud Laurent
% DATE : Jan 29th 2009
%
%   See also ERRORBAR

narginchk(1,3);

ca = get(gca); 
heb = hERROR.Children(2); 
ceb = get(heb); 

if nargin==1
    width = 0.01;
end

x = ceb.XData;

% Calculate width of error bars
if strcmpi(ca.XScale,'linear')
    dx = diff(ca.XLim);	
    width = dx*width;                  
    
    x(4:9:end) = x(1:9:end)-width/2;
    x(7:9:end) = x(1:9:end)-width/2;
    x(5:9:end) = x(1:9:end)+width/2;
    x(8:9:end) = x(1:9:end)+width/2;
    
elseif strcmpi(ca.XScale,'log')
    dx = 10^(log10(ceb.XData(length(ceb.XData)-8)/ceb.XData(1))*width);
    
    x(4:9:end) = x(1:9:end)/dx;	
    x(7:9:end) = x(1:9:end)/dx;
    x(5:9:end) = x(1:9:end)*dx;
    x(8:9:end) = x(1:9:end)*dx;
    
else
    error('XScale of current axes must be linear or log')
end

set(heb,'XData',x)	



