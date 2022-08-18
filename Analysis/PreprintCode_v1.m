% THIS DOCUMENT CONTAINS ALL THE CODE THAT WILL BE USED TO GENERATE FIGURE
% FOR THE FIRST PREPRINT VERSION OF MY PROJECT WITH GLENN TURNER, JAMES
% FITZGERALD & RAN DARSHAN. 
% 
% DATE : 033022
%
%% SECTION 1 : REPLICATION (+ EXPANSION) OF LOEWENSTEIN AND SEUNG (2006)
% Here the model simulated by L&S2006 will be replicated with the two
% learning rules that they used in their paper delW = n*R*S and delW =
% n*R*[S-E(S)]. I will then expand on this to also include the learning rule
% delW = n*[R-E(R)]*S. I will further expand the scope of the task to more
% closely resemble the fly task (which will be fully replicated in SECTION
% 2).

%% 1.1 : The code that calls function 1.2 and makes CR v RR plots

noisy_inputs = input('Enter 1 if you want noisy input, 0 if not : ');
learning_rule_ID = input('1 - S-E(S); 2 - R-E(R) both odors present at reward; 3 - R-E(R) one odor present at reward; 4 - R*S; 5 - [R-E(R)]*[S-E(S)]; 6 - R*S depression one odor present at reward; 7 - R-E(R)*S depression one odor present at reward : ');
comp_frac_trials = input('Enter p of trials where both odors are presented to choose b/w : ');
Tp = input('Enter Total Reward Probability : ');
noisy_behavior = input('Enter 1 if you want logisitc function determined behavior, 0 if deterministic comparison a la L&S : ');
reward_smoothing = input('Enter how to calculate E(R) - 1 = flat 10 trial average; 2 - exponential smoothing based on logisitic regression : ');
count = 0;

for exptn = 1:30
    
    p1 = Tp - ((Tp/29)*(exptn-1));
    p2 = Tp-p1;
    
    for contn = 1:10
        count = count + 1;
        
        [I1(count),I2(count),C1(count),C2(count)] = Loewenstein_Seung_preprint_v1(p1,p2,noisy_inputs,learning_rule_ID,comp_frac_trials,noisy_behavior,reward_smoothing);
    end
end


 fI1 = I1./[I1+I2];
 fC1 = C1./[C1+C2];
 
 figure
 scatter(fI1,fC1)
 
 hold on 

%% SECTION 2 : FLY TASK VERSION 
% Here the model simulated by L&S2006 will be modified to more closely
% resemble the task as experienced by the actual flies. Since flies only
% experience one odor at a time and the behavioral choice in that case will
% come down to whether or not the fly should walk into that odor stream
% this version of the code replicates those requirements of the fly task.

%% 2.1 : Simulating and plotting CRvRR for fly version of the task

noisy_inputs = input('0 =  no noise, 1 = noise older version, 2 = noise using the next three entered values : ');
alpha = input('enter alpha value - extent of mean overlap b/w stimuli : ');
sigma2 = input('enter sigma2 value - variance of distribution : ');
c = input('enter c value - off diagonal elements in stimulus co-variance matrix : ');
learning_rule_ID = input('1 - R-E(R)*S; 2 - R*S; 3 - R*S-E(S); 4 - R-E(R)*S-E(S) : ');  
n_expts = input('input the number of expts you want to simulate : ');
tottrial = input('input the number of trials per expt - 2000 has previously been used : ');
C1_1000 = nan(n_expts,1); % variable of size k,1 containing the number of times option 1 was chosen to calculate CR
C2_1000 = nan(n_expts,1); % variable of size k,1 containing the number of times option 2 was chosen to calculate CR
In1 = nan(n_expts,1); % variable of size k,1 containing the number of times option 1 was rewarded to calculate IR
In2 = nan(n_expts,1); % variable of size k,1 containing the number of times option 2 was rewarded to calculate RR
y_vec = {};
R_vec = {};
R_chosen_vec ={};
W_vec = {};
S_vec = {};
S_vec_noiseless = {};
S_chosen_vec = {};
S_chosen_vec_noiseless = {};
y_cont = {};


for k = 1:n_expts
   
%     k
    % reseting and predefining the size of the inputs to the regression model
    I1 = [];
    Q = [];
    I2 = [];
    R_v = [];
    I3 = [];
    S = [];
    I4 = [];
    % Simulate the learning process
    p2 = 1*rand(1,1); % Probability of reward for odor 1
    p1 = 1-p2; % Probability of reward for odor 2
%     % Simulate 80-20 expts
%     p2 = 0.2;
%     p1 = 0.8;
    % Simulate 100-0 expts
%     p2 = 0;
%     p1 = 1;
    % multiple blocks
%     p1 = 0.3*[0.75;0.25;0.25]; 
%     p2 = 0.3-p1;
    % IF YOU WANT POTENTIATION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
    [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec{k},R_vec{k},W_vec{k},S_vec{k},S_vec_noiseless{k},y_cont{k},R_chosen_vec{k},S_chosen_vec{k},S_chosen_vec_noiseless{k},block_switch_ID(k,:)] = Loewenstein_Seung_FlyVersion(p1,p2,noisy_inputs,alpha,c,sigma2,learning_rule_ID,tottrial); % simulate the behavior
    % IF YOU WANT DEPRESSION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_depression_JEF(p1,p2); % simulate the behavior
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_JEF_multBlock(p1,p2); % simulate the behavior with multiple blocks of rewards
end


fI1 = In1./[In1+In2];
fC1 = C1_1000./[C1_1000+C2_1000];
figure
scatter(fI1,fC1)

%% 2.2 Fitting regression model

tau = 3.5;
alpha_p = 1/(tau);
alpha_m = 1/tau;
FitInfo = {};

ER = input('Enter whether ER = 0 or 1 :');
ES = input('Enter whether ES = 0 or 1 :');
noisy_stimuli = input('Enter 1 if you want to incorporate stimulus noise; 2 if not : ');
beta = input('Assumed overlap between stimuli - range 0 - 1 : ');
fit_sim_data = input('What data are we fitting - simulated = 1, fly data = 2 : ');


if fit_sim_data == 2
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
    [FileName, PathName] = uigetfile ('*','Select spreadsheet containing experiment names', 'off');
%     tau = 7;
%     alpha_p = 1/(tau);
%     alpha_m = 1/tau;
    [~, expts, ~] = xlsread([PathName, FileName]);
    k = 0;
    for expt_n =  1:2
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);
%         ER = 0;


        for cond_n = 1:length(conds)
            
            I1 = [];
            I2 = [];
            I3 = [];
            I4 = [];
            Q = [];
            R_v = [];
            S = [];
            S_unsum = [];
            Y_tA = [];
            yhat_tA = [];
            yhat = [];
            R_ave = [];
            X_ave = [];
            R = [];
            R_ER = [];
            X = [];
            X_chosen = [];
            X_EX = [];
            Y = [];
            Pc = [];
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')

                continue
            elseif expt_n == 1
                if ismember(cond_n,[1,4,5,7,8,9,11,13,14,15,16,17,18,22]+3)
                    continue
                end
            elseif expt_n == 2
                if ismember(cond_n,[4,5,6,9,11,12,13,15,16,17,18,19,20]+2)
                    continue
                end
            end

            k = k+1;
            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
        % Formatting the data for regression model fitting
        % Converting R and X into the inputs for the regression (refer to
        % back of lab notebook 1 for how this is calculated)
        % The math behinnd the inputs to the regression model I1, I2, I3 and I4 can be
        % looked at in the pdf that was shared with Glenn Ran and James. These
        % terms are calculated below

            [R, R_ER, X, X_chosen, X_EX, Y] = FlyData_preprocess(beta,alpha_p,alpha_m,noisy_stimuli);
            
            if noisy_stimuli == 2
                X_chosen(find(X_chosen ~= 1)) = beta;
            end
            
            for t_prime = 2:length(Y)
                I1(t_prime,1) = sum((t_prime-1).*X(t_prime-1,:),2);
            end 
            % I2 is different depending on whether X or X-E(X) is used
            if ES == 0
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    Q(t_prime,:) = sum(X_chosen(1:t_app,:),1); 
                end
                I2 = sum(X.*Q,2);
            else
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    Q(t_prime,:) = sum(X_EX(1:t_app,:),1); 
                end
                I2 = sum(X.*Q,2);
            end 

            % I3 is different depending on whether R or R-E(R) is used
            if ER == 0
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    R_v(t_prime,:) = sum(R(1:t_app,:),1);
                end
                I3 = sum(X.*R_v,2);
            elseif ER == 1    
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    R_v(t_prime,:) = sum(R_ER(1:t_app,:),1);
                end
                I3 = sum(X.*R_v,2);
            end

            % I4 is different depending on whether R or R-E(R) & X or X-E(X) is used
            if ER == 0 && ES == 0 % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
                S_unsum = X_chosen.*R;
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
                end    
                I4 = sum(X.*S,2);
            elseif ER == 1 && ES == 0
                S_unsum = X_chosen.*R_ER;
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
                end    
                I4 = sum(X.*S,2);
            elseif ER == 0 && ES == 1  % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
                S_unsum = X_EX.*R;
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
                end    
                I4 = sum(X.*S,2);
            elseif ER == 1 && ES == 1
                S_unsum = X_EX.*R_ER;
                for t_prime = 2:length(Y)
                    t_app = (length(find(Y(1:t_prime-1) == 1)));
                    S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
                end    
                I4 = sum(X.*S,2);    
            end    
            %concatinating inputs to use in regression
              I = cat(2,I1,I2,I3,I4);
%               I = I(1:block_switch_ID(k,1));
        %     I = cat(2,I1,I2,I4);
        %     I = cat(2,I1,I2,I3);
%               I = ones(length(I4),1);
            % Fit regression model

            %VERSION 1 : LASSO GLM WITH CROSS VALIDATION. ERROR ESTIMATES ARE NOT
            % STRAIGHTFORWARD FOR LASSO REGRESSION WITH CV
            [B,FitInfo{k}] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1); %performing regression
            idxLambdaMinDeviance = FitInfo{k}.IndexMinDeviance; % identifying best fit model
            B0 = FitInfo{k}.Intercept(idxLambdaMinDeviance); % identifying the bias weight
            wi = [B0; B(:,idxLambdaMinDeviance)]; % all weights including bias
            yhat = glmval(wi,I,'logit'); % calcualting predicted behavior
            ws(:,k) = wi; % saving weights to weight history
            % Vanilla Regression

            % VERSION 2 : VANILLA REGRESSION THAT ALLOWS US TO GET ERROR ESTIMATES.
            % NO CROSS VALIDATION
