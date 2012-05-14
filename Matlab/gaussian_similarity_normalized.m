function data = gaussian_similarity_normalized (data, metric, sigma)

% compute a gaussian similarity matrix using a possibly 
% different metric in each coordinate.
% the metric must be given as a cell array of function handles

% compute the distance matrix for each coordiante

[n p] = size(data.pts);

Dist_matrix = zeros(n);

for i=1:p
    Dist_matrix_temp = zeros(n);
    for j=1:n-1
        for k=j+1:n
            Dist_matrix_temp(j,k) = metric{i}(data.pts(j,i), data.pts(k,i));
        end
    end
    if  max (max (Dist_matrix_temp)) > 0
        Dist_matrix = Dist_matrix + Dist_matrix_temp / max (max (Dist_matrix_temp));
    end
end

if (nargin == 2)
    sigma = av_min_dist(Dist_matrix);
end

A=zeros(n);
for i=1:n-1
    for j=i+1:n
        A(i,j) = exp( -0.5*( (Dist_matrix(i,j))/sigma )^2);
    end
end
A = A + A';

data.Aff = A;
data.inform = [data.inform, 'Similarity: gaussian, sigma = ', num2str(sigma)];


function sigma = av_min_dist(Dist_matrix)

n = size (Dist_matrix, 1);

minima = zeros(n,1);

for i=1:(n-1)
    minima(i) = min(Dist_matrix(i, (i+1):(n)));
end

sigma = sum(minima) / n;