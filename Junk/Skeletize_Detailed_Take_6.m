function [Array_In, iSsave, jSsave, Segments] = Skeletize_Detailed_Take_4( Array_In, Segments, MinBranchLength)

Debug = 0;

% % % load '~/Dropbox/ComputerPrograms/Satellite_Model_SST_Processing/AI-SST/Data/Debug_Abbreviated.mat'
% % % global AxisFontSize TitleFontSize Trailer_Info
% % % AxisFontSize = 20;
% % % TitleFontSize = 30;
% % % Trailer_Info = '_Original';
% % % global Thresholds
% % % Thresholds.segment_length = 3;

global Thresholds

% If Segments has been passed in get its length; we will increment it.

if exist('Segments')
    iSegment = length(Segments);
else
    iSegment = 0;
end

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
    
% % %     skel_no_spur = bwmorph(initial_skel, 'spur');
    skel_no_spur = initial_skel;
    Array_In = single(skel_no_spur);

% process as long as there are still some points in Array_In

First = 1;

nn = find(skel_no_spur==1);
while ~isempty(nn)
    
    % Get the pixel locations in the skeleton array.
    
    [iS, jS] = find(skel_no_spur == 1);
    
    if First == 1
        First = 0;
        iSsave = iS;
        jSsave = jS;
    end
    
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
    iB = [];
    jB = [];
    if ~isempty(find(skel_branch_point_array==1))
        [iB, jB] = find(skel_branch_point_array == 1);
    end
    
    % Finally get the end points of the skeleton. These are skeleton points
    % connected to only 1 other skeleton point. Note that there will be one
    % point at the end of each branch.
    
    skel_end_point_array = bwmorph( skel_no_spur, 'endpoints');
%     skel_end_point_array = BOHitOrMiss(skel_no_spur, 'end');
    [iE, jE] = find(skel_end_point_array == 1);
    Num_Ends = length(iE);
    
    if length(iE)<=1  % Only one masked pixel at this point; return.
        return
    end
    
    % % % % If no branch points, only one segment, save it and go to end of while.
    % % %
    % % % if length(iB) == 0
    % % %     Boundary = bwtraceboundary(skel_no_spur, [iE(1) jE(1)], 'W');
    % % %     Segments(iSeg).Pixels = Boundary(1:floor(length(Boundary/2)),:);
    % % %     return
    % % % end
    % % %
    % % % % Here if nore than one break point.
    
    iEB = [iE; iB];
    jEB = [jE; jB];
    Num_EB = length(iEB);
    
    if Debug >= 1
        Plot_Array_In
    end
    
    index_vector = 1:length(iEB);
    
    % Now start at one end point and get the boudaries, which for a line 1
    % pixel wide follows the line twice. Be careful on one side it will go down
    % one branch and on the other side it will go down the other branch when
    % the line splits.
    
    % Get all boundary points starting at this end point.
    
    Boundary = bwtraceboundary(skel_no_spur, [iE(1) jE(1)], 'W');
    
    % Loop over end points and branch points.
    
    clear Num_Found Loc_in_Mask_Temp Loc_on_Boundary_Temp End_Branch_Pt_Num_Temp
    
    iPtsOnBoundary = 0;
    for iBdPt=1:Num_EB
        
        % If this is a break point or an end point end this segment and start
        % another one otherwise save this pixel location to the current segment.
        
        Boundary_Points_Temp = find( (iEB(iBdPt) == Boundary(:,1)) & (jEB(iBdPt) == Boundary(:,2)));
        
        Num_Found(iBdPt) = length(Boundary_Points_Temp);
        
        for i=1:Num_Found(iBdPt)
            iPtsOnBoundary = iPtsOnBoundary + 1;
            Loc_in_Mask_Temp(iPtsOnBoundary,:) = [iEB(iBdPt) jEB(iBdPt)];
            Loc_on_Boundary_Temp(iPtsOnBoundary,:) = Boundary_Points_Temp(i);
            End_Branch_Pt_Num_Temp(iPtsOnBoundary,:) = iBdPt;
        end
    end
    
    % Reorder boundary points.
    
    [Loc_on_Boundary, iLocSorted] = sort(Loc_on_Boundary_Temp);
    Loc_in_Mask = Loc_in_Mask_Temp(iLocSorted,:);
    End_Branch_Pt_Num = End_Branch_Pt_Num_Temp(iLocSorted);
    
    if Debug
        disp(1:length(Num_Found))
        disp(Num_Found)
        Loc_on_Boundary'
        End_Branch_Pt_Num'
    end
    
    % Get segments
    
    iSegment = 0;
    
    for iEBPt=1:Num_EB
        pairs_processed(iEBPt).pairs = [0 0];
    end
    
    for iEBPt=2:length(Loc_on_Boundary)
        
        % Get the points between this end or branch point and the previous one.
        
        pts = Boundary(Loc_on_Boundary(iEBPt-1):Loc_on_Boundary(iEBPt),:);
        
        nPts = size(pts,1);
        
        if Debug
            plot(pts(:,1), pts(:,2), 'linewidth',5)
        end
        
        % Save this pair in processed pairs structure to make sure we don't do
        % it again.
        
        previous_pt = End_Branch_Pt_Num(iEBPt-1);
        this_pt     = End_Branch_Pt_Num(iEBPt);
        new_pair = [previous_pt this_pt];
        new_pair_reversed = [this_pt previous_pt];
        
        % Has this pair already been processed?
        
        pairs = pairs_processed(this_pt).pairs;
        
        found_one = 0;
        for iProcessed=1:size(pairs,1)
            if pairs(iProcessed,:) == new_pair_reversed
                found_one = 1;
                break
            end
        end
        
        % Skip this one if this pair has already been processed.
        
        if found_one == 0
