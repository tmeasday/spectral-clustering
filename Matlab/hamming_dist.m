function dist = hamming_dist(x,y)

% compute the Hamming distance between x and y
dist = sum (x~=y);