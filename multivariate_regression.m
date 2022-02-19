%Program to fit a multivariate regression model to a data set 
%Modelling a solid oxide fuel cell (SOFC) plant with compressed air energy storage (CAES)

summ = 0; 
[P,S,B,E] = SOFC_Data();

tilS = S/mean(S);
tilP = P/mean(P);
tilB = B/mean(B);


A = zeros(11,11);
b = zeros(11,1);
x = zeros(11,1);

%to get A matrix:

for M = 1:11
    for N = 1:11
        %for each element in the matrix A
        %find fM(x)*fN(x) for all combinations of x's and sum them
        
        for i = 1:length(S)
            for j = 1:length(P)
                for k = 1:length(B)
                    x_ijk = [tilS(i);tilP(j);tilB(k)];
                    summ = summ + func(M,x_ijk)*func(N,x_ijk);  
                end
            end
        end  
        
        A(M,N) = summ;
        summ = 0;        
    end  
end

summ = 0;

%to get b vector:
for M = 1:11
    for i = 1:length(S)
            for j = 1:length(P)
                for k = 1:length(B)
                    x_ijk = [tilS(i);tilP(j);tilB(k)];
                    summ = summ + func(M,x_ijk)*E(j,i,k);
                end
            end
     end  
        b(M) = summ;
        summ = 0;
    
end


%to solve for x:
x = A\b;
%x is the vector of a values

ePlot = zeros(length(P),length(S),length(B));
          
for i = 1:length(S)
    for j = 1:length(P)
        for k = 1:length(B)
            x_ijk = [tilS(i);tilP(j);tilB(k)];
            for M = 1:11
                ePlot(j,i,k) = ePlot(j,i,k) + x(M)*func(M,x_ijk);
            end
        end
    end
end
  
[S_plot,P_plot] = meshgrid(S,P);
c = ['k','r','g','b','m','c'];


F1 = figure;
for i = 1:length(BL)
    
    plot3(S_plot,P_plot,E(:,:,i),'o','MarkerFaceColor',c(i),'MarkerEdgeColor',c(i)); % NOTE P are rows in E and S are columns
    
    if i == 1
        hold on;
    end
    
end

surf(S,P,ePlot(:,:,1),'FaceAlpha',0.5,'FaceColor','k');
surf(S,P,ePlot(:,:,2),'FaceAlpha',0.5,'FaceColor','r');
surf(S,P,ePlot(:,:,3),'FaceAlpha',0.5,'FaceColor','g');
surf(S,P,ePlot(:,:,4),'FaceAlpha',0.5,'FaceColor','b');
surf(S,P,ePlot(:,:,5),'FaceAlpha',0.5,'FaceColor',[1 0.5 0.8]);
surf(S,P,ePlot(:,:,6),'FaceAlpha',0.5,'FaceColor',[0.2 0.7 0.9]);



% xlabel('Cathode Split (S, unitless)','Rotation',15,'Position',[0.85,49,67]);
% ylabel('Cavern Pressure (P, bar)','Rotation',-25,'Position',[-0.12,56,252]);
xlabel('Cathode Split (S, unitless)');
ylabel('Cavern Pressure (P, bar)');
zlabel('Net Plant Output (E, MW)');
box on;
hold off;
 

summ2 = 0;
summ3 = 0;
%mean of all E elements
meanE = mean(mean(mean(E)));


for i = 1:length(S)
    for j = 1:length(P)
        for k = 1:length(B)
            x_ijk = [tilS(i);tilP(j);tilB(k)];    

% we already computed ePlot, just need to extract it
            
            summ2 = summ2 + (ePlot(j,i,k)-E(j,i,k))^2;
            summ3 = summ3 + (E(j,i,k)-meanE)^2;
               
        end
    end
end

Rsquare = 1 - (summ2/summ3);

