%% segmentation__macro_region.m (Plane Fit functions)
function [ planes, final_array, region_idx ] = segmentation__region_growing(planes)
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
timer_start__segmentation__region_growing = tic; %Start GeoStruct timer
global geo_struct;

beta = struct(); % Stores coordinates for points with normals larger than the threshold for the
final_array = struct();
region_idx = []; % added to the point structs so that each point is in a region
current_point =  []; % just take the first point for now
angle_comparison_array = [];
coord_matrix = [];
ind_closest_array = [];
normal_threshold = geo_struct.normal_threshold;%10
A_matrix = planes;
han__seg_plane_draw = [];
idx__seg_plane_draw = 1;
matrix__A_seedbank = struct();
counter__zero_matches = [];
matrix__A_edge = struct();
idx__plane_draw = [];
seedbank_switch = 0; 
remove = [];
counter__no_match = [];
A_seedbank = struct();
% K Nearest Neigh
k = geo_struct.region_growing_k;
% TODO usually the last entry in the array comes in without a point vector
% or a bormal vector. Not sure why, must but for now, just get rid of the
% entry
% generate seed point for the beginning of the algo. Random should
% be fine
% keep loop going until A_matrix is empty
while(~isempty(A_matrix))
    
    % catch empty structs in the array. If the plane_draw field is empty,
    % then none of the other fields will be complete either
    idx__A_matrix_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_matrix);
    A_matrix = A_matrix(~idx__A_matrix_empty_elems);

    
    
a = 1;
b = length(A_matrix);
r = (b - a).*rand(1) + a;
r = round(r);
seed_index = r;
%[ seed_index ] = ancillary__randomiser(1, length(A_matrix), 1);

disp(['seed index is:  ', num2str(seed_index),'.']);
disp(['A_matrix is:  ', num2str(numel(A_matrix)),'.']);
if((seed_index == 0) || (numel(A_matrix) == 0))
    break;
else
    beta = A_matrix(seed_index);
    A_matrix(seed_index) = [];
    % catch empty structs in the array. 
    idx__A_matrix_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_matrix);
    A_matrix = A_matrix(~idx__A_matrix_empty_elems);
end    

if(0 > counter__zero_matches <= 2) % counter to catch no matching of any points
    beta = current_point;
elseif(seedbank_switch)
    % catch empty structs in the array. 
    idx__A_seedbank_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_seedbank);
    A_seedbank = A_seedbank(~idx__A_seedbank_empty_elems);    
    
    beta = matrix__A_seedbank(1);
    matrix__A_seedbank(1) = [];

end
% initialise the region selection
if(isempty(region_idx))
    region_idx = 1;
    % choose a random color
    region_colour = rand(1,3);
    beta(1).region_idx = region_idx;
    beta(1).region_colour = region_colour;
elseif(counter__zero_matches < 10)
    region_idx = region_idx;
else
    region_idx = region_idx + 1;
    % choose a random color
    region_colour = rand(1,3);
    beta(1).region_idx = region_idx;
    beta(1).region_colour = region_colour;
end


%knn bit
r = 1;
current_point = beta(r);
if(isempty(current_point.vec__point)| isempty(current_point.var__normal))
    disp(['This is the current point vector: ', mat2str(current_point.vec__point), '.']);
    disp(['This is the current point normal: ', mat2str(current_point.var__normal), '.']);
    beta(r) = [];
end

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

