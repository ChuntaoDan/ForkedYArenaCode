cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)


individual_pi = [];
arm_bias_expected_pi = [];
count = 0;
cpms = [];
fig_count = 0;
ave_choice_ratios = [];
ave_reward_ratios = [];
ave_choice_ratios_sec_half = [];
ave_reward_ratios_sec_half = [];
% ONLY FOR 100-0 EXPTS
num_turns_away_rewarded = zeros(2,25,3);
num_turns_away_unrewarded = zeros(2,25,3);

color_vec = cbrewer('qual','Dark2',10,'cubic');
Air_Color = 0*color_vec(6,:);
O_A_Color = color_vec(1,:);
O_M_Color = 0.6*color_vec(1,:);
M_A_Color = color_vec(7,:);
M_O_Color = 0.7*color_vec(7,:);

protocol_100_0 = 2; % just setting this number to two for now it is an unneccesary variable but removing it requires too many code changes for now
p_staying_g_Nreward = [];
p_staying_g_reward = [];
p_switching_g_Nreward = [];
p_switching_g_reward =[];

for expt_n = 1:2%length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            count = count+1;
            continue
            %SKIPPING LOW MI EXPTS FOR GR64f
%         elseif expt_n == 1
%             if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                 continue
%             end
%         elseif expt_n == 2
%             if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                 continue
%             end


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
        
        load('odor_crossing.mat')
        
         load(sprintf('all_variables_contingency_%d',1))
                   
                exist reward
                if ans == 0 
                    reward = [];
                end    

                
                cps_first = find(air_arm==0);
                cps_first(length(cps_first)+1) = length(air_arm);
                [xy_no_minus_ones,timestamps_no_minus_ones] = no_minus_ones(xy,timestamps);
                [region_at_time] = region_time_vector(xy_no_minus_ones,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9);
                [x_y_time_color] = plot_position_choices(region_at_time,xy_no_minus_ones,timestamps_no_minus_ones,air_arm,right_left,cps_first);
                % Specific fix
                if length(x_y_time_color.distance_up_arm) ~= length(x_y_time_color.time)
                    x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm)+1:length(x_y_time_color.distance_up_arm)+1+(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm))) = x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm))*ones(1,(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm)));
                end    
                
                [pi,cps] = preference_index_multConts(air_arm,right_left,x_y_time_color);
                [a,b,c,d,arm_bias_pi] = arm_bias(air_arm,right_left);

                individual_pi(expt_n,cond_n-2,1) = pi;
                arm_bias_expected_pi(expt_n,cond_n-2,1) = arm_bias_pi;
                cpms(expt_n,cond_n-2,1) = choicesperminute(air_arm,time);
                
                load('choice_order.mat')
                
                num_turn_away_O = 0;
                num_turn_away_M = 0
                num_stay_O = 0;
                num_stay_M = 0;
                
                previous_location = 'A'
                choice_num = 1
                
                for i = 1:length(odor_crossing)
                    time_c = odor_crossing(i).time_pt_in_vector

                    if time_c < cps(choice_num+1)
                        if previous_location == 'A'
                            if sum(odor_crossing(i).type{1} == 'AtoO') == 4
                                previous_location = 'O'
                                continue
                            elseif sum(odor_crossing(i).type{1} == 'AtoM') == 4
                                previous_location = ' M'
                                continue
                            end
                        elseif previous_location == 'O' 
                            if sum(odor_crossing(i).type{1} == 'OtoA') == 4
                                previous_location = 'A'
                                num_turn_away_O = num_turn_away_O + 1;
                                continue
                            elseif sum(odor_crossing(i).type{1} == 'OtoM') == 4
                                previous_location = ' M'
                                num_turn_away_O = num_turn_away_O + 1;
                                continue
                            end
                        elseif previous_location == 'M'   
                            if sum(odor_crossing(i).type{1} == 'MtoA') == 4
                                previous_location = 'A'
                                num_turn_away_M = num_turn_away_M + 1;
                                continue
                            elseif sum(odor_crossing(i).type{1} == 'MtoO') == 4
                                previous_location = 'O'
                                num_turn_away_M = num_turn_away_M + 1;
                                continue
                            end
                        end
                    elseif time_c > cps(choice_num+1)
                        choice_num = choice_num+1
                        if previous_location == 'O'
                            num_stay_O = num_stay_O + 1;
                        elseif previous_location == 'M'
                            num_stay_M = num_stay_M + 1;    
                        end    
                        previous_location = 'A'
                    end
                end    
                        

        keyboard
    end
end