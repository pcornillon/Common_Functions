function [ NameOut ] = Add_Slash_At_End( NameIn )
% [ NameOut ] = Add_Slash_At_End( NameIn ) - adds a slash at the end of
% Namein and returns the variable.
%
%   Check to see if there is a slash at the end of the name passed in. If
%   there is, don't do anything. If not, add one.


NameOut = NameIn;

if NameIn(end) == '/'
    return
else
    NameOut(length(NameIn)+1) = '/';
end

end

