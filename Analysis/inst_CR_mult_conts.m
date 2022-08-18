function [inst_choice_ratio,inst_income_ratio,ave_choice_ratio,ave_choice_ratio_sec_half,fig_count,ave_reward_ratio,ave_reward_ratio_sec_half,gotofig] = inst_CR_mult_conts(fig_count,protocol_100_0,choice_order,reward_order,lookback,conts,pre_sum,baiting,reward,gotofig)
    
    
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
    
    num_O_choices = length(find(choice_order(1 : end) == 2));
    num_M_choices = length(find(choice_order(1 : end) == 1));
    num_O_choices_sec_half = length(find(choice_order(41 : end) == 2));
    num_M_choices_sec_half = length(find(choice_order(41 : end) == 1));
    ave_choice_ratio = rad2deg(atan(num_O_choices/num_M_choices));
    ave_choice_ratio_sec_half = rad2deg(atan(num_O_choices_sec_half/num_M_choices_sec_half));
    
     if length(choice_order) == 240 && protocol_100_0 == 0
        num_O_choices_b1 = length(find(choice_order(1 : 80) == 2));
        num_M_choices_b1 = length(find(choice_order(1 : 80) == 1));
        num_O_choices_b2 = length(find(choice_order(81 : 160) == 2));
        num_M_choices_b2 = length(find(choice_order(81 : 160) == 1));
        num_O_choices_b3 = length(find(choice_order(161 : 240) == 2));
        num_M_choices_b3 = length(find(choice_order(161 : 240) == 1));
        ave_choice_slope_b1 = (num_O_choices_b1/num_M_choices_b1);
        ave_choice_ratio_b1 = rad2deg(atan(ave_choice_slope_b1));
        ave_choice_slope_b2 = (num_O_choices_b2/num_M_choices_b2);
        ave_choice_ratio_b2 = rad2deg(atan(ave_choice_slope_b2));
        ave_choice_slope_b3 = (num_O_choices_b3/num_M_choices_b3);
        ave_choice_ratio_b3 = rad2deg(atan(ave_choice_slope_b3));
    
    end
    
    num_O_rewarded = 0;
    num_M_rewarded = 0;
%     % HACKY CODE TO CALCULATE AVE_REWARD_SLOPE BECAUSE reward was
%     % incorrectly saved when acquiring data
%     if conts > 1
%         a_O = sum(reward(1,:));
%         b_O = sum(baiting(1,:));
%         c_O = 0;
%         for i = 1:length(baiting)-1
%             if baiting(1,i:i+1) == [0,1]
%             c_O = c_O + 1;
%             end
%         end
%         num_O_rewarded = a_O -b_O + c_O
%         a_M = sum(reward(2,:));
%         b_M = sum(baiting(2,:));
%         c_M = 0;
%         for i = 1:length(baiting)-1
%             if baiting(2,i:i+1) == [0,1]
%             c_M = c_M + 1;
%             end
%         end
%         num_M_rewarded = a_M -b_M + c_M
%       end
        
        num_O_rewarded = length(find(reward_order == 2));
        num_M_rewarded = length(find(reward_order == 1));
        ave_reward_slope = (num_O_rewarded/num_M_rewarded);
    num_O_rewarded_sec_half = length(find(reward_order(41 : end) == 2));
    num_M_rewarded_sec_half = length(find(reward_order(41 : end) == 1));
   
    ave_reward_slope_sec_half = (num_O_rewarded_sec_half/num_M_rewarded_sec_half);
    ave_reward_ratio = rad2deg(atan(ave_reward_slope));
    ave_reward_ratio_sec_half = rad2deg(atan(ave_reward_slope_sec_half));
    if length(choice_order) == 240 && protocol_100_0 == 0
        num_O_rewarded_b1 = length(find(reward_order(1 : 80) == 2));
        num_M_rewarded_b1 = length(find(reward_order(1 : 80) == 1));
        num_O_rewarded_b2 = length(find(reward_order(81 : 160) == 2));
        num_M_rewarded_b2 = length(find(reward_order(81 : 160) == 1));
        num_O_rewarded_b3 = length(find(reward_order(161 : 240) == 2));
        num_M_rewarded_b3 = length(find(reward_order(161 : 240) == 1));
        ave_reward_slope_b1 = (num_O_rewarded_b1/num_M_rewarded_b1);
        ave_reward_ratio_b1 = rad2deg(atan(ave_reward_slope_b1));
        ave_reward_slope_b2 = (num_O_rewarded_b2/num_M_rewarded_b2);
        ave_reward_ratio_b2 = rad2deg(atan(ave_reward_slope_b2));
        ave_reward_slope_b3 = (num_O_rewarded_b3/num_M_rewarded_b3);
        ave_reward_ratio_b3 = rad2deg(atan(ave_reward_slope_b3));
    
    end
    
    
 %     if conts == 1
