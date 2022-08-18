% simulating multiple cov-rule go no go datasets and fitting wit MBlike
% model

ws = []; % Contains best fit weights
ses = []; % Contains SE on best fit weights
LL = []; % Contains log-likelihoods
LossLOU = []; % Contains mean probability corrects
ER = 1; % Logical variable specifying whether to subtract the expected reward.
C1_1000 = zeros(50,1); % variable of size k,1 containing the number of times option 1 was chosen to calculate CR
C2_1000 = zeros(50,1); % variable of size k,1 containing the number of times option 2 was chosen to calculate CR
In1 = zeros(50,1); % variable of size k,1 containing the number of times option 1 was rewarded to calculate IR
In2 = zeros(50,1); % variable of size k,1 containing the number of times option 2 was rewarded to calculate RR
for k = 1:50
    % reseting and predefining the size of the inputs to the regression model
    I1 = [];
    Q = [];
    I2 = [];
    R_v = [];
    I3 = [];
    S = [];
    I4 = [];
    % Simulate the learning process
    p1 = rand(1,1); % Probability of reward for odor 1
    p2 = 1-p1; % Probability of reward for odor 2
    % IF YOU WANT POTENTIATION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
    [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_JEF(p1,p2); % simulate the behavior
    % IF YOU WANT DEPRESSION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_depression_JEF(p1,p2); % simulate the behavior
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y_vec(k,:),R_vec(:,:,k),W_vec(:,:,k),S_vec(:,:,k),y_cont(k,:)] = Loewenstein_Seung_v7_JEF_multBlock(p1,p2); % simulate the behavior with multiple blocks of rewards
end

for k = 1:50
    y = transpose(y_vec(k,:)); % tranposing choice history
    X = squeeze(S_vec(2:length(S_vec),:,k)); % stimulus history
    R = squeeze(R_vec(2:length(S_vec),:,k));% reward history
%     R(:,2) = R(:,1); % Here the reward vector is duplicated. 
    Y = y; % copying choice history
    Y_cont = transpose(y_cont(k,:)); % transposing choice variable prior to non-linearity
    % VERSION 1 : Compute the average reward in an odor specific manner
    
    R_ave = zeros(1,2);
    for timept = 2:length(Y)
        % Here the average reward for option 1 is computed over the last 10
        % exposures to option 1.
        X1 = find(X(1:timept-1,1) == 1);
        R1 = zeros(10,1);
        if length(X1) < 11
            R1(1:length(X1)) = R(X1,1);
            R_ave(timept,1) = mean(R1,1);
        else
            R1 = R(X1(end-9:end),1);
            R_ave(timept,1) = mean(R1,1);
        end
        if isnan(R_ave(timept,1)) == 1
            R_ave(timept,1) = 0;
        end    
        % Here the average reward for option 1 is computed over the last 10
        % exposures to option 1.
        X2 = find(X(1:timept-1,2) == 1);
        R2 = zeros(10,1);
        if length(X2) < 11
            R2(1:length(X2)) = R(X2,2);
            R_ave(timept,2) = mean(R2,1);
        else
            R2 = R(X2(end-9:end),2);
            R_ave(timept,2) = mean(R2,1);
        end
        if isnan(R_ave(timept,2)) == 1
            R_ave(timept,2) = 0;
        end    
    end 
   
    
    % R - E(R) is calculated
    R_ER = R - R_ave;
    
    %VERSION 2 : Compute the average reward in an odor independent manner
    % Making R that was calculated differently in the simulation same for
    % both odors
