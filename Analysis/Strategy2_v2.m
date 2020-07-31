function [nC1,nC2,nI1,nI2,I_list,C_list,v1,v2] = Strategy2_v2(nblocks,ntrials,pR1s,pR2s,window_trials)
% Strategy 2 : Choose the option with higher value. Value calculated as
% average reward recieved over window_trials
% 19.06.20
% Each sim will now produce a set of 'ntrials' trials per fly over
% 'nblocks' blocks. 'ntrials' is the number of trials per block.
% The p(reward) for options 1 and 2 need to be defined
% for each block. There pR1s is a vector of length 1,nblocks and similarly
% pR2s


nC1 = 0;
nC2 = 0;
nI1 = 0;
nI2 = 0;
cI1 = 0;
cI2 = 0;
I_list = [];
C_list = [];
v1 = [0];
v2 = [0];
v1_list = [-1];
v2_list = [-1];
exp_w_list = [];


for nb = 1:nblocks
    pR1 = pR1s(nb);
    pR2 = pR2s(nb);
    for nt = 1:ntrials
        if isnan(v1(((nb-1)*ntrials) + nt)) == 1
            v1(((nb-1)*ntrials) + nt) = 0;
        end
        if isnan(v2(((nb-1)*ntrials) + nt)) == 1
            v2(((nb-1)*ntrials) + nt) = 0;
        end
        
     if v1(((nb-1)*ntrials) + nt) == v2(((nb-1)*ntrials) + nt)
         if rand(1,1) <0.5
            nC1 = nC1 + 1;
            C_list(((nb-1)*ntrials) + nt) = 1;
            r1 = rand(1,1);
            r2 = rand(1,1);
            if cI1 == 1
                nI1 = nI1 + 1;
                I_list(((nb-1)*ntrials) + nt) = 1; 
            elseif cI1 == 0 && r1 < pR1
                nI1 = nI1 + 1;
                I_list(((nb-1)*ntrials) + nt) = 1;
            elseif cI1 == 0 && r1 >= pR1
                I_list(((nb-1)*ntrials) + nt) = 0;
            end
            if cI2 ==0 && r2 <pR2
                cI2 = 1;
            end
            cI1 = 0;
            if length(I_list) <= window_trials
%                     v1(nt+1) = mean(I1_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v1_list(valid_els));
            else
%                     v1(nt+1) = mean(I1_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                 if length(valid_els) < 3
                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v1_list(valid_els));
                else    

                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v1_list(valid_els(end-window_trials+1:end)));
                 end
            end
            
            if length(I_list) <= window_trials
%                     v2(nt+1) = mean(I2_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      
                v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v2_list(valid_els));
           
            else
%                     v2(nt+1) = mean(I2_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      

                if length(valid_els) < 3
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v2_list(valid_els));
                else    
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v2_list (valid_els(end-window_trials+1:end)));
                end
            end

         else
             nC2 = nC2 + 1;

             C_list(((nb-1)*ntrials) + nt) = 2;
             r1 = rand(1,1);
             r2 = rand(1,1);
             if cI2 == 1
                 nI2 = nI2 + 1;
                 I_list(((nb-1)*ntrials) + nt) = 2; 

             elseif cI2 == 0 && r2 < pR2
                 nI2 = nI2 + 1;
                 I_list(((nb-1)*ntrials) + nt) = 2;

             elseif cI2 == 0 && r2 >= pR2
                 I_list(((nb-1)*ntrials) + nt) = 0;

             end
             if cI1 ==0 && r1 <pR1
                 cI1 = 1;
             end
             cI2 = 0;
             if length(I_list) <= window_trials
%                     v1(nt+1) = mean(I1_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v1_list(valid_els));
            else
%                     v1(nt+1) = mean(I1_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                 if length(valid_els) < 3
                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v1_list(valid_els));
                else    

                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v1_list(valid_els(end-window_trials+1:end)));
                 end
            end
            
            if length(I_list) <= window_trials
%                     v2(nt+1) = mean(I2_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);  

                v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v2_list(valid_els));
           
            else
