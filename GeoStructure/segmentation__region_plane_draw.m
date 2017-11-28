%% best_fit_plane__draw.m (Plane Fit functions)
function [ ] = segmentation__region_plane_draw(vec__point, var__normal, planes, macro_region_colour, test_array_points, special_idx, strike, strike2, dip, dip2, dip_direction, dip_direction2)
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
point = vec__point;
normal = var__normal;
x = test_array_points(:, 1)';
y = test_array_points(:, 2)';
% zzz = test_array_points(:, 3)';
%# a plane is a*x+b*y+c*z+d=0
%# [a,b,c] is the normal. Thus, we have to calculate
%# d and we're set
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
    disp('Óne of the dimensions is equal to 1, so no surf');
else
    special_handle = surf(xx,yy,z);
    special_props = [special_idx, strike, strike2, dip, dip2 ,dip_direction, dip_direction2];
    set(special_handle,'UserData', special_props);
%     addproperty(special_handle,'special_idx')
%     addproperty(special_handle,'strike')
%     addproperty(special_handle,'strike2')
%     addproperty(special_handle,'dip')
%     addproperty(special_handle,'dip2')
%     addproperty(special_handle,'dip_direction')
%     addproperty(special_handle,'dip_direction2')
%     special_handle.special_idx = special_idx;
%     special_handle.strike = strike;
%     special_handle.strike2 = strike2;
%     special_handle.dip = dip;
%     special_handle.dip2 = dip2;
%     special_handle.dip_direction = dip_direction;
%     special_handle.dip_direction2 = dip_direction2;
    set(special_handle,'ButtonDownFcn', @ImageClickCallback);
    %special_idx, strike, strike2, dip, dip2, dip_direction, dip_direction2
end 

% if((size(z, 1) == 1) | (size(z, 2) == 1))
%     disp('Óne of the dimensions is equal to 1, so no surf');
% else
%     surf(xx,yy,z);
% end 
%--------------------------------------------------------------------------
% Remove the best fit planes 
%--------------------------------------------------------------------------

for j = 1:length(planes)
%find_idx = find(region_array(:, 2) == angle_comparison, 'first');
han__seg_plane_draw = planes(j).han__seg_plane_draw;
idx__seg_plane_draw = planes(j).idx__seg_plane_draw;
if(ishandle(han__seg_plane_draw))
    %pause(1);
    % delete the previous index of the plane on the current plot
    delete(han__seg_plane_draw);
end
end 
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function macro_plane__draw.m terminating.');
return;
end 