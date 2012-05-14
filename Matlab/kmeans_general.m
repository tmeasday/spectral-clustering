function [idx, C, sumD, D] = kmeans_general(X, k, normf, varargin)

% This function has been stolen from the matlab library, and converted to a
% form that is more usable for me. Ignore the comments below--some of this
% may no longer apply. All of this is is a bit of a hack...


% just use the defaults dammit
start = 'sample';
reps = [];
maxit = 100;
emptyact = 'error';
display = 'notify';
distance = '';



if nargin < 3
    error('stats:kmeans:TooFewInputs','At least two input arguments required.');
end

% n points in p dimensional space
[n, p] = size(X);
Xsort = []; Xord = [];


if ischar(start)
    startNames = {'uniform','sample','cluster'};
    i = strmatch(lower(start), startNames);
    if length(i) > 1
        error('stats:kmeans:AmbiguousStart', ...
              'Ambiguous ''start'' parameter value:  %s.', start);
    elseif isempty(i)
        error('stats:kmeans:UnknownStart', ...
              'Unknown ''start'' parameter value:  %s.', start);
    elseif isempty(k)
        error('stats:kmeans:MissingK', ...
              'You must specify the number of clusters, K.');
    end
    start = startNames{i};
    if strcmp(start, 'uniform')
        if strcmp(distance, 'hamming')
            error('stats:kmeans:UniformStartForHamm', ...
                  'Hamming distance cannot be initialized with uniform random values.');
        end
        Xmins = min(X,[],1);
        Xmaxs = max(X,[],1);
    end
elseif isnumeric(start)
    CC = start;
    start = 'numeric';
    if isempty(k)
        k = size(CC,1);
    elseif k ~= size(CC,1);
        error('stats:kmeans:MisshapedStart', ...
              'The ''start'' matrix must have K rows.');
    elseif size(CC,2) ~= p
        error('stats:kmeans:MisshapedStart', ...
              'The ''start'' matrix must have the same number of columns as X.');
    end
    if isempty(reps)
        reps = size(CC,3);
    elseif reps ~= size(CC,3);
        error('stats:kmeans:MisshapedStart', ...
              'The third dimension of the ''start'' array must match the ''replicates'' parameter value.');
    end
    
    % Need to center explicit starting points for 'correlation'. (Re)normalization
    % for 'cosine'/'correlation' is done at each iteration.
    if isequal(distance, 'correlation')
        CC = CC - repmat(mean(CC,2),[1,p,1]);
    end
else
    error('stats:kmeans:InvalidStart', ...
          'The ''start'' parameter value must be a string or a numeric matrix or array.');
end

if ischar(emptyact)
    emptyactNames = {'error','drop','singleton'};
    i = strmatch(lower(emptyact), emptyactNames);
    if length(i) > 1
        error('stats:kmeans:AmbiguousEmptyAction', ...
              'Ambiguous ''emptyaction'' parameter value:  %s.', emptyact);
    elseif isempty(i)
        error('stats:kmeans:UnknownEmptyAction', ...
              'Unknown ''emptyaction'' parameter value:  %s.', emptyact);
    end
    emptyact = emptyactNames{i};
else
    error('stats:kmeans:InvalidEmptyAction', ...
          'The ''emptyaction'' parameter value must be a string.');
end

if ischar(display)
    i = strmatch(lower(display), strvcat('off','notify','final','iter'));
    if length(i) > 1
        error('stats:kmeans:AmbiguousDisplay', ...
              'Ambiguous ''display'' parameter value:  %s.', display);
    elseif isempty(i)
        error('stats:kmeans:UnknownDisplay', ...
              'Unknown ''display'' parameter value:  %s.', display);
    end
    display = i-1;
else
    error('stats:kmeans:InvalidDisplay', ...
          'The ''display'' parameter value must be a string.');
end

if k == 1
    error('stats:kmeans:OneCluster', ...
          'The number of clusters must be greater than 1.');
elseif n < k
    error('stats:kmeans:TooManyClusters', ...
          'X must have more rows than the number of clusters.');
end

% Assume one replicate
if isempty(reps)
    reps = 1;
end

%
% Done with input argument processing, begin clustering
%

dispfmt = '%6d\t%6d\t%8d\t%12g';
D = repmat(NaN,n,k);   % point-to-cluster distances
Del = repmat(NaN,n,k); % reassignment criterion
m = zeros(k,1);

