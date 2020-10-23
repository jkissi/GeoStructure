% -------------------------------------------------------------------------
% statistics__write_textfile_normalisation_agg function
% -------------------------------------------------------------------------
function [save_file] = statistics__write_textfile_normalisation_agg(struct__stats)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to aggregates all the data from all the textfiles of the
% different experiments that are running and appends them to one big file
% that can be read and plotted at once. 
% ------------------------------------------------------------------------- 
%global geo_struct;

% experiment_folder = struct__stats.ouput_folder;
% filename = [struct__stats.experiment, '_normalised'];
% ext = '.txt';
save_file = struct__stats.save_file;
%struct__RP = struct__stats.struct__RP;
%vars = struct__stats.vars;
run_vars = struct__stats.run_vars;
fileID = fopen(save_file, 'at+');
%for i = 1:length(struct__RP)
[nrows, ncols] = size(run_vars);
disp(['Just displaying the number of rows. nrows = ', num2str(nrows),'. :0)']);
for row = 1:nrows
    fprintf(fileID,'%6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f\n', run_vars(row, :));
end
fclose(fileID); 

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function statistics__write_textfile_normalisation_agg.m terminating.');
return;
end
