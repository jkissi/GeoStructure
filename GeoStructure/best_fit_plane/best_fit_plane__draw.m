%% best_fit_plane__draw.m (Plane Fit functions)
function [ planes ] = best_fit_plane__draw(vec__point, mat__orthnorm_plane_base, var__search_space_interval, residual_average, norm_of_residuals, planes)
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
han__plane_draw = planes(end).han__plane_draw;
idx__plane_draw = planes(end).idx__plane_draw;

%--------------------------------------------------------------------------
% Create plane area
%--------------------------------------------------------------------------
[mat__plane_1, mat__plane_2] = meshgrid([-var__search_space_interval 0 var__search_space_interval]);

%--------------------------------------------------------------------------
% Modify plane orientation using point offset and orthonormal rotation
% vector
%--------------------------------------------------------------------------
%generate the point coordinates
mat__bf_plane_x = vec__point(1) + [mat__plane_1(:) mat__plane_2(:)] * mat__orthnorm_plane_base(1, :)';
mat__bf_plane_y = vec__point(2) + [mat__plane_1(:) mat__plane_2(:)] * mat__orthnorm_plane_base(2, :)';
mat__bf_plane_z = vec__point(3) + [mat__plane_1(:) mat__plane_2(:)] * mat__orthnorm_plane_base(3, :)';

%--------------------------------------------------------------------------
% Plot the plane (using reshaped plane matricies)
%--------------------------------------------------------------------------


if(isempty(han__plane_draw))
    idx__plane_draw =  1;
else
    idx__plane_draw = idx__plane_draw + 1;
end 
%hold on;
han__plane_draw(idx__plane_draw) = surf(reshape(mat__bf_plane_x, 3, 3), reshape(mat__bf_plane_y, 3, 3), reshape(mat__bf_plane_z, 3, 3), 'facealpha', 0.1);


planes(idx__plane_draw).han__plane_draw = han__plane_draw(end);
planes(idx__plane_draw).idx__plane_draw = idx__plane_draw;
planes(idx__plane_draw).mat__bf_plane_x = mat__bf_plane_x;
planes(idx__plane_draw).mat__bf_plane_y = mat__bf_plane_y;
planes(idx__plane_draw).mat__bf_plane_z = mat__bf_plane_z;
planes(idx__plane_draw).residual_average = residual_average;
planes(idx__plane_draw).norm_of_residuals = norm_of_residuals;
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__draw.m terminating.');
%return;
end 