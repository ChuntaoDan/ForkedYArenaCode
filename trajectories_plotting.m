start = 0
counta = 0;
countb = 0;
trajectories = []
for i = 1:length(xy_fly)
    if isnan(xy_fly(i,1)) == 0  && isnan(xy_fly(i,2))==0
        if start == 0
            if binarymask(round(xy_fly(i,2)),round(xy_fly(i,1)))==1
                start = i;
                counta = counta+1;
                countb = 1;
                trajectories(counta,countb) = i;
            end
        elseif start~= 0
            if binarymask(round(xy_fly(i,2)),round(xy_fly(i,1)))==1
                countb = countb+1;
                trajectories(counta,countb) = i;
            else
                start = 0;
            end
        end
    end    
end

figure
for i = 1:58
    t = trajectories(i,:);
    a = t(find(t~=0));
    if binarymask3(round(xy_fly(a(1),2)),round(xy_fly(a(1),1))) == 1
        plot((-0.5*(xy_fly(a,2)-662))-(sqrt(3)/2)*(xy_fly(a,1)-811),-(0.5)*(xy_fly(a,1)-811)+(sqrt(3)/2)*(xy_fly(a,2)-662),'Color',[0,0,i/58])
    elseif binarymask2(round(xy_fly(a(1),2)),round(xy_fly(a(1),1))) == 1
        plot((-0.5*(xy_fly(a,2)-662))+(sqrt(3)/2)*(xy_fly(a,1)-811),-(0.5)*(xy_fly(a,1)-811)-(sqrt(3)/2)*(xy_fly(a,2)-662),'Color',[0,0,i/58])
    else    
        plot(xy_fly(a,2)-662,xy_fly(a,1)-811,'Color',[0,0,i/58])
    end    
    hold on
end    