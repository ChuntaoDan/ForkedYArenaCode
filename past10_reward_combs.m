% Creat vectors to permute with different number of 1s and 0s

all_reward_combs = []

for i = 0:10
    for j = 0:10-i
        v = zeros(10,1);
        v(1:i) = 1;
        v(i+1:i+j) = 2;

        
        % all perms of vectors above and then finding unique combs
        all_reward_perms_ij = perms(v);
        [C,ia,ic] = unique(all_reward_perms_ij,'rows');
        all_reward_combs_ij = all_reward_perms_ij(ia,:);
        
        all_reward_combs = vertcat(all_reward_combs,all_reward_combs_ij);
    end
end    

save('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/past10_reward_combs.mat', 'all_reward_combs')

