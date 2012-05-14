function clusterout = generate_advice(data, num_adv, prob, clusterin)

% Generate constraints in the form of a sparse matrix:
% Constraints_{ij} = 1 if must link i,j; -1 if must not link i,j; 
% 0 otherwise. 

% arguments: 
% data      -- data structure.
% num_adv   -- number of pieces of advice to generate. 
% prob      -- probability that constraints generated will be 
%           consistent with data.lbls
% cluster   -- (optional) argument. When supplied will only consider
%           generating advice that is on edges where the labels and an
%           existing clustering disagree. 

% work out what to do if pick the same two points. Do we exclude this case?
if nargin <= 3
    normalmode = true;
    if nargin == 2
        prob = 1;
    end
else
    normalmode = false;
end

n = length (data.lbls); 

% build as much of clusterout as can be done at this stage

clusterout.data = data;
clusterout.Advice = sparse(n,n);
clusterout.V = [];
clusterout.Y = [];
clusterout.adv_name = datestr(now,30);


if ~normalmode
    impossible = true;
    % noramlize the labels so that data.lbls(1) = 1
    if data.lbls(1) ~= 1
      data.lbls = -data.lbls;
    end
    % normalize so that clusterin.Y(1,i) = 1 for all i
    for i=1:size(clusterin.Y,2)
        if clusterin.Y(1,i) ~= 1
            clusterin.Y(:,i) = -clusterin.Y(:,i);
        end
        impossible = impossible && all(data.lbls == clusterin.Y(:,i));
    end
    if impossible
        num_adv = 0;
    end
end

adv = 0;

while( adv < num_adv )
    % pick an unconstrained edge at random.
    edge = ceil(n*rand(2,1));
    edge = sort(edge);
    % make sure edge(1)!=edge(2) and edge(1), edge(2) != 0 
    if normalmode
        if acceptable_edge(edge, clusterout.Advice)
            clusterout.Advice(edge(1),edge(2)) = ...
            (-1)^( (rand < prob) + ( data.lbls(edge(1)) == data.lbls(edge(2)) ) );
            adv = adv + 1;
        end   
    else
        if acceptable_edge(edge, clusterout.Advice, clusterin.Y, data.lbls)
            clusterout.Advice(edge(1),edge(2)) = ...
                (-1)^( (rand < prob) + ( data.lbls(edge(1)) == data.lbls(edge(2)) ) );  
            adv = adv + 1;
        end
    end
end

clusterout.inform.Adv = ['num_adv = ', num2str(num_adv), '; prob = ', ...
    num2str(prob), '; '];
if normalmode
    clusterout.inform.Adv = [clusterout.inform.Adv, 'mode = normal;'];
else
    clusterout.inform.Adv = [clusterout.inform.Adv, 'mode = abnormal!;'];
end

    

function result = acceptable_edge(edge, Advice, Y, lbls)

% first, ensure that the edge satisfies all the trivial conditions
result = (all(edge>0));
result = result && (edge(1)~=edge(2));
result = result && (Advice(edge(1), edge(2)) == 0);

if (nargin == 2) || (result == false)
    return;
end

% first "normalize" so that Y(1,i) = 1 for all i

for i=1:size(Y,2)
    if Y(1,i) ~= 1
        Y(:,i) = -Y(:,i);
    end
end

% do the same for the labels

if lbls(1) ~= 1
    lbls = -lbls;
end

% we only want to generate advice on the edge if it has at least one
% endpoint for which a column of Y and lbls disagree.

test_val = false;

for i=1:size(Y,2)
    test_val = test_val || ( (lbls(edge(1))~=Y(edge(1),i)) || ...
                             (lbls(edge(2))~=Y(edge(2),i)) );
end

result = result && test_val;
    
