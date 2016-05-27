
nIn = 10000;
nOut = nIn;
% noUnknowns = 4;
% global priorMeans
% global priorSDs
% proposalMean = [10 10 10 10 1];
% proposalSD = [5 5 5 5 .1];
% priorLB = [0 0 1 1 .1];
% priorUB = [20 20 10 10 .2];
% %draw theta apriori uniform between 0 and 1. Draw fresh batch for each d
% exp = 1;
% rows = 20;
% columns = 20;
% d = zeros(rows*columns,1);
% for x = 1:20
%     for y = 1:20
%         d(exp,1) = x;
%         d(exp,2) = y;
%         exp = exp+1;
%     end
% end
%design space between 0 and 1
design = 0.2;%linspace(0,1,5);
yij = zeros(nIn,1);
information = zeros(length(design),1);
for ind = 1:length(design)
    ind
    d = design(ind);
    theta = unifrnd(0,1,[nIn,1]);
    sum = 0;
    for i = 1:nOut
        yij(i) = y(theta(i),d);
        pYiGivenD = 0;
        for j = 1:nIn
            pYiGivenD = LikelihoodDart(yij(i)+normrnd(0,10e-4),yij(j),d)+pYiGivenD;
        end
        pYiGivenD = pYiGivenD/nIn;
        sum = log(LikelihoodDart(yij(i)+ normrnd(0,10e-4),yij(i),d)+10e-30)-log(pYiGivenD + 10e-30) + sum;
    end         
    information(ind) = sum/nOut;
end
% 
plot(design,information)
% theta = zeros(nIn,noUnknowns);
% for ind = 1:length(d)
%     design = d(ind,:);
%     for draw = 1:nIn
%         theta(draw,1) = abs(normrnd(priorMeans(1),priorSDs(1)));
%         theta(draw,2) = abs(normrnd(priorMeans(2),priorSDs(2)));
%         theta(draw,3) = abs(normrnd(priorMeans(3),priorSDs(3)));
%         theta(draw,4) = abs(normrnd(priorMeans(4),priorSDs(4)));
%     end
%     sum = 0;
%     for i = 1:nOut
%         yi = testDart(theta(i,:),design);
%         pYiGivenD = 0;
%         for j = 1:nIn
%             pYiGivenD = LikelihoodDart(yi,theta(j,:),design)+pYiGivenD;
%         end
%         pYiGivenD = pYiGivenD/nIn;
%         sum = log(LikelihoodDart(yi,theta(i,:),design)+10e-30)-log(pYiGivenD + 10e-30) + sum;
%     end         
%     information(ind) = sum/nOut;
% end
% %make MI matrix
% for i=1:length(d)
%     MIGain(d(i,1),d(i,2))=information(i);
% end
% %MIGain
% [M,I] = max(information);
% F = d(I,:);
