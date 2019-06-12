speed = []; 

for i = 1:length(xy_fly)-1
speed(i) = sqrt((xy_fly(i,1)-xy_fly(i+1,1))^2 + (xy_fly(i,2)-xy_fly(i+1,2))^2)/(1/150);
end

speed_tA = []; 
for i = 300:length(speed)-300
speed_tA(i-299) = mean(speed(i-299:i+300));
end

X = [];
Y = [];
Z = [];
count = 0;
figure;
for j = 300:150:length(xy_fly)-301
    
    if isnan(speed_tA(j-299)) == 0
        count = count+1;
        X(count) = xy_fly(j,1);
        Y(count) = xy_fly(j,2);
        Z(count) = speed_tA(j-299);
        maxspeed = 150; %pre-calculated value
        if Z(count)/maxspeed < 1
            scatter(X(count),Y(count),140,'filled','MarkerFaceColor',[Z(count)/maxspeed,0,1-Z(count)/maxspeed],'MarkerEdgeColor',[0,0,0]);
            hold on
        else 
            scatter(X(count),Y(count),140,'filled','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0]);
            hold on
        end    
    end
end    

figure
plot(speed_tA)