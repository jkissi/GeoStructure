%% segmentation__generate_region_plane.m (Plane Fit functions)
function [ planes, orientations ] = segmentation__generate_region_plane(planes, final_array, region_idx)
% Function to implement region growing algorithm to classify all points in
% the cloud to group them into larger regions (A_matrix) for measurement
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% Implementation of Region Growing and point cloud segmentation algorithm
% from T. Rabbani(2006) - Segmentation of Point Clouds Using Smoothness
% Constraint
% Implements region growing part of algorithm in the most direct way, with
% less focus on the smoothness constrait or residual threshold, as these
% aspects are not required for this algorithm
% Returns 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
% index :: index of the set of A_matrix to be sampled 
% matrix :: matrix of the coords of the A_matrix 
% ?
timer_start__segmentation__generate_region_plane = tic; %Start GeoStruct timer
global geo_struct;


orientations = struct();
idx__final_array_empty_elems = arrayfun(@(s) all(structfun(@isempty, s)), final_array);
final_array = final_array(~idx__final_array_empty_elems);
for special_idx = 1:region_idx
    % calculate the average normal vector from one region and plot it
    disp('Test1')
    find_idx = find([final_array.region_idx] == special_idx);
    disp('Test2')
    % as long as it isn't empty
    if(~isempty(find_idx))
        % get the appropriate indexes
        final_array_find = final_array(find_idx);
        % get the points of those points
        test_array_points = vertcat(final_array_find.vec__point);
        % get the appropriate colour
        macro_region_colour = final_array_find(1).region_colour;
        % get the centeroid plane point and the average normal
        disp('Test3')
        [var__normal, mat__orthnorm_plane_base, var__centeroid_point] = affine_fit(test_array_points);
        %plane_base = mat__orthnorm_plane_base;
        disp('Test4')
        % do the calculations to get the new plane boundary - alternative with
        % boundary.m to follow soon
        %AA = test_array_points';
        
        % Find point in AA closest to p1.
        %var__centeroid_point = var__plane_point; % centeroid

        %squaredDistance = sqrt(sum((AA-repmat(centeroid_point', [1, size(AA, 2)])).^2, 1));

        %dists = sqrt(sum(bsxfun(@minus, test_array_points, centeroid_point).^2, 2));
        %[maxSqDist1, indexOfMax1] = max(squaredDistance);
        %search_space_interval = maxSqDist1;
        % draw the macro plane
        %segmentation__region_plane_draw(centeroid_point, plane_base, search_space_interval, final_array_find, macro_region_colour, test_array_points);
        if(geo_struct.calculation__strike_and_dip.switch)
            disp('Test5')
            [radians__strike, degrees__strike, radians__dip_direction, degrees__dip_direction, radians__dip_angle, degrees__dip_angle, sigma, centeroid, direction_cosines] = calculation__strike_and_dip(test_array_points, var__normal);
            disp('Test6')
            orientations(special_idx).radians__strike = radians__strike; 
            orientations(special_idx).degrees__strike = degrees__strike; 
            orientations(special_idx).radians__dip_direction = radians__dip_direction; 
            orientations(special_idx).degrees__dip_direction = degrees__dip_direction; 
            orientations(special_idx).radians__dip_angle = radians__dip_angle; 
            orientations(special_idx).degrees__dip_angle = degrees__dip_angle; 
            orientations(special_idx).region_idx = special_idx;
            orientations(special_idx).centeroid_point = var__centeroid_point;
            orientations(special_idx).var__normal = var__normal;
            disp('Test7')
            disp('--------------------------------------------------------');
            disp(['Results for region ', num2str(special_idx)]);
            disp(['Strike radians measurement: ', num2str(radians__strike)]);
            disp(['Strike degrees measurement: ', num2str(degrees__strike)]);
            disp(['Dip radians measurement: ', num2str(radians__dip_angle)]);
            disp(['Dip degrees measurement: ', num2str(degrees__dip_angle)]);
            disp(['Dip Direction radians measurement: ', num2str(radians__dip_direction)]);
            disp(['Dip Direction degrees measurement: ', num2str(degrees__dip_direction)]);
            disp('--------------------------------------------------------');           
            disp('Test8')           
        end 
        
        if(geo_struct.segmentation__region_plane_draw.switch)
            disp('Test9')
            segmentation__region_plane_draw(final_array_find, macro_region_colour, test_array_points, orientations);
            disp('Test10')
            %segmentation__region_plane_draw(centeroid_point, var__normal, final_array_find, macro_region_colour, test_array_points, special_idx, strike, strike2, dip, dip2, dip_direction, dip_direction2);        
        end 

    end
end


%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------

%timer_start__segmentation__region_growing = tic; %Start GeoStruct timer
timer_stop__segmentation__generate_region_plane = toc(timer_start__segmentation__generate_region_plane); %Stop internal timer

if(geo_struct.timings.switch)
    geo_struct.timings.timer_start__segmentation__generate_region_plane = timer_start__segmentation__generate_region_plane;
    geo_struct.timings.timer_stop__segmentation__generate_region_plane = timer_stop__segmentation__generate_region_plane;
end

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.parent_folder, '\',geo_struct.stats.experiment, '__seg_gen_rg', geo_struct.stats.figure_ext]);
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__pc_read', geo_struct.stats.figure_ext]);
disp('Execution complete. Function segmentation__generate_region_plane.m terminating.');
end

