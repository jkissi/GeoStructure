%% segmentation__macro_region.m (Plane Fit functions)
function [ planes ] = segmentation__region_growing(planes)
% Function to implement region growing algorithm to classify all points in
% the cloud to group them into larger regions (A_matrix) for measurement
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Implementation of Region Growing and point cloud segmentation algorithm
% from T. Rabbani(2006) - Segmentation of Point Clouds Using Smoothness
% Constraint
% Implements region growing part of algorithm in the most direct way, with
% less focus on the smoothness constrait or residual threshold, as these
% aspects are not required for this algorithm
% Returns 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% index :: index of the set of A_matrix to be sampled 
% matrix :: matrix of the coords of the A_matrix 
% ?

final_regions = []; % Stores the ID numbers of all the final regions
seed_array = struct(); % Stores coordinates for points with normals larger than the threshold for the
region_array = [];
final_array = struct();
region_idx = []; % added to the point structs so that each point is in a region
current_point =  []; % just take the first point for now
angle_comparison_array = [];
coord_matrix = [];
ind_closest_array = [];
array = [];
normal_threshold = 5;%10
A_matrix = planes;
han__seg_plane_draw = [];
idx__seg_plane_draw = 1;
% K Nearest Neigh
k = 30;
% TODO usually the last entry in the array comes in without a point vector
% or a bormal vector. Not sure why, must but for now, just get rid of the
% entry
idx__A_matrix_empty_elems = arrayfun(@(s) any(structfun(@isempty, s)), A_matrix);
A_matrix = A_matrix(~idx__A_matrix_empty_elems);

[A_matrix.han__seg_plane_draw] = deal([]);
[A_matrix.idx__seg_plane_draw] = deal([]);

%--------------------------------------------------------------------------
% While {A} is not empty, do...
%--------------------------------------------------------------------------

% keep loop going until A_matrix is empty
while(~isempty(A_matrix))
    
    % catch empty structs in the array. If the plane_draw field is empty,
    % then none of the other fields will be complete either
    idx__A_matrix_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_matrix);
    A_matrix = A_matrix(~idx__A_matrix_empty_elems);
    
    % catch the first instance, before the seed array has been filled
    if(isempty(fieldnames(seed_array)) || isempty(seed_array))
        
%--------------------------------------------------------------------------
% Point with minimum residual in {A} -> P_min (changed to random select) [1]
%--------------------------------------------------------------------------       
        % generate seed point for the beginning of the algo. Random should 
        % be fine
        a = 1;
        b = length(A_matrix);
        r = (b - a).*rand(1) + a;
        r = round(r);
        seed_index = r;
        
        disp(['seed index is:  ', num2str(seed_index),'.']);
        disp(['A_matrix is:  ', num2str(numel(A_matrix)),'.']);
        if((seed_index == 0) || (numel(A_matrix) == 0))
            break;
        else            
%--------------------------------------------------------------------------
% P_min insert-> {S_c}&{R_c} [1]
%--------------------------------------------------------------------------            
            seed_array = A_matrix(seed_index);
        end
%--------------------------------------------------------------------------        
% P_min insert-> {S_c}&{R_c} [1]
%--------------------------------------------------------------------------        
        % initialise the region selection
        if(isempty(region_idx))
            region_idx = 1;
            % choose a random color
            region_colour = rand(1,3);
            seed_array(1).region_idx = region_idx;
            seed_array(1).region_colour = region_colour;
        else
            region_idx = region_idx + 1;
            % choose a random color
            region_colour = rand(1,3);
            seed_array(1).region_idx = region_idx;
            seed_array(1).region_colour = region_colour;
        end
%--------------------------------------------------------------------------        
% P_min remove-> {A} [1]
%--------------------------------------------------------------------------
        A_matrix(seed_index) = [];
    end
