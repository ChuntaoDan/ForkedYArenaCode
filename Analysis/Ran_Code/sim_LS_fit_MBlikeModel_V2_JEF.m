% simulating multiple cov-rule go no go datasets and fitting wit MBlike
% model

ws = []; % Contains best fit weights
LL = []; % Contains log-likelihoods
LossLOU = []; % Contains mean probability corrects
ER = 1; % Logical variable specifying whether the subtract the expected reward.
for k = 1:30
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
    [In1,In2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec,y_cont] = Loewenstein_Seung_v4_JEF(p1,p2);
    y = transpose(y);
    X = S_vec(2:2001,:);
    R = transpose(R_vec);
    R(:,2) = R(:,1); % Here the reward vector is duplicated. 
    Y = y;
    
    % Compute the average reward
    % Note that this doesn't depend on the choices. 
    R_ave = zeros(1,2);
    for timept = 2:length(Y)
        % Here the average reward is computed over the last 10 exposures.
        % In the simulation, the average reward is odor specific and
        % computed over the last 30 exposures to that odor
        if timept < 11
            R_ave(timept,:) = mean(R(1:(timept-1),:),1);
        else
            R_ave(timept,:) = mean(R(timept-10:(timept-1),:),1);
        end
    end    

    R_ER = R - R_ave;

    % Formatting the data for regression model fitting
    % Converting R and X into the inputs for the regression (refer to
    % back of lab notebook 1 for how this is calculated)
    for t_prime = 2:length(Y)
        % What does this form assume about w_0, if anything.
        %I1(t_prime,1) = 1+sum((t_prime-1).*X(t_prime,:),2); % Why 1+? Shouldn't the final t_prime have a minus 1 after it. 
        I1(t_prime,1) = sum((t_prime-1).*X(t_prime-1,:),2);
    end    

    for t_prime = 2:length(Y)
        %Q(t_prime,:) = sum(X(1:t_prime,:),1); % Shouldn't this only go up to t-1?
        Q(t_prime,:) = sum(X(1:(t_prime-1),:),1); 
    end
    I2 = sum(X.*Q,2);

    if ER == 0
        for t_prime = 2:length(Y)
            %R_v(t_prime,:) = sum(R(1:t_prime,:),1); % Shouldn't this only go up to t-1?
            R_v(t_prime,:) = sum(R(1:(t_prime-1),:),1);
        end
        I3 = sum(X.*R_v,2);
    elseif ER == 1    
        for t_prime = 2:length(Y)
            %R_v(t_prime,:) = sum(R_ER(1:t_prime,:),1); % Shouldn't this only go up to t-1?
            R_v(t_prime,:) = sum(R_ER(1:(t_prime-1),:),1);
        end
        I3 = sum(X.*R_v,2);
    end

    if ER == 0 % As a general comment that may help with debugging, I'd keep lines of code that should be the same outside of if statements. 
        S_unsum = X.*R;
        for t_prime = 2:length(Y)
            %S(t_prime,:) = sum(S_unsum(1:t_prime,:),1); % Shouldn't this only go up to t-1?
            S(t_prime,:) = sum(S_unsum(1:(t_prime-1),:),1);
        end    
        I4 = sum(X.*S,2);
    elseif ER == 1  
        S_unsum = X.*R_ER;
        for t_prime = 2:length(Y)
            %S(t_prime,:) = sum(S_unsum(1:t_prime,:),1); % Shouldn't this only go up to t-1?
            S(t_prime,:) = sum(S_unsum(1:(t_prime-1),:),1); % Shouldn't this only go up to t-1?
        end    
        I4 = sum(X.*S,2);
    end    
    I = cat(2,I1,I2,I3,I4);
%     I = cat(2,I1,I2,I4);
    %% Fit regression model

    [B,FitInfo] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1);
    idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
    B0 = FitInfo.Intercept(idxLambdaMinDeviance);
    wi = [B0; B(:,idxLambdaMinDeviance)];

    yhat = glmval(wi,I,'logit');
    
    for i = 1:length(yhat)

        if eq(Y(i),1)
            prob_i = yhat(i);
        else
            prob_i = 1 - yhat(i);
        end
        Pc(i)=(prob_i); % This can be interpreted as the probability of the choice made. 

    end

    LL(k) = sum(log(Pc(1:end)));
    LossLOU(k)=mean(Pc(1:end));
%     toc;

    ws(:,k) = wi;
    
end

