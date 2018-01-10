%% search_space__create.m (Search Space functions)
function [ han__search_space, idx__search_space ] = search_space__create(han__search_space, idx__search_space, mat__cube_face_con, mat__new_search_space, vec__search_space_color)
% Function to create the Search Space
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Generates the Search Space encolsure 
% with specified dimension and direction around a set of coordinates. 
% The input variables are passed to the matlab built-in function patch() to 
% draw resulting figure on the current plot.
%
% Outputs the Search Space to the current plot. Returns current figure
% handle: han__search_space, and current figure handle index: 
% idx__search_space
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% han__search_space :: handle for current figure. Needed for drawing and
% redrawing of each Search Space instance
% idx__search_space :: index for the current Search Space instance. Needed
% for the drawing and redrawing of each Search Space
% mat__cube_face_connect :: matrix containing the order that cube faces are
% connected
% mat__new_search_space :: matrix of new position for the Search Space
% vec__search_space_color :: vector for randomised colour values 

%--------------------------------------------------------------------------
% Draw the new Search Space
%--------------------------------------------------------------------------      
han__search_space(idx__search_space) = patch('Faces', mat__cube_face_con, ...
    'Vertices', mat__new_search_space, 'FaceColor', vec__search_space_color, 'FaceAlpha', 0.1);

%--------------------------------------------------------------------------
% Increment the current figure handle index
%--------------------------------------------------------------------------     
idx__search_space = idx__search_space + 1;

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function search_space__create.m terminating.');
return;
end