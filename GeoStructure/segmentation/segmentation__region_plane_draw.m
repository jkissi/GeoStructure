%% segmentation__region_plane_draw.m (Plane Fit functions)
function [ ] = segmentation__region_plane_draw(planes, macro_region_colour, test_array_points, orientations)
% Function to find the best fit plane 
%% ------------------------------------------------------------------------
% Discussion
%--------------------------------------------------------------------------
% This is where all the magic happens. Finds the best fit plane
%
% Returns 
%% ------------------------------------------------------------------------
% External Variables
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Create plane area
%--------------------------------------------------------------------------
global geo_struct;
face_alpha = geo_struct.face_alpha;
edge_alpha = geo_struct.edge_alpha;
point = orientations(end).centeroid_point;
normal = orientations(end).var__normal;
% a plane is a*x + b*y + c*z + d = 0
% [a,b,c] is the normal. Thus, we have to calculate
% d and we're set
d = -point*normal; %'# dot product for less typing

% % create x,y
% [ xx, yy ] = meshgrid(min(x):max(x), min(y):max(y));
% 
% % calculate corresponding z
% % assuming normal(3)==0 and normal(2)~=0
% %if((normal(3) == 0) & (normal(2)~= 0))
% if((abs(normal(3)) < 0.1) & (normal(2)~= 0))
%     z = (-normal(3)*xx - normal(1)*yy - d)/normal(2); 
% else
%     z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
% end

% plot the centeroid point 
%plot3(point(1),point(2),point(3),'bo','markersize',5,'markerfacecolor', macro_region_colour);

%plot the normal vector
%quiver3(point(1), point(2), point(3), normal(1)/3, normal(2)/3, normal(3)/3, 'b','linewidth',5);


%# plot the surface
% if((size(z, 1) == 1) | (size(z, 2) == 1))
%     disp('One of the dimensions is equal to 1, so no surf');
% end
new_origin = point;
if(size(test_array_points, 1) <= 3)
    disp(['test array points less than 3: ', num2str(size(test_array_points, 1)),'.']);
    disp(['So no region plane for this one. Its Region: ', num2str(orientations(end).region_idx)])
else
% Bounding box method
o = [];
o = new_origin;

%set y = z = 0 (if n_x ~= 0)
phi = (1 + sqrt(5))/2; 
struct__phi = struct();
Eu = [];
I = [];

theta = 0; %pi/4 use radians or convert everything to degrees!

phi_a = 45;
phi_b = 22.5;
Eu = [(-d/normal(1)),0, 0 ];
u_vector_zero_default = (Eu - point)/norm(Eu - point)';

tol = geo_struct.phi_tolerance;     
phi_c = phi_b - (phi_b - phi_a)/phi;
phi_d = phi_a + (phi_b - phi_a)/phi;
% Assume the minimum wont be found between the bounds of the first
% iteration 
[ phi_search_a ] = compute_perimeter(phi_a, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_b ] = compute_perimeter(phi_b, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_c ] = compute_perimeter(phi_c, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_d ] = compute_perimeter(phi_d, u_vector_zero_default', test_array_points, normal, point);

%while(abs(phi_search_c.perimeter - phi_search_d.perimeter) > tol)
while(abs(phi_c - phi_d) > tol)
 
[ phi_search_a ] = compute_perimeter(phi_a, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_b ] = compute_perimeter(phi_b, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_c ] = compute_perimeter(phi_c, u_vector_zero_default', test_array_points, normal, point);

[ phi_search_d ] = compute_perimeter(phi_d, u_vector_zero_default', test_array_points, normal, point);

if(phi_search_c.perimeter < phi_search_d.perimeter)
    phi_b = phi_d;
else
    phi_a = phi_c;
end

 phi_c = phi_b - (phi_b - phi_a)/phi;

 phi_d = phi_a + (phi_b - phi_a)/phi;

end

final_theta_value = (phi_b + phi_a)/2;
disp('final theta value point');
[ final_phi_search ] = compute_perimeter(final_theta_value, u_vector_zero_default', test_array_points, normal, point);
disp('final theta search point');
max_U = final_phi_search.beta_max * final_phi_search.new_u;
min_U = final_phi_search.beta_min * final_phi_search.new_u;

max_V = final_phi_search.gamma_max * final_phi_search.new_v;
min_V = final_phi_search.gamma_min * final_phi_search.new_v;

corners_maxmax = o + max_U + max_V';
corners_maxmin = o + max_U + min_V';
corners_minmax = o + min_U + max_V';
corners_minmin = o + min_U + min_V';


region_plane = [corners_maxmax; corners_maxmin; corners_minmin; corners_minmax ];
f = [1, 2, 3, 4];
disp('before patch');
special_handle = patch('Faces',f,'Vertices',region_plane, 'FaceColor', macro_region_colour);
disp('after patch');
%if(size(z) > 1)
    %special_handle = surf(xx,yy,z);
    if(geo_struct.segmentation__region_plane_draw.invisible)
        %alpha_value = 0.4;
        disp(['before set alphas']);
        set(special_handle, 'FaceAlpha', face_alpha, 'EdgeAlpha', edge_alpha);
        disp('after set alphas');
    end 
    special_props.region = [orientations(end).region_idx, orientations(end).radians__strike, ...
        orientations(end).degrees__strike, orientations(end).radians__dip_angle, ...
        orientations(end).degrees__dip_angle, orientations(end).radians__dip_direction, ...
        orientations(end).degrees__dip_direction];
    special_props.experiment = geo_struct.stats.experiment;
    special_props.output_folder = geo_struct.output_folder;
    special_props.parent_folder = geo_struct.stats.parent_folder;
    special_props.struct__RP = geo_struct.stats.ground_truth.struct__RP;
    special_props.vars = [geo_struct.var__search_cube_size_factor, ...
        geo_struct.region_growing_k, geo_struct.normal_threshold, ...
        geo_struct.r_thresh_factor];
    if(numel(special_props) < 7)
        disp('Here one is');
    end
    disp('before set userdata');
    set(special_handle,'UserData', special_props);
    disp('after set userdata');
    disp('before set clickback');
    set(special_handle,'ButtonDownFcn', @ancillary__click_callback);
    disp('after set clickback');
end 

%--------------------------------------------------------------------------
% Remove the best fit planes 
%--------------------------------------------------------------------------
if(geo_struct.segmentation__region_plane_draw.remove_bf_planes)
    disp('before rm bfplanes');
    for j = 1:length(planes)
    han__seg_plane_draw = planes(j).han__seg_plane_draw;
    idx__seg_plane_draw = planes(j).idx__seg_plane_draw;
        if(ishandle(han__seg_plane_draw))
            %pause(1);
            % delete the previous index of the plane on the current plot
            delete(han__seg_plane_draw);
        end
    end 
    disp('after rm bfplanes');
end
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Test save1')
%saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__seg_rg_draw', geo_struct.stats.figure_ext]);
disp('Test save2')
disp('Execution complete. Function macro_plane__draw.m terminating.');
return;
end 