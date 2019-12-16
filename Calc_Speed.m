function [speed,speed_tA,fig_count] = Calc_Speed(xy_no_minus_ones,timestamps_no_minus_ones,times,fig_count)
speed = []; 

cf  = 0.1176% conversion factor from pixel to mm (mm/pixel)

for i = 1:length(xy_no_minus_ones)-1
%     disp(i)
    speed(i) = cf*sqrt(((xy_no_minus_ones(1,i)-xy_no_minus_ones(1,i+1))^2 + (xy_no_minus_ones(2,i)-xy_no_minus_ones(2,i+1))^2)/((timestamps_no_minus_ones(i)+timestamps_no_minus_ones(i+1))/2));
end

speed_tA = []; 
for i = 10:length(speed)-10
speed_tA(i-9) = mean(speed(i-9:i+10));
end
% 
% X = [];
% Y = [];
% Z = [];
% count = 0;
% figure(fig_count+1)
% fig_count = fig_count+1
% for j = 50:50:length(xy_no_minus_ones)-51
%     
%     if isnan(speed_tA(j-49)) == 0
%         count = count+1;
%         X(count) = xy_no_minus_ones(1,j);
%         Y(count) = xy_no_minus_ones(2,j);
%         Z(count) = speed_tA(j-49);
%         maxspeed = max(speed_tA); %pre-calculated value
%         if Z(count)/maxspeed < 1
%             scatter(X(count),Y(count),140,'filled','MarkerFaceColor',[Z(count)/maxspeed,0,1-Z(count)/maxspeed],'MarkerEdgeColor',[0,0,0]);
%             hold on
%         else 
%             scatter(X(count),Y(count),140,'filled','MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[0,0,0]);
%             hold on
%         end    
%     end
% end    

figure(fig_count+1)
fig_count = fig_count+1
plot(times(10:end-11),speed_tA)

end
