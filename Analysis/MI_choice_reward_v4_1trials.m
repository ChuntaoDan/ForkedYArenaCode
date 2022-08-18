clc
clear
% close all
count = 0;
% Select spreadsheet containing experiment names
cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

% List of all experiments 
[~, expts, ~] = xlsread([PathName, FileName]);

% Defining tau and betas to use for the Sugrue model
MI = [];
tau_list = [0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,80,100]
beta_list = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]

% ennumerating all possible reward combinations in past 10 trials
% these have all been saved using the "past10_reward_combs.m" file which is
% incorrectly named as it now takes a variable that tells it how big of a 
% window in which it should ennumerate combinations
past1_reward_combs = load('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/past1_reward_combs.mat');
past1_reward_combs = past1_reward_combs.all_reward_combs;

% looping through all experiments. An experiment contains multiple flies 
% worth of data. An experiment for example can be all flies of a given 
% genotype such as Gr64f-Gal4 X UAS-Chrimson
for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    count = 0;
    % Each experiment contains multiple flies and so this loop parses
    % through flies
    for cond_n = 1:length(conds)
        
        % Skip the folders containing '.' as name
        if startsWith(conds(cond_n).name, '.')
            
            continue
        end

        count = count+1
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        % MI between current choice and past reward
        n_trials = 1;
        Y_dim = 3^n_trials; % 3^ number of trials in past to look at reward
        % the 3 is because option 1 can be rewarded, option 2 can be or
        % there can be no reward
        X_dim = 1; % Always 1 because we are looking at predicting most recent choice

        % loading the choice and reward orders that have been calculated
        % using other code
        RO = load('reward_order.mat');
        CO = load('choice_order.mat');
        CO = CO.choice_order;
        RO = RO.reward_order;
        choice_order = [];
        reward_order = [];
        
        % reshaping the choice and reward order to be a vector
        for k = 1:size(CO,2)
            choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
            reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
        end
        
        % eliminating 0's because some experiments are shorter than 240
        % trials
        zero_locs = find(choice_order == 0);
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];
        
        % Calculating Mean Choice Ration and and Mean Reward Ratio for
        % different blocks. This is not relevant for MI but is calculated
        % to potentially compare against MI to see if there is any
        % relationship between MI and RR or CR
