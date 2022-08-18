cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

fig_count = 0;
rewarded_odor = [];
unrewarded_odor = [];
error_count_tA = [];
count_data = 0;

color_vec = cbrewer('qual','Dark2',10,'cubic');
Air_Color = 0*color_vec(6,:);
O_A_Color = color_vec(1,:);
O_M_Color = 0.6*color_vec(1,:);
M_A_Color = color_vec(7,:);
M_O_Color = 0.7*color_vec(7,:);

for expt_n = 1:7%length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        count_data = count_data+1;
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')

            continue
            %SKIPPING LOW MI EXPTS FOR GR64f 3 block expts
%         elseif expt_n == 1
%             if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
%                 continue
%             end
%         elseif expt_n == 2
%             if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
%                 continue
%             end

        end

        choice_order = [];
        reward_order = [];

        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)

        load('choice_order.mat')
        load('reward_order.mat')

        if length(find(reward_order(:,2) == 1)) > 0
            rewarded_odor = 1;
            unrewarded_odor = 2;
        else
            rewarded_odor = 2;
            unrewarded_odor = 1;
        end
        
        for i = 6:length(choice_order)
            error_count_tA(expt_n,cond_n-2,i-5) = length(find(choice_order(i-5:i,2)== unrewarded_odor));
        end    

    end
end
