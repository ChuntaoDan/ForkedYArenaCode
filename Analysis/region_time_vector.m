function [region_at_time] = region_time_vector(xy,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9)
region_at_time = zeros(length(xy(1,:)),1);
for i = 1:length(xy)

    if xy(1,i) == 0 && xy(2,i) == 0
        continue
%     elseif xy(1,i) == -1 && xy(2,i) == -1 && i ~= 1
%         region_at_time(i,1) = region_at_time(i-1,1);
%         continue
    elseif xy(1,i) == -1 && xy(2,i) == -1 %&& i == 1
        continue
    end
    
    if binarymask1(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 1;
    elseif binarymask2(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 2; 
    elseif binarymask3(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 3;
    elseif binarymask4(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 4; 
    elseif binarymask5(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 5;
    elseif binarymask6(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 6; 
    elseif binarymask7(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 7;
    elseif binarymask8(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 8; 
    elseif binarymask9(round(xy(2,i)),round(xy(1,i))) == 1
        region_at_time(i,1) = 9; 
    end
end
end