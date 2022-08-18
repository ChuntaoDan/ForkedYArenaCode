function [I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec,y_cont] = Loewenstein_Seung_v5_JEF(p1,p2)

% C1 = 0;
% C2 = 0;
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
% tS1 = []; 
% tS2 = [];
S_vec = [0,0]; % stimulus history
y = []; % choice history
y_cont = []; % history of choice variable before passing through non-linearity to determine the actual choice
R_vec = zeros(10,2); % reward history
W_vec = [W1,W2]; % weight history
% plasticity rate for cov LR
n = 0.2;
%plasticity rate for non-cov LR
%  n = 0.02;
currC = [];

for trialn = 1:2000 % The number of trials is hardcoded as 2000
    cS1 = round(rand(1,1)); % Randomly choose stimulus 1
    cS2 = 1 - cS1; % Randomly choose stimulus 2
    S_vec(length(S_vec(:,1))+1,:) = [cS1,cS2]; % Create an array of stimuli
    
    % Here the average reward is computed over the last 10 exposures.
    % the average reward is odor specific
    
% VERSION 0 OF CALCULATION
% Here the average reward is computed over the last 10 exposures without
% odor specificity
%     if eq(trialn,1)
%         R_ave = 0;
%     elseif (trialn < 11)
%         R_ave = mean(R_vec(1:trialn-1));
%     else
%         R_ave = mean(R_vec(trialn-10:trialn-1));
%     end
% 
%     eR1 = R_ave;
%     eR2 = R_ave;
    
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
    R_vec_sum = sum(R_vec,2);
    eR = mean(R_vec_sum(end-9:end));
    % Ensuring the eR is never a Nan in case the padding of rR1 or rR2 for the
    % calculation of eR on early trials is insufficient
    if isnan(eR1) == 1
        eR1 = 0;
    end    
    if isnan(eR2) == 1
        eR2 = 0;
    end  

    % reward for option 1
    if trialn > 1
        if aR1 == 1 % if aR = 1 this means the reward is availbe because of baiting so it stays as 1
            aR1 = 1; 
        elseif aR1 == 0 && y(trialn-1)== 1 % Indicates that there is no reward baiting, and the animal went forward last trial. To ensure that available reward is not recalculated after turning away from odor
            if rand(1,1) < p1 % determining whether to provide reward by comparing random number to predefined probability
                aR1 = 1;
            end
        end
    elseif trialn == 1
        if aR1 == 1
            aR1 = 1; 
        elseif aR1 == 0
            if rand(1,1) < p1 % Add a waiting reward with probability p1
                aR1 = 1;
            end
        end
    end    
        
    % reward for option 2 calculated in the same was as described above for
    % option 1
    if trialn > 1
        if aR2 == 1
            aR2 = 1;
        elseif aR2 == 0
            if rand(1,1) < p2 && y(trialn-1)== 1
                aR2 = 1;
            end
        end
    elseif trialn == 1
        if aR2 == 1
            aR2 = 1; 
        elseif aR2 == 0
            if rand(1,1) < p2
                aR2 = 1;
            end
        end
    end     
    
    % Calculating the activity of the output neurons. weight * input
    M1 = W1*cS1;
    M2 = W2*cS2;
    
    % COMMENT FROM JEF
    % When the animal goes forward, it has a chance of getting an 
    % available reward. If it turns, it always registers as not getting 
    % a reward. The better choice always seems to be "forward." Need some 
    % kind of a time-out?
    
    if cS1 == 1 % in situations where animal experiences option 1
        y_cont(trialn) = 1/(1+exp(4*(W1-W2))); % calculate choice determining variable via logisitc function
        if  rand(1,1) < 1/(1+exp(4*(W1-W2))) % determine the choice made by comparing y_cont to a random number
            
            y(length(y)+1) = 1; % Go forward
            C1_1000 = C1_1000+1; % update the number of times option 1 was chosen
            if aR1 == 1
                rR1(length(rR1)+ 1) = aR1; % update option 1 reward history
                R_vec(length(R_vec(:,1))+1,1) = aR1; %update reward history
                I1 = I1 + 1; % update the income associated with option 1
                aR1 = 0; % This is the only line that needs to be within an if statement
            else % here same as above but reward is not available
                rR1(length(rR1)+ 1) = aR1;
                R_vec(length(R_vec(:,1))+1,1) = aR1;
            end
        else
            
            y(length(y)+1) = 0; % Turn
            % When the animal turns, it always registers as not getting a
            % reward.
            rR1(length(rR1)+ 1) = 0; 
            R_vec(length(R_vec(:,1))+1,1) = 0;
        end  
    elseif cS1 == 0  % in situations where animal experiences option 2. Same as described for option 1 above
        y_cont(trialn) = 1/(1+exp(4*(W2-W1)));
        if rand(1,1) < 1/(1+exp(4*(W2-W1))) 
            y(length(y)+1) = 1;
            C2_1000 = C2_1000+1;
            if aR2 == 1
                rR2(length(rR2)+ 1) = aR2;
                R_vec(length(R_vec(:,1))+1,2) = aR2;
                I2 = I2 + 1;
                aR2 = 0;
            else
                rR2(length(rR2)+ 1) = aR2;
                R_vec(length(R_vec(:,1))+1,2) = aR2;
            end
        else
            y(length(y)+1) = 0;
            rR2(length(rR2)+ 1) = 0;
            R_vec(length(R_vec(:,1))+1,2) = 0;
        end 
    end
    
    
    
      

    
