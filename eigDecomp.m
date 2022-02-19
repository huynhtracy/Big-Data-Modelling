function [t, p, R2] = eigDecomp(data,components)

%preprocessing data - center and scale

%for each column (variable) of the data matrix 
for k = 1:size(data,2)
    
    meann = mean(data(:,k));
    stdd = std(data(:,k));
   
    %for each row (observation)
    for n = 1:size(data,1)
       data(n,k) = data(n,k) - meann;
       data(n,k) = data(n,k)/stdd;     
    end
end


%loadings
[vec, val] = eig(data'*data)
p = vec(:,size(vec,2)-components+1:size(vec,2));
p = flip(p,2)
%p3 = p(:,1)

%scores
t = data*p
%t3 = data*p3

%x hat 
xhat = t*p'
%xhat3 = t3*p3'

%residuals
E = data - xhat
%E3 = data - xhat3

%R2
R2 = 1 - var(E)/var(data)
%R23 = 1 - var(E3)/var(data)


end