% % %             disp(['Found this pair: ' num2str(new_pair)])
% % %         else
            
            pairs_processed(previous_pt).pairs = [pairs_processed(previous_pt).pairs; new_pair];
            
            % Only work on this segment if it is long enough.
            
            nPts = length(pts);
            if nPts < Thresholds.segment_length
                skel_no_spur(pts(:,1), pts(:,2)) = 0;
            else
                
                % Are there any end or branch points within one point of this line.
                
                new_iEB = iEB(index_vector~=this_pt & index_vector~=previous_pt);
                new_jEB = jEB(index_vector~=this_pt & index_vector~=previous_pt);
                
                clear found_one
                
                if nPts-2 <= Num_EB
                    
                    for ipts=2:nPts-1
                        nn = find( (abs(pts(ipts,1)-new_iEB) < 2) & (abs(pts(ipts,2)-new_jEB) < 2) );
                        if ~isempty(nn)
                            found_one = 1;
                            break
                        end
                    end
                else
                    
                    for ipts=1:length(new_iEB)
                        nn = find( (abs(new_iEB(ipts)-pts(:,1)) < 2) & (abs(new_jEB(ipts)-pts(:,2)) < 2) );
                        if ~isempty(nn)
                            found_one = 1;
                            break
                        end
                    end
                end
                
                % Continue to process if no end or branch points were found near
                % this segment.
                
                if exist('found_one') == 0
                    
                    % Save this segment.
                    
                    iSegment = iSegment + 1;
                    Segments(iSegment).Pixels = pts;
                    
                    % Zero out these points on the skeleton array.
                    
                    nn = sub2ind(size(skel_no_spur), pts(:,1), pts(:,2));
                    skel_no_spur(nn) = 0;
                    
                    if Debug == -1
                        Plot_Masks( 1, 3, 1, skel_no_spur); hold on
                        ANSWER = input([num2str(iSegment) ': Well? '],'s');
                        
                        switch ANSWER
                            case 'k'
                                keyboard
                                
                            case 'q'
                                return
                        end
                    end
                end
            end
        end
    end
end

end

