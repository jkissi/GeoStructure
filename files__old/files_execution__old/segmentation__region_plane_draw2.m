%% best_fit_plane__draw.m (Plane Fit functions)
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

point = orientations(end).centeroid_point;
normal = orientations(end).var__normal;
x = test_array_points(:, 1)';
y = test_array_points(:, 2)';
% zzz = test_array_points(:, 3)';
% a plane is a*x + b*y + c*z + d = 0
% [a,b,c] is the normal. Thus, we have to calculate
% d and we're set
d = -point*normal; %'# dot product for less typing

% create x,y
[ xx, yy ] = meshgrid(min(x):max(x), min(y):max(y));

% calculate corresponding z
% assuming normal(3)==0 and normal(2)~=0
%if((normal(3) == 0) & (normal(2)~= 0))
if((abs(normal(3)) < 0.1) & (normal(2)~= 0))
    z = (-normal(3)*xx - normal(1)*yy - d)/normal(2); 
else
    z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
end

% plot the centeroid point 
plot3(point(1),point(2),point(3),'bo','markersize',5,'markerfacecolor', macro_region_colour);

%plot the normal vector
quiver3(point(1), point(2), point(3), normal(1)/3, normal(2)/3, normal(3)/3, 'b','linewidth',5);


%# plot the surface
if((size(z, 1) == 1) | (size(z, 2) == 1))
    disp('One of the dimensions is equal to 1, so no surf');
else
    new_origin = point;
    
    %do transformation 
    %for x
    if(sign(new_origin(1)))
        transform_x = -new_origin(1);
    elseif(~sign(new_origin(1)))
        transform_x = new_origin(1);
    end 
    %for y
    if(sign(new_origin(2)))
        transform_y = -new_origin(2);
    elseif(~sign(new_origin(2)))
        transform_y = new_origin(2);
    end     
    %for z
    if(sign(new_origin(3)))
        transform_z = -new_origin(3);
    elseif(~sign(new_origin(3)))
        transform_z = new_origin(3);
    end     
    
     vec__transform = [transform_x transform_y transform_z];
     x = test_array_points(:, 1)';
     y = test_array_points(:, 2)';
     zzz = test_array_points(:, 3)';
