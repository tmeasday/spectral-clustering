function metrics = mixed_metric(types)

% returns a cell array of function handles to metrics. 

metrics = cell(1,length(types));

for i=1:length(types)
    if types(i)
        metrics{i} = @(x,y)(x~=y);
    else
        metrics{i} = @(x,y)norm(x-y);
    end
end


