clc
clear
close all
count = 0
% Select spreadsheet containing experiment names
cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);

MI = [];

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    for cond_n = 1:length(conds)-4
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            
            continue
        end

        count = count+1;
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        % MI between current choice and past reward
        Y_dim = 15; % number of trials in past to look at reward
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
        
                
        zero_locs = find(choice_order == 0);
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];


        % H(Y) - Here Y = most recent past reward

        Y_counts = zeros(Y_dim+1,Y_dim+1,Y_dim+1);

        for i = Y_dim+1:length(choice_order)
            Y_1 = length(find(reward_order(i-Y_dim:i-1)==1))+1;
            Y_2 = length(find(reward_order(i-Y_dim:i-1)==2))+1;
            Y_0 = length(find(reward_order(i-Y_dim:i-1)==0))+1;
            Y_counts(Y_1,Y_2,Y_0) = Y_counts(Y_1,Y_2,Y_0) + 1;
        end   

        P_Y = Y_counts/sum(sum(sum(Y_counts)));
        W = P_Y.*log(P_Y);
        W_nan = isnan(W)
        W(find(W_nan == 1)) = 0
        H_Y = -sum(sum(sum(W)));

        % H(Y|X) - Here Y = most recent past choice

        YgX_counts = zeros(Y_dim+1,Y_dim+1,Y_dim+1,X_dim*2);

        for i = Y_dim+1:length(choice_order)
            Y_1 = length(find(reward_order(i-Y_dim:i-1)==1))+1;
            Y_2 = length(find(reward_order(i-Y_dim:i-1)==2))+1;
            Y_0 = length(find(reward_order(i-Y_dim:i-1)==0))+1;
            
            if choice_order(i) == 1
                YgX_counts(Y_1,Y_2,Y_0,1) = YgX_counts(Y_1,Y_2,Y_0,1) + 1;
            else
                YgX_counts(Y_1,Y_2,Y_0,2) = YgX_counts(Y_1,Y_2,Y_0,2) + 1;
            end    

        end 


        P_YgX = YgX_counts./sum(sum(sum(YgX_counts)));
        V = P_YgX.*log(P_YgX);
        V_nan = isnan(V);
        V(find(V_nan == 1)) = 0;
        H_YgX_x = -sum(sum(sum(V)));
        H_YgX = sum((sum(sum(sum(YgX_counts)))./sum(sum(sum(sum(YgX_counts))))).*H_YgX_x);

        MI(count) = H_Y - H_YgX;
    end
end    