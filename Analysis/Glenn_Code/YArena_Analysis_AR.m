% cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')

cd('/Volumes/SSD2TB/OlfactoryYMaze/');

% Load excel sheet containing the various folders that data is stored in 
% folders should be divided by condition . Eg. Sham, Ablated
% EXCEL sheet should contain the full path to the folder that contains the
% data. One path per cell. An example excel sheet can be found at : 
% smb://dm11.hhmi.org/turnerlab/Adithya/Analysis_List.xls
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');
[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)
save_fig = 1;
% Initializing percentage correct matrices
% these matrices will contain the percentage of times the "correct" option was
% chosen during the entire block underconsideration
p_correct_naive_mat = zeros(length(expts), 1);
p_correct_rewarded_mat = zeros(length(expts), 1);
% These matrices will contain the percentage of times the "correct" option
% was chosen in the second half of the block under consideration
p_correct_naive_half_mat = zeros(length(expts), 1);
p_correct_rewarded_half_mat = zeros(length(expts), 1);

num_turns_away_rewarded = zeros(4,50,4);
num_turns_away_unrewarded = zeros(4,50,4);
time_turns_away_rewarded = [];
time_turns_away_unrewarded = [];

time_per_choice = zeros(4,50,160);

%Loop through expts - lines in excel sheet eg. Sham, Ablated
for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    % Loop through the folders containing the individual fly's data for a
    % given condition/expt
    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
