
    close all
    clear
    clc

    % Select spreadsheet containing experiment names
    cd('/groups/turner/home/rajagopalana/Documents/Turner Lab/Y-Arena') % Change directory to folder containing experiment lists
    [FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

    [~, expts, ~] = xlsread([PathName, FileName]);
    acquisition_rate = 30; % Acquisition rate (in Hz)

    peaks = [];
    Opeaks = [];
    Mpeaks = [];
    individual_pi = [];
    arm_bias_expected_pi = [];
    count = 0;
    count2 = 0;
    cpms = [];
    fig_count = 0;
    ave_choice_ratios = [];
    ave_reward_ratios = [];
    
    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);
    
    peaks = [];

    for expt_n = 1:length(expts)
        expt_name = expts{expt_n, 1};
        if expt_name(end-9:end) == 'O80M20_n+4'
            protocol_100_0 = 2; % 1 - O100M0; 2 - O80M20; 3 - O60M40;
            completed_conts = 5;
        elseif expt_name(end-9:end) == 'O80M20_n+3'
            protocol_100_0 = 2;
            completed_conts = 4;
        elseif expt_name(end-9:end) == 'O80M20_n+2'
            protocol_100_0 = 2;    
            completed_conts = 3;
        elseif expt_name(end-9:end) == 'O80M20_n+1'
            protocol_100_0 = 2;    
            completed_conts = 2;
        end    
        cd(expt_name)
        conds = dir(expt_name);
        
        for cond_n = 1:length(conds)
            % Skip the folders containing '.'
            if startsWith(conds(cond_n).name, '.')
                count = count+1;
                continue
            end
            


            % Change directory to file containing flycounts 
            cond = strcat(expt_name, '/', conds(cond_n).name);
            cd(cond)
            files = dir(cond)
            for file_n = 1:length(files)
                if startsWith(files(file_n).name, '.')
                    continue
                end
                if sum(files(file_n).name(1:5) == 'peaks') == 5
                    peak = load(files(file_n).name);
                    peak = peak.local_maxima;
                    peaks(length(peaks)+1 :length(peaks) + length(peak)) = peak;
                end
                if sum(files(file_n).name(1:3) == 'OCT') == 3
                    Opeak = load(files(file_n).name);
                    Opeak = Opeak.lmax_OCT;
                    Opeaks(length(Opeaks)+1 :length(Opeaks) + length(Opeak)) = Opeak;
                elseif sum(files(file_n).name(1:3) == 'MCH') == 3
                    Mpeak = load(files(file_n).name);
                    Mpeak = Mpeak.lmax_MCH;
                    Mpeaks(length(Mpeaks)+1 :length(Mpeaks) + length(Mpeak)) = Mpeak;
                
                end
            end 
        end
    end
        
    
    counts = find(peaks < 375);
    peaks = peaks(counts);
    Mcounts = find(Mpeaks < 375);
    Mpeaks = Mpeaks(Mcounts);
    Ocounts = find(Opeaks < 375);
    Opeaks = Opeaks(Ocounts);