%             B = fitglm(I,Y,'Distribution','binomial'); % performing regression
%             yhat = glmval(B.Coefficients.Estimate,I,'logit'); % predicted choices
%             ws(:,k) = B.Coefficients.Estimate; % weights (bias is included by default here)
%             ses(:,k) = B.Coefficients.SE; % error on weights

            % Calcuting the probability that the model predicts the same as the
            % chosen behavior by simulation
            for i = 1:length(yhat)

                if eq(Y(i),1)
                    prob_i = yhat(i);
                else
                    prob_i = 1 - yhat(i);
                end
                Pc(i)=(prob_i); % This can be interpreted as the probability of the choice made. 

            end

            LL(k) = sum(log(Pc(1:end))); % calculating log likelihood metric
            LossLOU(k)=mean(Pc(1:end)); % calculating average probability of choice made
        %     toc;

        % Plotting fit timecourses
            if k == 24
                keyboard
            end
            figure
            for i = 6:length(Y)-6
                Y_tA(i-5) = mean(Y(i-5:i+5));
            end
            for i = 6:length(Y)-6
                yhat_tA(i-5) = mean(yhat(i-5:i+5));
            end
            plot(Y_tA)
            hold on
            plot(yhat_tA)

            filename = sprintf('fit_timecourse_data_%dtrials_reg_ER%d*ES%d_V2_noise_%d_beta%d_nullModel.fig',length(R),ER,ES,noisy_stimuli,beta);

            savefig(filename)
            
            close all
          

    % %     

        end
    end
elseif fit_sim_data == 1     
    for k = 1:n_expts
        k
        I1 = [];
        I2 = [];
        I3 = [];
        I4 = [];
        Q = [];
        R_v = [];
        S = [];
        S_unsum = [];
        Y_tA = [];
        yhat_tA = [];
        yhat = [];
        R_ave = [];
        X_ave = [];


        y = transpose(y_vec{k}); % tranposing choice history
        if noisy_stimuli == 1
            X = S_vec{k}(2:end,:); % stimulus history on all trials including turn away trials
            X_chosen = S_chosen_vec{k}(2:end,:);
        elseif noisy_stimuli == 2
            X = S_vec_noiseless{k}(2:end,:); % stimulus history on all trials including turn away trials
            X_chosen = S_chosen_vec_noiseless{k}(2:end,:);
            X_chosen(find(X_chosen ~= 1)) = beta;
        end

        R_chosen = R_chosen_vec{k}(2:end);% reward history
    %     R(:,2) = R(:,1); % Here the reward vector is duplicated. 
        Y = y; % copying choice history
        Y_cont = transpose(y_cont{k}); % transposing choice variable prior to non-linearity

        % VERSION 1 : Compute the average reward in an odor independent manner

        R_ave = zeros(1,1);
        for timept = 1:length(find(Y==1))
            % Here the average reward is calculated as global signal common for
            % both odors.

            R_ave(timept) = mean(R_chosen(timept:timept+9));

        end 

        R = R_chosen(10:end);
        % R - E(R) is calculated
        R_ER = R - R_ave';

        % Compute average stimulus for each odor
        for timept = 1:length(find(Y==1))
            if timept > 1
                X_ave(timept,:) = alpha_p*X_chosen(timept-1,:) + (1 - alpha_m)*X_ave(timept-1,:);  
            else
                X_ave(timept,:) = [(1+alpha)/2,(1+alpha)/2] ;
            end    
        end
        X_EX = X_chosen - X_ave;



        for t_prime = 2:length(Y)
            I1(t_prime,1) = sum((t_prime-1).*X(t_prime-1,:),2);
        end 
        % I2 is different depending on whether X or X-E(X) is used
        if ES == 0
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                Q(t_prime,:) = sum(X_chosen(1:t_app,:),1); 
            end
            I2 = sum(X.*Q,2);
        else
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                Q(t_prime,:) = sum(X_EX(1:t_app,:),1); 
            end
            I2 = sum(X.*Q,2);
        end 

        % I3 is different depending on whether R or R-E(R) is used
        if ER == 0
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                R_v(t_prime,:) = sum(R(1:t_app,:),1);
            end
            I3 = sum(X.*R_v,2);
        elseif ER == 1    
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                R_v(t_prime,:) = sum(R_ER(1:t_app,:),1);
            end
            I3 = sum(X.*R_v,2);
        end

        % I4 is different depending on whether R or R-E(R) & X or X-E(X) is used
        if ER == 0 && ES == 0 % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
            S_unsum = X_chosen.*R;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
            end    
            I4 = sum(X.*S,2);
        elseif ER == 1 && ES == 0
            S_unsum = X_chosen.*R_ER;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
            end    
            I4 = sum(X.*S,2);
        elseif ER == 0 && ES == 1  % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
            S_unsum = X_EX.*R;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
            end    
            I4 = sum(X.*S,2);
        elseif ER == 1 && ES == 1
            S_unsum = X_EX.*R_ER;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
            end    
            I4 = sum(X.*S,2);    
        end    
        %concatinating inputs to use in regression
%         I = cat(2,I1,I2,I3,I4);
        I = ones(length(I4),1);
%         I = I(1:block_switch_ID(k,2),:);
%         Y_tmp = Y(1:block_switch_ID(k,2),:);
%         Y_cont_tmp = Y_cont(1:block_switch_ID(k,2),:);
    %     I = cat(2,I1,I2,I4);
    %     I = cat(2,I1,I2,I3);

        % Fit regression model

        %VERSION 1 : LASSO GLM WITH CROSS VALIDATION. ERROR ESTIMATES ARE NOT
        % STRAIGHTFORWARD FOR LASSO REGRESSION WITH CV
        [B,FitInfo{k}] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1); %performing regression
        idxLambdaMinDeviance = FitInfo{k}.IndexMinDeviance; % identifying best fit model
        B0 = FitInfo{k}.Intercept(idxLambdaMinDeviance); % identifying the bias weight
        wi = [B0; B(:,idxLambdaMinDeviance)]; % all weights including bias
        yhat = glmval(wi,I,'logit'); % calcualting predicted behavior
        ws(:,k) = wi; % saving weights to weight history
        % Vanilla Regression

        % VERSION 2 : VANILLA REGRESSION THAT ALLOWS US TO GET ERROR ESTIMATES.
        % NO CROSS VALIDATION
    %     B = fitglm(I,Y,'Distribution','binomial'); % performing regression
    %     yhat = glmval(B.Coefficients.Estimate,I,'logit'); % predicted choices
    %     ws(:,k) = B.Coefficients.Estimate; % weights (bias is included by default here)
    %     ses(:,k) = B.Coefficients.SE; % error on weights

        % Calcuting the probability that the model predicts the same as the
        % chosen behavior by simulation
        for i = 1:length(yhat)

            if eq(Y(i),1)
                prob_i = yhat(i);
            else
                prob_i = 1 - yhat(i);
            end
            Pc(i)=(prob_i); % This can be interpreted as the probability of the choice made. 

        end

        LL(k) = sum(log(Pc(1:end))); % calculating log likelihood metric
        LossLOU(k)=mean(Pc(1:end)); % calculating average probability of choice made
    %     toc;

    % Plotting fit timecourses
       
        
        figure
        for i = 6:length(Y)-6
            Y_tA(i-5) = mean(Y_cont(i-5:i+5));
        end
        for i = 6:length(yhat)-6
            yhat_tA(i-5) = mean(yhat(i-5:i+5));
        end
        plot(Y_tA)
        hold on
        plot(yhat_tA)

        filename = sprintf('fit_timecourse_sim_R_V2_noisy_tau_3_5_%dtrials_reg_ER%d*ES%d_V2_noise_%d_beta02_%d_tau_%d.fig',length(R),ER,ES,noisy_stimuli,k,tau);

        savefig(filename)
% %     
   
    

    end
end    

close all

figure
w_corr = corr(transpose(ws));
heatmap(w_corr,'colormap',redblue)

filename2 = 'heatmap_Corr_ws_sim_SDREsingleW_model_SDRE_drule.fig';

savefig(filename2)

%% 2.4 Fitting regression model to all fly data

tau = 3.5;
alpha_p = 1/(tau);
alpha_m = 1/tau;

ER = input('Enter whether ER = 0 or 1 :');
ES = input('Enter whether ES = 0 or 1 :');
noisy_stimuli = input('Enter 1 if you want to incorporate stimulus noise; 2 if not : ');
beta = input('Assumed overlap between stimuli - range 0 - 1 : ');



cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile ('*','Select spreadsheet containing experiment names', 'off');
%     tau = 7;
%     alpha_p = 1/(tau);
%     alpha_m = 1/tau;
[~, expts, ~] = xlsread([PathName, FileName]);
k = 0;
I_all = [];
Y_all = [];

for expt_n =  1:2
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
%         ER = 0;


    for cond_n = 1:length(conds)

        I1 = [];
        I2 = [];
        I3 = [];
        I4 = [];

        Q = [];
        R_v = [];
        S = [];
        S_unsum = [];
        Y_tA = [];
        yhat_tA = [];
        yhat = [];
        R_ave = [];
        X_ave = [];
        R = [];
        R_ER = [];
        X = [];
        X_chosen = [];
        X_EX = [];
        Y = [];
        Pc = [];
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

        k = k+1;
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
    % Formatting the data for regression model fitting
    % Converting R and X into the inputs for the regression (refer to
    % back of lab notebook 1 for how this is calculated)
    % The math behinnd the inputs to the regression model I1, I2, I3 and I4 can be
    % looked at in the pdf that was shared with Glenn Ran and James. These
    % terms are calculated below

        [R, R_ER, X, X_chosen, X_EX, Y] = FlyData_preprocess(beta,alpha_p,alpha_m,noisy_stimuli);

        if noisy_stimuli == 2
            X_chosen(find(X_chosen ~= 1)) = beta;
        end

        for t_prime = 2:length(Y)
            I1(t_prime,1) = sum((t_prime-1).*X(t_prime-1,:),2);
        end 
        % I2 is different depending on whether X or X-E(X) is used
        if ES == 0
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                Q(t_prime,:) = sum(X_chosen(1:t_app,:),1); 
            end
            I2 = sum(X.*Q,2);
        else
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                Q(t_prime,:) = sum(X_EX(1:t_app,:),1); 
            end
            I2 = sum(X.*Q,2);
        end 

        % I3 is different depending on whether R or R-E(R) is used
        if ER == 0
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                R_v(t_prime,:) = sum(R(1:t_app,:),1);
            end
            I3 = sum(X.*R_v,2);
        elseif ER == 1    
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                R_v(t_prime,:) = sum(R_ER(1:t_app,:),1);
            end
            I3 = sum(X.*R_v,2);
        end

        % I4 is different depending on whether R or R-E(R) & X or X-E(X) is used
        if ER == 0 && ES == 0 % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
            S_unsum = X_chosen.*R;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
            end    
            I4 = sum(X.*S,2);
        elseif ER == 1 && ES == 0
            S_unsum = X_chosen.*R_ER;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
            end    
            I4 = sum(X.*S,2);
        elseif ER == 0 && ES == 1  % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
            S_unsum = X_EX.*R;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1);
            end    
            I4 = sum(X.*S,2);
        elseif ER == 1 && ES == 1
            S_unsum = X_EX.*R_ER;
            for t_prime = 2:length(Y)
                t_app = (length(find(Y(1:t_prime-1) == 1)));
                S(t_prime,:) = sum(S_unsum(1:t_app,:),1); 
            end    
            I4 = sum(X.*S,2);    
        end    
        %concatinating inputs to use in regression
        I = cat(2,I1,I2,I3,I4);
    %     I = cat(2,I1,I2,I4);
    %     I = cat(2,I1,I2,I3);
        I_all = cat(1,I_all,I);
        Y_all = cat(1,Y_all,Y);
        % Fit regression model

    end
end

