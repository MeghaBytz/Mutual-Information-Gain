function F = Prior(current,index)
global priorLB
global priorUB
global priorRecord
global priorMeans
global priorSDs

priorTime = tic;
%prior = log(normpdf(current(index),priorMeans(index),priorSDs(index))+10e-20);
prior = log(unifpdf(current(index),priorLB(index),priorUB(index))+10e-20);
F = prior;
priorRecord = [priorRecord prior];
priorTimeElapsed = toc(priorTime);
assignin('base', 'priorTimeElapsed', priorTimeElapsed);
end