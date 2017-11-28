%
function [save_file] = statistics__write_textfile(struct__stats)
%% 
global geo_struct;

experiment_folder = [geo_struct.output_folder, struct__stats.parent_folder];
%filename = struct__stats.experiment;
filename = struct__stats.parent_folder;
ext = geo_struct.stats.textfile_ext;
save_file = [experiment_folder, '\',filename, ext];

GS_TStart = geo_struct.timings.timer_start__GeoStruct;
GS_TStart = double(GS_TStart);
GS_TStop = geo_struct.timings.timer_stop__GeoStruct;
RG_TStart = geo_struct.timings.timer_start__segmentation__region_growing;
RG_TStart = double(RG_TStart);
RG_TStop = geo_struct.timings.timer_stop__segmentation__region_growing;
k = geo_struct.region_growing_k;
Norm_Thresh = geo_struct.normal_threshold;
SC_Size = geo_struct.var__search_cube_size_factor;
psi = geo_struct.r_thresh_factor;
run_vars = [struct__stats.run; GS_TStart; GS_TStop; RG_TStart; RG_TStop; k; Norm_Thresh; SC_Size; psi];


fileID = fopen(save_file, 'at+');
fprintf(fileID,'%6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.6f | %6.6f\n', run_vars);
fclose(fileID); 


disp('Execution complete. Function statistics__write_textfile.m terminating.');
return;
end
