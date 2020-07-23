function [inst_choice_ratio,inst_income_ratio,ave_pre_choice_ratio,ave_post_choice_ratio,fig_count,ave_post_reward_ratio] = inst_CR(fig_count,cps_pre,cps_post,protocol_100_0,choice_order,reward_order,lookback)
    
    
    inst_choice_ratio = [];
    
    % inst_CR is calculated as rolling window of current and past 5 trials
    
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
    num_O_choices_pre = length(find(choice_order(1:length(cps_pre)) == 2));
    num_M_choices_pre = length(find(choice_order(1:length(cps_pre)) == 1));
    ave_pre_choice_ratio = rad2deg(atan(num_O_choices_pre/num_M_choices_pre));
    
    num_O_choices_post = length(find(choice_order(length(cps_pre)+1 : end) == 2));
    num_M_choices_post = length(find(choice_order(length(cps_pre)+1 : end) == 1));
    ave_post_choice_ratio = rad2deg(atan(num_O_choices_post/num_M_choices_post));
    
    num_O_rewarded_post = length(find(reward_order(length(cps_pre)+1 : end) == 2));
    num_M_rewarded_post = length(find(reward_order(length(cps_pre)+1 : end) == 1));
    ave_post_reward_ratio = rad2deg(atan(num_O_rewarded_post/num_M_rewarded_post));
    
    inst_income_ratio = [];
    if protocol_100_0 ~= 1
        
        for j = 1:length(reward_order)
            if j<=length(cps_pre)
                inst_income_ratio(j) = 45;
            elseif j>length(cps_pre) && j<length(cps_pre) + lookback    
                num_O_rewards = length(find(reward_order(1:j) == 2));
                num_M_rewards = length(find(reward_order(1:j) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    inst_income_ratio(j) = (((length(cps_pre) + lookback-j)*rad2deg(atan(num_O_rewards/num_M_rewards)))+((j-length(cps_pre))*45))/lookback;
                elseif num_O_rewards == 0
                    inst_income_ratio(j) = (((length(cps_pre) + lookback-j)*0)+((j-length(cps_pre))*45))/lookback;
                elseif num_M_rewards == 0 
                    inst_income_ratio(j) = (((length(cps_pre) + lookback-j)*90)+((j-length(cps_pre))*45))/lookback;;
                end    
            else
                num_O_rewards = length(find(reward_order(j-(lookback-1):j) == 2));
                num_M_rewards = length(find(reward_order(j-(lookback-1):j) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    inst_income_ratio(j) = rad2deg(atan(num_O_rewards/num_M_rewards));
                elseif num_O_rewards == 0
                    inst_income_ratio(j) = 0;
                elseif num_M_rewards == 0 
                    inst_income_ratio(j) = 90;
                end   
            end
        end
    end    
        
    
    fig_count = fig_count+1
    figure(fig_count)
    
    plot(inst_choice_ratio,'LineWidth',4,'Color','b')
    hold on
    if protocol_100_0 ~= 1 && protocol_100_0 ~= 4
%         plot(inst_income_ratio,'LineWidth',4,'Color','k')
        if protocol_100_0 == 2
            plot(length(cps_pre)+1:length(cps_pre)+length(cps_post),ones(1,length(cps_post))*ave_post_reward_ratio,'LineWidth',6,'Color','k')
        elseif protocol_100_0 == 3
            plot(length(cps_pre)+1:length(cps_pre)+length(cps_post),ones(1,length(cps_post))*ave_post_reward_ratio,'LineWidth',6,'Color','k')
    
        end
    elseif protocol_100_0 == 1
        plot(length(cps_pre)+1:length(cps_pre)+length(cps_post),ones(1,length(cps_post))*90,'LineWidth',6,'Color','k')
    elseif protocol_100_0 == 4
        plot(length(cps_pre)+1:length(cps_pre)+length(cps_post),ones(1,length(cps_post))*0,'LineWidth',6,'Color','k')
    end
    plot(1:length(cps_pre),ones(1,length(cps_pre))*ave_pre_choice_ratio,'LineWidth',6,'Color','b')
    plot(length(cps_pre)+1:length(cps_pre)+length(cps_post),ones(1,length(cps_post))*ave_post_choice_ratio,'LineWidth',6,'Color','b')
%     plot(1:length(cps_pre),ones(1,length(cps_pre))*45,'LineWidth',6,'Color','k')
    for r = 1:length(reward_order)
        if choice_order(r) == 2
            if reward_order(r) == 2
                plot([r,r],[92,97],'Color',[84/256,174/256,0],'LineWidth',4)
            else
                plot([r,r],[92,94],'Color',[84/256,174/256,0],'LineWidth',4)
            end
        else
            if reward_order(r) == 1
                plot([r,r],[-7,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            else
                plot([r,r],[-4,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            end
        end
    end
    box off
    axis off
    ylim([-7,97])
    keyboard
end