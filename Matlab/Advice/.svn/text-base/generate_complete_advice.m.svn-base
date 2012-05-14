function cluster = generate_complete_advice(data, prob, name, size)

n = length(data.lbls);

if nargin < 4
    size = n;
end

% pick a random sample of size n
perm = randperm(n);
S = perm(1:size);


adv = 0;
Advice = sparse(n,n);
for i = 1:size
    for j = i+1:size
        Advice(S(i), S(j)) = ...
            (-1)^( (rand < prob) + ( data.lbls(S(i)) == data.lbls(S(j)) ) );
    end
end

cluster.Advice = Advice;
cluster.V = [];
cluster.Y = [];
if nargin < 3
    cluster.adv_name = datestr(now,30);
else
    cluster.adv_name = name;
end
cluster.data = data;
cluster.inform.Adv = ['complete advice; '];
cluster.inform.Adv = [cluster.inform.Adv, 'prob = ', num2str(prob), '; '];
cluster.inform.Adv = [cluster.inform.Adv, 'size = ', num2str(size), '; '];
