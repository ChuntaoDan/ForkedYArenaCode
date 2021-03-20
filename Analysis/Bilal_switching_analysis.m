cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)
lookback = 10

individual_pi = [];
arm_bias_expected_pi = [];
count = 0;
cpms = [];
fig_count = 0;
ave_choice_ratios = [];
ave_reward_ratios = [];
ave_choice_ratios_sec_half = [];
ave_reward_ratios_sec_half = [];

color_vec = cbrewer('qual','Dark2',10,'cubic');
Air_Color = 0*color_vec(6,:);
O_A_Color = color_vec(1,:);
O_M_Color = 0.6*color_vec(1,:);
M_A_Color = color_vec(7,:);
M_O_Color = 0.7*color_vec(7,:);

CR = [];

for expt_n = 1:2%2
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            continue
            %SELECTING GOOD EXPTS BASED ON MI FOR GR64f
        elseif expt_n == 1
            if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
                continue
            end
        elseif expt_n == 2
            if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
                continue
            end
        end

        choice_order = [];
        reward_order = [];
        count = count + 1;
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
%             if exist('figure1.fig')==2
%                 continue
%             end    
        gotofig = 0;
        gotofig2 = 0;
        
        RO = load('reward_order.mat');
        CO = load('choice_order.mat');
        CO = CO.choice_order;
        RO = RO.reward_order;
        choice_order = [];
        reward_order = [];
        inst_choice_ratio = [];
        
        for k = 1:size(CO,2)
        choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
        reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
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
        
        CR(count,1:length(choice_order)) = inst_choice_ratio;
    end
end    
                
            