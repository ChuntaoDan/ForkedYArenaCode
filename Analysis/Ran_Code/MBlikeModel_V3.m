function[R, R_ER, X, X_chosen, Y] = FlyData_preprocess(beta)


        
        % LOADING and FORMATTING odor_crossings, choice and reward order and choice points
        load('odor_crossing_1.mat');
        load('cps_1.mat');
        odor_crossings = odor_crossing;
        cp_vec = cps(2:end);
        load('odor_crossing_2.mat');
        load('cps_2.mat');
        cp_vec(length(cp_vec)+1:length(cp_vec)+length(cps(2:end))) = cps(2:end);
        odor_crossings(length(odor_crossings)+1 : length(odor_crossings)+length(odor_crossing)) = odor_crossing;
        added_time = cp_vec(length(cp_vec)-length(cps)+1);
        for ii = length(odor_crossings)-length(odor_crossing)+1 : length(odor_crossings)
            odor_crossings(ii).time_pt_in_vector = odor_crossings(ii).time_pt_in_vector + added_time;
    
        end
        cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) =  cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) +added_time;
        
        if exist('odor_crossing_3.mat')
            load('cps_3.mat');
            load('odor_crossing_3.mat')
            cp_vec(length(cp_vec)+1:length(cp_vec)+length(cps(2:end))) = cps(2:end);
            odor_crossings(length(odor_crossings)+1 : length(odor_crossings)+length(odor_crossing)) = odor_crossing;
            added_time = cp_vec(length(cp_vec)-length(cps)+1);
            for ii = length(odor_crossings)-length(odor_crossing)+1 : length(odor_crossings)
                odor_crossings(ii).time_pt_in_vector = odor_crossings(ii).time_pt_in_vector + added_time;
    
            end
            cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) =  cp_vec(length(cp_vec)-length(cps)+2:length(cp_vec)) +added_time;
        end
        
        
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
        
        
        X = []; % KC - [1,0] if 1(MCH) and [0,1] if 2(OCT)
        X_times = []
        xcount = 0
        for i = 1:length(odor_crossings)
            class_i = class(odor_crossings(i).type);
            if class_i(1) == 'd'
                continue
            end    
            if class(odor_crossings(i).type(1)) == 'cell'
                if odor_crossings(i).type{1}(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                elseif odor_crossings(i).type{1}(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                else
                    continue
                end
            else
                if odor_crossings(i).type(4) == 'O'
                    xcount = xcount+1;
                    X(xcount,:) = [0,1];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                elseif odor_crossings(i).type(4) == 'M'
                    xcount = xcount+1;
                    X(xcount,:) = [1,0];
                    X_times(xcount) = odor_crossings(i).time_pt_in_vector
                else
                    continue
                end
            end    
        end    
        

        R = zeros(length(X),2); % shouldnt be a n,2 vec but am making it so by duplicating row for regression
        Y = zeros(length(X),1);
        interm_old = [];
        
        for j = 1:length(cp_vec)
            interm_new = find(X_times < cp_vec(j));
            if sum(interm_new) ~= sum(interm_old)
                R(interm_new(end),1) = reward_order(j);
                Y(interm_new(end)) = 1;
                interm_old = interm_new;
            end

        end
        R_count = find(R == 2);
        R(:,2) = R(:,1);
        R(R_count) = 0;
        R_count2 = find(R(:,2)==1);
        R(R_count2,2) = 0;
        R_count = find(R == 2);
        R(R_count) = 1;
        R = sum(R,2)
        R_ave = [];
        
        X_chosen = X(find(Y==1),:);
        R_chosen = R(find(Y==1),:);
        R_chosen = [zeros(9,1); R_chosen];
%      
        R_ave = zeros(1,1);
        for timept = 1:length(find(Y==1))
            % Here the average reward is calculated as global signal common for
            % both odors.

            R_ave(timept) = mean(R_chosen(timept:timept+9));

        end 

        R = R_chosen(10:end);
        % R - E(R) is calculated
        R_ER = R - R_ave';

        % Compute average stimulus for each odor
        for timept = 1:length(find(Y==1))
            if timept > 1
                X_ave(timept,:) = alpha_p*X_chosen(timept-1,:) + (1 - alpha_m)*X_ave(timept-1,:);  
            else
                X_ave(timept,:) = [(1+alpha)/2,(1+alpha)/2] ;
            end    
        end
        X_EX = X_chosen - X_ave;

  
end

