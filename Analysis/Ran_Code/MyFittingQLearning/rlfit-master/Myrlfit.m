function [beta, LL, Q] = Myrlfit(Qfun, choice, outcome, lb, ub, niter,Q0...
    ,ispresentx)
% fits a reinforcement learning model to a multi-option choice paradigm
% inputs:
%
% Qfun is a handle to a function that accepts a vector of parameters, a
% vector of choice indices, and a vector of outcomes, and returns 
% the action values, Q
% 
% choice is a vector, one entry per trial, the index of the chosen option
%
% outcome is a set of outcomes for each trial
%
% lb and ub are vectors of upper and lower bounds on parameters
%
% niter (optional) is the number of random restarts to use in fitting
%
% ispresentx (optional) is a set-options x number of trials matrix, 
% indicating the options present on each trial
% (1 if present, 0 if not present)
% 
% outputs:
%
% beta is the vector of fitted model parameters; first entry is the softmax
% inverse temperature, followed by parameters of the model
%
% LL is the log likelihood of the data (choice, outcome) given beta
% 
% Q is a trials x options matrix of action values

if (~exist('Q0', 'var')) || isempty(Q0)
        Q0 = [0,0];
end  

if (~exist('ispresentx', 'var')) || isempty(ispresentx)
        ispresentx = true;
end  

if ~exist('niter', 'var')
    niter = 10;
end

if ~exist('lb', 'var')
    lb = [];
end

if ~exist('ub', 'var')
    ub = [];
end

% rescale outcomes to offer better fit convergence
% outmean = mean(outcome(:));
% outstd = std(outcome(:));
% z = bsxfun(@minus, outcome, outmean)/outstd;

z = outcome;outstd=1;outmean=0;

% first, define a log likelihood function that takes as its input a vector
% of parameters, the first of which is the inverse temperature of the
% softmax
LLfun = @(x, choice, z) LL_softmax(x(1) * Qfun(x(2:end), choice, z,Q0) .* ...
                        ispresentx, choice);

% then define a function to be minimized (the total negative log
% likelihood)
fitfun = @(beta)(-1)*sum(LLfun(beta, choice, z));

% now combine upper and lower bounds on softmax temp with upper and lower
% bounds on other parameters
lb = [1e-5, lb]; %lower bounds
ub = [15, ub]; %upper bounds

% optmize to fit model
w = warning ('off','all');
options = optimset('Display', 'off');
[beta,fval]=multmin(fitfun, lb, ub, niter, options);
warning(w);

% return log likelihood
LL=-fval;

% get action values
% % % % % % % Rescale Q0 ????? This is a bug in the program, as he had to
% rescale Q0 as well!!!
Q0rescale=(Q0-outmean)./outstd;
% Q0rescale= Q0 ;
Q = Qfun(beta(2:end), choice, z,Q0rescale);

% undo scaling
Q = Q*outstd + outmean; % rescale appropriately
beta(1) = beta(1)/outstd;

