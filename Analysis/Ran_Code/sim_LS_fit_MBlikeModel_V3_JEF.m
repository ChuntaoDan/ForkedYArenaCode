% simulating multiple cov-rule go no go datasets and fitting wit MBlike
% model

ws = []; % Contains best fit weights
ses = []; % Contains SE on best fit weights
LL = []; % Contains log-likelihoods
LossLOU = []; % Contains mean probability corrects
ER = 0; % Logical variable specifying whether to subtract the expected reward.
C1_1000 = zeros(100,1); % variable of size k,1 containing the number of times option 1 was chosen to calculate CR
C2_1000 = zeros(100,1); % variable of size k,1 containing the number of times option 2 was chosen to calculate CR
In1 = zeros(100,1); % variable of size k,1 containing the number of times option 1 was rewarded to calculate IR
In2 = zeros(100,1); % variable of size k,1 containing the number of times option 2 was rewarded to calculate RR
for k = 1:100
    % reseting and predefining the size of the inputs to the regression model
    I1 = zeros(2000,1);
    Q = zeros(2000,2);
    I2 = zeros(2000,1);
    R_v = zeros(2000,2);
    I3 = zeros(2000,1);
    S = zeros(2000,2);
    I4 = zeros(2000,1);
    % Simulate the learning process
    p1 = rand(1,1); % Probability of reward for odor 1
    p2 = 1-p1; % Probability of reward for odor 2
    % IF YOU WANT POTENTIATION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
    [In1(k),In2(k),C1_1000(k),C2_1000(k),y,R_vec,W_vec,S_vec,y_cont] = Loewenstein_Seung_v6_JEF(p1,p2); % simulate the behavior
    % IF YOU WANT DEPRESSION LEARNING RULE UNCOMMENT THE FOLLOWING LINE
%     [In1(k),In2(k),C1_1000(k),C2_1000(k),y,R_vec,W_vec,S_vec,y_cont] = Loewenstein_Seung_v6_depression_JEF(p1,p2); % simulate the behavior
    y = transpose(y); % tranposing choice history
    X = S_vec(2:2001,:); % stimulus history
    R = (R_vec(2:2001,:));% reward history
%     R(:,2) = R(:,1); % Here the reward vector is duplicated. 
    Y = y; % copying choice history
    Y_cont = transpose(y_cont); % transposing choice variable prior to non-linearity
    
    % Compute the average reward
 
    R_ave = zeros(1,2);
    for timept = 2:length(Y)
        % Here the average reward is computed over the last 10 exposures.
      
        if timept < 11
            R_ave(timept,:) = mean(R(1:(timept-1),:),1);
        else
            R_ave(timept,:) = mean(R(timept-10:(timept-1),:),1);
        end
    end    
    
    % R - E(R) is calculated
    R_ER = R - R_ave;

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
            R_v(t_prime,:) = sum(R(1:(t_prime-1),:),1);
        end
        I3 = sum(X.*R_v,2);
    elseif ER == 1    
        for t_prime = 2:length(Y)
            R_v(t_prime,:) = sum(R_ER(1:(t_prime-1),:),1);
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

    %% Fit regression model
    
    %VERSION 1 : LASSO GLM WITH CROSS VALIDATION. ERROR ESTIMATES ARE NOT
    % STRAIGHTFORWARD FOR LASSO REGRESSION WITH CV
    [B,FitInfo] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1); %performing regression
    idxLambdaMinDeviance = FitInfo.IndexMinDeviance; % identifying best fit model
    B0 = FitInfo.Intercept(idxLambdaMinDeviance); % identifying the bias weight
    wi = [B0; B(:,idxLambdaMinDeviance)]; % all weights including bias
    yhat = glmval(wi,I,'logit'); % calcualting predicted behavior
    ws(:,k) = wi; % saving weights to weight history

    % VERSION 2 : VANILLA REGRESSION THAT ALLOWS US TO GET ERROR ESTIMATES.
    % NO CROSS VALIDATION
%     B = fitglm(I,Y,'Distribution','binomial'); % performing regression
%     yhat = glmval(B.Coefficients.Estimate,I,'logit'); % predicted choices
%     ws(:,k) = B.Coefficients.Estimate; % weights (bias is included by default here)
%     ses(:,k) = B.Coefficients.SE; % error on weights
%     
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

    

end

