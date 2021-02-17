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

        % H(Y) - Here Y = most recent past reward

        Y_counts = zeros(Y_dim*3,1);

        for i = 2:length(choice_order)
            if reward_order(i-1) == 0
                Y_counts(1) = Y_counts(1) + 1;
            elseif reward_order(i-1) == 1
                Y_counts(2) = Y_counts(2) + 1;
            else
                Y_counts(3) = Y_counts(3) + 1;
            end
        end    

        P_Y = Y_counts/sum(Y_counts);
        H_Y = -sum(P_Y.*log(P_Y));

        % H(Y|X) - Here Y = most recent past choice

        YgX_counts = zeros(Y_dim*3,X_dim*2);

        for i = 2:length(choice_order)
            if reward_order(i-1) == 0
                if choice_order(i) == 1
                    YgX_counts(1,1) = YgX_counts(1,1) + 1;
                else
                    YgX_counts(1,2) = YgX_counts(1,2) + 1;
                end    
            elseif reward_order(i-1) == 1
                if choice_order(i) == 1
                    YgX_counts(2,1) = YgX_counts(2,1) + 1;
                else
                    YgX_counts(2,2) = YgX_counts(2,2) + 1;
                end
            elseif reward_order(i-1) == 2
                if choice_order(i) == 1
                    YgX_counts(3,1) = YgX_counts(3,1) + 1;
                else
                    YgX_counts(3,2) = YgX_counts(3,2) + 1;
                end       
            end
        end 



        P_YgX = YgX_counts./sum(YgX_counts);
        H_YgX_x = -sum(P_YgX.*log(P_YgX));
        H_YgX = sum((sum(YgX_counts)./sum(sum(YgX_counts))).*H_YgX_x);

        MI(count) = H_Y - H_YgX;
    end
end    