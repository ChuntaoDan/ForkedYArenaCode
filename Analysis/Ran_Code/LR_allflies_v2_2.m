% This version of the logistic regression incorporates cross-validation and
% regularization.


clc
clear
close all
count = 0
% Select spreadsheet containing experiment names
cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
H_vec_max = input('enter max number of trials back to use in model')


for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    LL_mat = {};
    wi_mat = {};
    Pc_mat = {};
    P2_mat = {};
    LossLOU_mat = {};
    
    for cond_n = 1:length(conds)-4
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            
            continue
        end

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

% 
%         choice_order( 1 : 80) = CO(:,1);
%         reward_order( 1 : 80) = RO(:,1);




%     choice_order = CO(((simnum-1)*240)+1 : simnum*240);
%     reward_order = RO(((simnum-1)*240)+1 : simnum*240);
    
        % n0=length(cps_pre);
        n0=1;

        %
        H_vec=1:H_vec_max;
        N = length(choice_order);
        d = cvpartition(choice_order,'HoldOut',0.3);
        nTest = d.TestSize;
        lenH=length(H_vec);
        indH=0;
        LossLOU=zeros(lenH,1);
        Pc = NaN(length(H_vec),nTest-1);
        P2 = NaN(length(H_vec),nTest-1);

        for H=H_vec
            tic;
    %         indH=indH+1
            % H=1;


            n=N-H;  % num of obs
            p=3*H; % num of parameters
            X=zeros(n,p);

        %     c = -1+2*eq(choice_order,2);
            r = -1+2*ne(reward_order,0);
            c=choice_order;
        %     r = reward_order;
            Y = choice_order((H+1):end)';
            for i = (H+1):N
                X(i-H,1:H) = c(i-(1:H));
                X(i-H,(H+1):(2*H)) = r(i-(1:H));
                X(i-H,(2*H+1):(3*H)) = c(i-(1:H)).*r(i-(1:H));
                
            end

% REGRESSION WITHOUT CHOICE HISTORY ALONE. ONLY REWARD HISTORY AND
% CHOICE*REWARD
%               
%             n=N-H;  % num of obs
%             p=2*H; % num of parameters
%             X=zeros(n,p);
%             
%             r = -1+2*ne(reward_order,0);
%             c=choice_order;
%         %     r = reward_order;
%             Y = choice_order((H+1):end)';
%             
%             for i = (H+1):N-1
%                 X(i-H,1:H) = r(i-(1:H));
%                 X(i-H,H+1:(2*H)) = c(i-(1:H)).*r(i-(1:H));
%                 
%             end
            

            % Incorporate Training and Testing groups. model is fit using the
            % the training group which is further split into 10 to all for 10
            % fold cross-validation and regularization to avoid over-fitting.
                Xi = X;
                %Xi(i,:) = [];
                Yi = Y-1;
                %Yi(i) = [];
                i;
                c = cvpartition(Yi,'HoldOut',0.3);
                idxTrain = training(c,1);
                idxTest = ~idxTrain;
                XTrain = Xi(idxTrain,:);
                yTrain = Yi(idxTrain);
                XTest = Xi(idxTest,:);
                yTest = Yi(idxTest);
                [B,FitInfo] = lassoglm(XTrain,yTrain,'binomial','CV',10,'Alpha',0.1);
                idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
                B0 = FitInfo.Intercept(idxLambdaMinDeviance);
                wi = [B0; B(:,idxLambdaMinDeviance)];

                %store the regresseros for sd 

                % ADITHYA - 07.12.20:
                % wi_mat is 5 element char with each element corresponding to
                % different windows of trials (H_vec long). Each element contains
                % the weights ( regressors) of different predictors of present
                % choice. Three types of predictors are used above. past choice
                % (for the past H choices), past reward (for the past H choices)
                % and a product of past choices and past rewards (for the past H
                % choices). so each element will contain a n X 3*H long vector
                % (where n = N-H, where N is the number of choices made in the
                % session).

                wi_mat{(count),H}=wi;
                yhat = glmval(wi,XTest,'logit');
            % Test data Y is then compared with model prediction of test data Y
            % from Xs to measure accuracy of model
            for i = 1:length(yTest)


        %         hi = [X(i,:) 1]*wi;

                % hi is the predicted Y values based on the given Xs and calculated
                % wis
    %             hi = [1 X(i,:)]*wi;
    % 
                if eq(yTest(i),1)
                    prob_i = yhat(i);
                else
                    prob_i = 1 - yhat(i);
                end
    %             % Probability of model choosing action 2
    %             P2(H,i)=1/(1+exp(hi));
    % %             % probability of model choosing action chosen by fly
                Pc(H,i)=(prob_i);

            end

            LL(H) = sum(log(Pc(H,1:end - H+1)));
            LossLOU(H)=mean(Pc(H,1:end - H+1));
            toc;



        end
    
        LL_mat{count} = LL
        Pc_mat{count} = Pc;
        P2_mat{count} = yhat;
        LossLOU_mat{count} = LossLOU;
    
    end    
end    
