%% GeoStructure MATLAB/SfM software pipeline 
% Framework to run experiments on the using matlab and VSfM to create, read
% and postprocess pointcloud data for Geological analysis 

% The program MUST be run from INSIDE the GeoStructure folder otherwise the
% program will make erroneous output folders to place the output graphs and
% textfile in. 


struct__options = struct();
struct__stats = struct();
struct__options.var__search_cube_size_factor = 0.008;
struct__options.normal_threshold = 6; % theta
%struct__options.region_growing_k = 'var'; %40 %var string is for file titles only!
struct__options.region_growing_k = 10;
struct__options.r_thresh_factor = 0.1; % 10% offset from seed plane % psi

%for the golden section search
struct__options.phi_tolerance = 0.01; % 0.01; % tolerance value for phi 

struct__options.face_alpha = 0.2;
struct__options.edge_alpha = 0.2;

% boolean switch to turn on/off loop behaviour
% if this is on, the program will only replot the data and not go through
% the whole process again
struct__stats.replot_only = 0;
struct__stats.replot_zeta = 0;
struct__stats.replot_theta = 0;
struct__stats.replot_k = 0;
struct__stats.replot_psi = 0;
if(~struct__stats.replot_only)
% if one of these options is turned on then the filename will have 'var' in
% the title instead of the figure used and this quantity will be the one 
% that varies
struct__options.bool__search_cube_size_factor_on = 0;
struct__options.bool__normal_threshold_on = 0;
struct__options.bool__psi_threshold_on = 0;
struct__options.bool__region_growing_k_on = 0;
number_of_runs = 1;
struct__stats.current_time = datestr(now, 'yyyymmdd_HHMMSS');
struct__stats.experiment = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
struct__options.experiment = struct__stats.experiment;


if(struct__options.bool__search_cube_size_factor_on)
    struct__options.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', 'var','_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
    struct__stats.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', 'var','_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
elseif(struct__options.bool__normal_threshold_on)
    struct__options.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_','var','_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
    struct__stats.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_','var','_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];    
    %struct__stats.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
elseif(struct__options.bool__psi_threshold_on)
    struct__options.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_','var'];
    struct__stats.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_','var'];
elseif(struct__options.bool__region_growing_k_on)
    struct__options.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_','var','_psi_',num2str(struct__options.r_thresh_factor)];
    struct__stats.parent_folder = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_','var','_psi_',num2str(struct__options.r_thresh_factor)];
else
    struct__options.parent_folder = struct__options.experiment;
    struct__stats.parent_folder = struct__options.experiment;
end 

global geo_struct;
[ geo_struct ] = newGeo_Struct(struct__options);   
%[ geo_struct ] = newGeoStruct();   

 if(~exist([geo_struct.output_folder, struct__stats.parent_folder], 'dir'))
    mkdir(geo_struct.output_folder, struct__stats.parent_folder);
    [ text_file ] = statistics__write_textfile_header(struct__stats);   
end
end_point = [];
initial = [];
for r = 1:number_of_runs
    struct__stats.run = r;
    
    if(struct__options.bool__region_growing_k_on)
        end_point = 20;
        initial = 1:end_point/number_of_runs:end_point;
        %struct__options.region_growing_k = 0:end_point/number_of_runs:end_point; % calculation for all run figures --> 0:end_point/number_of_runs:end_point
        struct__options.region_growing_k = initial(r); % calculation for all run figures --> 0:end_point/number_of_runs:end_point
        struct__stats.experiment = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];    
        struct__options.experiment = struct__stats.experiment;
    end
    
    if(struct__options.bool__normal_threshold_on)
        end_point = 40;
        initial = 0:end_point/number_of_runs:end_point;
        struct__options.normal_threshold = initial(r);
        struct__stats.experiment = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
        struct__options.experiment = struct__stats.experiment;
    end
    
    if(struct__options.bool__psi_threshold_on)
        end_point = 1;
        initial = 0.01:end_point/number_of_runs:end_point;
        struct__options.r_thresh_factor = initial(r);
        struct__stats.experiment = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
        struct__options.experiment = struct__stats.experiment;
    end
    
    if(struct__options.bool__search_cube_size_factor_on)
        end_point = 0.1;
        initial = 0.01:end_point/number_of_runs:end_point;
        struct__options.var__search_cube_size_factor = initial(r);
        struct__stats.experiment = [struct__stats.current_time, '_GeoStruct__scs_', num2str(struct__options.var__search_cube_size_factor),'_theta_',num2str(struct__options.normal_threshold),'_rgk_',num2str(struct__options.region_growing_k),'_psi_',num2str(struct__options.r_thresh_factor)];
        struct__options.experiment = struct__stats.experiment;
    end
    [ geo_struct ] = newGeo_Struct(struct__options);          
    [ struct__planes, orientations ] = GeoStructure(); 

    [ text_file ] = statistics__write_textfile(struct__stats); 

