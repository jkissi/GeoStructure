%% best_fit_plane__calculate.m (Plane Fit functions)
function [ planes ] = best_fit_plane__calculate(planes)
% Function to find the standard deviation of an area of smaller planes
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Finds the best fit plane
%
% Returns 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% index :: index of the set of planes to be sampled 
% matrix :: matrix of the coords of the planes 
% ?
mat__grouping_array = [];
idx__grouping_array = 1;
struct__current_point = planes(1); % just take the first point for now  
idx__seed_index_array = 1;
vec__next_seed_point = [];
current_seed_point = []; 
smoothness_angle = [];
angle_comparison_array = [];
ind_closest_array = [];
normal_threshold = 15;
struct__seeding_array = struct();
struct__grouping_array = struct();
coord_matrix = [];
b = 1;
for o = 1:length(planes)
    coords = planes(o).vec__point;
    coord_matrix = [ coord_matrix; coords ];
end
x = coord_matrix;

%--------------------------------------------------------------------------
% KNN Clustering 
%--------------------------------------------------------------------------
% Using the algorithm for Euclidean Distance 
%N = size(x, 1);
%dists = sqrt(sum((x - repmat(newpoint, N, 1)).^2, 2));
k = 10;
% dists would be a N element vector that contains the distances between 
% each data point in x and struct__current_point.vec__point. We do an element-by-element subtraction 
% between struct__current_point.vec__point and a data point in x, square the differences, then sum 
% them all together. This sum is then square rooted, which completes the 
% Euclidean distance. 
% Another possible solution would be to replicate struct__current_point.vec__point and make this 
% matrix the same size as x, then doing an element-by-element subtraction 
% of this matrix, then summing over all of the columns for each row and 
% doing the square root. 
% repmat takes a matrix or vector and repeats them a certain amount of times 
% in a given direction. In our case, we want to take our newpoint vector, and 
% stack this N times on top of each other to create a N x M matrix, where 
% each row is M elements long. We subtract these two matrices together, then 
% square each component. Once we do this, we sum over all of the columns for 
% each row and finally take the square root of all result. 

dists = sqrt(sum(bsxfun(@minus, x, struct__current_point.vec__point).^2, 2));

% Now that we have our distances, we simply sort them. dist_sorted_asc would contain the 
% distances sorted in ascending order, while ind tells you for each value in 
% the unsorted array where it appears in the sorted result. We need to use 
% ind, extract the first k elements of this vector, then use ind to index 
% into our x data matrix to return those points that were the closest to 
% newpoint.

[dist_sorted_asc,ind] = sort(dists);

% The final step is to now return those k data points that are closest to 
% newpoint. 

ind_closest = ind(1:k);

ind_closest_array = [ind_closest_array, ind_closest];
% ind_closest should contain the indices in the original data matrix x that 
% are the closest to newpoint. Specifically, ind_closest contains which rows 
% you need to sample from in x to obtain the closest points to newpoint. 
% x_closest will contain those actual data points.
%x_closest = x(ind_closest, :);
x_closest = planes(ind_closest);
dist_sorted = dist_sorted_asc(1:k); %Actual sorted distance values 
% Evaluate neighbour
% angle = acosd(dot(n_1, n_2));
% if angle > 90
%     angle = 180-angle;
% end
%vec__grouping_array(1) = struct__current_point; 
for i = 1:length(x_closest)
    % compare the angle of the two normals
    angle_comparison = acosd(dot(struct__current_point.var__normal, x_closest(i).var__normal));
    % compare the threshold against the angle
    angle_comparison_array(i) = angle_comparison;
    if(angle_comparison <= normal_threshold)
        % group like planes together
        if(any(isequal(angle_comparison, angle_comparison_array)))
            % get the existing index
            idx_existing_angle = any(isequal(angle_comparison, angle_comparison_array));
            % add the current iteration to the grouping array
            struct__grouping_array(i).idx__plane_draw = x_closest(i).idx__plane_draw;
            struct__grouping_array(i).han__plane_draw = x_closest(i).han__plane_draw;
            struct__grouping_array(i).vec__point = x_closest(i).vec__point;
            struct__grouping_array(i).var__normal = x_closest(i).var__normal;
            struct__grouping_array(i).mat__bf_plane_x = x_closest(i).mat__bf_plane_x;
            struct__grouping_array(i).mat__bf_plane_y = x_closest(i).mat__bf_plane_y;
            struct__grouping_array(i).mat__bf_plane_z = x_closest(i).mat__bf_plane_z;
            struct__grouping_array(i).colour = [0 1 0];
            % redraw the face with the group colour
            surf(reshape(struct__grouping_array(i).mat__bf_plane_x, 3, 3), reshape(struct__grouping_array(i).mat__bf_plane_y, 3, 3), ...
            reshape(struct__grouping_array(i).mat__bf_plane_z, 3, 3), 'FaceColor', struct__grouping_array(i).colour ,'facealpha', 0.7);
        else % make a new group for planes of this orientation 
            % add centeroid to the grouping array 
            struct__seeding_array(i).idx__plane_draw = x_closest(i).idx__plane_draw;
            struct__seeding_array(i).han__plane_draw = x_closest(i).han__plane_draw;
            struct__seeding_array(i).vec__point = x_closest(i).vec__point;
            struct__seeding_array(i).var__normal = x_closest(i).var__normal;
            struct__seeding_array(i).mat__bf_plane_x = x_closest(i).mat__bf_plane_x;
            struct__seeding_array(i).mat__bf_plane_y = x_closest(i).mat__bf_plane_y;
            struct__seeding_array(i).mat__bf_plane_z = x_closest(i).mat__bf_plane_z;
            % choose a random color
            %colour = rand(1,3);
            struct__seeding_array(i).colour = [1 0 0];
            surf(reshape(struct__seeding_array(i).mat__bf_plane_x, 3, 3), reshape(struct__seeding_array(i).mat__bf_plane_y, 3, 3), ...
            reshape(struct__seeding_array(i).mat__bf_plane_z, 3, 3), 'FaceColor', struct__seeding_array(i).colour ,'facealpha', 0.7);
        end
    %end
%end
%     else % Normal angle is greater than threshold so add this point to the seed pool
%     %for i = 1:length(xclosest)  
%         for u = 1:length(idx_seed_check_array)
%             if(~ismember(idx_seed_check_array, idx__seed_index_array(i).idx__plane_draw))
%                 idx_seed_check_array(i) = idx__seed_index_array(i).idx__plane_draw;
%                 % add the new plane centeroid to seed [potential new points] array 
%                 idx__seed_index_array(i) = planes(i);
%             else
%                 disp(['The index ', num2str(idx__seed_index_array(i).idx__plane_draw) , ' to this is already a memeber']);
%             end
%         end
%     end 
    end
% get a new point from the list of seeds
%newpoint = idx__seed_index_array(n).vec__point;
%newpoint = idx__seed_index_array(n).vec__point;
end 
%--------------------------------------------------------------------------
% Region growing
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Plane Segmentation
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__draw.m terminating.');
return;
end 