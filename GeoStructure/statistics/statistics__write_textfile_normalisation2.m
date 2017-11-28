%
function [save_file] = statistics__write_textfile_normalisation(struct__stats)
%% 
%global geo_struct;

% experiment_folder = struct__stats.ouput_folder;
% filename = [struct__stats.experiment, '_normalised'];
% ext = '.txt';
save_file = struct__stats.save_file;
struct__RP = struct__stats.struct__RP;
vars = struct__stats.vars;

scs = vars(1);    
k = vars(2);
theta = vars(3);
psi = vars(4);

fileID = fopen(save_file, 'at+');
for i = 1:length(struct__RP)
run_vars = [i; scs; k; theta; psi; ... %vars
    struct__RP(i).strike.degrees(1).data; struct__RP(i).strike.degrees(2).data; struct__RP(i).strike.degrees(3).data;... % strike deg
    struct__RP(i).dip_angle.degrees(1).data; struct__RP(i).dip_angle.degrees(2).data; struct__RP(i).dip_angle.degrees(3).data;... % da deg
    struct__RP(i).dip_direction.degrees(1).data; struct__RP(i).dip_direction.degrees(2).data; struct__RP(i).dip_direction.degrees(3).data;... % dd deg
    struct__RP(i).strike.radians(1).data; struct__RP(i).strike.radians(2).data; struct__RP(i).strike.radians(3).data; ... % strike rads
    struct__RP(i).dip_angle.radians(1).data; struct__RP(i).dip_angle.radians(2).data; struct__RP(i).dip_angle.radians(3).data;... % da rads
    struct__RP(i).dip_direction.radians(1).data; struct__RP(i).dip_direction.radians(2).data; struct__RP(i).dip_direction.radians(3).data; ... % dd rads
    struct__RP(i).z__RP_norm_deg; struct__RP(i).z__RP_norm_rad];% struct__RP(i).z__Total_deg; struct__RP(i).z__Total_rad];



fprintf(fileID,'%6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.6f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f | %6.2f\n', run_vars);
end
fclose(fileID); 


disp('Execution complete. Function statistics__write_textfile.m terminating.');
return;
end
