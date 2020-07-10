expts = dir('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/Baited_Reward_V2_3Cont')


count = 0;
for expt_n = 1:length(expts)
    cd('/Users/adiraj95/Documents/MATLAB/TurnerLab_Code/Baited_Reward_V2_3Cont')
    % Skip the folders containing '.'
    if startsWith(expts(expt_n).name, '.')
        count = count+1;
        continue
    end
    
    expt = strcat(expts(expt_n).name);
    cd(expt)
    
    for conts = 1:3
        cont_file = sprintf('all_variables_contingency_%d.mat',conts)
        load(cont_file)
        
        
