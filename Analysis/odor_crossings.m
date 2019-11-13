function [odor_crossing] = odor_crossings(region_at_time,air_arm,right_left,timestamps)
    odor_crossing = struct('time',[],'type','','time_pt_in_vector',[]);
    count = 0;
    ct_right_left = 0;
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
            
            if current_arm ~= past_arm
                count = count+1;
                odor_crossing(count).time = sum(timestamps(1,1:i));
                odor_crossing(count).time_pt_in_vector = i;
                
                if region_at_time(i) == air_arm(ct_right_left)
                    if air_arm(ct_right_left) == 1
                        if right_left(ct_right_left) == 1
                            O_arm = 3;
                            M_arm = 2;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = 'OtoA';
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 2;
                            M_arm = 3;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 2
                        if right_left(ct_right_left) == 1
                            O_arm = 1;
                            M_arm = 3;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 3;
                            M_arm = 1;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 3
                        if right_left(ct_right_left) == 1
                            O_arm = 2;
                            M_arm = 1;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 1;
                            M_arm = 2;
                            
                            if region_at_time(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif region_at_time(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end  
                    end
                elseif region_at_time(i-1) == air_arm(ct_right_left)
                    if air_arm(ct_right_left) == 1
                        if right_left(ct_right_left) == 1
                            O_arm = 3;
                            M_arm = 2;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        elseif right_left(ct_right_left) == 2
                            O_arm = 2;
                            M_arm = 3;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 2
                        if right_left(ct_right_left) == 1
                            O_arm = 1;
                            M_arm = 3;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 3;
                            M_arm = 1;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 3
                        if right_left(ct_right_left) == 1
                            O_arm = 2;
                            M_arm = 1;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 1;
                            M_arm = 2;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end  
                    end  
                elseif region_at_time(i) ~= air_arm(i) && region_at_time(i-1) ~= air_arm(i)
                    if air_arm(ct_right_left) == 1
                        if right_left(ct_right_left) == 1
                            O_arm = 3;
                            M_arm = 2;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        elseif right_left(ct_right_left) == 2
                            O_arm = 2;
                            M_arm = 3;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 2
                        if right_left(ct_right_left) == 1
                            O_arm = 1;
                            M_arm = 3;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 3;
                            M_arm = 1;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end
                    elseif air_arm(ct_right_left) == 3
                        if right_left(ct_right_left) == 1
                            O_arm = 2;
                            M_arm = 1;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                            
                        elseif right_left(ct_right_left) == 2
                            O_arm = 1;
                            M_arm = 2;
                            
                            if region_at_time(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif region_at_time(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end  
                    end  
                end
                
            end
        end  
    end    
end