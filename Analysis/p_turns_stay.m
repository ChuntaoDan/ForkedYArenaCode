load('num_turns_rewarded.mat')
load('num_turns_unrewarded.mat')

% load('turns.mat')

cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');
[~, expts, ~] = xlsread([PathName, FileName]);
p_turn_rewarded = []
p_stay_rewarded = []
p_turn_unrewarded = []
p_stay_unrewarded = []

expt_name = expts{1, 1};
cd(expt_name)
conds = dir(expt_name);

for cond_n =1:length(conds)%-4
     if startsWith(conds(cond_n).name, '.')

            continue
     end
     
     cond = strcat(expt_name, '/', conds(cond_n).name);
     cd(cond)
     
     load('choice_order.mat');
     load(sprintf('all_variables_contingency_%d',1));
     
     % for single block 100-0 Gr64fGal4 expts
     if reward(1,2) == 1
        n_stay_rewarded = sum(choice_order == 1);
        n_stay_unrewarded = sum(choice_order == 2);
     else
        n_stay_rewarded = sum(choice_order == 2);
        n_stay_unrewarded = sum(choice_order == 1);
     end
     
     p_stay_rewarded(cond_n-3) = n_stay_rewarded(1)/(n_stay_rewarded(1)+num_turns_away_rewarded(expt_n,cond_n-2,1));
     p_turn_rewarded(cond_n-3) = num_turns_away_rewarded(expt_n,cond_n-2,1)/(n_stay_rewarded(1)+num_turns_away_rewarded(expt_n,cond_n-2,1));
     p_stay_unrewarded(cond_n-3) = n_stay_unrewarded(1)/(n_stay_unrewarded(1)+num_turns_away_unrewarded(expt_n,cond_n-2,1));
     p_turn_unrewarded(cond_n-3) = num_turns_away_unrewarded(expt_n,cond_n-2,1)/(n_stay_unrewarded(1)+num_turns_away_unrewarded(expt_n,cond_n-2,1));

     % for 3 odor expts
%      if x1 == 0.8
%         n_stay_hrewarded(cond_n-2) = sum(choice_order(:,2) == 1);
%         n_stay_lrewarded(cond_n-2) = sum(choice_order(:,2) == 2);
%         n_stay_hunrewarded(cond_n-2) = 40-n_stay_hrewarded(cond_n-2);
%         n_stay_lunrewarded(cond_n-2) = 40-n_stay_lrewarded(cond_n-2);
%      else
%         n_stay_hrewarded(cond_n-2) = sum(choice_order(:,2) == 2);
%         n_stay_lrewarded(cond_n-2) = sum(choice_order(:,2) == 1);
%         n_stay_hunrewarded(cond_n-2) = 40-n_stay_hrewarded(cond_n-2);
%         n_stay_lunrewarded(cond_n-2) = 40-n_stay_lrewarded(cond_n-2);
%      end
     
%      p_stay_hrewarded(cond_n-2) = n_stay_hrewarded/(n_stay_hrewarded+turns_high(expt_n,cond_n-2,2));
%      p_stay_hunrewarded(cond_n-2) = n_stay_hunrewarded/(n_stay_hunrewarded+turns_P_high(expt_n,cond_n-2,2));
%      p_stay_lrewarded(cond_n-2) = n_stay_lrewarded/(n_stay_lrewarded+turns_low(expt_n,cond_n-2,2));
%      p_stay_lunrewarded(cond_n-2) = n_stay_lunrewarded/(n_stay_lunrewarded+turns_P_low(expt_n,cond_n-2,2));

end