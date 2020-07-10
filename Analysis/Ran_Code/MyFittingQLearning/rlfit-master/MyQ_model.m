function out=MyQ_model(param,choice,outcome,Q0)
% basic reinforcement learning model
% calculate the action values, given model parameters
% xi is a decay term
% alpha is the learning rate

if (~exist('Q0', 'var')) || isempty(Q0)
        Q0 = [0,0];
end  


alpha = param(1);
% xi    = param(2);
xi=1;

N=length(outcome); %number of trials
k=length(unique(choice)); %number of options
Q=nan(N,k); %values of each choice each trial
Qthis=nan(N,1); %value of chosen option

Q(1,:) = Q0; %initialize guesses
% Q(1,:) = 0; %initialize guesses

for ind = 1:(N - 1) 
    % copy forward action values to next trial
    Q(ind + 1, :) = xi*Q(ind, :);
    
    % update option chosen on this trial for next trial's choice
    Q(ind + 1,choice(ind)) = xi*Q(ind,choice(ind)) + alpha*(outcome(ind)-Q(ind,choice(ind)));     
end

%return vector of action values for each trial
out=Q;