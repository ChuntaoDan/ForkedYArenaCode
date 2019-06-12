%% Calculate PI from an olfactory arena experiment
close all
clear
clc

% Select spreadsheet containing experiment names
cd('/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena') % Change directory to folder containing experiment lists
[FileName, PathName] = uigetfile('*', 'Select spreadsheet containing experiment names', 'off');

[~, expts, ~] = xlsread([PathName, FileName]);
acquisition_rate = 150; % Acquisition rate (in Hz)

individual_pi = zeros(265200,9,length(expts));
counts = zeros(1,length(expts));

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
        
        % Create indicator for CS+
        OCT = strfind(conds(cond_n).name,'OCT');
        
        if ~isempty(OCT) %OCT
            trials = dir(cond);
            count = 0;
            for trial_n = 1:length(trials)
                % Create indicator for arena number
                
                 % Skip the folders containing '.'
                 if startsWith(trials(trial_n).name, '.')
                     continue
                 end
                
                 
                 
                 cd(trials(trial_n).name)
                 
                 count = count+1;
                 
                 load('flycounts.mat')
        
                 if exist('allflycounts_OCT') == 0 %#ok<EXIST>
                    allflycounts_OCT =  NaN(length(n_flies),length(trials)-2, 2);
                 end

                   
                
                     allflycounts_OCT( 1:length(n_flies),count, 1) = n_flies(1:length(n_flies), 1);
                     allflycounts_OCT( 1:length(n_flies),count, 2) = n_flies(1:length(n_flies), 2);
                     allflycounts_OCT( 1:length(n_flies),count, 3) = n_flies(1:length(n_flies), 3);
                     
                 
                 cd(cond) 
                 
                 
            end
        else %MCH
            trials = dir(cond);
            count = 0;
            for trial_n = 1:length(trials)
                % Create indicator for arena number
                
                 % Skip the folders containing '.'
                 if startsWith(trials(trial_n).name, '.')
                     continue
                 end
               
                 
                 cd(trials(trial_n).name)
                 
                 count = count + 1;
                 
                 load('flycounts.mat')
        
                 if exist('allflycounts_MCH') == 0 %#ok<EXIST>
                    allflycounts_MCH = NaN(length(n_flies), length(trials)-2, 2);
                 end

                     allflycounts_MCH( 1:length(n_flies),count, 1) = n_flies(1:length(n_flies), 1);
                     allflycounts_MCH( 1:length(n_flies),count, 2) = n_flies(1:length(n_flies), 2);
                     allflycounts_MCH( 1:length(n_flies),count, 3) = n_flies(1:length(n_flies), 3);
                     
                 cd(cond)
                 
            end
        end 
        counts(expt_n) = count;
    end
    % Convert indices to time
    % Convert the indices for each measurement to time using the acquisition rate (30 Hz)
    frames_MCH = 1:size(allflycounts_MCH, 1);
    frames_OCT = 1:size(allflycounts_OCT, 1);
    time_MCH = frames_MCH/acquisition_rate;
    time_OCT = frames_OCT/acquisition_rate;
    time_MCH = permute(time_MCH, [2, 1]); % Time (in s)
    time_OCT = permute(time_OCT, [2, 1]);
    
    
%     %% Plot individual experiments PIs
%     figure
%     x = [30 30 90 90];
%     y = [-0.42 -.4 -0.4 -0.42];
%     patch(x, y, 'black')
%     xlim([0, 120])
%     ylim([-0.5, 0.5])
%     xlabel('Time (s)')
%     ylabel('Average PI')
%     title('Average PI for experiment')
%     
%     for c = 1:count
%         ind_OCT_pi = (allflycounts_OCT(:,c,1)-allflycounts_OCT(:,c,2))./(allflycounts_OCT(:,c,1)+allflycounts_OCT(:,c,2));
%     
%         ind_MCH_pi = (allflycounts_MCH(:,c,1)-allflycounts_MCH(:,c,2))./(allflycounts_MCH(:,c,1)+allflycounts_MCH(:,c,2));
%     
%         ind_recip_pi = (ind_MCH_pi - ind_OCT_pi(1:length(ind_MCH_pi)))./2;
%         
%         plot(time_MCH,ind_recip_pi)
%         
%         hold on
%     end    
    
    % Plot meanfly counts
    x = [30 30 150 150];
    y = [-2 -1.5 -1.5 -2]; 

    figure
    subplot(1, 2, 1)
    plot(time_MCH, squeeze(mean(allflycounts_MCH(:, 1:count, 1),2)),'Color',[0.8 0.6 1])% Specify trace by value for each dimension
    hold on
    plot(time_MCH, squeeze(mean(allflycounts_MCH(:, 1:count, 2),2)),'Color',[0.6 0.4 1])
    plot(time_MCH, squeeze(mean(allflycounts_MCH(:, 1:count, 3),2)),'Color',[0.4 0.2 1])
    
