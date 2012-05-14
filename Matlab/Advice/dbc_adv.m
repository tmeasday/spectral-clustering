function [cluster, slacks] = dbc_adv(clusterin, f, vxmeasure)

% dbc-based bi-clustering with advice. 
% arguments:
% 1. cluster structure
% 2. a non-negative parameter for the advice-based constraints 
% 3. a vertex measure (optimal)

cluster.data = clusterin.data;
cluster.Advice = clusterin.Advice;
cluster.adv_name = clusterin.adv_name;

A = clusterin.data.Aff;
Advice = clusterin.Advice;

if nargin == 2
    vxmeasure = sum (A, 2);
end

% find coordinates so the advice is in blocks.
[MB, partition] = to_block_form(Advice);

% now set up the SDP

n = size(A,1);

% form the Laplacian of A
D = diag (sum (A,2));
LA = D - A;

% form the Laplacian of vxmeasure * vxmeasure'
vol = sum(vxmeasure);
Lv = vol * diag (vxmeasure) - vxmeasure * vxmeasure';

% number of non-trivial advice blocks
final_part = {};
for i = 1:length(partition)
    if (length (partition{i}) > 1)
        final_part = [final_part, partition{i}];
    end
end
num_blocks = length (final_part);

% number of constraints and variables
num_constr = 1 + n + num_blocks;
num_vars  = 1 + n^2 + num_blocks;

Constr = sparse (num_constr, num_vars);

Constr(1,:) = sparse([0; zeros(num_blocks, 1); Lv(:)]');

for i=1:n
    Ei = sparse(n,n);
    Ei(i,i) = 1;
    Constr(i+1,:) = sparse([-1; zeros(num_blocks, 1); Ei(:)]');
end

for i=1:num_blocks
    MBi = MB(final_part{i}, final_part{i});
    
    [opt cost] = twoCC(MBi, 'SDP');
    ei = zeros(num_blocks, 1);
    ei(i) = 1;
    M = sparse(n,n);
    M(final_part{i}, final_part{i}) = MBi;
    Constr(i+(n+1), :) = sparse([-(1+f) * cost; ei; M(:)]');
end

b = zeros(num_constr, 1);
b(1) = vol;
   
% variable types
K.f = 1; % free variable is q
K.l = num_blocks; % a slack variable for each advice-constraint
K.q = 0;
K.r = 0;
K.s = n;

[X, y, info] = sedumi(Constr, b, [0; zeros(num_blocks, 1); LA(:)], K);

q = X(1);
slacks = X(2:(num_blocks+1));
X = X((num_blocks+2):end); % get rid of the slack and free variables
X = reshape(X,n,n);

[U,S] = eig(X);
cluster.V = U * sqrt(S) * U';

% then cluster the transformed points and go from k-means coordinates to
% plus or minus one coordinates.
cluster.Y = (kmeans (cluster.V, 2)) * 2 - 3;

cluster.inform.Aff = []; % this needs to be fixed.
cluster.inform.alg = ['dbc_adv',num2str(f)];
cluster.inform.round = {'k-means'};
cluster.inform.Adv = clusterin.inform.Adv;

if all(vxmeasure == ones(n,1))
    cluster.inform.obj = 'Ratio-cut';
elseif all(vxmeasure == sum (A, 2))
    cluster.inform.obj = 'Normalized-cut';
else
    cluster.inform.obj = 'Other vx measure';
end









