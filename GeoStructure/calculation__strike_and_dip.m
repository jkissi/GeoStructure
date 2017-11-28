%% calculation__strike_and_dip.m (Plane Fit functions)
function [strike, strike2, dip_direction, dip_direction2, dip, dip2, sigma, centeroid, direction_cosines] = calculation__strike_and_dip(points, var__normal)
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
% points :: matrix of the xyz coords of the points
%
% [1] Semi-automatic extraction of rock mass structural data from high 
% resolution LIDAR point clouds - Gigli 
% [2] Measuring fracture orientation at exposed rock faces by using a 
% non-reflector total station - Feng 


d = [];
dip_direction = [];
dip = [];
angular_constant = [];
sigma = [];
centeroid = [];
direction_cosines = [];

%--------------------------------------------------------------------------
% Call lsplane 
%--------------------------------------------------------------------------
[centeroid, direction_cosines, residuals, norm_of_resid_errors] = lsplane2(points);
point = centeroid;
point = point'; 

if(~isempty(direction_cosines))
    

l = direction_cosines(1); % [1]
m = direction_cosines(2); % [1]
n = direction_cosines(3); % [1]

x_cosine = l; % [1]
y_cosine = m; % [1]
z_cosine = n; % [1]

if((x_cosine > 0) && (y_cosine > 0)) % [1]
    angular_constant = 0; 
end 

if((x_cosine > 0) && (y_cosine < 0)) % [1]
    angular_constant = 360; 
end 

if((x_cosine < 0) && (y_cosine > 0)) % [1]
    angular_constant = 180; 
end 

if((x_cosine < 0) && (y_cosine < 0)) % [1]
    angular_constant = 180; 
end 

%% Attempt at alternative angles % [2]

kappa = var__normal(1)/sqrt(var__normal(1)^2 + var__normal(2)^2); % [2]
cos_kappa = cosd(kappa); % [2]
acos_kappa = acosd(kappa); % [2]




dip_direction = atand(y_cosine/x_cosine) + angular_constant; % [1]
dip = atand(z_cosine/sqrt(x_cosine^2 + y_cosine^2)); % [1]
strike = dip_direction - 90; % [1]

% This is the alternative angles from Measuring fracture orientations paper
d = -point*var__normal; % dot product for less typing 
if(d < 0) % [2]
cos_alpha = var__normal(1)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
cos_alpha = cosd(cos_alpha); % [2]
cos_beta = var__normal(2)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
cos_beta = cosd(cos_beta); % [2]
cos_gamma = var__normal(3)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
cos_gamma = cosd(cos_gamma); % [2]
elseif(d >= 0) % [2]
cos_alpha = var__normal(1)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
cos_alpha = cosd(cos_alpha); % [2]
cos_beta = var__normal(2)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
cos_beta = cosd(cos_beta); % [2]
cos_gamma = var__normal(3)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2); 
cos_gamma = cosd(cos_gamma); % [2]
end
% dip_direction2 = acosd(y_cosine/x_cosine) + angular_constant;
if(cos_gamma >= 0 && cos_beta >= 0) % [2]
    dip_direction2 = acos_kappa;
elseif(cos_gamma >= 0 && cos_beta < 0) % [2]
    dip_direction2 = 360 - acos_kappa;
elseif(cos_gamma < 0 && cos_beta >= 0) % [2]
    dip_direction2 = 180 + acos_kappa;
elseif(cos_gamma < 0 && cos_beta < 0) % [2]
    dip_direction2 = 180 - acos_kappa;
else
    disp('error. theres a problem with angles');
end 
% [2]
dip2 = abs(var__normal(3)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2));
dip2 = acosd(dip2); % [2]
strike2 = dip_direction2 - 90; % [2]
else
    sigma = 0; 
    centeroid = 0;
    direction_cosines = 0;
    dip_direction = 0;
    dip = 0;
    strike = 0;
    dip_direction2 = 0;
    dip2 = 0;
    strike2 = 0;
    disp('best_fit_plane__find_orientation.m - Not enough points to derive the direction cosines, dip or dip directions.');
end

%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__find_orientation.m terminating.');
return;
end 


% xyz = points;
% %find the average of the points within the bounding cube
% x_vals = xyz(:,1);
% y_vals = xyz(:,2);
% z_vals = xyz(:,3);
% 
% A = [x_vals y_vals ones(size(x_vals))];
% 
% b = z_vals;
% 
% sol=A\b;
% m = sol(1);
% n = sol(2);
% c = sol(3);
% 
% errs = (m*x_vals + n*y_vals + c) - z_vals;
% 
% sigma = std(errs);