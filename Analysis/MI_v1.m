% MI between current and past choice
Y_dim = 1;
X_dim = 1;

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
        
% H(Y) - Here Y = most recent past choice

Y_counts = [0,0];

for i = 2:length(choice_order)
    if choice_order(i-1) == 1
        Y_counts(1) = Y_counts(1) + 1;
    else
        Y_counts(2) = Y_counts(2) + 1;
    end
end    

P_Y = Y_counts/sum(Y_counts);
H_Y = -sum(P_Y.*log(P_Y));

% H(Y|X) - Here Y = most recent past choice

YgX_counts = zeros(Y_dim*2,X_dim*2);

for i = 2:length(choice_order)
    if choice_order(i-1) == 1
        if choice_order(i) == 1
            YgX_counts(1,1) = YgX_counts(1,1) + 1;
        else
            YgX_counts(1,2) = YgX_counts(1,2) + 1;
        end    
    else
        if choice_order(i) == 1
            YgX_counts(2,1) = YgX_counts(2,1) + 1;
        else
            YgX_counts(2,2) = YgX_counts(2,2) + 1;
        end    
    end
end 
   


P_YgX = YgX_counts./sum(YgX_counts);
H_YgX_x = -sum(P_YgX.*log(P_YgX));
H_YgX = sum((sum(YgX_counts)./sum(sum(YgX_counts))).*H_YgX_x);

MI = H_Y - H_YgX;