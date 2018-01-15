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
timer_start__point_cloud__read = tic; %Start GeoStruct timer
global geo_struct;

%--------------------------------------------------------------------------
% Display input message 
%--------------------------------------------------------------------------
% Always 'TRUE' variable 
verbose = 1;

if(verbose)  % If true, print the following... 
    fprintf(1, 'GeoStructure v1.0\n');
    fprintf(1, 'copyright Jon Kissi-Ameyaw (2016, 2017, 2018).\n');
    fprintf(1, ['MATLAB version: ', version, '\n']);
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
% Mahalanobis distance for noise reduction -- Don't forget, the hand written 
% implementation is ready to be swapped in closer to the time
%--------------------------------------------------------------------------
node_xyz = node_xyz';

% subsample_length = length(node_xyz);
% sub = round(subsample_length/2);
% 
if(geo_struct.point_cloud__read.calculation__get_mahal_dist.switch)
    mahal_array = [];
    for u = 1:length(node_xyz)
        mahal_array(end + 1) = mahal(node_xyz(u, :), node_xyz);
    end
    %number_of_std = 0.5;
    %mahal_idx = mahal_array > (mean(mahal_array)+ number_of_std*std(mahal_array));
    mahal_idx = mahal_array > 4.5;
    mahal_idx = mahal_idx';
    node_xyz = node_xyz(~mahal_idx, :);
end


% number_of_std = 5.0;
% % % test to see if I can remove outliers through this method 
% dave_points = node_xyz;
% %figure;
% %hold on;
% % 
% dist_idx = 1;
% dave_points3 = dave_points;
% while(any(dist_idx) == 1) 
%    
%    distance = sqrt(sum(dave_points3.^2,2));
%    dist_idx = distance > (mean(distance)+ number_of_std*std(distance));
%    dave_points3 = dave_points3(~dist_idx, :, :);
%    
% end
% node_xyz = dave_points3;


%--------------------------------------------------------------------------
% View the object
%-------------------------------------------------------------------------
figure;
scatter3(node_xyz(:, 2), node_xyz(:, 1), node_xyz(:, 3), 1, 'marker', '.');
%scatter3(node_xyz(1:sub, 2), node_xyz(1:sub, 1), node_xyz(1:sub, 3), 1, 'marker', '.');
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
set(gca,'ZDir','reverse');
xlabel('<--- X --->');
ylabel('<--- Y --->');
zlabel('<--- Z --->');

% This kees the graph showing and selected so that it is visible and the 
% subsequent processes add their results to the current figure
hold on;
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------

timer_stop__point_cloud__read = toc(timer_start__point_cloud__read); %Stop internal timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__point_cloud__read = timer_start__point_cloud__read;
    geo_struct.timings.timer_stop__point_cloud__read = timer_stop__point_cloud__read;
end

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.parent_folder, filesep, geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);

disp('Read complete. Function point_cloud__read.m terminating.');
return;
end