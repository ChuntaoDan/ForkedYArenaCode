% code aimed at simulating a range of experiments using one of the three
% strategies I have previously defined to describe local behavior that
% gives rise to Matching as a global behvaior. the chosen strategy will
% be used to generate experiments consisting of 'nblock' blocks of
% 'ntrial'trials in each block. The pRs for each block will be randomly
% drawn from the set of the following ratios (8:1,4:1,2:1,1:1,1:2,1:4,1:8) 
% and will include 10 trials for each random set. No set of 3 blocks will 
% multiple blocks with same rPs - summing up to 2100 expts per strategy.

function [nC1,nC2,nI1,nI2,I1_list,I2_list,C1_list,C2_list,v1,v2] = sim_multiple_choice_expts(strategy_num,ntrials,nblocks,total_prob_r)

if strategy_num == 3
    window_trials = input('enter window_trials');
    exp_p = input('enter prob of exploration');
elseif strategy_num == 2
     window_trials = input('enter window_trials');
end

reward_cont_list = [(8/9)*total_prob_r,(4/5)*total_prob_r,(2/3)*total_prob_r,(1/2)*total_prob_r,total_prob_r-(2/3)*total_prob_r,total_prob_r-(4/5)*total_prob_r,total_prob_r-(8/9)*total_prob_r];

reward_set_order = combnk([1,2,3,4,5,6,7],nblocks);

reward_set = [0,0,0];
for ii = 1:length(reward_set_order) 
    
    A = perms(reward_set_order(ii,:));
    reward_set = cat(1,reward_set,A);
end    

reward_set = reward_set(2:end,:);

reward_conts = reward_cont_list(reward_set);

nC1 = [];
nC2 = [];
nI1 = [];
nI2 = [];
I1_list = [];
I2_list = [];
C1_list = [];
C2_list = [];
v1 = [];
v2 = [];
count = 0;
for jj = 1:length(reward_conts)
    for kk = 1:10
        count = count+1;
        if strategy_num == 1
            [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:)] = Strategy1(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:));
        elseif strategy_num == 2
            [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:),v1(count,:),v2(count,:)] = Strategy2(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:),window_trials);
        elseif strategy_num == 3
            [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:),v1(count,:),v2(count,:)] = Strategy3(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:),window_trials,exp_p);
        end 
    end    
end    

end

