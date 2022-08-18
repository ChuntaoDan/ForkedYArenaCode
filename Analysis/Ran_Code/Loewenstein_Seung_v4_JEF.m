function [I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec,y_cont] = Loewenstein_Seung_v4_JEF(p1,p2)

C1 = 0;
C2 = 0;
C1_1000 = 0; % This is never updated
C2_1000 = 0; % This is never updated
I1 = 0;
I2 = 0;
W1 = 0;
W2 = 0;
aR1 = 0; % Accumulated reward for choice 1
aR2 = 0; % Accumulated reward for choice 2
rR1 = zeros(30,1);
rR2 = zeros(30,1);
tS1 = [];
tS2 = [];
S_vec = [0,0];
y = [];
R_vec = [];
W_vec = [W1,W2];
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
    % In the simulation, the average reward is odor specific and
    % computed over the last 30 exposures to that odor
    if eq(trialn,1)
        R_ave = 0;
    elseif (trialn < 11)
        R_ave = mean(R_vec(1:trialn-1));
    else
        R_ave = mean(R_vec(trialn-10:trialn-1));
    end
    %eR1 = mean(rR1(end-29:end)); % Expected reward from choice 1
    %eR2 = mean(rR2(end-29:end)); % Expected reward from choice 2
    eR1 = R_ave;
    eR2 = R_ave;
    
    % Why is this necessary? Where do the NaN's come from?
    if isnan(eR1) == 1
        eR1 = 0;
    end    
    if isnan(eR2) == 1
        eR2 = 0;
    end  
    
    % reward for option 1
    if trialn > 1
        if aR1 == 1
            aR1 = 1; 
        elseif aR1 == 0 && y(trialn-1)== 1 % Indicates that there is no reward waiting, and the animal went forward last trial
            if rand(1,1) < p1
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
        
    % reward for option 2
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

    M1 = W1*cS1;
    M2 = W2*cS2;
    
    % When the animal goes forward, it has a chance of getting an 
    % accumulated reward. If it turns, it always registers as not getting 
    % a reward. The better choice always seems to be "forward." Need some 
    % kind of a time-out?
    if cS1 == 1
        y_cont(trialn) = 1/(1+exp(-M1));
        if  rand(1,1) < 1/(1+exp(-M1))
            y(length(y)+1) = 1; % Go forward
            C1_1000 = C1_1000+1;
            if aR1 == 1
                rR1(length(rR1)+ 1) = aR1;
                R_vec(length(R_vec)+1) = aR1;
                I1 = I1 + 1; % Looks like this is tracking the income associated with option 1
                aR1 = 0; % This is the only line that needs to be within an if statement
            else
                rR1(length(rR1)+ 1) = aR1;
                R_vec(length(R_vec)+1) = aR1;
            end
        else
            y(length(y)+1) = 0; % Turn
            % When the animal turns, it always registers as not getting a
            % reward.
            rR1(length(rR1)+ 1) = 0; 
            R_vec(length(R_vec)+1) = 0;
        end  
    elseif cS1 == 0  
        y_cont(trialn) = 1/(1+exp(-M2));
        if rand(1,1) < 1/(1+exp(-M2)) 
            y(length(y)+1) = 1;
            C2_1000 = C2_1000+1;
            if aR2 == 1
                rR2(length(rR2)+ 1) = aR2;
                R_vec(length(R_vec)+1) = aR2;
                I2 = I2 + 1;
                aR2 = 0;
            else
                rR2(length(rR2)+ 1) = aR2;
                R_vec(length(R_vec)+1) = aR2;
            end
        else
            y(length(y)+1) = 0;
            rR2(length(rR2)+ 1) = 0;
            R_vec(length(R_vec)+1) = 0;
        end 
    end
    
    
    
      

    
%     % update rule for cov LR
    if cS1 == 1
        dW1 = n .* [rR1(end)-eR1] .* [cS1]; % This expected reward is stimulus specific, whereas the simulation is usually not
        W1 = W1 + transpose(dW1);
        % Why put a floor on the weights but not a ceiling. 
%         if W1 < 0 % This nonlinear puts a floor on the weights. This nonlinearity is not assumed in the fitting. 
%            W1 = 0;
%         end    
        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;
    elseif cS1 == 0
        dW2 = n .* [rR2(end)-eR2] .* [cS2];
        W2 = W2 + transpose(dW2);
%         if W2 < 0
%            W2 = 0;
%         end   
        W_vec(length(W_vec(:,1))+1,2) = W2;
        W_vec(length(W_vec(:,1)),1) = W1;
    end 

%     % update rule for non-cov LR
%     if cS1 == 1
%         dW1 = n .* [rR1(end)] .* [cS1];
%         W1 = W1 + transpose(dW1);
%         if W1 < 0
%             W1 = 0;
%         end    
%         W_vec(length(W_vec(:,1))+1,1) = W1;
%         W_vec(length(W_vec(:,1)),2) = W2;
%     elseif cS1 == 0
%         dW2 = n .* [rR2(end)] .* [cS2];
%         W2 = W2 + transpose(dW2);
%         if W2 < 0
%             W2 = 0;
%         end   
%         W_vec(length(W_vec(:,1))+1,2) = W2;
%         W_vec(length(W_vec(:,1)),1) = W1;
%     end     
%     keyboard
end 
end