%     
%     x2 = transform_x + x;
%     y2 = transform_y + y;
%     zzz2 = transform_z + zzz;
%     % get all the distances 
%     trans_dist = sqrt(sum(bsxfun (@minus, [x2' y2' zzz2'], new_origin).^2, 2));
%     [tdist_asc,tdist_asc_idx] = sort(trans_dist, 'descend');
%     transform_coords = [x2' y2' zzz2'];
%     idx_farthest = tdist_asc_idx(1:4);
%     trans_farthest = transform_coords(idx_farthest, :);
%     T__x = trans_farthest(:, 1) - transform_x;
%     T__y = trans_farthest(:, 2) - transform_y;
%     T__z = trans_farthest(:, 3) - transform_z;
%     special_handle = surf(T__x,T__y,T__z);

% Bounding box method
% p =[];
% p = new_origin;
% pi = test_array_points;
% Ui = [];
% Uu = [];
%  for f = 1:length(pi)
%      Ui(f, :) = pi(f, :) - p;
%  end
%  for q = 1:length(Ui)
%      Uu(q, :) = dot(normal, Ui(q, :)); %/Ui(q, :);
%  end 
%     alp = [];
%     alph_idx
%     
%     [alp, alph_idx] = min(Uu); % or max
% 
%     V = Uu*normal';
%     U = Ui;
%     vi = V(alp_idx);
%     ui = U(alp_idx);
    
o = [];
o = new_origin;
ui = test_array_points;
u = [];
v = [];
vi = [];
U = [];
V = [];
U_x = [];
U_y = [];
U_z = [];
V_x = [];
V_y = [];
V_z = [];
min_U_idx = [];
max_U_idx = [];
min_V_idx = [];
max_V_idx = []; 
corners_maxmax = [];
corners_minmin = [];
corners_minmax = [];
corners_maxmin = [];
alp = [];
alp_val = [];


for i = 1:length(test_array_points)
    uc(i, :) = ui(i, :) - o;
    alp(i) = dot(uc(i, :),normal)/norm(uc(i, :));
end 

[alp_val, alpha_ind] = min(alp);
u=uc(alpha_ind,:);
v=cross(u,normal);

% for t = 1:length(test_array_points)
%     vi(t, :) = v(t, :) + o;
% end     

% plane_points_x = (ui(:, 1) * u(:, 1)) + (vi(:, 1) * v(:, 1)) + o(:, 1); 
% plane_points_y = (ui(:, 2) * u(:, 2)) + (vi(:, 2) * v(:, 2)) + o(:, 2); 
% plane_points_z = (ui(:, 3) * u(:, 3)) + (vi(:, 3) * v(:, 3)) + o(:, 3); 

% for h = 1:length(test_array_points)
%     U(h, :) = cross(ui(h, :), u(h, :));
% end 
% %U = [U_x; U_y; U_z];
% for e = 1:length(test_array_points)
%     V(e, :) = cross(vi(e, :), v(e, :));
% end 
% % V_x = cross(vi(:, 1), v(:, 1));
% % V_y = cross(vi(:, 2), v(:, 2));
% % V_z = cross(vi(:, 3), v(:, 3));
% %V = [V_x; V_y; V_z];
% 
% [max_U, max_U_idx] = max(U);
% [min_U, min_U_idx] = min(U);
% 
% [max_V, max_V_idx] = max(V);
% [min_V, min_V_idx] = min(V);
% 
% corners_maxmax = o + max_U + max_V;
% corners_maxmin = o + max_U + min_V;
% corners_minmax = o + min_U + max_V;
% corners_minmin = o + min_U + min_V;
% %plane_points = [ plane_points_x; plane_points_y; plane_points_z ]; 
% 
% region_plane = [corners_maxmax; corners_maxmin; corners_minmax; corners_minmin];


beta = [];
gamma = [];

uv_test = []; 
sec_mat = [];
beta_gamma = [];

% for w = 1:length(test_array_points)
%     beta(w, :) = dot(u(w, :), normal);
% end  
% 
% for w = 1:length(test_array_points)
%     gamma(w, :) = dot(v(w, :), normal);
% end  
for w = 1:length(test_array_points)
    uv_test = [u(1) v(1); u(2) v(2)];
    sec_mat = [ui(w, 1) - o(:, 1); ui(w, 2) - o(:, 2)];
    beta_gamma(w, :) = inv(uv_test) * sec_mat;
end 

beta = beta_gamma(:, 1); 
gamma = beta_gamma(:, 2);
% for h = 1:length(test_array_points)
%     U(h, :) = beta(h) * u;
%     V(h, :) = gamma(h) * v;
% end 
beta_min = min(beta);
beta_max = max(beta);
gamma_min = min(gamma);
gamma_max = max(gamma);
max_U = beta_max * u;
min_U = beta_min * u;

max_V = gamma_max * v;
min_V = gamma_min * v;

% [max_U, max_U_idx] = max(U);
% [min_U, min_U_idx] = min(U);
% 
% [max_V, max_V_idx] = max(V);
% [min_V, min_V_idx] = min(V);

corners_maxmax = o + max_U + max_V;
corners_maxmin = o + max_U + min_V;
corners_minmax = o + min_U + max_V;
corners_minmin = o + min_U + min_V;

% corners_maxmax2 = o + max_V + max_U;
% corners_maxmin2 = o + max_V + min_U;
% corners_minmax2 = o + max_V + max_U;
% corners_minmin2 = o + min_V + min_U;

region_plane = [corners_maxmax; corners_maxmin; corners_minmin; corners_minmax ];
f = [1, 2, 3, 4];
special_handle = patch('Faces',f,'Vertices',region_plane, 'FaceColor', macro_region_colour);

    %special_handle = surf(xx,yy,z);
    if(geo_struct.segmentation__region_plane_draw.invisible)
        alpha 0.1;
    end 
    special_props = [orientations(end).region_idx, orientations(end).strike, orientations(end).strike2, orientations(end).dip, orientations(end).dip2 ,orientations(end).dip_direction, orientations(end).dip_direction2];
    set(special_handle,'UserData', special_props);
    set(special_handle,'ButtonDownFcn', @ancillary__click_callback);
end 

%--------------------------------------------------------------------------
% Remove the best fit planes 
%--------------------------------------------------------------------------
if(geo_struct.segmentation__region_plane_draw.remove_bf_planes)
    for j = 1:length(planes)
    han__seg_plane_draw = planes(j).han__seg_plane_draw;
    idx__seg_plane_draw = planes(j).idx__seg_plane_draw;
        if(ishandle(han__seg_plane_draw))
            %pause(1);
            % delete the previous index of the plane on the current plot
            delete(han__seg_plane_draw);
        end
    end 
end
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------

saveas(gcf, [geo_struct.output_folder, geo_struct.stats.experiment, '\', geo_struct.stats.experiment, '__seg_rg_draw', geo_struct.stats.figure_ext]);

disp('Execution complete. Function macro_plane__draw.m terminating.');
return;
end 