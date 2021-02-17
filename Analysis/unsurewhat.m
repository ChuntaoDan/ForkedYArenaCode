for ch = 1:length(cps)-1
    region_at_time_choice = 0;
    kk = 0;
    while region_at_time_choice == 0
        region_at_time_choice = region_at_time(cps(ch+1)+kk);
        if region_at_time_choice ~= 0
            first_chosen_arm = mod(region_at_time(cps(ch+1)+kk),3);
        end    
        kk = kk+1;
    end
    if first_chosen_arm == 0
        first_chosen_arm = 3;
    end    

    first_chosen_arm_entry = find (region_at_time(cps(ch):cps(ch+1))== first_chosen_arm,1);
    keyboard
    choice_time_from_entry(count_data,conts,ch) = cps(ch+1) - cps(ch) - first_chosen_arm_entry;

    if sum(x_y_time_color.color(cps(ch+1)-1,:) == O_A_Color)== 3 ||sum(x_y_time_color.color(cps(ch+1)-1,:) == O_M_Color)== 3
        c_OCT = c_OCT + 1;  
        choice_time_from_entry_OCT(count_data,conts,c_OCT) = choice_time_from_entry(count_data,conts,ch);
        choice_time_full_OCT(count_data,conts,c_OCT) = choice_time_full(count_data,conts,ch);
    elseif sum(x_y_time_color.color(cps(ch+1)-1,:) == M_A_Color)== 3 ||sum(x_y_time_color.color(cps(ch+1)-1,:) == M_O_Color)== 3
        c_MCH = c_MCH + 1;  
        choice_time_from_entry_MCH(count_data,conts,c_MCH) = choice_time_from_entry(count_data,conts,ch);
        choice_time_full_MCH(count_data,conts,c_MCH) = choice_time_full(count_data,conts,ch);
    end

end 