cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
% cd('/Volumes/turner$/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

CR_mat = []
RR_mat = []
count = 0;
lookback = 10;

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =4:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
%             count = count+1;
            continue
            %SKIPPING LOW MI EXPTS FOR GR64f
%             elseif expt_n == 1
%                 if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                     continue
%                 end
%             elseif expt_n == 2
%                 if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                     continue
%                 end

        end
        count = count+1
        choice_order = [];
        reward_order = [];
        
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)

        load('YArenaRunLearningCurve.mat')
%         load('reward_order.mat')
        
        choice_order = Choices;
%         reward_order = reward_order(:,2);
        

        for j = 1:length(choice_order)
            if j < lookback
                num_O_choices = length(find(choice_order(1:j) == 1));
                num_M_choices = length(find(choice_order(1:j) == 0));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    CR_mat(j,count) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    CR_mat(j,count) = 0;
                elseif num_M_choices == 0 
                    CR_mat(j,count) = 90;
                end    
            else
                num_O_choices = length(find(choice_order(j-(lookback-1):j) == 1));
                num_M_choices = length(find(choice_order(j-(lookback-1):j) == 0));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    CR_mat(j,count) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    CR_mat(j,count) = 0;
                elseif num_M_choices == 0 
                    CR_mat(j,count) = 90;
                end   
            end
        end 
        
%         for j = 1:length(reward_order) 
%             if j>0 && j< lookback    
%                 num_O_rewards = length(find(reward_order(1:j) == 2));
%                 num_M_rewards = length(find(reward_order(1:j) == 1));
%                 if num_O_rewards ~= 0 && num_M_rewards ~= 0
%                     RR_mat(j,count) = (((0 + lookback-j)*rad2deg(atan(num_O_rewards/num_M_rewards)))+((j)*45))/lookback;
%                 elseif num_O_rewards == 0
%                     RR_mat(j,count) = (((0 + lookback-j)*0)+((j)*45))/lookback;
%                 elseif num_M_rewards == 0 
%                     RR_mat(j,count) = (((0 + lookback-j)*90)+((j)*45))/lookback;
%                 end    
%             else
%                 num_O_rewards = length(find(reward_order(j-(lookback-1):j) == 2));
%                 num_M_rewards = length(find(reward_order(j-(lookback-1):j) == 1));
%                 if num_O_rewards ~= 0 && num_M_rewards ~= 0
%                     RR_mat(j,count) = rad2deg(atan(num_O_rewards/num_M_rewards));
%                 elseif num_O_rewards == 0
%                     RR_mat(j,count) = 0;
%                 elseif num_M_rewards == 0 
%                     RR_mat(j,count) = 90;
%                 end   
%             end
%         end
    end
%     for i = 1:2:6
% 
%         CR_mat(:,i) = 90-CR_mat(:,i);
% 
%     end    
end
            