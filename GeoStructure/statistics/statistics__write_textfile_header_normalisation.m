function [save_file] = statistics__write_textfile_header_normalisation(struct__stats)
%% 

%global geo_struct;
% experiment_folder = struct__stats.ouput_folder;
% filename = [struct__stats.experiment, '_normalised'];
% ext = '.txt';
% save_file = [experiment_folder,'\', filename, ext];
save_file = struct__stats.save_file;

fileID = fopen(save_file, 'at+');
fprintf(fileID,'===========================================================================================================================================================================================================================\n');
fprintf(fileID,'%8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s\n',...
    'RP','scs','k','theta','psi',...
    'st_1_deg','st_2_deg','st_3_deg','da_1_deg','da_2_deg','da_3_deg','dd_1_deg','dd_2_deg','dd_3_deg',...
    'st_1_rad','st_2_rad','st_3_rad','da_1_rad','da_2_rad','da_3_rad','dd_1_rad','dd_2_rad','dd_3_rad',...
    'RP_z_deg','RP_z_rad', 'Tot_z_deg', 'Tot_z_rad');%
fprintf(fileID,'===========================================================================================================================================================================================================================\n');
fclose(fileID); 


disp('Execution complete. Function statistics__write_textfile_header_normalisation.m terminating.');
return;
end
