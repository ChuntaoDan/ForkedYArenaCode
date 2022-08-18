cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')

% Load excel sheet containing the various folders that data is stored in 
% folders should be divided by condition . Eg. Sham, Ablated
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');
[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

% Initializing % correct matrix

p_correct_naive_mat = zeros(length(expts), 1);
p_correct_rewarded_mat = zeros(length(expts), 1);
p_correct_naive_half_mat = zeros(length(expts), 1);
p_correct_rewarded_half_mat = zeros(length(expts), 1);

%Loop through expts - lines in excel sheet
for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
%             count = count+1;
            continue
        end

        % Change directory to file containing flycounts 
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

        f = figure;
        f.Position = [50 500 1500 200];
        plot(Choices,'.','markersize',28);
        ylim([-2 3])
        set(gca,'box','off','ytick',[])
        NumOCT = length(find(Choices==1)) ;
        NumMCH = length(find(Choices==0)) ;
        disp(['OCT/MCH = ' num2str(NumOCT) '/' num2str(NumMCH) ' = ' num2str(NumOCT/(NumOCT+NumMCH))])

        saveas(gcf,'ChoiceRaster') ; 
        
        if sum(P_RewardMCH) > sum(P_RewardOCT)
            DominantOdor = 0 ;
        elseif sum(P_RewardOCT) > sum(P_RewardMCH)
            DominantOdor = 1 ;
        end
        
        % Calculating % correct for OCT v MCH choices in naive and rewarded
        % conditions Corresponding to flies where 40 trials were naive and 60 were rewarded
        if DominantOdor == 0
            p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(1:40) == 0))/length(Choices(1:40));
            p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(41:end) == 0))/length(Choices(41:end));
            p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 0))/length(Choices(21:40));
            p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 0))/length(Choices(71:end));
        elseif DominantOdor == 1
            p_correct_naive_mat(expt_n,cond_n-2) = length(find(Choices(1:40) == 1))/length(Choices(1:40));
            p_correct_rewarded_mat(expt_n,cond_n-2) = length(find(Choices(41:end) == 1))/length(Choices(41:end));
            p_correct_naive_half_mat(expt_n,cond_n-2) = length(find(Choices(21:40) == 1))/length(Choices(21:40));
            p_correct_rewarded_half_mat(expt_n,cond_n-2) = length(find(Choices(71:end) == 1))/length(Choices(71:end));
        end 
    end
end

figure

%plotting regular food raised
notBoxPlot(90*p_correct_naive_half_mat(1,:),1)
notBoxPlot(90*p_correct_rewarded_half_mat(1,:),2)
[h1,p1] = ttest(p_correct_rewarded_half_mat(1,:),p_correct_naive_half_mat(1,:));

%Plotting retinal food raised
notBoxPlot(90*p_correct_naive_half_mat(2,:),3)
notBoxPlot(90*p_correct_rewarded_half_mat(2,:),4)
[h2,p2] = ttest(p_correct_rewarded_half_mat(2,:),p_correct_naive_half_mat(2,:));


figure

%plotting regular food raised
notBoxPlot(90*p_correct_naive_mat(1,:),1)
notBoxPlot(90*p_correct_rewarded_mat(1,:),2)
[h1,p1] = ttest(p_correct_rewarded_mat(1,:),p_correct_naive_mat(1,:));

%Plotting retinal food raised
notBoxPlot(90*p_correct_naive_mat(2,:),3)
notBoxPlot(90*p_correct_rewarded_mat(2,:),4)
[h2,p2] = ttest(p_correct_rewarded_mat(2,:),p_correct_naive_mat(2,:));
