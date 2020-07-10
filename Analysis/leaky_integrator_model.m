function [for_efficiancy] = leaky_integrator_model(num_trials,x,tau,figures_on)

% INPUTS : 
% num_trials - the number of trials (of choices) the model experiences
% x - the reward associated with option 1 for the second reward
% contingency. First reward contingency is by default 50-50
% tau - the time constant of the leaky integrator model
%
% OUTPUTS : 
% for_efficiancy - the percentage of times that the agent gets the reward


for_efficiancy = 0;
choices = [];
rewards = [];
summed_choices1 = [0];
summed_choices2 = [0];
summed_i_1 = [];
summed_i_2 = [];
o1_history = [1]; % 1 - rewarded choice, 0 - unrewarded choice
o2_history = [1];


cont_switches = [1:100:num_trials];
num_conts = length(cont_switches);


for i = 1:num_conts
    
    if i~=1 && mod(i,4) == 2
        p_r1 = x;
        p_r2 = 1-x;
    elseif i~=1 && mod(i,4) == 3
        p_r1 = 1-x;
        p_r2 = x;
    elseif i~=1 && mod(i,4) == 0 
        p_r1 = x - 0.2;
        p_r2 = 1.2-x;
    elseif i~=1 && mod(i,4) == 1
        p_r1 = 1.2-x;
        p_r2 = x-0.2;
    elseif i == 1
        p_r1 = 0.5;
        p_r2 = 0.5;
    end
    if i ~= num_conts
        for j = cont_switches(i):cont_switches(i)+99
            t1 = (length(o1_history)+1) - [1:length(o1_history)];
            t2 = (length(o2_history)+1) - [1:length(o2_history)];
            i_1 = ([exp(-t1/tau)]./(exp(-1/tau))).*o1_history;
            i_2 = ([exp(-t2/tau)]./(exp(-1/tau))).*o2_history;
            p_1 = sum(i_1)/(sum(i_1) + sum(i_2));
            choice = rand(1);
            if choice < p_1 % choose 1
                reward1 = rand(1);
                if reward1 < p_r1 % rewarded
                    o1_history(length(o1_history)+1) = 1;
                    choices(length(choices) +1) = 1;
                    rewards(length(rewards) +1) = 1;
                    summed_choices1(j+1) = summed_choices1(j) + 1;
                    summed_choices2(j+1) = summed_choices2(j);
                    reward2 = rand(1);
%                     if reward2 < p_r2
%                         rewards(length(rewards)) = 2;
%                     else
%                         rewards(length(rewards)) = 1;
%                     end  
                else % not rewarded
                    o1_history(length(o1_history)+1) = 0;
                    choices(length(choices) +1) = 1;
                    reward2 = rand(1);
                    if reward2 < p_r2
                        rewards(length(rewards)+1 ) = 1;
                    else
                        rewards(length(rewards)+1 ) = 0;
                    end    
                    summed_choices1(j+1) = summed_choices1(j) + 1;
                    summed_choices2(j+1) = summed_choices2(j);
                end
            else    % choose 2
                reward2 = rand(1);
                if reward2 < p_r2 % rewarded
                    o2_history(length(o2_history)+1) = 1;
                    choices(length(choices) +1) = 2;
                    rewards(length(rewards) +1) = 1;
                    summed_choices1(j+1) = summed_choices1(j);
                    summed_choices2(j+1) = summed_choices2(j)+1;
                    reward1 = rand(1);
%                     if reward1 < p_r1
%                         rewards(length(rewards)) = 2;
%                     else
%                         rewards(length(rewards)) = 1;
%                     end  
                else % not rewarded
                    o2_history(length(o2_history)+1) = 0;
                    choices(length(choices) +1) = 2;
                    reward1 = rand(1);
                    if reward1 < p_r1
                        rewards(length(rewards) +1) = 1;
                    else
                        rewards(length(rewards) +1) = 0;
                    end    
                    summed_choices1(j+1) = summed_choices1(j);
                    summed_choices2(j+1) = summed_choices2(j)+1;
                end
            end    

        end
    else
        for j = cont_switches(i):num_trials
            t1 = (length(o1_history)+1) - [1:length(o1_history)];
            t2 = (length(o2_history)+1) - [1:length(o2_history)];
            i_1 = [exp(-t1/tau)].*o1_history;
            i_2 = [exp(-t2/tau)].*o2_history;
            p_1 = sum(i_1)/(sum(i_1) + sum(i_2));
            choice = rand(1);
            if choice < p_1 % choose 1
                reward = rand(1);
                if reward < p_r1 % rewarded
                    o1_history(length(o1_history)+1) = 1;
                    choices(length(choices) +1) = 1;
                    rewards(length(rewards) +1) = 1;
                    summed_choices1(j+1) = summed_choices1(j) + 1;
                    summed_choices2(j+1) = summed_choices2(j);
                    reward2 = rand(1);
%                     if reward2 < p_r2
%                         rewards(length(rewards)) = 2;
%                     else
%                         rewards(length(rewards)) = 1;
%                     end  
                else % not rewarded
                    o1_history(length(o1_history)+1) = 0;
                    choices(length(choices) +1) = 1;
                    reward2 = rand(1);
                    if reward2 < p_r1
                        rewards(length(rewards) +1) = 1;
                    else
                        rewards(length(rewards) +1) = 0;
                    end
                    summed_choices1(j+1) = summed_choices1(j) + 1;
                    summed_choices2(j+1) = summed_choices2(j);
                end
            else    % choose 2
                reward = rand(1);
                if reward < p_r2 % rewarded
                    o2_history(length(o2_history)+1) = 1;
                    choices(length(choices) +1) = 2;
                    rewards(length(rewards) +1) = 1;
                    summed_choices1(j+1) = summed_choices1(j);
                    summed_choices2(j+1) = summed_choices2(j)+1;
                    reward1 = rand(1);
%                     if reward1 < p_r1
%                         rewards(length(rewards)) = 2;
%                     else
%                         rewards(length(rewards)) = 1;
%                     end  
                else % not rewarded
                    o2_history(length(o2_history)+1) = 0;
                    choices(length(choices) +1) = 2;
                    reward1 = rand(1);
                    if reward1 < p_r1
                        rewards(length(rewards) +1) = 1;
                    else
                        rewards(length(rewards) +1) = 0;
                    end
                    summed_choices1(j+1) = summed_choices1(j);
                    summed_choices2(j+1) = summed_choices2(j)+1;
                end
            end    

        end
    end   
        
end

for_efficiancy = sum([sum(o1_history),sum(o2_history)])/sum(rewards);

if figures_on == 1
    plot(summed_choices1,summed_choices2)
    hold on
    y1 = find ((summed_choices1+summed_choices2)==101)
    scatter(summed_choices1(y1),summed_choices2(y1),160,'c','filled','MarkerFaceColor','r','MarkerEdgeColor','r')

    y2 = find ((summed_choices1+summed_choices2)==201)
    scatter(summed_choices1(y2),summed_choices2(y2),160,'c','filled','MarkerFaceColor','r','MarkerEdgeColor','r')

    y3 = find ((summed_choices1+summed_choices2)==301)
    scatter(summed_choices1(y3),summed_choices2(y3),160,'c','filled','MarkerFaceColor','r','MarkerEdgeColor','r')

    y4= find ((summed_choices1+summed_choices2)==401)
    scatter(summed_choices1(y4),summed_choices2(y4),160,'c','filled','MarkerFaceColor','r','MarkerEdgeColor','r')

end
   
end