if(~isempty(x))

    % Find the nearest neighbours of current seed point {B_c} <-
    % Omega(S_c{i}) [1]
    [ knn_closest ] = calculation__find_k_nearest_neighbours(k, current_point.vec__point, x, A_matrix);
    
    
    for j = 1:length(knn_closest)
        % compare the angle of the two normals
        angle_comparison = acosd(dot(current_point.var__normal, knn_closest(j).var__normal));
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
        idx__knn_closest_point = [knn_closest(j).idx__plane_draw];
        % compare the array members together
        idx__current_in_A_matrix = ismember(idx__A_matrix_array, idx__knn_closest_point);
        %vec__current_in_A_matrix(end + 1) = idx__current_in_A_matrix;
        if((any(idx__current_in_A_matrix) == 1))
            if(angle_comparison <= normal_threshold)

                % P_j insert -> {R_c}  [1]
                %region_array_add = [region_idx, angle_comparison, region_colour(:, 1), region_colour(:, 2), region_colour(:, 3)];
                %region_array = cat(1, region_array, region_array_add);
                knn_closest(j).region_idx = region_idx;
                knn_closest(j).region_colour = region_colour;

                
                % P_j remove -> {A}  [1]
                remove(end + 1) = find([A_matrix.idx__plane_draw] == knn_closest(j).idx__plane_draw);
                %A_matrix(remove) = [];
                
                % prepare the variables to hold the new plot handles and
                % indexes
                if(isempty(han__seg_plane_draw))
                    idx__seg_plane_draw =  1;
                else
                    idx__seg_plane_draw = idx__seg_plane_draw + 1;
                end
                
                han__plane_draw = knn_closest(j).han__plane_draw;
                idx__plane_draw = knn_closest(j).idx__plane_draw;
                if(ishandle(han__plane_draw))
                    %pause(1);
                    % delete the previous index of the plane on the current plot
                    delete(han__plane_draw);
                end
                
                han__seg_plane_draw(idx__seg_plane_draw) = surf(reshape(knn_closest(j).mat__bf_plane_x, 3, 3), reshape(knn_closest(j).mat__bf_plane_y, 3, 3), ...
                    reshape(knn_closest(j).mat__bf_plane_z, 3, 3), 'FaceColor', knn_closest(j).region_colour ,'facealpha', 0.7);
                
                knn_closest(j).han__seg_plane_draw = han__seg_plane_draw(end);
                knn_closest(j).idx__seg_plane_draw = idx__seg_plane_draw;
                
                if(isempty(fieldnames(final_array)))
                    field_names = fieldnames(knn_closest(j));
                    for fi = 1:length(field_names)
                        [final_array(:).(field_names{fi})] = [];
                    end
                end
                
                final_array(end + 1) = knn_closest(j);
                
            elseif(angle_comparison > normal_threshold)
               if(isa(matrix__A_edge, 'double'))
                   disp('Hello!!');
               end
               if(isempty(fieldnames(matrix__A_edge)))
                    field_names = fieldnames(knn_closest(j));
                    for fi = 1:length(field_names)
                        [matrix__A_edge(:).(field_names{fi})] = [];
                    end
                end
                matrix__A_edge(end + 1) = knn_closest(j);
                if(isempty(counter__no_match))
                    counter__no_match = 1;
                else
                    counter__no_match = counter__no_match + 1;
                end
            end
            if(counter__zero_matches == 2)
                counter__zero_matches = 0;
            end
            knn_length = length(knn_closest);
            if(counter__no_match == knn_length)
                if(isempty(counter__zero_matches))
                    counter__zero_matches = 1;
                else 
                    counter__zero_matches = counter__zero_matches + 1;
                end 
            end
        end
    end
    % Now that a couple of cycles have happened, delete matches from the
    % A_matrix
    %remove = find([A_matrix.idx__plane_draw] == xyz_closest(j).idx__plane_draw);
    A_matrix(remove) = [];
    % catch empty structs in the array. 
    idx__A_matrix_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), A_matrix);
    A_matrix = A_matrix(~idx__A_matrix_empty_elems);
    
    matrix__A_seedbank = matrix__A_edge;
    seedbank_switch = 1;
    matrix__A_edge = []; 
    % catch empty structs in the array. 
    idx__A_edge_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), matrix__A_edge);
    matrix__A_edge = matrix__A_edge(~idx__A_edge_empty_elems);
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

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__seg_rg', geo_struct.stats.figure_ext]);
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function segmentation__region_growing.m terminating.');
end

