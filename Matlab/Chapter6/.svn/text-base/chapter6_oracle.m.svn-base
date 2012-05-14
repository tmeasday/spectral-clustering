function X = chapter6_oracle(A, b)

% solve the feasibility problem: does there exist an 
% X in P? (some convex set with few constraints)

% P described by:
% for all j, trace ( A_j * X ) >= b
% X positive semi-definite

% In this implementation we use SeDuMi to do this. 
% There are probably more appropriate ways.

small_thing = 10^(-6);
[m n] = size (A);

% we are solving a feasibility problem 
objective = zeros (n,1);


% All constraints are inequalities. Add slack variables to constraints 
% to keep SeDuMi happy 
A = [A -eye(m)];

% variables consist of one n x n PSD matrix and 
% m non-negative slack variables.

K.l = m;
K.s = n^2;

[X,Y,INFO] = sedumi(A, b, objective, K);

if abs (INFO.feasratio + 1) < small_thing
    % problem is infeasible
    X = [];
    return;
elseif
    abs (INFO.feasratio - 1) < small_thing
    % problem is feasible
    X = reshape (X(1:n^2), n, n);
    return;
else
    warning('problem is neither clearly feasible nor clearly infeasible.');
    return;
end

