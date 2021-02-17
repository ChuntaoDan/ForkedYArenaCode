clear
clc
window_size = input('enter number of trials to include in value calculation');

RO = load('reward_order.mat');
CO = load('choice_order.mat');
CO = CO.choice_order;
RO = RO.reward_order;
choice_order = [];
reward_order = [];
v1 = [];
v2 = [];
pred_choice = [];

for k = 1:size(CO,2)
choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
end

zero_locs = find(choice_order == 0);
choice_order(zero_locs) = [];
reward_order(zero_locs) = [];
% 
% choice_order( 1 : 80) = CO(:,3);
% reward_order( 1 : 80) = RO(:,3);

for t_num = window_size+1:length(choice_order)
    choices = [];
    rewards = [];
    choices = choice_order(t_num - window_size : t_num - 1);
    rewards = reward_order(t_num - window_size : t_num - 1);
    v1_list = [];
    v2_list = [];
    for ct = 1:length(choices)
        if rewards(ct) == 1
            v1_list(ct) = 1;
            v2_list(ct) = -1;
        elseif rewards(ct) == 2
            v1_list(ct) = -1;
            v2_list(ct) = 1;
        elseif rewards(ct) ==  0
            if choices(ct) == 1
                v1_list(ct) = 0;
                v2_list(ct) = -1;
            else
                v1_list(ct) = -1;
                v2_list(ct) = 0;
            end
        end 
    end   
    exp_w_list = exp((window_size - [1:window_size]+1)/window_size)./exp(1);     
    valid_els_1 = find(v1_list ~= -1);   
    valid_els_2 = find(v2_list ~= -1); 
       
    % exp weighted sum for value
    v1(t_num-window_size) = sum(flip(exp_w_list(valid_els_1).*v1_list(valid_els_1)));
    v2(t_num-window_size) = sum(flip(exp_w_list(valid_els_2).*v2_list(valid_els_2)));
    
%     % non weighted sum for value
%     v1(t_num-window_size) = sum(v1_list(valid_els_1));
%     v2(t_num-window_size) = sum(v2_list(valid_els_2));
%     
    if v1(t_num-window_size) > v2(t_num-window_size)
        pred_choice(t_num-window_size) = 1;
    else
        pred_choice(t_num-window_size) = 2;
    end    
    
end 

num_corr_preds = 0;

for j = 1 : length(pred_choice)
    if pred_choice(j) == choice_order(j+window_size)
        num_corr_preds = num_corr_preds + 1;
    end
end    
