%% newGeoStruct.m
function [ geo_struct ] = newGeo_Struct(struct__options)
% Initialises and holds all variables, switches, default values 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Matlab Structure designed to preallocate and hold all variables and
% switches
% This is where all the magic happens. Finds the best fit plane
% function returns the default values for the processing scripts
% usually these values are overridden if a script wants to or if
% the user specified corresponding options on the commandline when
% running the generation
% Returns :: geo_struct initialisation structure  
%% ------------------------------------------------------------------------
% External none
%--------------------------------------------------------------------------
% points :: matrix of the xyz coords of the points
%options for script execution
%global geo_struct;
geo_struct = struct();
geo_struct.profile_script = 0;
geo_struct.debug = 0;
current_path = mfilename('fullpath');
% The program MUST be run from INSIDE the GeoStructure folder otherwise the
% program will make erroneous output folders to place the output graphs and
% textfile in. 
[pathstr, name, ext] = fileparts(current_path);
% make sure to use the 'filesep' for the slashes in all filenames. This 
% prevents errors from occuring when running on different os'.
output_folder = [pathstr, filesep 'output' filesep];
geo_struct.output_folder = output_folder;
option_fields = fieldnames(struct__options);
%--------------------------------------------------------------------------
% Convert from video to images
%--------------------------------------------------------------------------
geo_struct.v2i3.switch = 0;
geo_struct.absolute_video_file_path = ''; %'D:\research\drone_2\copy\Bebop_Drone_2015-11-27T2211.mp4'
geo_struct.output_image_file_prefix = ''; %'drone_2211'
geo_struct.output_file_ext = 'jpg'; %'jpg'

%--------------------------------------------------------------------------
% Modify number of images 
%--------------------------------------------------------------------------
geo_struct.one_over.switch = 0;
geo_struct.input_divisor = ''; %10
geo_struct.absolute_file_path = ''; %'D:\research\drone_2\copy\frames_from_Bebop_Drone_2015-11-27T2211'
geo_struct.absolute_output_path = ''; %'D:\research\drone_2\copy\frames_from_Bebop_Drone_2015-11-27T2211'
geo_struct.input_file_ext = 'jpg'; %'jpg'

%--------------------------------------------------------------------------
% Run VSfM (Currently run manually)
%--------------------------------------------------------------------------
geo_struct.run_vsfm.switch = 0;
geo_struct.run_vsfm.image_input_folder = geo_struct.output_folder;
geo_struct.run_vsfm.nvm_out_folder = '';

%--------------------------------------------------------------------------
% Run Meshlab (Currently run manually)
%--------------------------------------------------------------------------
geo_struct.run_meshlab.switch = 0;
geo_struct.run_meshlab.bundle_file = ''; %C:\Users\jkissi\Down loads\research\SfM\examples\wall4\wall_rectified_matlab_distortion\Movie Frames from MVI_0001\dense.nvm.cmvs\00\bundle.rd.out
geo_struct.run_meshlab.list_file = ''; %C:\Users\jkissi\Downloads\research\SfM\examples\wall4\wall_rectified_matlab_distortion\Movie Frames from MVI_0001\dense.nvm.cmvs\00\list.txt
geo_struct.run_meshlab.mlx_script_file = 'first_mlx.mlx';
geo_struct.run_meshlab.dense_mesh = ''; %'C:\Users\jkissi\Downloads\research\SfM\examples\wall4\wall_rectified_matlab_distortion\Movie Frames from MVI_0001\dense.0.ply';

%--------------------------------------------------------------------------
% Read in file
%--------------------------------------------------------------------------
geo_struct.point_cloud__read.point_cloud_file = [pathstr, filesep 'input' filesep 'data' filesep 'dense_poisson_oc_6.ply'];

geo_struct.point_cloud__read.calculation__get_mahal_dist.switch = 1;

%--------------------------------------------------------------------------
% Point Space
%--------------------------------------------------------------------------
geo_struct.point_space__create.switch = 1;
% the 6 faces of the cube, each is defined by connecting 4 of the
% available vertices:
geo_struct.point_space__create.mat__cube_face_connect = [1 2 3 4; 4 3 5 6; 6 7 8 5;
                                                         1 2 8 7; 6 7 1 4; 2 3 5 8];

geo_struct.point_cloud__get_coords.switch = 1;

geo_struct.point_space__search.switch = 1;

%--------------------------------------------------------------------------
% Search Space
%--------------------------------------------------------------------------

if(any(strcmp('var__search_cube_size_factor', option_fields)))
    geo_struct.var__search_cube_size_factor = struct__options.var__search_cube_size_factor;
else
    geo_struct.var__search_cube_size_factor = 0.01;
end 

%--------------------------------------------------------------------------
% Best Fit Plane 
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Segementation
%--------------------------------------------------------------------------
geo_struct.segmentation__region_growing.switch = 1;


if(any(strcmp('normal_threshold', option_fields)))
    geo_struct.normal_threshold = struct__options.normal_threshold;
else
    geo_struct.normal_threshold = 5;
end 


if(any(strcmp('region_growing_k', option_fields)))
    geo_struct.region_growing_k = struct__options.region_growing_k;
else
    geo_struct.region_growing_k = 40;
end 

if(any(strcmp('r_thresh_factor', option_fields)))
    geo_struct.r_thresh_factor = struct__options.r_thresh_factor;
else
    geo_struct.r_thresh_factor = 0.01;
end 

geo_struct.segmentation__generate_region_plane.switch = 1;

geo_struct.segmentation__region_plane_draw.switch = 1;
geo_struct.segmentation__region_plane_draw.invisible = 1;

