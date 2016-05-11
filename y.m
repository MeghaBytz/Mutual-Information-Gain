function F = y(theta,d)
F = theta^3*(d^2)+theta*exp(-abs(0.2-d))+normrnd(0,10e-4);
end
