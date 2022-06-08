function compare_file_lists( constraint_expression_1, constraint_expression_2, num_char_to_exclude_1, num_char_to_exclude_2, show_missing_files)
% compare_file_lists - will compare the two file lists in the specified directories.
%
% INPUT
%   constraint_expression_1 - to use to generate list 1 - include full path.
%   constraint_expression_2 - to use to generate list 2 - include full path.
%
% OUTPUT
%   none
%
% EXAMPLE
%   compare_file_lists( '/Volumes/Aqua-1/MODIS_R2019/night/2003/AQUA*.nc', '/Volumes/Aqua-1/Fronts/MODIS_Aqua_L2/Final_Mask/2003/AQUA*.nc4')
%

% Get the list of original files and the list of final_mask files.

file_list_1 = dir(constraint_expression_1);
if isempty(file_list_1)
    disp(['No files in ' constraint_expression_1])
    return
end

file_list_2 = dir(constraint_expression_2);
if isempty(file_list_2)
    disp([num2str(length(file_list_1)) ' files on list in ' constraint_expression_1 '( out of ' num2str(length(file_list_1)) ' files) missing from ' constraint_expression_2])
    return
end

% Replace all .s with _s in both lists since Goddard uses periods in multiple places in the filename.

num_characters_1 = length(file_list_1(1).name) - num_char_to_exclude_1;
for iFile=1:length(file_list_1)
    list_1(iFile) = string(strrep( file_list_1(iFile).name(1:num_characters_1), '.', '_'));
end

num_characters_2 = length(file_list_2(1).name) - num_char_to_exclude_2;
for iFile=1:length(file_list_2)
    list_2(iFile) = string(strrep( file_list_2(iFile).name(1:num_characters_2), '.', '_'));
end

% First find file names on list 1 missing on list 2.

% disp(' ')
% disp('********** Looking for files on list 1 missing from list 2 **********')
% disp(' ')

num_missing = 0;

for iFile=1:length(file_list_1)
    
    nn = find(list_2 == list_1(iFile));
    
    if isempty(nn)
        num_missing = num_missing + 1;
        if show_missing_files
            disp([num2str(num_missing) ' - ' num2str(iFile) ' - ' file_list_1(iFile).name])
        end
    end
end
disp([num2str(num_missing) ' files on list in ' constraint_expression_1 '( out of ' num2str(length(file_list_1)) ' files) missing from ' constraint_expression_2])

% Now find file names on list 2 missing on list 1.

% disp(' ')
% disp('********** Looking for files on list 2 missing from list 1 **********')
% disp(' ')

num_missing = 0;
for iFile=1:length(file_list_2)
    
    nn = find(list_1 == list_2(iFile));
    
    if isempty(nn)
        num_missing = num_missing + 1;
        if show_missing_files
            disp([num2str(num_missing) ' - ' num2str(iFile) ' - ' file_list_2(iFile).name])
        end
    end
end
disp([num2str(num_missing) ' files on list in ' constraint_expression_2 '( out of ' num2str(length(file_list_2)) ' files) missing from ' constraint_expression_1])

