% -------------------------------------------------------------------------
% statistics__generate_plot function
% -------------------------------------------------------------------------
function [struct__stats] = statistics__generate_plot(struct__stats)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to automatically generate plots from the data collected during
% the experiment cycle
% -------------------------------------------------------------------------
global geo_struct;

if(struct__stats.quality_score_switch)
    savepath = [struct__stats.output_folder, struct__stats.parent_folder, filesep];
    ext = struct__stats.plot_ext;
    experiment = struct__stats.experiment;

elseif(struct__stats.replot_only)
    savepath = [struct__stats.output_folder, struct__stats.parent_folder, filesep];
    ext = struct__stats.plot_ext;
    experiment = struct__stats.experiment;
else

    savepath = [geo_struct.output_folder, geo_struct.stats.parent_folder, filesep];
    ext = geo_struct.stats.plot_ext;
    experiment = struct__stats.parent_folder;
end
plotname = struct__stats.plotname;


x_array = struct__stats.x_array;
y_array = struct__stats.y_array;
x_label = struct__stats.x_label;
y_label = struct__stats.y_label;


%print_filetype = struct__stats.print_filetype;
savename = [experiment, plotname];

figure;
hold on;
for i = 1:length(x_array)
    if(isempty(x_array(i).data) | isempty(y_array(i).data))
        disp('Sorry xarray or yarray is empty.');
        disp('x array = ', mat2str(x_array(i).data),', y array = ', mat2str(y_array(i).data));
        disp('No plot for ', [savename, ext]);
    else
        if(struct__stats.legend_switch.on)
            plot(x_array(i).data, y_array(i).data, '.-', 'DisplayName', struct__stats.legend(i).data, 'Linewidth', 2, 'MarkerSize', 12);
            %legend('show');
        else
            plot(x_array(i).data, y_array(i).data, '.-', 'Linewidth', 2, 'MarkerSize', 12);   
        end
        xlabel(x_label.data);
        ylabel(y_label.data);
        grid on;
        if(struct__stats.xlim_switch)
            xlim(struct__stats.xlim_var);
        end
        if(struct__stats.ylim_switch)
            ylim(struct__stats.ylim_var);
        end
    end
end
if(struct__stats.legend_switch.on)
    legend('Location', 'best');
    legend('show');
end
saveas(gcf, [savepath, savename, ext]);
hold off;
struct__stats = rmfield(struct__stats, 'x_array');
struct__stats = rmfield(struct__stats, 'y_array');
if(isfield(struct__stats, 'legend'))
    struct__stats = rmfield(struct__stats, 'legend');
end

% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function statistics__generate_plot.m terminating.');
return;
end
