% this function looks at the percentage of times a particular arm is chosen
% to see if there is a bias induced by arm identity and also provides you
% the percentage of times that OCT or MCH was delivered in a given arm
function [arm_odor_ratios,arm_odor_values,chosen_arm_ratios,chosen_arm_matrix,expected_PI] = arm_bias(air_arm,right_left)

    arm_odor_values = zeros(3,2);
    
    cps = find(air_arm==0);
    
    
    if air_arm(end) == 0
        cps = cps(1:end-1);
    end    
    
    chosen_arm_list = []
    chosen_arm_matrix = zeros(3,3);
    
    for i = cps(2:end)
        home_arm = air_arm(i-1);
        h_c = [home_arm,air_arm(i+1)];
        not_chosen_arm = find(ismember([1,2,3],h_c)==0);
        chosen_arm_matrix(air_arm(i+1),not_chosen_arm) =chosen_arm_matrix(air_arm(i+1),not_chosen_arm) + 1; 
        chosen_arm_list(length(chosen_arm_list)+1) = air_arm(i+1);
        if right_left(i-1) == 1
            if home_arm == 1
                MCH_arm = 3;
                OCT_arm = 2;
            elseif home_arm == 2
                MCH_arm = 1;
                OCT_arm = 3;
            elseif home_arm == 3
                MCH_arm = 2;
                OCT_arm = 1;
            end
        elseif right_left(i-1) == 2
            if home_arm == 1
                MCH_arm = 2;
                OCT_arm = 3;
            elseif home_arm == 2
                MCH_arm = 3;
                OCT_arm = 1;
            elseif home_arm == 3
                MCH_arm = 1;
                OCT_arm = 2;
            end
        end
        arm_odor_values(MCH_arm,2) = arm_odor_values(MCH_arm,2)+1; 
        arm_odor_values(OCT_arm,1) = arm_odor_values(OCT_arm,1)+1; 
    
    end
    
arm_odor_ratios = arm_odor_values(:,1)./(arm_odor_values(:,1)+ arm_odor_values(:,2));   
chosen_arm_ratios = [length(find(chosen_arm_list==1))/(length(cps)-1),length(find(chosen_arm_list==2))/(length(cps)-1),length(find(chosen_arm_list==3))/(length(cps)-1)];  
chosen_arm_matrix_ratios = [chosen_arm_matrix(1,2)/(chosen_arm_matrix(1,2)+chosen_arm_matrix(2,1)),chosen_arm_matrix(1,3)/(chosen_arm_matrix(1,3)+chosen_arm_matrix(3,1));chosen_arm_matrix(2,1)/(chosen_arm_matrix(2,1)+chosen_arm_matrix(1,2)),chosen_arm_matrix(2,3)/(chosen_arm_matrix(2,3)+chosen_arm_matrix(3,2));chosen_arm_matrix(3,1)/(chosen_arm_matrix(3,1)+chosen_arm_matrix(1,3)),chosen_arm_matrix(3,2)/(chosen_arm_matrix(3,2)+chosen_arm_matrix(2,3))];
p_choice_bw_two_options = [(chosen_arm_matrix(1,2)+chosen_arm_matrix(2,1))/sum(sum(chosen_arm_matrix)),(chosen_arm_matrix(1,3)+chosen_arm_matrix(3,1))/sum(sum(chosen_arm_matrix)),(chosen_arm_matrix(3,2)+chosen_arm_matrix(2,3))/sum(sum(chosen_arm_matrix))];
expected_PI_matrix = [chosen_arm_matrix_ratios(1,1)*p_choice_bw_two_options(1), chosen_arm_matrix_ratios(1,2)*p_choice_bw_two_options(2);chosen_arm_matrix_ratios(2,1)*p_choice_bw_two_options(1),chosen_arm_matrix_ratios(2,2)*p_choice_bw_two_options(3);chosen_arm_matrix_ratios(3,1)*p_choice_bw_two_options(2),chosen_arm_matrix_ratios(3,2)*p_choice_bw_two_options(3)]; 
expected_PI = sum(sum(arm_odor_ratios .* expected_PI_matrix),'omitNan');
end
