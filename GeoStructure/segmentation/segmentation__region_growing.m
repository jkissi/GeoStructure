%% segmentation__macro_region.m (Plane Fit functions)
function [ planes, final_array, region_idx ] = segmentation__region_growing(planes)
% Function to implement region growing algorithm to classify all points in
% the cloud to group them into larger regions (A_matrix) for measurement
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Implementation of Region Growing and point cloud segmentation algorithm
% from T. Rabbani(2006) - Segmentation of Point Clouds Using Smoothness
% Constraint[1]
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
timer_start__segmentation__region_growing = tic; %Start GeoStruct timer
global geo_struct;
xyz_closest = struct();
seed_array = struct(); % Stores coordinates for points with normals larger than the threshold for the
region_array = [];
final_array = struct();
region_idx = []; % added to the point structs so that each point is in a region
current_point =  []; % just take the first point for now
normal_comparison_array = [];
coord_matrix = [];
ind_closest_array = [];
normal_threshold = geo_struct.normal_threshold;%10
A_matrix = planes;
han__seg_plane_draw = [];
idx__seg_plane_draw = 1;
random_range_min = 1;
random_range_max = [];
random_number_of_outputs = 1;
add_region = [];
region_idx_switch = 0;
counter__no_match = 0;
counter__zero_matches = 0;
seed_index = [];
normal_comparison_array = struct();
% K Nearest Neigh
k = geo_struct.region_growing_k;
r_thresh_factor = geo_struct.r_thresh_factor;
% TODO usually the last entry in the array comes in without a point vector
% or a bormal vector. Not sure why, must but for now, just get rid of the
% entry
% idx__A_matrix_empty_elems = arrayfun(@(s) any(structfun(@isempty, s)), A_matrix);
% A_matrix = A_matrix(~idx__A_matrix_empty_elems);

[A_matrix.han__seg_plane_draw] = deal([]);
[A_matrix.idx__seg_plane_draw] = deal([]);
[A_matrix.region_idx] = deal([]);
[A_matrix.region_colour] = deal([]);
[A_matrix.normal_vector_average] = deal([]);

[normal_comparison_array.var__normal] = deal([]);
[normal_comparison_array.idx__plane_draw] = deal([]);

%[ A_matrix, matrix__A_edge ] = ancillary__field_harmoniser(A_matrix, matrix__A_edge);
%[ A_matrix, seed_array ] = ancillary__field_harmoniser(A_matrix, seed_array);
[ A_matrix, xyz_closest ] = ancillary__field_harmoniser(A_matrix, xyz_closest);
[ A_matrix, final_array ] = ancillary__field_harmoniser(A_matrix, final_array);
%--------------------------------------------------------------------------
% While {A} is not empty, do...
%--------------------------------------------------------------------------

% keep loop going until A_matrix is empty
while(~isempty(A_matrix))
    
    % catch empty structs in the array. If the plane_draw field is empty,
    % then none of the other fields will be complete either
    idx__A_matrix_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_matrix);
    A_matrix = A_matrix(~idx__A_matrix_empty_elems);
    % this is to catch when there is only one entry left. The loop is
    % effectively over, so exit
    if(length(A_matrix) == 1)
        disp('A matrix only have one value left. exit');
        idx__final_array_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), final_array);
        final_array = final_array(~idx__final_array_empty_elems);
        break;
    end
    % if the seed index is empty, it could be trasformed into a double.
    % Transform it back
    if(isa(seed_index, 'double'))
        [ A_matrix, seed_array ] = ancillary__field_harmoniser(A_matrix, seed_array);
    end
    % catch the first instance, before the seed array has been filled
    if(isempty(fieldnames(seed_array)) || isempty(seed_array))
        
%--------------------------------------------------------------------------
% Point with minimum residual in {A} -> P_min (changed to random select) [1]
%--------------------------------------------------------------------------       
        % generate seed point for the beginning of the algo. Random should 
        % be fine
        if(isempty(seed_index))
