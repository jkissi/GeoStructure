%
function [save_file] = statistics__write_textfile_normalisation(struct__stats)
%% 
%global geo_struct;

% experiment_folder = struct__stats.ouput_folder;
% filename = [struct__stats.experiment, '_normalised'];
% ext = '.txt';
save_file = struct__stats.save_file;

calculate_final_score_switch = struct__stats.calculate_final_score_switch;

%fileID = fopen(save_file, 'at+');
% run_vars = struct__stats.run_vars;
%for i = 1:length(struct__RP)
if(calculate_final_score_switch)
    replaceLine = 4;
    run_vars = struct__stats.run_vars;
    fileID = fopen(save_file, 'r+');
    fseek(fileID,0,'bof');
    for k = 1:(replaceLine - 1);
        fgetl(fileID);
    end
    fseek(fileID,0,'cof');
    [nrows,ncols] = size(run_vars);
    if(nrows ~= 6)
        disp(['Somethings gone wrong. nrows = ', num2str(nrows),'. Either add more rows or start again. :-)']);
    else
        for row = 1:nrows
            %fprintf(fileID,formatSpec,run_vars{row,:});
            fprintf(fileID, '%6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f\n', run_vars(row, :));
            %fclose(fileID);    
        end
    end
else 
struct__RP = struct__stats.struct__RP;
vars = struct__stats.vars;
region = struct__stats.region_number;
scs = vars(1);    
k = vars(2);
theta = vars(3);
psi = vars(4);
fileID = fopen(save_file, 'at+');
run_vars = [region; scs; k; theta; psi; ... %vars
    struct__RP(region).strike.degrees(1).data; struct__RP(region).strike.degrees(2).data; struct__RP(region).strike.degrees(3).data;... % strike deg
    struct__RP(region).dip_angle.degrees(1).data; struct__RP(region).dip_angle.degrees(2).data; struct__RP(region).dip_angle.degrees(3).data;... % da deg
    struct__RP(region).dip_direction.degrees(1).data; struct__RP(region).dip_direction.degrees(2).data; struct__RP(region).dip_direction.degrees(3).data;... % dd deg
    struct__RP(region).strike.radians(1).data; struct__RP(region).strike.radians(2).data; struct__RP(region).strike.radians(3).data; ... % strike rads
    struct__RP(region).dip_angle.radians(1).data; struct__RP(region).dip_angle.radians(2).data; struct__RP(region).dip_angle.radians(3).data;... % da rads
    struct__RP(region).dip_direction.radians(1).data; struct__RP(region).dip_direction.radians(2).data; struct__RP(region).dip_direction.radians(3).data; ... % dd rads
    struct__RP(region).z__RP_norm_deg; struct__RP(region).z__RP_norm_rad; 0; 0];% struct__RP(i).z__Total_deg; struct__RP(i).z__Total_rad];

fprintf(fileID,'%6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f | %6.4f\n', run_vars);
%fclose(fileID); 
end
fclose(fileID);


disp('Execution complete. Function statistics__write_textfile.m terminating.');
return;
end
