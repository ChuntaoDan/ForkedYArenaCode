
clc
clear
% close all
count = 0
ws = []
% Select spreadsheet containing experiment names
% FOR MAC : 
% cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
% FOR LINUX : 
cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile ('*','Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
for expt_n = 1:2%length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    ER = 0;

    
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

        count = count+1;
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        
        % LOADING and FORMATTING odor_crossings, choice and reward order and choice points
        load('odor_crossing_1.mat');
        load('cps_1.mat');
        odor_crossings = odor_crossing;
        cp_vec = cps(2:end);
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
            load('odor_crossing_3.mat')
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
        choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
        reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
        end
        
        zero_locs = find(choice_order == 0);
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];
        
        
        X = []; % KC - [1,0] if 1(MCH) and [0,1] if 2(OCT)
        X_times = []
        xcount = 0
        for i = 1:length(odor_crossings)
            class_i = class(odor_crossings(i).type);
            if class_i(1) == 'd'
                continue
            end    
            if class(odor_crossings(i).type(1)) == 'cell'
                if odor_crossings(i).type{1}(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                elseif odor_crossings(i).type{1}(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                else
                    continue
                end
            else
                if odor_crossings(i).type(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                elseif odor_crossings(i).type(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
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
        R = sum(R,2)
        R_ave = [];
        
        % reseting and predefining the size of the inputs to the regression model
        Q = [];
        R_v = [];
        S = [];
        S_unsum = [];
        I = [];
        I1 = [];
        I2 = [];
        I3 = [];
        I4 = [];
        
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
        ws(:,count) = wi; % saving weights to weight history
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

        LL(count) = sum(log(Pc(1:end))); % calculating log likelihood metric
        LossLOU(count)=mean(Pc(1:end)); % calculating average probability of choice made
    %     toc;
    
    % Plotting fit timecourses

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
    
    filename = sprintf('fit_timecourse_fly_model_R_drule_%d.fig',k);
    
    savefig(filename)
%     
    end
    
    close all

    figure
    w_corr = corr(transpose(ws));
    heatmap(w_corr)

    filename2 = 'heatmap_Corr_ws_fly_model_R_drule.fig';

    savefig(filename2)
    
end

