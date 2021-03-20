clc
clear
% close all
count = 0;
% Select spreadsheet containing experiment names
cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);

MI = [];
tau_list = [0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,80,100]
beta_list = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
% ennumerating all possible reward combinations in past 10 trials

past1_reward_combs = load('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/past1_reward_combs.mat');
past1_reward_combs = past1_reward_combs.all_reward_combs;

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    count = 0;
    for cond_n = 1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            
            continue
        end

        count = count+1
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        % MI between current choice and past reward
        n_trials = 1;
        Y_dim = 3^n_trials; % 2 ^ number of trials in past to look at reward
        X_dim = 1; % Always 1
        j_th_trial = 3;

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
        
        CR1 = rad2deg(atan(length(find(choice_order(1:80) == 1))/length(find(choice_order(1:80) == 2))));
        RR1 = rad2deg(atan(length(find(reward_order(1:80) == 1))/length(find(reward_order(1:80) == 2))));
        UM(expt_n,count,1) = CR1/RR1;
        
        if length(choice_order) > 159
            CR2 = rad2deg(atan(length(find(choice_order(81:160) == 1))/length(find(choice_order(1:80) == 2))));
            RR2 = rad2deg(atan(length(find(reward_order(81:160) == 1))/length(find(reward_order(1:80) == 2))));
        else
            CR2 = rad2deg(atan(length(find(choice_order(81:end) == 1))/length(find(choice_order(81:end) == 2))));
            RR2 = rad2deg(atan(length(find(reward_order(81:end) == 1))/length(find(reward_order(81:end) == 2))));
        end
        UM(expt_n,count,2) = CR2/RR2;
        
        CR3 = rad2deg(atan(length(find(choice_order(161:end) == 1))/length(find(choice_order(161:end) == 2))));
        RR3 = rad2deg(atan(length(find(reward_order(161:end) == 1))/length(find(reward_order(161:end) == 2))));
        UM(expt_n,count,3) = CR3/RR3;
        
        Rec_R(expt_n,count) = length(find(reward_order ~= 0))/length(reward_order);
    
    %% MI for past 1 reward with current choice
        % H(Y) - Here Y = most recent past reward

        Y_counts = zeros(Y_dim,1);

        for i = j_th_trial+1:length(choice_order)
            Y_id = find(sum(reward_order(i-j_th_trial:i-j_th_trial)==past1_reward_combs,2) == n_trials);
            Y_counts(Y_id,1) = Y_counts(Y_id,1)+1;
        end   

        P_Y = Y_counts/sum(Y_counts);
        W = P_Y.*log(P_Y);
        W_nan = isnan(W);
        W(find(W_nan == 1)) = 0;
        H_Y = -sum(W);

        % H(Y|X) - Here Y = most recent past choice

        YgX_counts = zeros(Y_dim,X_dim*2);

        for i = j_th_trial+1:length(choice_order)
            if choice_order(i) == 1
                Y_id = find(sum(reward_order(i-j_th_trial:i-j_th_trial)==past1_reward_combs,2) == n_trials);
                YgX_counts(Y_id,1) = YgX_counts(Y_id,1)+1;
            else
                Y_id = find(sum(reward_order(i-j_th_trial:i-j_th_trial)==past1_reward_combs,2) == n_trials);
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
        