totsumDBest = Inf;
for rep = 1:reps
    switch start
    case 'uniform'
        C = unifrnd(Xmins(ones(k,1),:), Xmaxs(ones(k,1),:));
        % For 'cosine' and 'correlation', these are uniform inside a subset
        % of the unit hypersphere.  Still need to center them for
        % 'correlation'.  (Re)normalization for 'cosine'/'correlation' is
        % done at each iteration.
        if isequal(distance, 'correlation')
            C = C - repmat(mean(C,2),1,p);
        end
        if isa(X,'single')
            C = single(C);
        end
    case 'sample'
        C = X(randsample(n,k),:);
        if ~isfloat(C)      % X may be logical
            C = double(C);
        end
    case 'cluster'
        Xsubset = X(randsample(n,floor(.1*n)),:);
        [dum, C] = kmeans(Xsubset, k, varargin{:}, 'start','sample', 'replicates',1);
    case 'numeric'
        C = CC(:,:,rep);
    end    
    changed = 1:k; % everything is newly assigned
    idx = zeros(n,1);
    totsumD = Inf;
    
    if display > 2 % 'iter'
        disp(sprintf('  iter\t phase\t     num\t         sum'));
    end
    
    %
    % Begin phase one:  batch reassignments
    %
    
    converged = false;
    iter = 0;
    while true
        % Compute the distance from every point to each cluster centroid
        D(:,changed) = distfun(X, C(changed,:), normf, iter);
        
        % Compute the total sum of distances for the current configuration.
        % Can't do it first time through, there's no configuration yet.
        if iter > 0
            totsumD = sum(D((idx-1)*n + (1:n)'));
            % Test for a cycle: if objective is not decreased, back out
            % the last step and move on to the single update phase
            if prevtotsumD <= totsumD
                idx = previdx;
                [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
                iter = iter - 1;
                break;
            end
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,1,length(moved),totsumD));
            end
            if iter >= maxit, break; end
        end

        % Determine closest cluster for each point and reassign points to clusters
        previdx = idx;
        prevtotsumD = totsumD;
        [d, nidx] = min(D, [], 2);

        if iter == 0
            % Every point moved, every cluster will need an update
            moved = 1:n;
            idx = nidx;
            changed = 1:k;
        else
            % Determine which points moved
            moved = find(nidx ~= previdx);
            if length(moved) > 0
                % Resolve ties in favor of not moving
                moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));
            end
            if length(moved) == 0
                break;
            end
            idx(moved) = nidx(moved);

            % Find clusters that gained or lost members
            changed = unique([idx(moved); previdx(moved)])';
        end

        % Calculate the new cluster centroids and counts.
        [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
        iter = iter + 1;
        
        % Deal with clusters that have just lost all their members
        empties = changed(m(changed) == 0);
        if ~isempty(empties)
            switch emptyact
            case 'error'
                error('stats:kmeans:EmptyCluster', ...
                      'Empty cluster created at iteration %d.',iter);
            case 'drop'
                % Remove the empty cluster from any further processing
                D(:,empties) = NaN;
                changed = changed(m(changed) > 0);
                if display > 0
                    warning('stats:kmeans:EmptyCluster', ...
                            'Empty cluster created at iteration %d.',iter);
                end
            case 'singleton'
                if display > 0
                    warning('stats:kmeans:EmptyCluster', ...
                            'Empty cluster created at iteration %d.',iter);
                end
                
                for i = empties
                    % Find the point furthest away from its current cluster.
                    % Take that point out of its cluster and use it to create
                    % a new singleton cluster to replace the empty one.
                    [dlarge, lonely] = max(d);
                    from = idx(lonely); % taking from this cluster
                    C(i,:) = X(lonely,:);
                    m(i) = 1;
                    idx(lonely) = i;
                    d(lonely) = 0;
                    
                    % Update clusters from which points are taken
                    [C(from,:), m(from)] = gcentroids(X, idx, from, distance, Xsort, Xord);
                    changed = unique([changed from]);
                end
            end
        end
    end % phase one

    
    %
    % Begin phase two:  single reassignments
    %
    changed = find(m' > 0);
    lastmoved = 0;
    nummoved = 0;
    iter1 = iter;
    while iter < maxit
        % Calculate distances to each cluster from each point, and the
        % potential change in total sum of errors for adding or removing
        % each point from each cluster.  Clusters that have not changed
        % membership need not be updated.
        %
        % Singleton clusters are a special case for the sum of dists
        % calculation.  Removing their only point is never best, so the
        % reassignment criterion had better guarantee that a singleton
        % point will stay in its own cluster.  Happily, we get
        % Del(i,idx(i)) == 0 automatically for them.
		
        
        % TOM code
        for i = changed
            mbrs = (idx == i);
            sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
            if m(i) == 1
                sgn(mbrs) = 0; % prevent divide-by-zero for singleton mbrs
            end
            Del(:,i) = (m(i) ./ (m(i) + sgn)) .* (normf(X - C(repmat(i,n,1),:))).^2;
        end


        % Determine best possible move, if any, for each point.  Next we
        % will pick one from those that actually did move.
        previdx = idx;
        prevtotsumD = totsumD;
        [minDel, nidx] = min(Del, [], 2);
        moved = find(previdx ~= nidx);
        if length(moved) > 0
            % Resolve ties in favor of not moving
            moved = moved(Del((previdx(moved)-1)*n + moved) > minDel(moved));
        end
        if length(moved) == 0
            % Count an iteration if phase 2 did nothing at all, or if we're
            % in the middle of a pass through all the points
            if (iter - iter1) == 0 | nummoved > 0
                iter = iter + 1;
                if display > 2 % 'iter'
                    disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
                end
            end
            converged = true;
            break;
        end
        
        % Pick the next move in cyclic order
        moved = mod(min(mod(moved - lastmoved - 1, n) + lastmoved), n) + 1;
        
        % If we've gone once through all the points, that's an iteration
        if moved <= lastmoved
            iter = iter + 1;
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
            end
            if iter >= maxit, break; end
            nummoved = 0;
        end
        nummoved = nummoved + 1;
        lastmoved = moved;
        
        oidx = idx(moved);
        nidx = nidx(moved);
        totsumD = totsumD + Del(moved,nidx) - Del(moved,oidx);
        
        % Update the cluster index vector, and rhe old and new cluster
        % counts and centroids
        idx(moved) = nidx;
        m(nidx) = m(nidx) + 1;
        m(oidx) = m(oidx) - 1;
        
        
        % changed by TOM
        C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
        C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
        
        
        changed = sort([oidx nidx]);
    end % phase two
    
    if (~converged) & (display > 0)
        warning('stats:kmeans:FailedToConverge', ...
                'Failed to converge in %d iterations.', maxit);
    end

    % Calculate cluster-wise sums of distances
    nonempties = find(m(:)'>0);
    D(:,nonempties) = distfun(X, C(nonempties,:), normf, iter);
    d = D((idx-1)*n + (1:n)');
    sumD = zeros(k,1);
    for i = 1:k
        sumD(i) = sum(d(idx == i));
    end
    if display > 1 % 'final' or 'iter'
        disp(sprintf('%d iterations, total sum of distances = %g',iter,totsumD));
    end

    % Save the best solution so far
    if totsumD < totsumDBest
        totsumDBest = totsumD;
        idxBest = idx;
        Cbest = C;
        sumDBest = sumD;
        if nargout > 3
            Dbest = D;
        end
    end
end

% Return the best solution
idx = idxBest;
C = Cbest;
sumD = sumDBest;
if nargout > 3
    D = Dbest;
end


%------------------------------------------------------------------

function D = distfun(X, C, normf, iter)
%DISTFUN Calculate point to cluster centroid distances.
[n,p] = size(X);
D = zeros(n,size(C,1));
nclusts = size(C,1);

% better make sure we use the norm squared
for i = 1:nclusts
        D(:,i) = (normf(X - C(repmat(i,n,1),:))).^2;
end
   

%------------------------------------------------------------------

function [centroids, counts] = gcentroids(X, index, clusts, dist, Xsort, Xord)
%GCENTROIDS Centroids and counts stratified by group.
[n,p] = size(X);
num = length(clusts);
centroids = repmat(NaN, [num p]);
counts = zeros(num,1);
for i = 1:num
    members = find(index == clusts(i));
    
    % For Mahalanobis norms, we can use the mean point
    if length(members) > 0
        counts(i) = length(members);
        centroids(i,:) = sum(X(members,:),1) / counts(i);
    end
end
