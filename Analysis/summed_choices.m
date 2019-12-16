function [summed_choices_ends, summed_choices_center,summed_O_choices_ends, summed_O_choices_center,summed_M_choices_ends, summed_M_choices_center] = summed_choices(cps,odor_crossing,x_y_time_color)
    

    color_vec = cbrewer('qual','Dark2',10,'cubic')
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_M_Color = 0.6*color_vec(1,:);
    M_A_Color = color_vec(7,:);
    M_O_Color = 0.7*color_vec(7,:);
        
        
    summed_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_choices_center = zeros(length(x_y_time_color.time),1);
    summed_O_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_O_choices_center = zeros(length(x_y_time_color.time),1);
    summed_M_choices_ends = zeros(length(x_y_time_color.time),1);
    summed_M_choices_center = zeros(length(x_y_time_color.time),1);
    
    
    
    for p = 2:length(cps)-1
        summed_choices_ends(cps(p):cps(p+1)) = summed_choices_ends(cps(p)-1) + 1;
        no_match = 1;
        kk = 0;
        while no_match == 1
            kk = kk+1;
            if sum(x_y_time_color.color(cps(p)-kk,:) == M_A_Color )==3 ||sum(x_y_time_color.color(cps(p)-kk,:) == M_O_Color )==3
                summed_M_choices_ends(cps(p):end) = summed_M_choices_ends(cps(p)-1) + 1;
                no_match = 0;
            elseif sum(x_y_time_color.color(cps(p)-kk,:) == O_A_Color)==3 ||sum(x_y_time_color.color(cps(p)-kk,:) == O_M_Color)==3
                summed_O_choices_ends(cps(p):end) = summed_O_choices_ends(cps(p)-1) + 1;
                no_match = 0;
            end 
        end    
         
    end
    summed_choices_ends(cps(end):end) = summed_choices_ends(cps(end)-1) + 1;
    
    for p = 2:length(odor_crossing)-1
        summed_choices_center(odor_crossing(p).time_pt_in_vector :odor_crossing(p+1).time_pt_in_vector) = summed_choices_center(odor_crossing(p).time_pt_in_vector-1)+1;
        if isequal(odor_crossing(p-1).type,{'AtoM'})||isequal(odor_crossing(p-1).type,{'OtoM'})
            summed_M_choices_center(odor_crossing(p).time_pt_in_vector:end) = summed_M_choices_center(odor_crossing(p).time_pt_in_vector-1) + 1;
        elseif isequal(odor_crossing(p-1).type,{'AtoO'})||isequal(odor_crossing(p-1).type,{'MtoO'})
            summed_O_choices_center(odor_crossing(p).time_pt_in_vector:end) = summed_O_choices_center(odor_crossing(p).time_pt_in_vector-1) + 1;
        end
    end 
    summed_choices_center(odor_crossing(end).time_pt_in_vector :end) = summed_choices_center(odor_crossing(end).time_pt_in_vector-1)+1;

    

end