function R = subspace_trick(Advice, f, mode)

if strcmp(mode, 'noadvice')
    R = eye(size(Advice,2));
    return;
elseif strcmp(mode, '2CC-tri')
    R = corr_clustering(Advice);
    return;
elseif strcmp(mode, '2CC-complete')
    R = corr_clustering_complete(Advice);
    return;
elseif strcmp(mode, '2CC-sparse')
    R = corr_clustering_sparse(Advice);
    return;
end

% given an Advice matrix and a non-negative parameter, returns an
% orthonormal basis for the <= lambda_min + f eigenspace of each 
% advice block matrix.

% run to_block_form
[MB, partition] = to_block_form(Advice);

% loop over the partition: for each partition, run correlation
% clustering with leeway = f.

n = size(MB,1);
R = [];
col = 1;
for i=1:length(partition)
    MBi = MB(partition{i}, partition{i});
    [opt cost] = twoCC(MBi, mode, f);
    
    m = size (opt, 2);
    R(:,col:col+(m-1)) = zeros(n,m);
    R(partition{i},col:col+(m-1)) = opt;
    
    col = col + m; 
end