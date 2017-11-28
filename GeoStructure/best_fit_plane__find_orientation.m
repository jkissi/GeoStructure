%% best_fit_plane__find_orientation.m (Plane Fit functions)
function [dip_direction, dip, sigma, centeroid, direction_cosines] = best_fit_plane__find_orientation(points)
% Function to find the best fit plane 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Finds the best fit plane
%
% Returns 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% points :: matrix of the xyz coords of the points

%-------------------------------------------------------------------------
% Call lsplane 
%--------------------------------------------------------------------------
dip_direction = [];
dip = [];
angular_constant = [];
sigma = [];
centeroid = [];
direction_cosines = [];
% General plane: ax + by + cz + d = 0; 
% Apply svd to get the best fitting plane for 'cubic selection' using svd
% function
% matrix_cube = [0 0 0; 2 0 0; 2 4 0; 0 4 0; 0 0 3; 2 0 3; 2 4 3; 0 4 3]
% Best Fitting plane:
% [U, S, V] = svd(matrix_cube);
% 
% v_x = U;
% v_y = S;
% v_z = V;
% 
% %get direction cosine 
% al = v_x/sqrt(v_x.^2 + v_y.^2 + v_z.^2);
% l = cos(al); 
% be = v_y/sqrt(v_x.^2 + v_y.^2 + v_z.^2);
% m = cos(be); 
% ga = v_z/sqrt(v_x.^2 + v_y.^2 + v_z.^2);
% n = cos(ga); 

[centeroid, direction_cosines, residuals, norm_of_resid_errors] = lsplane(points');

if(~isempty(direction_cosines))
l = direction_cosines(1);
m = direction_cosines(2);
n = direction_cosines(3);

x_cosine = l; 
y_cosine = m; 
z_cosine = n; 

if((x_cosine > 0) && (y_cosine > 0))
    angular_constant = 0; 
end 

if((x_cosine > 0) && (y_cosine < 0))
    angular_constant = 360; 
end 

if((x_cosine < 0) && (y_cosine > 0))
    angular_constant = 180; 
end 

if((x_cosine < 0) && (y_cosine < 0))
    angular_constant = 180; 
end 




xyz = points;
%find the average of the points within the bounding cube
x_vals = xyz(:,1);
y_vals = xyz(:,2);
z_vals = xyz(:,3);

A = [x_vals y_vals ones(size(x_vals))];

b = z_vals;

sol=A\b;
m = sol(1);
n = sol(2);
c = sol(3);

errs = (m*x_vals + n*y_vals + c) - z_vals;

sigma = std(errs);

dip_direction = atan(y_cosine/x_cosine) + angular_constant;
dip = atan(z_cosine/sqrt(x_cosine^2 + y_cosine^2));
strike = dip_direction - 90;
else 
    disp('best_fit_plane__find_orientation.m - Not enough points to derive the direction cosines, dip or dip directions.');
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__find_orientation.m terminating.');
return;
end 