%% point_cloud__get_coords.m (Point Cloud functions)
function [struct__ps] = point_cloud__get_coords(current_graph_axes, struct__ps)
% This function extracts point data from from a figure. 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Written primarily to hoover up and return the points from the Search 
% Space Interrogates the provided plot axes and extracts the x, y, z point 
% data, and adds them to vectors. 
% Returns the x_vals, y_vals and z_vals vectors. 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% current_graph_axes :: current axes object
%
%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------      
%--------------------------------------------------------------------------
% Access data object of current axes
%--------------------------------------------------------------------------
% OK, get the current figure, drill down to the right level and find the
% appropriate placeholder structure

axes_obs = get(current_graph_axes, 'Children');

data_obs = get(axes_obs, 'Children');

%--------------------------------------------------------------------------
% Do some kind of rudimentary checking that the structure we want actually
% exists...
%--------------------------------------------------------------------------
if(isprop(data_obs, 'XData'))
    point_array = findobj(data_obs, 'type', 'scatter');
    
%--------------------------------------------------------------------------
% Hoover up all the x,y,z values into arrays for returning
%--------------------------------------------------------------------------    
    % Of course, assume that just because one of these arrays exists, they
    % all must do. This will certainly not lead to any problems.
    % Get axis values
    x_vals = point_array.XData;
    y_vals = point_array.YData;
    z_vals = point_array.ZData;

%--------------------------------------------------------------------------
% Just in case the values are in a cell array, which matlab sometimes does  
%--------------------------------------------------------------------------     
elseif(iscell(data_obs)) 
    Props = cell2struct(data_obs,'SurfaceProps', 2);

%--------------------------------------------------------------------------
% Determine if the appropriate property field is present and if it is,
% extract only the x,y,z values pertaining to the points
%--------------------------------------------------------------------------
    if(isfield(Props, 'SurfaceProps'))
        point_array = findobj(Props(2).SurfaceProps, 'type', 'scatter');
    
%--------------------------------------------------------------------------
% Hoover up all the x,y,z values into arrays for returning
%--------------------------------------------------------------------------    
        % More assumption. Excellent. 
        % Get axis values
        x_vals = point_array.XData;
        y_vals = point_array.YData;
        z_vals = point_array.ZData;
        
    else
        disp('Theres no surface property field in the current figure.');
    end
%--------------------------------------------------------------------------
% If there isnt a surface properties field, then return a message
%--------------------------------------------------------------------------          
else
    disp('There doesnt seem to be the appropriate field present to extract the scatter points');
end

struct__ps.vec__x_point_vals = x_vals;
struct__ps.vec__y_point_vals = y_vals;
struct__ps.vec__z_point_vals = z_vals;
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function point_cloud__get_coords.m terminating.');
return;       
end