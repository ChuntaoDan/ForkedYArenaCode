clc
clear
close all
count = 0
% Select spreadsheet containing experiment names
cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    wi_mat = {};
    Pc_mat = {};
    P2_mat = {};
    LossLOU_mat = {};
    
    for cond_n = 1:length(conds)-2
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            count = count+1;
            continue
        end


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
        
        zero_locs = find(choice_order == 0)
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];

        % n0=length(cps_pre);
        n0=1;

        H_vec=1:20;
        N = length(choice_order);
        lenH=length(H_vec);
        indH=0;
        LossLOU=zeros(lenH,1);
        Pc = NaN(length(H_vec),N-1);
        P2 = NaN(length(H_vec),N-1);
        for H=H_vec
            tic;
            indH=indH+1
            % H=1;


            n=N-H;  % num of obs
            p=3*H; % num of parameters
            X=zeros(n,p);

        %     c = -1+2*eq(choice_order,2);
            r = -1+2*ne(reward_order,0);
            c=choice_order;
        %     r = reward_order;
            Y = choice_order((H+1):end)';
            for i = (H+1):N;
                X(i-H,1:H) = c(i-(1:H));
                X(i-H,(H+1):(2*H)) = r(i-(1:H));
                X(i-H,(2*H+1):(3*H)) = c(i-(1:H)).*r(i-(1:H));
            end;
            % Leave one out
            for i = 1:n;
%                 i
                Xi = X;
                %Xi(i,:) = [];
                Yi = Y;
                %Yi(i) = [];
                i;
                wi = mnrfit(Xi,Yi);
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

                wi_mat{cond_n,H}(:,i)=wi;

        %         hi = [X(i,:) 1]*wi;

                % hi is the predicted Y values based on the given Xs and calculated
                % wis
                hi = [1 X(i,:)]*wi;

                if eq(Y(i),1);
                    prob_i = exp(hi)/(1+exp(hi));
                else
                    prob_i = 1/(1+exp(hi));
                end;
                % Probability of model choosing action 2
                P2(H,i)=1/(1+exp(hi));
                % probability of model choosing action chosen by fly
                Pc(H,i)=(prob_i);
            end;
%             figure(11)
%             subplot (5,4,H)
%             plot(Pc(H,:),'g')
%             hold on
%             plot(P2(H,:),'k')
%             plot(Y-1,'or')


            LossLOU(indH)=mean(Pc(H,1:end - H+1));
            toc;
            Pc_mat{cond_n-2} = Pc;
            P2_mat{cond_n-2} = P2;
            LossLOU_mat{cond_n-2} = LossLOU;
        


        end
        

        
%         H=20
%         figure
%         plot(H_vec,LossLOU) %plot LOU loss
%          % plot regressors for H=lenH
%         figure;
%         subplot 311
%         plot(wi_mat{H}(2:H+1,:),'b')
%         hold on
%         plot(mean(wi_mat{H}(2:H+1,:),2),'r')
%         subplot 312
%         plot(wi_mat{H}(H+2:2*H+1,:),'b')
%         hold on
%         plot(mean(wi_mat{H}(H+2:2*H+1,:),2),'r')
%         subplot 313
%         plot(wi_mat{H}(2*H+2:3*H+1,:),'b')
%         hold on
%         plot(mean(wi_mat{H}(2*H+2:3*H+1,:),2),'r')
    end   
end    