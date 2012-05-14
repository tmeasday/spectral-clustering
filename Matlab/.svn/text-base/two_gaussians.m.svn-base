function data = two_gaussians(pt1, sigma1, pt2, sigma2, n)

k=length(pt1);

pts = zeros(n,k);
lbls = zeros(n,1);

for i=1:n
    if rand < 0.5
        pt = pt1;
        sigma = sigma1;
        lbls(i) = 1;
    else
        pt = pt2;
        sigma = sigma2;
        lbls(i) = -1;
    end
    
    rands = randn(k,1);
    for j=1:k
        pts(i,j) = pt(j) + sqrt(sigma) * rands(j);
    end 
end

point1 = num2str(round(pt1(1)));
point2 = num2str(round(pt2(1)));

for i=2:k
    point1 = [point1, '_',num2str(round(pt1(i)))];
	point2 = [point2, '_',num2str(round(pt2(i)))];
end

data.pts = pts;
data.lbls = lbls;
data.inform = [];
data.Aff = [];
data.name = ['2gauss-',num2str(n),'_pts-',point1,'-',point2,'-',num2str(sigma1),'-',num2str(sigma2)];
