function [nC1,nC2,nI1,nI2,I1_list,I2_list,C1_list,C2_list,v1,v2] = Strategy2(nblocks,ntrials,pR1s,pR2s,window_trials)
% Strategy 2 : Choose the option with higher value. Value calculated as
% average reward recieved over last n trials (based on window_trials) for
% each option
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
I1_list = [];
I2_list = [];
C1_list = [];
C2_list = [];
v1 = [0];
v2 = [0];
I1_v_list = [0];
I2_v_list = [0];

for nb = 1:nblocks
    pR1 = pR1s(nb);
    pR2 = pR2s(nb);
    for nt = 1:ntrials
     if v1(((nb-1)*ntrials) + nt) == v2(((nb-1)*ntrials) + nt)
         if rand(1,1) <0.5
            nC1 = nC1 + 1;
            C1_list(((nb-1)*ntrials) + nt) = 1;
            C2_list(((nb-1)*ntrials) + nt) = 0;
            I2_list(((nb-1)*ntrials) + nt) = 0;
            r1 = rand(1,1);
            r2 = rand(1,1);
            if cI1 == 1
                nI1 = nI1 + 1;
                I1_list(((nb-1)*ntrials) + nt) = 1; 
                I1_v_list(length(I1_v_list)+1) = 1;
            elseif cI1 == 0 && r1 < pR1
                nI1 = nI1 + 1;
                I1_list(((nb-1)*ntrials) + nt) = 1;
                I1_v_list(length(I1_v_list)+1) = 1;
            elseif cI1 == 0 && r1 >= pR1
                I1_list(((nb-1)*ntrials) + nt) = 0;
                I1_v_list(length(I1_v_list)+1) = 0;
            end
            if cI2 ==0 && r2 <pR2
                cI2 = 1;
            end
            cI1 = 0;
            if length(I1_v_list) <= window_trials
                v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list);
            else
                v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list(end-window_trials : end));
            end
            if length(I2_v_list) <= window_trials
                v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list);
            else
                v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list(end-window_trials : end));
            end
         else
             nC2 = nC2 + 1;
             C1_list(((nb-1)*ntrials) + nt) = 0;
             C2_list(((nb-1)*ntrials) + nt) = 1;
             I1_list(((nb-1)*ntrials) + nt) = 0;
             r1 = rand(1,1);
             r2 = rand(1,1);
             if cI2 == 1
                 nI2 = nI2 + 1;
                 I2_list(((nb-1)*ntrials) + nt) = 1; 
                 I2_v_list(length(I2_v_list)+1) = 1;
             elseif cI2 == 0 && r2 < pR2
                 nI2 = nI2 + 1;
                 I2_list(((nb-1)*ntrials) + nt) = 1;
                 I2_v_list(length(I2_v_list)+1) = 1;
             elseif cI2 == 0 && r2 >= pR2
                 I2_list(((nb-1)*ntrials) + nt) = 0;
                 I2_v_list(length(I2_v_list)+1) = 0;
             end
             if cI1 ==0 && r1 <pR1
                 cI1 = 1;
             end
             cI2 = 0;
             if length(I1_v_list) <= window_trials
                 v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list);
             else
                 v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list(end-window_trials : end));
             end
             if length(I2_v_list) <= window_trials
                 v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list);
             else
                 v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list(end-window_trials : end));
             end
         end
     elseif v1(((nb-1)*ntrials) + nt) > v2(((nb-1)*ntrials) + nt)
        nC1 = nC1 + 1;
        C1_list(((nb-1)*ntrials) + nt) = 1;
        C2_list(((nb-1)*ntrials) + nt) = 0;
        I2_list(((nb-1)*ntrials) + nt) = 0;
        r1 = rand(1,1);
        r2 = rand(1,1);
        if cI1 == 1
            nI1 = nI1 + 1;
            I1_list(((nb-1)*ntrials) + nt) = 1; 
            I1_v_list(length(I1_v_list)+1) = 1;
        elseif cI1 == 0 && r1 < pR1
            nI1 = nI1 + 1;
            I1_list(((nb-1)*ntrials) + nt) = 1;
            I1_v_list(length(I1_v_list)+1) = 1;
        elseif cI1 == 0 && r1 >= pR1
            I1_list(((nb-1)*ntrials) + nt) = 0;
            I1_v_list(length(I1_v_list)+1) = 0;
        end
        if cI2 ==0 && r2 <pR2
            cI2 = 1;
        end
        cI1 = 0;
        if length(I1_v_list) <= window_trials
            v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list);
        else
            v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list(end-window_trials : end));
        end
        if length(I2_v_list) <= window_trials
            v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list);
        else
            v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list(end-window_trials : end));
        end
     elseif v2(((nb-1)*ntrials) + nt)>v1(((nb-1)*ntrials) + nt)
         nC2 = nC2 + 1;
             C1_list(((nb-1)*ntrials) + nt) = 0;
             C2_list(((nb-1)*ntrials) + nt) = 1;
             I1_list(((nb-1)*ntrials) + nt) = 0;
             r1 = rand(1,1);
             r2 = rand(1,1);
             if cI2 == 1
                 nI2 = nI2 + 1;
                 I2_list(((nb-1)*ntrials) + nt) = 1; 
                 I2_v_list(length(I2_v_list)+1) = 1;
             elseif cI2 == 0 && r2 < pR2
                 nI2 = nI2 + 1;
                 I2_list(((nb-1)*ntrials) + nt) = 1;
                 I2_v_list(length(I2_v_list)+1) = 1;
             elseif cI2 == 0 && r2 >= pR2
                 I2_list(((nb-1)*ntrials) + nt) = 0;
                 I2_v_list(length(I2_v_list)+1) = 0;
             end
             if cI1 ==0 && r1 <pR1
                 cI1 = 1;
             end
             cI2 = 0;
             if length(I1_v_list) <= window_trials
                 v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list);
             else
                 v1(((nb-1)*ntrials) + nt+1) = mean(I1_v_list(end-window_trials : end));
             end
             if length(I2_v_list) <= window_trials
                 v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list);
             else
                 v2(((nb-1)*ntrials) + nt+1) = mean(I2_v_list(end-window_trials : end));
             end
     end        

            
    end
end

end