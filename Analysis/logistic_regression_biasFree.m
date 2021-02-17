clear
clc
n_trials = input('enter max number of trials back to use in model')

RO = load('reward_order.mat');
CO = load('choice_order.mat');
CO = CO.choice_order;
RO = RO.reward_order;
choice_order = [];
reward_order = [];


for k = 1:size(CO,2)
    choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
    reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
end

zero_locs = find(choice_order == 0);
choice_order(zero_locs) = [];
reward_order(zero_locs) = [];
count = 0;
X = [];
Y = [];

for i = n_trials+1:length(choice_order)
    count = count + 1
    X(count,:) = reward_order(i-n_trials : i-1);
    Y(count) = choice_order(i);
    
end    
Y = transpose(Y);


% For the current data set we have two predictors. Therefore beta_zero can 
% be defined as a two element vector. This initializes beta

beta = zeros(n_trials,1);

beta_t_predictors = X*beta;
P_YgX = exp((beta_t_predictors))./(1+exp((beta_t_predictors)));

W = zeros(length(Y),length(Y));
for i = 1:length(Y)
    W(i,i) = P_YgX(i) * (1-P_YgX(i));
end

ll_zero = sum(Y.*log(P_YgX) + ((1-Y).*log(1-P_YgX)));

ll_past = ll_zero;
ll_now = ll_zero;

iter = 1
while ll_past < ll_now || ll_past == ll_zero
    iter = iter + 1
    ll_past = ll_now;

    beta = beta + inv(transpose(X)*W*X)*(transpose(X)*(Y-P_YgX));
    beta_t_predictors = X*beta;
    P_YgX = exp(beta_t_predictors)./(1+exp(beta_t_predictors));

    W = zeros(length(Y),length(Y));
    for i = 1:length(Y)
        W(i,i) = P_YgX(i) * (1-P_YgX(i));
    end
    V1 = Y.*log(P_YgX); 
    V2 = ((1-Y).*log(1-P_YgX));
    V1_nan = isnan(V1);
    V1(find(V1_nan == 1)) = 0;
    V2_nan = isnan(V2);
    V2(find(V2_nan == 1)) = 0;
    V = V1+V2;
    ll_now= sum(V);
end    


