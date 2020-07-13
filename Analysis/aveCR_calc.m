cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

ave_post_choice_ratios = [];
fig_count = 0;
lookback = 1;
for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        if expt_name(end-10:end-6) == '100_0'
            protocol_100_0 = 1;
        elseif expt_name(end-4:end) == '80_20'
            protocol_100_0 = 2;
        elseif expt_name(end-4:end) == '60_40'
            protocol_100_0 = 3;    
        end    
        cd(expt_name)
        conds = dir(expt_name);

        for cond_n = 1:length(conds)
            
            if startsWith(conds(cond_n).name, '.')
                
                continue
            end
            


            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            
            load('all_variables.mat')
            
            if protocol_100_0 ~= 1
            
                [pi,cps_30test] = preference_index(air_arm(1:end/2),right_left(1:end/2));
            
            else
                [pi,cps_30test] = preference_index(air_arm,right_left);
            end
            
            cps_pre = load('cps_pre.mat');
            cps_pre = cps_pre.cps_pre;
            choice_order = load('choice_order.mat');
            choice_order = choice_order.choice_order;
            reward_order = load('reward_order.mat');
            reward_order = reward_order.reward_order;
            
            if protocol_100_0 ~= 1
                [inst_choice_ratio,inst_income_ratio,ave_pre_choice_ratios(expt_n,cond_n-2),ave_post_choice_ratios(expt_n,cond_n-2),fig_count,ave_post_income_ratios(expt_n,cond_n-2)] = inst_CR(fig_count,cps_pre,cps_30test(length(cps_pre)+1:end),protocol_100_0,choice_order(1:length(cps_30test)),reward_order(1:length(cps_30test)),lookback)
            else
                [inst_choice_ratio,inst_income_ratio,ave_pre_choice_ratios(expt_n,cond_n-2),ave_post_choice_ratios(expt_n,cond_n-2),fig_count,ave_post_income_ratios(expt_n,cond_n-2)] = inst_CR(fig_count,cps_pre,cps_30test(length(cps_pre)+1:end),protocol_100_0,choice_order,reward_order,lookback)
           
            end
        end
end

ave_post_income_ratios(1,1:7) = 90;
pre_diff = 45-ave_pre_choice_ratios
post_plus_diff = ave_post_choice_ratios + pre_diff

vals = find(post_plus_diff > 90);
post_plus_diff(vals) = 90;
figure

x = [0 90];
y = x;
plot(x,y,'LineWidth',6)
hold on;
scatter (ave_post_income_ratios(2,1:7),post_plus_diff(2,1:7),200,'filled','MarkerFaceColor','k','MarkerEdgeColor','k')
scatter (ave_post_income_ratios(3,1:7),post_plus_diff(3,1:7),200,'filled','MarkerFaceColor','k','MarkerEdgeColor','k')


figure

x = [0 90];
y = x;
plot(x,y,'LineWidth',6)
hold on;
scatter (ave_post_income_ratios(2,1:7),ave_post_choice_ratios(2,1:7),200,'filled','MarkerFaceColor','k','MarkerEdgeColor','k')
scatter (ave_post_income_ratios(3,1:7),ave_post_choice_ratios(3,1:7),200,'filled','MarkerFaceColor','k','MarkerEdgeColor','k')
