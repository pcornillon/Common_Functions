function cmjb
% cmjb assigns the jet palette to colormap and adds a colorbar - PCC
%
% This function will also invert the axes and set the fonsize

global FontSizeTitle FontSizeAxis

colormap(jet)
colorbar

set( gca, 'ydir', 'normal')
if isempty(FontSizeAxis) == 0
    set( gca, 'fontsize', FontSizeAxis)
end

end

