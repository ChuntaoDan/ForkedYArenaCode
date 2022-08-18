function [I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec] = Loewenstein_Seung_v2(p1,p2)

C1 = 0;
C2 = 0;
C1_1000 = 0;
C2_1000 = 0;
I1 = 0;
I2 = 0;
W1 = 1;
W2 = 1;
aR1 = 0;
aR2 = 0;
rR1 = zeros(10,1);
rR2 = zeros(10,1);
tS1 = [];
tS2 = [];
S_vec = [0,0]
y = [];
R_vec = [];
W_vec = [W1,W2];
% plasticity rate for cov LR
% n = 0.2;
%plasticity rate for non-cov LR
n = 0.2;
currC = [];

for trialn = 1:2000
    cS1 = round(rand(1,1));
    cS2 = 1 - cS1;
    S_vec(length(S_vec(:,1))+1,:) = [cS1,cS2];
    
    eR1 = mean(rR1(end-9:end));
    eR2 = mean(rR2(end-9:end));
    
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
        elseif aR1 == 0 && y(trialn-1)== 1
            if rand(1,1) < p1
                aR1 = 1;
            end
        end
    elseif trialn == 1
        if aR1 == 1
            aR1 = 1; 
        elseif aR1 == 0
            if rand(1,1) < p1
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
    
    if cS1 == 1
        if  rand(1,1) > 1/(1+exp(4*(-M1+1)))
            y(length(y)+1) = 1;
            if aR1 == 1
                rR1(length(rR1)+ 1) = aR1;
                R_vec(length(R_vec)+1) = aR1;
                I1 = I1 + 1;
                aR1 = 0;
            else
                rR1(length(rR1)+ 1) = aR1;
                R_vec(length(R_vec)+1) = aR1;
            end
        else
            y(length(y)+1) = 0;
            rR1(length(rR1)+ 1) = 0;
            R_vec(length(R_vec)+1) = 0;
        end  
    elseif cS1 == 0  
        if rand(1,1) > 1/(1+exp(4*(-M2+1))) 
            y(length(y)+1) = 1;
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
    
    
    
      
          
    % update rule for cov LR 1
%     if currC == 1
%         dW1 = n .* [rR1(end)] .* [cS1-mean(tS1)];
%         W1 = W1 + transpose(dW1);
%     elseif currC == 2
%         dW2 = n .* [rR2(end)] .* [cS2-mean(tS2)];
%         W2 = W2 + transpose(dW2);
%     end  
    % update rule for cov LR 2
%     if currC == 1
%         dW1 = n .* [rR1(end)-eR1] .* [cS1];
%         W1 = W1 + transpose(dW1);
%     elseif currC == 2
%         dW2 = n .* [rR2(end)-eR2] .* [cS2];
%         W2 = W2 + transpose(dW2);
%     end  
    
%     % update rule for non-cov LR
    if cS1 == 1
        dW1 = n .* [rR1(end)-eR1] .* [cS1];
        W1 = W1 - transpose(dW1);
        if W1 < 0
            W1 = 0;
        end    
        W_vec(length(W_vec(:,1))+1,1) = W1;
        W_vec(length(W_vec(:,1)),2) = W2;
    elseif cS1 == 0
        dW2 = n .* [rR2(end)-eR2] .* [cS2];
        W2 = W2 - transpose(dW2);
        if W2 < 0
            W2 = 0;
        end   
        W_vec(length(W_vec(:,1))+1,2) = W2;
        W_vec(length(W_vec(:,1)),1) = W1;
    end 
    
%     keyboard
end 
end