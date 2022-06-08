function [h_text, h_arrow] = Annotate_Image( x, y, Text, Color, ArrowHeadSize, Direction)
% Annotate_Image - add text with an arrow to an image.
%
% INPUT
%   x - x [location of text, beginning of arrow, end of arrow]. If only one
%    element, then no arrow, only text.
%   y - y [location of text, beginning of arrow, end of arrow]. If only one
%   Text - to write.
%   Color - color of text and arrow.
%   ArrowHeadSize - the size of the arrowhead.
%   Direction - >0 if arrow is to start from right side other will start
%    arrow from left side of text.
%
% OUTPUT
%   h_text - handle for the text.
%   h_arrow - handle for the arrow.

global axis_font_size

h_text = text(x(1), y(1), Text);
h_text.FontSize = axis_font_size;
eval(['h_text.Color = ' Color ';'])
h_text.HorizontalAlignment = 'left';

if length(x) > 1
    h_text.HorizontalAlignment = 'right';
    if exist('Direction') == 1
        if Direction < 0
            h_text.HorizontalAlignment = 'left';
        end
        if Direction == 0
            h_text.HorizontalAlignment = 'center';
        end
    end
        h_arrow = quiver( x(2), y(2), x(3)-x(2), y(3)-y(2), 0);
        h_arrow.LineWidth = 1;
        eval(['h_arrow.Color = ' Color ';'])
        h_arrow.MaxHeadSize = ArrowHeadSize;
    else
        h_arrow = [];
    end

end