%         CR1 = rad2deg(atan(length(find(choice_order(1:80) == 1))/length(find(choice_order(1:80) == 2))));
%         RR1 = rad2deg(atan(length(find(reward_order(1:80) == 1))/length(find(reward_order(1:80) == 2))));
%         UM(expt_n,count,1) = CR1/RR1;
%         
%         if length(choice_order) > 159
%             CR2 = rad2deg(atan(length(find(choice_order(81:160) == 1))/length(find(choice_order(1:80) == 2))));
%             RR2 = rad2deg(atan(length(find(reward_order(81:160) == 1))/length(find(reward_order(1:80) == 2))));
%         else
%             CR2 = rad2deg(atan(length(find(choice_order(81:end) == 1))/length(find(choice_order(81:end) == 2))));
%             RR2 = rad2deg(atan(length(find(reward_order(81:end) == 1))/length(find(reward_order(81:end) == 2))));
%         end
%         UM(expt_n,count,2) = CR2/RR2;
%         
%         CR3 = rad2deg(atan(length(find(choice_order(161:end) == 1))/length(find(choice_order(161:end) == 2))));
%         RR3 = rad2deg(atan(length(find(reward_order(161:end) == 1))/length(find(reward_order(161:end) == 2))));
%         UM(expt_n,count,3) = CR3/RR3;
%         
%         RR_1(expt_n,count) = rad2deg(atan(length(find(reward_order(1:80) == 1))/length(find(reward_order(1:80)== 2))));
%         Rec_R(expt_n,count) = length(find(reward_order ~= 0))/length(reward_order);
    %% MI for past 1 reward with current choice
        % H(Y) - Here Y = most recent past reward

        Y_counts = zeros(Y_dim,1);

        for i = n_trials+1:length(choice_order)
            % finding the location in the past1_reward_combs matrix that is
            % in agreement with the past reward order for a given trial
            Y_id = find(sum(reward_order(i-n_trials:i-1)==past1_reward_combs,2) == n_trials);
            % Assigning a additional count to the identified location above
            Y_counts(Y_id,1) = Y_counts(Y_id,1)+1;
        end   
        
        % Calculating Probability and entropy of Y
        P_Y = Y_counts/sum(Y_counts);
        W = P_Y.*log(P_Y);
        W_nan = isnan(W);
        W(find(W_nan == 1)) = 0;
        H_Y = -sum(W);
        
        
        % X - most recent choice
        % Calculating H(X)
        
        X_counts = [0,0]
        
        X_counts(1) = length(find(choice_order == 1));
        X_counts(2) = length(find(choice_order == 2));
        
        P_X = X_counts/sum(X_counts);
        W_X = P_X.*log(P_X);
        W_X_nan = isnan(W_X);
        W_X(find(W_X_nan == 1)) = 0;
        H_X = -sum(W_X)
        
        Entropy_choice(expt_n,count) = H_X;

        % H(Y|X) - Here X = most recent past choice
        % Calculation is done with the same logic as above.

        YgX_counts = zeros(Y_dim,X_dim*2);

        for i = n_trials+1:length(choice_order)
            if choice_order(i) == 1
                Y_id = find(sum(reward_order(i-n_trials:i-1)==past1_reward_combs,2) == n_trials);
                YgX_counts(Y_id,1) = YgX_counts(Y_id,1)+1;
            else
                Y_id = find(sum(reward_order(i-n_trials:i-1)==past1_reward_combs,2) == n_trials);
                YgX_counts(Y_id,2) = YgX_counts(Y_id,2)+1;
            end    

        end 


        P_YgX = YgX_counts./sum(YgX_counts);
        V = P_YgX.*log(P_YgX);
        V_nan = isnan(V);
        V(find(V_nan == 1)) = 0;
        H_YgX_x = -sum(V);
        H_YgX = sum((sum(YgX_counts)./sum(sum(YgX_counts))).*H_YgX_x);

        MI(expt_n,count) = H_Y - H_YgX;
        
