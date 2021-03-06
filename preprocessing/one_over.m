% -------------------------------------------------------------------------
% one_over function
% -------------------------------------------------------------------------
function [ ] = one_over(input_divisor, absolute_file_path, absolute_output_path, output_folder, input_file_ext)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to select every nth file of a specific type from a directory,
% copy and place in a different directory. In the context of the
% GeoStructure pipeline, this is how the number of samples the point cloud
% is built from is selected, remembering that we work from a standard
% baseline of 25fps for video, like is being used here. 
% The first argument is the numerical denomiator, so if the argument is 10,
% 10% of the total images will be used as the sample set. 
% -------------------------------------------------------------------------

path_input = absolute_file_path;       % folder path
%path_output = output_folder;
file_extension = input_file_ext;       % input file extension
divisor = input_divisor;


files = dir(fullfile(path_input, ['*.', file_extension]));   % list all *.xyz files
files = {files.name}';                      % file names


%output_folder = sprintf('Frames from %s', folder, input_file_name);
%[pathstr,name] = fileparts(path_input);
%c_array = strsplit(path_input,'\')
output_folder = [absolute_output_path, '\', output_folder];
% Create the folder if it doesn't exist already.
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end


data = cell(numel(files), 1);                % store file contents
for i = 1:numel(files)
    if(mod(i, divisor) == 0)
        fname = fullfile(path_input, files{i});     % full path to file
        copyfile(fname, output_folder);
        disp([int2str(i), 'th file(', fname, ') copied and moved to ', output_folder])
    end
end


disp(['All files copied and moved to ', output_folder, '.']);

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Read complete. Function one_over.m terminating.');

end
