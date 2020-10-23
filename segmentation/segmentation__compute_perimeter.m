% -------------------------------------------------------------------------
% segmentation__compute_perimeter function
% -------------------------------------------------------------------------
function [ phi_search ] = segmentation__compute_perimeter(theta, u_vector,test_array_points, normal, o)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function that computes the perimeter of the region plane denoted by each
% seperately deliniated region on the point cloud. This particular function
% uses a rotation matrix and operates as part of a phi section search to 
% approximately calculate the tightest outer most perimeter of all best-fit 
% planes assigned to a single region. 
% -------------------------------------------------------------------------

phi_search = struct();
v_vector = [];
vec__bgr = [];
% -------------------------------------------------------------------------
% Generate output from the phi section search
% -------------------------------------------------------------------------
v_vector = cross(u_vector, normal);
[ rot_matrix ] = calculation__rotation_matrix(normal, theta);

new_u = rot_matrix*u_vector;
new_v = cross(new_u, normal);
for i = 1:(size(test_array_points, 1))

mat__uvn = [new_u, new_v, normal];
mat__uvn = inv(mat__uvn);
vec__bgr(: , i) = mat__uvn*(test_array_points(i, :) - o)';
end

% -------------------------------------------------------------------------
% Find the bounding box
% -------------------------------------------------------------------------

beta = vec__bgr(1,:); 
gamma = vec__bgr(2, :);
beta_min = min(beta);
beta_max = max(beta);
gamma_min = min(gamma);
gamma_max = max(gamma);

perimeter = 2*(beta_max - beta_min) + 2*(gamma_max - gamma_min);

phi_search.perimeter = perimeter;
phi_search.beta_max = beta_max;
phi_search.beta_min = beta_min;
phi_search.gamma_max = gamma_max;
phi_search.gamma_min = gamma_min;
phi_search.new_u = new_u';
phi_search.new_v = new_v;


%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function segmentation__compute_perimeter.m terminating.');
return;
end