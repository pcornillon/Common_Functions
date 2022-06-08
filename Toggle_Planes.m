function Toggle_Planes(Plane1, Plane2)
% Toggle_Images - toggles from one image to another on user clicks - PCC
%
% INPUT
%   Plane1 - one image plane.
%   Plane2 - the other image plane.
%
% OUTPUT - none
%

Toggle = '';
Counter = 1;

while isempty(Toggle)
    Counter = Counter + 1;
    Toggle = input('<cr> or ''q'': ', 's');
    
    if mod(Counter,2) == 0
        Plane1.Visible = 'off'; Plane2.Visible = 'on';
    else
        Plane1.Visible = 'on'; Plane2.Visible = 'off';
    end
end

end

