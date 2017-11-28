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
% figure;
% scatter3(node_xyz(2, :), node_xyz(1, :), node_xyz(3, :), 1, 'marker', '.');
% set(gca,'YDir','reverse');
% set(gca,'ZDir','reverse');
% xlabel('<--- X --->');
% ylabel('<--- Y --->');
% zlabel('<--- Z --->');
% hold on;

%--------------------------------------------------------------------------
% Mahalobis distance for noise reduction -- Don't forget, the hand written 
% implementation is ready to be swapped in closer to the time
%--------------------------------------------------------------------------
node_xyz = node_xyz';
mahal_array = [];
for u = 1:length(node_xyz)
    mahal_array(end + 1) = mahal(node_xyz(u, :), node_xyz);
end
%number_of_std = 0.5;
%mahal_idx = mahal_array > (mean(mahal_array)+ number_of_std*std(mahal_array));
mahal_idx = mahal_array > 4.5;
mahal_idx = mahal_idx';
node_xyz = node_xyz(~mahal_idx, :);
%--------------------------------------------------------------------------
% View the object
%-------------------------------------------------------------------------
figure;
scatter3(node_xyz(:, 2), node_xyz(:, 1), node_xyz(:, 3), 1, 'marker', '.');
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
set(gca,'ZDir','reverse');
xlabel('<--- X --->');
ylabel('<--- Y --->');
zlabel('<--- Z --->');
hold on;
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Read complete. Function point_cloud__read.m terminating.');
return;
end