function [MB, final_part] = to_block_form(Advice)

% algorithm:
% for each vertex maintain a list of vertices in its cluster.
% For each edge, merge the lists of the vertices that it joins.

[n n] = size(Advice);

% data structure to hold a partition of 1,...,n
part = cell(n,1);
for i=1:n
    part{i} = i;
end

[row col] = find(Advice);

order = randperm (length(col));
for i=1:length(col)
    j = order(i);
    % find the `end' of row(i) and col(i)
    row_end = find_end(row(j), part);
    col_end = find_end(col(j), part);
    
    if row_end ~= col_end
        part{col_end} = union(part{row_end}, part{col_end});
        part{row_end} = col_end;
    end
    
    % check that we are'nt finished (i.e. everything in one cluster
    if length (part{col_end}) == n
        break;
    end
end

non_empty = 0;
final_part = {};

for i=1:n
    if ( ( length(part{i}) > 1 ) || ( part{i} == i ) )
        non_empty = non_empty + 1;
        final_part{non_empty} = part{i};
    end
end

MB = sparse (diag (sum (abs (Advice + Advice'), 2)) - (Advice + Advice'));


function j = find_end(j, part)

if ( ( length(part{j}) > 1 ) || ( part{j} == j ) )
    return;
else
    j = find_end(part{j}, part);
end





