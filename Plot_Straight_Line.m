function [StraightLineWavenumber, StraightLinePSD, pp, Plot_Handles, iPlotHandle] = ...
    Plot_Straight_Line( FigNo, Wavenumber, PSD, Wavenumber_Range, Line_Width, Line_Color, ...
    Plot_Handles, iPlotHandle, Text_Loc, Keep_1st_Element)
% Plot_Straight_Line - fit a straight line to a spectrum and plot it - PCC
%
% INPUT
%   FigNo - the figure number to use for the plot.
%   Wavenumber - the wavenumber vector.
%   PSD - the power spectral density.
%   Wavenumber_Range - a two element vector defining the range over which
%    to fit the straightline. The first element is the lower wavenumber.
%   Line_Width - to use when plotting the straight line fit.
%   Line_Color - a three element color vector.
%   Plot_Handles - vector of plot handles.
%   iPlotHandle - first empty plot handle.
%   Text_Loc - a 2-element vector with the x,y location at which to write the slope. If < 0 do not write slope.
%   Keep_1st_Element- if present and equal to 1 will keep the first element
%    of the wavenumber vector.
%
% OUTPUT
%   StraightLineWavenumber - wavenumber corresponding to fit spectrum.
%   StraightLinePSD - the straight line fit.
%   pp - 2 element vector with slope and intercept of best fit straight line in log-log space.
%   Plot_Handles - vector of handles for the plot
%   iPlotHandle - next empty plot handle.
%

Define_Globals

% TickSizeFactor is the fraction of the PSD at the wavenumber of interest
% to use for the ticksize.

TickSizeFactor = 1;

% Get the wavenumbers to use in the fit.

nn = find(Wavenumber > Wavenumber_Range(1) & Wavenumber < Wavenumber_Range(2));
StraightLineWavenumber = Wavenumber(nn);

% Fit a straight line

pp = polyfit( log10(StraightLineWavenumber), log10(PSD(nn)), 1);

% Get the straight line. Skip the first element, it may be 0.

if exist('Keep_1st_Element')
    StraightLineWavenumber = Wavenumber;
else
    StraightLineWavenumber = Wavenumber(2:end);
end
StraightLinePSD = 10.^(pp(1) * log10(StraightLineWavenumber) + pp(2));

StraightLinePSDAtEnds(1) = 10^(pp(1) * log10(Wavenumber_Range(1)) + pp(2));
StraightLinePSDAtEnds(2) = 10^(pp(1) * log10(Wavenumber_Range(2)) + pp(2));

% Plot the straight line.

figure(FigNo)
Plot_Handles(iPlotHandle) = loglog( StraightLineWavenumber, StraightLinePSD, 'linewidth', Line_Width, 'color', Line_Color);
hold on

% And plot tick marks showing fit range.

for i=1:2
    Plot_Handles(iPlotHandle+i) = loglog( [Wavenumber_Range(i) Wavenumber_Range(i)],  [StraightLinePSDAtEnds(i)*(1-0.1*TickSizeFactor) StraightLinePSDAtEnds(i)*(1+0.1*TickSizeFactor)], 'linewidth', Line_Width, 'color', Line_Color);
end

if Text_Loc(1) > 0
    text( Text_Loc(1), Text_Loc(2), ['Slope: ' num2str(pp(1),3)], 'fontsize', AxisFontSize, 'color', Line_Color)
end

iPlotHandle = iPlotHandle + 3;

return
