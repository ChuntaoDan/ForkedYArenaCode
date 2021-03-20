cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

 for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);
        
        for cond_n =1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
                continue
                %SELECTING GOOD EXPTS BASED ON MI FOR GR64f
%             elseif expt_n == 1
%                 if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                     continue
%                 end
%             elseif expt_n == 2
%                 if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                     continue
%                 end
            end
            
             % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            
            load('O_choice.mat')
            load('M_choice.mat')
            load('PO_choice.mat')
            load('PM_choice.mat')
            summed_O_choices_ends = summed_O_choices_ends - summed_O_choices_ends(1);
            summed_P_O_choices_ends = summed_P_O_choices_ends - summed_P_O_choices_ends(1);
            summed_M_choices_ends = summed_M_choices_ends - summed_M_choices_ends(1);
            summed_P_M_choices_ends = summed_P_M_choices_ends - summed_P_M_choices_ends(1);
            O_P = cat(2,summed_O_choices_ends,summed_P_O_choices_ends);
            O_P_all(cond_n-2,1:length(unique(O_P,'rows')),:) = unique(O_P,'rows');
            M_P = cat(2,summed_M_choices_ends,summed_P_M_choices_ends);
            M_P_all(cond_n-2,1:length(unique(M_P,'rows')),:) = unique(M_P,'rows');
            
        end
 end