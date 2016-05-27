clear all
close all

%declare global variables
global proposalLB
global proposalUB
global proposalMean
global proposalSD
global data
global noUnknowns
global priorLB
global priorUB
global expRows
global expColumns
global noExperiments
global likelihoodRecord
global proposedParameterRecord
global accepted
global priorMeans
global priorSDs
global triedExperiments

%Build elliptical target
imageColumns = 20;
imageRows = 20;
[columnsInImage rowsInImage] = meshgrid(1:imageColumns, 1:imageRows);
% % Next create the ellipse in the image.
centerRow = 5;
centerColumn = 6;
radiusRow = 3;
radiusColumn = 2;

real = [centerRow centerColumn radiusRow radiusColumn];

noUnknowns = 4;
proposalLB = [0 0 1 1 ]
proposalUB = [20 20 20 20 ]
% proposalMean = [10 10 10 10];
% proposalSD = [10 10 10 10];
priorLB = [0 0 1 1 ];
priorUB = [20 20 10 10 ];
% priorMeans = [10 10 10 10 ];
% priorSDs = [10 10 10 10 ];
ellipsePixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;



%ROSS
%determine data for Baye's experiment randomly
noExperiments = 0;
stop = 1000;

%identify index best experiment in info gain
%run inference
%update priors with posterior distribution in both info gain and MI gain

%elapsedTime = toc
N = 1000;
theta = zeros(N*noUnknowns,noUnknowns);
acc = zeros(1,noUnknowns);
current = zeros(1,noUnknowns);
for i = 1:noUnknowns
           current = ProposalFunction(current,i);
end
PosteriorCurrent = Posterior(current,1);
%while (stop>20)
for iter = 1:25
    noExperiments = noExperiments + 1
%     newRow = randi(20,1,1);
%     newColumn = randi(20,1,1);


    exp = informationGain();
    newRow = exp(1);
    newColumn = exp(2);
    expRows = [expRows newRow];
    expColumns = [expColumns newColumn];
    if ellipsePixels(newRow,newColumn) ==1
        data = [data -20];
    else
        data = [data 20];
    end
%Make initial guess for unknown parameters

%Peform MH iterations
for cycle = 1:N  % Cycle to the number of samples
     for m=1:noUnknowns % Cycle to make the thinning
            [alpha,t, a,prob, PosteriorCatch] = MetropolisHastings(theta,current,PosteriorCurrent,m);
            theta((cycle-1)*noUnknowns+m,:) = t;        % Samples accepted
            AlphaSet(cycle,m) = alpha;
            current = t;
            PosteriorCurrent = PosteriorCatch;
            acc(m) = acc(m) + a;  % Accepted ?
     end
end

%update priors with posterior distribution (assume normal)
priorLB = min(theta);
priorUB = max(theta);
%priorMeans = mean(theta);
%priorSDs = std(theta);
accrate = acc/N;     % Acceptance rate,. 
%plot final predicted figure from Bayes using mean values
centerRow = round(mean(theta(:,1)));%round(mean(theta(:,1)));
centerColumn = round(mean(theta(:,2)));%round(mean(theta(:,2)));
radiusRow = round(mean(theta(:,3)));%round(mean(theta(:,3)));
radiusColumn = round(mean(theta(:,4)));%round(mean(theta(:,4)));
inferredParameters = [centerRow centerColumn radiusRow radiusColumn];
predictedPixels = (rowsInImage - centerColumn).^2 ./ radiusColumn^2 ...
    + (columnsInImage - centerRow).^2 ./ radiusRow^2 <= 1;

X = abs(predictedPixels - ellipsePixels);
stop = nnz(X)

end
%toc
%elapsedTime = toc




figure; image(predictedPixels);
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Predicted Target', 'FontSize', 20);
hold on
scatter(expRows,expColumns)

inferredParametersPlusSD = inferredParameters + std(theta);
inferredParametersMinusSD = inferredParameters - std(theta);
predictedPixelsPlus = (rowsInImage - inferredParametersPlusSD(2)).^2 ./ inferredParametersPlusSD(4)^2 ...
    + (columnsInImage - inferredParametersPlusSD(1)).^2 ./ inferredParametersPlusSD(3)^2 <= 1;
predictedPixelsMinus = (rowsInImage - inferredParametersMinusSD(2)).^2 ./ inferredParametersMinusSD(4)^2 ...
    + (columnsInImage - inferredParametersMinusSD(1)).^2 ./ inferredParametersMinusSD(3)^2 <= 1;

figure; image(predictedPixelsPlus);
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Predicted Target Uncertainty', 'FontSize', 20);
hold on
scatter(expRows,expColumns)

figure; image(predictedPixelsMinus);
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Predicted Target Uncertainty', 'FontSize', 20);
hold on
scatter(expRows,expColumns)




% circlePixels is a 2D "logical" array.
% Now, display it.
figure; image(ellipsePixels) ;
set(gca,'YDir','normal')
newmap = ([1 1 1; 1 0 0]);
colormap([1 1 1; 1 0 0]);
title('Target', 'FontSize', 20);
hold on
scatter(expRows,expColumns)
imwrite(ellipsePixels,newmap,'target.jpg')

figure;
    for i =1:noUnknowns
        subplot(2,2,i);
        outputTitle = sprintf('Unknown %d',i);
        paramEdges = [0:2:proposalUB(i)];
        f = histogram(theta(:,i),paramEdges);
        f.Normalization = 'probability';
        counts = f.Values;
        hold on
        line([real(i) real(i)],[0 max(counts)], 'Color', 'r')
        hold on
        line([inferredParameters(i) inferredParameters(i)],[0 max(counts)], 'Color', 'b')
        xmin = min(theta(:,i));
        xmax = max(theta(:,i));
        x = xmin:1:xmax;
        hold on
        line([priorLB(i) priorLB(i)],[0 max(counts)], 'Color', 'g')
        hold on
        line([priorUB(i) priorUB(i)],[0 max(counts)], 'Color', 'g')
        title(outputTitle);
        xlabel('Value');
        ylabel('Frequency');
    end



figure; 
for k =1:noUnknowns
    outputTitle = sprintf('Unknown %d',k);
    subplot(2,2,k);
    plot(theta(:,k));
    hold on
    line([0 N],[real(k) real(k)], 'Color', 'r')
    hold on
    line([0 N],[proposalLB(i) proposalLB(i)], 'Color', 'g')
    line([0 N],[proposalUB(i) proposalUB(i)], 'Color', 'g')
    title(outputTitle);
    xlabel('Cycle #');
    ylabel('Value');
end

