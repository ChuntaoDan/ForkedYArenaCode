% ONLY FOR 100-0 EXPTS

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
        conts = dir(cond);
        length_conts = 0;
        for ct = 1:length(conts)
            if endsWith(conts(ct).name,'.mat')
                length_conts = length_conts + 1;
            end
        end    

        if length_conts == 9
            subt = 6; %1;
        elseif length_conts == 8
            subt = 6;
        else
            subt = 6;
        end    

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
            [x_y_time_color] = plot_position_choices(region_at_time,xy_no_minus_ones,timestamps_no_minus_ones,air_arm,right_left,cps_first);
            % Specific fix
            if length(x_y_time_color.distance_up_arm) ~= length(x_y_time_color.time)
                x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm)+1:length(x_y_time_color.distance_up_arm)+1+(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm))) = x_y_time_color.distance_up_arm(length(x_y_time_color.distance_up_arm))*ones(1,(length(x_y_time_color.time)-length(x_y_time_color.distance_up_arm)));
            end    

            [pi,cps] = preference_index_multConts(air_arm,right_left,x_y_time_color);
            [a,b,c,d,arm_bias_pi] = arm_bias(air_arm,right_left);

            individual_pi(expt_n,cond_n-2,conts) = pi;
            arm_bias_expected_pi(expt_n,cond_n-2,conts) = arm_bias_pi;
            cpms(expt_n,cond_n-2,conts) = choicesperminute(air_arm,time);
            
            [odor_crossing] = odor_crossings(region_at_time,air_arm,right_left,timestamps);

            if reward(1,2) == 1
                rewarded_odor = 1;
            else
                rewarded_odor = 2;
            end       

            % Plotting # choices over time
            if conts > 1
                summed_choices_ends = [];
                summed_choices_center = [];
                summed_O_choices_ends = [];
                summed_O_choices_center = [];
                summed_M_choices_ends = []; 
                summed_M_choices_center = [];
                [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center,fig_count,net_summed_choices,CO,RO,gotofig] = summed_choices_mult_conts(cps,odor_crossing,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,pre_sumM,pre_sumO,baiting)

            else
                [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center,fig_count,net_summed_choices,CO,RO,gotofig] = summed_choices_mult_conts(cps,odor_crossing,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,0,0,baiting)
                pre_sumM = summed_M_choices_ends(end) ;
                pre_sumO = summed_O_choices_ends(end);
                pre_sum = summed_choices_ends(end);
            end

            choice_order(1:length(CO),conts) = CO;
            reward_order(1:length(RO),conts) = RO;
            
            keyboard
            
            figure
%             imshow(ave_background)
%             hold on


            trajectories = []
            for i = 2:length(cps)
            trajectories(i-1,1,1:cps(i)-cps(i-1)+1) = x_y_time_color.xy(cps(i-1) : cps(i),1);
            trajectories(i-1,2,1:cps(i)-cps(i-1)+1) = x_y_time_color.xy(cps(i-1) : cps(i),2);
            end
            
            for j = 1:length(cps)-1
%                 figure
                subplot(12,10,j)
                imshow(ave_background)
                hold on
                
                tx = trajectories(j,1,:);
                ty = trajectories(j,2,:);

                % define the x- and y-data for the original line we would like to rotate

                x = squeeze(tx(1:find(tx == 0)-1));
                y = squeeze(ty(1:find(tx == 0)-1));

                % create a matrix of these points, which will be useful in future calculations
            
                v = [x,y]
                %v = ave_background;
            
                % choose a point which will be the center of rotation
            
                x_center = 555;
            
                y_center = 643;
            
                % create a matrix which will be used later in calculations
            
                center = transpose(repmat([x_center; y_center], 1, length(x)));
            
                % define a 60 degree counter-clockwise rotation matrix
                if air_arm(cps(j+1)-1) == 1
                    theta = deg2rad(0); 
                elseif air_arm(cps(j+1)-1) == 2
             
                    theta = deg2rad(120);
                else
                    theta = deg2rad(240)
                end    
                R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            
                % do the rotation...
            
                s = v - center;     % shift points in the plane so that the center of rotation is at the origin
            
                so = s*R;           % apply the rotation about the origin
            
                vo = so + center;   % shift again so the origin goes back to the desired center of rotation
            
                % this can be done in one line as:
            
                % vo = R*(v - center) + center
            
                % pick out the vectors of rotated x- and y-data
            
                x_rotated = vo(:,1);
            
                y_rotated = vo(:,2);
            
                lineColor = linspace(0,1,length(x));
            % 
                rightmost_x = 973;
                leftmost_x = 140
                if rewarded_odor == 1
                    if right_left(cps(j+1)-1) == 1
                        continue
                    else
                        x_rotated = rightmost_x-x_rotated+leftmost_x;
                        
                    end  
                elseif rewarded_odor == 2
                    if right_left(cps(j+1)-1) == 2
                        continue
                    else
                        x_rotated = rightmost_x-x_rotated+leftmost_x;
                        
                    end  
                end
                for i = 2:length(x)

                    plot(x_rotated(i-1:i),y_rotated(i-1:i),'color', [lineColor(i),0.5,1-lineColor(i)],'LineWidth',4)
                end    
%                 keyboard
            end    
            
        end
    end
end

