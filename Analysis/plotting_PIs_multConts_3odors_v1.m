%% Calculate PI from an olfactory arena experiment
function [] = plotting_PIs_multConts_3odors_v1(save_fig,lookback)
%     close all
%     clear
%     clc

    % Select spreadsheet containing experiment names
% FOR MAC LAPTOP
%   cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
    % FOR WORK DESKTOP
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
    num_turns_away_O = []
    num_turns_away_M = []
    num_turns_away_PO = []
    num_turns_away_PM = []
    
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
                count = count+1;
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

%                 [local_maxima,locs] = findpeaks(dua,'MinPeakProminence',20);
%                 filename_1 = strcat('peaks',num2str(conts),'.mat');
%                 filename_2 = strcat('locs',num2str(conts),'.mat');
%                 save(filename_1,'local_maxima')
%                 save(filename_2,'locs')

                
                
               % PLOTTING position vs time with different colors for different
               % odors in arm
                max_time = max(x_y_time_color.time);
                
                num_figs = ceil(max_time/1800);
                cont_switch(1) = 1;
                if num_figs > 1
                    for yy = 2:num_figs
                        cont_switch(yy) = find(x_y_time_color.time > (yy-1)*1800,1);
                    end

                end    
                cont_switch(num_figs+1) = length(x_y_time_color.time);
                for k = 1:num_figs
