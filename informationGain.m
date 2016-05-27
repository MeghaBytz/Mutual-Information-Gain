function F = informationGain()
nIn = 1000;
nOut = nIn;
global noUnknowns
global priorMeans
global priorLB
global priorUB
global priorSDs
global noExperiments
global triedExperiments

% priorMeans = [10 10 10 10 1];
% priorSDs = [10 10 10 10 1];
%draw theta apriori uniform between 0 and 1. Draw fresh batch for each d
exp = 1;
%d = zeros(rows*columns,1);
% if (noExperiments <7)
% x = linspace(1,20,noExperiments +1);
% y = linspace(1,20,noExperiments +1);
% else
    x = linspace(1,20,8);
    y = linspace(1,20,8);
% end
for i = 1:length(x)
    for j = 1:length(y)
        d(exp,1) = round(x(i));
        d(exp,2) = round(y(j));
        exp = exp+1;
    end
end
%design space between 0 and 1
% for ind = 1:length(d)
%     d = d(ind,:);
%     theta = unifrnd(0,1,[nIn,1]);
%     sum = 0;
%     for i = 1:nOut
%         yi = y(theta(i),d);
%         pYiGivenD = 0;
%         for j = 1:nIn
%             pYiGivenD = Likelihood(yi,theta(j),d)+pYiGivenD;
%         end
%         pYiGivenD = pYiGivenD/nIn;
%         sum = log(Likelihood(yi,theta(i),d)+10e-30)-log(pYiGivenD + 10e-30) + sum;
%     end         
%     information(ind) = sum/nOut;
% end
% 
% plot(design,information)
theta = zeros(nIn,noUnknowns);
yij = zeros(nIn,1);
information = zeros(length(d),1);
for ind = 1:length(d)
    design = d(ind,:);
    for draw = 1:nIn
        theta(draw,1) = randi([priorLB(1) priorUB(1)], 1,1);
        theta(draw,2) = randi([priorLB(2) priorUB(2)], 1,1);
        theta(draw,3) = randi([priorLB(3) priorUB(3)], 1,1);;
        theta(draw,4) = randi([priorLB(4) priorUB(4)], 1,1);
        yij(draw) = testDart(theta(draw,:),design);
    end
    sum = 0;
    for i = 1:nOut
        yi = yij(i);
        pYiGivenD = 0;
        for j = 1:nIn
            pYiGivenD = LikelihoodDart(yi,yij(j))+pYiGivenD;
        end
        pYiGivenD = pYiGivenD/nIn;
        sum = log(LikelihoodDart(yi,yi)+10e-30)-log(pYiGivenD + 10e-30) + sum;
    end         
    information(ind) = sum/nOut;
end
%make MI matrix
for i=1:length(d)
    MIGain(d(i,1),d(i,2))=information(i);
end
%MIGain
[B,I] = sort(information,'descend');
%contour(MIGain)
%[M,I] = max(information);
index = 1;
while (ismember(I(index),triedExperiments))
    index = index+1;
end
triedExperiments = [I(index) triedExperiments]
F = d(I(index),:);
