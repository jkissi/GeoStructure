  function [x0, a, d, normd] = lsplane2(X)
%---------------------------------------------------------------------
% LSPLANE.M Least-squares plane (orthogonal distance
% regression).
%
% Version 1.0
% Last amended I M Smith 27 May 2002.
% Created I M Smith 08 Mar 2002
%---------------------------------------------------------------------
% Input
% X Array [x y z] where x = vector of x-coordinates,
% y = vector of y-coordinates and z = vector of
% z-coordinates.
% Dimension: m x 3.
%
% Output
% x0: Centroid of the data = point on the best-fit plane.
% Dimension: 3 x 1.
%
% a: Direction cosines of the normal to the best-fit
% plane.
% Dimension: 3 x 1.
%
% <Optional...
% d: Residuals.
% Dimension: m x 1.
%
% normd: Norm of residual errors.
% Dimension: 1 x 1.
% ...>
%
% [x0, a <, d, normd >] = lsplane(X)
%---------------------------------------------------------------------
% set all the output vars to empty 
x0 = []; 
a = []; 
d = [];
normd = [];
% check number of data points
  m = size(X, 1);
  if(m < 3) % if the number of data points is less than 3, throw a message
    disp(['At least 3 data points required, you only have ', num2str(m),...
        'The values are: ', mat2str(X),'. The SVD cant be done']);

  else
%
% calculate centroid
  x0 = mean(X)'; % modified to take an average of each coord vector

% form matrix A of translated points
  A = [(X(:, 1) - x0(1)) (X(:, 2) - x0(2)) (X(:, 3) - x0(3))];

% calculate the SVD of A
  [U, S, V] = svd(A, 0);
%
% find the smallest singular value index in the scaling factor 'S' and 
% extract from the initial rotation vector 'V' the right singular vector
% (direction cosines) using the index
  [s, i] = min(diag(S));
  a = V(:, i);
%
% calculate residual distances, if required
  if nargout > 2
    d = U(:, i)*s;
    normd = norm(d);
  end
  end
  end
%---------------------------------------------------------------------
% End of LSPLANE.M.

