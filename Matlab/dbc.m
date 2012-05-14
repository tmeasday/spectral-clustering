function [y] = dbc (A, opts, Constraints, cfactor)

% The De Bie and Cristianini sdp. 

% A is an affinity matrix.
% opts is a string of the form '[u|{b}][{c}|o]' where:
% -- 'u' indicates that q is unbounded above, 
%    'b' indicates that we use the upper bound on q 
% -- 'c' indicates that constraints are added in the SDP constraints
%    'o' indicates that constraints are added in the SDP objective 
% Constraints is a sparse matrix such that [Constraints]_{i,j} = 1 if we
% want i and j to be in the same cluster, -1 if we want i and j in
% different clusters, 0 if we don't care.
% cfactor indicates how hard we want to try to satisfy the constraints. 
% If cfactor = 0, we ignore the constraints. If cfactor = 1, we try very
% hard to satisfy the constraints. 

[n,m] = size (A);

if nargin <= 1
    opts = 'bc';
end
if nargin <= 2
    Constraints = sparse(n,n);
    cfactor = 0;
end
if nargin == 3
        cfactor = 1;
end
    
d = sum(A,2);
D = diag (d);

L = D - A;
s = sum(sum(D));

vol_diff = (d*d')/s^2;

d_sorted = sort (d);
upper_bound = ( s^2 / ( 4 * d_sorted(1) * sum (d_sorted(2:end)) ) );

num_Constraints = sum(sum(abs(Constraints)));

% variable is [q; x; y; Gamma(:)] where 
% x = upper_bound - q  
% y = Constraints(:)' * Gamma(:) - cfactor * num_Constraints

numvars = n^2 + 3;

% the standard constraints
numcons = n + 3;
constr = sparse (numcons, numvars);
for i=1:n
    Ei = sparse(n,n);
    Ei(i,i) = 1;
    constr(i,:) = sparse([-1 0 0 Ei(:)']);
end
constr(n + 1,:) = sparse([1 1 0 zeros(1, n^2)]);
constr(n + 2,:) = sparse([-1 0 0 vol_diff(:)']);
constr(n + 3,:) = sparse([0 0 -1 Constraints(:)']);

b = sparse([zeros(n,1); upper_bound; -1; cfactor*num_Constraints]);

% this will be modified later if constraints are in the objective
objective = [0; 0; 0; L(:)/s]; 

if any ( 'o' == opts )         % constraints in SDP objective 
    if any ( 'u' == opts )     % q unbounded 
        K.f = 3;               % q, x, y free
        K.l = 0;
    else                       % q bounded
        % swap order of variables x and y
        constr(:,[2,3]) = constr(:, [3,2]);
        objective([2,3]) = objective([3,2]);
        K.f = 2;               % q, y free
        K.l = 1;               % x >= 0
    end
    objective = objective - [0; 0; 0; Constraints(:)];  % may need to be rescaled
else                           % constraints in SDP constraints 
    if any ( 'u' == opts )     % q unbounded
        K.f = 2;               % q, x free
        K.l = 1;               % y >= 0
    else                       % q bounded
        K.f = 1;               % q free
        K.l = 2;               % x, y >= 0
    end
end

K.q = 0;
K.r = 0;
K.s = [n];


[Optimum dual_stuff info] = sedumi(constr,b,objective,K);

cost = objective'*Optimum;

% get the PSD matrix out of the optimal primal "point"
Gamma = Optimum(4:end);
q = Optimum(1);
objective = objective(4:end);

% un-normalize Gamma
Gamma = Gamma / q;

% this may have the wrong scaling when constraints added to the objective
cost_func = @(x) ( objective'*x ) / ( 1 - vol_diff(:)'*x);

% get an answer
y = cluster_from_psd (mat(Gamma,n), cost_func);
