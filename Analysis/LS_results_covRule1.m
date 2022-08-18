clear
clc
% close all

count = 0;

for exptn = 1:30
    
    p1 = 0.3 - ((0.3/29)*(exptn-1));
    p2 = 0.3-p1;
    
    for contn = 1:10
        count = count + 1;
        
%         [I1(count),I2(count),C1(count),C2(count),W1,W2,C_order,W_order(:,:,count),rR1,rR2] = Loewenstein_Seung_v1(p1,p2);
%         [I1(count),I2(count),C1(count),C2(count),y,R_vec,W_vec,S_vec] = Loewenstein_Seung_v1(p1,p2);
        [I1(count),I2(count),C1(count),C2(count)] = Loewenstein_Seung_v1(p1,p2);
    end
end


 fI1 = I1./[I1+I2];
 fC1 = C1./[C1+C2];
    
 figure
 scatter(fI1,fC1)
 
 hold on
 
%  %% plotting summed choices
%  summed_choices = 0;
%  summed_1_choices = 0;
%  summed_2_choices = 0;
%  for i = 1: length(C_order)
%      
%      summed_choices(i+1) = summed_choices(i) + 1;
%      if C_order(i) == 1
%         summed_1_choices(length(summed_1_choices)+1) = summed_1_choices(length(summed_1_choices)) + 1;
%         summed_2_choices(length(summed_2_choices)+1) = summed_2_choices(length(summed_2_choices)); 
%      else
%         summed_2_choices(length(summed_2_choices)+1) = summed_2_choices(length(summed_2_choices)) + 1; 
%         summed_1_choices(length(summed_1_choices)+1) = summed_1_choices(length(summed_1_choices)); 
%      end
%  end
%  
%  plot(summed_1_choices,summed_2_choices,'LineWidth',4)
%  
%  ave_reward_slope = (I1(300)/I2(300));
%  line1_x1 = 0;
% line1_x2 = summed_2_choices(end);
% line1_x = line1_x1:line1_x2;
% line1_y = (([1:length(line1_x)])/ave_reward_slope);
% 
% hold on
% plot(line1_x,line1_y,'LineWidth',4,'Color','k')
