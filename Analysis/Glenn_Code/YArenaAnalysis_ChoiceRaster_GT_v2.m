% /Dropbox (HHMI)/MATLAB/YArenaData/AnalyzeYExperiment_AdiAcquisition.m

% find places where AirArm = 0 (discard first one which marks experiment initiation)
% find what right_left is immediately after that (actually would it be immediately before that?
% if right_left = 1 then OCT is right MCH is left
% elseif right_left = 2 then MCH is right OCT is left
%     AirArm tells you absolute position

% AirArm takes values 0 1 2 3 for each video frame
% 0 = frame when a choice is made & Y resets
% 1 = Physical Arm0
% 2 = Physical Arm1
% 3 = Physical Arm2

% Find places where AirArm = 0 which is right after reward delivered (discard first one which marks experiment initiation)
% Return AirArm immediately before those times = PreChoiceArm
%     may be simpler to think about it as the end of the last choice
% Return AirArm immediately after those times = PostChoiceArm
% If it is a transition from 1to2 2to3 3to1 it was a RIGHT turn
%     if ArmRandomizerMat = 1 right turns are a choice for OCT
%     if ArmRandomizerMat = 2 right turns are a choice for MCH
% If it is a transition from 1to3 3to2 2to1 it was a LEFT turn
%     if ArmRandomizerMat = 1 left turns are a choice for MCH
%     if ArmRandomizerMat = 2 left turns are a choice for OCT

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


% if the ratio tips to OCT
%     find first choice for OCT
%     find all subsequent choices for MCH
%     what fraction of subsequent choices are for MCH
%     What fraction of those choices are within first 5/10 trials
%
%     ChoicesOCT = find(Choices == 1) ;
%     ChoicesMCH = find(Choices == 0) ;
%         FirstOCT = ChoicesOCT(1)
%     FirstMCH = ChoicesMCH(1)
%
%     if NumOCT>NumMCH
%     PostLightBulbMCH = sum(find(Choices(FirstOCT:end) = 0)

% disp(['OCT choices = ' num2str(sum(Choices))])
% disp(['MCH choices = ' num2str(length(find(Choices==0)))])
% If you made this OCT = 1 and MCH = 2 then you would get a single vector of all the choices
%
%     if PostChoiceFrames =
%
%     y = [1 3] ;
%     z = [2 3] ;
%     t = [1 3] ;
% if t == y || z
%     disp('match')
% end