%                     v2(nt+1) = mean(I2_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      

                if length(valid_els) < 3
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v2_list(valid_els));
                else    
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v2_list (valid_els(end-window_trials+1:end)));
                end
            end
         end
     elseif v1(((nb-1)*ntrials) + nt) > v2(((nb-1)*ntrials) + nt)
        nC1 = nC1 + 1;
        C_list(((nb-1)*ntrials) + nt) = 1;
        r1 = rand(1,1);
        r2 = rand(1,1);
        if cI1 == 1
            nI1 = nI1 + 1;
            I_list(((nb-1)*ntrials) + nt) = 1; 
        elseif cI1 == 0 && r1 < pR1
            nI1 = nI1 + 1;
            I_list(((nb-1)*ntrials) + nt) = 1;
        elseif cI1 == 0 && r1 >= pR1
            I_list(((nb-1)*ntrials) + nt) = 0;
        end
        if cI2 ==0 && r2 <pR2
            cI2 = 1;
        end
        cI1 = 0;
        if length(I_list) <= window_trials
%                     v1(nt+1) = mean(I1_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v1_list(valid_els));
            else
%                     v1(nt+1) = mean(I1_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                 if length(valid_els) < 3
                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v1_list(valid_els));
                else    

                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v1_list(valid_els(end-window_trials+1:end)));
                 end
            end
            
            if length(I_list) <= window_trials
%                     v2(nt+1) = mean(I2_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      
                v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v2_list(valid_els));
           
            else
%                     v2(nt+1) = mean(I2_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      

                if length(valid_els) < 3
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v2_list(valid_els));
                else    
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v2_list (valid_els(end-window_trials+1:end)));
                end
            end
            
     elseif v2(((nb-1)*ntrials) + nt)>v1(((nb-1)*ntrials) + nt)
         nC2 = nC2 + 1;
             C_list(((nb-1)*ntrials) + nt) = 2;
             r1 = rand(1,1);
             r2 = rand(1,1);
             if cI2 == 1
                 nI2 = nI2 + 1;
                 I_list(((nb-1)*ntrials) + nt) = 2; 
             elseif cI2 == 0 && r2 < pR2
                 nI2 = nI2 + 1;
                 I_list(((nb-1)*ntrials) + nt) = 2;
             elseif cI2 == 0 && r2 >= pR2
                 I_list(((nb-1)*ntrials) + nt) = 0;
             end
             if cI1 ==0 && r1 <pR1
                 cI1 = 1;
             end
             cI2 = 0;
             if length(I_list) <= window_trials
%                     v1(nt+1) = mean(I1_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v1_list(valid_els));
            else
%                     v1(nt+1) = mean(I1_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 1
                        v1_list(ct) = 1;
                    elseif I_list(ct) == 2
                        v1_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 1
                            v1_list(ct) = 0;
                        else
                            v1_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v1_list ~= -1);      
                 if length(valid_els) < 3
                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v1_list(valid_els));
                else    

                    v1(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v1_list(valid_els(end-window_trials+1:end)));
                 end
            end
            
            if length(I_list) <= window_trials
%                     v2(nt+1) = mean(I2_v_list);
                for ct = 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:length(I_list)]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      
                v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(valid_els)).*v2_list(valid_els));
           
            else
%                     v2(nt+1) = mean(I2_v_list(end-window_trials : end));
                for ct = length(I_list) - window_trials + 1:length(I_list)
                    if I_list(ct) == 2
                        v2_list(ct) = 1;
                    elseif I_list(ct) == 1
                        v2_list(ct) = -1;
                    elseif I_list(ct) ==  0
                        if C_list(ct) == 2
                            v2_list(ct) = 0;
                        else
                            v2_list(ct) = -1;
                        end
                    end 
                end   
                exp_w_list = exp((window_trials - [1:window_trials]+1)/window_trials)./exp(1);     
                valid_els = find(v2_list ~= -1);      

                if length(valid_els) < 3
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list(1:length(valid_els))).*v2_list(valid_els));
                else    
                    v2(((nb-1)*ntrials) + nt+1) = mean(flip(exp_w_list).*v2_list (valid_els(end-window_trials+1:end)));
                end
            end
     end        

            
    end
end

end