%         random_range_max = length(A_matrix);
%         [ seed_index ] = ancillary__randomiser(random_range_min, random_range_max, random_number_of_outputs);
        % select min residual value
        r_matrix = [A_matrix.residual_average];
        [seed_value, seed_index] = min(r_matrix);
        seed_array(1) = A_matrix(seed_index);
        end
        disp(['seed index is:  ', num2str(seed_index),'.']);
        disp(['A_matrix is:  ', num2str(numel(A_matrix)),'.']);
        if(numel(A_matrix) == 7)
            disp('hold on there, captain!!!');
        end
        %disp(['A_matrix figures are:  ', mat2str(A_matrix),'.']);
        if((seed_index == 0) || (numel(A_matrix) == 0))
            break;
         else            
%--------------------------------------------------------------------------
% P_min insert-> {S_c}&{R_c} [1]
%--------------------------------------------------------------------------       
%             random_range_max = length(A_matrix);
%             [ seed_index ] = ancillary__randomiser(random_range_min, random_range_max, random_number_of_outputs);
            % this bit is a back up plan to avoid getting stuck in a loop
            r_matrix = [A_matrix.residual_average];
            [seed_value, seed_index] = min(r_matrix);
            
            seed_array(1) = A_matrix(seed_index);
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
        else %if(region_idx_switch)
            update_average_normal = find([final_array.region_idx] == region_idx);
            for z = 1:length(update_average_normal)
                final_array(update_average_normal(z)).normal_vector_average = normal_vector_average;
            end 
            region_idx = region_idx + 1;
            % choose a random color
            region_colour = rand(1,3);
            seed_array(1).region_idx = region_idx;
            seed_array(1).region_colour = region_colour;
            normal_comparison_array = struct();
            normal_comparison_array.idx__plane_draw = deal([]);
            normal_comparison_array.var__normal = deal([]);
            region_idx_switch = 0;
        end
%--------------------------------------------------------------------------        
% P_min remove-> {A} [1]
%--------------------------------------------------------------------------
        %A_matrix(seed_index) = [];
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
            seed_array = [];
            break;
        end
        
        r = 1;
        current_point = seed_array(r);
        if(isempty(current_point.vec__point)| isempty(current_point.var__normal))
            disp(['This is the current point vector: ', mat2str(current_point.vec__point), '. Its empty, remove the point!!']);
            disp(['This is the current point normal: ', mat2str(current_point.var__normal), '. Its empty, remove the point!!']);
            if(~isempty(current_point.idx__plane_draw))
                remove = find([A_matrix.idx__plane_draw] == current_point.idx__plane_draw);
                A_matrix(remove) = []; 
            end
            seed_array(r) = [];
            current_point = [];  
        end
        if(~isempty(x) & ~isempty(current_point))
%--------------------------------------------------------------------------            
% Find the nearest neighbours of current seed point {B_c} <- Omega(S_c{i}) [1]
%--------------------------------------------------------------------------
            if(size(x, 2) ~= 3 |  size(current_point.vec__point, 2) ~= 3)
                disp('vars are not equal to 3');
            end
            [ xyz_closest ] = calculation__find_k_nearest_neighbours(k, x, current_point.vec__point, A_matrix);
            xyz_length = length(xyz_closest);
%--------------------------------------------------------------------------            
% For j = 0 to size({B_c}), do [1]
%--------------------------------------------------------------------------            
            for j = 1:length(xyz_closest)
%--------------------------------------------------------------------------                
% Current neighbour point P_j <- B_c{j} [1]
%--------------------------------------------------------------------------          
                idx__norm = find([normal_comparison_array.idx__plane_draw] == xyz_closest(j).idx__plane_draw);
                if(any(idx__norm))
                    disp(['already matched. the normal vector ave is: ', mat2str(normal_vector_average)]);
                else 
                    nca_length = length(normal_comparison_array);
                    normal_comparison_array(nca_length + 1).var__normal = xyz_closest(j).var__normal;
                    normal_comparison_array(nca_length + 1).idx__plane_draw = xyz_closest(j).idx__plane_draw;
                    normal_vector_average = mean([normal_comparison_array.var__normal], 2);                    
                end
                % compare the angle of the two normals
                angle_comparison = acosd(dot(current_point.var__normal, xyz_closest(j).var__normal));

                
                
                
                %angle_comparison = atan2d(norm(cross(current_point.var__normal, xyz_closest(j).var__normal)), dot(current_point.var__normal, xyz_closest(j).var__normal));                
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
                alpha_offset = abs(dot(current_point.var__normal/norm(current_point.var__normal).^2, current_point.vec__point - xyz_closest(j).vec__point));
                r_threshold = r_thresh_factor;
                
                %if((any(idx__current_in_A_matrix) == 1) && (angle_comparison <= normal_threshold))
                if((alpha_offset <= r_threshold) && (angle_comparison <= normal_threshold))                    
