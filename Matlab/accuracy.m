function score = accuracy(cluster)

% this function computes an "accuracy" measure of a clustering according
% to the method in Xing, Ng, Jordan, and Russell, "Distance metric learning
% with application to clustering with side-information", NIPS, 2002.
% Note that this is exactly the "Rand-index" from W. M. Rand, "Objective
% criteria for the evaluation of clustering methods." 
% Journal of the American Statistical Association, 66, pp846–850 (1971).


labels = cluster.data.lbls;
Y = cluster.Y;
n = length (labels);
m = size (Y,2);
score = zeros (1,m);

for k=1:m
    for j=1:n-1
        for i=(j+1):n
            score(k) = score(k) + ...
                ( (labels(i) == labels(j)) == (Y(i,k) == Y(j,k)) );
        end
    end
end

score = score / (0.5 * n * (n-1));
        