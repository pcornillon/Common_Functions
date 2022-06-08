function Inverted_Palette = Invert_Palette(Palette)
% Invert_Palette - switches high to low and vice-versa on the designated palette - PCC
%  
% INPUT
%   Palette - a string with a standard palette name.
%
% OUTPUT
%   Inverted_Palette - the inverted palette.

figure(1000)
xx = colormap(Palette);
for i=1:64
    Inverted_Palette(i,:) = xx(65-i,:);
end
close(1000)

end