%             count = count+1;
            continue
        end

        % Change directory to file containing data 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        
        load('YArenaRunData.mat')
        
        % Find all the times when flies made a choice the Y reset
        ChoiceFrames = find(AirArmMat==0) ;
        ChoiceFrames = ChoiceFrames(2:end) ;
        % Find Pre and PostChoice frames
        PreChoiceFrames  = ChoiceFrames - 1 ;
        PostChoiceFrames = ChoiceFrames + 1 ;
        % Find PreChoice & PostChoice Arms
        PreChoiceArm  = AirArmMat(PreChoiceFrames) ;
        PostChoiceArm = AirArmMat(PostChoiceFrames) ;
        ChoiceDirection = [PreChoiceArm PostChoiceArm] ;

        Choices = [] ;
        % ArmRandomizerMat is indexed by frames but I need it indexed by choices
        for n = 1:TrialCounter-1 ; % Was TotalTrials
            % When fly makes a RIGHT turn
            if isequal(ChoiceDirection(n,:),[1 3]) || isequal(ChoiceDirection(n,:),[2 1]) || isequal(ChoiceDirection(n,:),[3 2])        
                % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                if ArmRandomizerMat(n) == 0
                    Odor = 'OCT' ;
                    OdorChoice = 1 ;
                % When ArmRandomizer=1 RIGHT = MCH & LEFT = OCT
                elseif ArmRandomizerMat(n) == 1
                    Odor = 'MCH' ;
                    OdorChoice = 0 ;
                end
                % When fly makes a LEFT turn
            elseif isequal(ChoiceDirection(n,:),[1 2]) || isequal(ChoiceDirection(n,:),[2 3]) || isequal(ChoiceDirection(n,:),[3 1])
                % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                if ArmRandomizerMat(n) == 0
                    Odor = 'MCH' ;
                    OdorChoice = 0 ;
                % When ArmRandomizer=1 RIGHT = MCH & LEFT = OCT
                elseif ArmRandomizerMat(n) == 1
                    Odor = 'OCT' ;
                    OdorChoice = 1 ;
                end
            end
            Choices = [Choices OdorChoice] ;
        end
        
        % Plotting the raster plot
        f = figure;
        f.Position = [50 500 1500 200];
        plot(Choices,'.','markersize',28);
        ylim([-2 3])
        set(gca,'box','off','ytick',[])
        NumOCT = length(find(Choices==1)) ;
        NumMCH = length(find(Choices==0)) ;
        disp(['OCT/MCH = ' num2str(NumOCT) '/' num2str(NumMCH) ' = ' num2str(NumOCT/(NumOCT+NumMCH))])

        % saving raster plot
        saveas(gcf,'ChoiceRaster') ; 
        %         
        
        
        PlotChoices = Choices ;
        FlipChoices = abs(PlotChoices-1);

        
        % Determining the dominant or "correct" odor

        if sum(P_RewardMCH) > sum(P_RewardOCT)
            DominantOdor = 0 ;
        elseif sum(P_RewardOCT) > sum(P_RewardMCH)
            DominantOdor = 1 ;
        end

        switch DominantOdor
            case 0 %  P_Reward_MCH > P_Reward_OCT
                Cumul_Correct = cumsum(FlipChoices) ;
                Cumul_Error   = cumsum(PlotChoices) ;
            case 1 % P_Reward_OCT > P_Reward_MCH
                Cumul_Correct = cumsum(PlotChoices) ;
                Cumul_Error   = cumsum(FlipChoices) ;
        end

        figure;
        plot(Cumul_Error,Cumul_Correct,'linewidth',3)
        line([0,length(PlotChoices)],[0,length(PlotChoices)],'color','black','LineStyle','--')
        axis equal
        axis([0 length(PlotChoices) 0 length(PlotChoices)])
        xlabel('# Error Choices','FontSize',18)
        ylabel('# Correct Choices','FontSize',18)

        % To add a marker indicating when reward switched on
        % It would be useful to derive this generally using the reward probabiilities vector
        % itself i.e. P_RewardMCH
        hold on
        if NumBlocks == 2
            plot(Cumul_Error(41),Cumul_Correct(41),'r.','markersize',32)


        elseif NumBlocks == 3
            plot(Cumul_Error(81),Cumul_Correct(81),'r.','markersize',32)
            plot(Cumul_Error(161),Cumul_Correct(161),'r.','markersize',32)
        end
        saveas(gcf,'LearningCurve')
        save('YArenaRunLearningCurve.mat')

        
        color_vec = cbrewer('qual','Dark2',10,'cubic');
        Air_Color = 0*color_vec(6,:);
        O_A_Color = color_vec(1,:);
        O_M_Color = 0.6*color_vec(1,:);
        M_A_Color = color_vec(7,:);
        M_O_Color = 0.7*color_vec(7,:);
        
        Fly_xy_noNan = [];
        TimeStampMat_noNan = [];
        
        for i = 1:length(FlySpotsMat)
            if sum(isnan(FlySpotsMat(i).Centroid) == [0 0]) == 2 
                Fly_xy_noNan = [Fly_xy_noNan; FlySpotsMat(i).Centroid];
                TimeStampMat_noNan = [TimeStampMat_noNan; TimeStampMat(i,:)];
            end
        end    
        
        TimeSecsMat = [];
        MultFact = [0;0;24*60*60;60*60;60;1];
        
        for j = 1:length(TimeStampMat_noNan)
            TimeDiff = TimeStampMat_noNan(j,:) - TimeStampMat_noNan(1,:);
            TimeSecsMat(j) = TimeDiff*MultFact;
        end
        
        % ASSIGNING COLOR TO TIMEPOINT
        OdorColorMat = [];
        Cpt_count = 0;
        for k = 1:length(Fly_xy_noNan)
            if AirArmMat(k) == 0 
                Cpt_count = Cpt_count+1;
            end    
            if CurrentArmMat(k) == AirArmMat(k)
                OdorColorMat(k,:) = Air_Color;
            elseif AirArmMat(k) == 0
                OdorColorMat(k,:) = Air_Color;
            else
                if AirArmMat(k) == 1 && ArmRandomizerMat(Cpt_count) == 0
                 % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                    if CurrentArmMat(k) == 3
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 2
                        OdorColorMat(k,:) = M_A_Color;
                    end
                elseif AirArmMat(k) == 1 && ArmRandomizerMat(Cpt_count) == 1
                 % When ArmRandomizer=1 LEFT = OCT & RIGHT = MCH
                    if CurrentArmMat(k) == 2
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 3
                        OdorColorMat(k,:) = M_A_Color;
                    end 
                elseif AirArmMat(k) == 2 && ArmRandomizerMat(Cpt_count) == 0
                 % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                    if CurrentArmMat(k) == 1
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 3
                        OdorColorMat(k,:) = M_A_Color;
                    end
                elseif AirArmMat(k) == 2 && ArmRandomizerMat(Cpt_count) == 1
                 % When ArmRandomizer=1 LEFT = OCT & RIGHT = MCH
                    if CurrentArmMat(k) == 3
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 1
                        OdorColorMat(k,:) = M_A_Color;
                    end     
                elseif AirArmMat(k) == 3 && ArmRandomizerMat(Cpt_count) == 0
                 % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                    if CurrentArmMat(k) == 2
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 1
                        OdorColorMat(k,:) = M_A_Color;
                    end
                elseif AirArmMat(k) == 3 && ArmRandomizerMat(Cpt_count) == 1
                 % When ArmRandomizer=1 LEFT = OCT & RIGHT = MCH
                    if CurrentArmMat(k) == 1
                        OdorColorMat(k,:) = O_A_Color;
                    elseif CurrentArmMat(k) == 2
                        OdorColorMat(k,:) = M_A_Color;
                    end    
                end
            end
        end    
        % CALCULATING DISTANCE FROM CENTER AT TIMEPOINT
        %DISTANCE TRAVELLED UP ARM RELATIVE TO A SKELETON IN THE CENTER OF
        %THE ARM.

        % This set of coordinates need to be checked/updated for each
        % batch of experiments, in case the camera moved
        p0 = [565,644];
        v1 = [559,177;565,644];
        v2 = [970,874;565,644];
        v3 = [165,887;565,644];

        DistanceUpArmMat = [];
        for l = 1:length(Fly_xy_noNan)
            if CurrentArmMat(l) == 1
                pt_on_line = proj_pt(v1,[Fly_xy_noNan(l,1),Fly_xy_noNan(l,2)]);
                distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
                DistanceUpArmMat(l) = distance_traveled;
            elseif CurrentArmMat(l) == 2
                pt_on_line = proj_pt(v2,[Fly_xy_noNan(l,1),Fly_xy_noNan(l,2)]);
                distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
                DistanceUpArmMat(l) = distance_traveled;     
            elseif CurrentArmMat(l) == 3
                pt_on_line = proj_pt(v3,[Fly_xy_noNan(l,1),Fly_xy_noNan(l,2)]);
                distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
                DistanceUpArmMat(l) = distance_traveled;
            end
        end
        
        % PLOTTING position vs time with different colors for different
        % odors in arm
