% code aimed at simulating a range of experiments using one of the three
% strategies I have previously defined to describe local behavior that
% gives rise to Matching as a global behvaior. the chosen strategy will
% be used to generate experiments consisting of 'nblock' blocks of
% 'ntrial'trials in each block. The pRs for each block will be randomly
% drawn from the set of the following ratios (8:1,4:1,2:1,1:1,1:2,1:4,1:8) 
% and will include 10 trials for each random set. No set of 3 blocks will 
% multiple blocks with same rPs - summing up to 2100 expts per strategy.

function [nC1,nC2,nI1,nI2,I1_list,I2_list,C1_list,C2_list,v1,v2] = sim_multiple_choice_expts(strategy_num,version_number,ntrials,nblocks,total_prob_r)

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
I_list = [];
I1_list = [];
I2_list = [];
C1_list = [];
C2_list = [];
C_list = [];
v1 = [];
v2 = [];
count = 0;
for jj = 1:length(reward_conts)
    for kk = 1:10
        count = count+1;
        if strategy_num == 1
            [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:)] = Strategy1(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:));
        elseif strategy_num == 2
            if version_number == 1
                [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:),v1(count,:),v2(count,:)] = Strategy2(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:),window_trials);
            else
                [nC1(count),nC2(count),nI1(count),nI2(count),I_list(count,:),C_list(count,:),v1(count,:),v2(count,:)] = Strategy2_v2(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:),window_trials);
            end
        elseif strategy_num == 3
            [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:),v1(count,:),v2(count,:)] = Strategy3(nblocks,ntrials,reward_conts(jj,:),total_prob_r-reward_conts(jj,:),window_trials,exp_p);
        end 
    end    
end    


%%
if exist('C1_list') == 1 && isempty(C1_list) ~= 1
    % p(staying|Reward)


    for i = 1:2100
        n_staying_g_reward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C1_list(i,j-1) == 1
                if I1_list(i,j-1) == 1
                    if C1_list(i,j) == 1
                        n_staying_g_reward = n_staying_g_reward + 1;
                    end
                end
            elseif C2_list(i,j-1) == 1  
                if I2_list(i,j-1) == 1
                    if C2_list(i,j) == 1
                        n_staying_g_reward = n_staying_g_reward + 1;
                    end
                end
            end    
        end 
        p_staying_g_reward(i) = n_staying_g_reward/t_num_trials;
    end    




    % p(staying|NReward)


    for i = 1:2100
        n_staying_g_Nreward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C1_list(i,j-1) == 1
                if I1_list(i,j-1) == 0
                    if C1_list(i,j) == 1
                        n_staying_g_Nreward = n_staying_g_Nreward + 1;
                    end
                end
            elseif C2_list(i,j-1) == 1  
                if I2_list(i,j-1) == 0
                    if C2_list(i,j) == 1
                        n_staying_g_Nreward = n_staying_g_Nreward + 1;
                    end
                end
            end    
        end  
        p_staying_g_Nreward(i) = n_staying_g_Nreward/t_num_trials;
    end    


    % p(switching|NoReward)

    for i = 1:2100
        n_switching_g_Nreward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C1_list(i,j-1) == 1
                if I1_list(i,j-1) == 0
                    if C2_list(i,j) == 1
                        n_switching_g_Nreward = n_switching_g_Nreward + 1;
                    end
                end
            elseif C2_list(i,j-1) == 1  
                if I2_list(i,j-1) == 0
                    if C1_list(i,j) == 1
                        n_switching_g_Nreward = n_switching_g_Nreward + 1;
                    end
                end
            end    
        end       
        p_switching_g_Nreward(i) = n_switching_g_Nreward/t_num_trials;
    end


    % p(switching|Reward)

    for i = 1:2100
        n_switching_g_reward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C1_list(i,j-1) == 1
                if I1_list(i,j-1) == 1
                    if C2_list(i,j) == 1
                        n_switching_g_reward = n_switching_g_reward + 1;
                    end
                end
            elseif C2_list(i,j-1) == 1  
                if I2_list(i,j-1) == 1
                    if C1_list(i,j) == 1
                        n_switching_g_reward = n_switching_g_reward + 1;
                    end
                end
            end    
        end

        p_switching_g_reward(i) = n_switching_g_reward/t_num_trials;
    
    end

else
    for i = 1:2100
        n_staying_g_reward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C_list(i,j-1) == 1
                if I_list(i,j-1) == 1
                    if C_list(i,j) == 1
                        n_staying_g_reward = n_staying_g_reward + 1;
                    end
                end
            elseif C_list(i,j-1) == 2  
                if I_list(i,j-1) == 2
                    if C_list(i,j) == 2
                        n_staying_g_reward = n_staying_g_reward + 1;
                    end
                end
            end    
        end 
        p_staying_g_reward(i) = n_staying_g_reward/t_num_trials;
    end    




    % p(staying|NReward)


    for i = 1:2100
        n_staying_g_Nreward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C_list(i,j-1) == 1
                if I_list(i,j-1) == 0
                    if C_list(i,j) == 1
                        n_staying_g_Nreward = n_staying_g_Nreward + 1;
                    end
                end
            elseif C_list(i,j-1) == 2  
                if I_list(i,j-1) == 0
                    if C_list(i,j) == 2
                        n_staying_g_Nreward = n_staying_g_Nreward + 1;
                    end
                end
            end    
        end  
        p_staying_g_Nreward(i) = n_staying_g_Nreward/t_num_trials;
    end    


    % p(switching|NoReward)

    for i = 1:2100
        n_switching_g_Nreward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C_list(i,j-1) == 1
                if I_list(i,j-1) == 0
                    if C_list(i,j) == 2
                        n_switching_g_Nreward = n_switching_g_Nreward + 1;
                    end
                end
            elseif C_list(i,j-1) == 2  
                if I_list(i,j-1) == 0
                    if C_list(i,j) == 1
                        n_switching_g_Nreward = n_switching_g_Nreward + 1;
                    end
                end
            end    
        end       
        p_switching_g_Nreward(i) = n_switching_g_Nreward/t_num_trials;
    end


    % p(switching|Reward)

    for i = 1:2100
        n_switching_g_reward = 0;
        t_num_trials = 0;
        for j = 2:240
            t_num_trials = t_num_trials + 1;
            if C_list(i,j-1) == 1
                if I_list(i,j-1) == 1
                    if C_list(i,j) == 2
                        n_switching_g_reward = n_switching_g_reward + 1;
                    end
                end
            elseif C_list(i,j-1) == 2  
                if I_list(i,j-1) == 2
                    if C_list(i,j) == 1
                        n_switching_g_reward = n_switching_g_reward + 1;
                    end
                end
            end    
        end

        p_switching_g_reward(i) = n_switching_g_reward/t_num_trials;
    
    end
end
%% SAVING
if strategy_num == 1
    filename = sprintf('Strategy%d_allSims_probs.mat',strategy_num)
elseif strategy_num == 2
    filename = sprintf('Strategy%d_intWind%d_allSims_probs.mat',strategy_num,window_trials)
else
    filename = sprintf('Strategy%d_intWind%d_expPerc%d_allSims_probs.mat',strategy_num,window_trials,exp_p*100)
end    
save(filename)
end
