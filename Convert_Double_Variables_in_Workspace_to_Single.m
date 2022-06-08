% Convert_Double_Variables_in_Workspace_to_Single.
%
% Convert all double variables to single.

Vars = whos('*');

for i=1:length(Vars)
    
    % First is this variable double. If not skip
    
    Type = Vars(i).class;
    if strcmp(Type, 'double')
        
        % Convert it to single
        
        Name = Vars(i).name;
        
        eval(['Temp = single(' Name ');'])
        eval([Name ' = Temp;'])
    end
end

        
    