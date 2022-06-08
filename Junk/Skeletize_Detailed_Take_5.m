function [skel_no_spur_s, Segments] = Skeletize_Detailed_Take_4( Array_In, Segments, MinBranchLength)

Debug = 2;

% % % load '~/Dropbox/ComputerPrograms/Satellite_Model_SST_Processing/AI-SST/Data/Debug_Abbreviated.mat'
% % % global AxisFontSize TitleFontSize Trailer_Info
% % % AxisFontSize = 20;
% % % TitleFontSize = 30;
% % % Trailer_Info = '_Original';
% % % global Thresholds
% % % Thresholds.segment_length = 3;

global Thresholds

Array_Out = [];

% If Segments has been passed in get its length; we will increment it.

if exist('Segments')
    iSegment = length(Segments);
else
    iSegment = 0;
end

% Set return parameters in case have to leave early, before they are
% defined elsehwere.

skel_no_spur = nan;
Longest_Segment = nan;
Length = 0;

if ~exist('MinBranchLength')
    MinBranchLength = 0;
end

% Get the skeleton array

initial_skel = bwskel(logical(Array_In),'MinBranchLength', MinBranchLength);

% Get rid of spurs. Each skeketon pixel after applying bwskel will have at most
% 3 other skeleton pixels touching it. A spur is a skeleton pixel touching
% 1 other skeleton pixel, which touches at least 2 other pixels. The 'o'
% skeleton pixel below is a spur.
%
%   x
%    x
%     xo
%    x
%     x
%     x

skel_no_spur = bwmorph(initial_skel, 'spur');
skel_no_spur_s = single(skel_no_spur);

% Get the pixel locations in the skeleton array.

[iS, jS] = find(skel_no_spur == 1);

if length(iS)<=1  % Only one masked pixel at this point; return.
    return
end

% Find branch points. A branch point is a skeleton pixel connected to 3
% other skeleton pixels, each of which is connected to 2 pixels. The 'o'
% skeleton pixel below is a branch point.  bwmorph returns an array of
% the same size as the input array with all pixel values set to 0 except
% for the branch points.
%
%   x   x
%    oxx
%    x
%    x
%     x
%     x

skel_branch_point_array = bwmorph( skel_no_spur, 'branchpoints');
[iB, jB] = find(skel_branch_point_array == 1);

% Finally get the end points of the skeleton. These are skeleton points
% connected to only 1 other skeleton point. Note that there will be one
% point at the end of each branch.

% skel_end_point_array = bwmorph( skel_no_spur, 'endpoints');
skel_end_point_array = BOHitOrMiss(skel_no_spur, 'end');
[iE, jE] = find(skel_end_point_array == 1);
Num_Ends = length(iE);

if length(iE)<=1  % Only one masked pixel at this point; return.
    return
end

% If no branch points, only one segment, save it and return.

if length(iB) == 0
    Boundary = bwtraceboundary(skel_no_spur, [Ie(1) Je(1)], 'W');
    Segments(iSeg).Pixels = Boundary(1:floor(length(Boundary/2)),:);
    return
end

% Here if nore than one break point.

iEB = [iE; iB];
jEB = [jE; jB];
Num_EB = length(iEB);

if Debug >= 1
    Plot_Array_In
end

% Now start at one end point and get the boudaries, which for a line 1
% pixel wide follows the line twice. Be careful on one side it will go down
% one branch and on the other side it will go down the other branch when
% the line splits.

% Loop over end points to get segments connected to them.

Save_End_Points = [];

iSeg = 1;
iSegBdPt = 0;

% Get all boundary points starting at this end point.

Boundary = bwtraceboundary(skel_no_spur, [iE(1) jE(1)], 'W');

% Loop over boundary values

iPtsOnBoundary = 0;
for iBdPt_EB=1:Num_EB
    
    % If this is a break point or an end point end this segment and start
    % another one otherwise save this pixel location to the current segment.
    
    Boundary_Points_Temp = find( (iEB(iBdPt_EB) == Boundary(:,1)) & (jEB(iBdPt_EB) == Boundary(:,2)));
    
    Num_Found(iBdPt_EB) = length(Boundary_Points_Temp);
    
    for i=1:Num_Found(iBdPt_EB)
        iPtsOnBoundary = iPtsOnBoundary + 1;
        Loc_in_Mask_Temp(iPtsOnBoundary,:) = [iEB(iBdPt_EB) jEB(iBdPt_EB)];
        Loc_on_Boundary_Temp(iPtsOnBoundary,:) = Boundary_Points_Temp(i);
        End_Branch_Pt_Num_Temp(iPtsOnBoundary,:) = iBdPt_EB;
    end
end

% Reorder boundary points.

[Loc_on_Boundary, iLocSorted] = sort(Loc_on_Boundary_Temp);
Loc_in_Mask = Loc_in_Mask_Temp(iLocSorted,:);
End_Branch_Pt_Num = End_Branch_Pt_Num_Temp(iLocSorted);

if Debug
    disp(Num_Found)
    Loc_on_Boundary'
    End_Branch_Pt_Num'
end

% Get segments

iSegment = 0;
% Only_One = find(Num_Found==1);
% for i=1:length(Only_One)
%     nn = find(End_Branch_Pt_Num==Only_One(i));

for iBdPt=1:Num_EB
    Node_Pair(iBdPt).Mates = 0;
end

% Start with the first end point.

x_start = iE(1);
y_start = jE(1);

num_skel_pts = length(iS);

nn = find(iS == x_start & jS == y_start);
iSp = iS([1:num_skel_pts]~=nn);
jSp = jS([1:num_skel_pts]~=nn);

num_skel_pts = num_skel_pts - 1;

for iPt=1:num_skel_pts
    
end

end

