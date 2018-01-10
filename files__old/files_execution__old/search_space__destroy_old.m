%% search_space__destroy.m (Search Space functions)
function [ han__search_space, idx__search_space ] = search_space__destroy(han__search_space, idx__search_space)
% Function to destroy the Search Space
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Destroys the Search Space encolsure 
% The input variables are passed to the matlab built-in function delete() to 
% delete the last drawn instance of the Search Space on the current plot
%
% Destroys the Search Space on the current plot. Returns current figure
% handle: han__search_space, and current figure handle index: 
% idx__search_space
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% han__search_space :: handle for current figure. Needed for drawing and
% redrawing of each Search Space instance
% idx__search_space :: index for the current Search Space instance. Needed
% for the drawing and redrawing of each Search Space

%--------------------------------------------------------------------------
% Destroy last instance of the Search Space
%--------------------------------------------------------------------------
% check that the handle exists
if(ishandle(han__search_space(idx__search_space - 1)))
    %pause(1);
    % delete the previous index of the Search Space on the current plot
    delete(han__search_space(idx__search_space - 1));
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function search_space__destroy.m terminating.');
return;
end