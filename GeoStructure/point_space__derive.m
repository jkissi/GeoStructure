%% point_space__derive.m (Point Space function)
function [ax__axes_limits_x ax__axis_limit_x_min ax__axis_limit_x_max ax__axes_limits_y ax__axis_limit_y_min ax__axis_limit_y_max ...
          ax__axes_limits_z ax__axis_limit_z_min ax__axis_limit_z_max var__axes_lim_min var__axes_lim_max var__point_space_limit ...
          var__point_space_limit_min var__point_space_limit_max] = point_space__derive(ax__current_axes)
% Function to derive the boundaries and dimensions of the space containing
% the whole point cloud. 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Takes the measurements of the current axes and derives the largest
% possible CUBE from these. If for some reason the axis dimesions are 0, 
% creates a point space of unit leangth. Doesn't make a whole lot of sense 
% but if you axes lengths are 0, you're already in trouble. 
% Returns all axis_limit and point_space_limit variables. 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% ax__current_axes :: variable containing the current axes
%
%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Use the axes property create limit variables 
%--------------------------------------------------------------------------

ax__axes_limits_x = get(ax__current_axes,'XLim'); % x direction
ax__axes_limits_y = get(ax__current_axes,'YLim'); % y direction
ax__axes_limits_z = get(ax__current_axes,'ZLim'); % z direction

%--------------------------------------------------------------------------
% Get the minimum and maximum values from the axes variables
%--------------------------------------------------------------------------

ax__axis_limit_x_min = min(ax__axes_limits_x); % x min
ax__axis_limit_x_max = max(ax__axes_limits_x); % x max

ax__axis_limit_y_min = min(ax__axes_limits_y); % y min
ax__axis_limit_y_max = max(ax__axes_limits_y); % y max

ax__axis_limit_z_min = min(ax__axes_limits_z); % z min
ax__axis_limit_z_max = max(ax__axes_limits_z); % z max

%--------------------------------------------------------------------------
% Grab the absolute minimum and maximum values 
%--------------------------------------------------------------------------

var__axes_lim_min = min([ax__axes_limits_x, ax__axes_limits_y, ax__axes_limits_z]);
var__axes_lim_max = max([ax__axes_limits_x, ax__axes_limits_y, ax__axes_limits_z]);

%--------------------------------------------------------------------------
% Construct to 'decide' the maximum and minimum directional limits of the 
% point space 
%--------------------------------------------------------------------------

% figure out which is the bigger value
if(abs(var__axes_lim_min) > abs(var__axes_lim_max))
    var__point_space_limit = var__axes_lim_min;
else
    var__point_space_limit = var__axes_lim_max;
end

% construct to make sure all the sides are the same length regardless of
% the sign of the variable
if(sign(var__point_space_limit) < 0)
    var__point_space_limit_max = abs(var__point_space_limit);
    var__point_space_limit_min = var__point_space_limit;
elseif(sign(var__point_space_limit) > 0)
    var__point_space_limit_max = var__point_space_limit;
    var__point_space_limit_min = -var__point_space_limit;
else
    var__point_space_limit_max = 1;
    var__point_space_limit_min = -1;
    disp('Axis limit values appears to be 0. Setting the point space cube to unit dimensions');
end
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Read complete. Function point_space__derive.m terminating.');
end 