%VERSION 1 : LASSO GLM WITH CROSS VALIDATION. ERROR ESTIMATES ARE NOT
% STRAIGHTFORWARD FOR LASSO REGRESSION WITH CV
[B,FitInfo] = lassoglm(I_all,Y_all,'binomial','CV',10);%,'Alpha',0.1); %performing regression
idxLambdaMinDeviance = FitInfo.IndexMinDeviance; % identifying best fit model
B0 = FitInfo.Intercept(idxLambdaMinDeviance); % identifying the bias weight
wi = [B0; B(:,idxLambdaMinDeviance)]; % all weights including bias
yhat_all = glmval(wi,I_all,'logit'); % calcualting predicted behavior
ws(:,k) = wi; % saving weights to weight history
% Vanilla Regression

% VERSION 2 : VANILLA REGRESSION THAT ALLOWS US TO GET ERROR ESTIMATES.
% NO CROSS VALIDATION
%             B = fitglm(I,Y,'Distribution','binomial'); % performing regression
%             yhat = glmval(B.Coefficients.Estimate,I,'logit'); % predicted choices
%             ws(:,k) = B.Coefficients.Estimate; % weights (bias is included by default here)
%             ses(:,k) = B.Coefficients.SE; % error on weights

% Calcuting the probability that the model predicts the same as the
% chosen behavior by simulation
for i = 1:length(yhat_all)

    if eq(Y_all(i),1)
        prob_i = yhat_all(i);
    else
        prob_i = 1 - yhat_all(i);
    end
    Pc(i)=(prob_i); % This can be interpreted as the probability of the choice made. 

end

        LL = sum(log(Pc(1:end))); % calculating log likelihood metric
        LossLOU=mean(Pc(1:end)); % calculating average probability of choice made
%     toc;

% Plotting fit timecourses

figure
for i = 6:length(Y_all)-6
    Y_tA_all(i-5) = mean(Y_all(i-5:i+5));
end
for i = 6:length(Y_all)-6
    yhat_tA_all(i-5) = mean(yhat_all(i-5:i+5));
end
plot(Y_tA_all)
hold on
plot(yhat_tA_all)

% filename = sprintf('fit_timecourse_data_%dtrials_reg_ER%d*ES%d_V2_noise_%d_beta%d.fig',length(R),ER,ES,noisy_stimuli,beta);
% 
% savefig(filename)



% %     


% close all
% 
% figure
% w_corr = corr(transpose(ws));
% heatmap(w_corr,'colormap',redblue)
% 
% filename2 = 'heatmap_Corr_ws_sim_SDREsingleW_model_SDRE_drule.fig';
% 
% savefig(filename2)
       
%% 3.1 80-20 choice v time plots
for i = 1:length(S_chosen_vec_noiseless)
    S_chosen_vec_noiseless{i} = round(S_chosen_vec_noiseless{i});
