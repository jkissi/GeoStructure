% -------------------------------------------------------------------------
% ancillary__click_callback function
% -------------------------------------------------------------------------
function [] = ancillary__click_callback(objectHandle, eventData)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Holds the data collected from the experimental run in the large scale
% planes so that when the user clicks on the large planes in the figure,
% the various stored data is displayed in a dialog box
% -------------------------------------------------------------------------
% 1 Region
% 2 Strike_rad
% 3 Strike_deg
% 4 Dip_rad
% 5 Dip_deg
% 6 DDir_rad
% 7 DDir_deg
% 8 experiment
% 9 -
z__st_deg = [];
z__st_rad = [];
z__da_deg = [];
z__da_rad = [];
z__dd_deg = [];
z__dd_rad = [];
st_deg = [];
st_rad = [];
da_deg = [];
da_rad = [];
dd_deg = [];
dd_rad = [];
array__z_total_deg = [];
array__z_total_rad = [];
special_props  = get(objectHandle,'UserData');
measurements = special_props.region;
struct__RP = special_props.struct__RP;
experiment = special_props.experiment;
vars = special_props.vars;
output_folder = special_props.output_folder;
parent_folder = special_props.parent_folder;

message1 = sprintf('Region: %2.2f , Strike_rad: %2.2f , Dip_rad: %2.2f, DDir_rad: %2.2f\n', measurements(1) , measurements(2), measurements(4), measurements(6));
message2 = sprintf('Region: %2.2f , Strike_deg: %2.2f , Dip_deg: %2.2f, DDir_deg: %2.2f', measurements(1) , measurements(3), measurements(5), measurements(7));
helpdlg([message1, message2]);
% %radians = degrees * 3.1459/180;

