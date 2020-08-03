function [inst_choice_ratio,inst_income_ratio,ave_pre_choice_ratio,ave_post_choice_ratio,fig_count,ave_post_reward_ratio] = inst_CR_model(fig_count,cps_pre,cps_post,protocol_100_0,choice_order,reward_order,lookback)
    
    
    inst_choice_ratio = [];
    
    % inst_CR is calculated as rolling window of current and past 5 trials
    
    for j = 1:length(C1_list)
        if j < lookback
            num_O_choices = length(find(C1_list(1:j) == 1));
            num_M_choices = length(find(C2_list(1:j) == 1));
            if num_O_choices ~= 0 && num_M_choices ~= 0
                inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
            elseif num_O_choices == 0
                inst_choice_ratio(j) = 0;
            elseif num_M_choices == 0 
                inst_choice_ratio(j) = 90;
            end    
        else
            num_O_choices = length(find(C1_list(j-(lookback-1):j) == 1));
            num_M_choices = length(find(C2_list(j-(lookback-1):j) == 1));
            if num_O_choices ~= 0 && num_M_choices ~= 0
                inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
            elseif num_O_choices == 0
                inst_choice_ratio(j) = 0;
            elseif num_M_choices == 0 
                inst_choice_ratio(j) = 90;
            end   
        end
    end 
    
    num_O_choices = length(find(C1_list == 1));
    num_M_choices = length(find(C2_list == 1));
    ave_choice_ratio = rad2deg(atan(num_O_choices/num_M_choices));
    
    num_O_rewarded = length(find(I1_list == 1));
    num_M_rewarded = length(find(I2_list == 1));
    ave_reward_ratio = rad2deg(atan(num_O_rewarded/num_M_rewarded));
    
    inst_income_ratio = [];

        
    for j = 1:length(I1_list)
        if j < lookback
            num_O_rewards = length(find(I1_list(1:j) == 1));
            num_M_rewards = length(find(I2_list(1:j) == 1));
            if num_O_choices ~= 0 && num_M_choices ~= 0
                inst_income_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
            elseif num_O_choices == 0
                inst_income_ratio(j) = 0;
            elseif num_M_choices == 0 
                inst_income_ratio(j) = 90;
            end    
        else
            num_O_rewards = length(find(I1_list == 1));
            num_M_rewards = length(find(I2_list == 1));
            if num_O_rewards ~= 0 && num_M_rewards ~= 0
                inst_income_ratio(j) = rad2deg(atan(num_O_rewards/num_M_rewards));
            elseif num_O_rewards == 0
                inst_income_ratio(j) = 0;
            elseif num_M_rewards == 0 
                inst_income_ratio(j) = 90;
            end   

        end
    end    
        
    
    figure
    
    plot(inst_choice_ratio,'LineWidth',4,'Color','b')
    hold on
    
    plot([1:length(C1_list)],ones(1,length(C1_list))*ave_reward_ratio,'LineWidth',6,'Color','k')
    plot([1:length(C2_list)],ones(1,length(C2_list))*ave_choice_ratio,'LineWidth',6,'Color','b')
    for r = 1:length(I1_list)
        if C1_list(r) == 1
            if I1_list(r) == 1
                plot([r,r],[92,97],'Color',[84/256,174/256,0],'LineWidth',4)
            else
                plot([r,r],[92,94],'Color',[84/256,174/256,0],'LineWidth',4)
            end
        elseif C2_list(r) == 1
            if I2_list(r) == 1
                plot([r,r],[-7,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            else
                plot([r,r],[-4,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            end
        end
    end
    box off
    axis off
    ylim([-7,97])

end