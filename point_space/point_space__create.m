%% point_space__create.m (Point Space functions)
function [struct__axes, struct__ps] = point_space__create(struct__axes, struct__ps)
% Function to create point space enclosure
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Generates the point space encolsure around the point cloud plot by taking
% the var__point_space_limit_ and mat__cube_face_connect variables and
% using the matlab built-in function patch() to draw resulting figure on
% the current plot. 
% Returns the mat__point_space_vertices and var__point_space_limit_ 
% variables. 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% mat__cube_face_connect :: matrix containing the order that cube faces are
% connected
% var__point_space_limit_min :: variable minimum directional limit of point
% space
% var__point_space_limit_max :: variable maximum directional limit of point
% space

%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------      
timer_start__point_space__create = tic; %Start GeoStruct timer
global geo_struct;

%--------------------------------------------------------------------------
% Create matrix indicating connection order of the faces of a cube
%--------------------------------------------------------------------------      

% the 6 faces of the cube, each is defined by connecting 4 of the
% available vertices:

mat__cube_face_connect = geo_struct.point_space__create.mat__cube_face_connect;

var__point_space_limit_min = struct__ps.var__point_space_limit_min;
var__point_space_limit_max = struct__ps.var__point_space_limit_max;

ax__axis_limit_x_min = struct__axes.ax__axis_limit_x_min;
ax__axis_limit_x_max = struct__axes.ax__axis_limit_x_max;
ax__axis_limit_y_min = struct__axes.ax__axis_limit_y_min;
ax__axis_limit_y_max = struct__axes.ax__axis_limit_y_max;
ax__axis_limit_z_min = struct__axes.ax__axis_limit_z_min;
ax__axis_limit_z_max = struct__axes.ax__axis_limit_z_max;

%--------------------------------------------------------------------------
% Create matrix indicating connection order of verticies for a cube 
%--------------------------------------------------------------------------     
% the different 8 vertices of the cube, each is defined by its 3 x y z 
% coordinates. Beside is the order for a cube of unit length, so it's
% easier to see whats happening

mat__point_space_vertices = ...
       [var__point_space_limit_max var__point_space_limit_max var__point_space_limit_min; % 1 1 -1
        var__point_space_limit_min var__point_space_limit_max var__point_space_limit_min; % -1 1 -1
        var__point_space_limit_min var__point_space_limit_max var__point_space_limit_max; % -1 1 1
        var__point_space_limit_max var__point_space_limit_max var__point_space_limit_max; % 1 1 1
        var__point_space_limit_min var__point_space_limit_min var__point_space_limit_max; % -1 -1 1
        var__point_space_limit_max var__point_space_limit_min var__point_space_limit_max; % 1 -1 1
        var__point_space_limit_max var__point_space_limit_min var__point_space_limit_min; % 1 -1 -1
        var__point_space_limit_min var__point_space_limit_min var__point_space_limit_min]; % -1 -1 -1

%--------------------------------------------------------------------------
% Draw the point space on the plot
%--------------------------------------------------------------------------  
% use the "patch" function to draw the point space enclosure    
patch('Faces', mat__cube_face_connect, 'Vertices', mat__point_space_vertices, 'Facecolor', 'w');  

alpha('clear'); % makes the bounding enclosure trasparent 
grid on; % adds a grid
hold on; % holds the figure so more stuff can be added later

% Set axis to limit plus 10% in each direction
axis([var__point_space_limit_min + ((10/100) * ax__axis_limit_x_min), ...
      var__point_space_limit_max + ((10/100) * ax__axis_limit_x_max), ...
      var__point_space_limit_min + ((10/100) * ax__axis_limit_y_min), ...
      var__point_space_limit_max + ((10/100) * ax__axis_limit_y_max), ...
      var__point_space_limit_min + ((10/100) * ax__axis_limit_z_min), ...
      var__point_space_limit_max + ((10/100) * ax__axis_limit_z_max)]);

view(3); % set plot view


struct__ps.mat__point_space_vertices = mat__point_space_vertices;

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
timer_stop__point_space__create = toc(timer_start__point_space__create); %Stop internal timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__point_space__create = timer_start__point_space__create;
    geo_struct.timings.timer_stop__point_space__create = timer_stop__point_space__create;
end

disp('Execution complete. Function point_space__create.m terminating.');
return;       
end
      