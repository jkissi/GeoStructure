%%
% This is run when matlab starts up from within the folder of startup.m (which it should)
% we add all the paths neccessary to find the data production functions, toolbox functions etc

% add script base path
% (we run matlab ALWAYS from within the GeoStruct
% - so we can be sure of the paths to add, even if we move the
% caa_production folder around)


%global caa_production_path;
%caa_production_path = [pwd, '\'];
global geostruct_path;
geostruct_path = [ pwd, '\'];

% base path to the matlab scripts we are using
addpath(geostruct_path);

% genpath adds sub folders
% Data input and output folders 
addpath(genpath([geostruct_path, 'input']));

addpath(genpath([geostruct_path, 'output']));


% image processing 
addpath(genpath([geostruct_path, 'preprocessing']));


% Point cloud input  
addpath(genpath([geostruct_path, 'point_cloud']));


% Point cloud processing 
addpath(genpath([geostruct_path, 'point_space']));

addpath(genpath([geostruct_path, 'search_space']));

addpath(genpath([geostruct_path, 'best_fit_plane']));

addpath(genpath([geostruct_path, 'segmentation']));


% Orientation measurement 
addpath(genpath([geostruct_path, 'calculation']));


% Data evaluation
addpath(genpath([geostruct_path, 'statistics']));


% Misc and HCI interaction
addpath(genpath([geostruct_path, 'ancillary']));

