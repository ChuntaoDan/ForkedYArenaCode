cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 30; % Acquisition rate (in Hz)

n_diff_lb1 = [];
n_diff_lb2 = [];
n_diff_lb3 = [];
n_diff_lb6 = [];

for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        if expt_name(end-10:end-6) == '100_0'
            protocol_100_0 = 1;
        elseif expt_name(end-4:end) == '80_20'
            protocol_100_0 = 2;
        elseif expt_name(end-4:end) == '60_40'
            protocol_100_0 = 3;    
        end    
        cd(expt_name)
        conds = dir(expt_name);

        for cond_n = 1:length(conds)
            
            if startsWith(conds(cond_n).name, '.')
                
                continue
            end
            


            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            
            inst_choice_ratio_10 = load('inst_CR_lb10.mat');
            inst_choice_ratio_10 = inst_choice_ratio_10.inst_choice_ratio;
            inst_choice_ratio_6 = load('inst_CR_lb6.mat');
            inst_choice_ratio_6 = inst_choice_ratio_6.inst_choice_ratio;
            inst_choice_ratio_3 = load('inst_CR_lb3.mat');
            inst_choice_ratio_3 = inst_choice_ratio_3.inst_choice_ratio;
            inst_choice_ratio_2 = load('inst_CR_lb2.mat');
            inst_choice_ratio_2 = inst_choice_ratio_2.inst_choice_ratio;
            inst_choice_ratio_1 = load('inst_CR_lb1.mat');
            inst_choice_ratio_1 = inst_choice_ratio_1.inst_choice_ratio;
            inst_income_ratio_10 = load('inst_IR_lb10.mat');
            inst_income_ratio_10 = inst_income_ratio_10.inst_income_ratio;
            inst_income_ratio_6 = load('inst_IR_lb6.mat');
            inst_income_ratio_6 = inst_income_ratio_6.inst_income_ratio;
            inst_income_ratio_3 = load('inst_IR_lb3.mat');
            inst_income_ratio_3 = inst_income_ratio_3.inst_income_ratio;
            inst_income_ratio_2 = load('inst_IR_lb2.mat');
            inst_income_ratio_2 = inst_income_ratio_2.inst_income_ratio;
            inst_income_ratio_1 = load('inst_IR_lb1.mat');
            inst_income_ratio_1 = inst_income_ratio_1.inst_income_ratio;
            cps_pre = load('cps_pre.mat');
            cps_pre = cps_pre.cps_pre;
            
            diff_lb10 = abs(inst_income_ratio_10 - inst_choice_ratio_10);
            n_diff_lb10(expt_n,cond_n-2) = sum(diff_lb10(cps_pre+1:end))/length(diff_lb10(cps_pre+1:end));
            diff_lb6 = abs(inst_income_ratio_6 - inst_choice_ratio_6);
            n_diff_lb6(expt_n,cond_n-2) = sum(diff_lb6(cps_pre+1:end))/length(diff_lb6(cps_pre+1:end));
            diff_lb3 = abs(inst_income_ratio_3 - inst_choice_ratio_3);
            n_diff_lb3(expt_n,cond_n-2) = sum(diff_lb3(cps_pre+1:end))/length(diff_lb3(cps_pre+1:end));
            diff_lb2 = abs(inst_income_ratio_2 - inst_choice_ratio_2);
            n_diff_lb2(expt_n,cond_n-2) = sum(diff_lb2(cps_pre+1:end))/length(diff_lb2(cps_pre+1:end));
            diff_lb1 = abs(inst_income_ratio_1 - inst_choice_ratio_1);
            n_diff_lb1(expt_n,cond_n-2) = sum(diff_lb1(cps_pre+1:end))/length(diff_lb1(cps_pre+1:end));
            
            
            
        end
end    

mean_diff_lb10 = mean(mean(n_diff_lb10));
mean_diff_lb6 = mean(mean(n_diff_lb6));
mean_diff_lb3 = mean(mean(n_diff_lb3));
mean_diff_lb2 = mean(mean(n_diff_lb2));
mean_diff_lb1 = mean(mean(n_diff_lb1));

n_diff_all(1,:) = cat(2,n_diff_lb1(1,1:7),n_diff_lb1(2,:));
n_diff_all(2,:) = cat(2,n_diff_lb2(1,1:7),n_diff_lb2(2,:));
n_diff_all(3,:) = cat(2,n_diff_lb3(1,1:7),n_diff_lb3(2,:));
n_diff_all(4,:) = cat(2,n_diff_lb6(1,1:7),n_diff_lb6(2,:));
n_diff_all(5,:) = cat(2,n_diff_lb10(1,1:7),n_diff_lb10(2,:));



marker_colors = [1,0,0;1,0,0;1,0,0;1,0,0;1,0,0];
col_pairs = [1,2;2,3;3,4;4,5];
scattered_dot_plot(transpose(n_diff_all),100,1,4,8,marker_colors,1,col_pairs,[0.75,0.75,0.75],[],1,[0.35,0.35,0.35]);
    


