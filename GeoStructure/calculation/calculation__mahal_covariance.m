% -------------------------------------------------------------------------
% calculation__mahal_covariance function
% -------------------------------------------------------------------------
function [ C ] = calculation__mahal_covariance(X)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to calculate the covariance of a mahalanobis distance 
% -------------------------------------------------------------------------


% Get covariance given data matrix X (row = object, column = feature)
[ n, k ] = size(X);
Xc = X-repmat(mean(X), n, 1); % centered data
C = Xc'*Xc/n;                 % covariance


disp('Execution complete. Function calculation__mahal_covariance.m terminating.');
% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
end 