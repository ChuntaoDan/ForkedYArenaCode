function [fit_list] = figure2C_sugrue_dataFit(tau_start,tau_end)
fit_list = zeros(tau_end-tau_start+1,1);
cps_pre = load('cps_pre.mat');
cps_pre = cps_pre.cps_pre;
choices = load('choice_order.mat');
choices = choices.choice_order;
choices = choices(length(cps_pre)+1:end)
rewards = load('reward_order.mat');
rewards = rewards.reward_order;
rewards = rewards(length(cps_pre)+1:end)
% summed_choices1 = [0];
% summed_choices2 = [0];
% summed_i_1 = [];
% summed_i_2 = [];

% 
% for i= 1:length(choices)
%     if choices(i) == 1
%         if rewards(i) == 1
%             o1_history(length(o1_history)+1) = 1;
%         elseif rewards(i) == 0
%             o1_history(length(o1_history)+1) = 0;
%         end
%     elseif choices(i) == 2
%         if rewards(i) == 2
%             o2_history(length(o2_history)+1) = 1;
%         elseif rewards(i) == 0
%             o2_history(length(o2_history)+1) = 0;
%         end
%     end
% end    

for tau = tau_start:tau_end
    fit_current_tau = 0;
    o1_history = [1]; % 1 - rewarded choice, 0 - unrewarded choice
    o2_history = [1];
    for i = 1:length(choices)
        if choices(i) == 1
            if rewards(i) == 1
                o1_history(length(o1_history)+1) = 1;
            elseif rewards(i) == 0
                o1_history(length(o1_history)+1) = 0;
            end
        elseif choices(i) == 2
            if rewards(i) == 2
                o2_history(length(o2_history)+1) = 1;
            elseif rewards(i) == 0
                o2_history(length(o2_history)+1) = 0;
            end
        end
        t1 = (length(o1_history)+1) - [1:length(o1_history)];
        t2 = (length(o2_history)+1) - [1:length(o2_history)];
        i_1 = ([exp(-t1/tau)]./(exp(-1/tau))).*o1_history;
        i_2 = ([exp(-t2/tau)]./(exp(-1/tau))).*o2_history;
        p_1 = sum(i_1)/(sum(i_1) + sum(i_2));
        diff = abs(choices(i)-1-(1-p_1));
        fit_current_tau = fit_current_tau + diff;
    end
    fit_list(tau-tau_start+1) = fit_current_tau;
end

        
        