end
inst_choice_ratio = [];
RR_mat = [];
inst_choice_ratio_mat = [];
inst_reward_ratio_mat = [];
lookback = input('Enter number of trials to lookback for window average : ');
for i = 1:length(S_chosen_vec_noiseless)
    choice_order = S_chosen_vec_noiseless{i};
    choice_order = choice_order(2:end,:);
    for j = 1:length(S_chosen_vec_noiseless{i})-1
        if j < lookback
            num_O_choices = length(find(choice_order(1:j,2) == 1));
            num_M_choices = length(find(choice_order(1:j,1) == 1));
            if num_O_choices ~= 0 && num_M_choices ~= 0
                inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
            elseif num_O_choices == 0
                inst_choice_ratio(j) = 0;
            elseif num_M_choices == 0 
                inst_choice_ratio(j) = 90;
            end    
        else
            num_O_choices = length(find(choice_order(j-(lookback-1):j,2) == 1));
            num_M_choices = length(find(choice_order(j-(lookback-1):j,1) == 1));
            if num_O_choices ~= 0 && num_M_choices ~= 0
                inst_choice_ratio(j) = rad2deg(atan(num_O_choices/num_M_choices));
            elseif num_O_choices == 0
                inst_choice_ratio(j) = 0;
            elseif num_M_choices == 0 
                inst_choice_ratio(j) = 90;
            end   
        end
        
    end 
    
    inst_choice_ratio_mat(i,:) = inst_choice_ratio;
    
    reward_order = R_chosen_vec{i};
    reward_order = reward_order(11:end);
    for j = 1:length(reward_order) 
            if j>0 && j< lookback  
                O_choices = find(choice_order(1:j,2) == 1);
                M_choices = find(choice_order(1:j,1) == 1);
                reward_order_now = reward_order(1:j);
                num_O_rewards = length(find(reward_order_now(O_choices) == 1));
                num_M_rewards = length(find(reward_order_now(M_choices) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    RR_mat(j) = (((0 + lookback-j)*rad2deg(atan(num_O_rewards/num_M_rewards)))+((j)*45))/lookback;
                elseif num_O_rewards == 0
                    RR_mat(j) = (((0 + lookback-j)*0)+((j)*45))/lookback;
                elseif num_M_rewards == 0 
                    RR_mat(j) = (((0 + lookback-j)*90)+((j)*45))/lookback;
                end    
            else
                O_choices = find(choice_order(j-(lookback-1):j,2) == 1);
                M_choices = find(choice_order(j-(lookback-1):j,1) == 1);
                reward_order_now = reward_order((j-(lookback-1):j));
                num_O_rewards = length(find(reward_order_now(O_choices) == 1));
                num_M_rewards = length(find(reward_order_now(M_choices) == 1));
                if num_O_rewards ~= 0 && num_M_rewards ~= 0
                    RR_mat(j) = rad2deg(atan(num_O_rewards/num_M_rewards));
                elseif num_O_rewards == 0
                    RR_mat(j) = 0;
                elseif num_M_rewards == 0 
                    RR_mat(j) = 90;
                end   
            end
    end
        
    inst_reward_ratio_mat(i,:) = RR_mat;
end 

figure
 plot_distribution([2:length(inst_choice_ratio)],90-inst_choice_ratio_mat(:,2:end))

figure
plot([1:240],mean(90-inst_choice_ratio_mat(:,1:240)))
hold on; plot([1:240],mean(90-inst_reward_ratio_mat(:,1:240)))

%FOR 3 block expt plotting
plot([1:240],90-inst_choice_ratio_mat(end,1:240))
hold on; plot([1:240],90-inst_reward_ratio_mat(end,1:240))
pre_sum = 0
for r = 1:length(reward_order)
        if choice_order(r,1) == 1
            if reward_order(r) == 1
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

%% 3.2 80-20 Simulations : weights/ choices from a fixed 
% reward and choice pattern for Glenn's Renewal talk

learning_rule_ID = input('1 - R-E(R)*S depression; 2 - R*S depression; 3 - Glenn Rule depression; 4 - R*S-E(S) depression; 5 - Felsenberg Rule : ');  

W1 = 1;
W2 = 1;
W1_avoid = 1;
W2_avoid = 1;
W1_approach = 1;
W2_approach = 1;

if learning_rule_ID == 5
    W_vec = [W1_avoid,W1_approach,W2_avoid,W2_approach];
else
    W_vec = [W1,W2];
end

eR = 0;
tau = 3.5;
alpha_p = 1/(tau);
alpha_m = 1/tau;
n = 0.2;
n1 = 0.2;
n2 = 0.2;
p = 0.8
alpha = 0; % amount of overlap between odors
eS = [(1+alpha)/2,(1+alpha)/2];

try
    R_order = load('Rs_order.mat');
    R_order = R_order.R_order;
catch
    R_order = input('enter vector of rewards 0 and 1 : ');
end    

try
    C_order = load('C_order.mat');
    C_order = C_order.C_order;
catch
    C_order = input('enter vector of choice 1 and 2 : ');
end    

% save('R_order.mat','R_order');
% save('C_order.mat','C_order');

if length(C_order) ~= length(R_order)
    error('C and R vectors not same length');
end

for i = 1:length(C_order)
    if C_order(i) == 1
        cS1 = 1;
        cS2 = 0;
    else
        cS1 = 0;
        cS2 = 1;
    end
    
    if learning_rule_ID == 1 % depression RERS
        dW1 = n * (R_order(i)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
        dW2 = n * (R_order(i)-eR) * (cS2);
        W1 = W1 - transpose(dW1);
        W2 = W2 - transpose(dW2);
%             Why put a floor on the weights but not a ceiling. 
        if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W1 = 0;
        end   
        if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W2 = 0;
        end    

        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;

     elseif learning_rule_ID == 2 % depression RS
        dW1 = n * (R_order(i)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
        dW2 = n * (R_order(i)) * (cS2);
        W1 = W1 - transpose(dW1);
        W2 = W2 - transpose(dW2);
%             Why put a floor on the weights but not a ceiling. 
        if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W1 = 0;
        end   
        if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W2 = 0;
        end    

        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2; 

     elseif learning_rule_ID == 3 % depression Glenn Rule
         if C_order(i)==1
            dW1 = n .* [R_order(i)] .* [cS1];
            W1 = W1 - transpose(dW1);
            dW2 = n .* [R_order(i)] .* [cS1];
            W2 = W2 + transpose(dW2);
         elseif C_order(i)==2
            dW2 = n .* [R_order(i)] .* [cS2];
            W2 = W2 - transpose(dW2);
            dW1 = n .* [R_order(i)] .* [cS2];
            W1 = W1 + transpose(dW1);
         end    

%             Why put a floor on the weights but not a ceiling. 
        if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W1 = 0;
        end   
        if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W2 = 0;
        end    
        if W1 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W1 = 2;
        end   
        if W2 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W2 = 2;
        end 
        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;  
        
    elseif learning_rule_ID == 4 % depression RSES
        dW1 = n * (R_order(i)) * (cS1 - eS(1)); % This expected reward is stimulus specific, whereas the simulation is usually not
        dW2 = n * (R_order(i)) * (cS2 - eS(2));
        W1 = W1 - transpose(dW1);
        W2 = W2 - transpose(dW2);
%             Why put a floor on the weights but not a ceiling. 
        if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W1 = 0;
        end   
        if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
           W2 = 0;
        end    

        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;
    elseif learning_rule_ID == 5
            M_avoid = W1_avoid*cS1 + W2_avoid*cS2;
%             M_approach = W1_approach*cS1 + W2_approach*cS2 -W_MBON * M_avoid;
            
            % RULE from Springer and Nawrot 2021
            M_approach = W1_approach*cS1 + W2_approach*cS2 + (-0.6/(1+200*exp(-M_avoid*15)));
            
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
            if C_order(i) == 1
%                 dW1_avoid = n * (rR(end)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                % RULE from Springer and Nawrot 2021
                PAM_in = R_order(i);
                PAM = (1/(1+10000*exp(-PAM_in*19)));
                if PAM > 0
                    dW1_avoid = n1 * PAM * (cS1);
                else
                    dW1_avoid = 0;
                end    
                W1_avoid = W1_avoid - transpose(dW1_avoid);
                
                if R_order(i) == 1
                    PPL_in = p*M_approach;
                else
                    PPL_in = M_approach;
                end
                PPL = (1/(1+10000*exp(-PPL_in*19)));
                if PPL > 0
                    dW1_approach = n2 * PPL * (cS1);
                else
                    dW1_approach = 0;
                end
                W1_approach = W1_approach - transpose(dW1_approach);
                
                if W1_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_avoid = 0;
                end    
                if W1_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_approach = 0;
                end  
                
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;
                
            elseif C_order(i) == 2
                PAM_in = R_order(i);
                PAM = (1/(1+10000*exp(-PAM_in*19)));
                if PAM > 0
                    dW2_avoid = n1 * PAM * (cS2);
                else
                    dW2_avoid = 0;
                end    
                W2_avoid = W2_avoid - transpose(dW2_avoid);
                
                if R_order(i) == 1
                    PPL_in = p*M_approach;
                else
                    PPL_in = M_approach;
                end
                PPL = (1/(1+10000*exp(-PPL_in*19)));
                if PPL > 0
                    dW2_approach = n2 * PPL * (cS2);
                else
                    dW2_approach = 0;
                end
                W2_approach = W2_approach - transpose(dW2_approach);
                
                if W2_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_avoid = 0;
                end    
                if W2_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_approach = 0;
                end  
                  
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;  
            end
    end
    
    eR = alpha_p*R_order(i) + (1 - alpha_m)*eR;
    if C_order(i) == 1
        eS(1) = alpha_p*1 + (1 - alpha_m)*eS(1);  
        eS(2) = alpha_p*0 + (1 - alpha_m)*eS(2);
    elseif C_order(i) == 2
        eS(1) = alpha_p*0 + (1 - alpha_m)*eS(1);  
        eS(2) = alpha_p*1 + (1 - alpha_m)*eS(2);
    end 

end


%% 3.3 Felsenberg model simulations 

noisy_inputs = input('0 =  no noise, 1 = noise older version, 2 = noise using the next three entered values : ');
alpha = input('enter alpha value - extent of mean overlap b/w stimuli : ');
sigma2 = input('enter sigma2 value - variance of distribution : ');
c = input('enter c value - off diagonal elements in stimulus co-variance matrix : ');
learning_rule_ID = input('1 - Felsenberg Rule, 2 - Rule 1 + only unrewarded opp pathway changes, 3 - Rule 1 + floor : ');  
n_expts = input('input the number of expts you want to simulate : ');
tottrial = input('input the number of trials per expt - 2000 has previously been used : ');
behavior_rule_ID = input('1 - MBON activity based, 2 - weight based : ')
C1_1000 = nan(n_expts,1); % variable of size k,1 containing the number of times option 1 was chosen to calculate CR
C2_1000 = nan(n_expts,1); % variable of size k,1 containing the number of times option 2 was chosen to calculate CR
In1 = nan(n_expts,1); % variable of size k,1 containing the number of times option 1 was rewarded to calculate IR
In2 = nan(n_expts,1); % variable of size k,1 containing the number of times option 2 was rewarded to calculate RR
y_vec = {};
R_vec = {};
R_chosen_vec ={};
W_vec = {};
S_vec = {};
S_vec_noiseless = {};
S_chosen_vec = {};
S_chosen_vec_noiseless = {};
y_cont = {};


for k = 1:n_expts
   
%     k
    % reseting and predefining the size of the inputs to the regression model
    I1 = [];
    Q = [];
    I2 = [];
    R_v = [];
    I3 = [];
    S = [];
    I4 = [];
    % Simulate the learning process
    p2 = 0.3*rand(1,1); % Probability of reward for odor 1
    p1 = 0.3-p2; % Probability of reward for odor 2
    % Simulate 80-20 expts
%     p2 = 0.2;
%     p1 = 0.8;
    % Simulate 100-0 expts
%     p2 = 0;
%     p1 = 1;
    % multiple blocks
%     p1 = [0.8;0.11;0.89]; 
%     p2 = 1-p1;
    % IF YOU WANT POTENTIATION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
    [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec{k},R_vec{k},W_vec{k},S_vec{k},S_vec_noiseless{k},y_cont{k},R_chosen_vec{k},S_chosen_vec{k},S_chosen_vec_noiseless{k}] = Loewenstein_Seung_FelsenbergVersion(p1,p2,noisy_inputs,alpha,c,sigma2,learning_rule_ID,tottrial,behavior_rule_ID); % simulate the behavior
    % IF YOU WANT DEPRESSION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_depression_JEF(p1,p2); % simulate the behavior
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_JEF_multBlock(p1,p2); % simulate the behavior with multiple blocks of rewards
end


fI1 = In1./[In1+In2];
fC1 = C1_1000./[C1_1000+C2_1000];
figure
scatter(fI1,fC1)

%% FUNCTIONS
%% 1.2 : Function that runs the actual simulation in SECTION 1

function [I1,I2,C1_1000,C2_1000] = Loewenstein_Seung_preprint_v1(p1,p2,noisy_inputs,learning_rule_ID,comp_frac_trials,noisy_behavior,reward_smoothing)
    C1 = 0;
    C2 = 0;
    C1_1000 = 0;
    C2_1000 = 0;
    I1 = 0;
    I2 = 0;
    W1 = 1;
    W1_vec = [1];
    W2 = 1;
    W2_vec = [1];
    aR1 = 0;
    aR2 = 0;
    rR1 = [0,0,0,0,0,0,0,0,0,0];
    rR2 = [0,0,0,0,0,0,0,0,0,0];
    rR = [0,0,0,0,0,0,0,0,0,0];
    eR1 = 0;
    eR2 = 0;
    eR = 0;
    eR_vec = [];
    tau = 7;
    alpha_p = 1/(tau);
    alpha_m = 1/tau;
    tS1 = [0,0,0,0,0,0,0,0,0,0];
    tS2 = [0,0,0,0,0,0,0,0,0,0];
    trial_type = zeros(2000,1);
    if learning_rule_ID ~= 6
        % plasticity rate for cov LR
        n = 0.2;
    else
        %plasticity rate for non-cov LR
        n = 0.2;
    end    
    currC = [];

    for trialn = 1:2000
    %     if p1
    %     if trialn <= 500
    %         p1 = p1_mat(1);
    %         p2 = p2_mat(1);
    %     elseif trialn > 500 && trialn <= 1000
    %         p1 = p1_mat(2);
    %         p2 = p2_mat(2);
    %     elseif trialn > 1000 && trialn <= 1500
    %         p1 = p1_mat(3);
    %         p2 = p2_mat(3);
    %     else
    %         p1 = p1_mat(4);
    %         p2 = p2_mat(4);
    %     end

        ftrial_rand = rand(1,1);
        if ftrial_rand <= comp_frac_trials
            trial_type(trialn) = 1;
        elseif ftrial_rand <= comp_frac_trials + (1 - comp_frac_trials)/2
            trial_type(trialn) = 2;
        else
            trial_type(trialn) = 3;
        end 

        %cS1 = 1;
        %cS2 = 1;

        if trial_type(trialn) == 1
            cS1 = 1;
            cS2 = 1;
        elseif trial_type(trialn) == 2
            cS1 = 1;
            cS2 = 0;
        else
            cS1 = 0;
            cS2 = 1;
        end    

        if noisy_inputs == 1
            cS1 = 0.1.*randn(1,1) + cS1;
            cS2 = 0.1.*randn(1,1) + cS2;
        end

        tS1(trialn) = cS1;
        tS2(trialn) = cS2;

        if reward_smoothing == 1
            eR1 = mean(rR1(end-9:end)); % Expected reward from choice 1
            eR2 = mean(rR2(end-9:end)); % Expected reward from choice 2
            eR = mean(rR(end-9:end));
        elseif reward_smoothing == 2
    %         eR1 = alpha_p*rR1(end) + (1-alpha_m)*eR1;
    %         eR2 = alpha_p*rR2(end) + (1-alpha_m)*eR2;
              eR = alpha_p*rR(end) + (1 - alpha_m)*eR;  
              eR_vec(trialn) = eR;
    %         eR = movavg(rR','exponential',length(rR));
    %         eR = eR(end);
        end
        if isnan(eR1) == 1
            eR1 = 0;
        elseif isnan(eR2) == 1
            eR2 = 0;
        end    

        % reward for option 1
        if aR1 == 1
            aR1 = 1;
        elseif aR1 == 0
            if rand(1,1) < p1
                aR1 = 1;
            end
        end

        % reward for option 2
        if aR2 == 1
            aR2 = 1;
        elseif aR2 == 0
            if rand(1,1) < p2
                aR2 = 1;
            end
        end

        M1 = W1*cS1;
        M2 = W2*cS2;

        counted_trial = gt(trialn,1000);%*eq(trial_type(trialn),1); 

        if noisy_behavior == 0
            if learning_rule_ID < 6
                if mean(M1) > mean(M2)
                    currC = 1;
                elseif mean(M1) < mean(M2)
                    currC = 2;
                else
                    if rand(1,1) < 0.5
                        currC = 1;
                    else
                        currC = 2;
                    end
                end
            else
                if mean(M1) < mean(M2)
                    currC = 1;
                elseif mean(M1) > mean(M2)
                    currC = 2;
                else
                    if rand(1,1) < 0.5
                        currC = 1;
                    else
                        currC = 2;
                    end
                end
            end  

        elseif noisy_behavior == 1
            if learning_rule_ID < 6
                if rand(1,1) < 1/(1+exp(-8*(M1-M2)))        
                    currC = 1;
                else
                    currC = 2;
                end
            else
                if rand(1,1) < 1/(1+exp(8*(M1-M2)))        
                    currC = 1;
                else
                    currC = 2;
                end
            end    
        end

        if currC == 1
            if counted_trial 
                C1_1000 = C1_1000 + 1;
            end    
            C1 = C1 + 1;
            if aR1 == 1
                rR1(length(rR1)+ 1) = aR1;
                rR(length(rR)+1) = aR1;
                if counted_trial
                    I1 = I1 + 1;
                end    
                aR1 = 0;
            else
                rR1(length(rR1)+ 1) = aR1;
                rR(length(rR)+1) = aR1;
            end
        elseif currC == 2
            if counted_trial
                C2_1000 = C2_1000 + 1;
            end 
            C2 = C2 + 1;
            if aR2 == 1
                rR2(length(rR2)+ 1) = aR2;
                rR(length(rR)+1) = aR2;
                if counted_trial
                    I2 = I2 + 1;
                end
                aR2 = 0;
            else
                rR2(length(rR2)+ 1) = aR2;
                rR(length(rR)+1) = aR2;
            end
        end     

        if learning_rule_ID == 1      
            % update rule for cov LR 1
    %         if currC == 1
                dW1 = n .* [rR(end)] .* [cS1-mean(tS1(end-9:end))];
        %         dW1 = n .* [rR1(end)] .* [cS1-mean(tS1)];
                W1 = W1 + transpose(dW1);
    %         elseif currC == 2
                dW2 = n .* [rR(end)] .* [cS2-mean(tS2(end-9:end))];
        %         dW2 = n .* [rR2(end)] .* [cS2-mean(tS2)];
                W2 = W2 + transpose(dW2);
    %         end  
        elseif learning_rule_ID == 2
        %    update rule for cov LR 2
    %         if currC == 1
                dW1 = n .* [rR(end)-eR] .* [cS1];
                W1 = W1 + transpose(dW1);
    %         elseif currC == 2
                dW2 = n .* [rR(end)-eR] .* [cS2];
                W2 = W2 + transpose(dW2);
    %         end  
        elseif learning_rule_ID == 3
            % update rule for cov LR 3
            if currC == 1
                cS2 = cS2-1; % to say this stimulus disappears but noise remains
                dW1 = n .* [rR(end)-eR] .* [cS1];
                W1 = W1 + transpose(dW1);
    %             if W1 < 0
    %                 W1 = 0;
    %             end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)-eR] .* [cS2];
                W2 = W2 + transpose(dW2);
    %             if W2 < 0
    %                 W2 = 0;
    %             end 
                W2_vec(trialn+1) = W2;
            elseif currC == 2
                cS1 = cS1-1; %same reasoning as above
                dW1 = n .* [rR(end)-eR] .* [cS1];
                W1 = W1 + transpose(dW1);
    %             if W1 < 0
    %                 W1 = 0;
    %             end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)-eR] .* [cS2];
                W2 = W2 + transpose(dW2);
    %             if W2 < 0
    %                 W2 = 0;
    %             end 
                W2_vec(trialn+1) = W2;
            end  
        elseif learning_rule_ID == 4
            % update rule for non-cov LR
    %         if currC == 1
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 + transpose(dW1);
    %         elseif currC == 2
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 + transpose(dW2);
    %         end 
        elseif learning_rule_ID == 5
            % update rule for cov LR 4
    %         if currC == 1
                dW1 = n .* [rR(end)-eR] .* [cS1-mean(tS1(end-9:end))];
                W1 = W1 + transpose(dW1);
    %         elseif currC == 2
                dW2 = n .* [rR(end)-eR] .* [cS2-mean(tS2(end-9:end))];
                W2 = W2 + transpose(dW2);
    %         end  
        elseif learning_rule_ID == 6
        % depression update rule for non cov LR 2 - task v2
            if currC == 1
                cS2 = cS2-1; % to say this stimulus disappears but noise remains
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 - transpose(dW1);
                if W1 < 0
                    W1 = 0;
                end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 - transpose(dW2);
                if W2 < 0
                    W2 = 0;
                end  
                W2_vec(trialn+1) = W2;
            elseif currC == 2
                cS1 = cS1-1; %same reasoning as above
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 - transpose(dW1);
                if W1 < 0
                    W1 = 0;
                end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 - transpose(dW2);
                if W2 < 0
                    W2 = 0;
                end 
                W2_vec(trialn+1) = W2;
            end 
        elseif learning_rule_ID == 7
            % depression update rule for cov LR 5
            if currC == 1
                cS2 = cS2-1; % to say this stimulus disappears but noise remains
                dW1 = n .* [rR(end)-eR] .* [cS1];
                W1 = W1 - transpose(dW1);
                if W1 < 0
                    W1 = 0;
                end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)-eR] .* [cS2];
                W2 = W2 - transpose(dW2);
                if W2 < 0
                    W2 = 0;
                end 
                W2_vec(trialn+1) = W2;
            elseif currC == 2
                cS1 = cS1-1; %same reasoning as above
                dW1 = n .* [rR(end)-eR] .* [cS1];
                W1 = W1 - transpose(dW1);
                if W1 < 0
                    W1 = 0;
                end 
                W1_vec(trialn+1) = W1;
                dW2 = n .* [rR(end)-eR] .* [cS2];
                W2 = W2 - transpose(dW2);
                if W2 < 0
                    W2 = 0;
                end 
                W2_vec(trialn+1) = W2;
            end 
        elseif learning_rule_ID == 8
            % update rule for cov LR 4
    %         if currC == 1
                dW1 = n .* [rR(end)-eR] .* [cS1-mean(tS1(end-9:end))];
                W1 = W1 - transpose(dW1);
    %         elseif currC == 2
                dW2 = n .* [rR(end)-eR] .* [cS2-mean(tS2(end-9:end))];
                W2 = W2 - transpose(dW2);
    %         end      
        elseif learning_rule_ID == 0
            % update rule put forward by Glenn
            if currC == 1
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 + transpose(dW1);
                dW2 = n .* [rR(end)] .* [cS1];
                W2 = W2 - transpose(dW2);
            elseif currC == 2
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 + transpose(dW2);
                dW1 = n .* [rR(end)] .* [cS2];
                W1 = W1 - transpose(dW1);
            end    
        end
    %     keyboard
    end 