%% MI for Logistic Regression predictor and current choice
%         % define the number of trials to use in regression model
%         H_vec = n_trials;
%         
%         % defining variables used to ensure size of later vectors are
%         % correct
%         N = length(choice_order);
%         lenH=length(H_vec);
%         indH=0;
%         
%         % define number of bins in which to divide output of regression for
%         % calculation of MI
%         Y_hat_bin_num = 10;
% 
%         % This loops through a single value in this case because H_vec is a
%         % single element. This is a relic of my more details logistic
%         % regression code
%         for H=H_vec
%             tic;
%     %         indH=indH+1
%             % H=1;
% 
% 
%             n=N-H;  % num of obs
%             p=H; % num of parameters
%             X=zeros(n,p);
% 
%             % reframing reward_order vector. The vector originaly contains
%             % 0,1 and 2 as values depending on whether no reward was
%             % provided, option 1 was rewarded or option 2. This is being
%             % changed to 0,1 and -1 to be fed into the regression as
%             % predictors.
%             r = reward_order;
%             r_2_trials = find(r == 2);
%             r_1_trials = find(r == 1);
%             r(r_2_trials) = 1;
%             r(r_1_trials) = -1;
%             
%             % the true choice_order with which to train model and later
%             % compare model predictions
%             Y = choice_order((H+1):end)';
%             
%             % re-organizing reward_order into an input matrix for the
%             % regression
%               for i = (H+1):N
%                   X(i-H,1:H) = r(i-(1:H));
%               end
%             
% 
%             % Incorporate Training and Testing groups. model is fit using the
%             % the training group which is further split into 10 to all for 10
%             % fold cross-validation and regularization to avoid over-fitting.
%             
%             % 032021 - Current Training and Testing sets are not being used
%             % because size of  single flies data may be too small to do it.
%             Xi = X;
%             %Xi(i,:) = [];
%             Yi = Y-1;
%             %Yi(i) = [];
%             
%             % Using lassoglm to perform regression
%             
%             [B,FitInfo] = lassoglm(Xi,Yi,'binomial','CV',10,'Alpha',0.1,'Offset',zeros(length(Yi),1));
%             idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
%             B0 = FitInfo.Intercept(idxLambdaMinDeviance);
%             
%             % output weights from lassoglm
%             wi = [B0; B(:,idxLambdaMinDeviance)];
% 
%   
%             % predicted Y (choice) values
%             yhat = glmval(wi,Xi,'logit');
%              
%         end
%         
%         % CALCULATING Probability and entropy
%         yhat_counts = [];
%         for i = 1:Y_hat_bin_num
%             yhat_counts(i) = length(find( yhat<=((i+1)/Y_hat_bin_num))) - sum(yhat_counts);
%         end
%         
%         P_Yhat = yhat_counts/sum(yhat_counts);
%         What = P_Yhat.*log(P_Yhat);
%         What_nan = isnan(What);
%         What(find(What_nan == 1)) = 0;
%         H_yhat = -sum(What);
%         
%         yhatg1_counts = [];
%         Y_1_ids = find(Yi == 1);
%         yhatg0_counts = [];
%         Y_0_ids = find(Yi == 0);
%         
% %         [C,ia,ic] = unique(yhat(Y_1_ids));
% %         
%         for i = 1:Y_hat_bin_num
%             yhatg1_counts(i) = length(find(yhat(Y_1_ids) <= ((i+1)/Y_hat_bin_num))) - sum(yhatg1_counts);
%         end
%         
% %         [C,ia,ic] = unique(yhat(Y_0_ids));
% %         
%         for i = 1:Y_hat_bin_num
%             yhatg0_counts(i) = length(find(yhat(Y_0_ids) <= ((i+1)/Y_hat_bin_num))) - sum(yhatg0_counts);
%         end
%         
%         P_yhatg1 = yhatg1_counts/sum(yhatg1_counts);
%         P_yhatg0 = yhatg0_counts/sum(yhatg0_counts);
%         Whatg1 = P_yhatg1.*log(P_yhatg1);
%         Whatg0 = P_yhatg0.*log(P_yhatg0);
%         Whatg1_nan = isnan(Whatg1);
%         Whatg0_nan = isnan(Whatg0);
%         Whatg1(find(Whatg1_nan == 1)) = 0;
%         Whatg0(find(Whatg0_nan == 1)) = 0;
%         
%         H_yhatg1 = -sum(Whatg1);
%         H_yhatg0 = -sum(Whatg0);
%         H_yhatgX = (sum(yhatg1_counts)/(sum(yhatg1_counts)+sum(yhatg0_counts)))*H_yhatg1 + (sum(yhatg0_counts)/(sum(yhatg1_counts)+sum(yhatg0_counts)))*H_yhatg0;
%         
%         MI_yhat(expt_n,count) = H_yhat - H_yhatgX;
%         
%      %% MI for sugrue predictor with current choice 
%      
%      % defining value and choice variables
%         v1 = [];
%         v2 = [];
%         v = [];
%         pred_choice = [];
%         
%      % running code that fits sugrue like model to data using the taus and
%      % betas listed in line 14 and 15 and outputs the best fit tau and beta
%         [tau,beta] = sugrue_like_model_mult_tau_bias_singleFly(cond,tau_list,beta_list);
%         
%         % for every choice calculates the value of both options and
%         % produces a resulting predicted choice that ranges from 0 to 1
%         for t_num = 4:length(choice_order)
%             choices = [];
%             rewards = [];
%             choices = choice_order(t_num-3 : t_num - 1);
%             rewards = reward_order(t_num-3 : t_num - 1);
%             v1_list = [];
%             v2_list = [];
%             
%             % finding which choices were related to option 1 being chosen
%             % and which correspond to option2 being chosen and also
%             % whether or not they were rewarded
%             for ct = 1:length(choices)
%                 if rewards(ct) == 1
%                     v1_list(ct) = 1;
%                     v2_list(ct) = -1;
%                 elseif rewards(ct) == 2
%                     v1_list(ct) = -1;
%                     v2_list(ct) = 1;
%                 elseif rewards(ct) ==  0
%                     if choices(ct) == 1
%                         v1_list(ct) = 0;
%                         v2_list(ct) = -1;
%                     else
%                         v1_list(ct) = -1;
%                         v2_list(ct) = 0;
%                     end
%                 end 
%             end   
%             
%             % setting tau to a small value if 0 tau is best fit to avoid
%             % div by zero errors
%             if tau == 0
%                 tau = 0.001
%             end    
%             
%             % passing the rewarded choice order through a exponential
%             % function to assign value
%             exp_w_list = exp((tau - [1:length(choices)]+1)/tau)./exp(1);     
%             valid_els_1 = find(flip(v1_list)~= -1);   
%             valid_els_2 = find(flip(v2_list) ~= -1); 
%             flip_v1_list = flip(v1_list);
%             flip_v2_list = flip(v2_list);
%             % exp weighted sum for value
%             v1(t_num-3) = sum((exp_w_list(valid_els_1)).*flip_v1_list(valid_els_1));
%             v2(t_num-3) = sum((exp_w_list(valid_els_2)).*flip_v2_list(valid_els_2));
%             v(t_num-3) = 1/(1+exp(-beta*(v1(t_num-3) - v2(t_num-3))));
%         end
%         
%         % MI calculated in the same way as for logistic regression
%         v_counts = [];
%         for i = 1:Y_hat_bin_num
%             v_counts(i) = length(find( v<=((i+1)/Y_hat_bin_num))) - sum(v_counts);
%         end
%         
%         P_v = v_counts/sum(v_counts);
%         U = P_v.*log(P_v);
%         U_nan = isnan(U);
%         U(find(U_nan == 1)) = 0;
%         H_v = -sum(U);
%         
%         vg1_counts = [];
%         vg0_counts = [];
%         
% 
%         
%         for i = 1:Y_hat_bin_num
%             vg1_counts(i) = length(find( v(Y_1_ids)<=((i+1)/Y_hat_bin_num))) - sum(vg1_counts);
%         
%         end
%         
% 
%         
%         for i = 1:Y_hat_bin_num
%             vg0_counts(i) = length(find( v(Y_0_ids)<=((i+1)/Y_hat_bin_num))) - sum(vg0_counts);
%          end
%         
%         P_vg1 = vg1_counts/sum(vg1_counts);
%         P_vg0 = vg0_counts/sum(vg0_counts);
%         Ug1 = P_vg1.*log(P_vg1);
%         Ug0 = P_vg0.*log(P_vg0);
%         Ug1_nan = isnan(Ug1);
%         Ug0_nan = isnan(Ug0);
%         Ug1(find(Ug1_nan == 1)) = 0;
%         Ug0(find(Ug0_nan == 1)) = 0;
%         
%         H_vg1 = -sum(Ug1);
%         H_vg0 = -sum(Ug0);
%         H_vgX = (sum(vg1_counts)/(sum(vg1_counts)+sum(vg0_counts)))*H_vg1 + (sum(vg0_counts)/(sum(vg1_counts)+sum(vg0_counts)))*H_vg0;
%         
%         MI_v(expt_n,count) = H_v - H_vgX;

    end
end