%% calculation__find_k_nearest_neighbours.m (Plane Fit functions)
function [ closest_neighbours ] = calculation__find_k_nearest_neighbours(k, search_list, current_point, parent_matrix)
% Function to find the k nearest neighbours
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Finds the k nearest neighbours
%
% Returns
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% points :: matrix of the xyz coords of the points
ind_closest_array = [];

% produces a vector of distances
vec__distances = sqrt(sum(bsxfun(@minus, search_list, current_point).^2, 2));

% sorts the vector by distance
[ vec__distances_sorted, idx__distances_sorted ] = sort(vec__distances);
%--------------------------------------------------------------------------
% The final step is to now return those k data points that are closest to 
% newpoint.
%--------------------------------------------------------------------------
% if the total number of elements in the index is less than k
if(numel(idx__distances_sorted) < k)
    disp(['ind: ', mat2str(idx__distances_sorted), ' is less than k: ', num2str(k),'. Proceed.']);
    % chuck 'em all in
    closest_neighbours = parent_matrix(idx__distances_sorted);
else
    % or chuck in the nearest k elements
    ind_closest = idx__distances_sorted(1:k);
    ind_closest_array = [ind_closest_array, ind_closest];
    closest_neighbours = parent_matrix(ind_closest);
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function calculation__find_k_nearest_neighbours.m terminating.');
return;
end