%--------------------------------------------------------------------------                    
% P_j insert -> {R_c}  [1]
%--------------------------------------------------------------------------
                    if(~isempty(xyz_closest(j).region_idx))
                       
                        continue;
                    end
                    xyz_closest(j).region_idx = region_idx;
                    xyz_closest(j).region_colour = region_colour;
%--------------------------------------------------------------------------                    
% P_j remove -> {A}  [1]
%--------------------------------------------------------------------------                    
                    remove = find([A_matrix.idx__plane_draw] == xyz_closest(j).idx__plane_draw);
                    A_matrix(remove) = [];                    
                     
                    
                    %alpha_offset = abs(dot(current_point.var__normal/norm(current_point.var__normal).^2, current_point.vec__point - xyz_closest(j).vec__point));
                    
                    
                    %r_threshold = 0.01*current_point.residual_average;
                    %r_threshold = r_thresh_factor;
                    %if(~isnan(xyz_closest(j).residual_average) & ~isnan(current_point.residual_average))
%--------------------------------------------------------------------------                    
% If r{P_j} < r_th then [1]
%--------------------------------------------------------------------------                    
                    %if(xyz_closest(j).residual_average < r_threshold)
                    %if(alpha_offset <= r_threshold)
%--------------------------------------------------------------------------                        
% P_j insert-> {S_c} [1]
%--------------------------------------------------------------------------                        
                        seed_array(end + 1) = xyz_closest(j);
                    %end
                    %end
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
                    
                    %[ A_matrix, final_array ] = ancillary__field_harmoniser(A_matrix, final_array);
                    final_array(end + 1) = xyz_closest(j);
                    idx__final_array_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), final_array);
                    final_array = final_array(~idx__final_array_empty_elems);                    
                 else %if(angle_comparison > normal_threshold)
                     counter__no_match = counter__no_match + 1;
%                     disp('')
                    disp(['no match: ', num2str(counter__no_match)]);
                    disp(['total zero matches: ', num2str(counter__zero_matches)]);
                    % check first if the counter has already been fulfilled
                    if(counter__zero_matches == 2) 
                        counter__zero_matches = 0;
                    end
                    xyz_length = length(xyz_closest);
                    if(counter__no_match == xyz_length)
                        counter__no_match = 0;
                        if(isempty(counter__zero_matches))
                            counter__zero_matches = 0;
                            disp(['adding a zero match: ', num2str(counter__zero_matches)]);
                        else 
                            counter__zero_matches = counter__zero_matches + 1;
                            disp(['else adding a zero match: ', num2str(counter__zero_matches)]);
                        end 
                    end 

                 end
            end
            if(counter__zero_matches == 2) 
                region_idx_switch = 1;
                disp(['removing the seed. number left is: ', num2str(length(seed_array))]);
                seed_array(1) = [];
                counter__zero_matches = 0;
            end            
            
            counter__no_match = 0;

            %seed_array(1) = [];
            idx__seed_array_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), seed_array);
            seed_array = seed_array(~idx__seed_array_empty_elems);            
        end
    end
end


%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------

%timer_start__segmentation__region_growing = tic; %Start GeoStruct timer
timer_stop__segmentation__region_growing = toc(timer_start__segmentation__region_growing); %Stop internal timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__segmentation__region_growing = timer_start__segmentation__region_growing;
    geo_struct.timings.timer_stop__segmentation__region_growing = timer_stop__segmentation__region_growing;
end

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.parent_folder, filesep, geo_struct.stats.experiment, '__seg_rg', geo_struct.stats.figure_ext]);
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function segmentation__region_growing.m terminating.');
end