%         %% MI for Logistic Regression predictor and current choice
%         
%         H_vec = n_trials;
%         N = length(choice_order);
%         lenH=length(H_vec);
%         indH=0;
% 
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
%             r = reward_order;
%             r_2_trials = find(r == 2);
%             r_1_trials = find(r == 1);
%             r(r_2_trials) = 1;
%             r(r_1_trials) = -1;
% 
%               Y = choice_order((H+1):end)';
%             
%               for i = (H+1):N
%                   X(i-H,1:H) = r(i-(1:H));
%                   
%                 
%               end
%             
% 
%             % Incorporate Training and Testing groups. model is fit using the
%             % the training group which is further split into 10 to all for 10
%             % fold cross-validation and regularization to avoid over-fitting.
%             Xi = X;
%             %Xi(i,:) = [];
%             Yi = Y-1;
%             %Yi(i) = [];
%             [B,FitInfo] = lassoglm(Xi,Yi,'binomial','CV',10,'Alpha',0.1,'Offset',zeros(length(Yi),1));
%             idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
%             B0 = FitInfo.Intercept(idxLambdaMinDeviance);
%             wi = [B0; B(:,idxLambdaMinDeviance)];
% 
%             %store the regresseros for sd 
% 
%             % ADITHYA - 07.12.20:
%             % wi_mat is 5 element char with each element corresponding to
%             % different windows of trials (H_vec long). Each element contains
%             % the weights ( regressors) of different predictors of present
%             % choice. Three types of predictors are used above. past choice
%             % (for the past H choices), past reward (for the past H choices)
%             % and a product of past choices and past rewards (for the past H
%             % choices). so each element will contain a n X 3*H long vector
%             % (where n = N-H, where N is the number of choices made in the
%             % session).
% 
%             yhat = glmval(wi,Xi,'logit');
%              
%         end
%         
%         [C,ia,ic] = unique(yhat);
%         yhat_counts = [];
%         for i = 1:length(ia)
%             yhat_counts(i) = length(find(ic == ia(i)));
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
%         [C,ia,ic] = unique(yhat(Y_1_ids));
%         
%         for i = 1:length(ia)
%             yhatg1_counts(i) = length(find(ic == ia(i)));
%         end
%         
%         [C,ia,ic] = unique(yhat(Y_0_ids));
%         
%         for i = 1:length(ia)
%             yhatg0_counts(i) = length(find(ic == ia(i)));
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
%         
%      %% MI for sugrue predictor with current choice   
%         v1 = [];
%         v2 = [];
%         v = [];
%         pred_choice = [];
%         [tau,beta] = sugrue_like_model_mult_tau_bias_singleFly(cond,tau_list,beta_list);
%         for t_num = 2:length(choice_order)
%             choices = [];
%             rewards = [];
%             choices = choice_order(t_num-1 : t_num - 1);
%             rewards = reward_order(t_num-1 : t_num - 1);
%             v1_list = [];
%             v2_list = [];
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
%             exp_w_list = exp((tau - [1:length(choices)]+1)/tau)./exp(1);     
%             valid_els_1 = find(flip(v1_list)~= -1);   
%             valid_els_2 = find(flip(v2_list) ~= -1); 
%             flip_v1_list = flip(v1_list);
%             flip_v2_list = flip(v2_list);
%             % exp weighted sum for value
%             v1(t_num-1) = sum((exp_w_list(valid_els_1)).*flip_v1_list(valid_els_1));
%             v2(t_num-1) = sum((exp_w_list(valid_els_2)).*flip_v2_list(valid_els_2));
%             v(t_num-1) = 1/(1+exp(-beta*(v1(t_num-1) - v2(t_num-1))));
%         end
% 
%         [C,ia,ic] = unique(v);
%         v_counts = [];
%         for i = 1:length(ia)
%             v_counts(i) = length(find(ic == ia(i)));
%         end
%         
%         P_Yhat = v_counts/sum(v_counts);
%         U = P_Yhat.*log(P_Yhat);
%         U_nan = isnan(U);
%         U(find(U_nan == 1)) = 0;
%         H_v = -sum(U);
%         
%         vg1_counts = [];
%         vg0_counts = [];
%         
%         [C,ia,ic] = unique(v(Y_1_ids));
%         
%         for i = 1:length(ia)
%             vg1_counts(i) = length(find(ic == ia(i)));
%         end
%         
%         [C,ia,ic] = unique(v(Y_0_ids));
%         
%         for i = 1:length(ia)
%             vg0_counts(i) = length(find(ic == ia(i)));
%         end
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
% %         keyboard
    end
end