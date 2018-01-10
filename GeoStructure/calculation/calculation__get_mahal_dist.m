% -------------------------------------------------------------------------
% calculation__get_mahal_dist function
% -------------------------------------------------------------------------
function [ d ] = calculation__get_mahal_dist(A, B) 
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function to calculate the Mahalanobis distance between two points 
% Return mahalanobis distance of two data matrices A and B
% -------------------------------------------------------------------------

[ n1, k1 ] = size(A);
[ n2, k2 ] = size(B);
n = n1 + n2;
if(k1 ~= k2)
    disp('number of columns of A and B must be the same');
else
    xDiff = mean(A) - mean(B); % mean diff row vector
    cA = calculation__mahal_covariance(A);
    cB = calculation__mahal_covariance(B);
    pC = n1/n*cA + n2/n*cB; % pooled covariance matrix
    d = sqrt(xDiff*inv(pC)*xDiff'); % mahal distance calculation
    
end

disp('Execution complete. Function calculation__get_mahal_dist.m terminating.');
% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
end 