%     patch(x, y, 'black')
%     xlim([0, 120])
%     ylim([-3, 20])
    xlabel('Time (s)')
    ylabel('Fly counts')
    title('MCH as CS+')
    [~,hObj] = legend('Arm0','Arm2','Arm3');
   
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',2) 
    
    subplot(1, 2, 2)
    plot(time_OCT, squeeze(mean(allflycounts_OCT(:, 1:count, 1),2)),'Color',[0.8 0.6 1]) % Specify trace by value for each dimension
    hold on
    plot(time_OCT, squeeze(mean(allflycounts_OCT(:, 1:count, 2),2)),'Color',[0.6 0.4 1])
    plot(time_OCT, squeeze(mean(allflycounts_OCT(:, 1:count, 3),2)),'Color',[0.4 0.2 1])    
%     patch(x, y, 'black')
%     xlim([0, 120])
%     ylim([-3, 20])
    xlabel('Time (s)')
    ylabel('Fly counts')
    title('OCT as CS+')
    [~,hObj] = legend('Arm0','Arm2','Arm3');
    
    hL=findobj(hObj,'type','line');  % get the lines, not text
    set(hL,'linewidth',2) 
    
    % Calculate an average PI
    % Average the paired & unapaired odor trials for OCT trials
    for l = 4500:9000:220500 % length of this particular movie set
        if mod(((l-4500)/9000),3)== 1
            OCT_pi = (mean((allflycounts_OCT(:,1:count,1)-(1/2)*(allflycounts_OCT(:,1:count,2)+allflycounts_OCT(:,1:count,3))),2)./mean((allflycounts_OCT(:,1:count,1)+(1/2)*(allflycounts_OCT(:,1:count,2)+allflycounts_OCT(:,1:count,3))),2));
            OCT_se = 1/sqrt(trial_n-2).*(std(transpose(((allflycounts_OCT(:,1:count,1)-(1/2)*(allflycounts_OCT(:,1:count,2)+allflycounts_OCT(:,1:count,3))))./((allflycounts_OCT(:,1:count,1)+(1/2)*(allflycounts_OCT(:,1:count,2)+allflycounts_OCT(:,1:count,3)))))));
    
    % Average the paired & unpaired odor trials for the second camera
            MCH_pi = (mean(allflycounts_MCH(:,1:count,1)-(1/2)*(allflycounts_MCH(:,1:count,2)+allflycounts_MCH(:,1:count,3)),2)./mean(allflycounts_MCH(:,1:count,1)+(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,3)),2));
            MCH_se = 1/sqrt(trial_n-2).*(std(transpose((allflycounts_MCH(:,1:count,1)-(1/2)*(allflycounts_MCH(:,1:count,2)+allflycounts_MCH(:,1:count,3)))./(allflycounts_MCH(:,1:count,1)+(1/2)*(allflycounts_MCH(:,1:count,2)+allflycounts_MCH(:,1:count,3))))));
        elseif mod(((l-4500)/9000),3)== 2
            OCT_pi = (mean((allflycounts_OCT(:,1:count,2)-(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3))),2)./mean((allflycounts_OCT(:,1:count,2)+(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3))),2));
            OCT_se = 1/sqrt(trial_n-2).*(std(transpose(((allflycounts_OCT(:,1:count,2)-(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3))))./((allflycounts_OCT(:,1:count,2)+(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3)))))));
    
    % Average the paired & unpaired odor trials for the second camera
            MCH_pi = (mean(allflycounts_MCH(:,1:count,2)-(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,3)),2)./mean(allflycounts_MCH(:,1:count,2)+(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,3)),2));
            MCH_se = 1/sqrt(trial_n-2).*(std(transpose((allflycounts_MCH(:,1:count,2)-(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,3)))./(allflycounts_MCH(:,1:count,2)+(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,3))))));
        elseif mod(((l-4500)/9000),3)== 3
            OCT_pi = (mean((allflycounts_OCT(:,1:count,3)-(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,2))),2)./mean((allflycounts_OCT(:,1:count,2)+(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3))),2));
            OCT_se = 1/sqrt(trial_n-2).*(std(transpose(((allflycounts_OCT(:,1:count,3)-(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,2))))./((allflycounts_OCT(:,1:count,2)+(1/2)*(allflycounts_OCT(:,1:count,1)+allflycounts_OCT(:,1:count,3)))))));
    
    % Average the paired & unpaired odor trials for the second camera
            MCH_pi = (mean(allflycounts_MCH(:,1:count,3)-(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,2)),2)./mean(allflycounts_MCH(:,1:count,3)+(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,2)),2));
            MCH_se = 1/sqrt(trial_n-2).*(std(transpose((allflycounts_MCH(:,1:count,3)-(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,2)))./(allflycounts_MCH(:,1:count,3)+(1/2)*(allflycounts_MCH(:,1:count,1)+allflycounts_MCH(:,1:count,2))))));
        end
    end    
            
    x = [30 30 150 150];
    y = [0.42 0.4 0.4 0.42];
   
    
    figure
    subplot(1, 2, 1)
    shadedErrorBar(time_MCH, MCH_pi, MCH_se, 'lineprops', 'b')
   
