cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

fig_count = 0;

count_data = 0;

summed_high = zeros(10,41);
summed_low = zeros(10,41);

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
        load('all_variables_contingency_2.mat')
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
        
        if x1 == 0.8
            trial = 1;
            for i = 81:2:160
                trial = trial+1;
                if choice_order(i) == 2
                    summed_high(count_data,trial) = summed_high(count_data,trial-1)+1;
                else
                    summed_high(count_data,trial) = summed_high(count_data,trial-1);
                end
            end
            trial = 1;
            for i = 82:2:160
                trial = trial+1;
                if choice_order(i) == 1
                    summed_low(count_data,trial) = summed_low(count_data,trial-1)+1;
                else
                    summed_low(count_data,trial) = summed_low(count_data,trial-1);
                end
            end
        else
            trial = 1;
            for i = 81:2:160
                trial = trial+1;
                if choice_order(i) == 2
                    summed_low(count_data,trial) = summed_low(count_data,trial-1)+1;
                else
                    summed_low(count_data,trial) = summed_low(count_data,trial-1);
                end
            end
            trial = 1;
            for i = 82:2:160
                trial = trial+1;
                if choice_order(i) == 1
                    summed_high(count_data,trial) = summed_high(count_data,trial-1)+1;
                else
                    summed_high(count_data,trial) = summed_high(count_data,trial-1);
                end
            end
        end
    end
end