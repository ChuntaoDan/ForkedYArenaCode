%% Calculate PI from an olfactory arena experiment
close all
clear
clc

% Select spreadsheet containing experiment names
cd('/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 150; % Acquisition rate (in Hz)

individual_pi = [];
arm_bias_expected_pi = [];


%%

for expt_n = 1:length(expts)
    expt_name = expts{expt_n, 1};
    cd(expt_name)
    conds = dir(expt_name);
    
    for cond_n = 1:length(conds)
        % Skip the folders containing '.'
        if startsWith(conds(cond_n).name, '.')
            continue
        end

        % Change directory to file containing flycounts 
        cond = strcat(expt_name, '/', conds(cond_n).name);
        cd(cond)
        load('all_variables.mat')
        
        pi = preference_index(air_arm,right_left);
        arm_bias_pi = arm_bias(
    end    
    
end