end


%% 2.3 actual simulation function for SECTION 2

function [I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec,S_vec_noiseless,y_cont,rR,S_chosen_vec,S_chosen_vec_noiseless,block_switch_IDs] = Loewenstein_Seung_FlyVersion(p1mat,p2mat,noisy_inputs,alpha,c,sigma2,learning_rule_ID,tottrial)

    C1_1000 = 0; % Number of times option 1 is chosen (Y=1 when cS1 = 1)
    C2_1000 = 0; % Number of times option 2 is chosen (Y=1 when cS1 = 2)
    I1 = 0; % Number of times option 1 is rewarded
    I2 = 0; % Number of times option 2 is rewarded
    W1 = 1; % Weight associated with option 1
    W2 = 1; % Weight associated with option 2
    aR1 = 0; % Available reward for choice 1 after baiting is accounted for
    aR2 = 0; % Available reward for choice 2 after baiting is accounted for
    rR1 = zeros(10,1); % reward history for option 1 padded by 10 zeros to calculate eR1 for first 10 trials
    rR2 = zeros(10,1); % reward history for option 2 padded by 10 zeros to calculate eR2 for first 10 trials
    rR = zeros(10,1);
    eR = 0;
    S_chosen_vec = [0,0];
    S_chosen_vec_noiseless = [0,0];
    eS = [(1+alpha)/2,(1+alpha)/2];
    S_vec = [0,0]; % stimulus history
    S_vec_noiseless = [0,0];
    y = []; % choice history
    y_cont = []; % history of choice variable before passing through non-linearity to determine the actual choice
    new_trial = 0;
    R_vec = [0,0]; % reward history
    W_vec = [W1,W2]; % weight history
    tau = 3.5;
    alpha_p = 1/(tau);
    alpha_m = 1/tau;
    % plasticity rate for cov LR
    n = 0.2;
    %plasticity rate for non-cov LR
    % n = 0.2;
    kappa = 0.03;
    currC = [];

    for trialn = 1:tottrial % The number of trials is hardcoded as 2000
        if length(p1mat) == 1
            p1 = p1mat;
            p2 = p2mat;
        elseif length(p1mat) == 2    
            if trialn < 81
                p1 = p1mat(1);
                p2 = p2mat(1);
            elseif trialn >= 81 && trialn < 161
                p1 = p1mat(2);
                p2 = p2mat(2);
            end    
        elseif length(p1mat) == 3
            if trialn < 81
                p1 = p1mat(1);
                p2 = p2mat(1);
            elseif trialn >= 81 && trialn < 161
                p1 = p1mat(2);
                p2 = p2mat(2); 
            else
                p1 = p1mat(3);
                p2 = p2mat(3);
            end    
        end    
        new_trial = 0;
        if trialn == 81
            block_switch_IDs(1) = length(S_vec);
        elseif trialn == 161
            block_switch_IDs(2) = length(S_vec);
        end    
    % VERSION 1 OF CALCULATION
    %     if eq(trialn,1)
    %         R_ave_1 = 0;
    %         R_ave_2 = 0;
    %     elseif (trialn < 10)
    %         R_ave_1 = mean(R_vec(1:trialn,1));
    %         R_ave_2 = mean(R_vec(1:trialn,2));
    %     else
    %         R_ave_1 = mean(R_vec(trialn-9:trialn,1));
    %         R_ave_2 = mean(R_vec(trialn-9:trialn,2));
    %     end
    %     eR1 = R_ave_1;
    %     eR2 = R_ave_2;

    % VERSION 2 OF CALCULATION
        eR1 = mean(rR1(end-9:end)); % Expected reward from choice 1
        eR2 = mean(rR2(end-9:end)); % Expected reward from choice 2
%         eR = mean(rR(end-9:end));
        eR = alpha_p*rR(end) + (1 - alpha_m)*eR;  
       
    % VERSION 3 OF CALCULATION : ER is calculated independent of odor identity
    %     R_Ind = sum(R_vec,2);
    %     
    %     if eq(trialn,1)
    %         eR1 = 0;
    %         eR2 = 0;
    %     elseif (trialn < 10)
    %         eR1 = mean(R_Ind(1:trialn));
    %         eR2 = mean(R_Ind(1:trialn));
    %     else
    %         eR1 = mean(R_Ind(end-9:end));
    %         eR2 = mean(R_Ind(end-9:end));
    %     end

        % Ensuring the eR is never a Nan in case the padding of rR1 or rR2 for the
        % calculation of eR on early trials is insufficient
    %     if isnan(eR1) == 1
    %         eR1 = 0;
    %     end    
    %     if isnan(eR2) == 1
    %         eR2 = 0;
    %     end  
    
    % CALCULATING EXPECTED STIMULUS
        eS = alpha_p*S_chosen_vec(end,:) + (1 - alpha_m)*eS;  
       
        % reward for option 1
%         if trialn > 1
        if aR1 == 1 % if aR = 1 this means the reward is availbe because of baiting so it stays as 1
            aR1 = 1; 
        elseif aR1 == 0 %&& y(trialn-1)== 1 % Indicates that there is no reward baiting, and the animal went forward last trial. To ensure that available reward is not recalculated after turning away from odor
            if rand(1,1) < p1 % determining whether to provide reward by comparing random number to predefined probability
                aR1 = 1;
            end
        end
%         elseif trialn == 1
%             if aR1 == 1
%                 aR1 = 1; 
%             elseif aR1 == 0
%                 if rand(1,1) < p1 % Add a waiting reward with probability p1
%                     aR1 = 1;
%                 end
%             end
%         end    

        % reward for option 2 calculated in the same was as described above for
        % option 1
%         if trialn > 1
        if aR2 == 1
            aR2 = 1;
        elseif aR2 == 0
            if rand(1,1) < p2 %&& y(trialn-1) == 1
                aR2 = 1;
            end
        end
%         elseif trialn == 1
%             if aR2 == 1
%                 aR2 = 1; 
%             elseif aR2 == 0
%                 if rand(1,1) < p2
%                     aR2 = 1;
%                 end
%             end
%         end     

        while new_trial ~= 1

            ftrial_rand = rand(1,1);
            if ftrial_rand <= 0.5
                trial_type(trialn) = 1;
            else
                trial_type(trialn) = 2;
            end
            if noisy_inputs < 2
                if trial_type(trialn) == 1
                    cS1 = 1;
                    cS2 = 0;
                else
                    cS1 = 0;
                    cS2 = 1;
                end    

                if noisy_inputs == 1
                    cS1 = 0.1.*randn(1,1) + cS1;
                    cS2 = 0.1.*randn(1,1) + cS2;
                end
            elseif noisy_inputs == 2
                if trial_type(trialn) == 1
                    mu = [1,alpha];
                    covmat = sigma2*[1,c;c,1];
                else
                    mu = [alpha,1];
                    covmat = sigma2*[1,c;c,1];
                end  
                R = mvnrnd(mu,covmat,1);
                cS1 = R(1);
                cS2 = R(2);
            end

            if trial_type(trialn) == 1
                S_vec_noiseless(length(S_vec_noiseless(:,1))+1,:) = [1,alpha];
            else
                S_vec_noiseless(length(S_vec_noiseless(:,1))+1,:) = [alpha,1];
            end    
            S_vec(length(S_vec(:,1))+1,:) = [cS1,cS2]; % Create an array of stimuli