%         ave_reward_ratio = 45;
%     end    
    
    inst_income_ratio = [];
    if protocol_100_0 ~= 1 
        
        for j = 1:length(reward_order) 
            if j>0 && j< lookback    
                num_O_rewards = length(find(reward_order(1:j) == 2));
                num_M_rewards = length(find(reward_order(1:j) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    inst_income_ratio(j) = (((0 + lookback-j)*rad2deg(atan(num_O_rewards/num_M_rewards)))+((j)*45))/lookback;
                elseif num_O_rewards == 0
                    inst_income_ratio(j) = (((0 + lookback-j)*0)+((j)*45))/lookback;
                elseif num_M_rewards == 0 
                    inst_income_ratio(j) = (((0 + lookback-j)*90)+((j)*45))/lookback;
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
        
    if conts == 1
        fig_count = fig_count+1
        gotofig = fig_count;
        figure(fig_count)
    else
        figure(gotofig)
    end

    plot(pre_sum+1 : pre_sum + length(inst_choice_ratio),inst_choice_ratio,'LineWidth',4,'Color','b')
    hold on
    if protocol_100_0 ~= 1 
        plot(pre_sum+1:pre_sum + length(choice_order),inst_income_ratio,'LineWidth',4,'Color','k')

        if protocol_100_0 == 2
            plot(pre_sum+1:pre_sum + length(choice_order),ones(1,length(choice_order))*ave_reward_ratio,'LineWidth',6,'Color','k')
        elseif protocol_100_0 == 3
            plot(pre_sum+1:pre_sum + length(choice_order),ones(1,length(choice_order))*ave_reward_ratio,'LineWidth',6,'Color','k')
        elseif protocol_100_0 == 0
             plot(1:80,ones(1,80)*ave_reward_ratio_b1,'LineWidth',6,'Color','k')
             plot(81:160,ones(1,80)*ave_reward_ratio_b2,'LineWidth',6,'Color','k')
             plot(161:240,ones(1,80)*ave_reward_ratio_b3,'LineWidth',6,'Color','k')
             plot(1:80,ones(1,80)*ave_choice_ratio_b1,'LineWidth',6,'Color','r')
             plot(81:160,ones(1,80)*ave_choice_ratio_b2,'LineWidth',6,'Color','r')
             plot(161:240,ones(1,80)*ave_choice_ratio_b3,'LineWidth',6,'Color','r')
             
        end
    else
        plot(pre_sum+1:pre_sum + length(choice_order),ones(1,length(choice_order))*90,'LineWidth',6,'Color','k')
    end
    plot(pre_sum+1:pre_sum + length(choice_order),ones(1,length(choice_order))*ave_choice_ratio,'LineWidth',6,'Color','r')
    for r = 1:length(reward_order)
        if choice_order(r) == 2
            if reward_order(r) == 2
                plot([pre_sum+r,pre_sum+r],[92,97],'Color',[84/256,174/256,0],'LineWidth',4)
            else
                plot([pre_sum+r,pre_sum+r],[92,94],'Color',[84/256,174/256,0],'LineWidth',4)
            end
        else
            if reward_order(r) == 1
                plot([pre_sum+r,pre_sum+r],[-7,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            else
                plot([pre_sum+r,pre_sum+r],[-4,-2],'Color',[242/256,174/256,21/256],'LineWidth',4)
            end
        end
    end
    box off
    axis off
    ylim([-7,97])

end