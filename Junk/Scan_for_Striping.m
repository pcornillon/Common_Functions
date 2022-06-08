function Toggle_Planes(Plane1, Plane2)
% Toggle_Images - toggles from one image to another on user clicks - PCC
%
% INPUT
%   Fig1 - one image plage.
%   Fig2 - the other image plane.
%
% OUTPUT - none
%

Toggle = '';
Counter = 1;

figure(Fig1)
while isempty(Toggle)
    Counter = Counter + 1;
    Toggle = input('<cr> or ''q'': ', 's');
    
    if mod(Counter,2) == 0
        Plane1.Visible = 'off';Plane2.Visible = 'on';
    else
        Plane1.Visible = 'on';Plane2.Visible = 'off';
    end
end

end

