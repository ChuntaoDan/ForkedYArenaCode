choice_order = [];
reward_order = [];
reward_order_2 = [];
for a = 1:2100
    choice_order = cat(2,choice_order,C1_list(a,:));
    reward_order = cat(2,reward_order,I1_list(a,:));
end

z_list = find(choice_order == 0);
choice_order(z_list) = 2;

for a = 1:2100
    reward_order_2 = cat(2,reward_order_2,I2_list(a,:));
end

for b = 1:length(reward_order)
    if reward_order(b) == 0 && reward_order_2(b) == 1
        reward_order(b) = 2;
    end
end    