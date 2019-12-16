cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)


    individual_pi = [];
    arm_bias_expected_pi = [];
    adi = 0;
    cpms = [];
    fig_count = 0;

    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);

    cps_all  = zeros(14,200);
    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        cd(expt_name)
        conds = dir(expt_name);

        for cond_n = 1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
                
                continue
            end
            adi = adi+1


            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            
            
            load('all_variables.mat')

            [pi,cps] = preference_index(air_arm,right_left);
            cps_all(adi,1:length(cps)) = cps;
        end
    end
    psth_cps = []

    for kk = 1:14
        jj = 0
        cps_now = cps_all(kk,:);
        for time_pts = 301:300:9001
            jj = jj+1;
            one = find (cps_now > time_pts - 300);
            psth_cps(kk,jj) = length(find(cps_now(one) < time_pts));
        end  
    end    
    