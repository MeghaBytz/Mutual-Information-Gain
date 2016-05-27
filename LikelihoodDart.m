function [F] = LikelihoodDart(yi,yj)
global data;
global likelihoodRecord
global etchRecord

%change this back to unknown noise parameter eventually
lh = normpdf(yi,yj);
F = lh;
