cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

fig_count = 0;
rewarded_odor = [];
unrewarded_odor = [];
error_count_tA = [];
count_data = 0;
lookback = 10;
color_vec = cbrewer('qual','Dark2',10,'cubic');
Air_Color = 0*color_vec(6,:);
O_A_Color = color_vec(1,:);
O_M_Color = 0.6*color_vec(1,:);
M_A_Color = color_vec(7,:);
M_O_Color = 0.7*color_vec(7,:);

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')

            continue
            %SKIPPING LOW MI EXPTS FOR GR64f 3 block expts
%         elseif expt_n == 1
%             if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                 continue
%             end
%         elseif expt_n == 2
%             if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                 continue
%             end

        end
        count_data = count_data+1;
        choice_order = [];
        reward_order = [];

        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)

        load('choice_order.mat')
        load('reward_order.mat')

        choice_order = choice_order(:,2);
        
        if length(find(reward_order(:,2) == 1)) > length(find(reward_order(:,2) == 2))
            rewarded_odor = 1;
            unrewarded_odor = 2;
        else
            rewarded_odor = 2;
            unrewarded_odor = 1;
        end
        
         for j = 1:length(choice_order)
            if j < lookback
                num_O_choices = length(find(choice_order(1:j) == 2));
                num_M_choices = length(find(choice_order(1:j) == 1));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    inst_choice_ratio(j) = 0;
                elseif num_M_choices == 0 
                    inst_choice_ratio(j) = 90;
                end    
            else
                num_O_choices = length(find(choice_order(j-(lookback-1):j) == 2));
                num_M_choices = length(find(choice_order(j-(lookback-1):j) == 1));
                if num_O_choices ~= 0 && num_M_choices ~= 0
                    inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
                elseif num_O_choices == 0
                    inst_choice_ratio(j) = 0;
                elseif num_M_choices == 0 
                    inst_choice_ratio(j) = 90;
                end   
            end
         end  
        if rewarded_odor == 1 
            inst_choice_ratio_mat(count_data,:) = 90-inst_choice_ratio;
        else
            inst_choice_ratio_mat(count_data,:) = inst_choice_ratio;
        end
        
    end
end
