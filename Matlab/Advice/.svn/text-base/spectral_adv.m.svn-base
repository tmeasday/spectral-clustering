function cluster = spectral_adv(clusterin, f, mode, vxmeasure)

% spectral bi-clustering with advice. 
% arguments:
% 1. A "data" structure
% 2. a vertex measure (optional)
% 3. an Advice matrix 
% 4. a number of eigenvalues to keep for blocks of inconsistent advice.

datain = clusterin.data;
Advice = clusterin.Advice;

if nargin <= 3
    vxmeasure = sum (datain.Aff, 2);
    if nargin <=2
        mode = 'spectral';
    end
end

cluster.data = datain;
cluster.Advice = Advice;
cluster.adv_name = clusterin.adv_name;

% perform spectral clustering into k clusters

% first transform the points spectrally
cluster.V = spectral_transform_adv (datain.Aff, Advice, f, vxmeasure, mode);

% then cluster the transformed points and go from k-means coordinates to
% plus or minus one coordinates.
cluster.Y(:,1) = (kmeans (cluster.V, 2, 'EmptyAction', 'singleton')) * 2 - 3;
cluster.Y(:,2) = 2 * (cluster.V > 0) - 1;
cluster.Y(:,3) = cheapest_cut (cluster.V, datain.Aff, vxmeasure);

cluster.inform.Aff = []; % this needs to be fixed.
cluster.inform.alg = ['spectral_adv', num2str(f)];
cluster.inform.round = {'k-means', 'cut-at-zero', 'min-cut'};
cluster.inform.Adv = clusterin.inform.Adv;

n = size(datain.Aff, 1);

if all(vxmeasure == ones(n,1))
    cluster.inform.obj = 'Ratio-cut';
elseif all(vxmeasure == sum (datain.Aff, 2))
    cluster.inform.obj = 'Normalized-cut';
else
    cluster.inform.obj = 'Other vx measure';
end



function y = cheapest_cut(V, Aff, mu)

% search through all possible cuts and find the one with the lowest N-cut
% value.

n = length(V);

[V_sorted, idx] = sort(V);
Aff_sorted = Aff(idx, idx);
mu_sorted = mu(idx);

y = ones(n,1);
den1 = 0;
den2 = sum(mu_sorted);
cost = zeros(n-1,1);

for i=1:(n-1)
    y(i) = -1;
    num = y' * (diag(Aff_sorted*ones(n,1)) - Aff_sorted) * y;
    den1 = den1 + mu_sorted(i);
    den2 = den2 - mu_sorted(i);
    cost(i) = num / (den1 * den2);
end
[min_cost, index] = min(cost);
y = [ones(index,1); -ones(n-index, 1)];

y(idx) = y;
    

