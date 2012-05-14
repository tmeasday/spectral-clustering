function R = corr_clustering(Advice)

[MB, partition] = to_block_form(Advice);

n = size(MB,1);

R = sparse(n,length(partition));

% perform correlation clustering on each block.
for i=1:length(partition)
    if length(partition{i}) > 1
        length(partition{i})
    end
    if length(partition{i}) <= 2
        v = exhaustive_2CC(MB(partition{i},partition{i}));
    else
        if length(partition{i}) > 20 
            warning ('this is a large block: consider aborting mission');
            % delete an edge of the advice
            vx = partition{i}(1);
            nbs = find(Advice(:,vx) + Advice(vx,:)');
            nb = nbs(1);
            Advice(vx,nb) = 0;
            Advice(nb,vx) = 0;
            % now do CC on the resulting graph. Note that we know that 
            % Advice(partition{i}) is connected so this should only
            % return a single vector.
            v = corr_clustering_sparse(Advice(partition{i},partition{i}));
        else
        v = twoCC_tri(MB(partition{i}, partition{i}));
        end
    end
    R(partition{i},i) = v; 
end
