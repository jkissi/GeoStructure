% -------------------------------------------------------------------------
% best_fit_plane__affine_fit function
% -------------------------------------------------------------------------
function [n,V,p] = best_fit_plane__affine_fit(X)
%% ------------------------------------------------------------------------
% Discussion
% -------------------------------------------------------------------------
% Function modified version of original work done by Adrien Leygue (August
% 30 2013). Description follows:

% Computes the plane that fits best (least square of the normal distance
% to the plane) a set of sample points.
% INPUTS:
% X: a N by 3 matrix where each line is a sample point
%
% OUTPUTS:
% n : a unit (column) vector normal to the plane
% V : a 3 by 2 matrix. The columns of V form an orthonormal basis of the
% plane p : a point belonging to the plane
%
% NB: this code actually works in any dimension (2,3,4,...)
% Author: Adrien Leygue
% Date: August 30 2013
% -------------------------------------------------------------------------

%the mean of the samples belongs to the plane
p = mean(X,1);

%The samples are reduced:
R = bsxfun(@minus,X,p);

%Computation of the principal directions of the samples cloud
[V,D] = eig(R'*R);

%Extract the output from the eigenvectors
n = V(:,1);
V = V(:,2:end);


% -------------------------------------------------------------------------
% Terminate 
% -------------------------------------------------------------------------
disp('Execution complete. Function best_fit_plane__affine_fit.m terminating.');
end