% function to calculate the prefernce for a given odor by individual flies
% in terms of choices made.

function [PI,cps] = preference_index(air_arm,right_left)
    choices = [0,0];
    cps = find(air_arm==0);
    
    if air_arm(end) == 0
        cps = cps(1:end-1);
    end    
    for i = cps(2:end)
        home_arm = air_arm(i-1);
        chosen_arm = air_arm(i+1);
        if home_arm == 1
            if right_left(i-1) == 1
                if chosen_arm == 2
                    choices(1) = choices(1) + 1;
                elseif chosen_arm == 3
                    choices(2) = choices(2) + 1;
                end
            elseif right_left(i-1) == 2
                if chosen_arm == 2
                    choices(2) = choices(2) + 1;
                elseif chosen_arm == 3
                    choices(1) = choices(1) + 1;
                end
            end
        elseif home_arm == 2
            if right_left(i-1) == 1
                if chosen_arm == 1
                    choices(2) = choices(2) + 1;
                elseif chosen_arm == 3
                    choices(1) = choices(1) + 1;
                end
            elseif right_left(i-1) == 2
                if chosen_arm == 1
                    choices(1) = choices(1) + 1;
                elseif chosen_arm == 3
                    choices(2) = choices(2) + 1;
                end
            end
        elseif home_arm == 3
            if right_left(i-1) == 1
                if chosen_arm == 1
                    choices(1) = choices(1) + 1;
                elseif chosen_arm == 2
                    choices(2) = choices(2) + 1;
                end
            elseif right_left(i-1) == 2
                if chosen_arm == 1
                    choices(2) = choices(2) + 1;
                elseif chosen_arm == 2
                    choices(1) = choices(1) + 1;
                end
            end
        end
    end
    
    PI = choices(1)/(choices(1)+choices(2));
end