%             S_vec = [S_vec; [cS1,cS2]]
            % Here the average reward is computed over the last 10 exposures.
            % the average reward is odor specific
            if learning_rule_ID > 5
                steep = 4;
            else
                steep = -4;
            end

            % Calculating the activity of the output neurons. weight * input
            M1 = W1*cS1;
            M2 = W2*cS2;
%             counted_trial = gt(trialn,1000);
            counted_trial = gt(trialn,1);

            if trial_type(trialn)==1 % in situations where animal experiences option 1
        %         y_cont(trialn) = 1/(1+exp(-4*(M1+M2)));
%                 y_cont(trialn) = 1/(1+exp(-8*(M1-M2))); % calculate choice determining variable via logisitc function
                y_cont(length(y_cont)+1) = 1/(1+exp(steep*(M1+M2-1)));
        %         if rand(1,1) < 1/(1+exp(-4*(M1+M2)))
%                 if  rand(1,1) < 1/(1+exp(-8*(M1-M2))) % determine the choice made by comparing y_cont to a random number
                if  rand(1,1) < 1/(1+exp(steep*(M1+M2-1)))
                    S_chosen_vec = [S_chosen_vec; [cS1,cS2]];
%                     if trial_type(trialn) == 1
                        S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [1,alpha]];
%                     else
%                         S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [alpha,1]];
%                     end 
                    y(length(y)+1) = 1; % Go forward
                    new_trial = 1;
                    if counted_trial
                        C1_1000 = C1_1000+1; % update the number of times option 1 was chosen
                    end
                    if aR1 == 1
                        rR(length(rR)+ 1) = aR1;
                        rR1(length(rR1)+ 1) = aR1; % update option 1 reward history
                        R_vec(length(R_vec(:,1))+1,1) = aR1; %update reward history
                        if counted_trial
                            I1 = I1 + 1; % update the income associated with option 1
                        end
                        aR1 = 0; % This is the only line that needs to be within an if statement
                    else % here same as above but reward is not available
                        rR1(length(rR1)+ 1) = aR1;
                        rR(length(rR)+1) = aR1;
                        R_vec(length(R_vec(:,1))+1,1) = aR1;
                    end
                else

                    y(length(y)+1) = 0; % Turn
                    % When the animal turns, it always registers as not getting a
                    % reward.
        %             rR1(length(rR1)+ 1) = 0; 
        %             rR(length(rR)+1) = 0;
                    R_vec(length(R_vec(:,1))+1,1) = NaN;
                end  
            elseif trial_type(trialn)==2  % in situations where animal experiences option 2. Same as described for option 1 above
        %         y_cont(trialn) = 1/(1+exp(-4*(M2+M1)));
%                 y_cont(trialn) = 1/(1+exp(-8*(M2-M1)));
                y_cont(length(y_cont)+1) = 1/(1+exp(steep*(M1+M2-1)));
        %         if rand(1,1) < 1/(1+exp(-4*(M2+M1)))
%                 if rand(1,1) < 1/(1+exp(-8*(M2-M1))) 
                if rand(1,1) < 1/(1+exp(steep*(M1+M2-1))) 
                    S_chosen_vec = [S_chosen_vec; [cS1,cS2]];
%                     if trial_type(trialn) == 1
%                         S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [1,alpha]];
%                     else
                        S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [alpha,1]];
%                     end 
                    y(length(y)+1) = 1;
                    new_trial = 1;
                    if counted_trial
                        C2_1000 = C2_1000+1; % update the number of times option 1 was chosen
                    end
                    if aR2 == 1
                        rR2(length(rR2)+ 1) = aR2;
                        rR(length(rR)+1) = aR2;
                        R_vec(length(R_vec(:,1))+1,2) = aR2;
                        if counted_trial
                            I2 = I2 + 1; % update the income associated with option 1
                        end
                        aR2 = 0;
                    else
                        rR2(length(rR2)+ 1) = aR2;
                        rR(length(rR)+1) = aR2;
                        R_vec(length(R_vec(:,1))+1,2) = aR2;
                    end
                else
                    y(length(y)+1) = 0;
        %             rR2(length(rR2)+ 1) = 0;
        %             rR(length(rR)+1) = 0;
                    R_vec(length(R_vec(:,1))+1,2) = NaN;
                end 
            end

        end

        if learning_rule_ID == 1 
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
%             if trial_type(trialn) == 1
                dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                dW2 = n * (rR(end)-eR) * (cS2);
                W1 = W1 + transpose(dW1);
                W2 = W2 + transpose(dW2);
        %             Why put a floor on the weights but not a ceiling. 
        %             if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W1 = 0;
        %             end    
                W_vec(length(W_vec(:,1))+1,1) = W1;
                W_vec(length(W_vec(:,1)),2) = W2;
%             elseif trial_type(trialn) == 2
%                 dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
%                 dW2 = n * (rR(end)-eR) * (cS2);
%                 W1 = W1 + transpose(dW1);
%                 W2 = W2 + transpose(dW2);
%         %             if W2 < 0
%         %                W2 = 0;
%         %             end   
%                 W_vec(length(W_vec(:,1))+1,2) = W2;
%                 W_vec(length(W_vec(:,1)),1) = W1;
%             end 

        %     

                 % d rule COV bot updated but global R and E(R) - depression
                    % update rule VERSION 1 for cov LR where both options are modified
        %         if cS1 == 1
        %             dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
        %             dW2 = n * (rR(end)-eR) * (cS2);
        %             W1 = W1 - transpose(dW1);
        %             W2 = W2 - transpose(dW2);
        % %             Why put a floor on the weights but not a ceiling. 
        %             if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W1 = 0;
        %             end 
        %             if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W2 = 0;
        %             end
        %             W_vec(length(W_vec(:,1))+1,1) = W1;
        %             W_vec(length(W_vec(:,1)),2) = W2;
        %         elseif cS1 == 0
        %             dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
        %             dW2 = n * (rR(end)-eR) * (cS2);
        %             W1 = W1 -transpose(dW1);
        %             W2 = W2 - transpose(dW2);
        %             if W2 < 0
        %                W2 = 0;
        %             end   
        %             if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W1 = 0;
        %             end
        %             W_vec(length(W_vec(:,1))+1,2) = W2;
        %             W_vec(length(W_vec(:,1)),1) = W1;
        %         end 
        elseif learning_rule_ID == 2
        % non-cov rule both updated only R
        % update rule for non-cov LR VERSION 2 : Both options updated every step
%             if trial_type(trialn) == 1
                dW1 = n * (rR(end)) * (cS1);
                dW2 = n * (rR(end)) * (cS2);
                W1 = W1 + transpose(dW1);
                W2 = W2 + transpose(dW2);
        %         if W1 < 0
        %             W1 = 0;
        %         end    
                W_vec(length(W_vec(:,1))+1,1) = W1;
                W_vec(length(W_vec(:,1)),2) = W2;
