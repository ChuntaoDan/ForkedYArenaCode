% YArena_LearningCurve_v1
%
% IMPROVEMENTS
% Increase fontsize for tick labels
% Automatically add a title (maybe)
% Automatically determine the DominantOdor
% Automatically segment the blocks and plot accordingly
%

PlotChoices = Choices ;
FlipChoices = abs(PlotChoices-1);

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
plot(Cumul_Error(21),Cumul_Correct(21),'r.','markersize',32)
plot(Cumul_Error(41),Cumul_Correct(41),'r.','markersize',32)
plot(Cumul_Error(81),Cumul_Correct(81),'r.','markersize',32)
plot(Cumul_Error(121),Cumul_Correct(121),'r.','markersize',32)
plot(Cumul_Error(141),Cumul_Correct(141),'r.','markersize',32)

saveas(gcf,'LearningCurve')
save('YArenaRunLearningCurve.mat')