%     patch(x, y, 'black')
%     xlim([0, 120])
    ylim([-1, 0.5])
    xlabel('Time (s)')
    ylabel('PI')
    title('MCH as CS+')
    
    subplot(1, 2, 2)
    shadedErrorBar(time_OCT, OCT_pi, OCT_se,'lineprops', 'b')
    
%     patch(x, y, 'black')
%     xlim([0, 120])
    ylim([-1, 0.5])
    xlabel('Time (s)')
    ylabel('PI')
    title('OCT as CS+')
%     
%     % Plot reciprocal PI    
%     recip_pi(expt_n,:) = (MCH_pi(:) + OCT_pi(:))./2;
%     recip_se(expt_n,:) = 1/sqrt(trial_n-2).*(sqrt(MCH_se(:).^2 + OCT_se(:).^2));  
%     
%     individual_pi(:,1:count,expt_n) = 0.5*(((allflycounts_MCH(:,1:count,1)-(1/2)*allflycounts_MCH(:,1:count,2))./(allflycounts_MCH(:,1:count,1)+(1/2)*allflycounts_MCH(:,1:count,2))) + ((allflycounts_OCT(:,1:count,1)-(1/2)*allflycounts_OCT(:,1:count,2))./(allflycounts_OCT(:,1:count,1)+(1/2)*allflycounts_OCT(:,1:count,2))));
% 
%     figure
%     shadedErrorBar(time_MCH(:), recip_pi(expt_n,:), recip_se(expt_n,:),'lineprops', 'b')
%     hold on
%     plot(time_MCH(:),individual_pi(:,1,expt_n),'k','LineStyle',':')
%     plot(time_MCH(:),individual_pi(:,2,expt_n),'k','LineStyle',':')
%     plot(time_MCH(:),individual_pi(:,3,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,4,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,5,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,6,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,7,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,8,expt_n),'k','LineStyle',':')
% %     plot(time_MCH(:),individual_pi(:,9,expt_n),'k','LineStyle',':')
%     patch(x+0.2, y+0.2, 'black')
%     xlim([0, 120])
%     ylim([-0.8, 0.8])
%     xlabel('Time (s)')
%     ylabel('PI')
%     title('Average Combined PI (MCH+ - OCT+)')
%     
%     %individual_pi(:,1:count,expt_n) = 0.5*(((allflycounts_MCH(1:3630,1:count,1)-allflycounts_MCH(1:3630,1:count,2))./(allflycounts_MCH(1:3630,1:count,1)+allflycounts_MCH(1:3630,1:count,2))) - ((allflycounts_OCT(1:3630,1:count,1)-allflycounts_OCT(1:3630,1:count,2))./(allflycounts_OCT(1:3630,1:count,1)+allflycounts_OCT(1:3630,1:count,2))));

end
