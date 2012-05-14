pts = [5,5;
       0,1;
       1,0];

n=3;


A=zeros(n);
for i=1:n
    for j=1:n
        A(i,j) = exp(-norm(pts(i,:)-pts(j,:)));
    end
end
A = A - eye(n);


d = sum(A,2);
D = diag (d);

L = D - A;
s = sum(sum(D));

vol_diff = (d*d')/s^2;

%---------------

in = -1:0.01:0;
out=zeros(101,1);
for i=1:101
x = in(i);
gamma = [1,x,x;x,1,1;x,1,1];
p = 1 - gamma(:)' * vol_diff(:);
out(i) = (1/(s*p)) * gamma(:)' * L(:);
end

plot(in, out)