%         fig_count = 2;
%         max_time = max(TimeSecsMat);
% 
%         num_figs = ceil(max_time/1800);
%         cont_switch(1) = 1;
%         if num_figs > 1
%             for yy = 2:num_figs
%                 cont_switch(yy) = find(TimeSecsMat > (yy-1)*1800,1);
%             end
% 
%         end    
%         cont_switch(num_figs+1) = length(TimeSecsMat);
%         for k = 1:num_figs
%             figure(fig_count+1)
%             fig_count = fig_count+1
%             hold on
%             for i  = cont_switch(k):cont_switch(k+1)-1
%                 if sum(OdorColorMat(i,:) == Air_Color) == 3
%                     if sum(OdorColorMat(i+1) == Air_Color) == 3
%                         plot(TimeSecsMat(i:i+1),-1*(DistanceUpArmMat(i:i+1)),'LineWidth',3,'Color',OdorColorMat(i,:))
%                     elseif sum(OdorColorMat(i+1,:) == Air_Color) ~= 3
%                         plot(TimeSecsMat(i:i+1),[-1*(DistanceUpArmMat(i)),(DistanceUpArmMat(i+1))],'LineWidth',3,'Color',OdorColorMat(i,:))
%                     end    
%                 else
%                     if sum(OdorColorMat(i+1) == Air_Color) == 3
% %                                 plot(x_y_time_color.time(i:i+1),[x_y_time_color.distance_up_arm(i),-1*(x_y_time_color.distance_up_arm(i))],'LineWidth',3,'Color',Air_Color)
%                     else
%                         plot(TimeSecsMat(i:i+1),(DistanceUpArmMat(i:i+1)),'LineWidth',3,'Color',OdorColorMat(i,:))
%                     end    
%                 end
%             end 
%             cc = 0;
%             timestamps_summed = [];
%             cps = find(AirArmMat == 0);
% %             keyboard
% %             cps = cps(2:end);
%             for tt  = [max(find(cps<cont_switch(k)+1))+1:max(find(cps<cont_switch(k+1)))]
%                 tt;
%                 no_match = 1;
%                 kk = 0;
%                 while no_match == 1
%                     kk = kk+1;
%                     if sum(OdorColorMat(cps(tt)-kk,:) == M_A_Color )==3 %|| sum(OdorColorMat(tt-kk,:) == M_O_Color )==3
%                         dot_color = M_A_Color;
%                         no_match = 0;
%                     elseif sum(OdorColorMat(cps(tt)-kk,:) == O_A_Color)==3 %||sum(OdorColorMat(tt-kk,:) == O_M_Color)==3
%                         dot_color = O_A_Color;
%                         no_match = 0;
%                     end 
%                 end    
%                 cc = cc+1; 
%                 timestamps_summed = [timestamps_summed, TimeSecsMat(cps(tt))];
% %                 keyboard
%                 scatter(timestamps_summed(cc),460,200,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
% 
% %                         scatter(timestamps_summed(cc),1,100,'s','filled','MarkerEdgeColor',dot_color,'MarkerFaceColor',dot_color)
%             end
% 
% 
%             xlabel('time (sec)');
%             ylabel('distance (pixels)');
%             hold off
% 
%         end  
%         
%         if save_fig == 1 %&&  exist('figure1.fig') ~= 2
% 
%             for fc = 3:fig_count
%                     saveas(figure(fc),sprintf('figure%d.fig',fc))    
%             end
% 
% %             pause(60)
% %                     elseif save_fig == 1 && exist('speed_time.fig') == 2
% %                         fig_count = 0;
% 
% 
% 
%         end
%         
%         close all
%         
        % Odor Crossings
       

        [odor_crossing] = odor_crossings_GT_Yversion(CurrentArmMat,AirArmMat,ArmRandomizerMat,TimeSecsMat);

        
        figure%(fig_count+1)
%         fig_count = fig_count+1;
        hold on
        
        
        for b = 1:length(odor_crossing)
            if isequal(odor_crossing(b).type,{'AtoM'})
                scatter(odor_crossing(b).time,1,150,'s','filled','MarkerFaceColor',M_A_Color,'MarkerEdgeColor',M_A_Color)
            elseif isequal(odor_crossing(b).type,{'AtoO'})
                scatter(odor_crossing(b).time,2,150,'s','filled','MarkerFaceColor',O_A_Color,'MarkerEdgeColor',O_A_Color)
            elseif isequal(odor_crossing(b).type,{'OtoM'})
                scatter(odor_crossing(b).time,3,150,'s','filled','MarkerFaceColor',M_O_Color,'MarkerEdgeColor',M_O_Color)  
                if DominantOdor == 0
                    num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                elseif DominantOdor == 1
                    num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                end     
            elseif isequal(odor_crossing(b).type,{'MtoO'})
                scatter(odor_crossing(b).time,4,150,'s','filled','MarkerFaceColor',O_M_Color,'MarkerEdgeColor',O_M_Color) 
                if DominantOdor == 1
                    num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                elseif DominantOdor == 0
                    num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                end 
            elseif isequal(odor_crossing(b).type,{'MtoA'})
                scatter(odor_crossing(b).time,5,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                if DominantOdor == 1
                    num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                elseif DominantOdor == 0
                    num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                end 
            elseif isequal(odor_crossing(b).type,{'OtoA'})
                scatter(odor_crossing(b).time,6,150,'s','filled','MarkerFaceColor',Air_Color,'MarkerEdgeColor',Air_Color)
                if DominantOdor == 0
                    num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_rewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                elseif DominantOdor == 1
                    num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts)) = num_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts))+1;
                    time_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) = odor_crossing(b).time_pt_in_vector;
                    dist_turns_away_unrewarded(expt_n,cond_n-2,ceil(odor_crossing(b).conts),b) =  DistanceUpArmMat(odor_crossing(b).time_pt_in_vector);
                end 
            end
        end

        xlabel('time (sec)')
        ylabel('choice ID')
        yticks([1,2,3,4,5,6])
        yticklabels({'A to M','A to O','O to M','M to O','M to A','O to A'})


        hold off
        
        saveas(gcf,'OdorCrossings')
        save('OdorCrossings.mat','odor_crossing')
        
        % Time between Choices
        if expt_n == 1 ||expt_n == 2
            [time_per_choice(expt_n,cond_n-2,1:length(PlotChoices)-1)]  = time_per_choice_fn_GTY(OdorColorMat,TimeSecsMat,ChoiceFrames);
        elseif expt_n == 3 ||expt_n == 4
            [time_per_choice(expt_n,cond_n-2,1:length(PlotChoices)-1)]  = time_per_choice_fn_GTY(OdorColorMat,TimeSecsMat,ChoiceFrames);
        end
            
        % Calculating % correct for OCT v MCH choices in naive and rewarded
        % conditions
        
        if NumBlocks == 2 
            if DominantOdor == 0
                % when the number here says 40 it implies the first 40
                % trials are being searched to find the number of rewarded options.
                % Change this number to indicate how many trials are to be
                % searched.
                p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(1:40) == 0))/length(Choices(1:40)); 
                % here trial 41 onwards are being searched
                p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(41:end) == 0))/length(Choices(41:end));
                % IN the next two lines only half of a block of trials is
                % being used to calculate percentage correct indicated by
                % the values 21 and 40 that indicate the second half of
                % trials in the 40 trial naive block
                p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
                p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 0))/length(Choices(71:end));
            % The numbers in the brackets are all play similar roles and can be interpretted the same way for the next several lines 
            elseif DominantOdor == 1
                p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(1:40) == 1))/length(Choices(1:40));
                p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(41:end) == 1))/length(Choices(41:end));
                p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 1))/length(Choices(21:40));
                p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 1))/length(Choices(71:end));
            end
        elseif NumBlocks == 3
