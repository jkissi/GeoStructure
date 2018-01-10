%% point_cloud__read.m (Point Cloud functions)
function [ ] = point_cloud__read(ply_filename)
% Function to read and display point cloud data file 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Generates plot of point cloud by reading the input .ply file, calling 
% ply_to_tri_surface() and displaying the result using scatter(). 
% Outputs scatter of the point cloud file. 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% ply_filename :: This is the file path input

%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Display input message 
%--------------------------------------------------------------------------
% Always 'TRUE' variable 
verbose = 1;

if(verbose)  % If true, print the following... 
    fprintf(1, '\n');
    %timestamp();
    fprintf(1, '\n');
    fprintf(1, 'PLY_DISPLAY\n');
    fprintf(1, '  MATLAB version\n');
    fprintf(1, '  Read a PLY file and display it\n');
end

%--------------------------------------------------------------------------
% If first argument not supplied, request it from the user.
%--------------------------------------------------------------------------
if(nargin < 1)
    disp('Please input the .ply file');
    ply_filename = input('Enter the name of the point file \n');
end

%--------------------------------------------------------------------------
% Call main function to extract node and element information.
%--------------------------------------------------------------------------
[ node_xyz, element_node, node_colour ] = point_cloud__ply_to_tri_surface(ply_filename);

%--------------------------------------------------------------------------
% View the object
%-------------------------------------------------------------------------
number_of_std = 1.5;
% % test to see if I can remove outliers through this method 
% bumbum_points = node_xyz';
% distance = sqrt(sum(bumbum_points.^2,2));
% indices = distance<(mean(distance)+number_of_std*std(distance));
% dave_points = bumbum_points(indices, :, :);
% % vec__x_point_vals = dave_points(:, 1);
% % vec__y_point_vals = dave_points(:, 2);
% % vec__z_point_vals = dave_points(:, 3);
% node_xyz = dave_points';
dave_points = node_xyz';
%figure;
%hold on;
knumber = 100;
[idx, C] = kmeans(dave_points, knumber);

dist_idx = 1;
dave_points3 = dave_points;
while(any(dist_idx) == 1) 
   
   distance = sqrt(sum(dave_points3.^2,2));
   dist_idx = distance > (mean(distance)+ number_of_std*std(distance));
   dave_points3 = dave_points3(~dist_idx, :, :);
   
end
% figure;
% scatter3(dave_points3(:, 2), dave_points3(: ,1), dave_points3(:, 3), 1, 'marker', '.');
% set(gca,'ZDir','reverse');
% xlabel('<--- X --->');
% ylabel('<--- Y --->');
% zlabel('<--- Z --->');

cloud = pointCloud(dave_points);
figure
pcshow(cloud);
title('Original Data');
set(gca,'ZDir','reverse');
xlabel('<--- X --->');
ylabel('<--- Y --->');
zlabel('<--- Z --->');

% % figure;
% % scatter3(node_xyz(2, :), node_xyz(1, :), node_xyz(3, :), 1, 'marker', '.');
%  set(gca,'YDir','reverse');
%   set(gca,'ZDir','reverse');
% xlabel('<--- X --->');
% ylabel('<--- Y --->');
% zlabel('<--- Z --->');
% hold on;
%--------------------------------------------------------------------------
% Experiment to see if simply applying mean averaging surfacing will give
% me something usable
%--------------------------------------------------------------------------
% get the distance between two points
% for the length of the coord array
dave_points4 = node_xyz;
distance_array = [];
darray_mean = [];
da_idx = 1;
EuclidDistancePrevArray = [];
EuclidDistanceNextArray = [];
EuclidDistanceCurrArray = [];
    figure;
    grid on;
    scatter3(dave_points4(2,:), dave_points4(1, :), dave_points4( 3, :), 1, 'marker', '.');
    set(gca,'XDir','reverse');
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
   
while(any(da_idx) == 1)
    distance_array = [];
for idx = 1:length(dave_points4)
% get the first point     
current_point = dave_points4(:, idx);
% if there is a previous point
if(idx ~= 1)
    % grab it 
previous_point = dave_points4(:, idx-1);
else
previous_point = [0; 0; 0];
end 
% if there is a next point 
if(idx == length(dave_points4))
next_point = [0; 0; 0];

else
    % grab that
next_point = dave_points4(:, idx+1);
end
disp(['This is the index: ', num2str(idx)]);
% get the distance between the current point and the previous point 
EuclidDistancePrev = sqrt((current_point(1, :) - previous_point(1, :))^2 + (current_point(2, :)-previous_point(2, :))^2 + (current_point(3, :)-previous_point(3, :))^2);
% get the distance between the current point and the next point 
EuclidDistanceNext = sqrt((current_point(1, :) - next_point(1, :))^2 + (current_point(2, :)-next_point(2, :))^2 + (current_point(3, :)-next_point(3, :))^2);
EuclidDistance = [EuclidDistancePrev, EuclidDistanceNext];
% take the average of the distance bewteen current and other points 
EuclidDistanceMean = mean(EuclidDistance);
EuclidDistanceCurrArray(:, end + 1) = current_point;
EuclidDistancePrevArray(end + 1) = EuclidDistancePrev;
EuclidDistanceNextArray(end + 1) = EuclidDistanceNext;
% add this to the array
distance_array(end + 1) = EuclidDistanceMean;
%EuclidDistance = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2);
end

if(isempty(darray_mean))
 disp(['This is the index for darray: ', num2str(idx)]);   
darray_mean = mean(distance_array);
end 
% start with just greater than rather than looking at std just yet
% percentage offset 
% 36% of 25  (0.01 x 36) x wanted value
wanted_pc = 500;
one_pc = 0.01;
pc_offset = (one_pc * wanted_pc) * darray_mean;
%da_idx = distance_array >= darray_mean + pc_offset;
da_idx = zeros(length(dave_points4), 1);

for idx2 = 1:length(dave_points4)
if((EuclidDistancePrevArray(:, idx2) > (darray_mean + pc_offset)) | (EuclidDistanceNextArray(:, idx2) > (darray_mean + pc_offset)))
    da_idx(idx2,:) = 1;
end    
end


%da_idx = distance_array > (mean(distance_array)+ number_of_std*std(distance_array));
if(idx == 5000)
    disp('blahhh b;ah')

end 
    da_idx = da_idx';
    da_idx = logical(da_idx);
    dave_points5 = dave_points4(:, da_idx, :);
    dave_points6 = dave_points4(:, ~da_idx, :);
    figure;
    grid on;
    scatter3(dave_points6(2,:), dave_points6(1, :), dave_points6( 3, :), 1, 'marker', '.' );
    set(gca,'XDir','reverse');
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    hold on;
end 
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Read complete. Function point_cloud__read.m terminating.');
return;
end