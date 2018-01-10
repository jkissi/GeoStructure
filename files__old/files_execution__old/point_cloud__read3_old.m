%% point_cloud__read.m (Point Cloud functions)
function [ ] = point_cloud__read3(ply_filename)
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

figure;
scatter3(node_xyz(2, :), node_xyz(1, :), node_xyz(3, :), 1, 'marker', '.');
 set(gca,'YDir','reverse');
  set(gca,'ZDir','reverse');
xlabel('<--- X --->');
ylabel('<--- Y --->');
zlabel('<--- Z --->');

%--------------------------------------------------------------------------
% Mahalobis experiment 
%--------------------------------------------------------------------------
dave_points4 = node_xyz';
mahal_array = [];
for u = 1:length(dave_points4)
    mahal_array(end + 1) = mahal(dave_points4(u, :), dave_points4);
end
number_of_std = 0.5;
%mahal_idx = mahal_array > (mean(mahal_array)+ number_of_std*std(mahal_array));
mahal_idx = mahal_array > 4.5;
mahal_idx = mahal_idx';
dave_points5 = dave_points4(~mahal_idx, :);
figure;
title('mahal');
scatter3(dave_points5(:, 2), dave_points5(:, 1), dave_points5(:, 3), 1, 'marker', '.');
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
set(gca,'ZDir','reverse');
xlabel('<--- X --->');
ylabel('<--- Y --->');
zlabel('<--- Z --->');
hold on;

% mahalobis direct implementation - it works, need to stick it in later
% http://people.revoledu.com/kardi/tutorial/Similarity/MahalanobisDistance.html
% sigma = sample covariance 
% mu = sample mean 
%d(I) = (Y(I,:)-mu)*inv(SIGMA)*(Y(I,:)-mu)';
% mahal2_array = [];
% for b = 1:length(dave_points4)
% % Return mahalanobis distance of two data matrices 
% % A and B (row = object, column = feature)
% mahal2_array(end + 1) = calculation__get_mahal_dist(dave_points4, dave_points4(b, :));
% end 
% number_of_std = 0.5;
% %mahal_idx2 = mahal2_array > (mean(mahal2_array)+ number_of_std*std(mahal2_array));
% mahal_idx2 = mahal_array > 3.8;
% mahal_idx2 = mahal_idx2';
% dave_points6 = dave_points4(~mahal_idx2, :);
% scatter3(dave_points6(:, 2), dave_points6(:, 1), dave_points6(:, 3), 1, 'marker', '.');

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Read complete. Function point_cloud__read.m terminating.');
return;
end