%geo_struct.segmentation__region_plane_draw.edge_alpha = 0.4;
if(any(strcmp('edge_alpha', option_fields)))
    geo_struct.edge_alpha = struct__options.edge_alpha;
else
    geo_struct.edge_alpha = 0.1;
end 

if(any(strcmp('face_alpha', option_fields)))
    geo_struct.face_alpha = struct__options.face_alpha;
else
    geo_struct.face_alpha = 0.1;
end 

geo_struct.segmentation__region_plane_draw.remove_bf_planes = 0;

if(any(strcmp('phi_tolerance', option_fields)))
    geo_struct.phi_tolerance = struct__options.phi_tolerance;
else
    geo_struct.phi_tolerance = 1;
end 


%--------------------------------------------------------------------------
% Orientations
%--------------------------------------------------------------------------
geo_struct.calculation__strike_and_dip.switch = 1;

%--------------------------------------------------------------------------
% Time Variables
%--------------------------------------------------------------------------
geo_struct.timings.switch = 1; 

%--------------------------------------------------------------------------
% Data Collection (?)
%--------------------------------------------------------------------------
geo_struct.stats.switch = 1; 
geo_struct.stats.textfile_ext = '.txt';
geo_struct.stats.figure_ext = '.fig';
geo_struct.stats.plot_ext = '.fig';
geo_struct.stats.experiment = struct__options.experiment;
geo_struct.stats.parent_folder = struct__options.parent_folder;


% Ground truth data
geo_struct.stats.ground_truth.struct__RP(1).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 31 W';
geo_struct.stats.ground_truth.struct__RP(1).strike.degrees(1).data = 87;
geo_struct.stats.ground_truth.struct__RP(1).strike.radians(1).data = 1.5205;
geo_struct.stats.ground_truth.struct__RP(1).dip_angle.degrees(1).data = 89;
geo_struct.stats.ground_truth.struct__RP(1).dip_angle.radians(1).data = 1.5555;
geo_struct.stats.ground_truth.struct__RP(1).dip_direction.degrees(1).data = 177;
geo_struct.stats.ground_truth.struct__RP(1).dip_direction.radians(1).data = 3.0935;


geo_struct.stats.ground_truth.struct__RP(2).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 31 W';
geo_struct.stats.ground_truth.struct__RP(2).strike.degrees(1).data = 4;
geo_struct.stats.ground_truth.struct__RP(2).strike.radians(1).data = 0.0699;
geo_struct.stats.ground_truth.struct__RP(2).dip_angle.degrees(1).data = 89;
geo_struct.stats.ground_truth.struct__RP(2).dip_angle.radians(1).data = 1.5555;
geo_struct.stats.ground_truth.struct__RP(2).dip_direction.degrees(1).data = 94;
geo_struct.stats.ground_truth.struct__RP(2).dip_direction.radians(1).data = 1.6429;


geo_struct.stats.ground_truth.struct__RP(3).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 31 W';
geo_struct.stats.ground_truth.struct__RP(3).strike.degrees(1).data = 339;
geo_struct.stats.ground_truth.struct__RP(3).strike.radians(1).data = 5.9248;
geo_struct.stats.ground_truth.struct__RP(3).dip_angle.degrees(1).data = 87;
geo_struct.stats.ground_truth.struct__RP(3).dip_angle.radians(1).data = 1.5205;
geo_struct.stats.ground_truth.struct__RP(3).dip_direction.degrees(1).data = 69;
geo_struct.stats.ground_truth.struct__RP(3).dip_direction.radians(1).data = 1.2059;


geo_struct.stats.ground_truth.struct__RP(4).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 30 W';
geo_struct.stats.ground_truth.struct__RP(4).strike.degrees(1).data = 102;
geo_struct.stats.ground_truth.struct__RP(4).strike.radians(1).data = 1.7827;
geo_struct.stats.ground_truth.struct__RP(4).dip_angle.degrees(1).data = 86;
geo_struct.stats.ground_truth.struct__RP(4).dip_angle.radians(1).data = 1.5030;
geo_struct.stats.ground_truth.struct__RP(4).dip_direction.degrees(1).data = 192;
geo_struct.stats.ground_truth.struct__RP(4).dip_direction.radians(1).data = 3.3556;


geo_struct.stats.ground_truth.struct__RP(5).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 30 W';
geo_struct.stats.ground_truth.struct__RP(5).strike.degrees(1).data = 350;
geo_struct.stats.ground_truth.struct__RP(5).strike.radians(1).data = 6.1170;
geo_struct.stats.ground_truth.struct__RP(5).dip_angle.degrees(1).data = 89;
geo_struct.stats.ground_truth.struct__RP(5).dip_angle.radians(1).data = 1.5555;
geo_struct.stats.ground_truth.struct__RP(5).dip_direction.degrees(1).data = 80;
geo_struct.stats.ground_truth.struct__RP(5).dip_direction.radians(1).data = 1.3982;


geo_struct.stats.ground_truth.struct__RP(6).gps = '43^{\circ} 0^{\prime} 20 N, 81^{\circ} 16^{\prime} 30 W';
geo_struct.stats.ground_truth.struct__RP(6).strike.degrees(1).data = 359;
geo_struct.stats.ground_truth.struct__RP(6).strike.radians(1).data = 6.2743;
geo_struct.stats.ground_truth.struct__RP(6).dip_angle.degrees(1).data = 40;
geo_struct.stats.ground_truth.struct__RP(6).dip_angle.radians(1).data = 0.6991;
geo_struct.stats.ground_truth.struct__RP(6).dip_direction.degrees(1).data = 89;
geo_struct.stats.ground_truth.struct__RP(6).dip_direction.radians(1).data = 1.5555;



%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function newGeo_Struct.m terminating.');
return;
end 
