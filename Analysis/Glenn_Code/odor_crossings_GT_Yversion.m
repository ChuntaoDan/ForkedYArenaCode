function [odor_crossing] = odor_crossings_GT_Yversion(CurrentArmMat,AirArmMat,ArmRandomizerMat,TimeSecsMat)
    odor_crossing = struct('time',[],'type','','time_pt_in_vector',[],'conts',[]);
    count = 0;
    Cpt_count = 1;
        
    for i = 2:length(CurrentArmMat)
        if AirArmMat(i) == 0 
            Cpt_count = Cpt_count+1;
        end 
        
        if Cpt_count <= 40
            conts = 1;
        elseif Cpt_count > 40 && Cpt_count <= 80
            conts = 2;
        elseif Cpt_count > 80 && Cpt_count <= 120
            conts = 3;
        else
            conts = 4;
        end
        
        if CurrentArmMat(i) ~= 0 && CurrentArmMat(i-1) ~= 0
            if CurrentArmMat(i) == 1 
                current_arm = 1;
            elseif CurrentArmMat(i) == 2 
                current_arm = 2;    
            elseif CurrentArmMat(i) == 3 
                current_arm = 3;    
            end
            
            if CurrentArmMat(i-1) == 1 
                past_arm = 1;
            elseif CurrentArmMat(i-1) == 2 
                past_arm = 2;    
            elseif CurrentArmMat(i-1) == 3 
                past_arm = 3;    
            end
            
            if current_arm ~= past_arm

                count = count+1;
                odor_crossing(count).time = TimeSecsMat(i);
                odor_crossing(count).time_pt_in_vector = i;
                odor_crossing(count).conts = conts;
                
                if CurrentArmMat(i) == AirArmMat(i)
                    if AirArmMat(i) == 1
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 3;
                            M_arm = 2;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 2;
                            M_arm = 3;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end
                    elseif AirArmMat(i) == 2
                        if  ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 1;
                            M_arm = 3;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 3;
                            M_arm = 1;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end
                    elseif AirArmMat(i) == 3
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 2;
                            M_arm = 1;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 1;
                            M_arm = 2;
                            
                            if CurrentArmMat(i-1) == O_arm
                                odor_crossing(count).type = {'OtoA'};
                            elseif CurrentArmMat(i-1)== M_arm
                                odor_crossing(count).type = {'MtoA'};
                            end
                        end  
                    end
                elseif CurrentArmMat(i-1) == AirArmMat(i)
                    if AirArmMat(i) == 1
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 3;
                            M_arm = 2;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 2;
                            M_arm = 3;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end
                    elseif AirArmMat(i) == 2
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 1;
                            M_arm = 3;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 3;
                            M_arm = 1;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end
                    elseif AirArmMat(i) == 3
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 2;
                            M_arm = 1;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 1;
                            M_arm = 2;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'AtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'AtoM'};
                            end
                        end  
                    end  
                elseif CurrentArmMat(i) ~= AirArmMat(i) && CurrentArmMat(i-1) ~= AirArmMat(i)
                    if AirArmMat(i) == 1
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 3;
                            M_arm = 2;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 2;
                            M_arm = 3;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end
                    elseif AirArmMat(i) == 2
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 1;
                            M_arm = 3;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 3;
                            M_arm = 1;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end
                    elseif AirArmMat(i) == 3
                        if ArmRandomizerMat(Cpt_count) == 0
                            O_arm = 2;
                            M_arm = 1;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                            
                        elseif ArmRandomizerMat(Cpt_count) == 1
                            O_arm = 1;
                            M_arm = 2;
                            
                            if CurrentArmMat(i) == O_arm
                                odor_crossing(count).type = {'MtoO'};
                            elseif CurrentArmMat(i)== M_arm
                                odor_crossing(count).type = {'OtoM'};
                            end
                        end  
                    end  
                end
                
            end
        end  
    end    
end