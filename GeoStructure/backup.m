%     existMessage = sprintf('Does this correspond to a ground truth region?');
%     existbutton = questdlg(existMessage, 'Ground truth?', 'Yes', 'No', 'Y'); 

% if(strcmp(button__rp_input_save, 'Yes'))
%     while(strcmp(button__rp_input_complete, 'No'))
%              
%         prompt = {'RP number:', 'Does this region exist?'};
%         name = 'fracture orientation info';
%         defaultans = {'', 'Yes'};
%         options.Interpreter = 'tex';
%         button__RP = inputdlg(prompt, name, [1, 5], defaultans, options);
%         region_number = str2num(button__RP{1});
%         region_exist = button__RP{2};
%         if(strcmp(region_exist, 'No'))
%             % do normalisation
%             z__st_deg = 1;
%             z__st_rad = 1;
%             z__da_deg = 1;
%             z__da_rad = 1;
%             z__dd_deg = 1;
%             z__dd_rad = 1;
%             
%             struct__RP(region_number).strike.degrees(2).data = NaN;
%             struct__RP(region_number).strike.radians(2).data = NaN;
%             struct__RP(region_number).dip_angle.degrees(2).data = NaN;
%             struct__RP(region_number).dip_angle.radians(2).data = NaN;
%             struct__RP(region_number).dip_direction.degrees(2).data = NaN;
%             struct__RP(region_number).dip_direction.radians(2).data = NaN;
%         else
%             
%             st_deg(1) = struct__RP(region_number).strike.degrees(1).data;
%             st_rad(1) = struct__RP(region_number).strike.radians(1).data;
%             da_deg(1) = struct__RP(region_number).dip_angle.degrees(1).data;
%             da_rad(1) = struct__RP(region_number).dip_angle.radians(1).data;
%             dd_deg(1) = struct__RP(region_number).dip_direction.degrees(1).data;
%             dd_rad(1) = struct__RP(region_number).dip_direction.radians(1).data;
%             
%             % add saved measurements
%             st_deg(2) = measurements(3);
%             st_rad(2) = measurements(2);
%             da_deg(2) = measurements(5);
%             da_rad(2) = measurements(4);
%             dd_deg(2) = measurements(7);
%             dd_rad(2) = measurements(6);
%             
%             % do normalisation
%             z__st_deg = (sqrt((st_deg(1) - st_deg(2))^2) - 0)/(360 - 0);
%             z__st_rad = (sqrt((st_rad(1) - st_rad(2))^2) - 0)/(360 - 0);
%             z__da_deg = (sqrt((da_deg(1) - da_deg(2))^2) - 0)/(90 - 0);
%             z__da_rad = (sqrt((da_deg(1) - da_deg(2))^2) - 0)/(90 - 0);
%             z__dd_deg = (sqrt((dd_deg(1) - dd_deg(2))^2) - 0)/(360 - 0);
%             z__dd_rad = (sqrt((dd_deg(1) - dd_deg(2))^2) - 0)/(360 - 0);
%             
%             struct__RP(region_number).strike.degrees(2).data = st_deg(2);
%             struct__RP(region_number).strike.radians(2).data = st_rad(2);
%             struct__RP(region_number).dip_angle.degrees(2).data = da_deg(2);
%             struct__RP(region_number).dip_angle.radians(2).data = da_rad(2);
%             struct__RP(region_number).dip_direction.degrees(2).data = dd_deg(2);
%             struct__RP(region_number).dip_direction.radians(2).data = dd_rad(2);
%         end
%         struct__RP(region_number).strike.degrees(3).data = z__st_deg;
%         struct__RP(region_number).strike.radians(3).data = z__st_rad;
%         struct__RP(region_number).dip_angle.degrees(3).data = z__da_deg;
%         struct__RP(region_number).dip_angle.radians(3).data = z__da_rad;
%         struct__RP(region_number).dip_direction.degrees(3).data = z__dd_deg;
%         struct__RP(region_number).dip_direction.radians(3).data = z__dd_rad;
%         
%         
%         % do normalisation for entire plane
%         z__RP_norm_deg = (sqrt((z__st_deg - z__da_deg - z__dd_deg)^2) - 0)/(3 - 0);
%         z__RP_norm_rad = (sqrt((z__st_rad - z__da_rad - z__dd_rad)^2) - 0)/(3 - 0);
%         
%         struct__RP(region_number).z__RP_norm_deg = z__RP_norm_deg;
%         struct__RP(region_number).z__RP_norm_rad = z__RP_norm_rad;
%         
%         normMessage = sprintf(['Have you finished adding information for all the planes for experiment ', experiment,'?']);
%         button__rp_input_complete = questdlg(normMessage, 'finish loop?', 'Yes', 'No', 'Exit');
%         if(strcmp(button__rp_input_complete, 'Exit'))
%             disp('Exiting loop. No further data to be saved');
%             break;
%         elseif(strcmp(button__rp_input_complete, 'Yes'))
%             for t = 1:region_number
%                 array__z_total_deg(end + 1) = struct__RP(t).z__RP_norm_deg;
%                 array__z_total_rad(end + 1) = struct__RP(t).z__RP_norm_rad;
% 
%             end
%                 z__Total_deg = (sqrt((array__z_total_deg(1) - array__z_total_deg(2) - array__z_total_deg(3) - array__z_total_deg(4) - array__z_total_deg(5) - array__z_total_deg(6))^2) - 0)/(6 - 0);
%                 z__Total_rad = (sqrt((array__z_total_rad(1) - array__z_total_rad(2) - array__z_total_rad(3) - array__z_total_rad(4) - array__z_total_rad(5) - array__z_total_rad(6))^2) - 0)/(6 - 0);
%                 struct__RP(:).z__Total_deg = z__Total_deg;
%                 struct__RP(:).z__Total_rad = z__Total_rad;
%         end
%     end
%     if(strcmp(button__rp_input_complete, 'Yes'))
%         struct__stats.output_folder = output_folder;
%         struct__stats.experiment = experiment;
%         struct__stats.struct__RP = struct__RP;
%         save_file = [struct__stats.ouput_folder,'\textfiles','\', struct__stats.experiment, '_normalised', '.txt'];
%         struct__stats.save_file = struct__stats;
%         struct__stats.vars = vars;
%         struct__stats.region_number = region_number;
%         if(~exist(save_file, 'file'))
%             [ text_file ] = statistics__write_textfile_header_normalisation(struct__stats);
%         end
% 
%         [ text_file ] = statistics__write_textfile_normalisation(struct__stats);
%     end
% else
%     disp('Not saving any plane information!!');
% end