cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena/')
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
ave_choice_ratios_sec_half = [];
ave_reward_ratios_sec_half = [];

color_vec = cbrewer('qual','Dark2',10,'cubic');
Air_Color = 0*color_vec(6,:);
O_A_Color = color_vec(1,:);
O_M_Color = 0.6*color_vec(1,:);
M_A_Color = color_vec(7,:);
M_O_Color = 0.7*color_vec(7,:);

protocol_100_0 = 2; % just setting this number to two for now it is an unneccesary variable but removing it requires too many code changes for now
Cprior_to_switch = [];
Rprior_to_switch = [];
Cprior_to_stick = [];
Rprior_to_stick = [];

count_stick = 0; 
count_switch = 0;

for expt_n = 2:2%2
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);

    for cond_n =1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            count = count+1;
            continue
            %SELECTING GOOD EXPTS BASED ON MI FOR GR64f
        elseif expt_n == 1
            if ismember(cond_n,[1,4,5,7,8,11,13,14,15,16,17,18]+2)
                continue
            end
        elseif expt_n == 2
            if ismember(cond_n,[4,5,9,11,12,13,15,16,17,18,19,20]+2)
                continue
            end
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
        
        
        for i = 4:length(choice_order)
        if choice_order(i) ~= choice_order(i-1)
        count_switch = count_switch+1;
        Cprior_to_switch(count_switch,:) = [choice_order(i-1),choice_order(i-2),choice_order(i-3)];
        Rprior_to_switch(count_switch,:) = [reward_order(i-1),reward_order(i-2),reward_order(i-3)];
        end
        end


        for i = 4:length(choice_order)
        if choice_order(i) == choice_order(i-1)
        count_stick = count_stick+1;
        Cprior_to_stick(count_stick,:) = [choice_order(i-1),choice_order(i-2),choice_order(i-3)];
        Rprior_to_stick(count_stick,:) = [reward_order(i-1),reward_order(i-2),reward_order(i-3)];
        end
        end
    end
    Rprior_to_stick(find(Rprior_to_stick == 2)) = 1;
    Rprior_to_switch(find(Rprior_to_switch == 2)) = 1;
end
        
        
        
        