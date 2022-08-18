

clc
clear
% close all
count = 0
% Select spreadsheet containing experiment names
% FOR MAC : 
% cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/') % Change directory to folder containing experiment lists
% FOR LINUX : 
cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile ('*','Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    count = 0
    
    for cond_n = 1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            
            continue
        elseif expt_n == 1
            if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
                continue
            end
        elseif expt_n == 2
            if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
                continue
            end
        end

        count = count+1;
        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        RO = load('reward_order.mat');
        CO = load('choice_order.mat');
        CO = CO.choice_order;
        RO = RO.reward_order;
        choice_order = [];
        reward_order = [];
        
        for k = 1:size(CO,2)
        choice_order((k-1)*80 + 1 : (k)*80) = CO(:,k);
        reward_order((k-1)*80 + 1 : (k)*80) = RO(:,k);
        end
        
        zero_locs = find(choice_order == 0);
        choice_order(zero_locs) = [];
        reward_order(zero_locs) = [];
        
        CR_f10(expt_n,count) = rad2deg(atan(length(find(choice_order(1:10) == 1))/length(find(choice_order(1:10) == 2))));
        CR_b1(expt_n,count) = rad2deg(atan(length(find(choice_order(1:80) == 1))/length(find(choice_order(1:80) == 2))));
        if length(choice_order) >160
            CR_b2(expt_n,count) = rad2deg(atan(length(find(choice_order(81:160) == 1))/length(find(choice_order(81:160) == 2))));
        else
            CR_b2(expt_n,count) = rad2deg(atan(length(find(choice_order(81:end) == 1))/length(find(choice_order(81:end) == 2))));
      
        end
        if length(choice_order) > 160
            CR_b3(expt_n,count) = rad2deg(atan(length(find(choice_order(161:end) == 1))/length(find(choice_order(161:end) == 2))));
        end
        
    end
end

