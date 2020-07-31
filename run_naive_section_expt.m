function [n_trials,time,vidobj2] = run_naive_section_expt(n_trials,dataPath,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
% Defining variables

snapshot = zeros(1024,1280);
xy = [];
air_arm = [];
right_left = [];
count = 0;
more_count = 0;
less_count = 0;
delete_vidobj_count = 0;

time = 0;
timestamps = [];
statestamps = [];

if exist('vidobj2') == 0
    vidobj2 = videoinput('pointgrey',2);
    triggerconfig(vidobj2, 'manual');
    vidobj2.FramesPerTrigger = inf; 
    start(vidobj2);
    trigger(vidobj2) 
end

FoodPortStatus = 0; % 0 implies all food ports are closed. 1 implies atleast one is open
PreviousZone = 0;   % previous zone fly was located in
PresentZone = 0;    % present zone fly is located in
od_state = 0;        % defines odorized state; 0 - first trial or just after feeding has taken place actual odorized state could be 1, 2 or 3
                    % 1 - arm 0 has clean air
                    % 2 - arm 1 has clean air
                    % 3 - arm 2 has clean air
ch_state = 1;       % 1 - Right is OCT, Left is MCH
                    % 2 - Right is MCH, Left is OCT
reward = [];
reset = 0;
% n_trials = 1
baiting = [0;0];
% while time <7200
    while n_trials  < 41 && time<7200
        if exist('vidobj2') == 0
            vidobj2 = videoinput('pointgrey',2);
            triggerconfig(vidobj2, 'manual');
            vidobj2.FramesPerTrigger = inf; 
            start(vidobj2);
            trigger(vidobj2) 
        end
        tic
        [xy,count,snapshot,ave_background, more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count);  
        xy_now = round(xy(:,end));
        if sum(xy_now == [-1;-1]) == 2
            if vidobj2.FramesAcquired > 100000
                delete(vidobj2);
                delete_vidobj_count =delete_vidobj_count +1
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
            PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
            while isempty(PresentZone) == 1
                [xy,count,snapshot,ave_background, more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count);  
                xy_now = round(xy(:,end));
                if sum(xy_now == [-1,-1]) == 2
                    if vidobj2.FramesAcquired > 100000
                        delete(vidobj2);
                        delete_vidobj_count =delete_vidobj_count +1
                        clear('vidobj2');
                    end
                    s = toc;
                    timestamps(length(timestamps)+1) = s;
                    statestamps(length(statestamps)+1) = od_state;
                    time = time + s;
                    continue
                end
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)
            end
            if PresentZone == 7 || PresentZone == 4  || PresentZone == 1 %(fly isin arm 0)
                od_state = 1;
                if rand(1) >0.5
                    ch_state = 1;
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio2); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % OCT

                else
                    ch_state = 2;
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio2); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio3); % MCH

                end
            elseif PresentZone == 8 || PresentZone == 5  || PresentZone == 2 %(fly isin arm 1)
                od_state = 2;
                if rand(1) >0.5
                    ch_state = 2;
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio1); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % OCT

                else
                    ch_state = 1;
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio1); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % AIR
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio3); % MCH
 
                end    
            elseif PresentZone == 9 || PresentZone == 6  || PresentZone == 3 %(fly isin arm 2)
                od_state = 3;
                if rand(1) >0.5
                    ch_state = 1;
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio1); % MCH
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio2); % OCT
                    s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % AIR

                else
                    ch_state = 2;
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
                while isempty(PresentZone) == 1
                    [xy,count,snapshot,ave_background, more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count);  
                    xy_now = round(xy(:,end));
                    if sum(xy_now == [-1,-1]) == 2
                        if vidobj2.FramesAcquired > 100000
                            delete(vidobj2);
                            delete_vidobj_count =delete_vidobj_count +1
                            clear('vidobj2');
                        end
                        s = toc;
                        timestamps(length(timestamps)+1) = s;
                        statestamps(length(statestamps)+1) = od_state;
                        time = time + s;
                        continue
                    end
                    PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
                end
    %             if PresentZone == 6 && PastZone == 3
    %                 if ch_state == 1
    %                     servos.expose(2) 
    %                 end
    %             elseif PresentZone == 5 && PastZone == 2
    %                 if ch_state == 2
    %                     servos.expose(1) 
    %                 end  
                if PresentZone == 9 && PastZone == 6

                        od_state = 0;
                        n_trials = n_trials + 1

                elseif PresentZone == 8 && PastZone == 5

                        od_state = 0;
                        n_trials = n_trials + 1
 
                end

            end
        elseif od_state == 2
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            if PresentZone ~= find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)

                PastZone = PresentZone;
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
                while isempty(PresentZone) == 1
                    [xy,count,snapshot,ave_background, more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count);  
                    xy_now = round(xy(:,end));
                    if sum(xy_now == [-1,-1]) == 2
                        if vidobj2.FramesAcquired > 100000
                            delete(vidobj2);
                            delete_vidobj_count =delete_vidobj_count +1
                            clear('vidobj2');
                        end
                        s = toc;
                        timestamps(length(timestamps)+1) = s;
                        statestamps(length(statestamps)+1) = od_state;
                        time = time + s;
                        continue
                    end
                    PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
                end
    %             if PresentZone == 6 && PastZone == 3
    %                 if ch_state == 2
    %                     servos.expose(2) 
    %                 end
    %             elseif PresentZone == 4 && PastZone == 1
    %                 if ch_state == 1
    %                     servos.expose(0) 
    %                 end  
                if PresentZone == 9 && PastZone == 6

                    od_state = 0;
                    n_trials = n_trials + 1
                elseif PresentZone == 7 && PastZone == 4

                    od_state = 0;
                    n_trials = n_trials + 1
                end

            end 
        elseif od_state == 3
            air_arm(length(air_arm)+1) = od_state;
            right_left(length(right_left)+1) = ch_state;
            if PresentZone ~= find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1)
                PastZone = PresentZone;
                PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
                while isempty(PresentZone) == 1
                    [xy,count,snapshot,ave_background, more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count);  
                    xy_now = round(xy(:,end));
                    if sum(xy_now == [-1,-1]) == 2
                        if vidobj2.FramesAcquired > 100000
                            delete(vidobj2);
                            delete_vidobj_count =delete_vidobj_count +1
                            clear('vidobj2');
                        end
                        s = toc;
                        timestamps(length(timestamps)+1) = s;
                        statestamps(length(statestamps)+1) = od_state;
                        time = time + s;
                        continue
                    end
                    PresentZone = find([binarymask1(xy_now(2),xy_now(1)),binarymask2(xy_now(2),xy_now(1)),binarymask3(xy_now(2),xy_now(1)),binarymask4(xy_now(2),xy_now(1)),binarymask5(xy_now(2),xy_now(1)),binarymask6(xy_now(2),xy_now(1)),binarymask7(xy_now(2),xy_now(1)),binarymask8(xy_now(2),xy_now(1)),binarymask9(xy_now(2),xy_now(1))]==1,1);
                end
    %             if PresentZone == 5 && PastZone == 2
    %                 if ch_state == 1
    %                        servos.expose(1) 
    %                 end
    %             elseif PresentZone == 4 && PastZone == 1
    %                 if ch_state == 2
    %                     servos.expose(0) 
    %                 end  
                if PresentZone == 8 && PastZone == 5

                    od_state = 0;
                    n_trials = n_trials + 1

                elseif PresentZone == 7 && PastZone == 4

                    od_state = 0;
                    n_trials = n_trials + 1
                end

            end  
        end
        if vidobj2.FramesAcquired > 100000
            delete(vidobj2);
            delete_vidobj_count =delete_vidobj_count +1
            clear('vidobj2');
        end
        s = toc;
        timestamps(length(timestamps)+1) = s;
        statestamps(length(statestamps)+1) = od_state;
        time = time + s;
    end
    if time>7200
        n_trials = 1000
    end    
% end    
    matfilename = strcat(dataPath, '\all_variables_contingency_naive.mat');
    save(matfilename)
%     delete(vidobj2);
%     clear('vidobj2');
end    