%                     if length(find(times(locs) > k*1800,1)) ==1
%                         splt(k) = find(times(locs) > k*1800,1);
%                     else
%                         splt(k) = 0;
%                     end    
                        figure(fig_count+1)
                        fig_count = fig_count+1
                        hold on
                        for i  = cont_switch(k):cont_switch(k+1)-1
                            if sum(x_y_time_color.color(i) == O_AirWall_Color) == 1 || sum(x_y_time_color.color(i) == P_AirWall_Color) == 1|| sum(x_y_time_color.color(i) == M_AirWall_Color) == 1
                                if sum(x_y_time_color.color(i+1) == O_AirWall_Color) == 1 || sum(x_y_time_color.color(i+1) == P_AirWall_Color) == 1|| sum(x_y_time_color.color(i+1) == M_AirWall_Color) == 1
                                    plot(x_y_time_color.time(i:i+1),-1*(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                                elseif sum(x_y_time_color.color(i+1) == O_AirWall_Color) ~= 1 || sum(x_y_time_color.color(i+1) == P_AirWall_Color) ~= 1|| sum(x_y_time_color.color(i+1) == M_AirWall_Color) ~= 1
                                    plot(x_y_time_color.time(i:i+1),[-1*(x_y_time_color.distance_up_arm(i)),(x_y_time_color.distance_up_arm(i+1))],'LineWidth',3,'Color',x_y_time_color.color(i,:))
                                end    
                            else
                                if sum(x_y_time_color.color(i+1) == O_AirWall_Color) == 1 || sum(x_y_time_color.color(i+1) == P_AirWall_Color) == 1|| sum(x_y_time_color.color(i+1) == M_AirWall_Color) == 1
    %                                 plot(x_y_time_color.time(i:i+1),[x_y_time_color.distance_up_arm(i),-1*(x_y_time_color.distance_up_arm(i))],'LineWidth',3,'Color',Air_Color)
                                else
                                    plot(x_y_time_color.time(i:i+1),(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                                end    
                            end
                        end 
                        cc = 0;
                        timestamps_summed = [];
                        for tt  = cps(max(find(cps<cont_switch(k)+1))+1:max(find(cps<cont_switch(k+1))))
                            no_match = 1;
                            kk = 0;
                            while no_match == 1
                                kk = kk+1;
                                if sum(x_y_time_color.color(tt-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(tt-kk,:) == M_P_Color )==3
                                    dot_color = M_A_Color;
                                    no_match = 0;
                                elseif sum(x_y_time_color.color(tt-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == O_P_Color)==3
                                    dot_color = O_A_Color;
                                    no_match = 0;
                                elseif  sum(x_y_time_color.color(tt-kk,:) == P_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == P_O_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == P_M_Color)==3  
                                    dot_color = P_A_Color;
                                    no_match = 0;
                                end 
                            end    
                            cc = cc+1; 
                            timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
                            scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)

    %                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                        end

%                         if k == 1
%                             if splt(k)== 0
%                                 scatter(times(locs(1:end)),local_maxima(1:end),'filled','r')
%                             else
%                                 scatter(times(locs(1:splt(k))),local_maxima(1:splt(k)),'filled','r')
%                             end
% 
%                         else
%                             if splt(k) ~= 0
%                                scatter(times(locs(splt(k-1):splt(k))),local_maxima(splt(k-1):splt(k)),'filled','g')
%                             else
%                                scatter(times(locs(splt(k-1):end)),local_maxima(splt(k-1):end),'filled','g')
%                             end
%                         end 
                        xlabel('time (sec)');
                        ylabel('distance (pixels)');
                        hold off
                    
                end

%                 keyboard
                [odor_crossing] = odor_crossings_3odor(region_at_time,air_arm,right_left,timestamps,x_y_time_color,cps);
% %             
%                 keyboard
                num_turns_away_M(expt_n, cond_n-2, conts) = 0;
                num_turns_away_O(expt_n, cond_n-2, conts) = 0;
                num_turns_away_PM(expt_n, cond_n-2, conts) = 0;
                num_turns_away_PO(expt_n, cond_n-2, conts) = 0;
                num_turns_APW_AOW(expt_n, cond_n-2, conts) = 0;
                num_turns_APW_AMW(expt_n, cond_n-2, conts) = 0;
                num_turns_AOW_APW(expt_n, cond_n-2, conts) = 0;
                num_turns_AMW_APW(expt_n, cond_n-2, conts) = 0;
                num_trans_APW_O(expt_n, cond_n-2, conts) = 0;
                num_trans_APW_P_O(expt_n, cond_n-2, conts) = 0;
                num_trans_APW_P_M(expt_n, cond_n-2, conts) = 0;
                num_trans_APW_M(expt_n, cond_n-2, conts) = 0;
                num_trans_AOW_O(expt_n, cond_n-2, conts) = 0;
                num_trans_AOW_P(expt_n, cond_n-2, conts) = 0;
                num_trans_AMW_M(expt_n, cond_n-2, conts) = 0;
                num_trans_AMW_P(expt_n, cond_n-2, conts) = 0;
                figure(fig_count+1)
                    fig_count = fig_count+1;
                    hold on
                    for b = 1:length(odor_crossing)
                        if isequal(odor_crossing(b).type,'A_MWtoM')
                            scatter(odor_crossing(b).time,1,150,'s','filled','MarkerFaceColor',M_A_Color,'MarkerEdgeColor',M_A_Color)
                            num_trans_AMW_M(expt_n, cond_n-2, conts) =  num_trans_AMW_M(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoM')
                            scatter(odor_crossing(b).time,2,150,'s','filled','MarkerFaceColor',M_A_Color,'MarkerEdgeColor',M_A_Color)
                            num_trans_APW_M(expt_n, cond_n-2, conts) =  num_trans_APW_M(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_OWtoO')
                            scatter(odor_crossing(b).time,3,150,'s','filled','MarkerFaceColor',O_A_Color,'MarkerEdgeColor',O_A_Color)
                            num_trans_AOW_O(expt_n, cond_n-2, conts) =  num_trans_AOW_O(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoO')
                            scatter(odor_crossing(b).time,4,150,'s','filled','MarkerFaceColor',O_A_Color,'MarkerEdgeColor',O_A_Color)
                            num_trans_APW_O(expt_n, cond_n-2, conts) =  num_trans_APW_O(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_OWtoP')
                            scatter(odor_crossing(b).time,5,150,'s','filled','MarkerFaceColor',P_A_Color,'MarkerEdgeColor',P_A_Color)
                            num_trans_AOW_P(expt_n, cond_n-2, conts) =  num_trans_AOW_P(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_MWtoP')
                            scatter(odor_crossing(b).time,6,150,'s','filled','MarkerFaceColor',P_A_Color,'MarkerEdgeColor',P_A_Color)    
                            num_trans_AMW_P(expt_n, cond_n-2, conts) =  num_trans_AMW_P(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoP_O')
                            scatter(odor_crossing(b).time,7,150,'s','filled','MarkerFaceColor',P_A_Color,'MarkerEdgeColor',P_A_Color)
                            num_trans_APW_P_O(expt_n, cond_n-2, conts) =  num_trans_APW_P_O(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoP_M')
                            scatter(odor_crossing(b).time,8,150,'s','filled','MarkerFaceColor',P_A_Color,'MarkerEdgeColor',P_A_Color)
                            num_trans_APW_P_M(expt_n, cond_n-2, conts) =  num_trans_APW_P_M(expt_n, cond_n-2, conts)+1;
                        elseif isequal(odor_crossing(b).type,'OtoP')
                            scatter(odor_crossing(b).time,9,150,'s','filled','MarkerFaceColor',P_O_Color,'MarkerEdgeColor',P_O_Color)  
                            num_turns_away_O(expt_n,cond_n-2,conts) = num_turns_away_O(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoO')
                            scatter(odor_crossing(b).time,10,150,'s','filled','MarkerFaceColor',O_P_Color,'MarkerEdgeColor',O_P_Color) 
                            num_turns_away_PO(expt_n,cond_n-2,conts) = num_turns_away_PO(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'MtoP')
                            scatter(odor_crossing(b).time,11,150,'s','filled','MarkerFaceColor',P_M_Color,'MarkerEdgeColor',P_M_Color)  
                            num_turns_away_M(expt_n,cond_n-2,conts) = num_turns_away_M(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoM')
                            scatter(odor_crossing(b).time,12,150,'s','filled','MarkerFaceColor',M_P_Color,'MarkerEdgeColor',M_P_Color) 
                            num_turns_away_PM(expt_n,cond_n-2,conts) = num_turns_away_PM(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'MtoA_MW')
                            scatter(odor_crossing(b).time,13,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_M(expt_n,cond_n-2,conts) = num_turns_away_M(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'MtoA_PW')
                            scatter(odor_crossing(b).time,14,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_M(expt_n,cond_n-2,conts) = num_turns_away_M(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'OtoA_OW')
                            scatter(odor_crossing(b).time,15,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_O(expt_n,cond_n-2,conts) = num_turns_away_O(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'OtoA_PW')
                            scatter(odor_crossing(b).time,16,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_O(expt_n,cond_n-2,conts) = num_turns_away_O(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoA_PW_O')
                            scatter(odor_crossing(b).time,17,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_PO(expt_n,cond_n-2,conts) = num_turns_away_PO(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoA_OW')
                            scatter(odor_crossing(b).time,18,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_PO(expt_n,cond_n-2,conts) = num_turns_away_PO(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoA_MW')
                            scatter(odor_crossing(b).time,19,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_PM(expt_n,cond_n-2,conts) = num_turns_away_PM(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'PtoA_PW_M')
                            scatter(odor_crossing(b).time,20,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_away_PM(expt_n,cond_n-2,conts) = num_turns_away_PM(expt_n,cond_n-2,conts)+1;
                        elseif isequal(odor_crossing(b).type,'A_OWtoA_PW')
                            scatter(odor_crossing(b).time,21,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_AOW_APW(expt_n, cond_n-2, conts) = num_turns_AOW_APW(expt_n, cond_n-2, conts) +1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoA_OW')
                            scatter(odor_crossing(b).time,22,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_APW_AOW(expt_n, cond_n-2, conts) = num_turns_APW_AOW(expt_n, cond_n-2, conts) +1;
                        elseif isequal(odor_crossing(b).type,'A_MWtoA_PW')
                            scatter(odor_crossing(b).time,23,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_AMW_APW(expt_n, cond_n-2, conts) = num_turns_AMW_APW(expt_n, cond_n-2, conts) +1;
                        elseif isequal(odor_crossing(b).type,'A_PWtoA_MW')
                            scatter(odor_crossing(b).time,24,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                            num_turns_APW_AMW(expt_n, cond_n-2, conts) = num_turns_APW_AMW(expt_n, cond_n-2, conts) +1;
                                                         
                        end
                    end
                xlabel('time (sec)')
                ylabel('choice ID')
                yticks([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24])
                yticklabels({'A_MW to M','A_PW to M','A_OW to O','A_PW to O','A_OW to P ','A_MW to P ','A_PW to P (Otrials)','A_PW to P (Mtrials)','O to P', 'P to O','M to P', 'P to M', 'M to A_MW', 'M to A_PW', 'O to A_OW', 'O to A_PW','P to A_PW (Otrials)', 'P to A_OW','P to A_MW','P to A_PW (Mtrials)','A_OW to A_PW','A_PW to A_OW', 'A_MW to A_PW','A_PW to A_MW'})

% 
                hold off
%                 keyboard
                % Plotting # choices over time
                if conts > 1
                    summed_choices_ends = [];
                    summed_choices_center = [];
                    summed_O_choices_ends = [];
                    summed_O_choices_center = [];
                    summed_M_choices_ends = []; 
                    summed_M_choices_center = [];
                    [summed_choices_ends,summed_O_choices_ends, summed_P_O_choices_ends,summed_M_choices_ends, summed_P_M_choices_ends,fig_count,net_summed_choices,gotofig,gotogifg3,CO,RO] = summed_choices_mult_conts_3odor(cps,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,gotofig3,pre_sumM,pre_sumO,pre_sumPO,pre_sumPM);

                else
                    [summed_choices_ends,summed_O_choices_ends, summed_P_O_choices_ends,summed_M_choices_ends, summed_P_M_choices_ends,fig_count,net_summed_choices,gotofig,gotofig3,CO,RO] = summed_choices_mult_conts_3odor(cps,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,gotofig3,0,0,0,0);
                    pre_sumM = summed_M_choices_ends(end) ;
                    pre_sumO = summed_O_choices_ends(end);
                    pre_sumPO = summed_P_O_choices_ends(end);
                    pre_sumPM = summed_P_M_choices_ends(end);
                    pre_sum = summed_choices_ends(end);
                end

                
                choice_order(1:length(CO),ceil(conts)) = CO;
                reward_order(1:length(RO),ceil(conts)) = RO;


                if conts > 1
%                     [inst_choice_ratio(cond_n-2,:),inst_income_ratio,ave_choice_ratios(expt_n,cond_n-2,conts),ave_choice_ratios_sec_half(expt_n,cond_n-2,conts),fig_count,ave_reward_ratios(expt_n,cond_n-2,conts),ave_reward_ratios_sec_half(expt_n,cond_n-2,conts),gotofig2] = inst_CR_mult_conts(fig_count,protocol_100_0,choice_order(:,conts),reward_order(:,conts),lookback,conts,pre_sum,baiting,reward,gotofig2)
                    pre_sumM = summed_M_choices_ends(end) ;
                    pre_sumO = summed_O_choices_ends(end);
                    pre_sumPO = summed_P_O_choices_ends(end);
                    pre_sumPM = summed_P_M_choices_ends(end);
                    pre_sum = summed_choices_ends(end);
                else
%                     [inst_choice_ratio(cond_n-2,:),inst_income_ratio,ave_choice_ratios(expt_n,cond_n-2,conts),ave_choice_ratios_sec_half(expt_n,cond_n-2,conts),fig_count,ave_reward_ratios(expt_n,cond_n-2,conts),ave_reward_ratios_sec_half(expt_n,cond_n-2,conts),gotofig2] = inst_CR_mult_conts(fig_count,protocol_100_0,choice_order(:,conts),reward_order(:,conts),lookback,conts,0,baiting,reward,gotofig2)
                end
                    
                    
                       

            end   
                     
            
            if save_fig == 1 %&&  exist('figure1.svg') ~= 2

                for fc = 1:fig_count
                    if fc == gotofig
                        saveas(figure(gotofig),'summed_choices_ends.fig')
                        saveas(figure(gotofig),'summed_choices_ends.svg')
                    elseif fc == gotofig2
                        saveas(figure(gotofig2),'inst_CR_lb10.fig')
                        saveas(figure(gotofig2),'inst_CR_lb10.svg')
                    else
                        saveas(figure(fc),sprintf('figure%d.fig',fc))
                        saveas(figure(fc),sprintf('figure%d.svg',fc))
                    end    
                end


%                 saveas(figure(1),'pre_reward_summary.fig')
%                 saveas(figure(2),'post_reward_summary.fig')
%                 saveas(figure(3),'end_choices.fig')
%                 saveas(figure(4),'center_choices.fig')
%                 saveas(figure(5),'summed_choices_ends.fig')
%                 saveas(figure(6),'inst_CR_lb10.fig')
%                 saveas(figure(7),'speed_heatmap.jpg')
%                 saveas(figure(7),'speed_time.fig')
%                 save('inst_CR_lb10.mat','inst_choice_ratio')
%                 save('inst_IR_lb10.mat','inst_income_ratio')
%                 save('cps_pre.mat','cps_pre')
                        save('choice_order.mat','choice_order')
                        save('reward_order.mat','reward_order')
%                         close all
                pause(60)
%                     elseif save_fig == 1 && exist('speed_time.fig') == 2
%                         fig_count = 0;
 
                
                
            end
%             
            save('O_choice.mat','summed_O_choices_ends')
            save('M_choice.mat','summed_M_choices_ends')
            save('PO_choice.mat','summed_P_O_choices_ends')
            save('PM_choice.mat','summed_P_M_choices_ends')
% %                        
            fig_count = 0;
            close all
        end
        keyboard  
        save('pis_m.mat','individual_pi_m')
        save('pis_0.mat','individual_pi_o')
%         save('num_turns_rewarded.mat','num_turns_away_rewarded')
%         save('num_turns_unrewarded.mat','num_turns_away_unrewarded')
    
    end 
end