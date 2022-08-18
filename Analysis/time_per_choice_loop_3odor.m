cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)



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
    

    protocol_100_0 = 2; % just setting this number to two for now it is an unneccesary variable but removing it requires too many code changes for now

    
    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);
        
        for cond_n =1:length(conds)-2
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
%                 count = count+1;
                continue
                %SELECTING GOOD EXPTS BASED ON MI FOR GR64f
%             elseif expt_n == 1
%                 if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                     continue
%                 end
%             elseif expt_n == 2
%                 if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                     continue
%                 end
            end
              
            choice_order = [];
            reward_order = [];

            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
%             if exist('figure1.fig')==2
%                 continue
%             end    
            gotofig = 0;
            gotofig2 = 0;
            gotofig3 = 0;
            conts = dir(cond);
            length_conts = 0;
            for ct = 1:length(conts)
                if endsWith(conts(ct).name,'.mat')
                    length_conts = length_conts + 1;
                end
            end    
            
            if length_conts == 16
                subt = 13;
            elseif length_conts == 13
                subt = 11;
            elseif length_conts == 10
                subt = 7;
            elseif length_conts == 9
                subt = 6;
            elseif length_conts == 11
                subt = 9
            end
            
            cts = 0;
              
            for conts = 1:length_conts-subt % this set of expts has 3 conts
                
                load(sprintf('all_variables_contingency_%d',conts))
                   
                exist reward
                if ans == 0 
                    reward = [];
                end   
                
                cps_first = find(air_arm==0);
                cps_first(length(cps_first)+1) = length(air_arm);
                [xy_no_minus_ones,timestamps_no_minus_ones] = no_minus_ones(xy,timestamps);
                [region_at_time] = region_time_vector(xy_no_minus_ones,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9);

                [x_y_time_color] = plot_position_choices_3_odors(region_at_time,xy_no_minus_ones,timestamps_no_minus_ones,air_arm,right_left,cps_first);
                if length(x_y_time_color.distance_up_arm) ~= length(x_y_time_color.time)
                    x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm)+1:length(x_y_time_color.distance_up_arm)+1+(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm))) = x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm))*ones(1,(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm)));
                end
                [pi_m,pi_o,cps] = preference_index_multConts_3_odors(air_arm,right_left,x_y_time_color);
                individual_pi_m(expt_n,cond_n-2,conts) = pi_m;
                individual_pi_o(expt_n,cond_n-2,conts) = pi_o;
                
                   
                dua = x_y_time_color.distance_up_arm;
                times = x_y_time_color.time;
                colors = x_y_time_color.color;
                dua = dua(1:length(x_y_time_color.time))
                
                for i = 1:length(dua)
                    if sum(colors(i,:) == O_AirWall_Color) == 3 ||sum(colors(i,:) == P_AirWall_Color) == 3 ||sum(colors(i,:) == M_AirWall_Color) == 3 
                        dua(i) = -dua(i);
                    end
                end   

                for i = 2:length(cps)
                    cts = cts+1
                    time_center(expt_n,cond_n-2,cts) = length(find(x_y_time_color.distance_up_arm(cps(i-1):cps(i)) < 100));
                    time_total(expt_n,cond_n-2,cts) = cps(i)- cps(i-1);
                end
                
            end
        end
    end
    