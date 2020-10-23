% -------------------------------------------------------------------------
% ancillary__randomiser.m
% -------------------------------------------------------------------------
function [ random_number ] = ancillary__randomiser(minval, maxval, no_of_out_values)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to extend the standard operation of rand() and make it a little
% more usable for this pipeline. 

% By default, rand returns normalized values (between 0 and 1) that are drawn 
% from a uniform distribution. To change the range of the distribution 
% to a new range, (a, b), multiply each value by the width of the new range, 
% (b - a) and then shift every value by a.
% -------------------------------------------------------------------------

a = minval;
b = maxval;
r = (b - a).*rand(no_of_out_values) + a;
% produces floats, so need to round to nearest input figure
r = round(r); 
random_number = r;


disp('Execution complete. Function ancillary__randomiser.m terminating.');
% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
end