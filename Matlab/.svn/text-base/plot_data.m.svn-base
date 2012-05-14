function plot_data(data, Cluster, rounding)

if nargin==0
    error('no data supplied');
elseif nargin >= 1
    
    Data = data.pts;
    lbls = data.lbls;
    
    if ( nargin == 3 ) && (~isempty(Cluster.Y))
        y = Cluster.Y(:,rounding);
    elseif ( nargin == 2 ) && (~isempty(Cluster.Y))
        y = Cluster.Y(:,1);
    else
        y = [];
    end
    
    if nargin >=2
        Constraints = Cluster.Advice;
    else
        Constraints = [];
    end
end

close all;
figure (1);
hold on;

if ~( isempty (y) && isempty (lbls) ) % either we have labels or clusters
    if isempty (y)
        y = lbls;
        format = ['bo';'b+';'bo';'b+'];
    elseif isempty (lbls)
        lbls = y;
        format = ['ro';'ro';'bo';'bo'];
    else
        format = ['ro';'r+';'bo';'b+'];
    end

    Data_lbl1_clust1 = Data((lbls>0)&(y>0),:);
    Data_lbl2_clust1 = Data((lbls<0)&(y>0),:);
    Data_lbl1_clust2 = Data((lbls>0)&(y<0),:);
    Data_lbl2_clust2 = Data((lbls<0)&(y<0),:);

    % plot the labelling and the clustering
    scatter (Data_lbl1_clust1(:,1), Data_lbl1_clust1(:,2), format(1,:));
    scatter (Data_lbl2_clust1(:,1), Data_lbl2_clust1(:,2), format(2,:));
    scatter (Data_lbl1_clust2(:,1), Data_lbl1_clust2(:,2), format(3,:));
    scatter (Data_lbl2_clust2(:,1), Data_lbl2_clust2(:,2), format(4,:));

    % add the constraints
    % i.e. loop over the non-zero elements of Constraints. If 
    % the entry is a 1, draw a solid line between Data(i,:) and Data(j,:)
    % that is plot([Data(i,1) Data(j,1)], [Data(i,2), Data(j,2)], 'k-');
else 
    % no labels or clusters so just plot data    
    scatter (Data(:,1), Data(:,2));
end

% [n m] = size(Constraints);

if ~isempty(Constraints)
    [is, js] = find(Constraints ~= 0);

    for I = [is, js]'
        if Constraints(I(1), I(2)) == 1
            plot([Data(I(1),1) Data(I(2),1)], [Data(I(1),2), Data(I(2),2)], 'k-');
        elseif Constraints(I(1), I(2)) == -1
            plot([Data(I(1),1) Data(I(2),1)], [Data(I(1),2), Data(I(2),2)], 'k--');
        end
    end
end

hold off;
    
    
    
    
    