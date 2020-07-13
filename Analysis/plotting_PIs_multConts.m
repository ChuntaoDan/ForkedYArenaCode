%% Calculate PI from an olfactory arena experiment
function [] = plotting_PIs_multConts(save_fig,lookback)
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
    ave_choice_ratios = [];
    ave_reward_ratios = [];
    
    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);


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
                       
                        figure(fig_count+1)
                        fig_count = fig_count+1
                        hold on
                        for i  = cont_switch(k):cont_switch(k+1)-1
                            if sum(x_y_time_color.color(i) == Air_Color) == 3
                                if sum(x_y_time_color.color(i+1) == Air_Color) == 3
                                    plot(x_y_time_color.time(i:i+1),-1*(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
                                elseif sum(x_y_time_color.color(i+1) == Air_Color) ~= 3
                                    plot(x_y_time_color.time(i:i+1),[-1*(x_y_time_color.distance_up_arm(i)),(x_y_time_color.distance_up_arm(i+1))],'LineWidth',3,'Color',x_y_time_color.color(i,:))
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


                        xlabel('time (sec)');
                        ylabel('distance (pixels)');
                        hold off
                    
                    end  
            
    % 

                    % PLOTTING odor crossings
                    figure (fig_count+1)
                    hold on
                    fig_count = fig_count+1
                    for tt  = cps(2:end)
                        no_match = 1;
                        kk = 0;
                        while no_match == 1
                            kk = kk+1;
                            if sum(x_y_time_color.color(tt-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(tt-kk,:) == M_O_Color )==3
                                dot_color = M_A_Color;
                                no_match = 0;
                                cc = cc+1; 
                                timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
                                scatter(timestamps_summed(cc),1,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                            elseif sum(x_y_time_color.color(tt-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == O_M_Color)==3
                                dot_color = O_A_Color;
                                no_match = 0;
                                cc = cc+1; 
                                timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
                                scatter(timestamps_summed(cc),2,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
                            end 
                        end    
        %                 cc = cc+1; 
        %                 timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
        %                 scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
        %                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)

                    end
                    hold off
                    [odor_crossing] = odor_crossings(region_at_time,air_arm,right_left,timestamps);

                    figure(fig_count+1)
                    fig_count = fig_count+1
                    hold on
                    for b = 1:length(odor_crossing)
                        if isequal(odor_crossing(b).type,{'AtoM'})
                            scatter(odor_crossing(b).time,1,150,'s','filled','MarkerFaceColor',M_A_Color,'MarkerEdgeColor',M_A_Color)
                        elseif isequal(odor_crossing(b).type,{'AtoO'})
                            scatter(odor_crossing(b).time,2,150,'s','filled','MarkerFaceColor',O_A_Color,'MarkerEdgeColor',O_A_Color)
                        elseif isequal(odor_crossing(b).type,{'OtoM'})
                            scatter(odor_crossing(b).time,3,150,'s','filled','MarkerFaceColor',M_O_Color,'MarkerEdgeColor',M_O_Color)  
                        elseif isequal(odor_crossing(b).type,{'MtoO'})
                            scatter(odor_crossing(b).time,4,150,'s','filled','MarkerFaceColor',O_M_Color,'MarkerEdgeColor',O_M_Color) 
                        elseif isequal(odor_crossing(b).type,{'MtoA'})
                            scatter(odor_crossing(b).time,5,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                        elseif isequal(odor_crossing(b).type,{'OtoA'})
                            scatter(odor_crossing(b).time,6,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                        end
                    end

                    xlabel('time (sec)')
                    ylabel('choice ID')
                    yticks([1,2,3,4,5,6])
                    yticklabels({'A to M','A to O','O to M','M to O','M to A','O to A'})


                    hold off

                    % Plotting # choices over time
                    if conts > 1
                        summed_choices_ends = [];
                        summed_choices_center = [];
                        summed_O_choices_ends = [];
                        summed_O_choices_center = [];
                        summed_M_choices_ends = []; 
                        summed_M_choices_center = [];
                        [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center,fig_count,net_summed_choices,choice_order,reward_order,gotofig] = summed_choices_mult_conts(cps,odor_crossing,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,pre_sumM,pre_sumO,baiting)
                        
                    else
                        [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center,fig_count,net_summed_choices,choice_order,reward_order,gotofig] = summed_choices_mult_conts(cps,odor_crossing,x_y_time_color,fig_count,protocol_100_0,reward,conts,gotofig,0,0,baiting)
                        pre_sumM = summed_M_choices_ends(end) ;
                        pre_sumO = summed_O_choices_ends(end);
                        pre_sum = summed_choices_ends(end);
                    end
                    
                    inst_choice_ratio =[];
                    if conts > 1
                        [inst_choice_ratio,inst_income_ratio,ave_choice_ratios(expt_n,cond_n-2,conts),fig_count,ave_reward_ratios(expt_n,cond_n-2,conts),gotofig2] = inst_CR_mult_conts(fig_count,protocol_100_0,choice_order,reward_order,lookback,conts,pre_sum,baiting,reward,gotofig2)
                        pre_sumM = summed_M_choices_ends(end) ;
                        pre_sumO = summed_O_choices_ends(end);
                        pre_sum = summed_choices_ends(end);
                    else
                        [inst_choice_ratio,inst_income_ratio,ave_choice_ratios(expt_n,cond_n-2,conts),fig_count,ave_reward_ratios(expt_n,cond_n-2,conts),gotofig2] = inst_CR_mult_conts(fig_count,protocol_100_0,choice_order,reward_order,lookback,conts,0,baiting,reward,gotofig2)
                    end
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

%                     % Plotting and calculating speeds
%                     [speed,speed_tA,fig_count] = Calc_Speed(xy_no_minus_ones,timestamps_no_minus_ones,x_y_time_color.time,fig_count)
%                     hold on
% 
%                     for tt  = cps(2:end)
%                         no_match = 1;
%                         kk = 0;
%                         while no_match == 1
%                             kk = kk+1;
%                             if sum(x_y_time_color.color(tt-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(tt-kk,:) == M_O_Color )==3
%                                 dot_color = M_A_Color;
%                                 no_match = 0;
%                                 cc = cc+1; 
%                                 timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
%                                 scatter(timestamps_summed(cc),0,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
%                             elseif sum(x_y_time_color.color(tt-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == O_M_Color)==3
%                                 dot_color = O_A_Color;
%                                 no_match = 0;
%                                 cc = cc+1; 
%                                 timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
%                                 scatter(timestamps_summed(cc),0,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
%                             end 
%                         end    
%         %                 cc = cc+1; 
%         %                 timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
%         %                 scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
%         %                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
% 
%                     end
                       

            end   
            % THIS NEEDS TO BE CHANGED AS AND WHEN MORE FIGURE ARE
                    % GENERATED
            if save_fig == 1 %&&  exist('speed_time.fig') ~= 2

                for fc = 1:fig_count
                    if fig_count == gotofig
                        saveas(figure(gotofig),'summed_choices_ends.fig')
                    elseif fig_count == gotofig2
                        saveas(figure(gotofig2),'inst_CR_lb10.fig')
                    else
                        saveas(figure(fc),sprintf('figure%d.fig',fc))
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
%                         save('choice_order.mat','choice_order')
%                         save('reward_order.mat','reward_order')
%                         close all
                pause(60)
%                     elseif save_fig == 1 && exist('speed_time.fig') == 2
%                         fig_count = 0;
%                         keyboard
                close all
                fig_count = 0;
            end 
        end

%             pis = cat(1,pi_pre,pi_post);
%             list1 = find(isnan(pis(1,:)) ~= 1);
%             list2 = find(isnan(pis(2,:))~= 1);
%             list = intersect(list1,list2);
%         keyboard
    end
    
%     keyboard
    
    figure(599)
    ax = polaraxes;
    for k = 1:length(ave_choice_ratios)
        t = deg2rad(ave_choice_ratios(k));
        polarplot(ax,[t;t],[0;1],'Color','b')
        hold on
    end
    ax.ThetaLim = [0 90];
%     
%     marker_colors = [1,0,0;0,1,0];
%     col_pairs = [1,2];
%     figure(600)
%     scattered_dot_plot(transpose(pis(:, list)),100,1,4,8,marker_colors,1,col_pairs,[0.75,0.75,0.75],[{'PI - pre reward'},{'PI - post reward (OCT)'}],1,[0.35,0.35,0.35]);
%     
    cd(expt_name)
    
    save('ave_CR.mat','ave_choice_ratios')
    save('ave_IR.mat','ave_reward_ratios')

    
    % 
    % figure(101)
    % scattered_dot_plot(transpose(cpms(1,list)),101,1,4,8,marker_colors(1,:),1,[],[0.75,0.75,0.75],[{'choices per minute'}],1,[0.35,0.35,0.35]);
end