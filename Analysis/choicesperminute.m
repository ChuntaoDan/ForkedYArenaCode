% This function calculates the number of choices made by the fly per
% minute.

function [choicepm] = choicesperminute(air_arm,time)
    num_choices = length(find(air_arm==0));
    if air_arm(end) == 0
        num_choices = num_choices-1;
    end
    time_min = time/60;
    
    choicepm = num_choices/time_min;
end