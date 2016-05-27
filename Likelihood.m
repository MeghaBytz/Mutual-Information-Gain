function [F] = Likelihood(current)
global data;
global likelihoodRecord
global etchRecord
imageRows = 10;
imageColumns = 10;
likeData = 0;
noise = 0.01;%current(5); %change this back to unknown noise parameter eventually
for i=1:length(data)
        [ellipseGuess] = testEllipse(current);
        Like = normpdf(data(i),ellipseGuess(i),noise) + 10e-20;
        likeData = log(Like) + likeData;
end
likelihoodRecord = [likelihoodRecord likeData];
F = likeData;
