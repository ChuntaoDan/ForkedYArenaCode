% Creat vectors to permute with different number of 1s and 0s
window_size = 1
all_reward_combs = []

for i = 0:window_size
    for j = 0:window_size-i
        v = zeros(window_size,1);
        v(1:i) = 1;
        v(i+1:i+j) = 2;

        
        % all perms of vectors above and then finding unique combs
        all_reward_perms_ij = perms(v);
        [C,ia,ic] = unique(all_reward_perms_ij,'rows');
        all_reward_combs_ij = all_reward_perms_ij(ia,:);
        
        all_reward_combs = vertcat(all_reward_combs,all_reward_combs_ij);
    end
end    
filename = sprintf('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/past%d_reward_combs.mat',window_size)
save(filename, 'all_reward_combs')

