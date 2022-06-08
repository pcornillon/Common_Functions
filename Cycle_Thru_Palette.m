function Cycle_Thru_Palette( iStart, iEnd )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PCC = colormap;

if isempty(iStart)
    iStart = 1;
    iEnd = length(PCC);
end

if isempty(iEnd)
    iEnd = length(PCC);
end

for i=iStart:iEnd
    i
    PCCTemp = PCC(i,:);
    PCC(i,:) = 1;
    colormap(PCC)
    input('<cr>')
    PCC(i,:) = PCCTemp;
end

end

