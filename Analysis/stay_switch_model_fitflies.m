function [LL,LossLOU] = stay_switch_model_fitflies()
    count = 0
   
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);

    LL_mat = [];
    LossLOU_mat = [];
    typ_p = [];


    for expt_n = 1:2%length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);



        for cond_n = 1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')

                continue
            elseif expt_n == 1
                if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+3)
                    continue
                end
            elseif expt_n == 2
                if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
                    continue
                end
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
            pred_choice = [1.5];
            
            for i = 2:length(choice_order)
                if choice_order(i-1) == 1
                    if reward_order(i-1)== 1
                        pred_choice(i) = 1;
                    else
                        pred_choice(i) = 2;
                    end
                elseif choice_order(i-1) == 2
                    if reward_order(i-1) == 2
                        pred_choice(i) = 2;
                    else
                        pred_choice(i) = 1;
                    end
                end
            end    
            

            P_correct = double(eq(pred_choice,choice_order));
            P_correct(1) = 0.5;
            for j = 1:length(choice_order)
                if P_correct(j) == 0
                    P_correct(j) = 0.001;
                end    
            end    
            y(count,1:length(choice_order)) = choice_order;
            y_hat(count,1:length(choice_order)) = pred_choice;
            LL(count) = sum(log(P_correct));
            LossLOU(count)=mean(P_correct);



        end
    end
end
    