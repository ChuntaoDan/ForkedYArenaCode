% simulateing multiple cov-rule go no go datasets and fitting wit MBlike
% model

ws = [];
LL = [];
LossLOU = [];
ER = 1;
for k = 1:30
    p1 = rand(1,1);
    p2 = 1-p1;
    [In1,In2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec] = Loewenstein_Seung_v4(p1,p2);
    y = transpose(y);
    X = S_vec(2:2001,:);
    R = transpose(R_vec);
    R(:,2) = R(:,1);
    Y = y;
    
    R_ave = [];
    for timept = 1:length(Y)
        if timept < 10
            R_ave(timept,:) = mean(R(1:timept,:),1);
        else
            R_ave(timept,:) = mean(R(timept-9:timept,:),1);
        end
    end    

    R_ER = R - R_ave;

    % Converting R and X into the inputs for the regression (refer to
    % back of lab notebook 1 for how this is calculated)
    for t_prime = 1:length(Y)

        I1(t_prime,1) = 1+sum((t_prime-1).*X(t_prime,:),2);
    end    

    for t_prime = 1:length(Y)
        Q(t_prime,:) = sum(X(1:t_prime,:),1);
    end
    I2 = sum(X.*Q,2);

    if ER == 0
        for t_prime = 1:length(Y)
            R_v(t_prime,:) = sum(R(1:t_prime,:),1);
        end
        I3 = sum(X.*R_v,2);
    elseif ER == 1    
        for t_prime = 1:length(Y)
            R_v(t_prime,:) = sum(R_ER(1:t_prime,:),1);
        end
        I3 = sum(X.*R_v,2);
    end

    if ER == 0
        S_unsum = X.*R;
        for t_prime = 1:length(Y)
            S(t_prime,:) = sum(S_unsum(1:t_prime,:),1);
        end    
        I4 = sum(X.*S,2);
    elseif ER == 1  
        S_unsum = X.*R_ER;
        for t_prime = 1:length(Y)
            S(t_prime,:) = sum(S_unsum(1:t_prime,:),1);
        end    
        I4 = sum(X.*S,2);
    end    
    I = cat(2,I1,I2,I3,I4);

    %% Regression

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
        Pc(i)=(prob_i);

    end

    LL(k) = sum(log(Pc(1:end)));
    LossLOU(k)=mean(Pc(1:end));
%     toc;

    ws(:,k) = wi;
    keyboard
end