%     % update rule for cov LR
    if cS1 == 1
        dW1 = n * (rR1(end)-eR1) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
        W1 = W1 - transpose(dW1);
        % Why put a floor on the weights but not a ceiling. 
%         if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
%            W1 = 0;
%         end    
        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;
    elseif cS1 == 0
        dW2 = n * (rR2(end)-eR2) * (cS2);
        W2 = W2 - transpose(dW2);
%         if W2 < 0
%            W2 = 0;
%         end   
        W_vec(length(W_vec(:,1))+1,2) = W2;
        W_vec(length(W_vec(:,1)),1) = W1;
    end 

 %     % update rule for cov LR 2
%     if cS1 == 1
%         dW1 = n * (rR1(end)-eR) * (cS1); % This expected reward is stimulus specific, whereas the simulation is usually not
%         W1 = W1 - transpose(dW1);
%         % Why put a floor on the weights but not a ceiling. 
% %         if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
% %            W1 = 0;
% %         end    
%         W_vec(length(W_vec(:,1))+1,1) = W1;
%         W_vec(length(W_vec(:,1)),2) = W2;
%     elseif cS1 == 0
%         dW2 = n * (rR2(end)-eR) * (cS2);
%         W2 = W2 - transpose(dW2);
% %         if W2 < 0
% %            W2 = 0;
% %         end   
%         W_vec(length(W_vec(:,1))+1,2) = W2;
%         W_vec(length(W_vec(:,1)),1) = W1;
%     end 
%  
    
%     % update rule for non-cov LR
%     if cS1 == 1
%         dW1 = n * (rR1(end)) * (cS1);
%         W1 = W1 - transpose(dW1);
%         if W1 < 0
%             W1 = 0;
%         end    
%         W_vec(length(W_vec(:,1))+1,1) = W1;
%         W_vec(length(W_vec(:,1)),2) = W2;
%     elseif cS1 == 0
%         dW2 = n * (rR2(end)) * (cS2);
%         W2 = W2 - transpose(dW2);
%         if W2 < 0
%             W2 = 0;
%         end   
%         W_vec(length(W_vec(:,1))+1,2) = W2;
%         W_vec(length(W_vec(:,1)),1) = W1;
%     end     
%     keyboard
end 

end