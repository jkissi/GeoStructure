%% point_space__create.m (Point Space functions)
function [var__point_space_limit_min, var__point_space_limit_max, ...
    mat__point_space_vertices] = point_space__create(mat__cube_face_connect, var__point_space_limit_min, var__point_space_limit_max)
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


%--------------------------------------------------------------------------
% Create matrix indicating connection order of the faces of a cube
%--------------------------------------------------------------------------      

% the 6 faces of the cube, each is defined by connecting 4 of the
% available vertices:
mat__cube_face_connect = [1 2 3 4; 4 3 5 6; 6 7 8 5;
                           1 2 8 7; 6 7 1 4; 2 3 5 8];
                      
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

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function point_space__create.m terminating.');
return;       
end
      