%             if DominantOdor == 0
%                 CR_1_mat(expt_n,cond_n-2) = length(find(Choices(1:80) == 0))/length(find(Choices(1:80) == 1));
%                 CR_2_mat(expt_n,cond_n-2) = length(find(Choices(81:160) == 0))/length(find(Choices(81:160) == 1));
%                 CR_3_mat(expt_n,cond_n-2) = length(find(Choices(161:end) == 0))/length(find(Choices(161:end) == 1));
%                 
%             elseif DominantOdor == 1
%                 p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(41:80) == 1))/length(find(Choices(41:80) == 1));
%                 p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(81:120) == 1))/length(Choices(81:120));
%                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(61:80) == 1))/length(Choices(61:80));
%                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(101:120) == 1))/length(Choices(101:120));
%             end
        end
        
        % Calculating % correct for Air v OCT choices in naive and rewarded
        % conditions
%         
%         if expt_n == 3 || expt_n == 4 % Corresponding to v1 of either sham or ablated flies where 40 trials were naive and 60 were rewarded
%             if DominantOdor == 0
%                 p_correct_naive_A_O_mat_Mrew(expt_n,cond_n-2) = length(find(Choices(1:20) == 0))/length(Choices(1:20));
%                 p_correct_rewarded_A_O_mat_Mrew(expt_n,cond_n-2) = length(find(Choices(141:end) == 0))/length(Choices(141:end));
% %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
% %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 0))/length(Choices(71:end));
%             elseif DominantOdor == 1
%                 p_correct_naive_A_O_mat_Orew(expt_n,cond_n-2) = length(find(Choices(1:20) == 1))/length(Choices(1:20));
%                 p_correct_rewarded_A_O_mat_Orew(expt_n,cond_n-2) = length(find(Choices(141:end) == 1))/length(Choices(141:end));
% %                 p_correct_naive_half_A_O_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 1))/length(Choices(21:40));
% %                 p_correct_rewarded_half_A_O_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 1))/length(Choices(71:end));
%             end
% %         elseif expt_n == 4
% %             if DominantOdor == 0
% % %                 p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(41:80) == 0))/length(Choices(41:80));
% % %                 p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(81:120) == 0))/length(Choices(81:120));
% % %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(61:80) == 0))/length(Choices(61:80));
% % %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(101:120) == 0))/length(Choices(101:120));
% %             elseif DominantOdor == 1
% %                 p_correct_naive_A_O_mat(expt_n,cond_n-2) = length(find(Choices(1:20) == 1))/length(Choices(1:20));
% %                 p_correct_rewarded_A_O_mat(expt_n,cond_n-2) = length(find(Choices(141:end) == 1))/length(Choices(141:end));
% % %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(61:80) == 1))/length(Choices(61:80));
% % %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(101:120) == 1))/length(Choices(101:120));
% %             end
%         end
% %         
%         % Calculating % correct for Air v MCH choices in naive and rewarded
%         % conditions
%         
%         if expt_n == 3 || expt_n == 4% Corresponding to v1 of either sham or ablated flies where 40 trials were naive and 60 were rewarded
% %             if DominantOdor == 0
%                 p_correct_naive_A_M_mat_Mrew(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
%                 p_correct_rewarded_A_M_mat_Mrew(expt_n,cond_n-2) = length(find(Choices(121:140) == 0))/length(Choices(121:140));
% %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
% %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 0))/length(Choices(71:end));
%             if DominantOdor == 1
%                 p_correct_naive_A_M_mat_Orew(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
%                 p_correct_rewarded_A_M_mat_Orew(expt_n,cond_n-2) = length(find(Choices(121:140) == 0))/length(Choices(121:140));
% %                 p_correct_naive_half_A_O_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 1))/length(Choices(21:40));
% %                 p_correct_rewarded_half_A_O_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 1))/length(Choices(71:end));
%             end
% %         elseif expt_n == 4
% % %             if DominantOdor == 0
% % %                 p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(41:80) == 0))/length(Choices(41:80));
% % %                 p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(81:120) == 0))/length(Choices(81:120));
% % %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(61:80) == 0))/length(Choices(61:80));
% % %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(101:120) == 0))/length(Choices(101:120));
% %             if DominantOdor == 1
% %                 p_correct_naive_A_M_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
% %                 p_correct_rewarded_A_M_mat(expt_n,cond_n-2) = length(find(Choices(121:140) == 0))/length(Choices(121:140));
% % %                 p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(61:80) == 1))/length(Choices(61:80));
% % %                 p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(101:120) == 1))/length(Choices(101:120));
% %             end
%         end
    end
