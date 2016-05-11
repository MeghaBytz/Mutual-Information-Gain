function [F] = Likelihood(yi,theta,d)
global data;
global likelihoodRecord
global etchRecord

noise = 10e-4; %change this back to unknown noise parameter eventually
pred = y(theta,d);
lh = normpdf(yi,pred,noise);
F = lh;
