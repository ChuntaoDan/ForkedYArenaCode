function [peaks] = plotting_turns_multConts()
%     close all
%     clear
%     clc

    % Select spreadsheet containing experiment names
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)

    peaks = struct('peaks',struct(),'locs',struct());
    individual_pi = [];
    arm_bias_expected_pi = [];
    count = 0;
    count2 = 0;
    cpms = [];
    fig_count = 0;
    ave_choice_ratios = [];
    ave_reward_ratios = [];
    
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
    
    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        if expt_name(end-9:end) == 'O80M20_n+4'
            protocol_100_0 = 2; % 1 - O100M0; 2 - O80M20; 3 - O60M40;
            completed_conts = 5;
        elseif expt_name(end-9:end) == 'O80M20_n+3'
            protocol_100_0 = 2;
            completed_conts = 4;
        elseif expt_name(end-9:end) == 'O80M20_n+2'
            protocol_100_0 = 2;    
            completed_conts = 3;
        elseif expt_name(end-9:end) == 'O80M20_n+1'
            protocol_100_0 = 2;    
            completed_conts = 2;
        end    
        cd(expt_name)
        conds = dir(expt_name);
        
        for cond_n = 1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
                count = count+1;
                continue
            end
            


            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            gotofig = 0;
            gotofig2 = 0;
            for conts = 1:completed_conts
                if conts == 1
                    load('all_variables_contingency_naive.mat')
                else
                    load(sprintf('all_variables_contingency_%d',conts-1))
                end    
                exist reward
                if ans == 0 
                    reward = [];
                end    
                count2 = count2+1
                
                cps_first = find(air_arm==0);
                cps_first(length(cps_first)+1) = length(air_arm);
                [xy_no_minus_ones,timestamps_no_minus_ones] = no_minus_ones(xy,timestamps);
                [region_at_time] = region_time_vector(xy_no_minus_ones,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9);
                [x_y_time_color] = plot_position_choices(region_at_time,xy_no_minus_ones,timestamps_no_minus_ones,air_arm,right_left,cps_first);

                
                [pi,cps] = preference_index_multConts(air_arm,right_left,x_y_time_color);
                [a,b,c,d,arm_bias_pi] = arm_bias(air_arm,right_left);

                individual_pi(expt_n,cond_n-2,conts) = pi;
                arm_bias_expected_pi(expt_n,cond_n-2,conts) = arm_bias_pi;
                cpms(expt_n,cond_n-2,conts) = choicesperminute(air_arm,time);
                
                dua = x_y_time_color.distance_up_arm;
                times = x_y_time_color.time;
                colors = x_y_time_color.color;
                
                for i = 1:length(dua)
                    if sum(colors(i,:) == O_AirWall_Color) == 3 ||sum(colors(i,:) == P_AirWall_Color) == 3 ||sum(colors(i,:) == M_AirWall_Color) == 3 
                        dua(i) = -dua(i);
                    end
                end   
                
                
                times =  x_y_time_color.time(lists);
                
                lists = find(dua < 415);
                dua = x_y_time_color.distance_up_arm(lists);
                
                lists2 = find(dua == 0);  
                if lists2(1) == 1
                    lists2 = lists2(2:end);
                end    
                dua(lists2) = dua(lists2-1)+0.1;
                [local_maxima,locs] = findpeaks(dua,'MinPeakProminence',20);
                filename_1 = strcat('peaks',num2str(count2),'.mat');
                filename_2 = strcat('locs',num2str(count2),'.mat');
                save(filename_1,'local_maxima')
                save(filename_2,'locs')

                lmax_OCT = [];
                lmax_MCH = [];

                for i = 1:length(locs)

                    if sum(colors(locs(i),:) == O_A_Color) == 3 || sum(colors(locs(i),:) == O_M_Color) == 3
                        lmax_OCT(length(lmax_OCT)+1) = local_maxima(i);
                    elseif sum(colors(locs(i),:) == M_A_Color) == 3 || sum(colors(locs(i),:) == M_O_Color) == 3
                        lmax_MCH(length(lmax_MCH)+1) = local_maxima(i);
                         
                    end
                end 

                filename_1 = strcat('OCT_peaks',num2str(count2),'.mat');
                filename_2 = strcat('MCH_peaks',num2str(count2),'.mat');
                save(filename_1,'lmax_OCT')
                save(filename_2,'lmax_MCH')
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
                    if length(find(times(locs) > k*1800,1)) ==1
                        splt(k) = find(times(locs) > k*1800,1);
                    else
                        splt(k) = 0;
                    end    
                    figure(fig_count+1)
                    fig_count = fig_count+1
                    hold on
                    for i  = cont_switch(k):cont_switch(k+1)-1
                        if sum(x_y_time_color.color(i) == Air_Color) == 3
                            if sum(x_y_time_color.color(i+1) == Air_Color) == 3
                                plot(x_y_time_color.time(i:i+1),1*(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                            elseif sum(x_y_time_color.color(i+1) == Air_Color) ~= 3
                                plot(x_y_time_color.time(i:i+1),[1*(x_y_time_color.distance_up_arm(i)),(x_y_time_color.distance_up_arm(i+1))],'LineWidth',3,'Color',x_y_time_color.color(i,:))
                            end    
                        else
                            if sum(x_y_time_color.color(i+1) == Air_Color) == 3
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
                            if sum(x_y_time_color.color(tt-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(tt-kk,:) == M_O_Color )==3
                                dot_color = M_A_Color;
                                no_match = 0;
                            elseif sum(x_y_time_color.color(tt-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == O_M_Color)==3
                                dot_color = O_A_Color;
                                no_match = 0;
                            end 
                        end    
                        cc = cc+1; 
                        timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
                        scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)

%                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                    end
                     

                    if k == 1
                        if splt(k)== 0
                            scatter(times(locs(1:end)),local_maxima(1:end),'filled','r')
                        else
                            scatter(times(locs(1:splt(k))),local_maxima(1:splt(k)),'filled','r')
                        end
                        
                    else
                        if splt(k) ~= 0
                           scatter(times(locs(splt(k-1):splt(k))),local_maxima(splt(k-1):splt(k)),'filled','g')
                        else
                           scatter(times(locs(splt(k-1):end)),local_maxima(splt(k-1):end),'filled','g')
                        end
                    end 
                    xlabel('time (sec)');
                    ylabel('distance (pixels)');


                end

                 
                

                fieldname = strcat('peaks',num2str(count2));
                fieldname2 = strcat('locs',num2str(count2));
                peaks.peak.('fieldname') = local_maxima;
                peaks.locs.('fieldname2') = locs;
            end
        end
    end
end    
