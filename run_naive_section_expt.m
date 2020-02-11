function [n_trials] = run_naive_section_expt(n_trials,dataPath)
    while n_trials  < 41
        tic
        [xy,count,snapshot,ave_background, more_count, less_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count);  
        xy_now = round(xy(:,end));
        if sum(xy_now == [-1,-1]) == 2
            if vidobj2.FramesAcquired > 100000
                delete(vidobj2);
                clear('vidobj2');
            end
            s = toc;
            timestamps(length(timestamps)+1) = s;
            statestamps(length(statestamps)+1) = od_state;
            time = time + s;
            continue
        end  
        reward(length(reward)+1) = 0;
        if od_state == 0
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)
            if PresentZone == 7 || PresentZone == 4  || PresentZone == 1 %(fly isin arm 0)
                od_state = 1
                if rand(1) >0.5
                    ch_state = 1
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio2); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % OCT

                else
                    ch_state = 2
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio2); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio3); % MCH

                end
            elseif PresentZone == 8 || PresentZone == 5  || PresentZone == 2 %(fly isin arm 1)
                od_state = 2
                if rand(1) >0.5
                    ch_state = 2
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio1); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % OCT

                else
                    ch_state = 1
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio1); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio3); % MCH
 
                end    
            elseif PresentZone == 9 || PresentZone == 6  || PresentZone == 3 %(fly isin arm 2)
                od_state = 3
                if rand(1) >0.5
                    ch_state = 1
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio1); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio2); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % AIR

                else
                    ch_state = 2
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio1); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio2); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % AIR

                end  
            end    
        elseif od_state == 1
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            if PresentZone ~= find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)

                PastZone = PresentZone;
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);

    %             if PresentZone == 6 && PastZone == 3
    %                 if ch_state == 1
    %                     servos.expose(2) 
    %                 end
    %             elseif PresentZone == 5 && PastZone == 2
    %                 if ch_state == 2
    %                     servos.expose(1) 
    %                 end  
                if PresentZone == 9 && PastZone == 6

                        od_state = 0
                        n_trials = n_trials + 1

                elseif PresentZone == 8 && PastZone == 5

                        od_state = 0
                        n_trials = n_trials + 1;
 
                end

            end
        elseif od_state == 2
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            if PresentZone ~= find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)

                PastZone = PresentZone;
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
    %             if PresentZone == 6 && PastZone == 3
    %                 if ch_state == 2
    %                     servos.expose(2) 
    %                 end
    %             elseif PresentZone == 4 && PastZone == 1
    %                 if ch_state == 1
    %                     servos.expose(0) 
    %                 end  
                if PresentZone == 9 && PastZone == 6

                    od_state = 0
                    n_trials = n_trials + 1;
                elseif PresentZone == 7 && PastZone == 4

                    od_state = 0
                    n_trials = n_trials + 1;
                end

            end 
        elseif od_state == 3
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            if PresentZone ~= find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)
                PastZone = PresentZone;
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
    %             if PresentZone == 5 && PastZone == 2
    %                 if ch_state == 1
    %                     servos.expose(1) 
    %                 end
    %             elseif PresentZone == 4 && PastZone == 1
    %                 if ch_state == 2
    %                     servos.expose(0) 
    %                 end  
                if PresentZone == 8 && PastZone == 5

                    od_state = 0
                    n_trials = n_trials + 1;

                elseif PresentZone == 7 && PastZone == 4

                    od_state = 0
                    n_trials = n_trials + 1;
                end

            end  
        end
        if vidobj2.FramesAcquired > 100000
            delete(vidobj2);
            clear('vidobj2');
        end
        s = toc;
        timestamps(length(timestamps)+1) = s;
        statestamps(length(statestamps)+1) = od_state;
        time = time + s;
    end
    matfilename = strcat(dataPath, '\all_variables_contingency_naive.mat');
    save(matfilename)
end    