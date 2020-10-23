% -------------------------------------------------------------------------
% statistics__write_textfile_header function
% -------------------------------------------------------------------------
function [save_file] = statistics__write_textfile_header(struct__stats)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to write the header of the textfile
% ------------------------------------------------------------------------- 

global geo_struct;
experiment_folder = [geo_struct.output_folder, struct__stats.parent_folder];
%filename = struct__stats.experiment;
filename = struct__stats.parent_folder;
ext = geo_struct.stats.textfile_ext;
save_file = [experiment_folder, filesep, filename, ext];

fileID = fopen(save_file, 'at+');
fprintf(fileID,'============================================================================================\n');
fprintf(fileID,'%6s | %8s | %8s | %8s | %8s | %8s | %8s | %8s | %8s\n','Run','GS_TStart','GS_TStop','RG_TStart','RG_TStop','k','Norm_Thresh','SC_Size','psi');
fprintf(fileID,'============================================================================================\n');
fclose(fileID); 


%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function statistics__write_textfile_header.m terminating.');
return;
end
