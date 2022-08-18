function [p_r_OCT,choice_time_full, choice_time_from_entry, choice_time_full_OCT, choice_time_full_MCH, choice_time_from_entry_OCT, choice_time_from_entry_MCH] = plotting_turns_choiceSpeed_multconts()
%     close all
%     clear
%     clc

    % Select spreadsheet containing experiment names
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)


    individual_pi = [];
    arm_bias_expected_pi = [];
    count_data = 0;
    cpms = [];
    fig_count = 0;
    p_r_OCT = [];
    choice_time_full = [];
    choice_time_from_entry = [];
    choice_time_full_OCT = [];
    choice_time_full_MCH = [];
    choice_time_from_entry_OCT = [];
    choice_time_from_entry_MCH = [];
    local_maxima_MCH = [];
    local_maxima_OCT = [];
    locs_MCH = [];
    locs_OCT = [];
    
    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);
    
    for expt_n = 1:2%length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);

        for cond_n =1:length(conds)
            count_data = count_data+1;
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
                
                continue
                %SKIPPING LOW MI EXPTS FOR GR64f
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
            conts = dir(cond);
            length_conts = 0;
            for ct = 1:length(conts)
                if endsWith(conts(ct).name,'.mat')
                    length_conts = length_conts + 1;
                end
            end    

            if length_conts == 9
                subt = 8;
            elseif length_conts == 12
                subt = 10;
            elseif length_conts == 16
                subt = 13;
            elseif length_conts == 15
                subt = 12;
            else    
                subt = 9;
            end  
            
%             for conts = [1,1.25,1.75,2.25]
%                 conts_name = conts;
%                 conts = find([1,1.25,1.75,2.25]==conts_name);
%             for conts = 1:0.75:1.75% THIS IS SOME WEIRDNESS FOR twoblock 100-0 expts remove for others 
              for conts = 1:length_conts-subt % this set of expts has 3 conts
               % this set of expts has 3 conts
                
                load(sprintf('all_variables_contingency_%d.mat',conts))
                   
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

                individual_pi(expt_n,cond_n-2,ceil(conts)) = pi;
                arm_bias_expected_pi(expt_n,cond_n-2,ceil(conts)) = arm_bias_pi;
                cpms(expt_n,cond_n-2,ceil(conts)) = choicesperminute(air_arm,time);