%--------------------------------------------------------------------------    
% For i = 0 to size({S_c{i}}) do [1]
%--------------------------------------------------------------------------
    % not sure how well this will work really...
    while(~isempty(seed_array))        
        if(~isempty(coord_matrix))
            coord_matrix = [];
        end
        % now do the knn to find nearest neighbours of seed point
        % just randomise the whole k nearest neighbour process
        for o = 1:length(A_matrix)
            coords = A_matrix(o).vec__point;
            coord_matrix = [ coord_matrix; coords ];
        end
        x = coord_matrix;
        if(isempty(x))
            disp(['This is the x matrix: ', mat2str(x), '.']);
            % no point continuing as structure of A_matrix is empty
        end
        
        r = 1;
        current_point = seed_array(r);
        if(isempty(current_point.vec__point)| isempty(current_point.var__normal))
            disp(['This is the current point vector: ', mat2str(current_point.vec__point), '.']);
            disp(['This is the current point normal: ', mat2str(current_point.var__normal), '.']);
            seed_array(r) = [];
        end
        if(~isempty(x))
%--------------------------------------------------------------------------            
% Find the nearest neighbours of current seed point {B_c} <- Omega(S_c{i}) [1]
%--------------------------------------------------------------------------
            % [ xyz_closest ] = calculation__find_k_nearest_neighbours(k,
            % current_point.vec__point, x, A_matrix);
            dists = sqrt(sum(bsxfun(@minus, x, current_point.vec__point).^2, 2));
            
            [distance_asc, ind] = sort(dists);
            % The final step is to now return those k data points that are
            % closest to newpoint.
            % if the total number of elements in the index is less than k
            if(numel(ind) < k)
                disp(['ind: ', mat2str(ind), ' is less than k: ', num2str(k),'. Do it.']);
                % chuck 'em all in
                xyz_closest = A_matrix(ind);
            else
                % or chuck in the nearest k elements
                ind_closest = ind(1:k);
                ind_closest_array = [ind_closest_array, ind_closest];
                xyz_closest = A_matrix(ind_closest);
            end
%--------------------------------------------------------------------------            
% For j = 0 to size({B_c}), do [1]
%--------------------------------------------------------------------------            
            for j = 1:length(xyz_closest)
%--------------------------------------------------------------------------                
% Current neighbour point P_j <- B_c{j} [1]
%--------------------------------------------------------------------------                
                % compare the angle of the two normals
                angle_comparison = acosd(dot(current_point.var__normal, xyz_closest(j).var__normal));
                % round and convert this value to signed int
                angle_comparison = round(angle_comparison);
                if(angle_comparison > 90)
                    angle_comparison = 180 - angle_comparison;
                end
%--------------------------------------------------------------------------                
% If {A} contains P_j and cos^-1(|<N{S_c{i}}, N{P_j}>|) < Theta_th  [1]
%--------------------------------------------------------------------------                
                % get all the A_matrix unique identifier
                idx__A_matrix_array = [A_matrix.idx__plane_draw];
                % get all the xyz_closest unique identifier
                idx__xyz_closest_point = [xyz_closest(j).idx__plane_draw];
                % compare the array members together
                idx__current_in_A_matrix = ismember(idx__A_matrix_array, idx__xyz_closest_point);
                
                if((any(idx__current_in_A_matrix) == 1) && (angle_comparison <= normal_threshold))
%--------------------------------------------------------------------------                    
% P_j insert -> {R_c}  [1]
%--------------------------------------------------------------------------                    
                    region_array_add = [region_idx, angle_comparison, region_colour(:, 1), region_colour(:, 2), region_colour(:, 3)];
                    region_array = cat(1, region_array, region_array_add);
                    xyz_closest(j).region_idx = region_idx;
                    xyz_closest(j).region_colour = region_colour;
%--------------------------------------------------------------------------                    
% P_j remove -> {A}  [1]
%--------------------------------------------------------------------------                    
                    remove = find([A_matrix.idx__plane_draw] == xyz_closest(j).idx__plane_draw);
                    A_matrix(remove) = [];                    
                    
                    r_threshold = normal_threshold;
%--------------------------------------------------------------------------                    
% If r{P_j} < r_th then [1]
%--------------------------------------------------------------------------                    
                    if(angle_comparison < r_threshold)
