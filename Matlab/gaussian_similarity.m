function data = gaussian_similarity (data, sigma, metric)

% compute a gaussian similarity matrix using a general metric.
% if no metric specified use the 2-norm.
% the metric must be given as a function handle

if nargin <= 2
    metric = @(x,y) norm(x - y);
end
if (nargin == 1 || isempty(sigma))
        sigma = av_min_dist(data, metric);
end

[n,k] = size (data.pts);

A=zeros(n);
for i=1:n
    for j=1:n
        A(i,j) = exp( -0.5*( metric(data.pts(i,:), data.pts(j,:))/sigma )^2);
    end
end
A = A - eye(n);

data.Aff = A;
data.inform = [data.inform, 'Similarity: gaussian, sigma = ', num2str(sigma)];

function sigma = av_min_dist(data, metric)

n = size (data.pts, 1);

Distances = zeros(n);
minima = zeros(n,1);

for i=1:(n-1)
    for j=(i+1):(n)
        Distances(i,j) = metric (data.pts(i,:), data.pts(j,:));
    end
    minima(i) = min(Distances(i, (i+1):(n)));
end

sigma = sum(minima) / n;
