function [Filename] = Get_Filename( BaseDir, Beginning_of_Filename)
% Get_Filename - get the most recent filename starting with Beginning_of_Filename - PCC
%
% This function will do a dir based on the directory structure passed in
% (BaseDir) and the beginning of the filename. It will then return the name
% of the most recent file on that list.
%
% INPUT
%   BaseDir - the directory with the files of interest.
%   Beginning_of_Filename - just that to search on.

Filename = '';

FileList = dir([BaseDir Beginning_of_Filename '*']);

Date = FileList(1).datenum;
Filename = [BaseDir FileList(1).name];

if length(FileList) > 1
    for iFile=2:length(FileList)
        if FileList(iFile).datenum > Date
            Date = FileList(iFile).datenum;
            Filename = [BaseDir FileList(iFile).name];
        end
    end
end

end