%     [a1,b1] = find(R(:,1)==1);
%     [a2,b2] = find(R(:,2)==1);
%     
%     R(a1,2) = 1;
%     R(a2,1) = 1;
%     R_ave = zeros(1,2);
%     for timept = 2:length(Y)
%         % Here the average reward for option 1 is computed over the last 10
%         % exposures to either option.
%         R1 = zeros(10,1);
%         if timept < 10
%             R1(1:timept) = R(1:timept,1);
%             R_ave(timept,1) = mean(R1,1);
%         else
%             R1 = R(timept-9:timept,1);
%             R_ave(timept,1) = mean(R1,1);
%         end
%         if isnan(R_ave(timept,1)) == 1
%             R_ave(timept,1) = 0;
%         end    
%         % Here the average reward for option 1 is computed over the last 10
%         % exposures either option.
%         R2 = zeros(10,1);
%         if timept < 10
%             R2(1:timept) = R(1:timept,2);
%             R_ave(timept,2) = mean(R2,1);
%         else
%             R2 = R(timept-9:timept,2);
%             R_ave(timept,2) = mean(R2,1);
%         end
%         if isnan(R_ave(timept,2)) == 1
%             R_ave(timept,2) = 0;
%         end    
%     end 
% %    
%     
%     % R - E(R) is calculated
%     R_ER = R - R_ave;
%     
    % Formatting the data for regression model fitting
    % Converting R and X into the inputs for the regression (refer to
    % back of lab notebook 1 for how this is calculated)
    % The math behinnd the inputs to the regression model I1, I2, I3 and I4 can be
    % looked at in the pdf that was shared with Glenn Ran and James. These
    % terms are calculated below
    for t_prime = 2:length(Y)
        I1(t_prime,1) = sum((t_prime-1).*X(t_prime-1,:),2);
    end    

    for t_prime = 2:length(Y)
        Q(t_prime,:) = sum(X(1:(t_prime-1),:),1); 
    end
    I2 = sum(X.*Q,2);
    
    % I3 is different depending on whether R or R-E(R) is used
    if ER == 0
        for t_prime = 2:length(Y)
            t_prime_1 = find(X(1:t_prime-1,1)==1);
            t_prime_2 = find(X(1:t_prime-1,2)==1);
            if X(t_prime,1)==1
                R_v(t_prime,1) = sum(R(t_prime_1,1),1);
            else    
                R_v(t_prime,2) = sum(R(t_prime_2,2),1);
            end
        end
        I3 = sum(X.*R_v,2);
    elseif ER == 1    
        for t_prime = 2:length(Y)
            t_prime_1 = find(X(1:t_prime-1,1)==1);
            t_prime_2 = find(X(1:t_prime-1,2)==1);
            if X(t_prime,1)==1
                R_v(t_prime,1) = sum(R_ER(t_prime_1,1),1);
            else    
                R_v(t_prime,2) = sum(R_ER(t_prime_2,2),1);
            end    
        end
        I3 = sum(X.*R_v,2);
    end
    
    % I4 is different depending on whether R or R-E(R) is used
    if ER == 0 % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
        S_unsum = X.*R;
        for t_prime = 2:length(Y)
            S(t_prime,:) = sum(S_unsum(1:(t_prime-1),:),1);
        end    
        I4 = sum(X.*S,2);
    elseif ER == 1  
        S_unsum = X.*R_ER;
        for t_prime = 2:length(Y)
            S(t_prime,:) = sum(S_unsum(1:(t_prime-1),:),1); 
        end    
        I4 = sum(X.*S,2);
    end    
    %concatinating inputs to use in regression
    I = cat(2,I1,I2,I3,I4);
%     I = cat(2,I1,I2,I4);
%     I = cat(2,I1,I2,I3);

    %% Fit regression model
    
    %VERSION 1 : LASSO GLM WITH CROSS VALIDATION. ERROR ESTIMATES ARE NOT
    % STRAIGHTFORWARD FOR LASSO REGRESSION WITH CV
    [B,FitInfo] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1); %performing regression
    idxLambdaMinDeviance = FitInfo.IndexMinDeviance; % identifying best fit model
    B0 = FitInfo.Intercept(idxLambdaMinDeviance); % identifying the bias weight
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
    for i = 6:length(Y)-6
        yhat_tA(i-5) = mean(yhat(i-5:i+5));
    end
    plot(Y_tA)
    hold on
    plot(yhat_tA)
    
    filename = sprintf('fit_timecourse_sim_SDREsingleW_model_SDRE_ifStatement_drule_%d.fig',k);
    
    savefig(filename)
%     
   
    

end

close all

figure
w_corr = corr(transpose(ws));
heatmap(w_corr)

filename2 = 'heatmap_Corr_ws_sim_SDREsingleW_model_SDRE_ifStatement_drule.fig';

savefig(filename2)
    