%             elseif trial_type(trialn) == 2
%                 dW1 = n * (rR(end)) * (cS1);
%                 dW2 = n * (rR(end)) * (cS2);
%                 W1 = W1 + transpose(dW1);
%                 W2 = W2 + transpose(dW2);
%         %         if W2 < 0
%         %             W2 = 0;
%         %         end   
%                 W_vec(length(W_vec(:,1))+1,2) = W2;
%                 W_vec(length(W_vec(:,1)),1) = W1;
%             end
            
        elseif learning_rule_ID == 3    
            dW1 = n * (rR(end)) * (cS1-eS(end,1));
            dW2 = n * (rR(end)) * (cS2-eS(end,2));
            W1 = W1 + transpose(dW1);
            W2 = W2 + transpose(dW2);
    %         if W1 < 0
    %             W1 = 0;
    %         end    
            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;
            
        elseif learning_rule_ID == 4    
            dW1 = n * (rR(end)-eR) * (cS1-eS(end,1));
            dW2 = n * (rR(end)-eR) * (cS2-eS(end,2));
            W1 = W1 + transpose(dW1);
            W2 = W2 + transpose(dW2);
    %         if W1 < 0
    %             W1 = 0;
    %         end    
            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;  
            
        elseif learning_rule_ID == 5 % with ceiling
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
%             if trial_type(trialn) == 1
                dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                dW2 = n * (rR(end)-eR) * (cS2);
                W1 = W1 + transpose(dW1);
                W2 = W2 + transpose(dW2); 
                if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1 = 0;
                end   
                if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2 = 0;
                end  
                if W1 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1 = 2;
                end   
                if W2 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2 = 2;
                end 
                W_vec(length(W_vec(:,1))+1,1) = W1;
                W_vec(length(W_vec(:,1)),2) = W2;    
                
        elseif learning_rule_ID == 6 % depression RERS
            dW1 = n * (rR(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
            dW2 = n * (rR(end)-eR) * (cS2);
            W1 = W1 - transpose(dW1);
            W2 = W2 - transpose(dW2);
    %             Why put a floor on the weights but not a ceiling. 
            if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 0;
            end   
            if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 0;
            end    

            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;
                    
         elseif learning_rule_ID == 7 % depression RS
            dW1 = n * (rR(end)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
            dW2 = n * (rR(end)) * (cS2);
            W1 = W1 - transpose(dW1);
            W2 = W2 - transpose(dW2);
    %             Why put a floor on the weights but not a ceiling. 
            if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 0;
            end   
            if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 0;
            end    

            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2; 
            
         elseif learning_rule_ID == 8 % depression Glenn Rule
             if trial_type(trialn)==1
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 - transpose(dW1);
                dW2 = n .* [rR(end)] .* [cS1];
                W2 = W2 + transpose(dW2);
             elseif trial_type(trialn)==2
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 - transpose(dW2);
                dW1 = n .* [rR(end)] .* [cS2];
                W1 = W1 + transpose(dW1);
             end    

    %             Why put a floor on the weights but not a ceiling. 
            if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 0;
            end   
            if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 0;
            end    
            if W1 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 2;
            end   
            if W2 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 2;
            end 
            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;  
            
         elseif learning_rule_ID == 9 % depression Glenn Rule
             if trial_type(trialn)==1
                dW1 = n .* [rR(end)] .* [cS1];
                W1 = W1 - transpose(dW1);
                dW2 = kappa*(2-W2);
                W2 = W2 + transpose(dW2);
             elseif trial_type(trialn)==2
                dW2 = n .* [rR(end)] .* [cS2];
                W2 = W2 - transpose(dW2);
                dW1 = kappa*(2-W1);
                W1 = W1 + transpose(dW1);
             end    

    %             Why put a floor on the weights but not a ceiling. 
            if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 0;
            end   
            if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 0;
            end    
            if W1 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 2;
            end   
            if W2 > 2 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 2;
            end 
            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;     
       elseif learning_rule_ID == 10    
            dW1 = n * (rR(end)) * (cS1-eS(end,1));
            dW2 = n * (rR(end)) * (cS2-eS(end,2));
            W1 = W1 - transpose(dW1);
            W2 = W2 - transpose(dW2);
            if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W1 = 0;
            end   
            if W2 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
               W2 = 0;
            end    
            W_vec(length(W_vec(:,1))+1,1) = W1;
            W_vec(length(W_vec(:,1)),2) = W2;
        end
        
    end
end

%% 2.4 Fly Data Pre-processing

function[R, R_ER, X, X_chosen, X_EX, Y] = FlyData_preprocess(beta,alpha_p,alpha_m,noisy_stimuli)


        
        % LOADING and FORMATTING odor_crossings, choice and reward order and choice points
        load('odor_crossing_1.mat');
        load('cps_1.mat');
        odor_crossings = odor_crossing;
        cp_vec = cps(2:end);
%         load('odor_crossing_1.750000e+00.mat');
%         load('cps_1.750000e+00.mat');
%         cp_vec(length(cp_vec)+1:length(cp_vec)+length(cps(2:end))) = cps(2:end);
%         odor_crossings(length(odor_crossings)+1 : length(odor_crossings)+length(odor_crossing)) = odor_crossing;
%         added_time = cp_vec(length(cp_vec)-length(cps)+1);
%         for ii = length(odor_crossings)-length(odor_crossing)+1 : length(odor_crossings)
%             odor_crossings(ii).time_pt_in_vector = odor_crossings(ii).time_pt_in_vector + added_time;
%     
%         end
%         cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) =  cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) +added_time;
%         
        load('odor_crossing_2.mat');
        load('cps_2.mat');
        cp_vec(length(cp_vec)+1:length(cp_vec)+length(cps(2:end))) = cps(2:end);
        odor_crossings(length(odor_crossings)+1 : length(odor_crossings)+length(odor_crossing)) = odor_crossing;
        added_time = cp_vec(length(cp_vec)-length(cps)+1);
        for ii = length(odor_crossings)-length(odor_crossing)+1 : length(odor_crossings)
            odor_crossings(ii).time_pt_in_vector = odor_crossings(ii).time_pt_in_vector + added_time;
    
        end
        cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) =  cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) +added_time;
        
        if exist('odor_crossing_3.mat')
            load('cps_3.mat');
            load('odor_crossing_3.mat');
            cp_vec(length(cp_vec)+1:length(cp_vec)+length(cps(2:end))) = cps(2:end);
            odor_crossings(length(odor_crossings)+1 : length(odor_crossings)+length(odor_crossing)) = odor_crossing;
            added_time = cp_vec(length(cp_vec)-length(cps)+1);
            for ii = length(odor_crossings)-length(odor_crossing)+1 : length(odor_crossings)
                odor_crossings(ii).time_pt_in_vector = odor_crossings(ii).time_pt_in_vector + added_time;
    
            end
            cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) =  cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) +added_time;
        end
        
        
        RO = load('reward_order.mat');
        CO = load('choice_order.mat');
        CO = CO.choice_order;
        RO = RO.reward_order;
        choice_order = [];
        reward_order = [];
        
        
        for k = 1:size(CO,2)
        choice_order((k-1)*length(CO) + 1 : (k)*length(CO)) = CO(:,k);
        reward_order((k-1)*length(CO) + 1 : (k)*length(CO)) = RO(:,k);
        end
        
        zero_locs = find(choice_order == 0);
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];
        
        
        X = []; % KC - [1,0] if 1(MCH) and [0,1] if 2(OCT)
        X_times = [];
        xcount = 0;
        for i = 1:length(odor_crossings)
       
            class_i = class(odor_crossings(i).type);
            if class_i(1) == 'd'
                continue
            end    
            if isempty(odor_crossings(i).type) 
                continue
            end
            if class(odor_crossings(i).type(1)) == 'cell'
                if odor_crossings(i).type{1}(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector;
                elseif odor_crossings(i).type{1}(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector;
                else
                    continue
                end
            else
                if odor_crossings(i).type(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector;
                elseif odor_crossings(i).type(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector;
                else
                    continue
                end
            end    
        end    
        

        R = zeros(length(X),2); % shouldnt be a n,2 vec but am making it so by duplicating row for regression
        Y = zeros(length(X),1);
        interm_old = [];
        
        for j = 1:length(cp_vec)
            interm_new = find(X_times < cp_vec(j));
            if sum(interm_new) ~= sum(interm_old)
                R(interm_new(end),1) = reward_order(j);
                Y(interm_new(end)) = 1;
                interm_old = interm_new;
            end

        end
        R_count = find(R == 2);
        R(:,2) = R(:,1);
        R(R_count) = 0;
        R_count2 = find(R(:,2)==1);
        R(R_count2,2) = 0;
        R_count = find(R == 2);
        R(R_count) = 1;
        R = sum(R,2);
        R_ave = [];
        
        X_chosen = X(find(Y==1),:);
        if noisy_stimuli == 2
            X_chosen(find(X_chosen ~= 1)) = beta;
        end
        R_chosen = R(find(Y==1),:);
        R_chosen = [zeros(9,1); R_chosen];
%         R_chosen = [zeros(9,2); R_chosen];
%      
        R_ave = zeros(1,1);
%         R_ave = zeros(1,2);
        for timept = 1:length(find(Y==1))
            % Here the average reward is calculated as global signal common for
            % both odors.
            R_ave(timept) = mean(R_chosen(timept:timept+9));
%             R_ave(timept,:) = mean(R_chosen(timept:timept+9,:));

        end 

        R = R_chosen(10:end);
%         R = R_chosen(10:end,:);
        % R - E(R) is calculated
        R_ER = R - R_ave';
%         R_ER = R - R_ave;

        % Compute average stimulus for each odor
        for timept = 1:length(find(Y==1))
            if timept > 1
                X_ave(timept,:) = alpha_p*X_chosen(timept-1,:) + (1 - alpha_m)*X_ave(timept-1,:);  
            else
                X_ave(timept,:) = [(1+beta)/2,(1+beta)/2] ;
            end    
        end
        X_EX = X_chosen - X_ave;

  
end

%% 3.4 simulation Felsenberg version


function [I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec,S_vec_noiseless,y_cont,rR,S_chosen_vec,S_chosen_vec_noiseless] = Loewenstein_Seung_FelsenbergVersion(p1mat,p2mat,noisy_inputs,alpha,c,sigma2,learning_rule_ID,tottrial,behavior_rule_ID)

    C1_1000 = 0; % Number of times option 1 is chosen (Y=1 when cS1 = 1)
    C2_1000 = 0; % Number of times option 2 is chosen (Y=1 when cS1 = 2)
    I1 = 0; % Number of times option 1 is rewarded
    I2 = 0; % Number of times option 2 is rewarded
    W1_avoid = 1; % Weight associated with option 1 avoidance MBON
    W2_avoid = 1; % Weight associated with option 2 avoidance MBON
    W1_approach = 1; % Weight associated with option 1 approach MBON
    W2_approach = 1; % Weight associated with option 2 approach MBON
    W_MBON = 1;
    W_MD = 1;
    aR1 = 0; % Available reward for choice 1 after baiting is accounted for
    aR2 = 0; % Available reward for choice 2 after baiting is accounted for
    rR1 = zeros(10,1); % reward history for option 1 padded by 10 zeros to calculate eR1 for first 10 trials
    rR2 = zeros(10,1); % reward history for option 2 padded by 10 zeros to calculate eR2 for first 10 trials
    rR = zeros(10,1);
    eR = 0;
    S_chosen_vec = [0,0];
    S_chosen_vec_noiseless = [0,0];
    eS = [(1+alpha)/2,(1+alpha)/2];
    S_vec = [0,0]; % stimulus history
    S_vec_noiseless = [0,0];
    y = []; % choice history
    y_cont = []; % history of choice variable before passing through non-linearity to determine the actual choice
    new_trial = 0;
    R_vec = [0,0]; % reward history
    W_vec = [W1_avoid,W1_approach,W2_avoid,W2_approach]; % weight history
    tau = 3.5;
    alpha_p = 1/(tau);
    alpha_m = 1/tau;
    % plasticity rate for cov LR
    n = 0.2;
    %plasticity rate for non-cov LR
    % n = 0.2;
%     kappa = 0.03;
    currC = [];
    
    % Springer and Nawrot parameters
    p = 0.8;
%     n1 = 0.0045;
%     n2 = 0.0045;
    n1 = 0.2;
    n2 = 0.2;
%     n2 = 0.002;
%     W1_avoid = 0.01; % Weight associated with option 1 avoidance MBON
%     W2_avoid = 0.01; % Weight associated with option 2 avoidance MBON
%     W1_approach = 0.01; % Weight associated with option 1 approach MBON
%     W2_approach = 0.01;
%     W_vec = [W1_avoid,W1_approach,W2_avoid,W2_approach]; % weight history
%     
    
    for trialn = 1:tottrial % The number of trials is an input
        if length(p1mat) == 1
            p1 = p1mat;
            p2 = p2mat;
        else
            if trialn < 81
                p1 = p1mat(1);
                p2 = p2mat(1);
            elseif trialn >= 81 && trialn < 161
                p1 = p1mat(2);
                p2 = p2mat(2); 
            else
                p1 = p1mat(3);
                p2 = p2mat(3);
            end    
        end    
        new_trial = 0;
    % VERSION 1 OF CALCULATION
    %     if eq(trialn,1)
    %         R_ave_1 = 0;
    %         R_ave_2 = 0;
    %     elseif (trialn < 10)
    %         R_ave_1 = mean(R_vec(1:trialn,1));
    %         R_ave_2 = mean(R_vec(1:trialn,2));
    %     else
    %         R_ave_1 = mean(R_vec(trialn-9:trialn,1));
    %         R_ave_2 = mean(R_vec(trialn-9:trialn,2));
    %     end
    %     eR1 = R_ave_1;
    %     eR2 = R_ave_2;

    % VERSION 2 OF CALCULATION
        eR1 = mean(rR1(end-9:end)); % Expected reward from choice 1
        eR2 = mean(rR2(end-9:end)); % Expected reward from choice 2
%         eR = mean(rR(end-9:end));
        eR = alpha_p*rR(end) + (1 - alpha_m)*eR;  
       
    % VERSION 3 OF CALCULATION : ER is calculated independent of odor identity
    %     R_Ind = sum(R_vec,2);
    %     
    %     if eq(trialn,1)
    %         eR1 = 0;
    %         eR2 = 0;
    %     elseif (trialn < 10)
    %         eR1 = mean(R_Ind(1:trialn));
    %         eR2 = mean(R_Ind(1:trialn));
    %     else
    %         eR1 = mean(R_Ind(end-9:end));
    %         eR2 = mean(R_Ind(end-9:end));
    %     end

        % Ensuring the eR is never a Nan in case the padding of rR1 or rR2 for the
        % calculation of eR on early trials is insufficient
    %     if isnan(eR1) == 1
    %         eR1 = 0;
    %     end    
    %     if isnan(eR2) == 1
    %         eR2 = 0;
    %     end  
    
    % CALCULATING EXPECTED STIMULUS
        eS = alpha_p*S_chosen_vec(end,:) + (1 - alpha_m)*eS;  
       
        % reward for option 1
%         if trialn > 1
        if aR1 == 1 % if aR = 1 this means the reward is availbe because of baiting so it stays as 1
            aR1 = 1; 
        elseif aR1 == 0 %&& y(trialn-1)== 1 % Indicates that there is no reward baiting, and the animal went forward last trial. To ensure that available reward is not recalculated after turning away from odor
            if rand(1,1) < p1 % determining whether to provide reward by comparing random number to predefined probability
                aR1 = 1;
            end
        end


        % reward for option 2 calculated in the same was as described above for
        % option 1
%         if trialn > 1
        if aR2 == 1
            aR2 = 1;
        elseif aR2 == 0
            if rand(1,1) < p2 %&& y(trialn-1) == 1
                aR2 = 1;
            end
        end
  

        while new_trial ~= 1

            ftrial_rand = rand(1,1);
            if ftrial_rand <= 0.5
                trial_type(trialn) = 1;
            else
                trial_type(trialn) = 2;
            end
            if noisy_inputs < 2
                if trial_type(trialn) == 1
                    cS1 = 1;
                    cS2 = 0;
                else
                    cS1 = 0;
                    cS2 = 1;
                end    

                if noisy_inputs == 1
                    cS1 = 0.1.*randn(1,1) + cS1;
                    cS2 = 0.1.*randn(1,1) + cS2;
                end
            elseif noisy_inputs == 2
                if trial_type(trialn) == 1
                    mu = [1,alpha];
                    covmat = sigma2*[1,c;c,1];
                else
                    mu = [alpha,1];
                    covmat = sigma2*[1,c;c,1];
                end  
                R = mvnrnd(mu,covmat,1);
                cS1 = R(1);
                cS2 = R(2);
            end

            if trial_type(trialn) == 1
                S_vec_noiseless(length(S_vec_noiseless(:,1))+1,:) = [1,alpha];
            else
                S_vec_noiseless(length(S_vec_noiseless(:,1))+1,:) = [alpha,1];
            end    
            S_vec(length(S_vec(:,1))+1,:) = [cS1,cS2]; % Create an array of stimuli
%             S_vec = [S_vec; [cS1,cS2]]
            % Here the average reward is computed over the last 10 exposures.
            % the average reward is odor specific
%             if learning_rule_ID > 5
                steep = 4;
%             else
%                 steep = -4;
%             end

            % Calculating the activity of the output neurons and punishment DANs. weight * input
            M_avoid = W1_avoid*cS1 + W2_avoid*cS2;
%             M_approach = W1_approach*cS1 + W2_approach*cS2 -W_MBON * M_avoid;
            
            % RULE from Springer and Nawrot 2021
            M_approach = W1_approach*cS1 + W2_approach*cS2 + (-0.6/(1+200*exp(-M_avoid*15)));
            
%             D_punish = W_MD*M_approach;
            
%             counted_trial = gt(trialn,1000);
            counted_trial = gt(trialn,1);

            if trial_type(trialn)==1 % in situations where animal experiences option 1
        %         y_cont(trialn) = 1/(1+exp(-4*(M1+M2)));
%                 y_cont(trialn) = 1/(1+exp(-8*(M1-M2))); % calculate choice determining variable via logisitc function
                if behavior_rule_ID == 1
%                     y_cont(length(y_cont)+1) = 1/(1+exp(steep*(M_avoid-(M_avoid + M_approach))));
                    % RULE from Springer and Nawrot 2021
                    y_cont(length(y_cont)+1) = (M_approach - M_avoid)/(M_approach + M_avoid);
                elseif behavior_rule_ID == 2
                    y_cont(length(y_cont)+1) = 1/(1+exp(steep*(W1_avoid-W1_approach)));
                end
                
%                 if  rand(1,1) < y_cont(end)
                % RULE from Springer and Nawrot 2021
                if  -1 + (1+1)*rand(1,1) < y_cont(end)   
                    S_chosen_vec = [S_chosen_vec; [cS1,cS2]];
%                     if trial_type(trialn) == 1
                        S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [1,alpha]];
%                     else
%                         S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [alpha,1]];
%                     end 
                    y(length(y)+1) = 1; % Go forward
                    new_trial = 1;
                    if counted_trial
                        C1_1000 = C1_1000+1; % update the number of times option 1 was chosen
                    end
                    if aR1 == 1
                        rR(length(rR)+ 1) = aR1;
                        rR1(length(rR1)+ 1) = aR1; % update option 1 reward history
                        R_vec(length(R_vec(:,1))+1,1) = aR1; %update reward history
                        if counted_trial
                            I1 = I1 + 1; % update the income associated with option 1
                        end
                        aR1 = 0; % This is the only line that needs to be within an if statement
                    else % here same as above but reward is not available
                        rR1(length(rR1)+ 1) = aR1;
                        rR(length(rR)+1) = aR1;
                        R_vec(length(R_vec(:,1))+1,1) = aR1;
                    end
                else

                    y(length(y)+1) = 0; % Turn
                    % When the animal turns, it always registers as not getting a
                    % reward.
        %             rR1(length(rR1)+ 1) = 0; 
        %             rR(length(rR)+1) = 0;
                    R_vec(length(R_vec(:,1))+1,1) = NaN;
                end  
            elseif trial_type(trialn)==2  % in situations where animal experiences option 2. Same as described for option 1 above
                
                if behavior_rule_ID == 1
%                     y_cont(length(y_cont)+1) = 1/(1+exp(steep*(M_avoid -(M_avoid + M_approach))));
                    % RULE from Springer and Nawrot 2021
                    y_cont(length(y_cont)+1) = (M_approach - M_avoid)/(M_approach + M_avoid);
                elseif behavior_rule_ID == 2
                    y_cont(length(y_cont)+1) = 1/(1+exp(steep*(W2_avoid-W2_approach)));
                end
                
%                 if rand(1,1) < y_cont(end)
                   % RULE from Springer and Nawrot 2021
                if  -1 + (1+1)*rand(1,1) < y_cont(end)  
                    S_chosen_vec = [S_chosen_vec; [cS1,cS2]];
%                     if trial_type(trialn) == 1
%                         S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [1,alpha]];
%                     else
                        S_chosen_vec_noiseless = [S_chosen_vec_noiseless; [alpha,1]];
%                     end 
                    y(length(y)+1) = 1;
                    new_trial = 1;
                    if counted_trial
                        C2_1000 = C2_1000+1; % update the number of times option 1 was chosen
                    end
                    if aR2 == 1
                        rR2(length(rR2)+ 1) = aR2;
                        rR(length(rR)+1) = aR2;
                        R_vec(length(R_vec(:,1))+1,2) = aR2;
                        if counted_trial
                            I2 = I2 + 1; % update the income associated with option 1
                        end
                        aR2 = 0;
                    else
                        rR2(length(rR2)+ 1) = aR2;
                        rR(length(rR)+1) = aR2;
                        R_vec(length(R_vec(:,1))+1,2) = aR2;
                    end
                else
                    y(length(y)+1) = 0;
        %             rR2(length(rR2)+ 1) = 0;
        %             rR(length(rR)+1) = 0;
                    R_vec(length(R_vec(:,1))+1,2) = NaN;
                end 
            end

        end

        if learning_rule_ID == 1 
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
            if trial_type(trialn) == 1
%                 dW1_avoid = n * (rR(end)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                % RULE from Springer and Nawrot 2021
                PAM_in = rR(end);
                PAM = (1/(1+10000*exp(-PAM_in*19)));
                if PAM > 0
                    dW1_avoid = n1 * PAM * (cS1);
                else
                    dW1_avoid = 0;
                end    
                W1_avoid = W1_avoid - transpose(dW1_avoid);
                
                if rR(end) == 1
                    PPL_in = p*M_approach;
                else
                    PPL_in = M_approach;
                end
                PPL = (1/(1+10000*exp(-PPL_in*19)));
                if PPL > 0
                    dW1_approach = n2 * PPL * (cS1);
                else
                    dW1_approach = 0;
                end
                W1_approach = W1_approach - transpose(dW1_approach);
                
                if W1_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_avoid = 0;
                end    
                if W1_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_approach = 0;
                end  
                
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;
                
            elseif trial_type(trialn) == 2
                PAM_in = rR(end);
                PAM = (1/(1+10000*exp(-PAM_in*19)));
                if PAM > 0
                    dW2_avoid = n1 * PAM * (cS2);
                else
                    dW2_avoid = 0;
                end    
                W2_avoid = W2_avoid - transpose(dW2_avoid);
                
                if rR(end) == 1
                    PPL_in = p*M_approach;
                else
                    PPL_in = M_approach;
                end
                PPL = (1/(1+10000*exp(-PPL_in*19)));
                if PPL > 0
                    dW2_approach = n2 * PPL * (cS2);
                else
                    dW2_approach = 0;
                end
                W2_approach = W2_approach - transpose(dW2_approach);
                
                if W2_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_avoid = 0;
                end    
                if W2_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_approach = 0;
                end  
                  
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;  
            end
%             keyboard
         elseif learning_rule_ID == 2 
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
            if trial_type(trialn) == 1
                dW1_avoid = n * (rR(end)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                W1_avoid = W1_avoid - transpose(dW1_avoid);
                if rR(end) == 0
                    dW1_approach = n * D_punish * (cS1);
                    W1_approach = W1_approach - transpose(dW1_approach);
                end
        %             Why put a floor on the weights but not a ceiling. 
        %             if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W1 = 0;
        %             end    
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;
                
            elseif trial_type(trialn) == 2
                dW2_avoid = n * (rR(end)) * (cS2); % This expected reward is stimulus specific, whereas the simulation is usually not
                W2_avoid = W2_avoid - transpose(dW2_avoid);
                if rR(end) == 0
                    dW2_approach = n * D_punish * (cS2);
                    W2_approach = W2_approach - transpose(dW2_approach);
                end
        %             Why put a floor on the weights but not a ceiling. 
        %             if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
        %                W1 = 0;
        %             end    
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;  
            end
%             keyboard
        elseif learning_rule_ID == 3 
            % d rule COV bot updated but global R and E(R)
                % update rule VERSION 1 for cov LR where both options are modified
            if trial_type(trialn) == 1
                dW1_avoid = n * (rR(end)) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
                W1_avoid = W1_avoid - transpose(dW1_avoid);
                
                dW1_approach = n * D_punish * (cS1);
                W1_approach = W1_approach - transpose(dW1_approach);
        
                if W1_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_avoid = 0;
                end    
                if W1_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W1_approach = 0;
                end  
                    
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;
                
            elseif trial_type(trialn) == 2
                dW2_avoid = n * (rR(end)) * (cS2); % This expected reward is stimulus specific, whereas the simulation is usually not
                W2_avoid = W2_avoid - transpose(dW2_avoid);
                
                dW2_approach = n * D_punish * (cS2);
                W2_approach = W2_approach - transpose(dW2_approach);
     
                if W2_avoid < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_avoid = 0;
                end    
                if W2_approach < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
                   W2_approach = 0;
                end  

                
                W_vec(length(W_vec(:,1))+1,1) = W1_avoid;
                W_vec(length(W_vec(:,1)),2) = W1_approach;
                W_vec(length(W_vec(:,1)),3) = W2_avoid;
                W_vec(length(W_vec(:,1)),4) = W2_approach;  
            end

        end
        
    end
end


