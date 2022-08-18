cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
% cd('/Volumes/turner$/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

CR_mat = [];
RR_mat = [];
count = 0;
lookback = 10;
n =[ 240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240
   240];

for expt_n = 1:2%length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
%             count = count+1;
            continue
%             SKIPPING LOW MI EXPTS FOR GR64f
            elseif expt_n == 1
                if ismember(cond_n,[1,4,5,7,8,9,11,13,14,15,16,17,18,22]+3)
                    continue
                end
            elseif expt_n == 2
                if ismember(cond_n,[4,5,6,9,11,12,13,15,16,17,18,19,20]+2)
                    continue
                end

        end
        count = count+1
        choice_order = [];
        reward_order = [];
        
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        RO = load('reward_order.mat');
        CO = load('choice_order.mat');
        CO = CO.choice_order;
        RO = RO.reward_order;
        choice_order = [];
        reward_order = [];
        
        
        for k = 1:size(CO,2)
        choice_order((k-1)*length(CO) + 1 : (k)*length(CO)) = CO(:,k);
        reward_order((k-1)*length(CO) + 1 : (k)*length(CO)) = RO(:,k);
        end
        
        

        for j = 1:length(choice_order)
            if j < lookback
                num_O_choices = length(find(choice_order(1:j) == 2));
                num_M_choices = length(find(choice_order(1:j) == 1));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    CR_mat(j,count) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    CR_mat(j,count) = 0;
                elseif num_M_choices == 0 
                    CR_mat(j,count) = 90;
                end    
            else
                num_O_choices = length(find(choice_order(j-(lookback-1):j) == 2));
                num_M_choices = length(find(choice_order(j-(lookback-1):j) == 1));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    CR_mat(j,count) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    CR_mat(j,count) = 0;
                elseif num_M_choices == 0 
                    CR_mat(j,count) = 90;
                end   
            end
        end 
        
        for j = 1:length(reward_order) 
            if j>0 && j< lookback    
                num_O_rewards = length(find(reward_order(1:j) == 2));
                num_M_rewards = length(find(reward_order(1:j) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    RR_mat(j,count) = (((0 + lookback-j)*rad2deg(atan(num_O_rewards/num_M_rewards)))+((j)*45))/lookback;
                elseif num_O_rewards == 0
                    RR_mat(j,count) = (((0 + lookback-j)*0)+((j)*45))/lookback;
                elseif num_M_rewards == 0 
                    RR_mat(j,count) = (((0 + lookback-j)*90)+((j)*45))/lookback;
                end    
            else
                num_O_rewards = length(find(reward_order(j-(lookback-1):j) == 2));
                num_M_rewards = length(find(reward_order(j-(lookback-1):j) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    RR_mat(j,count) = rad2deg(atan(num_O_rewards/num_M_rewards));
                elseif num_O_rewards == 0
                    RR_mat(j,count) = 0;
                elseif num_M_rewards == 0 
                    RR_mat(j,count) = 90;
                end   
            end
        end
    
    figure; plot(1:length(CR_mat(1:n(count),count)),CR_mat(1:n(count),count),'LineWidth',4,'Color','b')
    hold on; plot(1:length(RR_mat(1:n(count),count)),RR_mat(1:n(count),count),'LineWidth',4,'Color','k')
    
    num_O_rewarded_1 = length(find(reward_order(1:80) == 2));
    num_M_rewarded_1 = length(find(reward_order(1:80) == 1));
    ave_reward_slope_1 = (num_O_rewarded_1/num_M_rewarded_1);
    ave_reward_ratio_1 = rad2deg(atan(ave_reward_slope_1));
    num_O_choices_1 = length(find(choice_order(1 : 80) == 2));
    num_M_choices_1 = length(find(choice_order(1 : 80) == 1));     
    ave_choice_ratio_1 = rad2deg(atan(num_O_choices_1/num_M_choices_1));

    plot(1:80,ones(1,80)*ave_reward_ratio_1,'LineWidth',6,'Color','k')
    plot(1:80,ones(1,80)*ave_choice_ratio_1,'LineWidth',6,'Color','b')
    
    if length(choice_order) >=160
        num_O_rewarded_2 = length(find(reward_order(81:160) == 2));
        num_M_rewarded_2 = length(find(reward_order(81:160) == 1));
        ave_reward_slope_2 = (num_O_rewarded_2/num_M_rewarded_2);
        ave_reward_ratio_2 = rad2deg(atan(ave_reward_slope_2));
        num_O_choices_2 = length(find(choice_order(81 : 160) == 2));
        num_M_choices_2 = length(find(choice_order(81 : 160) == 1));     
        ave_choice_ratio_2 = rad2deg(atan(num_O_choices_2/num_M_choices_2));

        plot(81:160,ones(1,80)*ave_reward_ratio_2,'LineWidth',6,'Color','k')
        plot(81:160,ones(1,80)*ave_choice_ratio_2,'LineWidth',6,'Color','b')
    else
        num_O_rewarded_2 = length(find(reward_order(81:end) == 2));
        num_M_rewarded_2 = length(find(reward_order(81:end) == 1));
        ave_reward_slope_2 = (num_O_rewarded_2/num_M_rewarded_2);
        ave_reward_ratio_2 = rad2deg(atan(ave_reward_slope_2));
        num_O_choices_2 = length(find(choice_order(81 : end) == 2));
        num_M_choices_2 = length(find(choice_order(81 : end) == 1));     
        ave_choice_ratio_2 = rad2deg(atan(num_O_choices_2/num_M_choices_2));

        plot(81:length(choice_order),ones(1,length(choice_order(81:end)))*ave_reward_ratio_2,'LineWidth',6,'Color','k')
        plot(81:length(choice_order),ones(1,length(choice_order(81:end)))*ave_choice_ratio_2,'LineWidth',6,'Color','b')
   
    end
    
    if length(choice_order) == 240
        num_O_rewarded_3 = length(find(reward_order(161:240) == 2));
        num_M_rewarded_3 = length(find(reward_order(161:240) == 1));
        ave_reward_slope_3 = (num_O_rewarded_3/num_M_rewarded_3);
        ave_reward_ratio_3 = rad2deg(atan(ave_reward_slope_3));
        num_O_choices_3 = length(find(choice_order(161 : 240) == 2));
        num_M_choices_3 = length(find(choice_order(161 : 240) == 1));     
        ave_choice_ratio_3 = rad2deg(atan(num_O_choices_3/num_M_choices_3));

        plot(161:240,ones(1,80)*ave_reward_ratio_3,'LineWidth',6,'Color','k')
        plot(161:240,ones(1,80)*ave_choice_ratio_3,'LineWidth',6,'Color','b')
    else
        num_O_rewarded_2 = length(find(reward_order(161:end) == 2));
        num_M_rewarded_2 = length(find(reward_order(161:end) == 1));
        ave_reward_slope_2 = (num_O_rewarded_2/num_M_rewarded_2);
        ave_reward_ratio_2 = rad2deg(atan(ave_reward_slope_1));
        num_O_choices_2 = length(find(choice_order(161 : end) == 2));
        num_M_choices_2 = length(find(choice_order(161 : end) == 1));     
        ave_choice_ratio_2 = rad2deg(atan(num_O_choices_2/num_M_choices_2));

        plot(161:length(choice_order),ones(1,length(choice_order(161:end)))*ave_reward_ratio_2,'LineWidth',6,'Color','k')
        plot(161:length(choice_order),ones(1,length(choice_order(161:end)))*ave_choice_ratio_2,'LineWidth',6,'Color','b')
   
    end
    
    filename = sprintf('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/Baited_Reward_V2/instCRRR/instCR_RR_fly%d_expt%d.fig',cond_n,expt_n);

    savefig(filename)
    
    close all
    
    end
%     for i = 1:2:6
% 
%         CR_mat(:,i) = 90-CR_mat(:,i);
% 
%     end    
end
            