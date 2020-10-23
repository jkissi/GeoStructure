%% point_space__search.m (Point Space functions)
function [ struct__planes ] = point_space__search(struct__axes, struct__ps)
% Function to search the Point Space
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Searches the Point Space with the Search Space which is generated in a
% function called from the loop. The loop steps through the Point Space at
% defined intervals equal to the Search Space. This effectively divides the
% Point Space into a 3D grid of blocks the same volume as the Search Space.
%
% At each interval an evaulation of the prescence of point occurs and
% depending on the results, further operations are executed. 
%
% Outputs the visual cues of Space processing to the plot. Returns no 
% variables
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% vec__ _point_vals :: vectors with the directional point values 
% ax__axes_limits_ :: axes limits in each direction
% mat__search_space_cube_vertices :: matrix of the search space verticies
% var__search_space_interval :: 1/2 the total step of the search space
% interval
% mat__cube_face_connect :: matrix containing the order of connection for
% the space faces
%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Calling function to generate point cloud surface
%--------------------------------------------------------------------------
timer_start__point_space__search = tic; %Start GeoStruct timer

global geo_struct;

han__search_space = []; % var to contain the plot handle for the Search Space
idx__search_space = 1; % idx of the Search Space plot
struct__planes = struct();
struct__planes.idx__plane_draw = 1;
struct__planes.han__plane_draw = [];
struct__planes.vec__point = [];
ax__axes_limits_x = struct__axes.ax__axes_limits_x;
ax__axes_limits_y = struct__axes.ax__axes_limits_y;
ax__axes_limits_z = struct__axes.ax__axes_limits_z;
var__search_space_interval = struct__ps.var__search_space_interval;
mat__search_space_cube_vertices = struct__ps.mat__search_space_cube_vertices;
vec__x_point_vals = struct__ps.vec__x_point_vals;
vec__y_point_vals = struct__ps.vec__y_point_vals;
vec__z_point_vals = struct__ps.vec__z_point_vals;

%--------------------------------------------------------------------------
% Loop to draw the Search Space, evaluate the contents, destroy the Search
% Space and move on to the next interval
%--------------------------------------------------------------------------
% one loop for each direction, bounded at the minimum and maximum values so
% that the Search Space is always inside the Point Space, and, progresses
% through that space in intervals equivalent to 1 volume of Search Space,
% which is equivalent to a rational multiplier of the Point Space volume
for m = min(ax__axes_limits_z + var__search_space_interval):abs(var__search_space_interval*2):max(ax__axes_limits_z - var__search_space_interval)
    for n = min(ax__axes_limits_y + var__search_space_interval):abs(var__search_space_interval*2):max(ax__axes_limits_y - var__search_space_interval)
        for o = min(ax__axes_limits_x + var__search_space_interval):abs(var__search_space_interval*2):max(ax__axes_limits_x - var__search_space_interval)
            
            % randomised colours...
            vec__search_space_color = rand(1,3); 
            
            % vector to translate the Search Space 
            vec__search_space_translation = [o, n, m]; 

%--------------------------------------------------------------------------
% creates new positional vector based on the volume and current position
%--------------------------------------------------------------------------            
            mat__new_search_space = bsxfun(@plus, mat__search_space_cube_vertices, vec__search_space_translation);

%--------------------------------------------------------------------------
% Create a new instance of the Search Space
%--------------------------------------------------------------------------            
            [ han__search_space, idx__search_space ] = search_space__create(han__search_space,...
                idx__search_space, mat__new_search_space, vec__search_space_color);

            %[ han__search_space, idx__search_space ] = search_space__create(han__search_space,...
             %   idx__search_space, mat__cube_face_connect, mat__new_search_space, vec__search_space_color);            
%--------------------------------------------------------------------------
% Evaluate Search Space for points
%--------------------------------------------------------------------------                
            % cat vectors together
            mat__xyz_point_vals = [vec__x_point_vals; vec__y_point_vals; vec__z_point_vals];
            [ mat__point_matrix ] = search_space__intersecting_points(mat__new_search_space, mat__xyz_point_vals);
            
            
%--------------------------------------------------------------------------
% Is the Search Space empty?
%--------------------------------------------------------------------------     
            % if there is no points in the bounding array, destroy the
            % Search Space 
            if(isempty(mat__point_matrix))
                [ han__search_space, idx__search_space ] = search_space__destroy(han__search_space, idx__search_space);
            
            % if there is a point in the bounding array, evaluate the
            % Search Space 
            elseif(~isempty(mat__point_matrix))
                disp(['Point matrix is ', mat2str(mat__point_matrix),'\n and the index is ', num2str(o),', ',...
                    num2str(n),', ',num2str(m), '\n Done, bye :-)'])

%--------------------------------------------------------------------------
% Derive plane orientation from point density(?)
%--------------------------------------------------------------------------                   
                [var__normal, mat__orthnorm_plane_base, var__plane_point, residual_average, norm_of_residuals] = best_fit_plane__find_orientation(mat__point_matrix');
                
                %[var__normal, mat__orthnorm_plane_base, var__plane_point] = affine_fit(mat__point_matrix');
                
                vec__point = var__plane_point;

%--------------------------------------------------------------------------
% Draw the Plane of Best Fit
%--------------------------------------------------------------------------        
                disp(['normal vec is ', mat2str(var__normal),' and the index is ', num2str(o),', ',...
                    num2str(n),', ',num2str(m), '. The number is ', num2str(struct__planes(end).idx__plane_draw),'. Done, bye :-)'])
                struct__planes(struct__planes(end).idx__plane_draw).var__normal = var__normal;
                struct__planes(struct__planes(end).idx__plane_draw).vec__point = vec__point;
                [ struct__planes ] = best_fit_plane__draw(vec__point, mat__orthnorm_plane_base, var__search_space_interval, residual_average, norm_of_residuals, struct__planes);
                 
                % then...destroy the Search Space. Hate that Search Space...;-) 
                [ han__search_space, idx__search_space ] = search_space__destroy(han__search_space, idx__search_space);              
                
                % reset the point matrix. This way there is no chance
                % using points from a previous Search Space and skewing the
                % plane derivation
                mat__point_matrix = [];
            end
            
        end
        
    end
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
%timer_start__point_space__search = tic; %Start GeoStruct timer
timer_stop__point_space__search = toc(timer_start__point_space__search); %Stop internal timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__point_space__search = timer_start__point_space__search;
    geo_struct.timings.timer_stop__point_space__search = timer_stop__point_space__search;
end

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.parent_folder, filesep, geo_struct.stats.experiment, '__ps_search', geo_struct.stats.figure_ext]);
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function point_space__search.m terminating.');
return;
end