%--------------------------------------------------------------------------                        
% P_j insert-> {S_c} [1]
%--------------------------------------------------------------------------                        
                        seed_array(end + 1) = xyz_closest(j);
                    end
                    
                    % prepare the variables to hold the new plot handles and
                    % indexes
                    if(isempty(han__seg_plane_draw))
                        idx__seg_plane_draw =  1;
                    else
                        idx__seg_plane_draw = idx__seg_plane_draw + 1;
                    end

                    han__plane_draw = xyz_closest(j).han__plane_draw;
                    idx__plane_draw = xyz_closest(j).idx__plane_draw;
                    if(ishandle(han__plane_draw))
                        %pause(1);
                        % delete the previous index of the plane on the current plot
                        delete(han__plane_draw);
                    end
                    
                    han__seg_plane_draw(idx__seg_plane_draw) = surf(reshape(xyz_closest(j).mat__bf_plane_x, 3, 3), reshape(xyz_closest(j).mat__bf_plane_y, 3, 3), ...
                        reshape(xyz_closest(j).mat__bf_plane_z, 3, 3), 'FaceColor', xyz_closest(j).region_colour ,'facealpha', 0.7);
                                        
                    xyz_closest(j).han__seg_plane_draw = han__seg_plane_draw(end);
                    xyz_closest(j).idx__seg_plane_draw = idx__seg_plane_draw;
                    
                    if(isempty(fieldnames((final_array))))
                        field_names = fieldnames(xyz_closest(j));
                        for fi = 1:length(field_names)
                            [final_array(:).(field_names{fi})] = [];
                        end
                    end
                    
                    final_array(end + 1) = xyz_closest(j);
                end
            end
            seed_array(1) = [];
        else
            % TODO not sure how much sense this makes now. Must check the shizzle
            % later
            seed_array(1) = [];
        end
    end
end

idx__final_array_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), final_array);
final_array = final_array(~idx__final_array_empty_elems);
for special_idx = 1:region_idx
    % calculate the average normal vector from one region and plot it
    find_idx = find([final_array.region_idx] == special_idx);
    % as long as it isn't empty
    if(~isempty(find_idx))
        % get the appropriate indexes
        final_array_find = final_array(find_idx);
        % get the points of those points
        test_array_points = vertcat(final_array_find.vec__point);
        % get the appropriate colour
        macro_region_colour = final_array_find(1).region_colour;
        % get the centeroid plane point and the average normal
        [var__normal, mat__orthnorm_plane_base, var__plane_point] = affine_fit(test_array_points);
        plane_base = mat__orthnorm_plane_base;
        % do the calculations to get the new plane boundary - alternative with
        % boundary.m to follow soon
        %legend({'Region ',special_idx},'Color', macro_region_colour);
        AA = test_array_points';
        
        % Find point in AA closest to p1.
        centeroid_point = var__plane_point; % centeroid
        squaredDistance = sqrt(sum((AA-repmat(centeroid_point', [1, size(AA, 2)])).^2, 1));
        %dists = sqrt(sum(bsxfun(@minus, test_array_points, centeroid_point).^2, 2));
        [maxSqDist1, indexOfMax1] = max(squaredDistance);
        search_space_interval = maxSqDist1;
        % draw the macro plane
        %segmentation__region_plane_draw(centeroid_point, plane_base, search_space_interval, final_array_find, macro_region_colour, test_array_points);
        [strike, strike2, dip_direction, dip_direction2, dip, dip2, sigma, centeroid, direction_cosines] = calculation__strike_and_dip(test_array_points, var__normal);
        segmentation__region_plane_draw(centeroid_point, var__normal, final_array_find, macro_region_colour, test_array_points, special_idx, strike, strike2, dip, dip2, dip_direction, dip_direction2);

        disp('--------------------------------------------------------');
        disp(['Results for region ', num2str(special_idx)]);
        disp(['Strike measurement: ', num2str(strike)]);
        disp(['Strike2 measurement: ', num2str(strike2)]);
        disp(['Dip measurement: ', num2str(dip)]);
        disp(['Dip2 measurement: ', num2str(dip2)]);
        disp(['Dip Direction measurement: ', num2str(dip_direction)]);
        disp(['Dip Direction2 measurement: ', num2str(dip_direction2)]);
        disp('--------------------------------------------------------');
    end
end



%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function segmentation__region_growing.m terminating.');
end

