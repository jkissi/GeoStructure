function [ ] = v2i3(absolute_video_file_path, output_image_file_prefix, output_file_ext)
% Construct a multimedia reader object associated with file 'xylophone.mpg' with
% user tag set to 'myreader1'.

[input_file_path, input_file_name, input_file_extension] = fileparts(absolute_video_file_path);
%readerobj = VideoReader('\video\MVI_0002.AVI', 'tag', 'myreader1');
readerobj = VideoReader(absolute_video_file_path, 'tag', 'myreader1');


% Get the number of frames.
numFrames = get(readerobj, 'NumberOfFrames');
% Ask user if they want to write the individual frames out to disk.
promptMessage = sprintf(['There are ', num2str(numFrames), ' frames. Do you want to save the individual frames out to individual disk files?']);
button = questdlg(promptMessage, 'Save individual frames?', 'Yes', 'No', 'Yes');
% Create a MATLAB movie struct from the video frames.
mov = struct();
written_frames = 0;
for v = 1:numFrames
% Read in all video frames.
vidFrames = read(readerobj, v);


%folder = fullfile('C:\Users\jkissi\Downloads\research\SfM\examples\wall3\video\');
%movieFullFileName = fullfile(folder, 'MVI_0002.AVI');
%movieFullFileName = fullfile(folder, input_file_name);
%prefix = 'MVI02';
prefix = output_image_file_prefix;

if strcmp(button, 'Yes')
    writeToDisk = true;
    % Extract out the various parts of the filename.
    [folder, video_file_name, extension] = fileparts(absolute_video_file_path);
    % Make up a special new output subfolder for all the separate
    % movie frames that we're going to extract and save to disk.
    % (Don't worry - windows can handle forward slashes in the folder name.)
    %folder = [folder, '\'];   % Make it a subfolder of the folder where this m-file lives.
    output_folder = sprintf('%s/frames_from_%s', folder, input_file_name);
    % Create the folder if it doesn't exist already.
    if(~exist(output_folder, 'dir'))
        mkdir(output_folder);
    end
else
    writeToDisk = false;
end



%for k = 1:numFrames
    mov.cdata = vidFrames(:,:,:);
    mov.colormap = [];
    
    thisFrame = mov.cdata;
    hImage = subplot(1,1,1);
    image(thisFrame);
    %axis square;
    axis off;
    drawnow; % Force it to refresh the window.
    set(findobj(gcf, 'type','axes'), 'Visible','off')
    % Write the image array to the output file, if requested.
    if writeToDisk
        % Construct an output image file name.
        output_file_name = sprintf([prefix,'_','%4.4d','.',output_file_ext], v);
        output_file_path = fullfile(output_folder, output_file_name);
        
        % Extract the image with the text "burned into" it.
        frameWithText = getframe(gca);
        % Write it out to disk.
        imwrite(frameWithText.cdata, output_file_path, output_file_ext);
    end
    
    % Update user with the progress.  Display in the command window.
    if writeToDisk
        progressIndication = sprintf('Wrote frame %4d of %d.', v, numFrames);
    else
        progressIndication = sprintf('Processed frame %4d of %d.', v, numFrames);
    end
    disp(progressIndication);
    % Increment frame count (should eventually = numberOfFrames
    % unless an error happens).
    written_frames = written_frames + 1;
    
end



% Inform of completion 
if writeToDisk
    finishedMessage = sprintf('Done!  It wrote %d frames to folder\n"%s"', written_frames, output_folder);
else
    finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"', written_frames, [input_file_name, input_file_extension]);
end
disp(finishedMessage); % Write to command window.
uiwait(msgbox(finishedMessage)); % Also pop up a message box.
end
