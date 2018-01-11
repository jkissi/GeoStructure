function [ phi_search ] = phi_section_search(theta, u_vector,test_array_points, normal, o)
%%

phi_search = struct();
v_vector = [];
vec__bgr = [];
% Generates output from the phi section search

v_vector = cross(u_vector, normal);
[ rot_matrix ] = rotation_matrix(normal, theta);

new_u = rot_matrix*u_vector;
new_v = cross(new_u, normal);
for i = 1:(size(test_array_points, 1))

mat__uvn = [new_u, new_v, normal];
mat__uvn = inv(mat__uvn);
vec__bgr(: , i) = mat__uvn*(test_array_points(i, :) - o)';
end


% find the bounding box

beta = vec__bgr(:, 1); 
gamma = vec__bgr(:, 2);
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

disp('Execution complete. Function phi_section_search.m terminating.');
return;
end