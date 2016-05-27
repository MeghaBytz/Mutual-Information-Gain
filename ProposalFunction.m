function [F, chainSD] = ProposalFunction(current,parameterIndex)
global proposedParameterRecord
global proposalLB
global proposalUB
global proposalSD
global proposalMean

% s = 2.4;
% epsilon = 10e-3;
% variance = s*(var(theta(:,index)))+s*epsilon;
% chainSD = sqrt(log(variance/((proposalCenter(index))^2)+1));
% parameter(index) = lognrnd(proposalMean(index),chainSD);
% proposedParameterRecord = [proposedParameterRecord parameter];
parameter = current;
new = -1;
% while new<0
%     new = normrnd(proposalMean(parameterIndex), proposalSD(parameterIndex));
% end 
parameter(parameterIndex)= new;
parameter(parameterIndex) = randi([proposalLB(parameterIndex) proposalUB(parameterIndex)], 1,1);
chainSD = 1;
proposedParameterRecord = [proposedParameterRecord parameter];
F = parameter;
end
