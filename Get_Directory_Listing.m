function [ DirectoryListing ] = Get_Directory_Listing( Directory )
% [DirectoryListing] = GetDirectoryListing( Directory );
%
% This function executes a dir command and then removes entries from the
% listing starting with '.'
%
% INPUT - directory name for which the listing is to be obtained.
%
% OUTPUT - the listing of files in the directory after removal of .
%   files.
%
%   Written by Peter Cornillon 9/22/13

DirectoryListing= [];


TT = dir(Directory);

NumberOfEntries = length(TT);

if ~isempty(NumberOfEntries)
    
    jEntry = 0;
    for iEntry=1:NumberOfEntries
        
        if TT(iEntry).name(1) ~= '.'
            jEntry = jEntry + 1;
            DirectoryListing(jEntry).name = TT(iEntry).name;
        end
    end
end

end

