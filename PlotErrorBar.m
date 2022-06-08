function PlotErrorBar( X, Y, xSize, Error, COLOR, LineWidth, RGB)
% Plot an error bar at X, Y

for i=1:length(X)
    if exist('RGB')
        COLOR = num2str(COLOR);
        eval(['plot( [X(i) X(i)], [Y(i)-Error(i) Y(i)+Error(i)], ''Color'', [' COLOR '], ''linewidth'', LineWidth)'])
        hold on
        eval(['plot( [X(i)-xSize X(i)+xSize], [Y(i)-Error(i) Y(i)-Error(i)], ''Color'', ['  COLOR '], ''linewidth'', 1)'])
        eval(['plot( [X(i)-xSize X(i)+xSize], [Y(i)+Error(i) Y(i)+Error(i)], ''Color'', ['  COLOR '], ''linewidth'', 1)' ])
    else
        eval(['plot( [X(i) X(i)], [Y(i)-Error(i) Y(i)+Error(i)], '  COLOR ', ''linewidth'', LineWidth)'])
        hold on
        eval(['plot( [X(i)-xSize X(i)+xSize], [Y(i)-Error(i) Y(i)-Error(i)], '  COLOR ', ''linewidth'', 1)'])
        eval(['plot( [X(i)-xSize X(i)+xSize], [Y(i)+Error(i) Y(i)+Error(i)], '  COLOR ', ''linewidth'', 1)' ])
    end
end

end