end

keyboard

save('time_per_choice.mat','time_per_choice');
save('num_turns_rewarded.mat','num_turns_away_rewarded');
save('num_turns_unrewarded.mat','num_turns_away_unrewarded');
save('p_correct_naive.mat','p_correct_naive_mat');
save('p_correct_rewarded.mat','p_correct_rewarded_mat');

% PLOTTING PREFERENCES FOR MCH V OCT TRIALS ONLY
%plotting sham
figure
notBoxPlot(100*cat(2,p_correct_naive_half_mat(1,1:3),p_correct_naive_half_mat(2,1:end)),3)
notBoxPlot(100*cat(2,p_correct_rewarded_half_mat(1,1:3),p_correct_rewarded_half_mat(2,1:end)),4)
[h,p] = ttest(cat(2,p_correct_rewarded_half_mat(1,1:3),p_correct_rewarded_half_mat(2,1:end)),cat(2,p_correct_naive_half_mat(1,1:3),p_correct_naive_half_mat(2,1:end)))

%Plotting ablated
% figure
notBoxPlot(100*cat(2,p_correct_naive_half_mat(3,1:5),p_correct_naive_half_mat(4,1:end)),5)
notBoxPlot(100*cat(2,p_correct_rewarded_half_mat(3,1:5),p_correct_rewarded_half_mat(4,1:end)),6)
[h,p] = ttest(cat(2,p_correct_rewarded_half_mat(3,1:5),p_correct_rewarded_half_mat(4,1:end)),cat(2,p_correct_naive_half_mat(3,1:5),p_correct_naive_half_mat(4,1:end)))