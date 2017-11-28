function [ random_number ] = ancillary__randomiser(minval, maxval, no_of_out_values)


% By default, rand returns normalized values (between 0 and 1) that are drawn 
% from a uniform distribution. To change the range of the distribution 
% to a new range, (a, b), multiply each value by the width of the new range, 
% (b – a) and then shift every value by a.

a = minval;
b = maxval;
r = (b - a).*rand(no_of_out_values) + a;
r = round(r); % produces floats, so need to round to nearest input figure
random_number = r;


disp('Execution complete. Function ancillary__randomiser.m terminating.');
end