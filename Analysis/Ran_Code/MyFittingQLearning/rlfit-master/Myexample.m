% example.m
% basic code for fitting a learning model

% load up data
load testdata
%%
clear

load('reward_order.mat')
load('choice_order.mat')
load('cps_pre.mat');
n0=length(cps_pre);
reward_order(1:n0)

choice_order(1:n0)=[];
reward_order(1:n0)=[];
outcome = ne(reward_order,0);
disp('mean outcome')
mean(outcome)
disp('mean choice')
mean(choice_order-1)
choice=choice_order;

randRewardPre=reward_order(1:n0);
bias2=sum(randRewardPre==2)./n0;
bias1=sum(randRewardPre==1)./n0;
bias=[bias1 bias2]

% bias=[0.5 0.5]
%
% model has only one parameter, the learning rate, between 0 and 1
% in general, there will be one of these for each parameter (excluding the
% softmax parameter)
lb = [0]; %lower bounds
ub = [1]; %upper bounds

% however, we can also use a decorator to add perseveration behavior 
% to the model:
% the following are limits for a perseveration bonus
% lb = [-1, lb];
% ub = [1, ub];
% Qfun = add_perseveration(@Q_model);
Qfun = @MyQ_model;

% now optmize to fit model
numiter = 15;
% Q0=[0.9 0.1];
Q0=bias;
% Q0=[0.1 0.2];
% Q0=[0 0];
[beta, LL, Q] = Myrlfit(Qfun, choice, outcome, lb, ub, numiter,Q0);

% plot results
figure
% plot(Q)
plot(exp  (beta(1).*(Q(:,2))    )./sum(exp(  beta(1).*Q) ,2)    ,'-r' );
hold on
plot(exp  (beta(1).*(Q(:,1))    )./sum(exp(  beta(1).*Q) ,2)    ,'-b' );

[m1 n1]=find(choice==1);
[m2 n2]=find(choice==2);
plot(n2,1.*m2,'ro')
plot(n1,0.*m1,'bo')
beta