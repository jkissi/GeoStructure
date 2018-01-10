%% best_fit_plane__calculate.m (Plane Fit functions)
function [ planes ] = macro_plane__calculate(planes)
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

point_cloud = []; % The entire point cloud 
final_regions = []; % Stores the ID numbers of all the final regions
seed_array = []; % Stores coordinates for points with normals larger than the threshold for the 
grow_array = []; % Contains the k nearest list of points 
colour_array = []; % Store the idx's of all the colour vectors
region_array = [];
final_array = [];
region_idx = []; % added to the point structs so that each point is in a region
current_point =  planes(1); % just take the first point for now  
angle_comparison_array = [];
coord_matrix = [];
ind_closest_array = [];
b = 1;

for o = 1:length(planes)
    coords = planes(o).vec__point;
    coord_matrix = [ coord_matrix; coords ];
end
x = coord_matrix;

% K Nearest Neigh
k = 10;
dists = sqrt(sum(bsxfun(@minus, x, current_point.vec__point).^2, 2));

[dist_sorted_asc,ind] = sort(dists);
% The final step is to now return those k data points that are closest to
% newpoint.
ind_closest = ind(1:k);
ind_closest_array = [ind_closest_array, ind_closest];
x_closest = planes(ind_closest);
dist_sorted = dist_sorted_asc(1:k); %Actual sorted distance values
% Evaluate neighbour

while any(~isfield(planes, 'region_idx'))
    
%     for f = 1:10:length(x) % (length(x)\k) 
%         if(f > 1)
%             b = k;
%             k = k + k;
%         end
%         ind_closest = ind(b:k);
%         ind_closest_array = [ind_closest_array, ind_closest];
%         x_closest = planes(ind_closest);
%     end
    if(true)
        for y = 1:length(planes)
            if(~isfield(planes(y), 'region_idx'))
                array(end + 1) = planes(y).idx__plane_draw;
            end
            
        end
        if(numel(array) < k)
            x_closest = planes(array);
        end
    else
    % Just randomise the whole k nearest neighbour process
    a = 1;
    b = length(planes);
    r = (b-a).*rand(1) + a;
    r = round(r);
    current_point = planes(r);
    dists = sqrt(sum(bsxfun(@minus, x, current_point.vec__point).^2, 2));

    [dist_sorted_asc,ind] = sort(dists);
    % The final step is to now return those k data points that are closest to
    % newpoint.
    ind_closest = ind(1:k);
    ind_closest_array = [ind_closest_array, ind_closest];
    x_closest = planes(ind_closest);
    dist_sorted = dist_sorted_asc(1:k); %Actual sorted distance values
    % Evaluate neighbour
    end
    if(~isempty(seed_array))
        x_closest = planes(seed_array);
        current_point = planes(min(seed_array));
        seed_array = [];
    else
        for t = 1:length(x_closest)
            % compare the angle of the two normals
            angle_comparison = acosd(dot(current_point.var__normal, x_closest(t).var__normal));
            
            % compare the threshold against the angle
            angle_comparison_array(end + 1) = angle_comparison;
            
            % compare the threshold against the angle
            % check the neighbors for the current position
            if(angle_comparison <= normal_threshold)
                if(isempty(region_idx))
                    region_idx = 1;
                    % choose a random color
                    region_colour = rand(1,3);
                    region_array = [region_idx, angle_comparison, region_colour];
                end
                if(any(isequal(angle_comparison, angle_comparison_array)))
                    % get the existing index
                    idx_existing_angle = any(isequal(angle_comparison, angle_comparison_array));
                    x_closest(t).region_idx = region_array(region_array(1, :) == angle_comparison);
                    x_closest(t).region_colour = region_array(t, 3);
                    final_array(end +1) = x_closest(t);
                    surf(reshape(x_closest(t).mat__bf_plane_x, 3, 3), reshape(x_closest(t).mat__bf_plane_y, 3, 3), ...
                    reshape(x_closest(t).mat__bf_plane_z, 3, 3), 'FaceColor', x_closest(t).region_colour ,'facealpha', 0.7);                    
                end
                if(~isfield(x_closest(t), 'region_idx'))
                    x_closest(t).region_idx = region_array(t, 1);
                    x_closest(t).region_colour = region_array(t, 3);
                    final_array(end +1) = x_closest(t);
                    surf(reshape(x_closest(t).mat__bf_plane_x, 3, 3), reshape(x_closest(t).mat__bf_plane_y, 3, 3), ...
                    reshape(x_closest(t).mat__bf_plane_z, 3, 3), 'FaceColor', x_closest(t).region_colour ,'facealpha', 0.7);
                elseif(isempty(x_closest(t).region_idx))
                    x_closest(t).region_idx = region_array(t, 1);
                    x_closest(t).region_colour = region_array(t, 3);
                    final_array(end +1) = x_closest(t);
                    surf(reshape(x_closest(t).mat__bf_plane_x, 3, 3), reshape(x_closest(t).mat__bf_plane_y, 3, 3), ...
                    reshape(x_closest(t).mat__bf_plane_z, 3, 3), 'FaceColor', x_closest(t).region_colour ,'facealpha', 0.7);                    
                else
                    continue;
                end
                
            else
                region_idx = region_idx + 1;
                seed_array(end + 1) = x_closest(t).idx__plane_draw;
                % choose a random color
                region_colour = rand(1,3);
                region_array(end + 1) = [region_idx, angle_comparison, region_colour];
            end
            
        end
        
    end
end


end

