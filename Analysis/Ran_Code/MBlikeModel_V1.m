

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
    ER = 1;

    
    for cond_n = 1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            
            continue
        elseif expt_n == 1
            if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
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
        R_ave = [];
        for timept = 1:length(Y)
            if timept < 10
                R_ave(timept,:) = mean(R(1:timept,:),1);
            else
                R_ave(timept,:) = mean(R(timept-9:timept,:),1);
            end
        end    
        
        R_ER = R - R_ave;
        Q = [];
        R_v = [];
        S = [];
        S_unsum = [];
        I = [];
        I1 = [];
        I2 = [];
        I3 = [];
        I4 = [];
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
                
        yhat = [];
         yhat = glmval(wi,I,'logit');
        keyboard
        ws(:,count) = wi;
    end
end
