%% calculation__strike_and_dip.m (Plane Fit functions)
function [radians__strike, degrees__strike, radians__dip_direction, degrees__dip_direction, radians__dip_angle, degrees__dip_angle, sigma, centeroid, direction_cosines] = calculation__strike_and_dip(points, var__normal)
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
% -------------------------------------------------------------------------

d = [];
angular_constant = [];
sigma = [];
centeroid = [];
direction_cosines = [];
radians__dip_direction = [];
radians__dip_angle = [];
radians__strike = [];
degrees__dip_direction = [];
degrees__dip_angle = [];
degrees__strike = [];
%--------------------------------------------------------------------------
% Call lsplane 
%--------------------------------------------------------------------------

[centeroid, direction_cosines, residuals, norm_of_resid_errors] = best_fit_plane__lsplane(points);

point = centeroid;
point = point'; 

if(~isempty(direction_cosines))

    kappa = var__normal(1)/sqrt(var__normal(1)^2 + var__normal(2)^2); % [2]
    acos_kappa = acosd(kappa); % [2]

    % This is the alternative angles from Measuring fracture orientations paper
    d = -point*var__normal; % dot product for less typing 
    if(d < 0) % [2]
        cos_alpha = var__normal(1)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
        cos_beta = var__normal(2)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
        cos_gamma = var__normal(3)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
    elseif(d >= 0) % [2]
        cos_alpha = var__normal(1)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
        cos_beta = var__normal(2)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2);
        cos_gamma = var__normal(3)/-sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2); 
    end
    
    if(cos_gamma >= 0 && cos_beta >= 0) % [2]
        dip_direction = acos_kappa;
    elseif(cos_gamma >= 0 && cos_beta < 0) % [2]
        dip_direction = 360 - acos_kappa;
    elseif(cos_gamma < 0 && cos_beta >= 0) % [2]
        dip_direction = 180 + acos_kappa;
    elseif(cos_gamma < 0 && cos_beta < 0) % [2]
        dip_direction = 180 - acos_kappa;
    else
        disp('error. theres a problem with angles');
    end 
    
    dip = abs(var__normal(3)/sqrt(var__normal(1)^2 + var__normal(2)^2 + var__normal(3)^2));
    dip = acosd(dip); % [2]
    strike = dip_direction - 90; % [2]
    %    if not 
    if(strike < 0)
        degrees__strike = 360 + strike;
        radians__strike = degrees__strike * 3.1459/180;
    else
        radians__strike = strike * 3.1459/180;
        degrees__strike = strike;
    end
    degrees__dip_angle = dip;
    degrees__dip_direction = dip_direction;
    
    % convert to radians    
    radians__dip_direction = degrees__dip_direction * 3.1459/180;
    radians__dip_angle = degrees__dip_angle * 3.1459/180;
    if(isempty(degrees__strike))
       disp('Degrees are empty Jim!!!'); 
    end
else
    sigma = 0; 
    centeroid = 0;
    direction_cosines = 0;
    radians__dip_direction = 0;
    radians__dip_angle = 0;
    radians__strike = 0;
    degrees__dip_direction = 0;
    degrees__dip_angle = 0;
    degrees__strike = 0;
    disp('calculation__strike_and_dip.m - Not enough points to derive the direction cosines, dip or dip directions.');
    if(isempty(degrees__strike))
       disp('Degrees are empty Jim!!!'); 
    end
end
if(isempty(degrees__strike))
   disp('Degrees are empty!!!'); 
end
%--------------------------------------------------------------------------
% Terminate
%--------------------------------------------------------------------------
disp('Execution complete. Function calculation__strike_and_dip.m terminating.');    
return;
end 

% degrees to radians conversion
% radians = 360 * 3.1459/180; % for 360 degrees 
% degrees = 4 * 180/3.1459; % for 4pi radians 
% (360 * 2) + 90 = 810 maximum error (degrees)
% (2*pi * 2) + pi/2 = 14.1308 maximum error (radians)
