%% best_fit_plane__find_orientation.m (Plane Fit functions)
function [var__normal, mat__orthnorm_plane_base, var__plane_point, residual_average, norm_of_residuals] = best_fit_plane__find_orientation(mat__point_matrix)
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

%--------------------------------------------------------------------------
% Call affine fit
%--------------------------------------------------------------------------

[var__normal, mat__orthnorm_plane_base, var__plane_point] = affine_fit(mat__point_matrix);

%--------------------------------------------------------------------------
% Call lsplane (i need both of the residual values)
%--------------------------------------------------------------------------

[centeroid, cosines, residuals, norm_of_residuals] = lsplane(mat__point_matrix);

residual_average = mean(residuals);
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__find_orientation.m terminating.');
return;
end 