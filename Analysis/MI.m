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
        

c = choice_order;
c_2_trials = find(c == 2);
c_1_trials = find(c == 1);
c(c_2_trials) = 1;
c(c_1_trials) = -1;

r = reward_order;
r_2_trials = find(r == 2);
r_1_trials = find(r == 1);
r(r_2_trials) = 1;
r(r_1_trials) = -1;

u_trials = find(r == 0);
u_1_trials = u_trials(find(c(u_trials) == 1));
u_2_trials = u_trials(find(c(u_trials) == -1));
u = zeros(1,240);
u(u_1_trials) = 1;
u(u_2_trials) = -1;

P = [];
cP = []; % P of a given outcome given a past predictor
P_y = [];
% Number of possible options for outcomes
X = [1,-1];

% Number of possible options for predictors: Read [CR_# in past*no. of values that element can take - # = [1,n];
% CUR_# in past*no. of values that element can take - # = [1,n]]

Y = [1,-1,0; 1,-1,0];

for i = 1:length(X)
    P(i) = length(find(choice_order == i))/length(choice_order);
end

for n = 1:size(Y,1)
    for o = 1:size(Y,2)
        if n == 1
            P_y(n,o) = length(find(r == Y(n,o)))/length(choice_order);
        else    
            P_y(n,o) = length(find(u == Y(n,o)))/length(choice_order);
        end
    end
end

H_x = 0;
H_xgy = 0;

for j = 1:length(X)
    H_x = H_x - (P(j)*log(P(j)));
end   


for k = 1:size(Y,1)
    count = 0;
    for l = 1:size(Y,2)
        for m = 1:length(X)
            count = count +1

            if k == 1
                y = find(r(1:239) == Y(k,l));
                x = y(find(c(y+1) == X(m)))+1;
                cP(count,k) = length(x)/(length(y));
            else
                y = find(u(1:239) == Y(k,l));
                x = find(c(y+1) == X(m));
                cP(count,k) = length(x)/(length(y));
            end
        end
    end
end

for q = 1:size(Y,1)
    count2 = 0;
    for s = 1:size(Y,2)
        for t = 1:length(X)
            count2 = count2+1;
            H_xgy = H_xgy - (P(t)*P_y(q,s)*log(cP(count2,q)));

        end  
    end
end
            
            