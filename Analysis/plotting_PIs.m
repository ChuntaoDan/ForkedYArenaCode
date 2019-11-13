%% Calculate PI from an olfactory arena experiment
function [] = plotting_PIs(save_fig)
%     close all
%     clear
%     clc

    % Select spreadsheet containing experiment names
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)


    individual_pi = [];
    arm_bias_expected_pi = [];
    count = 0;
    cpms = [];
    fig_count = 0;

    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.3*color_vec(7,:);


    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
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
            load('all_variables.mat')

            [pi,cps] = preference_index(air_arm,right_left);
            [a,b,c,d,arm_bias_pi] = arm_bias(air_arm,right_left);

            individual_pi(expt_n,cond_n-2) = pi;
            arm_bias_expected_pi(expt_n,cond_n-2) = arm_bias_pi;
            cpms(expt_n,cond_n-2) = choicesperminute(air_arm,time);


            [xy_no_minus_ones,timestamps_no_minus_ones] = no_minus_ones(xy,timestamps);
            [region_at_time] = region_time_vector(xy_no_minus_ones,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9);
            [x_y_time_color] = plot_position_choices(region_at_time,xy_no_minus_ones,timestamps_no_minus_ones,air_arm,right_left,cps);

           % PLOTTING position vs time with different colors for different
           % odors in arm
            cont_switch = find(x_y_time_color.time >1800,1);
            [pi_pre(cond_n-2),cps_pre] = preference_index(air_arm(1:cont_switch-1),right_left(1:cont_switch-1));
            [pi_post(cond_n-2),cps_post] = preference_index(air_arm(cont_switch:length(x_y_time_color.time)),right_left(cont_switch:length(x_y_time_color.time)));
            for k = 1:2
                if k == 1    
                    figure(fig_count+1)
                    fig_count = fig_count+1
                    hold on
                    for i  = 1:cont_switch-1
                        if x_y_time_color.color == Air_Color
                            plot(x_y_time_color.time(i:i+1),x_y_time_color.distance_up_arm(i:i+1),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                        else
                            plot(x_y_time_color.time(i:i+1),x_y_time_color.distance_up_arm(i:i+1),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                        end
                    end 
                    cc = 0;
                    timestamps_summed = [];
                    for tt  = cps(2:max(find(cps<cont_switch)))
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
                        scatter(timestamps_summed(cc),600,200,'d','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                    end


                    xlabel('time (sec)');
                    ylabel('distance (pixels)');
                    hold off
                elseif k == 2
                    figure(fig_count+1)
                    fig_count = fig_count+1
                    hold on
                    for i  = cont_switch:length(x_y_time_color.distance_up_arm)-1
                        if x_y_time_color.color == Air_Color
                            plot(x_y_time_color.time(i:i+1),x_y_time_color.distance_up_arm(i:i+1),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                        else
                            plot(x_y_time_color.time(i:i+1),x_y_time_color.distance_up_arm(i:i+1),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                        end
                    end 
                    cc = 0;
                    timestamps_summed = [];
                    for tt  = cps(min(find(cps>cont_switch)):end)
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
                        scatter(timestamps_summed(cc),600,200,'d','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                    end


                    xlabel('time (sec)');
                    ylabel('distance (pixels)');
                    hold off
                end  
            end    


            % PLOTTING odor crossings

            [odor_crossing] = odor_crossings(region_at_time,air_arm,right_left,timestamps);

            figure(fig_count+1)
            fig_count = fig_count+1
            hold on
            for b = 1:length(odor_crossing)
                if isequal(odor_crossing(b).type,{'AtoM'})
                    scatter(odor_crossing(b).time,1,150,'d','filled','MarkerFaceColor',M_A_Color,'MarkerEdgeColor',M_A_Color)
                elseif isequal(odor_crossing(b).type,{'AtoO'})
                    scatter(odor_crossing(b).time,2,150,'d','filled','MarkerFaceColor',O_A_Color,'MarkerEdgeColor',O_A_Color)
                elseif isequal(odor_crossing(b).type,{'OtoM'})
                    scatter(odor_crossing(b).time,3,150,'d','filled','MarkerFaceColor',M_O_Color,'MarkerEdgeColor',M_O_Color)  
                elseif isequal(odor_crossing(b).type,{'MtoO'})
                    scatter(odor_crossing(b).time,4,150,'d','filled','MarkerFaceColor',O_M_Color,'MarkerEdgeColor',O_M_Color) 
                elseif isequal(odor_crossing(b).type,{'MtoA'})
                    scatter(odor_crossing(b).time,5,150,'d','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                elseif isequal(odor_crossing(b).type,{'OtoA'})
                    scatter(odor_crossing(b).time,6,150,'d','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                end
            end

            xlabel('time (sec)')
            ylabel('choice ID')
            yticks([1,2,3,4,5,6])
            yticklabels({'A to M','A to O','O to M','M to O','M to A','O to A'})


            hold off

            % Plotting # choices over time

            [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center] = summed_choices(cps,odor_crossing,x_y_time_color);
            figure(fig_count+1)
            fig_count = fig_count+1
            plot(summed_M_choices_ends,summed_O_choices_ends,'LineWidth',4)
    %         plot(x_y_time_color.time,summed_choices_ends,'LineWidth',4,'Color','b')
    %         hold on
    %         plot(x_y_time_color.time,summed_M_choices_ends,'LineWidth',4,'Color',M_O_Color)
    %         plot(x_y_time_color.time,summed_O_choices_ends,'LineWidth',4,'Color',O_M_Color)
    %         xlabel('time (sec)')
    %         ylabel('# of choice')
    %         hold off 
    %         
    %         figure()
    %         plot(x_y_time_color.time,summed_choices_center,'LineWidth',4,'Color','b')
    %         hold on
    %         plot(x_y_time_color.time,summed_M_choices_center,'LineWidth',4,'Color',M_O_Color)
    %         plot(x_y_time_color.time,summed_O_choices_center,'LineWidth',4,'Color',O_M_Color)
    % 
    %         xlabel('time (sec)')
    %         ylabel('# of choice')
    %         
    %         hold off

            % Plotting and calculating speeds
            [speed,speed_tA,fig_count] = Calc_Speed(xy_no_minus_ones,timestamps_no_minus_ones,x_y_time_color.time,fig_count)
            % THIS NEEDS TO BE CHANGED AS AND WHEN MORE FIGURE ARE
            % GENERATED
            if save_fig == 1
                fig_count = 0;
                saveas(figure(1),'pre_reward_summary.jpg')
                saveas(figure(2),'post_reward_summary.jpg')
                saveas(figure(3),'center_choices.jpg')
                saveas(figure(4),'summed_choices_ends.jpg')
                saveas(figure(5),'speed_heatmap.jpg')
                saveas(figure(6),'speed_time.jpg')
                close all
            end    
        end    

        pis = cat(1,pi_pre,pi_post);
        list1 = find(isnan(pis(1,:)) ~= 1);
        list2 = find(isnan(pis(2,:))~= 1);
        list = intersect(list1,list2);
    %     keyboard
    end
    marker_colors = [1,0,0;0,1,0];
    col_pairs = [1,2];
    figure(100)
    scattered_dot_plot(transpose(pis(:, list)),100,1,4,8,marker_colors,1,col_pairs,[0.75,0.75,0.75],[{'pi'},{'expected pi arm-bias'}],1,[0.35,0.35,0.35]);
    % 
    % figure(101)
    % scattered_dot_plot(transpose(cpms(1,list)),101,1,4,8,marker_colors(1,:),1,[],[0.75,0.75,0.75],[{'choices per minute'}],1,[0.35,0.35,0.35]);
end