inputPromptMessage = sprintf('You clicked a region, do you want to record the information?');
button__rp_input_save = questdlg(inputPromptMessage, 'Save information?', 'Yes', 'No', 'No');
%button__rp_input_complete = 'No';
if(strcmp(button__rp_input_save, 'Yes'))
    
    %prompt = {'RP number:', 'scs:', 'k:', 'theta:', 'psi:', 'Does this region exist?'};
    prompt = {'RP number:', 'experiment (Add if creating for plot with NO clickable regions):', ...
        'scs (Add for all non-existant regions):', 'k (Add for all non-existant regions):', ...
        '\theta (Add for all non-existant regions):', '\psi (Add for all non-existant regions):',...
        'Does this region exist?'};
    name = ['fracture orientation info for: ', experiment];
    defaultans = {'', '', '', '', '', '', 'Yes'};
    options.Interpreter = 'tex';
    options.Resize = 'on';
    button__RP = inputdlg(prompt, name, [1, 80], defaultans, options);
    region_number = str2num(button__RP{1});
    region_exist = button__RP{7};
    if(strcmp(region_exist, 'No'))
        experimentPromptMessage = sprintf('Manually add experiment? (Do this when creating entry for plot with NO clickable regions)');
        button__add_experiment = questdlg(experimentPromptMessage, 'experiment?', 'Yes', 'No', 'No');
        if(strcmp(button__add_experiment, 'Yes'))
            experiment = button__RP{2};
        end
        scs = str2num(button__RP{3});
        k = str2num(button__RP{4});
        theta = str2num(button__RP{5});
        psi = str2num(button__RP{6});
        vars = [scs, k, theta, psi];
        % do normalisation
        z__st_deg = 1;
        z__st_rad = 1;
        z__da_deg = 1;
        z__da_rad = 1;
        z__dd_deg = 1;
        z__dd_rad = 1;
        
        struct__RP(region_number).strike.degrees(2).data = NaN;
        struct__RP(region_number).strike.radians(2).data = NaN;
        struct__RP(region_number).dip_angle.degrees(2).data = NaN;
        struct__RP(region_number).dip_angle.radians(2).data = NaN;
        struct__RP(region_number).dip_direction.degrees(2).data = NaN;
        struct__RP(region_number).dip_direction.radians(2).data = NaN;
    else
        % Calculate the Quality metric score (z)
        
        st_deg(1) = struct__RP(region_number).strike.degrees(1).data;
        st_rad(1) = struct__RP(region_number).strike.radians(1).data;
        da_deg(1) = struct__RP(region_number).dip_angle.degrees(1).data;
        da_rad(1) = struct__RP(region_number).dip_angle.radians(1).data;
        dd_deg(1) = struct__RP(region_number).dip_direction.degrees(1).data;
        dd_rad(1) = struct__RP(region_number).dip_direction.radians(1).data;
        
        % add saved measurements
        st_deg(2) = measurements(3);
        st_rad(2) = measurements(2);
        da_deg(2) = measurements(5);
        da_rad(2) = measurements(4);
        dd_deg(2) = measurements(7);
        dd_rad(2) = measurements(6);
        
        % z for strike, dip, dip direction measurements
        % do normalisation
        z__st_deg = (sqrt((st_deg(1) - st_deg(2))^2) - 0)/(360 - 0);
        z__st_rad = (sqrt((st_rad(1) - st_rad(2))^2) - 0)/(6.2832 - 0);
        z__da_deg = (sqrt((da_deg(1) - da_deg(2))^2) - 0)/(90 - 0);
        z__da_rad = (sqrt((da_rad(1) - da_rad(2))^2) - 0)/(1.5708 - 0);
        z__dd_deg = (sqrt((dd_deg(1) - dd_deg(2))^2) - 0)/(360 - 0);
        z__dd_rad = (sqrt((dd_rad(1) - dd_rad(2))^2) - 0)/(6.2832 - 0);
        
        struct__RP(region_number).strike.degrees(2).data = st_deg(2);
        struct__RP(region_number).strike.radians(2).data = st_rad(2);
        struct__RP(region_number).dip_angle.degrees(2).data = da_deg(2);
        struct__RP(region_number).dip_angle.radians(2).data = da_rad(2);
        struct__RP(region_number).dip_direction.degrees(2).data = dd_deg(2);
        struct__RP(region_number).dip_direction.radians(2).data = dd_rad(2);
    end
    % z for the Regions (R_i)
    struct__RP(region_number).strike.degrees(3).data = z__st_deg;
    struct__RP(region_number).strike.radians(3).data = z__st_rad;
    struct__RP(region_number).dip_angle.degrees(3).data = z__da_deg;
    struct__RP(region_number).dip_angle.radians(3).data = z__da_rad;
    struct__RP(region_number).dip_direction.degrees(3).data = z__dd_deg;
    struct__RP(region_number).dip_direction.radians(3).data = z__dd_rad;
    
    
    % do normalisation for entire plane
    z__RP_norm_deg = (sqrt((z__st_deg + z__da_deg + z__dd_deg)^2) - 0)/(3 - 0);
    z__RP_norm_rad = (sqrt((z__st_rad + z__da_rad + z__dd_rad)^2) - 0)/(3 - 0);
    
    struct__RP(region_number).z__RP_norm_deg = z__RP_norm_deg;
    struct__RP(region_number).z__RP_norm_rad = z__RP_norm_rad;
    
    
    %if(strcmp(button__rp_input_complete, 'Yes'))
    struct__stats.output_folder = output_folder;
    struct__stats.parent_folder = parent_folder;
    struct__stats.experiment = experiment;
    struct__stats.struct__RP = struct__RP;
    %save_file = [struct__stats.output_folder, struct__stats.parent_folder,'\', struct__stats.experiment, '_final_scores', '.txt'];
    save_file = [struct__stats.output_folder, struct__stats.parent_folder filesep struct__stats.experiment, '_final_scores', '.txt'];
    struct__stats.save_file = save_file;
    struct__stats.vars = vars;
    struct__stats.region_number = region_number;
    if(~exist(save_file, 'file'))
        [ text_file ] = statistics__write_textfile_header_normalisation(struct__stats);
    end
    struct__stats.calculate_final_score_switch = 0;
    [ text_file ] = statistics__write_textfile_normalisation(struct__stats);
    %end
else
    disp('Not saving any plane information!!');
end


normMessage = sprintf(['Would you like to derive the final accuracy score? ', experiment,'?']);
button__rp_input_complete = questdlg(normMessage, 'finish loop?', 'Yes', 'No', 'No');
if(strcmp(button__rp_input_complete, 'Exit'))
    disp('Exiting loop. No further data to be saved');
    %break;
elseif(strcmp(button__rp_input_complete, 'Yes'))
    %get a list of files
    %BASE_DIR = [geo_struct.output_folder, struct__stats.parent_folder];
    %save_file = [output_folder, parent_folder,'\', parent_folder, '_final_scores', '.txt'];
    save_file = [output_folder, parent_folder filesep experiment, '_final_scores', '.txt'];
    %save_file = [output_folder, parent_folder,'\', '*', '_final_scores', '.txt'];
    files = dir(fullfile(save_file));
    files = {files.name};
    
    scs = [];
    theta = [];
    k = [];
    run = [];
    psi = [];
    
    for i = 1:numel(files)
        % read data file
        fname = fullfile(files{i});
        fid = fopen(fname);
        data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'delimiter','|', 'HeaderLines',3);
        fclose(fid);
        
        % load data from files into matlab structures
        RP(i).data = data{1};
        scs(i).data = data{2};
        k(i).data = data{3};
        theta(i).data = data{4};
        psi(i).data = data{5};
        st_1_deg(i).data = data{6};
        st_2_deg(i).data = data{7};
        st_3_deg(i).data = data{8};
        da_1_deg(i).data = data{9};
        da_2_deg(i).data = data{10};
        da_3_deg(i).data = data{11};
        dd_1_deg(i).data = data{12};
        dd_2_deg(i).data = data{13};
        dd_3_deg(i).data = data{14};
        st_1_rad(i).data = data{15};
        st_2_rad(i).data = data{16};
        st_3_rad(i).data = data{17};
        da_1_rad(i).data = data{18};
        da_2_rad(i).data = data{19};
        da_3_rad(i).data = data{20};
        dd_1_rad(i).data = data{21};
        dd_2_rad(i).data = data{22};
        dd_3_rad(i).data = data{23};
        RP_norm_deg(i).data = data{24};
        RP_norm_rad(i).data = data{25};
        z__Total_deg(i).data = data{26};
        z__Total_rad(i).data = data{27};
    end
    
    % Calculate the Total Quality Metric score (z)
    normalised_base = length(RP_norm_deg.data);
    z__Total_deg = (sqrt(sum(RP_norm_deg.data)^2) - 0)/(normalised_base - 0);
    normalised_base = length(RP_norm_rad.data);
    z__Total_rad = (sqrt(sum(RP_norm_rad.data)^2) - 0)/(normalised_base - 0);
    
    z__Total_repeat_length = length(RP.data);
    z__Total_deg = repmat(z__Total_deg, z__Total_repeat_length, 1);
    z__Total_rad = repmat(z__Total_rad, z__Total_repeat_length, 1);
    
    struct__stats.run_vars = [RP.data, scs.data, k.data, theta.data, psi.data,...
        st_1_deg.data, st_2_deg.data, st_3_deg.data,...
        da_1_deg.data, da_2_deg.data, da_3_deg.data,...
        dd_1_deg.data, dd_2_deg.data, dd_3_deg.data,...
        st_1_rad.data, st_2_rad.data, st_3_rad.data,...
        da_1_rad.data, da_2_rad.data, da_3_rad.data,...
        dd_1_rad.data, dd_2_rad.data, dd_3_rad.data,...
        RP_norm_deg.data,  RP_norm_rad.data,...
        z__Total_deg, z__Total_rad];
    
    struct__stats.save_file = save_file;
    struct__stats.calculate_final_score_switch = 1;
    [ text_file ] = statistics__write_textfile_normalisation(struct__stats);
end

% save_file = [struct__stats.output_folder, struct__stats.parent_folder,'\', struct__stats.parent_folder, '_final_scores', '.txt'];
% struct__stats.save_file = save_file;
% struct__stats.vars = vars;
% struct__stats.region_number = region_number;
% if(~exist(save_file, 'file'))
%     [ text_file ] = statistics__write_textfile_header_normalisation(struct__stats);
% end

%% aggregate the files
%%

aggregateMessage = sprintf(['Would you like ot aggregate the files? ', experiment,'?']);
button__aggregate = questdlg(aggregateMessage, 'aggregate?', 'Yes', 'No', 'No');
if(strcmp(button__aggregate, 'No'))
    disp('Exiting loop. No aggregation working...');
    %break;
elseif(strcmp(button__aggregate, 'Yes'))
    %get a list of files
    load_file = [output_folder, parent_folder filesep '*', '_final_scores', '.txt'];
    files = dir(fullfile(load_file));
    files = {files.name};
    disp(['The files are: ', files, '. smiley face!']);
    % scs = [];
    % normal_threshold = [];
    % region_growing_k = [];
    % run = [];
    % psi = [];
    save_file = [output_folder, parent_folder,filesep, parent_folder, '_final_scores', '.txt'];
    struct__stats.save_file = save_file;
    %struct__stats.vars = vars;
    if(~exist(save_file, 'file'))
        [ text_file ] = statistics__write_textfile_header_normalisation(struct__stats);
    end
    for i = 1:numel(files)
        % read data file
        fname = fullfile(files{i});
        fid = fopen(fname);
        data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'delimiter','|', 'HeaderLines',3);
        fclose(fid);
        
        % load data from files into matlab structures
        RP(i).data = data{1};
        scs(i).data = data{2};
        k(i).data = data{3};
        theta(i).data = data{4};
        psi(i).data = data{5};
        st_1_deg(i).data = data{6};
        st_2_deg(i).data = data{7};
        st_3_deg(i).data = data{8};
        da_1_deg(i).data = data{9};
        da_2_deg(i).data = data{10};
        da_3_deg(i).data = data{11};
        dd_1_deg(i).data = data{12};
        dd_2_deg(i).data = data{13};
        dd_3_deg(i).data = data{14};
        st_1_rad(i).data = data{15};
        st_2_rad(i).data = data{16};
        st_3_rad(i).data = data{17};
        da_1_rad(i).data = data{18};
        da_2_rad(i).data = data{19};
        da_3_rad(i).data = data{20};
        dd_1_rad(i).data = data{21};
        dd_2_rad(i).data = data{22};
        dd_3_rad(i).data = data{23};
        RP_norm_deg(i).data = data{24};
        RP_norm_rad(i).data = data{25};
        z__Total_deg(i).data = data{26};
        z__Total_rad(i).data = data{27};
        
        
        
        struct__stats.run_vars = [RP(i).data, scs(i).data, k(i).data, theta(i).data, psi(i).data,...
            st_1_deg(i).data, st_2_deg(i).data, st_3_deg(i).data,...
            da_1_deg(i).data, da_2_deg(i).data, da_3_deg(i).data,...
            dd_1_deg(i).data, dd_2_deg(i).data, dd_3_deg(i).data,...
            st_1_rad(i).data, st_2_rad(i).data, st_3_rad(i).data,...
            da_1_rad(i).data, da_2_rad(i).data, da_3_rad(i).data,...
            dd_1_rad(i).data, dd_2_rad(i).data, dd_3_rad(i).data,...
            RP_norm_deg(i).data,  RP_norm_rad(i).data,...
            z__Total_deg(i).data, z__Total_rad(i).data];
        
        [ text_file ] = statistics__write_textfile_normalisation_agg(struct__stats);
        struct__stats.run_vars = [];
        data = {};
    end
    
    %struct__stats.save_file = save_file;
    %struct__stats.calculate_final_score_switch = 0;
    
end

%% Plot the files
%%
normMessage = sprintf('do you want to plot these files? ');
button__plot_files = questdlg(normMessage, 'finish loop?', 'Yes', 'No', 'No');
if(strcmp(button__plot_files, 'Yes'))
    
    plotprompt = {'if necessary, input the experiment be plotted'};
    name = 'which file to plot?';
    defaultans = {''};
    options.Interpreter = 'tex';
    options.Resize = 'on';
    button__plot_prompt = inputdlg(plotprompt, name, [1, 80], defaultans, options);
    choice = button__plot_prompt{1};
    
    folder_name{1} = '20160804_184815_GeoStruct__scs_var_theta_10_rgk_15_psi_0.1'; % scs = 1   
    folder_name{2} = '20160804_190630_GeoStruct__scs_0.01_theta_var_rgk_15_psi_0.1'; % theta = 2
    folder_name{3} = '20160804_202540_GeoStruct__scs_0.01_theta_10_rgk_15_psi_var'; % psi = 3    
    folder_name{4} = '20160804_231604_GeoStruct__scs_0.01_theta_10_rgk_var_psi_0.1'; % k = 4    
    
    files = {};
    
    for g = 1:length(folder_name)
        save_file = [output_folder, folder_name{g} filesep folder_name{g}, '_final_scores', '.txt'];
        files{end + 1} = save_file;   
    end 
    
    for i = 1:numel(files)
        % read data file
        fname = fullfile(files{i});
        fid = fopen(fname);
        data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'delimiter','|', 'HeaderLines',3);
        fclose(fid);
        
        % load data from files into matlab structures
        struct__stats.quality.RP(i).data = data{1};
        struct__stats.quality.scs(i).data = data{2};
        struct__stats.quality.k(i).data = data{3};
        struct__stats.quality.theta(i).data = data{4};
        struct__stats.quality.psi(i).data = data{5};
        struct__stats.quality.st_1_deg(i).data = data{6};
        struct__stats.quality.st_2_deg(i).data = data{7};
        struct__stats.quality.st_3_deg(i).data = data{8};
        struct__stats.quality.da_1_deg(i).data = data{9};
        struct__stats.quality.da_2_deg(i).data = data{10};
        struct__stats.quality.da_3_deg(i).data = data{11};
        struct__stats.quality.dd_1_deg(i).data = data{12};
        struct__stats.quality.dd_2_deg(i).data = data{13};
        struct__stats.quality.dd_3_deg(i).data = data{14};
        struct__stats.quality.st_1_rad(i).data = data{15};
        struct__stats.quality.st_2_rad(i).data = data{16};
        struct__stats.quality.st_3_rad(i).data = data{17};
        struct__stats.quality.da_1_rad(i).data = data{18};
        struct__stats.quality.da_2_rad(i).data = data{19};
        struct__stats.quality.da_3_rad(i).data = data{20};
        struct__stats.quality.dd_1_rad(i).data = data{21};
        struct__stats.quality.dd_2_rad(i).data = data{22};
        struct__stats.quality.dd_3_rad(i).data = data{23};
        struct__stats.quality.RP_norm_deg(i).data = data{24};
        struct__stats.quality.RP_norm_rad(i).data = data{25};
        struct__stats.quality.z_Total_deg(i).data = data{26};
        struct__stats.quality.z_Total_rad(i).data = data{27};
    end
    
    
    
 % scs = 1   
% theta = 2
 % psi = 3    
 % k = 4      
    %% Options and such...
    %%
    struct__stats.output_folder = output_folder;
    struct__stats.parent_folder = 'GeoStruct__quality_score_data';
    struct__stats.plot_ext = '.fig';
    struct__stats.quality_score_switch = 1;
    struct__stats.xlim_switch = 0;
    struct__stats.ylim_switch = 1;
    %struct__stats.xlim_var
    struct__stats.ylim_var = [0, 1.1];
    %for i = 1:numel(files)     
        %% scs experiments
        %% Overall z
        struct__stats.experiment = '20160804_184815_GeoStruct__scs_var_theta_10_rgk_15_psi_0.1';
        struct__stats.plotname = '__quality_deg_v_scs';
        struct__stats.x_label.data = '\zeta Proportion';
        struct__stats.y_label.data = 'Quality Score (z)';
        %struct__stats.print_filetype = '-dpng';
        struct__stats.x_array(1).data = struct__stats.quality.scs(1).data;
        struct__stats.y_array(1).data = struct__stats.quality.z_Total_deg(1).data;
        struct__stats.legend_switch.on = 0;
        %struct__stats.legend(1).data = 'line1';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        % z per plane
        struct__stats.plotname = '__quality_deg_v_scs_region_planes';
        struct__stats.x_label.data = '\zeta Proportion';
        struct__stats.y_label.data = 'Quality Score (z)';
        % Calcuation
        region_1 = find(struct__stats.quality.RP(1).data == 1);
        region_2 = find(struct__stats.quality.RP(1).data == 2); 
        region_3 = find(struct__stats.quality.RP(1).data == 3);               
        region_4 = find(struct__stats.quality.RP(1).data == 4);      
        region_5 = find(struct__stats.quality.RP(1).data == 5);         
        region_6 = find(struct__stats.quality.RP(1).data == 6);     
              
        struct__stats.x_array(1).data = struct__stats.quality.scs(1).data(region_1);
        struct__stats.y_array(1).data = struct__stats.quality.RP_norm_deg(1).data(region_1);
        struct__stats.x_array(2).data = struct__stats.quality.scs(1).data(region_2);
        struct__stats.y_array(2).data = struct__stats.quality.RP_norm_deg(1).data(region_2);
        struct__stats.x_array(3).data = struct__stats.quality.scs(1).data(region_3);
        struct__stats.y_array(3).data = struct__stats.quality.RP_norm_deg(1).data(region_3);
        struct__stats.x_array(4).data = struct__stats.quality.scs(1).data(region_4);
        struct__stats.y_array(4).data = struct__stats.quality.RP_norm_deg(1).data(region_4);
        struct__stats.x_array(5).data = struct__stats.quality.scs(1).data(region_5);
        struct__stats.y_array(5).data = struct__stats.quality.RP_norm_deg(1).data(region_5);
        struct__stats.x_array(6).data = struct__stats.quality.scs(1).data(region_6);
        struct__stats.y_array(6).data = struct__stats.quality.RP_norm_deg(1).data(region_6);
        
        struct__stats.legend_switch.on = 1;
        
        struct__stats.legend(1).data = 'Region 1';
        struct__stats.legend(2).data = 'Region 2';
        struct__stats.legend(3).data = 'Region 3';
        struct__stats.legend(4).data = 'Region 4';
        struct__stats.legend(5).data = 'Region 5';
        struct__stats.legend(6).data = 'Region 6';
        
        [struct__stats] = statistics__generate_plot(struct__stats);

        
        %% theta experiments
        %%
        struct__stats.experiment = '20160804_190630_GeoStruct__scs_0.01_theta_var_rgk_15_psi_0.1';
        struct__stats.plotname = '__quality_deg_v_theta';
        struct__stats.x_label.data = '\theta Angle Threshold';
        struct__stats.y_label.data = 'Quality Score (z)';
        %struct__stats.print_filetype = '-dpng';
        struct__stats.x_array(1).data = struct__stats.quality.theta(2).data;
        struct__stats.y_array(1).data = struct__stats.quality.z_Total_deg(2).data;
        struct__stats.legend_switch.on = 0;
        %struct__stats.legend(1).data = 'line1';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        
        % z per plane
        struct__stats.plotname = '__quality_deg_v_theta_region_planes';
        struct__stats.x_label.data = '\theta Angle Threshold';
        struct__stats.y_label.data = 'Quality Score (z)';
        % Calcuation
        region_1 = find(struct__stats.quality.RP(2).data == 1);
        region_2 = find(struct__stats.quality.RP(2).data == 2); 
        region_3 = find(struct__stats.quality.RP(2).data == 3);               
        region_4 = find(struct__stats.quality.RP(2).data == 4);      
        region_5 = find(struct__stats.quality.RP(2).data == 5);         
        region_6 = find(struct__stats.quality.RP(2).data == 6);     
              
        struct__stats.x_array(1).data = struct__stats.quality.theta(2).data(region_1);
        struct__stats.y_array(1).data = struct__stats.quality.RP_norm_deg(2).data(region_1);
        struct__stats.x_array(2).data = struct__stats.quality.theta(2).data(region_2);
        struct__stats.y_array(2).data = struct__stats.quality.RP_norm_deg(2).data(region_2);
        struct__stats.x_array(3).data = struct__stats.quality.theta(2).data(region_3);
        struct__stats.y_array(3).data = struct__stats.quality.RP_norm_deg(2).data(region_3);
        struct__stats.x_array(4).data = struct__stats.quality.theta(2).data(region_4);
        struct__stats.y_array(4).data = struct__stats.quality.RP_norm_deg(2).data(region_4);
        struct__stats.x_array(5).data = struct__stats.quality.theta(2).data(region_5);
        struct__stats.y_array(5).data = struct__stats.quality.RP_norm_deg(2).data(region_5);
        struct__stats.x_array(6).data = struct__stats.quality.theta(2).data(region_6);
        struct__stats.y_array(6).data = struct__stats.quality.RP_norm_deg(2).data(region_6);
        
        struct__stats.legend_switch.on = 1;
        
        struct__stats.legend(1).data = 'Region 1';
        struct__stats.legend(2).data = 'Region 2';
        struct__stats.legend(3).data = 'Region 3';
        struct__stats.legend(4).data = 'Region 4';
        struct__stats.legend(5).data = 'Region 5';
        struct__stats.legend(6).data = 'Region 6';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        %% psi experiments
        %%
        struct__stats.experiment = '20160804_202540_GeoStruct__scs_0.01_theta_10_rgk_15_psi_var';
        struct__stats.plotname = '__quality_deg_v_psi';
        struct__stats.x_label.data = '\psi Offset Threshold';
        struct__stats.y_label.data = 'Quality Score (z)';
        %struct__stats.print_filetype = '-dpng';
        struct__stats.x_array(1).data = struct__stats.quality.psi(3).data;
        struct__stats.y_array(1).data = struct__stats.quality.z_Total_deg(3).data;
        struct__stats.legend_switch.on = 0;
        %struct__stats.legend(1).data = 'line1';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        
        % z per plane
        struct__stats.plotname = '__quality_deg_v_psi_region_planes';
        struct__stats.x_label.data = '\psi Offset Threshold';
        struct__stats.y_label.data = 'Quality Score (z)';
        % Calcuation
        region_1 = find(struct__stats.quality.RP(3).data == 1);
        region_2 = find(struct__stats.quality.RP(3).data == 2); 
        region_3 = find(struct__stats.quality.RP(3).data == 3);               
        region_4 = find(struct__stats.quality.RP(3).data == 4);      
        region_5 = find(struct__stats.quality.RP(3).data == 5);         
        region_6 = find(struct__stats.quality.RP(3).data == 6);     
              
        struct__stats.x_array(1).data = struct__stats.quality.psi(3).data(region_1);
        struct__stats.y_array(1).data = struct__stats.quality.RP_norm_deg(3).data(region_1);
        struct__stats.x_array(2).data = struct__stats.quality.psi(3).data(region_2);
        struct__stats.y_array(2).data = struct__stats.quality.RP_norm_deg(3).data(region_2);
        struct__stats.x_array(3).data = struct__stats.quality.psi(3).data(region_3);
        struct__stats.y_array(3).data = struct__stats.quality.RP_norm_deg(3).data(region_3);
        struct__stats.x_array(4).data = struct__stats.quality.psi(3).data(region_4);
        struct__stats.y_array(4).data = struct__stats.quality.RP_norm_deg(3).data(region_4);
        struct__stats.x_array(5).data = struct__stats.quality.psi(3).data(region_5);
        struct__stats.y_array(5).data = struct__stats.quality.RP_norm_deg(3).data(region_5);
        struct__stats.x_array(6).data = struct__stats.quality.psi(3).data(region_6);
        struct__stats.y_array(6).data = struct__stats.quality.RP_norm_deg(3).data(region_6);
        
        struct__stats.legend_switch.on = 1;
        
        struct__stats.legend(1).data = 'Region 1';
        struct__stats.legend(2).data = 'Region 2';
        struct__stats.legend(3).data = 'Region 3';
        struct__stats.legend(4).data = 'Region 4';
        struct__stats.legend(5).data = 'Region 5';
        struct__stats.legend(6).data = 'Region 6';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        
        %% rgk threshold plots
        %%
        struct__stats.experiment = '20160804_231604_GeoStruct__scs_0.01_theta_10_rgk_var_psi_0.1';
        struct__stats.plotname = '__quality_deg_v_k';
        struct__stats.x_label.data = 'k';
        struct__stats.y_label.data = 'Quality Score (z)';
        %struct__stats.print_filetype = '-dpng';
        struct__stats.x_array(1).data = struct__stats.quality.k(4).data;
        struct__stats.y_array(1).data = struct__stats.quality.z_Total_deg(4).data;
        struct__stats.legend_switch.on = 0;
        %struct__stats.legend(1).data = 'line1';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
        
        
        % z per plane
        struct__stats.plotname = '__quality_deg_v_k_region_planes';
        struct__stats.x_label.data = 'k';
        struct__stats.y_label.data = 'Quality Score (z)';
        % Calcuation
        region_1 = find(struct__stats.quality.RP(4).data == 1);
        region_2 = find(struct__stats.quality.RP(4).data == 2); 
        region_3 = find(struct__stats.quality.RP(4).data == 3);               
        region_4 = find(struct__stats.quality.RP(4).data == 4);      
        region_5 = find(struct__stats.quality.RP(4).data == 5);         
        region_6 = find(struct__stats.quality.RP(4).data == 6);     
              
        struct__stats.x_array(1).data = struct__stats.quality.k(4).data(region_1);
        struct__stats.y_array(1).data = struct__stats.quality.RP_norm_deg(4).data(region_1);
        struct__stats.x_array(2).data = struct__stats.quality.k(4).data(region_2);
        struct__stats.y_array(2).data = struct__stats.quality.RP_norm_deg(4).data(region_2);
        struct__stats.x_array(3).data = struct__stats.quality.k(4).data(region_3);
        struct__stats.y_array(3).data = struct__stats.quality.RP_norm_deg(4).data(region_3);
        struct__stats.x_array(4).data = struct__stats.quality.k(4).data(region_4);
        struct__stats.y_array(4).data = struct__stats.quality.RP_norm_deg(4).data(region_4);
        struct__stats.x_array(5).data = struct__stats.quality.k(4).data(region_5);
        struct__stats.y_array(5).data = struct__stats.quality.RP_norm_deg(4).data(region_5);
        struct__stats.x_array(6).data = struct__stats.quality.k(4).data(region_6);
        struct__stats.y_array(6).data = struct__stats.quality.RP_norm_deg(4).data(region_6);
        
        struct__stats.legend_switch.on = 1;
        
        struct__stats.legend(1).data = 'Region 1';
        struct__stats.legend(2).data = 'Region 2';
        struct__stats.legend(3).data = 'Region 3';
        struct__stats.legend(4).data = 'Region 4';
        struct__stats.legend(5).data = 'Region 5';
        struct__stats.legend(6).data = 'Region 6';
        
        [struct__stats] = statistics__generate_plot(struct__stats);
    %end 
else
    disp('Not doing any plotting');
end

disp('Execution complete. Function ancillary__click_callback.m terminating.');
% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
end