end 
end
if(struct__stats.replot_only)
    current_path = mfilename('fullpath');
    [pathstr, name, ext] = fileparts(current_path);
    output_folder = [pathstr, filesep, 'output', filesep];
    struct__stats.output_folder = output_folder;
    struct__stats.plot_ext = '.fig';
    
    % you have to manually input the files that you want to re-plot
    folder_name{1} = '20160804_184815_GeoStruct__scs_var_theta_10_rgk_15_psi_0.1'; % scs = 1   
    folder_name{2} = '20160804_190630_GeoStruct__scs_0.01_theta_var_rgk_15_psi_0.1'; % theta = 2
    folder_name{3} = '20160804_202540_GeoStruct__scs_0.01_theta_10_rgk_15_psi_var'; % psi = 3    
    folder_name{4} = '20160804_231604_GeoStruct__scs_0.01_theta_10_rgk_var_psi_0.1'; % k = 4    

    files = {};

    for g = 1:length(folder_name)
        save_file = [output_folder, folder_name{g}, filesep, folder_name{g}, '.txt'];
        files{end + 1} = save_file;   
    end 
else
%get a list of files
    save_file = [geo_struct.output_folder, struct__stats.parent_folder];
    file_list = dir(fullfile(save_file, '*.txt'));
    file_names = file_list.name;
    files = [save_file, filesep, file_names];
    ext = geo_struct.stats.plot_ext;
end

scs = [];
normal_threshold = [];
region_growing_k = [];
run = [];
psi = [];
GS_TElapsed = [];
RG_TElapsed = [];
%for i = 1:numel(files)
    % read data file
    fname = fullfile(files);
    fid = fopen(fname);
    data = textscan(fid, '%f %f %f %f %f %f %f %f %f', 'delimiter','|', 'HeaderLines', 3);
    fclose(fid);

    % load data from files into matlab structures 
    run.data = data{1};
    GS_TElapsed.data = data{3};
    RG_TElapsed.data = data{5};
    region_growing_k.data = data{6};
    normal_threshold.data = data{7};
    scs.data = data{8};  
    psi.data = data{9};  
    
%     run(i).data = data{1};
%     GS_TElapsed(i).data = data{3};
%     RG_TElapsed(i).data = data{5};
%     region_growing_k(i).data = data{6};
%     normal_threshold(i).data = data{7};
%     scs(i).data = data{8};  
%     psi(i).data = data{9};  
%end


struct__stats.quality_score_switch = 0;
struct__stats.xlim_switch = 0;
struct__stats.ylim_switch = 0;
%struct__stats.xlim_var
%struct__stats.ylim_var = [0, 1.1];
struct__stats.run = run;
struct__stats.GS_TElapsed = GS_TElapsed;
struct__stats.RG_TElapsed = RG_TElapsed;
struct__stats.region_growing_k = region_growing_k; % k
struct__stats.normal_threshold = normal_threshold; % theta
struct__stats.scs = scs; % zeta
struct__stats.psi = psi;


