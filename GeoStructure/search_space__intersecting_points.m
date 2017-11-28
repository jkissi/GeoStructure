%% search_space__intersecting_points.m (Search Space functions)
function [ mat__point_matrix ] = search_space__intersecting_points(mat__new_search_space, mat__xyz_point_vals)
% Function to evaluate the Search Space for points
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. This function takes the matricies of 
% the current Search Space coordinates and the entire point cloud and 
% finds the mathematical instersection of the two.   
%
% Returns coordinate matrix modified by Search Space and point cloud
% intersection
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% mat__new_search_space :: matrix of most recent Search Space position 
% mat__xyz_point_vals :: matrix of point coordinates for the entire point
% cloud

%--------------------------------------------------------------------------
% Divide Search Space matrix into vectors
%--------------------------------------------------------------------------
vec__ax_x_range = mat__new_search_space(:, 1);
vec__ax_y_range = mat__new_search_space(:, 2);
vec__ax_z_range = mat__new_search_space(:, 3);

%--------------------------------------------------------------------------
% Divide Search Space matrix into vectors
%--------------------------------------------------------------------------
vec__x_point_vals = mat__xyz_point_vals(1, :);
vec__y_point_vals = mat__xyz_point_vals(2, :);
vec__z_point_vals = mat__xyz_point_vals(3, :);

%--------------------------------------------------------------------------
% Find all values within the range in each direction
%--------------------------------------------------------------------------
idx__point_space_x = find(vec__x_point_vals > min(vec__ax_x_range) & vec__x_point_vals < max(vec__ax_x_range));
idx__point_space_y = find(vec__y_point_vals > min(vec__ax_y_range) & vec__y_point_vals < max(vec__ax_y_range));
idx__point_space_z = find(vec__z_point_vals > min(vec__ax_z_range) & vec__z_point_vals < max(vec__ax_z_range));

%--------------------------------------------------------------------------
% Take all the converging intersections
%--------------------------------------------------------------------------
idx__point_space_xy = intersect(idx__point_space_x, idx__point_space_y);
idx__point_space_xyz = intersect(idx__point_space_xy, idx__point_space_z);

%--------------------------------------------------------------------------
% Get index of all points inside the Search Space
%--------------------------------------------------------------------------
mat__point_matrix = mat__xyz_point_vals(:, idx__point_space_xyz);

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function search_space__intersecting_points.m terminating.');
return;
end 