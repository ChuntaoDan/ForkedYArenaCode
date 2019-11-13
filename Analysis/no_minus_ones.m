function [xy_no_minus_ones,timestamps_no_minus_ones] = no_minus_ones(xy,timestamps)
    xy_no_minus_ones = [];
    timestamps_no_minus_ones = [];
    count = 0;
    for i = 1:length(timestamps)
        if xy(1,i) ~= -1 && xy(2,i) ~= -1
            count = count+1;
            xy_no_minus_ones(:,count) = xy(:,i);
            timestamps_no_minus_ones(count) = timestamps(i);
        end
    end    