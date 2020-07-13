function [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center,fig_count,net_summed_choices,choice_order,reward_order,gotofig] = summed_choices_mult_conts(cps,odor_crossing,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,pre_sumM, pre_sumO,baiting)
    
    
    color_vec = cbrewer('qual','Dark2',10,'cubic')
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);
        
        
    summed_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_choices_center = zeros(length(x_y_time_color.time),1);
    summed_O_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_O_choices_center = zeros(length(x_y_time_color.time),1);
    summed_M_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_M_choices_center = zeros(length(x_y_time_color.time),1);
    
    
    
    for p = 2:length(cps)
        if cps(p) == length(summed_choices_ends)
            summed_choices_ends(cps(p)) = summed_choices_ends(cps(p)-1) + 1;
        else    
            summed_choices_ends(cps(p):cps(p+1)) = summed_choices_ends(cps(p)-1) + 1;
        end
        no_match = 1;
        kk = 0;
        if cps(p) ==1
            
        else    
            while no_match == 1
                kk = kk+1
                if sum(x_y_time_color.color(cps(p)-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(cps(p)-kk,:) == M_O_Color )==3
                    summed_M_choices_ends(cps(p):end) = summed_M_choices_ends(cps(p)-1) + 1;
                    no_match = 0;
                elseif sum(x_y_time_color.color(cps(p)-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(cps(p)-kk,:) == O_M_Color)==3
                    summed_O_choices_ends(cps(p):end) = summed_O_choices_ends(cps(p)-1) + 1;
                    no_match = 0;
                end 
            end    
        end
    end
    summed_choices_ends(cps(end):end) = summed_choices_ends(cps(end)-1) + 1;
    
    for p = 2:length(odor_crossing)-1
        summed_choices_center(odor_crossing(p).time_pt_in_vector :odor_crossing(p+1).time_pt_in_vector) = summed_choices_center(odor_crossing(p).time_pt_in_vector-1)+1;
        if isequal(odor_crossing(p-1).type,{'AtoM'})||isequal(odor_crossing(p-1).type,{'OtoM'})
            summed_M_choices_center(odor_crossing(p).time_pt_in_vector:end) = summed_M_choices_center(odor_crossing(p).time_pt_in_vector-1) + 1;
        elseif isequal(odor_crossing(p-1).type,{'AtoO'})||isequal(odor_crossing(p-1).type,{'MtoO'})
            summed_O_choices_center(odor_crossing(p).time_pt_in_vector:end) = summed_O_choices_center(odor_crossing(p).time_pt_in_vector-1) + 1;
        end
    end 
    summed_choices_center(odor_crossing(end).time_pt_in_vector :end) = summed_choices_center(odor_crossing(end).time_pt_in_vector-1)+1;
    
    
    summed_choices_ends = summed_choices_ends + pre_sumM + pre_sumO;
    summed_M_choices_ends = summed_M_choices_ends + pre_sumM;
    summed_O_choices_ends = summed_O_choices_ends + pre_sumO;
    net_summed_choices = summed_M_choices_ends + summed_O_choices_ends;
    
    choice_order = [] ;
    reward_order = [];
    for i = 2:length(summed_choices_ends)
        if summed_choices_ends(i-1) ~= summed_choices_ends(i)
            if summed_M_choices_ends(i-1) ~= summed_M_choices_ends(i)
                choice_order(length(choice_order)+1) = 1;
                if protocol_100_0 ~= 1
%                     if reward(2,i-1) == 1
%                         reward_order(length(choice_order)) = 1;
%                     elseif reward(2,i-1) == 0
%                         reward_order(length(choice_order)) = 0;
%                     end
                end    
            elseif summed_O_choices_ends(i-1) ~= summed_O_choices_ends(i)
                choice_order(length(choice_order)+1) = 2;
                if protocol_100_0 ~= 1
%                     if reward(1,i-1) == 1
%                       reward_order(length(choice_order)) = 2;
%                     elseif reward(1,i-1) == 0
%                         reward_order(length(choice_order)) = 0;
%                     end 
                end    
            end
        end    
    end
    
    num_O_rewarded = 0;
    num_M_rewarded = 0;
    % HACKY CODE TO CALCULATE AVE_REWARD_SLOPE BECAUSE reward was
    % incorrectly saved when acquiring data
    if conts > 1
        a_O = sum(reward(1,:));
        b_O = sum(baiting(1,:));
        c_O = 0;
        for i = 1:length(baiting)-1
            if baiting(1,i:i+1) == [0,1]
            c_O = c_O + 1;
            end
        end
        num_O_rewarded = a_O -b_O + c_O
        a_M = sum(reward(2,:));
        b_M = sum(baiting(2,:));
        c_M = 0;
        for i = 1:length(baiting)-1
            if baiting(2,i:i+1) == [0,1]
            c_M = c_M + 1;
            end
        end
        num_M_rewarded = a_M -b_M + c_M
        
           
            

    end
%     
%     num_O_rewarded = length(find(reward_order == 2));
%     num_M_rewarded = length(find(reward_order == 1));
     ave_reward_slope = (num_O_rewarded/num_M_rewarded);
     
% This is how lines will be defined for experiments where first set of
% trials involve no reward and second set of trials have OCT100:MCH0
    if protocol_100_0 == 1
        % NEED TO MAKE CHANGES TO THIS SECTION AS NEEDED IN THE FUTURE
        line1_x1 = 0;
        line1_x2 = summed_M_choices_ends(pre_end_time);
        line1_x = line1_x1:line1_x2;
        line1_y = line1_x;

        line2_y1 = summed_O_choices_ends(pre_end_time);
        line2_y2 = summed_O_choices_ends(end);
        line2_y = line2_y1 : line2_y2;
        line2_x = zeros(1,length(line2_y)) + pre_sumM;
    % This is how lines will be defined for experiments where first set of
    % trials involve no reward and second set of trials have OCT80:MCH20
    elseif protocol_100_0 == 2
        if conts == 1
            line1_x1 = 0;
            line1_x2 = summed_M_choices_ends(end);
            line1_x = line1_x1:line1_x2;
            line1_y = line1_x;
        elseif conts > 1    
            line1_y1 = pre_sumO;
            line1_y2 = summed_O_choices_ends(end);
            line1_y = line1_y1 : line1_y2;
            line1_x = (([1:length(line1_y)])/ave_reward_slope) + pre_sumM;

        
    % This is how lines will be defined for experiments where first set of
    % trials involve no reward and second set of trials have OCT60:MCH40
    elseif protocol_100_0 == 3 
        % NEED TO MAKE CHANGES TO THIS SECTION AS NEEDED IN THE FUTURE
        line1_x1 = 0;
        line1_x2 = summed_M_choices_ends(pre_end_time);
        line1_x = line1_x1:line1_x2;
        line1_y = line1_x;

        line2_y1 = pre_sumO;
        line2_y2 = summed_O_choices_ends(end);
        line2_y = line1_y1 : line1_y2;
        line2_x = (([1:length(line1_y)])/ave_reward_slope) + pre_sumM;
    end    

    if conts == 1
        figure(fig_count+1)
        gotofig = fig_count+1;
        fig_count = fig_count+1
        plot(summed_M_choices_ends,summed_O_choices_ends,'LineWidth',4)
        
        hold on
        plot(line1_x,line1_y,'LineWidth',4,'Color','k')

    else
        figure(gotofig)
        plot(summed_M_choices_ends,summed_O_choices_ends,'LineWidth',4)
        
        hold on
        plot(line1_x,line1_y,'LineWidth',4,'Color','k')
    end
        
end