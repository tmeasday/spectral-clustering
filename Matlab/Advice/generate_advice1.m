function cluster = generate_advice1(data, prob, num_adv, sub_size, num_blobs, name)

n = length(data.lbls);

if nargin <=4
    num_blobs = 1;
    if nargin == 3
        sub_size = n;
    end
end

% pick num_blobs random subsets of the vertices each of size sub_size
S = zeros(num_blobs, sub_size);
perm = randperm(n);
for i=1:num_blobs
    S(i,:) = perm((1 + sub_size * (i-1)):(i * sub_size));
end

adv = 0;
Advice = sparse(n,n);

while( adv < num_adv )
    % pick a random blob
    perm = randperm(num_blobs);
    blob = perm(1);
    
    % pick a random edge
    perm = randperm(sub_size);
    edge = S(blob,perm(1:2));
    edge = sort(edge);
    
    if (Advice(edge(1), edge(2)) == 0)
        Advice(edge(1),edge(2)) = ...
            (-1)^( (rand < prob) + ( data.lbls(edge(1)) == data.lbls(edge(2)) ) );
            adv = adv + 1;
    end   
end

cluster.Advice = Advice;
cluster.V = [];
cluster.Y = [];
if nargin < 6
    cluster.adv_name = datestr(now,30);
else
    cluster.adv_name = name;
end
cluster.data = data;
cluster.inform.Adv = ['num_adv = ', num2str(num_adv), '; '];
cluster.inform.Adv = [cluster.inform.Adv, 'prob = ', num2str(prob), '; '];
cluster.inform.Adv = [cluster.inform.Adv, 'sub_size = ', num2str(sub_size), '; '];
cluster.inform.Adv = [cluster.inform.Adv, 'num_blobs = ', num2str(num_blobs), '; '];
cluster.inform.Adv = [cluster.inform.Adv, 'alg = 1'];
