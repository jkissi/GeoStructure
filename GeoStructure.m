%% GeoStructure.m (Main function)
function [struct__planes, orientations] = GeoStructure()
% GeoStructure MATLAB/SfM software pipeline 
% Framework to run experiments on the using matlab and VSfM to create, read
% and postprocess pointcloud data for Geological analysis  
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Stage 1: Plot planes on point surface 
% Stage 2: Aggregate planes
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% Local Variables
%--------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% Intialise GeoStruct object
%--------------------------------------------------------------------------
timer_start__GeoStruct = tic; %Start GeoStruct timer
global geo_struct;

%[ geo_struct ] = newGeoStruct();

%tstart_ga = tic; %Start internal timer
%tstop_ga = toc(tstart_ga); %Stop internal timer
%% ------------------------------------------------------------------------
% Convert from video to images (Currently run manually, so newGeo_Struct switch is off)
%--------------------------------------------------------------------------
if(geo_struct.v2i3.switch)
    v2i3('D:\research\drone_2\copy\Bebop_Drone_2015-11-27T2211.mp4', 'drone_2211', 'jpg');
end 
%% ------------------------------------------------------------------------
% Modify number of images (Currently run manually, so newGeo_Struct switch is off)
%--------------------------------------------------------------------------
if(geo_struct.one_over.switch)
    one_over(10, 'D:\research\drone_2\copy\frames_from_Bebop_Drone_2015-11-27T2211', 'D:\research\drone_2\copy\frames_from_Bebop_Drone_2015-11-27T2211', '10', 'jpg');
end
%% ------------------------------------------------------------------------
% Run VSfM (Currently run manually, so newGeo_Struct switch is off)
%--------------------------------------------------------------------------
if(geo_struct.run_vsfm.switch)
    [status, result] = system(['cmd /c VisualSFM sfm+pmvs my_jpg_list.txt my_result.nvm']);
end
%% ------------------------------------------------------------------------
% Run Meshlab (Currently run manually, so newGeo_Struct switch is off)
%--------------------------------------------------------------------------
if(geo_struct.run_meshlab.switch)
    [status, result] = system(['meshlabserver -i ', geo_struct.run_meshlab.dense_mesh,' -o ./meshed.ply -s ',geo_struct.run_meshlab.mlx_script_file,' -om vc vn']);
end
%% ------------------------------------------------------------------------
% Read point cloud (.ply) file into Matlab matrices
%--------------------------------------------------------------------------

% read in point cloud file
point_cloud__read(geo_struct.point_cloud__read.point_cloud_file);

pause('on'); % initiate matlab pause function

%--------------------------------------------------------------------------
% Derive point space dimensions
%--------------------------------------------------------------------------
% get axes propeties from the loaded point cloud file and process to create
% the variable for the point space bounding cube

ax__current_axes = gca; 

[struct__axes struct__ps] = point_space__derive(ax__current_axes);

%--------------------------------------------------------------------------
% Generate Point Space enclosure
%--------------------------------------------------------------------------

if(geo_struct.point_space__create.switch)
    [struct__axes, struct__ps] = point_space__create(struct__axes, struct__ps);
end

%--------------------------------------------------------------------------
% Derive Search Space properties
%--------------------------------------------------------------------------
% the factor by which the search space is a fractal of the point space
%var__search_cube_size_factor = 0.01;
var__search_cube_size_factor = geo_struct.var__search_cube_size_factor;

% product of the point space vertices and the Search Space factor gives the
% Search Space verticies values
mat__search_space_cube_vertices = struct__ps.mat__point_space_vertices * var__search_cube_size_factor;

% because the point space is ALWAYS a cube, can just take the absolute of
% any index to get 1/2 the step for the search progresion interval.
% Currently only building to evaulate the entirety of each space once. 
% Question - Am I sure I really want these two tied together? No.
var__search_space_interval = abs(mat__search_space_cube_vertices(1)); 
struct__ps.var__search_space_interval = var__search_space_interval;
struct__ps.mat__search_space_cube_vertices = mat__search_space_cube_vertices;

%--------------------------------------------------------------------------
% Extract the point cloud coordinates
%--------------------------------------------------------------------------
fig__current_figure = gcf; % get the current figure 

if(geo_struct.point_cloud__get_coords.switch)
% get point coordiantes from current figure
    [struct__ps] = point_cloud__get_coords(fig__current_figure, struct__ps);
end 

%--------------------------------------------------------------------------
% Search the Point Space
%--------------------------------------------------------------------------
% axis limits offsets ensure the search cube space is always bounded
% within the point space cube
if(geo_struct.point_space__search.switch)
    [ struct__planes ] = point_space__search(struct__axes, struct__ps);
end

%--------------------------------------------------------------------------
% Segmentation
%--------------------------------------------------------------------------
if(geo_struct.segmentation__region_growing.switch)
    [ struct__planes, final_array, region_idx] = segmentation__region_growing(struct__planes);
end
%[ struct__planes ] = segmentation__region_growing(struct__planes);

if(geo_struct.segmentation__generate_region_plane.switch)
    [ struct__planes, orientations ] = segmentation__generate_region_plane(struct__planes, final_array, region_idx);
end

%--------------------------------------------------------------------------
% Get Orientations
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
timer_stop__GeoStruct = toc(timer_start__GeoStruct); %Stop total GeoStruct timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__GeoStruct = timer_start__GeoStruct;
    geo_struct.timings.timer_stop__GeoStruct = timer_stop__GeoStruct;
end

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.parent_folder, filesep, geo_struct.stats.experiment, '__complete', geo_struct.stats.figure_ext]);
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function GeoStructure.m terminating.');
end