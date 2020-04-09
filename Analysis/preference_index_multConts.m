% function to calculate the prefernce for a given odor by individual flies
% in terms of choices made.

function [PI,cps] = preference_index_multConts(air_arm,right_left,x_y_time_color)

    
    color_vec = cbrewer('qual','Dark2',10,'cubic')
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);
    
    choices = [0,0];
    cps = find(air_arm==0);
    cps(length(cps)+1) = length(air_arm);
    if air_arm(end) == 0
        cps = cps(2:end-1);
    end    
    for i = cps(2:end)
        home_arm = air_arm(i-1);
        if i == length(air_arm)
            no_match = 1
            jj = 0
            while no_match == 1
               
                if sum(x_y_time_color.color(i-jj,:) == M_A_Color )==3 ||sum(x_y_time_color.color(i-jj,:) == M_O_Color )==3
                    choices(1) = choices(1) + 1;
                    no_match = 0;
                else
                    choices(2) = choices(2) + 1;
                    no_match = 0;
                end 
                jj = jj+1
            end    
        else    
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
    end
    
    PI = choices(1)/(choices(1)+choices(2));
end