function [odor_crossing] = odor_crossings_3odor(region_at_time,air_arm,right_left,timestamps,x_y_time_color,cps)
    
    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_P_Color = 0.6*color_vec(1,:);
    O_AirWall_Color = 0.5*color_vec(1,:);
    P_A_Color = color_vec(3,:);
    P_O_Color = 0.6*color_vec(3,:);
    P_AirWall_Color = 0.5*color_vec(3,:);
    M_A_Color = color_vec(7,:);
    M_P_Color = 0.7*color_vec(7,:);
    M_AirWall_Color = 0.5*color_vec(7,:);
    P_M_Color = 0.6*color_vec(3,:);

    odor_crossing = struct('time',[],'type','','time_pt_in_vector',[]);
    count = 0;
    ct_right_left = 0;
    colors = x_y_time_color.color;
    for i = 2:length(region_at_time)
        if region_at_time(i) ~= 0 && region_at_time(i-1) ~= 0
            ct_right_left = ct_right_left + 1;
            if region_at_time(i) == 1 ||region_at_time(i) == 4||region_at_time(i) == 7
                current_arm = 1;
            elseif region_at_time(i) == 2 ||region_at_time(i) == 5||region_at_time(i) == 8
                current_arm = 2;    
            elseif region_at_time(i) == 3 ||region_at_time(i) == 6||region_at_time(i) == 9
                current_arm = 3;    
            end
            
            if region_at_time(i-1) == 1 ||region_at_time(i-1) == 4||region_at_time(i-1) == 7
                past_arm = 1;
            elseif region_at_time(i-1) == 2 ||region_at_time(i-1) == 5||region_at_time(i-1) == 8
                past_arm = 2;    
            elseif region_at_time(i-1) == 3 ||region_at_time(i-1) == 6||region_at_time(i-1) == 9
                past_arm = 3;    
            end

            if sum(colors(i,:) == colors(i-1,:)) ~= 3 && ismember(i,cps) == 0
                count = count+1;
                trial_n = find(i<cps,1)-1;
                odor_crossing(count).time = sum(timestamps(1,1:i));
                odor_crossing(count).time_pt_in_vector = i;
                
                if sum(x_y_time_color.color(i) == O_AirWall_Color) == 1
                    if sum(x_y_time_color.color(i-1) == O_A_Color) == 1 || sum(x_y_time_color.color(i-1) == O_P_Color) == 1
                        odor_crossing(count).type = 'OtoA_OW';
                    elseif sum(x_y_time_color.color(i-1) == P_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_PWtoA_OW';
                    elseif sum(x_y_time_color.color(i-1) == P_A_Color) == 1 || sum(x_y_time_color.color(i-1) == P_O_Color) == 1 
                        odor_crossing(count).type = 'PtoA_OW';
                    end
                elseif sum(x_y_time_color.color(i) == M_AirWall_Color) == 1    
                    if sum(x_y_time_color.color(i-1) == M_A_Color) == 1 || sum(x_y_time_color.color(i-1) == M_P_Color) == 1
                         odor_crossing(count).type = 'MtoA_MW';
                    elseif sum(x_y_time_color.color(i-1) == P_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_PWtoA_MW';
                    elseif sum(x_y_time_color.color(i-1) == P_A_Color) == 1 || sum(x_y_time_color.color(i-1) == P_M_Color) == 1 
                        odor_crossing(count).type = 'PtoA_MW';
                    end
                elseif sum(x_y_time_color.color(i) == P_AirWall_Color) == 1    
                    if sum(x_y_time_color.color(i-1) == M_A_Color) == 1 || sum(x_y_time_color.color(i-1) == M_P_Color) == 1
                         odor_crossing(count).type = 'MtoA_PW';
                    elseif  sum(x_y_time_color.color(i-1) == O_A_Color) == 1 || sum(x_y_time_color.color(i-1) == O_P_Color) == 1
                         odor_crossing(count).type = 'OtoA_PW';    
                    elseif sum(x_y_time_color.color(i-1) == M_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_MWtoA_PW';
                    elseif sum(x_y_time_color.color(i-1) == O_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_OWtoA_PW';    
                    elseif sum(x_y_time_color.color(i-1) == P_A_Color) == 1 || sum(x_y_time_color.color(i-1) == P_M_Color) == 1 
                        if mod(trial_n,2) == 1
                            odor_crossing(count).type = 'PtoA_PW_O';
                        else
                            odor_crossing(count).type = 'PtoA_PW_M';
                        end
                    end    
                elseif sum(x_y_time_color.color(i) == O_A_Color) == 1 || sum(x_y_time_color.color(i) == O_P_Color) == 1    
                    if sum(x_y_time_color.color(i-1) == O_AirWall_Color) == 1  
                        odor_crossing(count).type = 'A_OWtoO';
                    elseif sum(x_y_time_color.color(i-1) == P_AirWall_Color) == 1
                        odor_crossing(count).type = 'A_PWtoO';
                    elseif sum(x_y_time_color.color(i-1) == P_A_Color) == 1 || sum(x_y_time_color.color(i-1) == P_M_Color) == 1 || sum(x_y_time_color.color(i-1) == P_O_Color) == 1 
                          odor_crossing(count).type = 'PtoO';
                    end
                elseif sum(x_y_time_color.color(i) == M_A_Color) == 1 || sum(x_y_time_color.color(i) == M_P_Color) == 1    
                    if sum(x_y_time_color.color(i-1) == M_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_MWtoM';
                    elseif sum(x_y_time_color.color(i-1) == P_AirWall_Color) == 1
                        odor_crossing(count).type = 'A_PWtoM';
                    elseif sum(x_y_time_color.color(i-1) == P_A_Color) ==1 || sum(x_y_time_color.color(i-1) == P_M_Color) == 1 
                          odor_crossing(count).type = 'PtoM';
                    end   
                elseif sum(x_y_time_color.color(i) == P_A_Color) == 1 || sum(x_y_time_color.color(i) == P_O_Color) == 1 || sum(x_y_time_color.color(i) == P_M_Color) == 1    
                    if sum(x_y_time_color.color(i-1) == O_AirWall_Color) == 1  
                        odor_crossing(count).type = 'A_OWtoP';
                    elseif sum(x_y_time_color.color(i-1) == P_AirWall_Color) == 1 
                        if mod(trial_n,2) == 1
                            odor_crossing(count).type = 'A_PWtoP_O';
                        else
                            odor_crossing(count).type = 'A_PWtoP_M';
                        end    
                    elseif sum(x_y_time_color.color(i-1) == M_AirWall_Color) == 1 
                        odor_crossing(count).type = 'A_MWtoP';
                    elseif sum(x_y_time_color.color(i-1) == M_A_Color) == 1 || sum(x_y_time_color.color(i-1) == M_P_Color) == 1
                         odor_crossing(count).type = 'MtoP';
                    elseif sum(x_y_time_color.color(i-1) == O_P_Color) == 1 || sum(x_y_time_color.color(i-1) == O_A_Color ) == 1
                          odor_crossing(count).type = 'OtoP';
                    end    
                end 
            end    
        end  
    end    
end