% clc
% clear
% close all
function [tau_fig,beta_fig,LL_mat] = sugrue_like_model_mult_tau_bias()
    count = 0
    tau_list = input('enter time-scales of lookback window as a vector');
    beta_list = input('enter beta list');
    % bias = input('enter bias');
    % kappa = input('enter kappa');
    % Select spreadsheet containing experiment names
    % FOR MAC : 
    % cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
    % FOR LINUX : 
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);

    LL_mat = [];
    LossLOU_mat = [];
    typ_p = [];


    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);



        for cond_n = 1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')

                continue
            end

    %         if cond_n == 8
    %             
    %             keyboard
    %         end

            count = count+1;
            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            RO = load('reward_order.mat');
            CO = load('choice_order.mat');
            CO = CO.choice_order;
            RO = RO.reward_order;
            choice_order = [];
            reward_order = [];


            for k = 1:size(CO,2)
            choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
            reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
            end

            zero_locs = find(choice_order == 0);
            choice_order(zero_locs) = [];
            reward_order(zero_locs) = [];

    % % 
    %         choice_order( 1 : 80) = CO(:,1);
    %         reward_order( 1 : 80) = RO(:,1);
            pred_choice = [];
            for tau_n = 1:length(tau_list)

                tau = tau_list(tau_n);

                for beta_n = 1:length(beta_list)
                    beta = beta_list(beta_n);
                    for t_num = 2:length(choice_order)
                        choices = [];
                        rewards = [];
                        choices = choice_order(1 : t_num - 1);
                        rewards = reward_order(1 : t_num - 1);
                        v1_list = [];
                        v2_list = [];
                        for ct = 1:length(choices)
                            if rewards(ct) == 1
                                v1_list(ct) = 1;
                                v2_list(ct) = -1;
                            elseif rewards(ct) == 2
                                v1_list(ct) = -1;
                                v2_list(ct) = 1;
                            elseif rewards(ct) ==  0
                                if choices(ct) == 1
                                    v1_list(ct) = 0;
                                    v2_list(ct) = -1;
                                else
                                    v1_list(ct) = -1;
                                    v2_list(ct) = 0;
                                end
                            end 
                        end
                        if tau == 0
                            exp_w_list = zeros(1,length(choices));
                            exp_w_list(1) = 1;
                        else    
                            exp_w_list = exp((tau - [1:length(choices)]+1)/tau)./exp(1);
                        end

                        valid_els_1 = find(flip(v1_list)~= -1);   
                        valid_els_2 = find(flip(v2_list) ~= -1); 
                        flip_v1_list = flip(v1_list);
                        flip_v2_list = flip(v2_list);
                        % exp weighted sum for value
                        v1(t_num-1) = sum((exp_w_list(valid_els_1)).*flip_v1_list(valid_els_1));
                        v2(t_num-1) = sum((exp_w_list(valid_els_2)).*flip_v2_list(valid_els_2));


                    %     % non weighted sum for value
                    %     v1(t_num-window_size) = sum(v1_list(valid_els_1));
                    %     v2(t_num-window_size) = sum(v2_list(valid_els_2));
                    %     

                    %% Choosing behavior without exploration
        %                 if v1(t_num-1) > v2(t_num-1)
        %                     pred_choice(t_num-1) = 1;
        %                 elseif v2(t_num-1) > v1(t_num-1)
        %                     pred_choice(t_num-1) = 2;
        %                 else % randomly chose 1 or 2 in-case of tie.
        %             %         if rand(1) > 0.5
        %             %             pred_choice(t_num-1) = 1;
        %             %         else
        %                         pred_choice(t_num-1) = 2;
        %             %         end    
        %                 end    
        %% Choosing behavior with exploration
                        if choice_order(t_num-1) == 1
                            auto_corr_choice = 1;
                        else
                            auto_corr_choice = -1;
                        end
                        prob_1 = 1/(1 + exp(-beta*(v1(t_num-1) - v2(t_num-1))));

                        %prob_1 = 1/(1 + exp(-beta*(v1(t_num-1) - v2(t_num-1))+bias + kappa*(auto_corr_choice)));
        % 
        %                 if rand(1) < prob_1
        %                     pred_choice(t_num-1) = 1;
        %                 else
        %                     pred_choice(t_num-1) = 2;
        %                 end  
        % 

        %% No behavior being choosen just calculating probability of being correct
                        if choice_order(t_num) == 1
                            pred_choice(tau_n,beta_n,t_num - 1) = prob_1;
                            plotting_choice(tau_n,beta_n,t_num - 1) = 1-prob_1;
                        else
                            pred_choice(tau_n,beta_n,t_num - 1) = 1-prob_1;
                            plotting_choice(tau_n,beta_n,t_num - 1) = 1-prob_1;
                        end

                    end 

                    %% Calculating perc correct if a single choice is predicted
        %             num_corr_preds = 0;
        % 
        %             for j = 1 : length(pred_choice)
        %                 if pred_choice(j) == choice_order(j+1)
        %                     num_corr_preds = num_corr_preds + 1;
        %                 end
        %             end 
        % 
        %             perc_corr_preds_list(count,tau_n) = num_corr_preds/(length(choice_order)-1);
        %             
                    %% Calculating prediction accuracy using prob of choice instead of a single choice
        %   
                    LL_mat(count,tau_n,beta_n) = sum(log(pred_choice(tau_n,beta_n,:)));
                    LossLOU_mat(count,tau_n,beta_n) =mean(pred_choice(tau_n,beta_n,:));
                    typ_p(count,tau_n,beta_n) = exp(mean(log(pred_choice(tau_n,beta_n,:))));



                end
                
            end

            %%Plotting
            open('figure7.fig')
%             keyboard
            hold on
            [maxLL_tau,maxLL_taus] = max(LL_mat(count,:,:));
            [maxLL,maxLL_beta_n] = max(max(LL_mat(count,:,:)));
            maxLL_tau_n = maxLL_taus(maxLL_beta_n)
            tau_fig(count) = tau_list(maxLL_tau_n);
            beta_fig(count) = beta_list(maxLL_beta_n);
            smoothed_pred_choice = [];
            for i = 10:length(choice_order)-1
                smoothed_pred_choice(i-9,:) = mean(plotting_choice(find(tau_list == tau_fig(count)),find(beta_list == beta_fig(count)),i-9:i));
            end
%             plot([10:length(choice_order)-1],smoothed_pred_choice*90,'LineWidth',4,'Color',[0.75,0,0.75])
%     %         plot([2:240],plotting_choice(tau_fig,:)*90,'LineWidth',4,'Color',[0.75,0,0.75])
%             filename = sprintf('data_sugrueModel_withExp_smoothed_tau_%d_beta_%d.fig',tau_fig(count),beta_fig(count));
%             savefig(filename)
            close all

        end
    end
end