% THE FOLLOWING COMMENTED SECIONT IS A SECOND METHOD FOR CALCULATING TURSN
% THAT WAS NOT USED IN THE PAPER. 
%                 dua = x_y_time_color.distance_up_arm;
%                 peak_count_MCH = 0;
%                 peak_count_OCT = 0;
%                 [local_maxima,locs] = findpeaks(dua,'MinPeakProminence',20);
%                 tp = 1;
%               
% 
%                 while tp < length(dua)
%                     TP = tp;
%                     if dua(tp) == 0
%                         k = 0;
%                         while k < 100
%                         k = k+1;
%                         if sum(x_y_time_color.color(tp+k,:) == O_A_Color)== 3 ||sum(x_y_time_color.color(tp+k,:) == O_M_Color)== 3
%                             peak_count_OCT = peak_count_OCT + 1;
%                             [tempPks,tempLocs] = findpeaks(dua(tp:end),'MinPeakProminence',20);
%                             local_maxima_OCT(count_data,ceil(conts),peak_count_OCT) = tempPks(1);
%                             locs_OCT(count_data,ceil(conts),peak_count_OCT) = tempLocs(1)+tp;
%                             tp = tempLocs(1)+tp;
%                             k = 100
%                         elseif sum(x_y_time_color.color(tp+k,:) == M_A_Color)== 3 ||sum(x_y_time_color.color(tp+k,:) == M_O_Color)== 3
%                             peak_count_MCH = peak_count_MCH + 1;
%                             [tempPks,tempLocs] = findpeaks(dua(tp:end),'MinPeakProminence',20);
%                             local_maxima_MCH(count_data,ceil(conts),peak_count_MCH) = tempPks(1);
%                             locs_MCH(count_data,ceil(conts),peak_count_MCH) = tempLocs(1)+tp;
%                             tp = tempLocs(1)+tp;
%                             k = 100
%                         end
%                         end
%                         if k ==100
%                             tp = tp+1;
%                         end
% 
%                     else
%                         tp = tp+1;
%                     end 
%                 end    
%       
%                 max_time = max(x_y_time_color.time);
%                 
%                 num_figs = ceil(max_time/1800);
%                 cont_switch(1) = 1;
%                 if num_figs > 1
%                     for yy = 2:num_figs
%                         cont_switch(yy) = find(x_y_time_color.time > (yy-1)*1800,1);
%                     end
% 
%                 end    
%                 cont_switch(num_figs+1) = length(x_y_time_color.time);
%                 for k = 1:num_figs
%                     if length(find(x_y_time_color.time(locs_OCT) > k*1800,1)) ==1
%                         splt_OCT(k) = find(x_y_time_color.time(locs_OCT) > k*1800,1);
%                     else
%                         splt_OCT(k) = 0;
%                     end   
%                     if length(find(x_y_time_color.time(locs_MCH) > k*1800,1)) ==1
%                         splt_MCH(k) = find(x_y_time_color.time(locs_MCH) > k*1800,1);
%                     else
%                         splt_MCH(k) = 0;
%                     end  
%                     figure(fig_count+1)
%                     fig_count = fig_count+1
%                     hold on
%                     for i  = cont_switch(k):cont_switch(k+1)-1
%                         if sum(x_y_time_color.color(i) == Air_Color) == 3
%                             if sum(x_y_time_color.color(i+1) == Air_Color) == 3
%                                 plot(x_y_time_color.time(i:i+1),-1*(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
%                             elseif sum(x_y_time_color.color(i+1) == Air_Color) ~= 3
%                                 plot(x_y_time_color.time(i:i+1),[-1*(x_y_time_color.distance_up_arm(i)),(x_y_time_color.distance_up_arm(i+1))],'LineWidth',3,'Color',x_y_time_color.color(i,:))
%                             end    
%                         else
%                             if sum(x_y_time_color.color(i+1) == Air_Color) == 3
% %                                 plot(x_y_time_color.time(i:i+1),[x_y_time_color.distance_up_arm(i),-1*(x_y_time_color.distance_up_arm(i))],'LineWidth',3,'Color',Air_Color)
%                             else
%                                 plot(x_y_time_color.time(i:i+1),(x_y_time_color.distance_up_arm(i:i+1)),'LineWidth',3,'Color',x_y_time_color.color(i,:))
%                             end    
%                         end
%                     end 
%                     cc = 0;
%                     timestamps_summed = [];
%                     for tt  = cps(max(find(cps<cont_switch(k)+1))+1:max(find(cps<cont_switch(k+1))))
%                         no_match = 1;
%                         kk = 0;
%                         while no_match == 1
%                             kk = kk+1;
%                             if sum(x_y_time_color.color(tt-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(tt-kk,:) == M_O_Color )==3
%                                 dot_color = M_A_Color;
%                                 no_match = 0;
%                             elseif sum(x_y_time_color.color(tt-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(tt-kk,:) == O_M_Color)==3
%                                 dot_color = O_A_Color;
%                                 no_match = 0;
%                             end 
%                         end    
%                         cc = cc+1; 
%                         timestamps_summed(cc) = sum(timestamps_no_minus_ones(1:tt));
%                         scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
% 
% %                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
%                     end
% 
%                     if k == 1
%                         if splt_OCT(k)== 0
%                             scatter(x_y_time_color.time(locs_OCT(1:end)),local_maxima_OCT(1:end),'filled','g')
%                         else
%                             scatter(x_y_time_color.time(locs_OCT(1:splt_OCT(k))),local_maxima_OCT(1:splt_OCT(k)),'filled','g')
%                         end
%                         
%                     else
%                         if splt_OCT(k) ~= 0
%                            scatter(x_y_time_color.time(locs_OCT(splt_OCT(k-1):splt_OCT(k))),local_maxim_OCT(splt_OCT(k-1):splt_OCT(k)),'filled','g')
%                         else
%                            keyboard
%                            scatter(x_y_time_color.time(locs_OCT(splt_OCT(k-1):end)),local_maxima_OCT(splt_OCT(k-1):end),'filled','g')
%                         end
%                     end 
%                     
%                     if k == 1
%                         if splt_MCH(k)== 0
%                             scatter(x_y_time_color.time(locs_MCH(1:end)),local_maxima_MCH(1:end),'filled','r')
%                         else
%                             scatter(x_y_time_color.time(locs_MCH(1:splt_MCH(k))),local_maxima_MCH(1:splt_MCH(k)),'filled','r')
%                         end
%                         
%                     else
%                         if splt_MCH(k) ~= 0
%                            scatter(x_y_time_color.time(locs_MCH(splt_MCH(k-1):splt_MCH(k))),local_maxim_MCH(splt_MCH(k-1):splt_MCH(k)),'filled','r')
%                         else
%                            scatter(x_y_time_color.time(locs_MCH(splt_MCH(k-1):end)),local_maxima_MCH(splt_MCH(k-1):end),'filled','r')
%                         end
%                     end 
% 
%                     xlabel('time (sec)');
%                     ylabel('distance (pixels)');
%                     hold off
%                     
%                     
%                     
%                 end  
                    
                choice_time_full(count_data,ceil(conts),1:length(cps)-1) = cps(2:end)-cps(1:end-1);
                c_OCT = 0;
                c_MCH = 0;
                for ch = 1:length(cps)-1
                    first_chosen_arm = [];
                    region_at_time_choice = 0;
                    kk = 0;
                    while region_at_time_choice == 0
                        region_at_time_choice = region_at_time(cps(ch+1)+kk);
                        if region_at_time_choice ~= 0
                            first_chosen_arm = mod(region_at_time(cps(ch+1)+kk),3);
                        end
                        kk = kk+1;
                    end
                    if isempty(first_chosen_arm) == 1
                        continue
                    end    

                    if first_chosen_arm == 0
                        first_chosen_arm = 3;
                    end    
        
                    first_chosen_arm_entry = find (region_at_time(cps(ch):cps(ch+1))== first_chosen_arm,1);
                     if isempty(first_chosen_arm_entry) == 1
                        continue
                    end    
                    
                    choice_time_from_entry(count_data,ceil(conts),ch) = cps(ch+1) - cps(ch) - first_chosen_arm_entry;
                
                    if sum(x_y_time_color.color(cps(ch+1)-1,:) == O_A_Color)== 3 ||sum(x_y_time_color.color(cps(ch+1)-1,:) == O_M_Color)== 3
                        c_OCT = c_OCT + 1;  
                        choice_time_from_entry_OCT(count_data,ceil(conts),c_OCT) = choice_time_from_entry(count_data,ceil(conts),ch);
                        choice_time_full_OCT(count_data,ceil(conts),c_OCT) = choice_time_full(count_data,ceil(conts),ch);
                    elseif sum(x_y_time_color.color(cps(ch+1)-1,:) == M_A_Color)== 3 ||sum(x_y_time_color.color(cps(ch+1)-1,:) == M_O_Color)== 3
                        c_MCH = c_MCH + 1;  
                        choice_time_from_entry_MCH(count_data,ceil(conts),c_MCH) = choice_time_from_entry(count_data,ceil(conts),ch);
                        choice_time_full_MCH(count_data,ceil(conts),c_MCH) = choice_time_full(count_data,ceil(conts),ch);
                    end

                end  

                
                
                
                p_r_OCT(count_data,ceil(conts),ch) = x;

               
                
            end
        end
    end
end
