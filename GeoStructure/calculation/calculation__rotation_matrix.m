function [ rot_matrix ] = rotation_matrix(normal, angle)
%%
% Generates rotation matrix on an axis for a given angle

I = eye(3);
X = [0 -normal(3) normal(2) ; normal(3) 0 -normal(1) ; -normal(2) normal(1) 0];
omega_hat = X;
theta = angle;

rot_matrix = I + omega_hat*sind(theta) + omega_hat^2*(1 - cosd(theta));

disp('Execution complete. Function rotation_matrix.m terminating.');
end