for i = 1:length(run.data)

    %% knn region growing experiments
  
    struct__stats.plotname = '__knn_value_v_total_time';
    struct__stats.y_label.data = 'Total Time(s)';
    struct__stats.x_label.data = 'k';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.region_growing_k.data;
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(4).data;
    %struct__stats.y_array(1).data = struct__stats.region_growing_k(4).data; 
    struct__stats.legend_switch.on = 0;
    if(struct__stats.replot_only)
        struct__stats.parent_folder = folder_name{4};
    end
    struct__stats.experiment = struct__stats.parent_folder; 
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);

    
    struct__stats.plotname = '__knn_value_v_rg_time';
    struct__stats.y_label.data = 'RG Convergence(s)';
    struct__stats.x_label.data = 'k';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.region_growing_k.data;
    %struct__stats.x_array(1).data = struct__stats.RG_TElapsed(4).data;
    %struct__stats.y_array(1).data = struct__stats.region_growing_k(4).data;        
    struct__stats.legend_switch.on = 0;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);
    
    
    %combined one
    struct__stats.plotname = '__knn_value_v_time';
    struct__stats.y_label.data = 'Time Elapsed(s)';
    struct__stats.x_label.data = 'k';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.region_growing_k.data;
    struct__stats.y_array(2).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(2).data = struct__stats.region_growing_k.data; 
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(4).data;
    %struct__stats.y_array(1).data = struct__stats.region_growing_k(4).data;
    %struct__stats.x_array(2).data = struct__stats.RG_TElapsed(4).data;
    %struct__stats.y_array(2).data = struct__stats.region_growing_k(4).data;      
    struct__stats.legend_switch.on = 1;
    %struct__stats.legend(1).data = 'line1';
    struct__stats.legend(1).data = 'Total Time';
    struct__stats.legend(2).data = 'RG Convergence';    
    
    [struct__stats] = statistics__generate_plot(struct__stats);
    
    %% search cube size experiments
    
    struct__stats.plotname = '__scs_v_total_time';
    struct__stats.y_label.data = 'Total Time(s)';
    struct__stats.x_label.data = '\zeta Proportion';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.scs.data;  
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(1).data;
    %struct__stats.y_array(1).data = struct__stats.scs(1).data;        
    struct__stats.legend_switch.on = 0;
    if(struct__stats.replot_only)
        struct__stats.parent_folder = folder_name{1};
    end
    struct__stats.experiment = struct__stats.parent_folder; 
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);

    
    struct__stats.plotname = '__scs_v_rg_time';
    struct__stats.y_label.data = 'RG Convergence(s)';
    struct__stats.x_label.data = '\zeta Proportion';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.scs.data;
    %struct__stats.x_array(1).data = struct__stats.RG_TElapsed(1).data;
    %struct__stats.y_array(1).data = struct__stats.scs(1).data;  
    struct__stats.legend_switch.on = 0;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);    
    
    %combined one
    struct__stats.plotname = '__scs_v_time';
    struct__stats.y_label.data = 'Time Elapsed(s)';
    struct__stats.x_label.data = '\zeta Proportion';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.scs.data;
    struct__stats.y_array(2).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(2).data = struct__stats.scs.data;
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(1).data;
    %struct__stats.y_array(1).data = struct__stats.scs(1).data;
    %struct__stats.x_array(2).data = struct__stats.RG_TElapsed(1).data;
    %struct__stats.y_array(2).data = struct__stats.scs(1).data;  
    struct__stats.legend_switch.on = 1;
    %struct__stats.legend(1).data = 'line1';
    struct__stats.legend(1).data = 'Total Time';
    struct__stats.legend(2).data = 'RG Convergence';    
    
    [struct__stats] = statistics__generate_plot(struct__stats); 
    
    %% normal angle threshold experiments
    
    struct__stats.plotname = '__theta_v_total_time';
    struct__stats.y_label.data = 'Total Time(s)';
    struct__stats.x_label.data = '\theta Angle Threshold';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.normal_threshold.data;  
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(2).data;
    %struct__stats.y_array(1).data = struct__stats.normal_threshold(2).data;      
    struct__stats.legend_switch.on = 0;
    if(struct__stats.replot_only)
        struct__stats.parent_folder = folder_name{2};
    end
    struct__stats.experiment = struct__stats.parent_folder;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);

    
    struct__stats.plotname = '__theta_v_rg_time';
    struct__stats.y_label.data = 'RG Convergence(s)';
    struct__stats.x_label.data = '\theta Angle Threshold';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.normal_threshold.data;  
    %struct__stats.x_array(1).data = struct__stats.RG_TElapsed(2).data;
    %struct__stats.y_array(1).data = struct__stats.normal_threshold(2).data;
    struct__stats.legend_switch.on = 0;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);       
    
    %combined one
    struct__stats.plotname = '__theta_v_time';
    struct__stats.y_label.data = 'Time Elapsed(s)';
    struct__stats.x_label.data = '\theta Angle Threshold';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.normal_threshold.data;
    struct__stats.y_array(2).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(2).data = struct__stats.normal_threshold.data; 
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(2).data;
    %struct__stats.y_array(1).data = struct__stats.normal_threshold(2).data;
    %struct__stats.x_array(2).data = struct__stats.RG_TElapsed(2).data;
    %struct__stats.y_array(2).data = struct__stats.normal_threshold(2).data;     
    struct__stats.legend_switch.on = 1;
    %struct__stats.legend(1).data = 'line1';
    struct__stats.legend(1).data = 'Total Time';
    struct__stats.legend(2).data = 'RG Convergence';

    [struct__stats] = statistics__generate_plot(struct__stats); 
    
    
    %% psi offset threshold plots 
    
    struct__stats.plotname = '__psi_v_total_time';
    struct__stats.y_label.data = 'Total Time(s)';
    struct__stats.x_label.data = '\psi Offset Threshold';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.psi.data;    
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(3).data;
    %struct__stats.y_array(1).data = struct__stats.psi(3).data;
    struct__stats.legend_switch.on = 0;
    if(struct__stats.replot_only)
        struct__stats.parent_folder = folder_name{3};
    end
    struct__stats.experiment = struct__stats.parent_folder;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);

    
    struct__stats.plotname = '__psi_v_rg_time';
    struct__stats.y_label.data = 'RG Convergence(s)';
    struct__stats.x_label.data = '\psi Offset Threshold';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.psi.data;  
    %struct__stats.x_array(1).data = struct__stats.RG_TElapsed(3).data;
    %struct__stats.y_array(1).data = struct__stats.psi(3).data;    
    struct__stats.legend_switch.on = 0;
    %struct__stats.legend(1).data = 'line1';
    
    [struct__stats] = statistics__generate_plot(struct__stats);     
    
    % combined one
    struct__stats.plotname = '__psi_v_time';
    struct__stats.x_label.data = '\psi Offset Threshold';
    struct__stats.y_label.data = 'Time Elapsed(s)';
    struct__stats.print_filetype = '-dpng';
    struct__stats.y_array(1).data = struct__stats.GS_TElapsed.data;
    struct__stats.x_array(1).data = struct__stats.psi.data;
    struct__stats.y_array(2).data = struct__stats.RG_TElapsed.data;
    struct__stats.x_array(2).data = struct__stats.psi.data;
    %struct__stats.x_array(1).data = struct__stats.GS_TElapsed(3).data;
    %struct__stats.y_array(1).data = struct__stats.psi(3).data;
    %struct__stats.x_array(2).data = struct__stats.RG_TElapsed(3).data;
    %struct__stats.y_array(2).data = struct__stats.psi(3).data;
    struct__stats.legend_switch.on = 1;
    struct__stats.legend(1).data = 'Total Time';
    struct__stats.legend(2).data = 'RG Convergence';
    
    [struct__stats] = statistics__generate_plot(struct__stats);    
    
    
    
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
% Final thing - add the data output to the matlab path
if(struct__stats.replot_only)
    addpath(genpath([struct__stats.output_folder, struct__stats.parent_folder]));
else
    addpath(genpath([geo_struct.output_folder, struct__stats.parent_folder]));
end
% End of experimental run. Close all figures generated.
close all;
% End of expereimental run. Run startup script. 
startup;

disp('Execution terminating. Experiment(s) complete.');





