function Box( xur, yur, xll, yll, Color, LineWidth)
% Box - plots a box is 
% Plot a box on the current axes.
%
% x and y of the upper right hand corner
% x and y of the lower left hand corner
% Color - a string for line type and color; e.g., 'w-'
% LineWidth - the width of the line; 0.5 is the default.

hold on

plot([xur xur],[yur yll],Color,'LineWidth',LineWidth)
plot([xll xll],[yur yll],Color,'LineWidth',LineWidth)
plot([xur xll],[yur yur],Color,'LineWidth',LineWidth)
plot([xur xll],[yll yll],Color,'LineWidth',LineWidth)

return
